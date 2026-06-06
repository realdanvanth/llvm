#include "llvm/Passes/PassBuilder.h"
#include "llvm/Plugins/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;
namespace {
struct HelloWorld : PassInfoMixin<HelloWorld> {
  void printSET(std::vector<Value *> SET) {
    for (auto i = 0; i < SET.size(); i++) {
      errs() << SET[i]->getNameOrAsOperand() << " ";
    }
    errs() << "\n";
  }
  void GenKill(BasicBlock &BB) {
    errs() << "----------------------------------\n";
    std::vector<Value *> KILL;
    std::vector<Value *> GEN;
    for (auto inst = BB.begin(), einst = BB.end(); inst != einst; inst++) {
      if (auto load = dyn_cast<LoadInst>(inst)) {
        if (std::find(KILL.begin(), KILL.end(), load->getPointerOperand()) ==
            KILL.end()) {
          GEN.push_back(load->getPointerOperand());
        }
      } else if (auto store = dyn_cast<StoreInst>(inst)) {
        KILL.push_back(store->getPointerOperand());
      }
    }
    errs() << "GEN: \n";
    printSET(GEN);
    errs() << "KILL: \n";
    printSET(KILL);
  }
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    for (auto BB = F.begin(), eBB = F.end(); BB != eBB; BB++) {
      GenKill(*BB);
    }
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
