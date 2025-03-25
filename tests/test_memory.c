#include "../memory.h"
#include "../types.h"
#include <stdint.h>

// Test heap space
#define HEAP_SIZE 1024
static word_t test_heap[HEAP_SIZE / sizeof(word_t)];

// Simple test tracking
static word_t tests_failed = 0;

static void run_test(const char* name, word_t condition) {
    if (!condition) {
        tests_failed++;
    }
}

void test_init() {
    address_t heap_addr = (address_t)test_heap;
    init_memory(heap_addr, HEAP_SIZE);
    run_test("init free blocks", get_free_blocks_count() == 1);
    run_test("init free memory", get_total_free_memory() == (HEAP_SIZE - sizeof(block_header_t)));
}

void test_simple_malloc() {
    void* ptr = my_malloc(64);
    run_test("malloc non-null", ptr != NULL);
    run_test("malloc reduces free memory", get_total_free_memory() < (HEAP_SIZE - sizeof(block_header_t)));
}

void test_malloc_free() {
    void* ptr1 = my_malloc(64);
    void* ptr2 = my_malloc(64);
    my_free(ptr1);
    run_test("free creates block", get_free_blocks_count() == 2);
    my_free(ptr2);
    run_test("free merges blocks", get_free_blocks_count() == 1);
}

void test_malloc_zero() {
    void* ptr = my_malloc(0);
    run_test("malloc zero", ptr == NULL);
}

void test_free_null() {
    my_free(NULL);
    run_test("free null", get_free_blocks_count() == 1);
}

int main() {
    test_init();
    test_simple_malloc();
    test_malloc_free();
    test_malloc_zero();
    test_free_null();

    return tests_failed;
}