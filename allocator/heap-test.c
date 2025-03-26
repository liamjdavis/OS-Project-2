#include <stdio.h>
#include <stdlib.h>
#include "heap-alloc.h"
#include "types.h"

address_t statics_limit;

int main () {

  statics_limit = (address_t)malloc(1024 * 4096);
  if (statics_limit == (address_t)NULL) return 1;
  
  char* msg = allocate(8);
  if (msg == NULL) return 2;

  msg[0] = 'H';
  msg[1] = 'i';
  msg[2] = '!';
  msg[3] = '\0';
  printf("%s\n", msg);

  deallocate(msg);
  char* remsg = allocate(8);
  if (msg != remsg) return 3;
  
  return 0;
  
}
