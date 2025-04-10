/* =============================================================================================================================== */
/* INCLUDES */

#include "kernel-stub.h"
#include "types.h"
/* =============================================================================================================================== */



/* =============================================================================================================================== */
/* CONSTANTS */

#define BYTES_PER_WORD  4
#define BITS_PER_BYTE   8
#define BITS_PER_NYBBLE 4
#define BLOCK_SIZE      0x8000 // 32 KB

static char hex_digits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

static free_block_s* free_list_head = NULL;
/* =============================================================================================================================== */



/* =============================================================================================================================== */
void int_to_hex (word_t value, char* buffer) {

  /* Traverse the value from most to least significant bits. */
  for (int shift = BYTES_PER_WORD * BITS_PER_BYTE - BITS_PER_NYBBLE; shift >= 0; shift -= BITS_PER_NYBBLE) {

    /* Grab the next nybble and add its corresponding digit to the string, advancing the string's pointer. */
    word_t nybble = (value >> shift) & 0xf;
    *buffer++ = hex_digits[nybble];
    
  }

  /* Finish the string with a null termination. */
  *buffer = '\0';
  
} /* int_to_hex () */
/* =============================================================================================================================== */


/* =============================================================================================================================== */
void init_memory(address_t kern_limit, address_t ram_limit) {
  address_t current_block_start = kern_limit; // Start allocating after kernel


  print("Initializing RAM free block list...\n");
  
  while (current_block_start + BLOCK_SIZE <= ram_limit) {
    free_block_s* new_block = (free_block_s*)current_block_start;
    new_block->next = free_list_head;
    free_list_head = new_block;
    current_block_start += BLOCK_SIZE;
  }

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
  print(" free blocks.");


} /* init_memory() */
/* =============================================================================================================================== */
void run_programs () {

  static word_t next_program_ROM = 3;
  
  /* Find the next program ROM in the device table. */
  char str_buffer[9];
  print("Searching for ROM #");
  int_to_hex(next_program_ROM, str_buffer);
  print(str_buffer);
  print("\n");
  dt_entry_s* dt_ROM_ptr = find_device(ROM_device_code, next_program_ROM++);
  if (dt_ROM_ptr == NULL) {
    return;
  }

  /* Initialize the scheduler if this is the first program */
  if (scheduler_active == 0) {
    print("Initializing scheduler...\n");
    scheduler_init();
    
    /* Display the time quantum */
    print(scheduler_start_msg);
    int_to_hex(time_quantum, str_buffer);
    print(str_buffer);
    print(scheduler_cycles_msg);
  }

  print("Running program...\n");

  /* Copy the program into the free RAM space after the kernel. */
  DMA_portal_ptr->src    = dt_ROM_ptr->base;
  DMA_portal_ptr->dst    = kernel_limit;
  DMA_portal_ptr->length = dt_ROM_ptr->limit - dt_ROM_ptr->base; // Trigger

  /* Add the program to the scheduler */
  scheduler_add_process(kernel_limit, RAM_limit, RAM_limit);

  /* Jump to the copied code at the kernel limit / program base. */
  userspace_jump(kernel_limit);
  
} /* run_programs () */
/* =============================================================================================================================== */