.PHONY: deb clean

deb:
	mkdir -p dist
	dpkg-deb --build nodeinfo dist/nodeinfo_v1.2.deb

clean:
	rm -rf dist