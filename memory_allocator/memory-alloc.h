#ifndef _MALLOC_H
#define _MALLOC_H
#include "../types.h"

void* malloc(word_t size);
void free(void* ptr);

#endif /* _MALLOC_H */