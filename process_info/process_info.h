#ifndef PROCESS_INFO_H
#define PROCESS_INFO_H

/* Structure to store process information */
typedef struct process_info {
    int pid;
    char name[50];
    void* sp;  // Stack pointer
    void* pc;  // Program counter
    struct process_info* next;
    struct process_info* prev;
} process_info_t;

/* Function prototypes */
void insert_process(process_info_t** head, int pid, const char* name, void* sp, void* pc);
void delete_process(process_info_t** head, int pid);
void display_processes(process_info_t* head);

#endif // PROCESS_INFO_H