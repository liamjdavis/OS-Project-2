#if !defined (_TYPES_H)
#define _TYPES_H

/* Define NULL */
#define NULL ((void*)0)

/* Define uint32_t for compatibility with kernel stub */
typedef unsigned int uint32_t;

/* Use 32-bit types for simulator */
typedef unsigned int address_t;
typedef unsigned int word_t;

typedef struct dt_entry {
  word_t    type;
  address_t base;
  address_t limit;
} dt_entry_s;

typedef struct DMA_portal {
  address_t src;
  address_t dst;
  word_t    length;
} DMA_portal_s;

typedef struct free_block {
  struct free_block *next;
} free_block_s;

#endif /* _TYPES_H */
