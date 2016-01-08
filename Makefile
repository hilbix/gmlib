#

TARGS=libcoffee.js libgm.js
SUBS=

%.js: %.coffee
	@{ sed -ne "/^#\/\//s|{{{VERSION}}}|$$(git rev-parse --short HEAD || echo 0).$$(date +%Y%m%d.%H%M%S -r '$<')|g" -e "/^#\/\//s|{{{FILENAME}}}|$<|g" -e 's|^#//|//|p' '$<'; bash -xc "coffee --no-header -pc '$<'"; } > "$$(dirname '$<')/$$(basename '$<' .coffee).js"

.PHONY: all
all::	$(DIRS) $(TARGS)

.PHONY: clean
clean::
	rm -f $(TARGS)

clean all::
	for a in $(SUBS); do $(MAKE) -C "$$a" $@; done

.PHONY: st
st:
	git status --porcelain

$(SUBS):
	git submodule update --init

$(TARGS):	Makefile

