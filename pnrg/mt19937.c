/* =============================================================================================================================== */
/* INCLUDES */

#include <stdint.h>
#include "mt19937.h"
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* CONSTANTS & MACROS */
   
#define n STATE_SIZE
#define m 397
#define w 32
#define r 31
#define UMASK (0xffffffffUL << r)
#define LMASK (0xffffffffUL >> (w-r))
#define a 0x9908b0dfUL
#define u 11
#define s 7
#define t 15
#define l 18
#define b 0x9d2c5680UL
#define c 0xefc60000UL
#define f 1812433253UL
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* GLOBALS */

/** A single, global state, internally kept to provide random values without managing separate states. */
static mt_state_s _mt_state;
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void mt_new_state (mt_state_s* state, uint32_t seed) 
{
    uint32_t* state_array = &(state->state_array[0]);
    
    state_array[0] = seed;                          // suggested initial seed = 19650218UL
    
    for (int i=1; i<n; i++)
    {
        seed = f * (seed ^ (seed >> (w-2))) + i;    // Knuth TAOCP Vol2. 3rd Ed. P.106 for multiplier.
        state_array[i] = seed; 
    }
    
    state->state_index = 0;
}
/* =============================================================================================================================== */



/* =============================================================================================================================== */
uint32_t mt_get_random (mt_state_s* state)
{
    uint32_t* state_array = &(state->state_array[0]);
    
    int k = state->state_index;      // point to current state location
                                     // 0 <= state_index <= n-1   always
    
//  int k = k - n;                   // point to state n iterations before
//  if (k < 0) k += n;               // modulo n circular indexing
                                     // the previous 2 lines actually do nothing
                                     //  for illustration only
    
    int j = k - (n-1);               // point to state n-1 iterations before
    if (j < 0) j += n;               // modulo n circular indexing

    uint32_t x = (state_array[k] & UMASK) | (state_array[j] & LMASK);
    
    uint32_t xA = x >> 1;
    if (x & 0x00000001UL) xA ^= a;
    
    j = k - (n-m);                   // point to state n-m iterations before
    if (j < 0) j += n;               // modulo n circular indexing
    
    x = state_array[j] ^ xA;         // compute next value in the state
    state_array[k++] = x;            // update new state value
    
    if (k >= n) k = 0;               // modulo n circular indexing
    state->state_index = k;
    
    uint32_t y = x ^ (x >> u);       // tempering 
             y = y ^ ((y << s) & b);
             y = y ^ ((y << t) & c);
    uint32_t z = y ^ (y >> l);
    
    return z; 
}
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void mt_init ()
{
  mt_new_state(&_mt_state, 19650218UL);
}
/* =============================================================================================================================== */



/* =============================================================================================================================== */
uint32_t mt_rand ()
{
  return mt_get_random(&_mt_state);
}
/* =============================================================================================================================== */

