#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "process_info.h"
#include "../types.h"

/* Structure to store process information */
typedef struct process_info {
    int pid;
    char name[50];
    void* sp;  // Stack pointer
    void* pc;  // Program counter
    struct process_info* next;
    struct process_info* prev;
} process_info_t;

/* Function to insert a new process into the circular doubly linked list */
void insert_process(process_info_t** head, int pid, const char* name, int priority, void* sp, void* pc) {
    process_info_t* new_process = (process_info_t*)malloc(sizeof(process_info_t));
    if (!new_process) {
        printf("Memory allocation failed\n");
        return;
    }
    new_process->pid = pid;
    strncpy(new_process->name, name, 50);
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
        printf("No processes available\n");
        return;
    }
    process_info_t* temp = head;
    do {
        printf("PID: %d, Name: %s, SP: %p, PC: %p\n", temp->pid, temp->name, temp->sp, temp->pc);
        temp = temp->next;
    } while (temp != head);
}
