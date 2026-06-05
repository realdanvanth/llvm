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


## Redundant Load Elimination:
this is a pre-requisite for CSE as we need to identify the common expressions
two loads loading the same pointer are identical if there is no store happening 
in between. all identical loads can be replaced with its copy.
This also makes the program effcient.
<table>
<tr>
<th width="50%">Before Pass</th>
<th width="50%">After Pass</th>
</tr>

<tr>
<td valign="top">

<pre style="font-size:11px;"><code>
  %5 = load i32, ptr %3, align 4
  %6 = load i32, ptr %3, align 4
</code></pre>

</td>

<td valign="top">

<pre style="font-size:11px;"><code>
  %5 = load i32, ptr %3, align 4
</code></pre>
</td>
</tr>
</table>

## Constant Propogation / Constant Folding
If a store is storing constants , all the loads that load the same SSA value
can be replaced with constants. so 
instead of add nsw 132 %5, %6 we get add nsw i32, 10,20
If a binary operator has the left and the right value as constants then we can 
fold it.
<table>
<tr>
<th width="50%">Before Pass</th>
<th width="50%">After Pass</th>
</tr>

<tr>
<td valign="top">

<pre style="font-size:11px;"><code>
  store i32 10, ptr %2, align 4
  store i32 20, ptr %3, align 4
  %5 = load i32, ptr %2, align 4
  %6 = load i32, ptr %3, align 4
  %7 = add nsw i32 %5, %6
</code></pre>

</td>

<td valign="top">

<pre style="font-size:11px;"><code>
 store i32 10, ptr %2, align 4
 store i32 20, ptr %3, align 4
 %5 = load i32, 30, align 4
</code></pre>
</td>
</tr>
</table>
