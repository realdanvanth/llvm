# Multiplication Shifts 
if the multiplcation operator has a constant and it is a power of 2
it can be replaced with the left shift like so
this reduces the cpu cycles as left shift instruction is faster than mul
a *  2  →  a << 1
a * 4  →  a << 2
a * 8  →  a << 3
a * 16 →  a << 4
<table>
<tr>
<th width="50%">Before Pass</th>
<th width="50%">After Pass</th>
</tr>
<tr>
<td valign="top">
<pre style="font-size:11px;"><code>
 %2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  %4 = mul nsw i32 %3, 8
  ret i32 %4
</code></pre>
</td>
<td valign="top">
<pre style="font-size:11px;"><code>
%2 = alloca i32, align 4
  store i32 %0, ptr %2, align 4
  %3 = load i32, ptr %2, align 4
  %4 = shl i32 %3, 3
  ret i32 %4
</code></pre>
</td>
</tr>
</table>
