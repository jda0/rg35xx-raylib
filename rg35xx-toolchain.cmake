# Toolchain file for RG35XX Plus (ARM Cortex-A53 - ARM64/AArch64)
# Usage: cmake -DCMAKE_TOOLCHAIN_FILE=rg35xx-toolchain.cmake -DBUILD_FOR_RG35XX=ON ..

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(TOOLCHAIN_ID "aarch64-linux-gnu")
set(CMAKE_C_COMPILER ${TOOLCHAIN_ID}-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_ID}-g++)
set(CMAKE_AR ${TOOLCHAIN_ID}-ar)
set(CMAKE_RANLIB ${TOOLCHAIN_ID}-ranlib)

# Target specific flags for Cortex-A53 (ARM64)
set(CMAKE_C_FLAGS "-march=armv8-a -mtune=cortex-a53 -O2 -ffunction-sections -fdata-sections")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections")

# Where to look for target environment
set(CMAKE_FIND_ROOT_PATH ${CMAKE_CURRENT_LIST_DIR}/rg35xx-sysroot)

# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)

# Search for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Specify the path where RG35XX libraries are located
# You'll need to copy SDL2, EGL, GLESv2 .so files from your RG35XX
set(RG35XX_LIBS_PATH "${CMAKE_CURRENT_LIST_DIR}/rg35xx-sysroot/usr/lib" CACHE PATH "Path to RG35XX libraries")
