#include "llvm/Passes/PassBuilder.h"
#include "llvm/Plugins/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/ADT/DenseMap.h>
#include <llvm/ADT/StringMapEntry.h>
#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/InstrTypes.h>
#include <llvm/IR/Instructions.h>
#include <llvm/Support/Casting.h>
#include <string>
using namespace llvm;
namespace {
struct LVN : PassInfoMixin<LVN> {
  int getValue(Value *operand,
               std::unordered_map<std::basic_string<char>, int> constantmap) {
    if (auto val = dyn_cast<ConstantInt>(operand)) {
      int n = val->getSExtValue();
      return n;
    }
    auto val = constantmap.find(operand->getNameOrAsOperand());
    if (val != constantmap.end()) {
      return val->second;
    }

    return 0;
  }
  void eliminateRedLoads(
      BasicBlock *BB) { // this is required for common subexpression elimination
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
  void constantPropogation(BasicBlock *BB) {
    std::unordered_map<std::basic_string<char>, int> constantmap;
    for (auto inst = BB->begin(), eInst = BB->end(); inst != eInst;) {
      // eliminateRedLoads(&*inst);
      bool del = false;
      if (auto op = dyn_cast<BinaryOperator>(inst)) {
        int l = getValue(op->getOperand(0), constantmap);
        int r = getValue(op->getOperand(1), constantmap);
        if (l != 0 &&
            r != 0) { // both are constants so we can do constant propogation
          int result = 0;
          if (op->getOpcode() == Instruction::Add) {
            result = l + r;
          } else if (op->getOpcode() == Instruction::Sub) {
            result = l - r;
          } else if (op->getOpcode() == Instruction::Mul) {
            result = l * r;
          } else if (op->getOpcode() == Instruction::SDiv) {
            result = l / r;
          } else if (op->getOpcode() == Instruction::SRem) {
            result = l % r;
          }
          auto value = ConstantInt::get(op->getType(), result);
          errs() << "constant propogation is happening \n";
          op->replaceAllUsesWith(value);
          del = true;
        }
      }
      if (del) {
        auto next = std::next(inst);
        // errs() << "we replaced lol \n";
        inst->eraseFromParent();
        inst = next;
      } else {
        inst++;
      }
    }
  }
  // TO DO : eliminate redundant stores , like when two variables are the same
  // thing , this must be implemented only after common
  //  sub expression elimination

  // TO DO : after constant prop/ LVN , we need to check if the loads and stores
  // are actually used anywhere else this must be done after everything is
  // finished
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    errs() << "running constant propogtion pass\n";
    for (auto BB = F.begin(), eBB = F.end(); BB != eBB; BB++) {
      eliminateRedLoads(&*BB);
      std::unordered_map<std::basic_string<char>, int> constantmap;
      llvm::DenseMap<std::tuple<unsigned, Value *, Value *>, Value *> map;
      bool del = false;
      for (auto inst = BB->begin(), eInst = BB->end(); inst != eInst;) {
        // eliminateRedLoads(&*inst);
        bool del = false;
        if (auto op = dyn_cast<BinaryOperator>(inst)) {
          int l = getValue(op->getOperand(0), constantmap);
          int r = getValue(op->getOperand(1), constantmap);
          if (l != 0 && r != 0) { // both are constants so we can do constant
                                  // constantPropogation
            constantPropogation(&*BB);
          } else { // common subexpression elimination
            auto hashl = op->getOperand(0);
            auto hashr = op->getOperand(1);
            if (hashl > hashr && (op->getOpcode() == Instruction::Add ||
                                  op->getOpcode() == Instruction::Mul)) {
              std::swap(hashl, hashr);
            }
            auto expr =
                map.find(std::make_tuple(op->getOpcode(), hashl, hashr));
            if (expr != map.end()) {
              errs() << "expression found tp be replaced...........\n";
              errs() << "erased : " << *inst
                     << " replaced with : " << *expr->second << "\n";
              // op->replaceAllUsesWith(item->second);
              op->replaceAllUsesWith(expr->second);
              del = true;
            } else {
              errs() << "inserted expression "
                     << op->getOperand(0)->getNameOrAsOperand() << "  "
                     << op->getOperand(1)->getNameOrAsOperand() << "\n";
              map[std::make_tuple(op->getOpcode(), hashl, hashr)] = &*inst;
            }
          }
        } else if (auto op = dyn_cast<StoreInst>(inst)) {
          if (auto val = dyn_cast<ConstantInt>(op->getOperand(0))) {
            constantmap.insert(
                {op->getOperand(1)->getNameOrAsOperand(), val->getSExtValue()});
            errs() << "inserted\n";
          } else { // have to check if the value is changed so we cant do things
          }
        } else if (auto op = dyn_cast<LoadInst>(inst)) {
          // errs() << op->getNameOrAsOperand() << " : load address"
          //      << "\n"; // this is the load address
          // errs() << op->getOperand(0)->getNameOrAsOperand() << "the pointer
          // \n";
          //  if pointer address is there in the constantmap then we good....
          auto item = constantmap.find(op->getOperand(0)->getNameOrAsOperand());
          if (item != constantmap.end()) {
            // errs() << "hello\n";
            constantmap.insert({op->getNameOrAsOperand(), item->second});
            // errs() << "hellolil voooo\n";
          }
        }
        if (del) {
          auto next = std::next(inst);
          // errs() << "we replaced lol \n";
          inst->eraseFromParent();
          inst = next;
        } else {
          inst++;
        }
      }
    }
    return PreservedAnalyses::all();
  }
};
} // namespace
// namespace
PassPluginLibraryInfo getLVNPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "LVN", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "hello-world") {
                    FPM.addPass(LVN());
                    return true;
                  }
                  return false;
                });
            PB.registerPipelineStartEPCallback([](ModulePassManager &MPM,
                                                  OptimizationLevel Level) {
              FunctionPassManager FPM;
              FPM.addPass(LVN());
              MPM.addPass(createModuleToFunctionPassAdaptor(std::move(FPM)));
            });
          }};
}
extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getLVNPluginInfo();
}
