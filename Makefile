# additional Busted options to pass
BUSTED:=

# SCM rockspec label; scm/cvs/dev
SCM_LABEL:=$(shell cat *.rockspec | grep "local package_version" | sed "s/ //g" | sed "s/localpackage_version=//g" | sed "s/\"//g")
ROCK_REV:=$(shell cat *.rockspec | grep "local rockspec_revision" | sed "s/ //g" | sed "s/localrockspec_revision=//g" | sed "s/\"//g")
ROCK_NAME:=$(shell cat *.rockspec | grep "local package_name" | sed "s/ //g" | sed "s/localpackage_name=//g" | sed "s/\"//g")
ROCKSPEC:=${ROCK_NAME}-${SCM_LABEL}-${ROCK_REV}.rockspec
TAB=$(shell printf "\t")

# dev/test dependencies; versions can be pinned. Example: "ldoc 1.4.6"
DEV_ROCKS = "busted" "luacheck" "ldoc" "luacov"

LRCMD=luarocks --tree=user

target_not_specified: help
	@exit 1


help:
	@echo "Available make targets for ${ROCK_NAME}:"
	@echo ""
	@echo "install:     uses LuaRocks to install ${ROCK_NAME}"
	@echo "uninstall:   uninstalls ALL versions of ${ROCK_NAME} (using LuaRocks with"
	@echo "             the '--force' flag)"
	@echo "clean:       removes LuaCov output, packed rocks, and restores docs to the"
	@echo "             last commited version"
	@echo "test:        runs the test suite using Busted"
	@echo "testinst:    installs ${ROCK_NAME} and runs tests using the installed version"
	@echo "             (this modifies the local installation, but also tests the"
	@echo "             .rockspec file). This is best used when testing in CI."
	@echo "lint:        will validate all 'rockspec' files using LuaRocks, and the"
	@echo "             '.lua' files with LuaCheck"
	@echo "doc/docs:    regenerates the documentation using LDoc"
	@echo "deps:        installs the module dependencies"
	@echo "dev:         installs the development dependencies (Busted, LuaCheck, etc.)"
	@echo "help:        displays this list of make targets"
	@echo ""


install: luarocks
	$(LRCMD) make


uninstall: luarocks
	if ($(LRCMD) list --porcelain ${ROCK_NAME} | grep "^${ROCK_NAME}${TAB}" | grep -q "installed") ; then \
	  $(LRCMD) remove ${ROCK_NAME} --force; \
	fi;


# note: restore the docs to the last committed version
clean: clean_luacov clean_luarocks clean_doc
	git checkout docs
	$(RM) -r spec/JSON-Schema-Test-Suite
	mkdir spec/JSON-Schema-Test-Suite


.PHONY: test
test: clean_luacov dev
	busted ${BUSTED}


# test while having the code installed; also tests the rockspec, but
# this will modify the local luarocks installation/tree!!
.PHONY: testinst
testinst: clean_luacov dev uninstall install
	busted --lpath="" --cpath="" ${BUSTED}


.PHONY: lint
lint: dev
	@echo "luarocks lint ..."
	@for spec in $(shell find . -type f -name "*.rockspec") ; do \
	  ($(LRCMD) lint $$spec && echo "$$spec [OK]") || (echo "$$spec [NOK]"; exit 1); \
	done
	luacheck .


.PHONY: doc
doc: clean_doc dev
	mkdir -p ./docs
	ldoc . --date=""


.PHONY: docs
docs: doc


.PHONY: deps
deps: luarocks
	$(LRCMD) install $(ROCKSPEC) --deps-only


# submodule with the JSONscehma test suite
spec/JSON-Schema-Test-Suite/.git:
	git submodule update --init --recursive; \


.PHONY: dev
dev: luarocks deps spec/JSON-Schema-Test-Suite/.git
	@for rock in $(DEV_ROCKS) ; do \
	  ($(LRCMD) list --porcelain $$rock | grep -q "installed") || ($(LRCMD) install $$rock || exit 1); \
	done;


.PHONY: clean_doc
clean_doc:
	$(RM) -r docs


.PHONY: clean_luarocks
clean_luarocks:
	$(RM) *.rock


.PHONY: clean_luacov
clean_luacov:
	$(RM) luacov.report.out luacov.stats.out


.PHONY: luarocks
luarocks:
	@which luarocks > /dev/null || (echo "LuaRocks was not found. Please install and/or make available in the path." && exit 1)
