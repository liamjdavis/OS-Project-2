#include "memory_alloc.h"
#include "../heap_allocator/heap_alloc.h"
#include "../types.h"

void* malloc(word_t size) {
    // Handle zero-size allocation
    if (size == 0) {
        return NULL;
    }
    
    // Call the heap allocator
    return allocate((int)size);
}

void free(void* ptr) {
    deallocate(ptr);
}