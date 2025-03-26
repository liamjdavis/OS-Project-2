/* =============================================================================================================================== */
/**
 * A collection of useful functions.
 *
 * \file utility.h
 */
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* AVOID MULTIPLE INCLUSION */

#if !defined (_UTILITY_H)
#define _UTILITY_H
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* INCLUDES */

#include "../types.h"
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* FUNCTION PROTOTYPES */

/**
 * Convert an integer value into a null-terminated text string in base 16.  The string is always a full eight digits, including
 * leading zeros, so the buffer space provided must be at least 9 characters in length.
 *
 * \param value  The integer to convert.
 * \param buffer The space in which to construct the string.
 */
void int_to_hex (word_t value, char* buffer);

/**
 * Convert an integer value into a null-terminated text string in base 10.  The integer is always interpreted as unsigned.  Leading
 * zeros are not generated.  The buffer space should be at least 11 characters in length.
 */
void int_to_dec (word_t value, char* buffer);
/* =============================================================================================================================== */



/* =============================================================================================================================== */
#endif /* _UTILITY_H */
/* =============================================================================================================================== */
