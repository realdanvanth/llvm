# build pass
```bash
./run.sh <dir>
```

# run pass

```bash
./pass.sh <plugin.so> <pass> <input.ll>
```

# create new pass

```bash
./newpass.sh
```

## Passes

| Pass | Description |
|--------|-------------|
| [Dead Code Elimination](https://github.com/realdanvanth/llvm/tree/main/deadcode) | Removes unreachable functions and dead instructions |
| [Local Value Numbering](https://github.com/realdanvanth/llvm/tree/main/LVN) | Constant folding, propagation, and CSE |
| [Multiplication to Shifts](https://github.com/realdanvanth/llvm/tree/main/MultiplicationShifts) | Replaces powers-of-two multiplication with shifts |
| [Security Analysis](https://github.com/realdanvanth/llvm/tree/main/sec-analysis) | Detects double free and use-after-free errors |

