// #include <stdio.h>

int compute(int x) {
  int a = x * x;
  int b = x * x;

  int c = (x * x) + (x * x);

  int d = 42 * 8;
  int e = 42 * 8;

  int f = d + e;

  return a + b + c + f;
}

int main() {
  int sum = 0;

  for (int i = 0; i < 1000; i++) {
    sum += compute(i);
  }

  // printf("%d\n", sum);
  return sum;
}
