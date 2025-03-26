/* =============================================================================================================================== */
#include "utility.h"
#include <stdio.h>  /* For printf */

/* Define missing constants */
#define BYTES_PER_WORD 4  /* 32-bit word = 4 bytes */
#define BITS_PER_BYTE 8   /* 8 bits per byte */
#define BITS_PER_NYBBLE 4 /* 4 bits per nybble/hexadecimal digit */

void int_to_hex (word_t value, char* buffer) {

  static char hex_digits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

  /* Traverse the value from most to least significant bits. */
  for (int shift = BYTES_PER_WORD * BITS_PER_BYTE - BITS_PER_NYBBLE; shift >= 0; shift -= BITS_PER_NYBBLE) {

    /* Grab the next nybble and add its corresponding digit to the string, advancing the string's pointer. */
    word_t nybble = (value >> shift) & 0xf;
    *buffer++ = hex_digits[nybble];
    
  }

  /* Finish the string with a null termination. */
  *buffer = '\0';
  
} /* int_to_hex () */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void int_to_dec (word_t value, char* buffer) {

  /* Special case for zero */
  if (value == 0) {
    buffer[0] = '0';
    buffer[1] = '\0';
    return;
  }

  /* Append digits until no more remain. */
  int i = 0;
  while (value != 0) {
    int digit = value % 10;
    value /= 10;
    buffer[i++] = '0' + digit;
  }
  
  /* Reverse the digits (since we built the number backward) */
  for (int j = 0; j < i/2; j++) {
    char temp = buffer[j];
    buffer[j] = buffer[i-j-1];
    buffer[i-j-1] = temp;
  }
  
  /* Add null terminator */
  buffer[i] = '\0';

} /* int_to_dec () */
/* =============================================================================================================================== */

/* =============================================================================================================================== */
/* Test main function */
int main(void) {
  char buffer[20];
  
  /* Test int_to_hex */
  int_to_hex(0x12345678, buffer);
  printf("Hex: %s\n", buffer);
  
  /* Test int_to_dec */
  int_to_dec(12345, buffer);
  printf("Dec: %s\n", buffer);
  
  /* Test edge cases */
  int_to_hex(0, buffer);
  printf("Hex zero: %s\n", buffer);
  
  int_to_dec(0, buffer);
  printf("Dec zero: %s\n", buffer);
  
  return 0;
}
/* =============================================================================================================================== */
