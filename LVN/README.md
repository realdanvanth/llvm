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

### code :
```cpp
std::unordered_map<Value *, Value *> map;
      for (auto inst = BB->begin(), einst = BB->end(); inst != einst;) {
        bool del = false;
        if (auto op = dyn_cast<LoadInst>(inst)) {
          auto item = map.find(op->getPointerOperand());
          if (item != map.end()) {
            del = true;
            errs() << "Replaced : " << *inst << "| with : " << *item->second
                   << "\n";
            op->replaceAllUsesWith(item->second);
          } else {
            map[op->getPointerOperand()] = op;
          }
        } else if (auto op = dyn_cast<StoreInst>(inst)) {
          auto item = map.find(op->getPointerOperand());
          if (item != map.end()) {
            map.erase(item);
          }
        }
```
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

### code:
```cpp
 if (l && r) {
            long result = 0;
            if (op->getOpcode() == Instruction::Add) {
              result = *l + *r;
            } else if (op->getOpcode() == Instruction::Sub) {
              result = *l - *r;
            } else if (op->getOpcode() == Instruction::Mul) {
              result = *l * *r;
            } else if (op->getOpcode() == Instruction::SDiv) {
              if (*r != 0)
                result = *l / *r;
              else
                errs() << "warning division by 0\n";
            } else if (op->getOpcode() == Instruction::SRem) {
              if (*r != 0)
                result = *l % *r;
              else
                errs() << "warning division by 0\n";
            }
            // if both are constants then they can be folded
            auto value = ConstantInt::get(op->getType(), result);
            errs() << "constants folded : left :" << l << "  right :" << r
                   << "\n";
            op->replaceAllUsesWith(value);
            del = true;
          }

```
## Common SubExpr Elimination
If we find the same binary operation happening more than once 
we replace duplicate binary operations by storing the 
binary operation in a hashmap with op,l,r
and if its a commutative operation we sort it and store it, 
so we can eliminate a+b and b+a since they are identical 

<table>
<tr>
<th width="50%">Before Pass</th>
<th width="50%">After Pass</th>
</tr>

<tr>
<td valign="top">

<pre style="font-size:11px;"><code>
  %10 = add nsw i32 %8, %9
  %11 = add nsw i32 %8, %9
</code></pre>

</td>

<td valign="top">

<pre style="font-size:11px;"><code>
 %10 = add nsw i32 %8, %9
</code></pre>
</td>
</tr>
</table>

```cpp
if (hashl > hashr && (op->getOpcode() == Instruction::Add ||
                                op->getOpcode() == Instruction::Mul)) {
            std::swap(hashl,
                      hashr); // this is to maintain commutativity , so a+b and
                              // b+a are always stored in the same order
          }
          auto expr = map.find(std::make_tuple(op->getOpcode(), hashl, hashr));
          if (expr != map.end()) {
            errs() << "Common SubExpr Found : " << *inst
                   << " replaced with : " << *expr->second << "\n";
            op->replaceAllUsesWith(
                expr->second); // if its an old expression then replace it
            del = true;
          } else {
            map[std::make_tuple(op->getOpcode(), hashl, hashr)] =
                &*inst; // if its a new tuple store it
          }
```

## Dead Store/Alloca Elimination

If a store is not loaded throughout the program then we eliminate the store
We iterate through all instructions and and store all the loaded SSA values 
in an array and if a store uses an unused location it is eliminated,
the same goes for alloca

```cpp
if (auto store = dyn_cast<StoreInst>(inst)) {
            auto c = std::count(stores.begin(), stores.end(),
                                store->getPointerOperand());
            if (c <= 0) {
              errs() << "deleting store : " << *inst << "\n";
              del = true;
            }
          }
```

```cpp
if (auto alloca = dyn_cast<AllocaInst>(inst)) {
            if (alloca->use_empty()) {
              errs() << "deleting alloca : " << *inst << "\n";
              del = true;
            }
          }

```
