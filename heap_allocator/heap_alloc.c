#include <stdint.h>
#include "heap_alloc.h"
#include "../types.h"
#include "../linked_list.h"

/* MACROS */
#define ADDR_SIZE (sizeof(address_t))
#define ALIGN_UP(addr) ((addr + (ADDR_SIZE-1)) & ~(ADDR_SIZE-1))
#define HEADER_TO_BLOCK(p) ((void*)ALIGN_UP((address_t)((char*)(p) + sizeof(header_s))))
#define BLOCK_TO_HEADER(p) ((header_s*)((char*)(p) - (ALIGN_UP(sizeof(header_s)))))

/* STATICS */
static unsigned char* heap_space = NULL;  // Dynamic heap space
static word_t heap_size = 0;              // Size of the heap
static header_s* free_blocks = NULL;      // Head of free blocks list

header_s* heap_init(word_t heap_start) {
    if (free_blocks != NULL) return free_blocks;  // Already initialized
    
    // Use the address after kernel_end_marker as the heap space
    heap_space = (unsigned char*)heap_start;
    
    // Calculate available heap size from heap_start to kernel_limit
    extern word_t kernel_limit;  // Defined in kernel-stub.asm
    heap_size = (word_t)kernel_limit - heap_start;
    
    // Verify we have enough space for at least one block
    if (heap_size <= sizeof(header_s)) {
        heap_space = NULL;
        heap_size = 0;
        free_blocks = NULL;
        return NULL;
    }
    
    // Create initial free block
    header_s* initial_block = (header_s*)heap_space;
    initial_block->size = heap_size - sizeof(header_s);
    initial_block->next = NULL;
    initial_block->prev = NULL;
    
    // Initialize free list with the initial block
    free_blocks = initial_block;
    
    // Verify initialization succeeded
    if (free_blocks == NULL || free_blocks->size == 0) {
        heap_space = NULL;
        heap_size = 0;
        free_blocks = NULL;
        return NULL;
    }
    
    return free_blocks;
}

void* allocate(int size) {
    if (free_blocks == NULL) return NULL;  // Heap not initialized
    
    // Calculate total size needed including alignment padding
    size = ALIGN_UP(size);
    int header_size = ALIGN_UP(sizeof(header_s));
    int total_size = size + (header_size - sizeof(header_s));  // Extra space for alignment
    
    header_s* current = free_blocks;

    while (current != NULL) {
        if (current->size >= total_size) {
            REMOVE(free_blocks, current);
            
            if (current->size > total_size + sizeof(header_s)) {
                void* current_end = (char*)current + header_size + size;
                header_s* split_block = (header_s*)current_end;
                
                split_block->next = NULL;
                split_block->prev = NULL;
                split_block->size = current->size - total_size - sizeof(header_s);
                
                current->size = total_size;
                
                INSERT(free_blocks, split_block);
            }
            
            return HEADER_TO_BLOCK(current);
        }
        current = current->next;
    }

    return NULL;
}

void deallocate(void* ptr) {
    if (ptr == NULL) return;

    header_s* header = BLOCK_TO_HEADER(ptr);
    header_s* current = free_blocks;

    while (current != NULL) {
        if ((address_t)current + current->size + sizeof(header_s) == (address_t)header) {
            current->size += header->size + sizeof(header_s);
            return;
        } else if ((address_t)header + header->size + sizeof(header_s) == (address_t)current) {
            header->size += current->size + sizeof(header_s);
            REMOVE(free_blocks, current);
            INSERT(free_blocks, header);
            return;
        }
        current = current->next;
    }

    INSERT(free_blocks, header);
}