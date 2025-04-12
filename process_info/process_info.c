#include "../memory_allocator/memory_alloc.h"
#include "../kernel-stub.h"
#include "process_info.h"
#include "../types.h"
#include "../linked_list.h"
#include "../utility/utility.h"

/* Function to insert a new process into the circular doubly linked list */
process_info_t* insert_process(process_info_t* head, int pid, address_t sp, address_t pc) {
    process_info_t* new_process = (process_info_t*)malloc(sizeof(process_info_t));
    if (!new_process) {
        print("Memory allocation failed\n");
        return head;
    }
    new_process->pid = pid;
    new_process->sp = sp;
    new_process->pc = pc;

    if (head == NULL) {
        new_process->next = new_process;
        new_process->prev = new_process;
        return new_process;
    } else {
        process_info_t* tail = head->prev;
        tail->next = new_process;
        new_process->prev = tail;
        new_process->next = head;
        head->prev = new_process;
        return new_process;
    }
}

/* Function to delete a process by PID */
process_info_t* delete_process(process_info_t* head, int pid) {
    if (head == NULL) return NULL;

    process_info_t *current = head;
    process_info_t *new_head = head;
    
    do {
        if (current->pid == pid) {
            process_info_t* prev = current->prev;
            process_info_t* next = current->next;
            
            // If this is the last process
            if (next == current) {
                free(current);
                return NULL;
            }
            
            // Update links
            prev->next = next;
            next->prev = prev;
            
            // If we're deleting the head, update new_head
            if (current == head) {
                new_head = next;
            }
            
            free(current);
            return new_head;
        }
        current = current->next;
    } while (current != head);
    
    return head;  // Process not found
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
        print(", SP: ");
        print(sp_str);
        print(", PC: ");
        print(pc_str);
        print("\n");
        
        temp = temp->next;
    } while (temp != head);
}