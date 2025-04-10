#include "process_info.h"
#include "../memory_allocator/memory_alloc.h"
#include "../types.h"
#include "../linked_list.h"

/* Custom string copy to replace strncpy */
static void my_strncpy(char* dest, const char* src, int n) {
    int i;
    for (i = 0; i < n - 1 && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    dest[i] = '\0';
}

/* Function to insert a new process into the circular doubly linked list */
void insert_process(process_info_t** head, int pid, const char* name, void* sp, void* pc) {
    process_info_t* new_process = (process_info_t*)malloc(sizeof(process_info_t));
    if (!new_process) {
        // Memory allocation failed, but we can't use printf
        return;
    }
    new_process->pid = pid;
    my_strncpy(new_process->name, name, 50);
    new_process->sp = sp;
    new_process->pc = pc;

    if (*head == NULL) {
        new_process->next = new_process;
        new_process->prev = new_process;
        *head = new_process;
    } else {
        process_info_t* tail = (*head)->prev;
        tail->next = new_process;
        new_process->prev = tail;
        new_process->next = *head;
        (*head)->prev = new_process;
    }
}

/* Function to delete a process by PID */
void delete_process(process_info_t** head, int pid) {
    if (*head == NULL) return;

    process_info_t *current = *head;
    do {
        if (current->pid == pid) {
            if (current->next == current) {
                free(current);
                *head = NULL;
                return;
            }
            
            process_info_t* prev = current->prev;
            process_info_t* next = current->next;
            prev->next = next;
            next->prev = prev;
            
            if (current == *head) {
                *head = next;
            }
            
            free(current);
            return;
        }
        current = current->next;
    } while (current != *head);
}

/* Function to display the process list */
void display_processes(process_info_t* head) {
    if (head == NULL) {
        return;
    }
    
    process_info_t* temp = head;
    do {
        temp = temp->next;
    } while (temp != head);
}