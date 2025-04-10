#ifndef _SCHEDULER_H
#define _SCHEDULER_H

#include "../types.h"
#include "../process_info/process_info.h"

// Process states
#define PROCESS_READY     0
#define PROCESS_RUNNING   1
#define PROCESS_BLOCKED   2
#define PROCESS_TERMINATED 3

// Register context saved during context switch
typedef struct context {
    word_t regs[32];
    word_t pc;
    word_t sp;
    word_t fp;
} context_t;

// PCB - Process Control Block
typedef struct pcb {
    int pid;
    int state;
    context_t context;
    struct pcb* next;
} pcb_t;

// Scheduler functions
void scheduler_init(void);
void scheduler_add_process(word_t pc, word_t sp, word_t fp);
void scheduler_handle_alarm(void);
void context_switch(void);
pcb_t* scheduler_get_current_process(void);
pcb_t* scheduler_get_next_process(void);
void scheduler_terminate_current(void);

#endif /* _SCHEDULER_H */