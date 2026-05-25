#include "llvm/Passes/PassBuilder.h"
#include "llvm/Plugins/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/IR/Instruction.h>
#include <llvm/IR/Instructions.h>
#include <unordered_map>
using namespace llvm;
namespace {
void eliminateRedLoads(Function *F) {
  errs() << "................................................................"
            "..................\n";
  errs() << "Running Redundant Load Elimination on : " << F->getName() << "\n";
  for (auto BB = F->begin(), eBB = F->end(); BB != eBB; BB++) {
    std::unordered_map<Value *, Value *> map;
    for (auto inst = BB->begin(), einst = BB->end(); inst != einst;) {
      bool del = false;
      if (auto op = dyn_cast<LoadInst>(inst)) {
        auto item = map.find(op->getPointerOperand());
        if (item != map.end()) {
          del = true;
          errs() << "Replaced : " << *inst << "| with : " << *item->second
                 << "\n";
          op->replaceAllUsesWith(item->second);
        } else {
          map[op->getPointerOperand()] = op;
        }
      } else if (auto op = dyn_cast<StoreInst>(inst)) {
        auto item = map.find(op->getPointerOperand());
        if (item != map.end()) {
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
}
void detectUseAfterFree(BasicBlock *BB) {
  std::set<Value *> objects;
  std::unordered_map<Value *, Value *> ptrset;
  for (auto inst = BB->begin(), einst = BB->end(); inst != einst; ++inst) {
    if (auto call = dyn_cast<CallInst>(inst)) {
      if (call->getCalledFunction()->getName() ==
          "malloc") // we assume if a malloc is found then the next instruction
                    // is probably the store instruction
      {
        inst = std::next(inst);
        auto store = dyn_cast<StoreInst>(inst);
        if (store) {
          objects.insert(store->getPointerOperand());
          // errs()<<"stored :
          // "<<store->getPointerOperand()->getNameOrAsOperand()<<"\n";
          ptrset.insert({store->getOperand(0), store->getOperand(1)});
        }
      } else if (call->getCalledFunction()->getName() == "free") {
        auto elem = ptrset.find(call->getOperand(0));
        if (elem != ptrset.end()) {
          auto obj = objects.find(elem->second);
          if (obj == objects.end()) {
            errs() << "DOUBLE FREE double free detected\n";
          } else {
            // errs()<<"object erased \n";
            objects.erase(obj);
          }
        }
      }
    }
    if (auto getelem = dyn_cast<GetElementPtrInst>(inst)) {
      // errs()<<getelem->getOperand(0)->getNameOrAsOperand()<<"\n";
      auto elem = objects.find(getelem->getOperand(0));
      if (elem == objects.end()) {
        errs() << "USE AFTER FREE after free detected\n";
      }
    }
    if (auto load = dyn_cast<LoadInst>(inst)) {
      auto cond = objects.find(load->getPointerOperand());
      // errs()<<"this load is not a pointer :
      // "<<load->getOperand(0)->getNameOrAsOperand()<<"\n";
      if (cond != objects.end()) { // if a pointer object is loaded
                                   // errs()<<"inserted load pointing to :
        // "<<load->getOperand(0)->getNameOrAsOperand()<<"\n";
        ptrset.insert({load, load->getOperand(0)});
        // errs()<<"load: "<<load->getOperand(0)<<"
        // "<<load->getOperand(1)<<"\n";
      }
      auto ptr = ptrset.find(load->getPointerOperand());
      if (ptr != ptrset.end()) {
        auto obj = objects.find(ptr->second);
        if (obj == objects.end()) {
          errs() << "LOAD AFTER FREE detected\n";
        }
      } else {
        // errs()<<"this load is not a pointer :
        // "<<load->getOperand(0)->getNameOrAsOperand()<<"\n";
      }
    } else if (auto store = dyn_cast<StoreInst>(inst)) {
      auto ptr = ptrset.find(store->getPointerOperand());
      if (ptr != ptrset.end()) {
        auto obj = objects.find(ptr->second);
        if (obj == objects.end()) {
          errs() << "STORE AFTER FREE detected\n";
        }
      }
    }
  }
}
} // namespace
struct HelloWorld : PassInfoMixin<HelloWorld> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    eliminateRedLoads(&F);
    for (auto BB = F.begin(), eBB = F.end(); BB != eBB; BB++) {
      detectUseAfterFree(&*BB);
    }
    return PreservedAnalyses::all();
  }
};
// namespace
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
