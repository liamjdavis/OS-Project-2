#include <stdio.h>
#include <string.h>
#include "memory-alloc.h"

int main() {
    // Test 1: Basic allocation and writing
    printf("Test 1: Basic allocation and writing\n");
    char* str = (char*)malloc(16);
    if (str == NULL) {
        printf("FAIL: malloc returned NULL\n");
        return 1;
    }
    
    strcpy(str, "Hello, World!");
    printf("Allocated string: %s\n", str);
    
    // Test 2: Free and reallocate
    printf("\nTest 2: Free and reallocate\n");
    void* first_addr = str;
    free(str);
    char* str2 = (char*)malloc(16);
    
    if (str2 != first_addr) {
        printf("FAIL: reallocated memory at different address\n");
        return 2;
    }
    printf("Successfully reallocated at same address\n");
    
    // Test 3: Zero-size allocation
    printf("\nTest 3: Zero-size allocation\n");
    void* null_ptr = malloc(0);
    if (null_ptr != NULL) {
        printf("FAIL: zero-size allocation did not return NULL\n");
        return 3;
    }
    printf("Zero-size allocation correctly returned NULL\n");
    
    // Test 4: Multiple allocations
    printf("\nTest 4: Multiple allocations\n");
    int* numbers = (int*)malloc(5 * sizeof(int));
    if (numbers == NULL) {
        printf("FAIL: malloc returned NULL for numbers array\n");
        return 4;
    }
    
    for (int i = 0; i < 5; i++) {
        numbers[i] = i + 1;
    }
    
    printf("Numbers array: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    
    free(numbers);
    printf("\nAll tests passed!\n");
    return 0;
}