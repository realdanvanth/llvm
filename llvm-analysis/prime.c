int div(int a, int b) { return a / b; }
int isPrime(int n) {
  for (int i = 2; i < div(i, 2); i++) {
    if (n % i == 0)
      return 0;
  }
  return 1;
}
int main() {
  isPrime(2);
  return isPrime(3);
}
