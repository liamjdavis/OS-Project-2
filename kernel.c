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
extern process_info_t* current_process;    // Points to currently running process in circular list
static word_t next_program_ROM = 3;              // Next ROM to load (starts at 3 since 1 is BIOS, 2 is kernel)
static int next_pid = 1;                         // Next process ID to assign
static address_t statics_limit;

/* =============================================================================================================================== */

/* =============================================================================================================================== */
void init_process_management() {
    current_process = NULL;    // No processes yet
    print("Process management system initialized.\n");
}
/* =============================================================================================================================== */

/* =============================================================================================================================== */
void init_memory(address_t kern_limit, address_t ram_limit) {
  address_t current_block_start = kern_limit;
  statics_limit = kern_limit - 4096;

  print("Initializing RAM free block list...\n");
  
  while (current_block_start + BLOCK_SIZE <= ram_limit) {
    free_block_s* new_block = (free_block_s*)current_block_start;
    new_block->next = free_list_head;
    free_list_head = new_block;
    current_block_start += BLOCK_SIZE;
  }

  heap_init(statics_limit);

  // Initialize process management
  init_process_management();

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

    print("Scheduling process\n");

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
    
    // Delete the exiting process and get new head
    process_info_t* new_head = delete_process(to_delete, exiting_pid);
    
    // Update current process based on deletion result
    if (new_head == NULL) {
        current_process = NULL;
        print("Process exited. No more processes to run.\n");
    } else {
        current_process = new_head;  // Safe because new_head is guaranteed to be valid
        print("Process exited. Scheduling next process.\n");
        // Schedule the next process
        schedule(current_process->sp, current_process->pc);
    }
}
/* =============================================================================================================================== */

/* =============================================================================================================================== */
void run_programs (uint32_t rom_number) {
    /* Find the specified program ROM in the device table. */
    char str_buffer[12];
    print("Searching for ROM #");
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

    /* Copy the program into first free block in RAM */
    free_block_s* free_block = free_list_head;

    // Update free block to point to next free block
    free_list_head = free_block->next;

    // Copy program from ROM to free block
    DMA_portal_ptr->src    = dt_ROM_ptr->base;
    DMA_portal_ptr->dst    = (address_t) free_block;
    DMA_portal_ptr->length = dt_ROM_ptr->limit - dt_ROM_ptr->base; // Trigger
    
    // Insert process into circular list
    current_process = insert_process(current_process, next_pid++, (address_t)(free_block + BLOCK_SIZE), (address_t)free_block);
    
    // Load new process state
    load_process_state(current_process);
} /* run_programs () */
/* =============================================================================================================================== */