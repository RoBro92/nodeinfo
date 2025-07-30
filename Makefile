PYFILE := nodeinfo/usr/local/bin/nodeinfo
VERSION := $(shell grep '^VERSION' $(PYFILE) | cut -d '"' -f2)
DEBNAME := nodeinfo_v$(VERSION).deb
DISTDIR := dist
DATE := $(shell date +%Y-%m-%d)
SECTION ?= Added

.PHONY: deb release changelog

deb:
	@echo "🔧 Building .deb for version $(VERSION)..."
	@sed "s/^Version: .*/Version: $(VERSION)/" nodeinfo/debian/control > nodeinfo/debian/control.tmp && mv nodeinfo/debian/control.tmp nodeinfo/debian/control
	@sed -i '' "s|nodeinfo_v[0-9.]*.deb|nodeinfo_v$(VERSION).deb|g" README.md
	@sed -i '' "s|vX.X.X|v$(VERSION)|g" README.md
	@mkdir -p $(DISTDIR)
	dpkg-deb --build nodeinfo $(DISTDIR)/$(DEBNAME)

changelog:
	@echo "📝 Updating CHANGELOG.md..."
	@CHANGELOG=CHANGELOG.md; \
	TMP=CHANGELOG.tmp; \
	HEADER_LINE=$$(grep -n '^# Changelog' $$CHANGELOG | cut -d: -f1); \
	INSERT_LINE=$$((HEADER_LINE + 2)); \
	VERSION_LINE="## [$(VERSION)] - $(DATE)"; \
	SECTION_LINE="### $(SECTION)"; \
	FORMATTED_NOTES=$$(printf "%s" "$(NOTES)" | sed 's/^/- /; s/\\n/\\n- /g'); \
	awk -v insline="$$INSERT_LINE" -v vline="$$VERSION_LINE" -v sline="$$SECTION_LINE" -v notes="$$FORMATTED_NOTES" '\
		NR==insline { print vline "\n" sline "\n" notes "\n" } { print }' $$CHANGELOG > $$TMP && mv $$TMP $$CHANGELOG

release: deb changelog
	@echo "📦 Committing and tagging version v$(VERSION)..."
	git add .
	git commit -m "Release v$(VERSION)" || true
	git tag -f v$(VERSION)
	git push origin main --tags

	@echo "🚀 Creating GitHub release and uploading .deb..."
	gh release delete v$(VERSION) -y || true
	gh release create v$(VERSION) $(DISTDIR)/$(DEBNAME) --title "v$(VERSION)" --notes "$(subst \n,\\n,$(NOTES))"