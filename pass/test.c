// test.c — input file for the HelloPass demo
#include <stdio.h>

void greet(const char *name) { printf("Hello, %s!\n", name); }

int add(int a, int b) { return a + b; }

int main() {
  greet("World");
  printf("1 + 2 = \n");
  return 0;
}
