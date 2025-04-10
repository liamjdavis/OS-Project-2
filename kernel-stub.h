#if !defined (_KERNEL_STUB_H)
#define _KERNEL_STUB_H

#include "types.h"
#include "scheduler/scheduler.h"

/**
 * Copy the given PC value into CSR epc, then eret.
 * THIS FUNCTION DOES NOT RETURN.
 *
 * \param pc The program counter in the user-space program to which to jump.
 */
void userspace_jump (address_t pc);

/**
 * Search the device table for the n-th instance of a particular device type.
 *
 * \param type The code for the device type for which to search.
 * \param instance The instance number to find.
 * \return The address of the device table entry of the n-th instance of the given device type; <code>NULL</code> if no such
 *         instance was found.
 */
dt_entry_s* find_device (uint32_t type, uint32_t instance);

/**
 * Print a message to the console.
 *
 * \param msg The null-terminated string to print.
 */
void print (char* msg);

extern uint32_t none_device_code;
extern uint32_t controller_device_code;
extern uint32_t ROM_device_code;
extern uint32_t RAM_device_code;
extern uint32_t console_device_code;
extern uint32_t block_device_code;

extern address_t     kernel_limit;
extern address_t     RAM_limit;
extern DMA_portal_s* DMA_portal_ptr;

/* Scheduler-related variables */
extern uint32_t scheduler_active;
extern uint32_t time_quantum;
extern uint32_t saved_user_pc;
extern uint32_t saved_user_sp;
extern uint32_t saved_user_fp;
extern uint32_t saved_registers[32];
extern char* scheduler_start_msg;
extern char* scheduler_cycles_msg;

#endif /* _KERNEL_STUB_H */
