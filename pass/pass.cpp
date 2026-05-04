#include "llvm/IR/Function.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Plugins/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/IR/Module.h>
using namespace llvm;
using namespace std;
struct DeadCode : public PassInfoMixin<DeadCode> {
  vector<StringRef> livecode;
  void addlivecode(StringRef func) {
    for (auto i = 0; i < livecode.size(); i++) {
      if (livecode[i] == func)
        return;
    }
    livecode.push_back(func);
  }
  bool check(vector<StringRef> functions, StringRef func) {
    for (auto i = 0; i < functions.size(); i++) {
      if (functions[i] == func) {
        // errs()<<func<<" found\n";
        return false;
      }
    }
    // errs()<<"true\n";
    return true;
  }
  void callgraph(Function *func, vector<StringRef> functions,
                 string indentation) {
    functions.push_back(func->getName());
    for (auto BB = func->begin(), eBB = func->end(); BB != eBB; BB++) {
      // errs()<<"basic block:\n";
      for (auto Inst = BB->begin(), eInst = BB->end(); Inst != eInst; Inst++) {
        // errs()<<*Inst<<"\n";
        if (auto call = dyn_cast<CallInst>(Inst)) {
          auto calledf = call->getCalledFunction();
          // errs()<<calledf->getName()<<"\n";
          if (check(functions, calledf->getName())) {
            errs() << indentation << func->getName() << "-->"
                   << calledf->getName() << "\n";
            vector<StringRef> cycle = functions;
            cycle.push_back(calledf->getName());
            addlivecode(calledf->getName());
            callgraph(calledf, cycle, indentation + "   ");

          } else {
            errs() << "\n";
          }
        }
      }
    }
  }

  PreservedAnalyses run(Module &M, ModuleAnalysisManager &) {
    Function *F = M.getFunction("main");
    vector<StringRef> hello;
    callgraph(F, hello, "");
    addlivecode("main");
    auto module = F->getParent();
    for (auto M = module->begin(), Me = module->end(); M != Me;) {
      if (check(livecode, M->getName())) {
        errs() << "dead code found\n" << M->getName();
        auto next = std::next(M);
        M->eraseFromParent();
        M = next;
      } else {
        M++;
      }
    }
    return PreservedAnalyses::none();
  }

  static bool isRequired() { return true; }
};

llvm::PassPluginLibraryInfo getHelloPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "DeadCode", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, ModulePassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "dead-code") {
                    FPM.addPass(DeadCode());
                    return true;
                  }
                  return false;
                });
          }};
}
extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getHelloPassPluginInfo();
}
