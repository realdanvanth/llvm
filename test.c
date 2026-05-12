#include <stdio.h>

#define N 500000000

int main() {

  volatile int sum = 0;

  for (int i = 0; i < N; i++) {

    int x = i % 100;

    int p = 5 * x * x * x * x + 5 * x * x * x * x + 3 * x * x * x +
            3 * x * x * x + 2 * x * x + 2 * x * x;

    sum += p;
  }

  printf("%d\n", sum);
}
