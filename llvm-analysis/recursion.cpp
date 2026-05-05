#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/IR/InstrTypes.h>
using namespace llvm;
int main(int argc, char **argv) {
  LLVMContext contex;
  SMDiagnostic error;
  auto module = parseIRFile(argv[1], error, contex);
  for (auto func = module->begin(), eFunc = module->end(); func != eFunc;
       func++) {
    for (auto BB = func->begin(), eBB = func->end(); BB != eBB; BB++) {
      for (auto Inst = BB->begin(), eInst = BB->end(); Inst != eInst; Inst++) {
        if (auto call = dyn_cast<CallInst>(Inst)) {
          if (call->getCalledFunction()->getName() == func->getName()) {
            errs() << "yo thats a recursion\n";
          }
        }
      }
    }
  }
}
