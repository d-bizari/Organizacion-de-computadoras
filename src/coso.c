#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
 // Funcion escrita en assembly
extern void merge_sort(int * array, size_t lenght);

int  main() {
  int test[6] = {3,4,-8,1,5,2};
  merge_sort(test, 6);
  for(size_t i = 0; i < 6; i++){
    fprintf(stdout, "%d ", test[i]);
  }
}
