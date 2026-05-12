#include "llvm/Passes/PassBuilder.h"
#include "llvm/Plugins/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Instructions.h>
#include <llvm/Support/Casting.h>
#include <unordered_map>
using namespace llvm;
namespace {
struct HelloWorld : PassInfoMixin<HelloWorld> {
  void eliminateDeadLoads(BasicBlock *BB) {
    std::unordered_map<Value *, Value *> map;
    for (auto inst = BB->begin(), einst = BB->end(); inst != einst;) {
      bool del = false;
      if (auto op = dyn_cast<LoadInst>(inst)) {
        // errs() << " load address : " << op->getPointerOperand() << "\n";
        auto item = map.find(op->getPointerOperand());
        if (item != map.end()) { // this is an redundant load
          del = true;
          errs() << "erased : " << *inst << " replaced with : " << *item->second
                 << "\n";
          op->replaceAllUsesWith(item->second);
        } else { // now this is a new load we add it to the map
          map[op->getPointerOperand()] = op;
        }
      } else if (auto op = dyn_cast<StoreInst>(inst)) {
        // errs() << "store inst gng : "<<op->getPointerOperand()<<"\n";
        auto item = map.find(op->getPointerOperand());
        if (item != map.end()) // now if a store is found , the value is changed
                               // and cant be reused
        {
          map.erase(item);
        }
      }
      if (del) {
        auto next = std::next(inst);
        inst->eraseFromParent();
        inst = next;
      } else {
        inst++;
      }
    }
  }
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    for (auto BB = F.begin(), eBB = F.end(); BB != eBB; BB++) {
      eliminateDeadLoads(&*BB);
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
