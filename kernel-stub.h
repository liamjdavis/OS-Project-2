#if !defined (_KERNEL_STUB_H)
#define _KERNEL_STUB_H

#include "types.h"
#include "process_info/process_info.h"

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

/**
 * Run a program from the specified ROM number.
 *
 * \param rom_number The ROM number to load and execute.
 */
void run_programs(uint32_t rom_number);

/**
 * Loads process state and sets up next alarm.
 *
 * @param process_info Address of process_info structure
 */
void load_process_state(process_info_t* process_info);

extern uint32_t none_device_code;
extern uint32_t controller_device_code;
extern uint32_t ROM_device_code;
extern uint32_t RAM_device_code;
extern uint32_t console_device_code;
extern uint32_t block_device_code;

extern address_t     kernel_limit;
extern DMA_portal_s* DMA_portal_ptr;

#endif /* _KERNEL_STUB_H */
