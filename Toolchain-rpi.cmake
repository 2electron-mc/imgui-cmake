# Define our host system
SET(CMAKE_SYSTEM_NAME Linux)

set(TOOLCHAIN_HOST "armv8-rpi3-linux-gnueabihf")
SET(RPI_ENV "/home/marcocorona/x-tools/${TOOLCHAIN_HOST}" CACHE PATH "Rpi environment")

set(SYSROOT_PATH "${RPI_ENV}/${TOOLCHAIN_HOST}/sysroot")

message(STATUS "Using sysroot path: ${SYSROOT_PATH}")

set(TOOLCHAIN_CC "${TOOLCHAIN_HOST}-gcc")
set(TOOLCHAIN_CXX "${TOOLCHAIN_HOST}-g++")
set(TOOLCHAIN_LD "${TOOLCHAIN_HOST}-ld")
set(TOOLCHAIN_AR "${TOOLCHAIN_HOST}-ar")
set(TOOLCHAIN_RANLIB "${TOOLCHAIN_HOST}-ranlib")
set(TOOLCHAIN_STRIP "${TOOLCHAIN_HOST}-strip")
set(TOOLCHAIN_NM "${TOOLCHAIN_HOST}-nm")

set(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_SYSROOT "${SYSROOT_PATH}")
set(RASPBERRY_VERSION 3 )

# Define name of the target system
set(CMAKE_SYSTEM_NAME "Linux")
if(RASPBERRY_VERSION VERSION_GREATER 1)
	set(CMAKE_SYSTEM_PROCESSOR "armv7")
else()
	set(CMAKE_SYSTEM_PROCESSOR "arm")
endif()


SET(CMAKE_SYSTEM_VERSION 1)# Define the cross compiler locations
SET(CMAKE_C_COMPILER   ${RPI_ENV}/bin/${TOOLCHAIN_CC})
SET(CMAKE_CXX_COMPILER ${RPI_ENV}/bin/${TOOLCHAIN_CXX})# Define the sysroot path for the RaspberryPi distribution in our tools folder
SET(CMAKE_FIND_ROOT_PATH ${RPI_ENV})# Use our definitions for compiler tool

# You can additionally check the linker paths if you add the flags ' -Xlinker --verbose'
# set(COMMON_FLAGS "-I${RPI_ENV}/${TOOLCHAIN_HOST}/include ")


if(RASPBERRY_VERSION VERSION_GREATER 2)
	set(CMAKE_C_FLAGS "-mcpu=cortex-a53 -mfpu=neon-vfpv4 -mfloat-abi=hard" CACHE STRING "Flags for Raspberry PI 3")
	set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "Flags for Raspberry PI 3")
elseif(RASPBERRY_VERSION VERSION_GREATER 1)
	set(CMAKE_C_FLAGS "-mcpu=cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard" CACHE STRING "Flags for Raspberry PI 2")
	set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "Flags for Raspberry PI 2")
else()
	set(CMAKE_C_FLAGS "-mcpu=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard " CACHE STRING "Flags for Raspberry PI 1 B+ Zero")
	set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "Flags for Raspberry PI 1 B+ Zero")
endif()

set(CMAKE_FIND_ROOT_PATH "${CMAKE_INSTALL_PREFIX};${CMAKE_PREFIX_PATH};${CMAKE_SYSROOT}")


# search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# for libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
