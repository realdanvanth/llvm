# Local Value Numbering
A pass performed within a basic block to implement:

- Constant Folding
- Constant Propagation
- Common Subexpression Elimination


## workflow:
```text
Redundant Load Elimination
          |
          V
Constant Propagation/folding
          |
          V
Common SubExpr Elimination
          |
          V
Dead Load Elimination
          |
          V
Dead Alloca Elimination
```

<table>
<tr>
<th width="50%">Before Pass</th>
<th width="50%">After Pass</th>
</tr>

<tr>
<td valign="top">

<pre style="font-size:11px;"><code>
define dso_local i32 @compute(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %3, align 4
  %6 = load i32, ptr %4, align 4
  %7 = add nsw i32 %5, %6
  %8 = load i32, ptr %3, align 4
  %9 = load i32, ptr %4, align 4
  %10 = add nsw i32 %8, %9
  %11 = add nsw i32 %7, %10
  ret i32 %11
}
</code></pre>

</td>

<td valign="top">

<pre style="font-size:11px;"><code>
define dso_local i32 @compute(i32 noundef %0, i32 noundef %1) #0 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, ptr %3, align 4
  store i32 %1, ptr %4, align 4
  %5 = load i32, ptr %3, align 4
  %6 = load i32, ptr %4, align 4
  %7 = add nsw i32 %5, %6
  %8 = add nsw i32 %7, %7
  ret i32 %8
}
</code></pre>
</td>
</tr>
</table>


## Dead Load Elimination:

<table>
<tr>
<th width="50%">Before Pass</th>
<th width="50%">After Pass</th>
</tr>

<tr>
<td valign="top">

<pre style="font-size:11px;"><code>
```llvm
  %5 = load i32, ptr %3, align 4
  %6 = load i32, ptr %3, align 4
```
</code></pre>

</td>

<td valign="top">

<pre style="font-size:11px;"><code>
```llvm
  %5 = load i32, ptr %3, align 4
```
</code></pre>
</td>
</tr>
</table>
