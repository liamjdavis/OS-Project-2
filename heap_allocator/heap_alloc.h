/* =============================================================================================================================== */
/* Avoid multiple inclusion. */

#if !defined (_HEAP_ALLOC_H)
#define _HEAP_ALLOC_H
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* INCLUDES */

#include "../types.h"

/* =============================================================================================================================== */

/* =============================================================================================================================== */
/* PROTOTYPES */

/**
 * Initialize the heap with the specified start address.
 *
 * \param heap_start The address to use as the start of the heap space.
 * \return Pointer to the head of the free blocks list.
 */
header_s* heap_init(word_t heap_start);

/**
 * Allocate a block of memory that is at least as large as the requested size.
 *
 * \param size The number of bytes to allocate (at a minimum).
 * \return a pointer to a block that is at least `size` bytes in length; `NULL` if the allocation failed.
 */
void* allocate (int size);

/**
 * Free an allocated block of memory, reclaiming it for later re-use.
 *
 * \param ptr A pointer to a block of memory previously allocated by `allocate()`.  If `ptr == NULL`, do nothing.
 */
void deallocate (void* ptr);
/* =============================================================================================================================== */



/* =============================================================================================================================== */
#endif /* _HEAP_ALLOC_H */
/* =============================================================================================================================== */
