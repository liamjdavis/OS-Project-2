/* =============================================================================================================================== */
/**
 * The Marseinne Twister psuedo-random number generator for 32-bit values.  Implemented to allow individual states to be initialized
 * and used, or to allow the use of a single, global state that is internally managed.
 *
 * \file mt19937.h
 */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/** AVOID MULTIPLE INCLUSION */

#if !defined (_MT19937_H)
#define _MT19937_H
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* INCLUDES */

#include <stdint.h>
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* CONSTANTS & MACROS */

/** The given default state size, needed to define the structure (below). */
#define STATE_SIZE 624
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* STRUCTURES */

/** The state that defines the current position in the random number sequence. */
typedef struct mt_state
{
  uint32_t state_array[STATE_SIZE];  // the array for the state vector 
  int      state_index;              // index into state vector array, 0 <= state_index <= n-1   always
} mt_state_s;
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* FUNCTION PROTOTYPES */

/**
 * Initialize a new state, setting its seed.
 *
 * \param state The state to initialize.
 * \param seed  The seed with which to initialize the state.
 */
void mt_new_state (mt_state_s* state, uint32_t seed);

/**
 * Get a random value from a given random state.
 *
 * \param state The state from which to generate a random value.  The state is updated with the generation.
 * \return the random value.
 */
uint32_t mt_get_random (mt_state_s* state);

/**
 * Initialize the global state to a default initial seed.
 */
void mt_init ();

/**
 * Get a random value from the global random state, updating it in the process.
 *
 * \return a randomly generated value.
 */
uint32_t mt_rand ();
/* =============================================================================================================================== */


  
/* =============================================================================================================================== */
#endif /* _MT19937_H */
/* =============================================================================================================================== */
