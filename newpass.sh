echo "enter project name"
read name
mkdir $name

cat << 'HEREDOC' > $name/CMakeLists.txt
cmake_minimum_required(VERSION 3.13.4)
project(PROJECTNAME)
set(CMAKE_CXX_COMPILER /usr/bin/clang++)
set(CMAKE_C_COMPILER /usr/bin/clang)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# Uncomment these two lines if you want to pass the LLVM Path
# set(LT_LLVM_INSTALL_DIR "" CACHE PATH "LLVM installation directory")
# list(APPEND CMAKE_PREFIX_PATH "${LT_LLVM_INSTALL_DIR}/lib/cmake/llvm/")
find_package(LLVM REQUIRED CONFIG)
# Include directories specified by LLVM in the project's include path
include_directories(${LLVM_INCLUDE_DIRS})
# Include definitions specified by LLVM in the project's options
add_definitions(${LLVM_DEFINITIONS})
link_directories(${LLVM_LIBRARY_DIR})
# Use the same C++ standard as LLVM does
set(CMAKE_CXX_STANDARD 17 CACHE STRING "")
# LLVM is normally built without RTTI. Be consistent with that.
if(NOT LLVM_ENABLE_RTTI)
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti")
endif()
add_library(PROJECTNAME SHARED main.cpp)
# Link against LLVM libraries
target_link_libraries(PROJECTNAME ${llvm_libs})
set_target_properties(PROJECTNAME PROPERTIES
    OUTPUT_NAME "PROJECTNAME"
    PREFIX ""
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}
)
HEREDOC
sed -i "s/PROJECTNAME/$name/g" $name/CMakeLists.txt

cat << 'HEREDOC' > $name/main.cpp
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Plugins/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;
namespace {
void visitor(Function &F) {
  errs() << "Hello from: " << F.getName() << "\n";
  errs() << "  number of arguments: " << F.arg_size() << "\n";
}
struct HelloWorld : PassInfoMixin<HelloWorld> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    visitor(F);
    return PreservedAnalyses::all();
  }
};
} // namespace
PassPluginLibraryInfo getHelloWorldPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "HelloWorld", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "hello-world") {
                    FPM.addPass(HelloWorld());
                    return true;
                  }
                  return false;
                });
            PB.registerPipelineStartEPCallback([](ModulePassManager &MPM,
                                                  OptimizationLevel Level) {
              FunctionPassManager FPM;
              FPM.addPass(HelloWorld());
              MPM.addPass(createModuleToFunctionPassAdaptor(std::move(FPM)));
            });
          }};
}
extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getHelloWorldPluginInfo();
}
HEREDOC
