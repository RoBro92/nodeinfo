PYFILE := nodeinfo/usr/local/bin/nodeinfo
VERSION := $(shell grep '^VERSION' $(PYFILE) | cut -d '"' -f2)
DEBNAME := nodeinfo_v$(VERSION).deb
DISTDIR := dist
BUILDDIR := build

SED_INPLACE := sed -i
ifeq ($(shell uname), Darwin)
	SED_INPLACE := sed -i ''
endif

.PHONY: dev
.PHONY: deb release

deb:
	@echo "🔧 Building .deb for version $(VERSION)..."
	@rm -rf $(BUILDDIR)
	@mkdir -p $(BUILDDIR)/DEBIAN
	@mkdir -p $(BUILDDIR)/usr/local/bin
	@cp nodeinfo/DEBIAN/control $(BUILDDIR)/DEBIAN/control
	@cp nodeinfo/DEBIAN/postinst $(BUILDDIR)/DEBIAN/postinst
	@chmod 755 $(BUILDDIR)/DEBIAN/postinst
	@cp nodeinfo/usr/local/bin/nodeinfo $(BUILDDIR)/usr/local/bin/nodeinfo
	@chmod +x $(BUILDDIR)/usr/local/bin/nodeinfo
	@sed "s/^Version: .*/Version: $(VERSION)/" $(BUILDDIR)/DEBIAN/control > $(BUILDDIR)/DEBIAN/control.tmp && mv $(BUILDDIR)/DEBIAN/control.tmp $(BUILDDIR)/DEBIAN/control
	@$(SED_INPLACE) "s|nodeinfo_v[0-9.]*.deb|nodeinfo_v$(VERSION).deb|g" README.md || true
	@$(SED_INPLACE) "s|vX.X.X|v$(VERSION)|g" README.md || true
	@mkdir -p $(DISTDIR)
	dpkg-deb --build --root-owner-group $(BUILDDIR) $(DISTDIR)/$(DEBNAME)

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

DEV_PYFILE := dev/usr/local/bin/nodeinfodev
DEV_VERSION := $(shell grep '^VERSION' $(DEV_PYFILE) | cut -d '"' -f2)-Dev
DEV_DEBNAME := nodeinfo_v$(DEV_VERSION).deb
DEV_BUILDDIR := dev_build
DEV_DISTDIR := dist

dev:
	@echo "🔧 Building DEV .deb for version $(DEV_VERSION)..."
	@rm -rf $(DEV_BUILDDIR)
	@mkdir -p $(DEV_BUILDDIR)/DEBIAN
	@mkdir -p $(DEV_BUILDDIR)/usr/local/bin
	@cp dev/DEBIAN/control $(DEV_BUILDDIR)/DEBIAN/control
	@cp dev/DEBIAN/postinst $(DEV_BUILDDIR)/DEBIAN/postinst
	@chmod 755 $(DEV_BUILDDIR)/DEBIAN/postinst
	@cp dev/usr/local/bin/nodeinfodev $(DEV_BUILDDIR)/usr/local/bin/nodeinfo
	@chmod +x $(DEV_BUILDDIR)/usr/local/bin/nodeinfo
	@mkdir -p $(DEV_DISTDIR)
	@dpkg-deb --build --root-owner-group $(DEV_BUILDDIR) $(DEV_DISTDIR)/$(DEV_DEBNAME)
	@echo "✅ DEV build created at $(DEV_DISTDIR)/$(DEV_DEBNAME)"