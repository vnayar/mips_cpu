import std.conv;

void main() {
  int[] numbers = [5, 7, 3, 2, 9, 4, 1, 8, 6, 0];
  for (int i = 0; i < numbers.length; i++) {
    int min = i;
    int min_val = numbers[i];
    for (int j = i + 1; j < numbers.length; j++) {
      int check_val = numbers[j];
      if (check_val < min_val) {
        min = j;
        min_val = check_val;
      }
    }
    int temp_val = numbers[i];
    numbers[i] = min_val;
    numbers[min] = temp_val;
  }
  assert(numbers == [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], to!string(numbers));
}