#ifndef _MALLOC_H
#define _MALLOC_H

#include <stddef.h>

void* malloc(size_t size);
void free(void* ptr);

#endif /* _MALLOC_H */