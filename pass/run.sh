#!/usr/bin/env bash
set -euo pipefail

# ─── Config ───────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
PASS_LIB="$SCRIPT_DIR/DeadCode.so"
TEST_C="$SCRIPT_DIR/test.c"
TEST_LL="$SCRIPT_DIR/test.ll"

# ─── Clean ────────────────────────────────────────────────────────────────────
echo "==> Cleaning previous build..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# ─── Build ────────────────────────────────────────────────────────────────────
echo "==> Configuring with CMake..."
cmake -S "$SCRIPT_DIR" -B "$BUILD_DIR" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

echo "==> Building HelloPass.so..."
cmake --build "$BUILD_DIR" -- -j"$(nproc)"

echo ""
echo "==> Build successful: $PASS_LIB"

# ─── Compile test.c to LLVM IR ────────────────────────────────────────────────
echo ""
echo "==> Compiling test.c to LLVM IR..."
clang -S -emit-llvm -O0 "$TEST_C" -o "$TEST_LL"

# ─── Run the pass ─────────────────────────────────────────────────────────────
echo ""
echo "==> Running HelloPass via opt..."
echo "-------------------------------------------"
opt -load-pass-plugin "$PASS_LIB" \
    -passes="dead-code" \
    -disable-output \
    "$TEST_LL"
opt --load-pass-plugin ./DeadCode.so -passes=dead-code\
    test.ll -S -o output.ll
