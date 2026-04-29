int leaf(int x) { return x * 2; }
int left(int x) { return leaf(x + 1); }
int right(int x) { return leaf(x - 1); }
int root(int x) { return left(x) + right(x); }
int main() { return root(5); }
