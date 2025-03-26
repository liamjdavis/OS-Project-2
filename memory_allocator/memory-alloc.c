#include "malloc.h"
#include "../heap_allocator/heap-alloc.h"

void* malloc(size_t size) {
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