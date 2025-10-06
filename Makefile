.PHONY: help
.PHONY: host
.PHONY: rg35xx

CMAKEPROJECT := RG35XX_Game
OUTPROJECT := RaylibTest

all: help

host:
	@echo "Building for host (macOS/Linux)..."
	mkdir -p build/host
	cmake \
		-S . \
		-B build/host \
		-DCMAKE_BUILD_TYPE=Release \
		-G "Unix Makefiles"
	cd build/host && make -j$(nproc)
	cp -r build/host/$(CMAKEPROJECT) out/host
	
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
			make -j$$(nproc) && \
			(rm -r /workspace/out/rg35xx || true) && \
			mkdir -p /workspace/out/rg35xx/.$(OUTPROJECT) && \
			cp -r /workspace/build/rg35xx/rg35xx/* \
			  /workspace/out/rg35xx/.$(OUTPROJECT) && \
			mv /workspace/out/rg35xx/.$(OUTPROJECT)/assets/entrypoint.sh \
				/workspace/out/rg35xx/$(OUTPROJECT).sh && \
			mv /workspace/out/rg35xx/.$(OUTPROJECT)/$(CMAKEPROJECT) \
				/workspace/out/rg35xx/.$(OUTPROJECT)/$(OUTPROJECT) && \
			mv /workspace/out/rg35xx/.$(OUTPROJECT)/assets/keymap.gptk \
				/workspace/out/rg35xx/.$(OUTPROJECT)/$(OUTPROJECT).gptk'

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  host        Build the project for the host system (macOS/Linux)"
	@echo "  rg35xx      Build the project for the RG35XX device"
	@echo "  help        Show this help message"
	@echo ""
