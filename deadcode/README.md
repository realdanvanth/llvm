# Dead Code Elimination

A module-level LLVM pass that removes functions never reachable from `main`
and basic blocks that can never execute after a `return`.

## Workflow

```text
Build call graph from main
          |
          V
Collect all reachable functions (livecode)
          |
          V
Erase functions not in livecode
```

---

## Dead Function Elimination

Any function never called (directly or transitively) from `main` is unreachable
and gets erased.

<table>
<tr>
<th width="50%">Before</th>
<th width="50%">After</th>
</tr>
<tr>
<td valign="top">
<pre style="font-size:11px;"><code>int used()   { return 1; }
int unused() { return 2; } // never called

int main() {
    return used();
}
</code></pre>
</td>
<td valign="top">
<pre style="font-size:11px;"><code>int used()   { return 1; }
; unused() erased — not in livecode

int main() {
    return used();
}
</code></pre>
</td>
</tr>
</table>

### code:
```cpp
void callgraph(
      Function *func,
      vector<StringRef> functions, // this must be called first before anything
      string indentation) {
    functions.push_back(func->getName());
    for (auto BB = func->begin(), eBB = func->end(); BB != eBB; BB++) {
      for (auto Inst = BB->begin(), eInst = BB->end(); Inst != eInst; Inst++) {
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

```
