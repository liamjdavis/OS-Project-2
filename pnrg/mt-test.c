#include <stdio.h>
#include <stdlib.h>
#include "mt19937.h"
#include "../types.h"

static mt_state_s test_state;

int main () {

  mt_new_state(&test_state, 13);
  mt_init();

  for (int i = 0; i < 5; i += 1) {
    uint32_t x = mt_get_random(&test_state);
    uint32_t y = mt_rand();
    printf("%d\t%d\n", x, y);
  }
  
  return 0;
  
}
