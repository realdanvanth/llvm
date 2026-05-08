#include "llvm/Passes/PassBuilder.h"
#include "llvm/Plugins/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/ADT/StringMapEntry.h>
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
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    errs() << "running constant propogtion pass\n";
    for (auto BB = F.begin(), eBB = F.end(); BB != eBB; BB++) {
      std::unordered_map<std::basic_string<char>, int> constantmap;
      for (auto inst = BB->begin(), eInst = BB->end(); inst != eInst; inst++) {
        if (auto op = dyn_cast<BinaryOperator>(inst)) {
          int l = getValue(op->getOperand(0), constantmap);
          int r = getValue(op->getOperand(1), constantmap);
          if (l != 0 && r != 0) {
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
            op->replaceAllUsesWith(value);
            auto next = std::next(inst);
            errs() << "we replaced lol \n";
            inst->eraseFromParent();
            inst = next;
          }
        } else if (auto op = dyn_cast<StoreInst>(inst)) {
          if (auto val = dyn_cast<ConstantInt>(op->getOperand(0))) {
            constantmap.insert(
                {op->getOperand(1)->getNameOrAsOperand(), val->getSExtValue()});
            errs() << "inserted\n";
          }
        } else if (auto op = dyn_cast<LoadInst>(inst)) {
          errs() << op->getNameOrAsOperand() << " : load address"
                 << "\n"; // this is the load address
          errs() << op->getOperand(0)->getNameOrAsOperand() << "the pointer \n";
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
