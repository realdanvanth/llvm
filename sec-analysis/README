# Security Analysis

This LLVM pass performs simple security analysis within a single basic block.

Currently implemented detections:

- Double Free
- Use After Free
- Load After Free
- Store After Free

Memory leak detection is planned for future versions, as it requires analysis that spans multiple basic blocks and function exit paths.

## Overview

The analysis tracks dynamically allocated memory objects and a basic set of pointer aliases created through loads and stores.

For each basic block, the pass maintains:

- A set of currently allocated objects.
- A mapping between pointers and the objects they reference.

When a `malloc()` call is encountered, the allocated object is recorded. When a `free()` call is encountered, the corresponding object is removed from the active object set.

Subsequent accesses to freed memory are reported as errors.

## Detected Errors

### Double Free

The pass reports an error when a memory object is freed more than once.

Example:

```c
int *p = malloc(sizeof(int));
free(p);
free(p);   // Double Free
```

Output:

```text
DOUBLE FREE detected
```

---

### Use After Free

The pass reports an error when pointer arithmetic or address computation is performed on a freed object.

Example:

```c
int *p = malloc(sizeof(int));
free(p);
p[0] = 10; // Use After Free
```

Output:

```text
USE AFTER FREE detected
```

---

### Load After Free

The pass reports an error when a value is loaded through a pointer that references a freed object.

Example:

```c
int *p = malloc(sizeof(int));
free(p);
int x = *p; // Load After Free
```

Output:

```text
LOAD AFTER FREE detected
```

---

### Store After Free

The pass reports an error when a value is stored through a pointer that references a freed object.

Example:

```c
int *p = malloc(sizeof(int));
free(p);
*p = 42; // Store After Free
```

Output:

```text
STORE AFTER FREE detected
```

## Alias Analysis

A lightweight alias analysis is implemented to track simple pointer relationships inside a basic block.

The analysis records:

```text
pointer -> allocated object
```

relationships and propagates them through loads and stores whenever possible.

This allows the pass to detect errors even when the original pointer is accessed indirectly through another pointer variable.

Example:

```c
int *p = malloc(sizeof(int));
int *q = p;

free(p);

*q = 5; // Detected through alias tracking
```



The security analysis is currently performed after redundant load elimination to simplify the generated IR and reduce redundant memory operations.
