#include "scheduler.h"
#include "../syscall-wrappers.h"
#include "../process_info/process_info.h"
#include "../memory_allocator/memory-alloc.h"
#include "../types.h"

// External references to kernel-stub.asm variables
extern word_t time_quantum;
extern word_t saved_user_pc;
extern word_t saved_user_sp;
extern word_t saved_user_fp;
extern word_t saved_registers[32];

// Scheduler state
static pcb_t* ready_queue = NULL;
static pcb_t* current_process = NULL;
static int next_pid = 1;

// Circular queue operations
void enqueue(pcb_t** queue, pcb_t* process) {
    if (*queue == NULL) {
        *queue = process;
        process->next = process;
    } else {
        pcb_t* last = *queue;
        while (last->next != *queue) {
            last = last->next;
        }
        last->next = process;
        process->next = *queue;
    }
}

pcb_t* dequeue(pcb_t** queue) {
    if (*queue == NULL) return NULL;
    
    pcb_t* process = *queue;
    
    if (process->next == process) {
        // Last process in queue
        *queue = NULL;
    } else {
        // Find the last process that points to the first
        pcb_t* last = process;
        while (last->next != process) {
            last = last->next;
        }
        *queue = process->next;
        last->next = *queue;
    }
    
    process->next = NULL;
    return process;
}

// Initialize the scheduler
void scheduler_init(void) {
    ready_queue = NULL;
    current_process = NULL;
    next_pid = 1;
    
    // Set default time quantum if not already set
    if (time_quantum == 0) {
        time_quantum = 10000;  // Default to 10,000 cycles
    }
}

// Add a new process to the scheduler
void scheduler_add_process(word_t pc, word_t sp, word_t fp) {
    pcb_t* new_process = (pcb_t*)malloc(sizeof(pcb_t));
    if (!new_process) return;
    
    // Initialize the PCB
    new_process->pid = next_pid++;
    new_process->state = PROCESS_READY;
    new_process->context.pc = pc;
    new_process->context.sp = sp;
    new_process->context.fp = fp;
    
    // Clear register context
    for (int i = 0; i < 32; i++) {
        new_process->context.regs[i] = 0;
    }
    
    // Add to ready queue
    enqueue(&ready_queue, new_process);
}

// Get the current running process
pcb_t* scheduler_get_current_process(void) {
    return current_process;
}

// Get next process to run
pcb_t* scheduler_get_next_process(void) {
    if (ready_queue == NULL) return NULL;
    
    pcb_t* next = dequeue(&ready_queue);
    next->state = PROCESS_RUNNING;
    
    // Add current process back to ready queue if it exists and is still runnable
    if (current_process != NULL && current_process->state == PROCESS_RUNNING) {
        current_process->state = PROCESS_READY;
        enqueue(&ready_queue, current_process);
    }
    
    return next;
}

// Save current process context
void save_context(void) {
    if (current_process == NULL) return;
    
    // Save registers from kernel-stub.asm saved area
    current_process->context.pc = saved_user_pc;
    current_process->context.sp = saved_user_sp;
    current_process->context.fp = saved_user_fp;
    
    // Save general registers
    for (int i = 0; i < 32; i++) {
        current_process->context.regs[i] = saved_registers[i];
    }
}

// Restore context for a process
void restore_context(pcb_t* process) {
    if (process == NULL) return;
    
    // Restore PC, SP, FP to kernel-stub.asm variables
    saved_user_pc = process->context.pc;
    saved_user_sp = process->context.sp;
    saved_user_fp = process->context.fp;
    
    // Restore general registers
    for (int i = 0; i < 32; i++) {
        saved_registers[i] = process->context.regs[i];
    }
}

// Perform a context switch
void context_switch(void) {
    // Save context of current process
    save_context();
    
    // Get next process to run
    pcb_t* next = scheduler_get_next_process();
    
    // If no process available, just return (kernel will handle it)
    if (next == NULL) {
        return;
    }
    
    current_process = next;
    
    // Restore context of next process
    restore_context(current_process);
}

// Handle alarm interrupt - this is called from alarm_handler in kernel-stub.asm
void scheduler_handle_alarm(void) {
    // If scheduler not initialized or no processes, just return
    if (ready_queue == NULL && current_process == NULL) {
        return;
    }
    
    // Perform context switch
    context_switch();
}

// Terminate the current process
void scheduler_terminate_current(void) {
    if (current_process == NULL) return;
    
    // Free the PCB
    current_process->state = PROCESS_TERMINATED;
    pcb_t* terminated = current_process;
    
    // Get next process to run
    pcb_t* next = scheduler_get_next_process();
    
    if (next == NULL) {
        // No more processes to run
        current_process = NULL;
    } else {
        current_process = next;
        restore_context(current_process);
    }
    
    free(terminated);
}