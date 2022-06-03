#!/bin/bash

cmake -S . -B build-arm -DARCH=armhf -DBUILD_EXAMPLES=ON -DCMAKE_TOOLCHAIN_FILE=Toolchain-rpi.cmake -DUSE_PREBUILT_SDL_LIB=0N
