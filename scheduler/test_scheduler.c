#include <stdio.h>
#include "scheduler.h"
#include "../types.h"
#include "../syscall-wrappers.h"

// Mock external variables that would be provided by kernel-stub.asm
word_t time_quantum = 0;
word_t saved_user_pc = 0;
word_t saved_user_sp = 0;
word_t saved_user_fp = 0;
word_t saved_registers[32] = {0};

// Mock address values for process code/stack
#define PROCESS1_PC 0x1000
#define PROCESS1_SP 0x2000
#define PROCESS1_FP 0x2000

#define PROCESS2_PC 0x3000
#define PROCESS2_SP 0x4000
#define PROCESS2_FP 0x4000

#define PROCESS3_PC 0x5000
#define PROCESS3_SP 0x6000
#define PROCESS3_FP 0x6000

// Function to print process details
void print_process(pcb_t* proc) {
    if (proc == NULL) {
        printf("Process: NULL\n");
        return;
    }
    
    printf("Process: PID=%d, State=%d, PC=0x%lx, SP=0x%lx, FP=0x%lx\n",
           proc->pid,
           proc->state,
           proc->context.pc,
           proc->context.sp,
           proc->context.fp);
}

// Function to simulate context switches and print state
void simulate_alarm_and_print_state() {
    pcb_t* before = scheduler_get_current_process();
    printf("\nBefore context switch: ");
    print_process(before);
    
    printf("Handling alarm interrupt...\n");
    scheduler_handle_alarm();
    
    pcb_t* after = scheduler_get_current_process();
    printf("After context switch: ");
    print_process(after);
    
    // Print whether we switched to a different process
    if (before != after) {
        printf("Context switch successful: Switched to a different process\n");
    } else if (before == NULL && after == NULL) {
        printf("No context switch performed: No processes available\n");
    } else {
        printf("Context switch performed, but stayed on same process (only one available)\n");
    }
}

int main() {
    printf("Initializing scheduler...\n");
    scheduler_init();
    
    printf("Initial time quantum: %lu\n", time_quantum);
    
    printf("\nAdding 3 processes...\n");
    scheduler_add_process(PROCESS1_PC, PROCESS1_SP, PROCESS1_FP);
    scheduler_add_process(PROCESS2_PC, PROCESS2_SP, PROCESS2_FP);
    scheduler_add_process(PROCESS3_PC, PROCESS3_SP, PROCESS3_FP);
    
    // First context switch - should select the first process
    printf("\n--- First context switch ---\n");
    simulate_alarm_and_print_state();
    
    // Set some register values to verify they're saved and restored
    printf("\nSetting register values for current process...\n");
    saved_registers[1] = 0xABCD;
    saved_registers[2] = 0x1234;
    
    // Second context switch - should move to the next process and save registers
    printf("\n--- Second context switch ---\n");
    simulate_alarm_and_print_state();
    
    // Third context switch - should move to the third process
    printf("\n--- Third context switch ---\n");
    simulate_alarm_and_print_state();
    
    // Fourth context switch - should wrap around to the first process
    printf("\n--- Fourth context switch (wraparound) ---\n");
    simulate_alarm_and_print_state();
    
    // Test process termination
    printf("\n--- Terminating current process ---\n");
    pcb_t* current = scheduler_get_current_process();
    printf("Terminating: ");
    print_process(current);
    
    scheduler_terminate_current();
    
    printf("After termination, current process: ");
    print_process(scheduler_get_current_process());
    
    // Two more context switches to verify remaining processes
    printf("\n--- Fifth context switch (after termination) ---\n");
    simulate_alarm_and_print_state();
    
    printf("\n--- Sixth context switch ---\n");
    simulate_alarm_and_print_state();
    
    // Terminate all remaining processes
    printf("\n--- Terminating all remaining processes ---\n");
    scheduler_terminate_current();
    scheduler_terminate_current();
    
    // Verify no processes remain
    printf("\nFinal state - should have no processes:\n");
    printf("Current process: ");
    print_process(scheduler_get_current_process());
    
    // Try a context switch with no processes
    printf("\n--- Final context switch attempt (no processes) ---\n");
    simulate_alarm_and_print_state();
    
    return 0;
}