#include "memory-alloc.h"
#include "../heap_allocator/heap-alloc.h"

void* malloc(word_t size) {
    if (size == 0) {
        return NULL;
    }
    return allocate((int)size);
}

void free(void* ptr) {
    deallocate(ptr);
}