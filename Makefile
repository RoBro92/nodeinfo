PYFILE := nodeinfo/usr/local/bin/nodeinfo
VERSION := $(shell grep '^VERSION' $(PYFILE) | cut -d '"' -f2)
DEBNAME := nodeinfo_v$(VERSION).deb
DISTDIR := dist

.PHONY: deb release

deb:
	@echo "🔧 Building .deb for version $(VERSION)..."
	@test -f nodeinfo/DEBIAN/control || { echo "❌ control file missing"; exit 1; }
	@mkdir -p nodeinfo/DEBIAN
	@sed "s/^Version: .*/Version: $(VERSION)/" nodeinfo/DEBIAN/control > nodeinfo/DEBIAN/control.tmp && mv nodeinfo/DEBIAN/control.tmp nodeinfo/DEBIAN/control
	@sed -i '' "s|nodeinfo_v[0-9.]*.deb|nodeinfo_v$(VERSION).deb|g" README.md || true
	@sed -i '' "s|vX.X.X|v$(VERSION)|g" README.md || true
	@mkdir -p $(DISTDIR)
	dpkg-deb --build nodeinfo $(DISTDIR)/$(DEBNAME)

release: deb
	@echo "📦 Preparing release v$(VERSION)..."
	@if git rev-parse "v$(VERSION)" >/dev/null 2>&1; then \
		echo "⚠️  Tag v$(VERSION) already exists. Skipping tag creation."; \
	else \
		git tag v$(VERSION); \
	fi
	git add .
	git commit -m "Release v$(VERSION)" || true
	git push origin main
	git push origin v$(VERSION)
	@echo "🚀 Creating GitHub release and uploading .deb..."
	@gh release delete v$(VERSION) -y || true
	gh release create v$(VERSION) $(DISTDIR)/$(DEBNAME) --title "v$(VERSION)" --notes "$(subst \n,\\n,$(NOTES))"