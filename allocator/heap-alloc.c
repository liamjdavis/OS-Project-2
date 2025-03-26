#include <stdint.h>
#include "heap-alloc.h"
#include "../types.h"
#include "../linked_list.h"

/* MACROS */
#define ADDR_SIZE (sizeof(address_t))
#define ALIGN_UP(addr) ((addr + (ADDR_SIZE-1)) & ~(ADDR_SIZE-1))
#define HEADER_TO_BLOCK(p) ((void*)((char*)(p) + sizeof(header_s)))
#define BLOCK_TO_HEADER(p) ((header_s*)((char*)(p) - sizeof(header_s)))

/* TYPES & STRUCTS */
typedef struct header {
    struct header* next;
    struct header* prev;
    word_t size;
} header_s;

/* STATICS */
#define HEAP_SIZE (1024 * 1024)  // 1MB heap
static unsigned char heap_space[HEAP_SIZE];
static header_s* free_blocks = NULL;  // Head of free blocks list

void heap_init() {
    if (free_blocks != NULL) return;

    header_s* initial_block = (header_s*)heap_space;
    initial_block->size = HEAP_SIZE - sizeof(header_s);
    initial_block->next = NULL;
    initial_block->prev = NULL;

    INSERT(free_blocks, initial_block);
}

void* allocate(int size) {
    heap_init();
    
    size = ALIGN_UP(size);
    header_s* current = free_blocks;

    while (current != NULL) {
        if (current->size >= size) {
            REMOVE(free_blocks, current);
            
            if (current->size > size + sizeof(header_s)) {
                void* current_end = (char*)current + sizeof(header_s) + size;
                header_s* split_block = (header_s*)current_end;
                
                split_block->next = NULL;
                split_block->prev = NULL;
                split_block->size = current->size - size - sizeof(header_s);
                
                current->size = size;
                
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