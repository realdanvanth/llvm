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
