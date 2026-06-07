#include <stdio.h>

int test(int a, int b, int c, int n) {
  int sum = 0;

  for (int i = 0; i < n; i++) {
    int x1 = a + b;
    int x2 = a + b;
    x1 = 2;
    int x3 = (a + b) * c;
    int x4 = x1 * c;

    int x5 = x3 + x4;
    int x6 = x3 + x4;

    int x7 = (c + 10) * (c + 10);
    int x8 = (c + 10) * (c + 10);

    sum += x1 + x2 + x5 + x6 + x7 + x8;
  }

  return sum;
}

int main() { printf("%d\n", test(3, 4, 5, 100)); }
