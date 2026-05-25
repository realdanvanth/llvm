#include <stdlib.h>
void test() {
  // 1. normal alloc and free - no error
  int *p = malloc(4);
  free(p);

  // 2. double free
  int *q = malloc(4);
  free(q);
  free(q); // ERROR: double free

  // 3. use after free - load
  int *r = malloc(4);
  free(r);
  int x = *r; // ERROR: load after free

  // 4. use after free - store
  int *s = malloc(4);
  free(s);
  *s = 5; // ERROR: store after free

  // 5. use after free - GEP (array indexing)
  int *arr = malloc(16);
  free(arr);
  int y = arr[2]; // ERROR: gep after free

  // 6. memory leak - no free at all
  int *leak = malloc(4);
  // ERROR: never freed
}
int main() { test(); }
