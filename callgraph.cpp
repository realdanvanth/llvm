#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"
#include <llvm/ADT/StringRef.h>
#include <vector>
using namespace llvm;
using namespace std;
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
int main(int argc, char **argv) {
  LLVMContext context;
  SMDiagnostic error;
  livecode.push_back("main");
  auto module = parseIRFile(argv[1], error, context);
  vector<StringRef> hello;
  callgraph(module->getFunction("main"), hello, "");
  for (auto f = module->begin(), e = module->end(); f != e; f++) {
    if (check(livecode, f->getName())) {
      errs() << "dead code found : \n" << f->getName() << "\n";
    }
  }
}
