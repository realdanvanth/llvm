#include "string.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Plugins/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/ADT/StringMapEntry.h>
#include <llvm/IR/Constants.h>
#include <llvm/IR/InstrTypes.h>
#include <string>
using namespace llvm;
namespace {
struct LVN : PassInfoMixin<LVN> {
  std::string getInfo(Value *inst) {
    if (auto val = dyn_cast<ConstantInt>(inst)) {
      return toString(val->getValue(), 10, true);
    }
    std::string s;
    raw_string_ostream rso(s);
    inst->printAsOperand(rso, false);
    return rso.str();
  }
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
    for (auto BB = F.begin(), eBB = F.end(); BB != eBB; BB++) {
      std::unordered_map<std::string, Value *> map;
      for (auto inst = BB->begin(), eInst = BB->end(); inst != eInst; inst++) {
        std::string hash = "";
        if (auto op = dyn_cast<BinaryOperator>(inst)) {
          hash += getInfo(op->getOperand(0));
          if (op->getOpcode() == Instruction::Add) {
            hash += "+";
          } else if (op->getOpcode() == Instruction::Sub) {
            hash += "-";
          } else if (op->getOpcode() == Instruction::Mul) {
            hash += "*";
          } else if (op->getOpcode() == Instruction::SDiv) {
            hash += "/";
          } else if (op->getOpcode() == Instruction::SRem) {
            hash += "%";
          }
          hash += getInfo(op->getOperand(1));
          // errs() << hash << "\n";
          auto expr = map.find(hash);
          if (expr != map.end()) {
            // insert that element so we dont do the computation again
            auto next = std::next(inst);
            errs() << "Replaced........\n\n";
            inst->replaceAllUsesWith(expr->second);
            inst->eraseFromParent();

          } else {
            errs() << hash << "   new one vro\n";
            map[hash] = &*inst;
          }
        }
      }
    }
    return PreservedAnalyses::all();
  }
};
} // namespace
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
