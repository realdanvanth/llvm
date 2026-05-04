cmake_minimum_required(VERSION 3.16)
project(DeadCode)

# Find LLVM (installed via pacman on Arch)
find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})

# Build the pass as a shared library
add_library(DeadCode SHARED pass.cpp)

# Don't link against LLVM libs — opt loads the plugin dynamically
# and the LLVM symbols are already available at runtime
target_compile_features(DeadCode PRIVATE cxx_std_17)

# Remove the default "lib" prefix so the file is HelloPass.so
set_target_properties(DeadCode PROPERTIES PREFIX "" LIBRARY_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}")
