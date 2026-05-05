#!/bin/bash

if [ -z "$1" ]; then
  echo "usage: $0 <source-dir>"
  exit 1
fi

BUILD_DIR="$1/build"

# Create build dir only if it doesn't exist
mkdir -p "$BUILD_DIR"

cd "$BUILD_DIR" || exit

# Run cmake only if not already configured
if [ ! -f "CMakeCache.txt" ]; then
  cmake -DLT_LLVM_INSTALL_DIR="$LLVM_DIR" ..
fi

make
