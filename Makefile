.PHONY: help
.PHONY: host
.PHONY: rg35xx

CMAKEPROJECT := RG35XX_Game
OUTPROJECT := RaylibTest
HOSTTYPE := $(shell echo $${OSTYPE:-host})

all: help

host:
	@echo "Building for host ($(HOSTTYPE))..."
	mkdir -p build/$(HOSTTYPE)
	cmake \
		-S . \
		-B build/$(HOSTTYPE) \
		-DCMAKE_BUILD_TYPE=Release \
		-G "Unix Makefiles"
	cd build/$(HOSTTYPE) && make -j$(nproc)
	rm -rf dist/$(HOSTTYPE)/* || true
	mkdir -p dist/$(HOSTTYPE) || true
	cp -r build/$(HOSTTYPE)/assets/ dist/$(HOSTTYPE)/assets
	rm -f dist/$(HOSTTYPE)/assets/README.md || true
	cp build/$(HOSTTYPE)/$(CMAKEPROJECT) dist/$(HOSTTYPE)/$(OUTPROJECT)
	$(MAKE) host-run

ifneq (, $(filter $(RUN), true 1))
host-run:
	chmod +x dist/host/$(OUTPROJECT)
	./dist/host/$(OUTPROJECT)
else
host-run:
	@echo "Skipping host run. Set RUN=true to enable."
endif
	
rg35xx:
	@echo "Building for RG35XX..."
	mkdir -p build/rg35xx
	docker build -t rg35xx-builder .
	docker run -v .:/workspace:rw \
		rg35xx-builder \
		/bin/sh -c 'cmake \
				-S . \
				-B build/rg35xx \
				-DCMAKE_BUILD_TYPE=Release \
				-DCMAKE_TOOLCHAIN_FILE=rg35xx-toolchain.cmake \
				-DBUILD_FOR_RG35XX=ON \
				-G "Unix Makefiles" && \
			cd build/rg35xx && \
			make clean && \
			make -j$$(nproc)'
	(rm -r dist/rg35xx || true)
	mkdir -p dist/rg35xx/.$(OUTPROJECT)
	cp -r build/rg35xx/rg35xx/* dist/rg35xx/.$(OUTPROJECT)
	mv dist/rg35xx/.$(OUTPROJECT)/$(CMAKEPROJECT) dist/rg35xx/.$(OUTPROJECT)/$(OUTPROJECT)
	cp assets-rg35xx/entrypoint.sh dist/rg35xx/$(OUTPROJECT).sh
	cp assets-rg35xx/keymap.gptk dist/rg35xx/.$(OUTPROJECT)/$(OUTPROJECT).gptk
	(rm dist/rg35xx/.$(OUTPROJECT)/assets/README.md || true)

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  host        Build the project for the host system (macOS/Linux)"
	@echo "  rg35xx      Build the project for the RG35XX device"
	@echo "  help        Show this help message"
	@echo ""
