/* =============================================================================================================================== */
/* INCLUDES */

#include "kernel-stub.h"
#include "types.h"
#include "process_info/process_info.h"
#include "utility/utility.h"
#include "heap_allocator/heap_alloc.h"
/* =============================================================================================================================== */

/* Function declarations */
void handle_process_exit(void);

/* =============================================================================================================================== */
/* CONSTANTS */

#define BYTES_PER_WORD  4
#define BITS_PER_BYTE   8
#define BITS_PER_NYBBLE 4
#define BLOCK_SIZE      0x8000 // 32 KB

static free_block_s* free_list_head = NULL;
static header_s* heap_free_list = NULL;     // Head of kernel heap's free blocks list
extern process_info_t* current_process;    // Points to currently running process in circular list
static word_t next_program_ROM = 3;              // Next ROM to load (starts at 3 since 1 is BIOS, 2 is kernel)
static int next_pid = 1;                         // Next process ID to assign

/* =============================================================================================================================== */

/* =============================================================================================================================== */
void init_process_management() {
    current_process = NULL;    // No processes yet
    print("Process management system initialized.\n");
}
/* =============================================================================================================================== */

/* =============================================================================================================================== */
void init_memory(address_t kern_limit, address_t ram_limit) {
  // Find kernel_end_marker
  extern char kernel_end_marker[];  // Defined in kernel-stub.asm
  address_t heap_start = (address_t)kernel_end_marker + 16; // Add 16 bytes to skip the marker string
  address_t current_block_start = kern_limit;

  print("Initializing RAM free block list...\n");
  
  while (current_block_start + BLOCK_SIZE <= ram_limit) {
    free_block_s* new_block = (free_block_s*)current_block_start;
    new_block->next = free_list_head;
    free_list_head = new_block;
    current_block_start += BLOCK_SIZE;
  }

  // Initialize process management
  init_process_management();

  // Initialize heap starting after kernel_end_marker and store free list head
  heap_free_list = heap_init(heap_start);

  // Debug print the number of blocks created
  int count = 0;
  free_block_s* temp = free_list_head;
  while(temp != NULL) {
    count++;
    temp = temp->next;
  }
  char count_str[9];
  print("Created ");
  int_to_hex(count, count_str);
  print(count_str);
  print(" free blocks. \n");
} /* init_memory() */
/* =============================================================================================================================== */

/* =============================================================================================================================== */
/* Function to schedule the next process to run */
process_info_t* schedule(address_t current_sp, address_t current_pc) {
    if (current_process == NULL) {
        print("No processes to schedule\n");
        return NULL;
    }

    // Update current process state
    current_process->sp = current_sp;
    current_process->pc = current_pc;
    
    // Move to next process in circular list
    current_process = current_process->next;

    print("Scheduling process: ");
    print(current_process->name);
    print("\n");

    return current_process;
}
/* =============================================================================================================================== */

/* =============================================================================================================================== */
/* Function to handle process exit and cleanup */
void handle_process_exit(void) {
    if (current_process == NULL) {
        print("No processes to exit\n");
        return;
    }

    // Store the process to delete
    process_info_t* to_delete = current_process;
    int exiting_pid = current_process->pid;

    // Move to prev process before deletion
    current_process = current_process->prev;
    
    // If this was the last process, set current_process to NULL
    if (current_process == to_delete) {
        current_process = NULL;
    }

    // Delete the exiting process
    delete_process(&current_process, exiting_pid);

    // Print status
    print("Process exited. ");
    if (current_process == NULL) {
        print("No more processes to run.\n");
    } else {
        print("Scheduling next process.\n");
        // Schedule the next process
        schedule(current_process->sp, current_process->pc);
    }
}
/* =============================================================================================================================== */

/* =============================================================================================================================== */
void run_programs (word_t rom_number) {
    /* Find the specified program ROM in the device table. */
    char str_buffer[12];
    print("Searching for ROM #");
    int_to_hex(rom_number, str_buffer);
    print(str_buffer);
    print("\n");
    
    // Debug: Print device code and ROM number
    print("ROM_device_code: ");
    int_to_hex(ROM_device_code, str_buffer);
    print(str_buffer);
    print(", rom_number: ");
    int_to_hex(rom_number, str_buffer);
    print(str_buffer);
    print("\n");
    
    dt_entry_s* dt_ROM_ptr = find_device(ROM_device_code, rom_number);
    if (dt_ROM_ptr == NULL) {
        print("ROM #");
        int_to_hex(rom_number, str_buffer);
        print(str_buffer);
        print(" not found. \n");
        return;
    }

    print("Running program...\n");

    /* Copy the program into the free RAM space after the kernel. */
    DMA_portal_ptr->src    = dt_ROM_ptr->base;
    DMA_portal_ptr->dst    = kernel_limit;
    DMA_portal_ptr->length = dt_ROM_ptr->limit - dt_ROM_ptr->base; // Trigger

    /* Create process info entry */
    char program_name[52];
    copy_str(program_name, "Program-", 52);
    char num_str[9];
    int_to_dec(rom_number, num_str);
    int name_len = 0;
    while (program_name[name_len] != '\0') name_len++;
    copy_str(program_name + name_len, num_str, 52 - name_len);
    
    // Insert process into circular list
    process_info_t** list_ptr = current_process ? &current_process : NULL;
    insert_process(list_ptr, next_pid++, program_name, (address_t)(kernel_limit + BLOCK_SIZE), (address_t)kernel_limit);
    
    // Debug: Print process list after insertion
    print("Process list after insertion:\n");
    display_processes(current_process);
    
    // If this is the first process, schedule it
    if (current_process == NULL || current_process->next == current_process) {
        print("First process - scheduling...\n");
        schedule((address_t) NULL, (address_t) NULL);  // First schedule call
        print("After scheduling:\n");
        display_processes(current_process);
    }

    /* Jump to the copied code at the kernel limit / program base. */
    print("Jumping to userspace...\n");
    userspace_jump(kernel_limit);
  
} /* run_programs () */
/* =============================================================================================================================== */