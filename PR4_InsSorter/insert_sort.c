#include <stdio.h>
#define A_LENGTH 6
#pragma GCC diagnostic ignored "-fno-stack-protector"
int main() {
  int i, j, key;
  int A[A_LENGTH] = {3,34,333,34,53,31};
  
  for(j = 1; j <= A_LENGTH; j++) {
    key = A[j];
    i = j - 1;
    while (i > 0 && A[i] > key) {
      A[i+1] = A[i];
      --i;
    }
    A[i+1] = key;
  }
  return 0;
}
