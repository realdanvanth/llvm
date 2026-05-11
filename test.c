int test_commute(int a, int b) {
  int x = a + b;
  int y = a + b; // same thing, different order — CSE should catch this
  return x + y;
}
int main() { return test_commute(1, 3); }
