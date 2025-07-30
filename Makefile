PYFILE := nodeinfo/usr/local/bin/nodeinfo
VERSION := $(shell grep '^VERSION' $(PYFILE) | cut -d '"' -f2)
DEBNAME := nodeinfo_v$(VERSION).deb
DISTDIR := dist

.PHONY: deb release

deb:
	@echo "🔧 Building .deb for version $(VERSION)..."
	@sed "s/^Version: .*/Version: $(VERSION)/" nodeinfo/debian/control > nodeinfo/debian/control.tmp && mv nodeinfo/debian/control.tmp nodeinfo/debian/control
	mkdir -p $(DISTDIR)
	dpkg-deb --build nodeinfo $(DISTDIR)/$(DEBNAME)

release: deb
	@echo "📦 Committing and tagging version v$(VERSION)..."
	git add .
	git commit -m "Release v$(VERSION)" || true
	git tag -f v$(VERSION)
	git push origin main --tags

	@echo "🚀 Creating GitHub release and uploading .deb..."
	gh release delete v$(VERSION) -y || true
	gh release create v$(VERSION) $(DISTDIR)/$(DEBNAME) --title "v$(VERSION)" --notes "Automatic release for v$(VERSION)"