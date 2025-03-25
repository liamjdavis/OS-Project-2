#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "linked_list.h"

typedef struct int_link {
    struct int_link* next;
    struct int_link* prev;
    int              val;
} int_link_s;

void print_list (int_link_s* head) {

    for (int_link_s* current = head; current != NULL; current = current->next) {
        printf("%d\n", current->val);
    }
  
}

int main (int argc, char** argv) {
    
    int_link_s* head = NULL;
    
    for (int i = 0; i < 4; i += 1) {
        int_link_s* il = malloc(sizeof(*il));
        il->val = i * i;
        INSERT(head, il);
    }
    print_list(head);

    int_link_s* mid = head->next->next;
    REMOVE(head, mid);
    print_list(head);

    REMOVE(head, head);
    print_list(head);

    return 0;
  
}