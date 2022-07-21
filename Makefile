.RECIPEPREFIX = >

out/%: src/%.scm
> @ mkdir -p $$(dirname $@)
> @ (printf '#!/bin/guile --no-auto-compile\n!#\n\n'; cat $<) > $@
> @ chmod +x $@

build: $(shell find src -type f | sed 's|^src/|out/|' | sed 's|.scm$$||')

clean:
> @ rm -rf out

install: build
> @ mkdir -p $(DESTDIR)$(PREFIX)/bin
> @ cp -r out/. $(DESTDIR)$(PREFIX)/bin

uninstall:
> @ rm -f $(DESTDIR)$(PREFIX)/bin/sxml2xml
> @ rm -f $(DESTDIR)$(PREFIX)/bin/xml2sxml

reinstall: uninstall install
