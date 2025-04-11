#include "../memory_allocator/memory_alloc.h"
#include "../kernel-stub.h"
#include "process_info.h"
#include "../types.h"
#include "../linked_list.h"
#include "../utility/utility.h"

/* Function to insert a new process into the circular doubly linked list */
void insert_process(process_info_t** head, int pid, const char* name, address_t sp, address_t pc) {
    process_info_t* new_process = (process_info_t*)malloc(sizeof(process_info_t));
    if (!new_process) {
        print("Memory allocation failed\n");
        return;
    }
    new_process->pid = pid;
    copy_str(new_process->name, name, 50);
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
        print("No processes available\n");
        return;
    }
    process_info_t* temp = head;
    do {
        char pid_str[9];
        char sp_str[9];
        char pc_str[9];
        
        int_to_hex(temp->pid, pid_str);
        int_to_hex((word_t)temp->sp, sp_str);
        int_to_hex((word_t)temp->pc, pc_str);
        
        print("PID: ");
        print(pid_str);
        print(", Name: ");
        print(temp->name);
        print(", SP: ");
        print(sp_str);
        print(", PC: ");
        print(pc_str);
        print("\n");
        
        temp = temp->next;
    } while (temp != head);
}