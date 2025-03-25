#ifndef _MEMORY_H
#define _MEMORY_H

#include "linked_list.h"
#include "types.h"

// Block Header
typedef struct block_header {
    struct block_header* next;
    struct block_header* prev;
    word_t size;
    word_t is_free;
} block_header_t;

// Init memory allocator
void init_memory(address_t heap_start, word_t heap_size);

// Allocate memory
void* malloc(word_t size);

// Free memory
void free(void* ptr);

// Split block
void split_block(block_header_t* block, word_t size);

// Find free block
block_header_t* find_free_block(word_t size);

#endif /* _MEMORY_H */