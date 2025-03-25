#include "memory.h"

// Static variables
static block_header_t* free_list = 0;
static address_t heap_start = 0;
static address_t heap_end = 0;

void init_memory(address_t start, word_t size) {
    heap_start = start;
    heap_end = start + size;

    // Create initial free block
    block_header_t* initial_block = (block_header_t*) start;
    initial_block->size = size;
    initial_block->is_free = 1;
    initial_block->next = 0;
    initial_block->prev = 0;
}

void* malloc(word_t size) {
    if (size == 0) return 0;

    block_header_t* block = find_free_block(size);
    if (!block) return 0;

    split_block(block, size);
    block->is_free = 0;

    // Return pointer
    return (void*)((address_t)block + sizeof(block_header_t));
}

void free(void* ptr) {
    if (!ptr) return;

    // Get block header
    block_header_t* block = (block_header_t*)((address_t)ptr - sizeof(block_header_t));

    // Validate pointer is within heap
    if ((address_t)block < heap_start || (address_t)block >= heap_end) {
        return;
    }

    // Mark block as free
    block->is_free = 1;

    // Merge with next block if it is free
    block_header_t* next = (block_header_t*)((address_t)block + block->size);
    
    if ((address_t)next < heap_end && next->is_free) {
        block->size += next->size;
        REMOVE(free_list, next);
    }

    // Merge with previous block if it is free
    if (block->prev && block->prev->is_free) {
        block->prev->size += block->size;
        REMOVE(free_list, block);
    }
}

/*
    Best first fit for now
*/
block_header_t* find_free_block(word_t size) {
    block_header_t* current = free_list;

    while (current) {
        if (current->size >= size) {
            return current;
        }
        current = current->next;
    }

    return 0;
}

void split_block(block_header_t* block, word_t size) {
    word_t remaining = block->size - size - sizeof(block_header_t);

    // Split block and allocate
    if (remaining >= sizeof(block_header_t)) {
        block_header_t* new_block = (block_header_t*)((address_t)block + size + sizeof(block_header_t));
        new_block->size = remaining;
        new_block->is_free = 1;

        // Insert new block into free list
        new_block->next = block->next;
        new_block->prev = block;
        block->next = new_block;
        block->size = size;
    }
}
