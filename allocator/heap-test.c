#include <stdio.h>
#include <stdlib.h>
#include "heap-alloc.h"
#include "../types.h"

address_t statics_limit;

int main () {

  statics_limit = (address_t)malloc(1024 * 4096);
  if (statics_limit == (address_t)NULL) return 1;
  
  printf("statics_limit: %p\n", statics_limit);
  char* msg = allocate(8);
  printf("msg: %p\n", msg);
  if (msg == NULL) return 2;

  printf("msg: %p\n", msg);
  printf("About to write to msg[0] at address %p\n", &msg[0]);
  msg[0] = 'H';
  printf("Successfully wrote 'H' to msg[0]\n");
  printf("msg: %p\n", msg);
  printf("About to write to msg[1] at address %p\n", &msg[1]);
  msg[1] = 'i';
  printf("Successfully wrote 'i' to msg[1]\n");
  printf("msg: %p\n", msg);
  printf("About to write to msg[2] at address %p\n", &msg[2]);
  msg[2] = '!';
  printf("Successfully wrote '!' to msg[2]\n");
  printf("msg: %p\n", msg);
  printf("About to write to msg[3] at address %p\n", &msg[3]);
  msg[3] = '\0';
  printf("Successfully wrote null terminator to msg[3]\n");
  printf("msg: %p\n", msg);
  printf("About to print msg: ");
  printf("%s\n", msg);

  deallocate(msg);
  char* remsg = allocate(8);
  if (msg != remsg) return 3;
  
  return 0;
  
}
