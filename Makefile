# Makefile for building and releasing nodeinfo

PYFILE := nodeinfo/usr/local/bin/nodeinfo
VERSION := $(shell grep '^VERSION' $(PYFILE) | cut -d '"' -f2)
DEBNAME := nodeinfo_v$(VERSION).deb
DISTDIR := dist

.PHONY: deb release

deb:
	@echo "🔧 Building .deb for version $(VERSION)..."
	# Update control file with correct version
	@sed "s/^Version: .*/Version: $(VERSION)/" nodeinfo/debian/control > nodeinfo/debian/control.tmp && mv nodeinfo/debian/control.tmp nodeinfo/debian/control
	# Update README.md install instructions
	@sed -i '' "s|nodeinfo_v[0-9.]*.deb|nodeinfo_v$(VERSION).deb|g" README.md
	@sed -i '' "s|vX.X.X|v$(VERSION)|g" README.md
	# Create dist and build .deb
	@mkdir -p $(DISTDIR)
	dpkg-deb --build nodeinfo $(DISTDIR)/$(DEBNAME)

release: deb
	@echo "📦 Committing and tagging version v$(VERSION)..."
	git add .
	git commit -m "Release v$(VERSION)" || true
	git tag -f v$(VERSION)
	git push origin main --tags

	@echo "🚀 Creating GitHub release and uploading .deb..."
	gh release delete v$(VERSION) -y || true
	gh release create v$(VERSION) $(DISTDIR)/$(DEBNAME) --title "v$(VERSION)" --notes "$(NOTES)"