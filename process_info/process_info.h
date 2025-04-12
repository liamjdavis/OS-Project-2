#ifndef PROCESS_INFO_H
#define PROCESS_INFO_H

#include "../types.h"

/* Structure to store process information */
typedef struct process_info {
    int pid;            // 4 bytes
    address_t sp;       // 4 bytes
    address_t pc;       // 4 bytes
    struct process_info* next;  // 4 bytes
    struct process_info* prev;  // 4 bytes
} process_info_t;

/* Global process management variables */
extern process_info_t* current_process;

/* Function prototypes */
process_info_t* insert_process(process_info_t* head, int pid, address_t sp, address_t pc);
process_info_t* delete_process(process_info_t* head, int pid);
void display_processes(process_info_t* head);

#endif // PROCESS_INFO_H
