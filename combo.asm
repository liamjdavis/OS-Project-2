### ================================================================================================================================
### kernel-stub.asm
### Scott F. Kaplan -- sfkaplan@amherst.edu
###
### The assembly core that perform the basic initialization of the kernel, bootstrapping the installation of trap handlers and
### configuring the kernel's memory space.
###
### v.2025-02-11 : Load and execute a sequence of processes.
### v.2025-02-18 : Just the stub code, leaving other functions to be written in C.
### ================================================================================================================================


### ================================================================================================================================
	.Code
### ================================================================================================================================

### ================================================================================================================================
### Entry point.

__start:	
	## Find RAM.  Start the search at the beginning of the device table.
	lw		t0,		device_table_base			# [t0] dt_current = &device_table[0]
	lw		s0,		none_device_code			# [s0] none_device_code
	lw		s1,		RAM_device_code				# [s1] RAM_device_code
	
RAM_search_loop_top:

	## End the search with failure if we've reached the end of the table without finding RAM.
	lw		t1,		0(t0) 					# [t1] device_code = dt_current->type_code
	beq		t1,		s0,		RAM_search_failure 	# if (device_code == none_device_code)

	## If this entry is RAM, then end the loop successfully.
	beq		t1,		s1,		RAM_found 		# if (device_code == RAM_device_code)

	## This entry is not RAM, so advance to the next entry.
	addi		t0,		t0,		12 			# [t0] dt_current += dt_entry_size
	j		RAM_search_loop_top

RAM_search_failure:

	## Record a code to indicate the error, and then halt.
	lw		a0,		kernel_error_RAM_not_found
	halt

RAM_found:
	
	## RAM has been found.  If it is big enough, create a stack.
	lw		t1,		4(t0) 					# [t1] RAM_base  = dt_RAM->base
	lw		t2,		8(t0)					# [t2] RAM_limit = dt_RAM->limit
	sub		t0,		t2,		t1			# [t0] |RAM| = RAM_limit - RAM_base
	lw		t3,		min_RAM					# [t3] min_RAM
	blt		t0,		t3,		RAM_too_small		# if (|RAM| < min_RAM) ...
	lw		t3,		kernel_size				# [t3] ksize
	add		sp,		t1,		t3			# [sp] klimit = RAM_base + ksize : new stack
	mv		fp,		sp					# Initialize fp

	## Copy the RAM and kernel bases and limits to statically allocated spaces.
	sw		t1,		RAM_base,	t6
	sw		t2,		RAM_limit,	t6
	sw		t1,		kernel_base,	t6	
	sw		sp,		kernel_limit,	t6

	## Grab the DMA portal's address for later.
	lw		t0,		device_table_base			# [t0] device_table_base
	lw		t0,		8(t0)					# [t0] device_table_limit
	addi		t0,		t0,		-12			# [t0] DMA_portal_ptr
	sw		t0,		DMA_portal_ptr,	t6

	## With the stack initialized, call main() to begin booting proper.
	call		main

	## End the kernel.  Termination code has already been returned by main() in a0.
	halt

RAM_too_small:
	## Set an error code and halt.
	lw		a0,		kernel_error_small_RAM
	halt
### ================================================================================================================================



### ================================================================================================================================	
### Procedure: find_device
### Parameters:
###   [a0]: type     -- The device type to find.
###   [a1]: instance -- The instance of the given device type to find (e.g., the 3rd ROM).
### Caller preserved registers:
###   [s0/fp + 0]: pfp
### Return address (preserved if needed):
###   [s0/fp + 4]: pra
### Return value:
###   [a0]: If found, a pointer to the correct device table entry, otherwise, null.
### Locals:
###   [t0]: current_ptr  -- The current pointer into the device table.
###   [t1]: current_type -- The current entry's device type.
###   [t2]: none_type    -- The null device type code.

find_device:

	## No calls nor values pushed onto the stack, so no prologue needed.
	
	##   Initialize the locals.
	lw		t0,		device_table_base				# current_ptr = dt_base
	lw		t2,		none_device_code				# none_type
	
find_device_loop_top:

	## End the search with failure if we've reached the end of the table without finding the device.
	lw		t1,		0(t0)						# current_type = current_ptr->type
	beq		t1,		t2,		find_device_loop_failure	# while (current_type == none_type) {

	## If this entry matches the device type we seek, then decrement the instance count.  If the instance count hits zero, then
	## the search ends successfully.
	bne		t1,		a0,		find_device_continue_loop	#   if (current_type == type) {
	addi		a1,		a1,		-1				#     instance--
	beqz		a1,		find_device_loop_success			#     if (instance == 0) break }
	
find_device_continue_loop:	

	## Advance to the next entry.
	addi		t0,		t0,		12				#   current_ptr++
	j		find_device_loop_top						# }

find_device_loop_failure:

	## Set the return value to a null pointer.
	li		a0,		0						# rv = null
	j		find_device_return

find_device_loop_success:

	## Set the return pointer into the device table that currently points to the given iteration of the given type.
	mv		a0,		t0						# rv = current_ptr
	## Fall through...
	
find_device_return:

	## Epilogue: Return.
	ret
### ================================================================================================================================



### ================================================================================================================================
### Procedure: print
### Preserved registers:
###   [fp + 0]: pfp
### Parameters:
###   [a0]: str_ptr -- A pointer to the beginning of a null-terminated string.
### Return address:
###   [ra / fp + 4]
### Return value:
###   <none>
### Preserved registers:
###   [fp -  4]: a0
###   [fp -  8]: s1
###   [fp - 12]: s2
###   [fp - 16]: s3
###   [fp - 20]: s4
###   [fp - 24]: s5
###   [fp - 28]: s6
### Locals:
###   [s1]: current_ptr        -- Pointer to the current position in the string.
###   [s2]: console_buffer_end -- The console buffer's limit.
###   [s3]: cursor_column      -- The current cursor column (always on the bottom row).
###   [s4]: newline_char       -- A copy of the newline character.
###   [s5]: cursor_char        -- A copy of the cursor character.
###   [s6]: console_width      -- The console's width.
	
print:

	## Callee prologue: Push preserved registers.
	addi		sp,		sp,		-32
	sw		ra,		28(sp)					# Preserve ra
	sw		fp,		24(sp)					# Preserve fp
	sw		s1,		20(sp)
	sw		s2,		16(sp)
	sw		s3,		12(sp)
	sw		s4,		8(sp)
	sw		s5,		4(sp)
	sw		s6,		0(sp)
	addi		fp,		sp,		32

	## Initialize locals.
	mv		s1,		a0					# current_ptr = str_ptr
	lw		s2,		console_limit				# console_limit
	addi		s2,		s2,		-4			# console_buffer_end = console_limit - |word|
										#   (offset portal)
	lw		s3,		cursor_column				# cursor_column
	lb		s4,		newline_char
	lb		s5,		cursor_char
	lw		s6,		console_width

	## Loop through the characters of the given string until the terminating null character is found.
loop_top:
	lb		t0,		0(s1)					# [t0] current_char = *current_ptr

	## The loop should end if this is a null character
	beqz		t0,		loop_end

	## Scroll without copying the character if this is a newline.
	beq		t0,		s4,		_print_scroll_call

	## Assume that the cursor is in a valid location.  Copy the current character into it.
	sub		t1,		s2,		s6			# [t0] = console[limit] - width
	add		t1,		t1,		s3			#      = console[limit] - width + cursor_column
	sb		t0,		0(t1)					# Display current char @t1.
	
	## Advance the cursor, scrolling if necessary.
	addi		s3,		s3,		1			# cursor_column++
	blt		s3,		s6,		_print_scroll_end       # Skip scrolling if cursor_column < width

_print_scroll_call:
	sw		s3,		cursor_column,	t6			# Copy back global used by scroll_console()
	call		scroll_console
	lw		s3,		cursor_column				# Reload global updated by scroll_console()

_print_scroll_end:
	## Place the cursor character in its new position.
	sub		t1,		s2,		s6			# [t1] = console[limit] - width
	add		t1,		t1,		s3			#      = console[limit] - width + cursor_column
	sb		s5,		0(t1)					# Display cursor char @t1.
	
	## Iterate by advancing to the next character in the string.
	addi		s1,		s1,		1
	j		loop_top

loop_end:
	## Callee Epilogue...
	
	##   Store cursor_column back into statics for the next call.
	sw		s3,		cursor_column,	t6			# Store cursor_column (static)
	
	##   Pop and restore preserved registers, then return.
	addi		sp,		fp,		-32			# Pop extras that may have been added to the stack.
	lw		s6,		0(sp)					# Restore s[1-6]
	lw		s5,		4(sp)
	lw		s4,		8(sp)
	lw		s3,		12(sp)
	lw		s2,		16(sp)
	lw		s1,		20(sp)
	lw		fp,		24(sp)					# Restore fp
	lw		ra,		28(sp)					# Restore ra
	addi		sp,		sp,		32
	ret
### ================================================================================================================================



### ================================================================================================================================
### Procedure: scroll_console
### Description: Scroll the console and reset the cursor at the 0th column.
### Preserved frame pointer:
###   [fp + 0]: pfp
### Parameters:
###   <none>
### Return address:
###   [fp + 4]
### Return value:
###   <none>
### Locals:
###   [t0]: console_buffer_end / console_offset_ptr
###   [t1]: console_width
###   [t2]: console_buffer_begin
###   [t3]: cursor_column
###   [t4]: screen_size	
	
scroll_console:

	## No calls performed, no values pushed onto the stack, so no frame created.
	
	## Initialize locals.
	lw		t2,		console_base				# console_buffer_begin = console_base
	lw		t0,		console_limit				# console_limit
	addi		t0,		t0,		-4			# console_buffer_end = console_limit - |word|
	                                                                        #   (offset portal)
	lw		t1,		console_width				# console_width
	lw		t3,		cursor_column				# cursor_column
	lw		t4,		console_height				# t4 = console_height
	mul		t4,		t1,		t4			# screen_size = console_width * console_height
	
	## Blank the top line.
	lw		t5,		device_table_base       	        # t5 = dt_controller_ptr
	lw		t5,		8(t5)					#    = dt_controller_ptr->limit
	addi		t5,		t5,		-12			# DMA_portal_ptr = dt_controller_ptr->limit - 3*|word|
	la		t6,		blank_line				# t6 = &blank_line
	sw		t6,		0(t5)					# DMA_portal_ptr->src = &blank_line
	sw		t2,		4(t5)					# DMA_portal_ptr->dst = console_buffer_begin
	sw		t1,		8(t5)					# DMA_portal_ptr->len = console_width

	## Clear the cursor if it isn't off the end of the line.
	beq		t1,		t3,		_scroll_console_update_offset	# Skip if width == cursor_column
	sub		t5,		t0,		t1			# t5 = console_buffer_end - width
	add		t5,		t5,		t3			#    = console_buffer_end - width + cursor_column
	lb		t6,		space_char
	sb		t6,		0(t5)

	## Update the offset, wrapping around if needed.
_scroll_console_update_offset:
	lw		t6,		0(t0)					# [t6] offset
	add		t6,		t6,		t1			# offset += column_width
	rem		t6,		t6,		t4			# offset %= screen_size
	sw		t6,		0(t0)					# Set offset in console
	
	## Reset the cursor at the start of the new line.
	li		t3,		0					# cursor_column = 0
	sw		t3,		cursor_column,	t6			# Store cursor_column
	lb		t6,		cursor_char				# cursor_char
	sub		t5,		t0,		t1			# t5 = console_buffer_end - width (cursor_column == 0)	
	sb		t6,		0(t5)
	
	## Return.
	ret
### ================================================================================================================================



### ================================================================================================================================
### Procedure: load_process_state
### Description: Loads process state and sets up next alarm
### Parameters:
###   [a0]: process_info pointer
### Preserved registers:
###   [sp + 0]: ra
### Return:
###   None - sets EPC directly

load_process_state:
	# First save the kernel's SP in a temporary register
	mv      t3, sp              # Save kernel's SP in t3

	# Load new process state
	lw      t1, 4(a0)         # Load new SP (offset: pid[4])
	lw      t2, 8(a0)         # Load new PC (offset: after sp)

	# Set up next alarm while keeping MSB clear
	csrr    t0, ck            # Get current cycle count
	lw      t1, QUANTA_CYCLES # Load QUANTA_CYCLES value
	add     t1, t0, t1        # Add current cycle count + QUANTA_CYCLES
	csrw    al, t1            # Set next alarm

	# Enable alarm bit (bit 4) in mode register
	csrr    t0, md                  # Read current mode
	ori     t0, t0, 0x10          # Set alarm byte (bit 4)
	csrw    md, t0                 # Write back to mode register

	# Set EPC to the new PC value before returning
	csrw    epc, t2          # Set EPC to new PC value

	# Now set the user's stack pointer last, right before eret
	# mv      sp, t1            # Some kind of bug where the eret needs the sp

	eret

### ================================================================================================================================
### Procedure: syscall_handler

syscall_handler:
	# Disable alarm interrupts by setting MSB of alarm register
	csrr    t0, al                  # Read current alarm value
	li      t1, 0x80000000         # Create mask with MSB=1
	or      t0, t0, t1             # Set MSB to disable alarm (makes it far in future)
	csrw    al, t0                 # Write back to alarm register

	mv s1, a1 # Save any auxiliary info (e.g., RUN call ROM number)
	csrr s2, epc # save the epc

	# Update current process's PC to point to next instruction
	la t0, current_process
	lw t0, 0(t0)
	addi t1, s2, 4         # Calculate next instruction address (current EPC + 4)
	sw t1, 8(t0)           # Store in process's PC field (offset 8 from process_info_t struct)

	## Reset kernel's stack and frame pointers.
	lw		fp,		kernel_limit
	lw		sp,		kernel_limit

	# Print sys_call_made_msg
	addi    sp, sp, -4      # Save a0 since we need it for print
	sw      a0, 0(sp)       # Store original syscall code
	la      a0, sys_call_made_msg
	call    print
	lw      a0, 0(sp)       # Restore original syscall code
	addi    sp, sp, 4       # Restore stack pointer

	# Save received syscall code
	mv s0, a0

	# Print received syscall code
	la a0, debug_received_msg
	call print
	mv a0, s0
	addi sp, sp, -16
	mv a1, sp
	call int_to_hex
	mv a0, sp
	call print
	la a0, newline_char
	call print

	# Restore syscall code
	mv a0, s0

	## Dispatch on the requested syscall.
	lw		t0,		syscall_EXIT
	beq		a0,		t0,		handle_exit			# Is it an EXIT request?

	lw t0, syscall_RUN
	beq a0, t0, handle_run

	lw t0, syscall_PRINT
	beq a0, t0, handle_print
	
	## The syscall code is invalid, so print an error message and halt.
	la		a0,		invalid_syscall_code_msg			# Print failure.
	call		print
	j		syscall_handler_halt

handle_exit:
	## An exit was requested. Save registers.
	addi		sp,		sp,		-8
	sw		ra,		4(sp)						# Preserve ra
	sw		fp,		0(sp)						# Preserve fp
	addi		fp,		sp,		8				# Set fp
	
	## Show that we got here.
	la		a0,		exit_msg					# Print EXIT occurrence.
	call		print

	## Handle process exit and cleanup
	call		handle_process_exit

	## If we get here and there are no more processes, halt the system
	la		t0,		current_process		# Get address of current_process variable
	lw		t0,		0(t0)			# Load value (pointer) stored at that address
	beqz		t0,		exit_system		# If current_process is NULL, exit
	

	# Load new process state
	la      a0, current_process  # Get address of current_process variable
	lw a0, 0(a0)
	call    load_process_state

exit_system:
	## Print final message and halt
	la		a0,		all_programs_run_msg
	call		print
	j		syscall_handler_halt

handle_run:
    # Move ROM number from s1 to a0 for run_programs
    mv a0, s1
    call run_programs
    
    # Set success return value and return to user mode
    call    load_process_state

handle_print:
	# Move string pointer to a0
	mv a0, a1
	call print

	# Re-enable alarm interrupts by setting next alarm time with MSB clear
	csrr    t0, ck                 # Get current cycle count
	lw      t1, QUANTA_CYCLES      # Load QUANTA_CYCLES value
	add     t0, t0, t1             # Next alarm at current + QUANTA_CYCLES
	csrw    al, t0                 # Set alarm register with enabled value

	csrw epc, s2
	eret

syscall_handler_halt:
	## Halt.  No need to preserve/restore state, because we're halting.
	la		a0,		halting_msg					# Print halting.
	call		print
	halt
### ================================================================================================================================


	
### ================================================================================================================================
### Procedure: default_handler

default_handler:

	# If we are here, we probably want to look around.
	ebreak
	
	## Reset the kernel's stack and frame pointers.
	lw		fp,		kernel_limit
	lw		sp,		kernel_limit
	
	## Print a message to show that we got here.
	la		a0,		default_handler_msg
	call		print
	
	## Then halt, because we don't know what to do next.
	la		a0,		halting_msg
	call		print
	lw		a0,		kernel_error_unmanaged_interrupt
	halt
### ================================================================================================================================

### ================================================================================================================================
### Procedure: alarm_handler
### Description: Handles CLOCK_ALARM interrupts for process scheduling
### The handler:
### 1. Saves current process state (SP and PC)
### 2. Calls C scheduler to select next process
### 3. Loads new process state and sets up next alarm
### 4. Returns to new process via eret

alarm_handler:
	la a0, alarm_interupt_msg
	call print

	# First save the user's SP before we modify it
	mv      a0, sp              # Save user's SP in t0
	csrr    a1, epc            # Get EPC from CSR

	addi a1, a1, 4 # increment user pc

	# Call C scheduler with user SP and PC
	call    schedule           # Schedule will update current_process pointer

	# Load new process state
	la      t0, current_process  # Get address of current_process variable
	lw      a1, 0(t0)           # Load value (pointer) stored at that address
	call    load_process_state
### ================================================================================================================================


	
### ================================================================================================================================
### Procedure: init_trap_table
### Caller preserved registers:	
###   [fp + 0]:      pfp
###   [ra / fp + 4]: pra
### Parameters:
###   [a0]: trap_base -- The address of the trap table to initialize and enable.
### Return value:
###   <none>
### Callee preserved registers:
###   <none>
### Locals:
###   [t0]: default_handler_ptr -- A pointer to the default interrupt handler

init_trap_table:

	## Set the 13 entries to point to some interrupt handler.
	la		t0,		default_handler				# t0 = default_handler()
	la		t1,		syscall_handler				# t1 = syscall_handler()
	la		t2,		alarm_handler				# t2 = alarm_handler()
	sw		t0,		0x00(a0)				# tt[INVALID_ADDRESS]      = default_handler()
	sw		t0,		0x04(a0)				# tt[INVALID_REGISTER]     = default_handler()
	sw		t0,		0x08(a0)				# tt[BUS_ERROR]            = default_handler()
	sw		t2,		0x0c(a0)				# tt[CLOCK_ALARM]          = alarm_handler()
	sw		t0,		0x10(a0)				# tt[DIVIDE_BY_ZERO]       = default_handler()
	sw		t0,		0x14(a0)				# tt[OVERFLOW]             = default_handler()
	sw		t0,		0x18(a0)				# tt[INVALID_INSTRUCTION]  = default_handler()
	sw		t0,		0x1c(a0)				# tt[PERMISSION_VIOLATION] = default_handler()
	sw		t0,		0x20(a0)				# tt[INVALID_SHIFT_AMOUNT] = default_handler()
	sw		t1,		0x24(a0)				# tt[SYSTEM_CALL]          = syscall_handler()
	sw		t0,		0x28(a0)				# tt[SYSTEM_BREAK]         = default_handler()
	sw		t0,		0x2c(a0)				# tt[INVALID_DEVICE_VALUE] = default_handler()
	sw		t0,		0x30(a0)				# tt[DEVICE_FAILURE]       = default_handler()

	## Set the TBR to point to the trap table, and the IBR to point to the interrupt buffer.
	csrw		tb,		a0					# tb = trap_base
	ret
### ================================================================================================================================



### ================================================================================================================================
### Procedure: userspace_jump

userspace_jump:
	lw		sp,		RAM_limit
	lw		fp,		RAM_limit
	csrw		epc,		a0
	eret
### ================================================================================================================================
	
### ================================================================================================================================
### Procedure: run_program
###   [a0]: ROM_number -- The ROM number to run
### Return value:
###   [a0]: 0 = success, 1 = invalid ROM number, 2 = insufficient RAM, 3 = other error
### ================================================================================================================================

run_programs_done:
	## Epilogue
	lw ra, 4(sp)
	lw fp, 0(sp)
	addi sp, sp, 8
	ret

run_program_invalid:
    li a0, 1                     # Return invalid ROM number error

run_program_return:
	## Epilogue
	lw ra, 4(sp)
	lw fp, 0(sp)
	addi sp, sp, 8
	ret
### ================================================================================================================================
### Procedure: main
### Preserved registers:
###   [fp + 0]:      pfp
###   [ra / fp + 4]: pra
### Parameters:
###   <none>
### Return value:
###   [a0]: exit_code
### Preserved registers:
###   <none>
### Locals:
###   <none>

main:

	## Prologue.
	addi		sp,		sp,		-8
	sw		ra,		4(sp)						# Preserve ra
	sw		fp,		0(sp)						# Preserve fp
	addi		fp,		sp,		8				# Set fp

	## Call find_device() to get console info.
	lw		a0,		console_device_code				# arg[0] = console_device_code
	li		a1,		1						# arg[1] = 1 (first instance)
	call		find_device							# [a0] rv = dt_console_ptr
	bnez		a0,		main_with_console				# if (dt_console_ptr == NULL) ...
	lw		a0,		kernel_error_console_not_found			# Return with failure code
	halt

main_with_console:
	## Copy the console base and limit into statics for later use.
	lw		t0,		4(a0)						# [t0] dt_console_ptr->base
	sw		t0,		console_base,		t6
	lw		t0,		8(a0)						# [t0] dt_console_ptr->limit
	sw		t0,		console_limit,		t6
	
	## Call print() on the banner and attribution.
	la		a0,		banner_msg					# arg[0] = banner_msg
	call		print
	la		a0,		attribution_msg					# arg[0] = attribution_msg
	call		print

	## Call init_trap_table(), then finally restore the frame.
	la		a0,		initializing_tt_msg				# arg[0] = initializing_tt_msg
	call		print
	la		a0,		trap_table
	call		init_trap_table
	la		a0,		done_msg					# arg[0] = done_msg
	call		print

	## Call init_memory(kern_limit, ram_limit) to divide RAM into 32 KB blocks and create free block tracking structure
	lw a0, kernel_limit
	lw a1, RAM_limit
	call init_memory

			## Initialize alarm system - do this just before running first program
	
	## Call run_programs() to invoke ROM 3
	addi a0, zero, 3  # Start with ROM #3 (after BIOS and kernel)
	call run_programs

main_no_program:
	## Epilogue: If we reach here, there were no ROMs, so use the frame to emit an error message and halt.
	la		a0,		no_programs_msg
	call		print
	la		a0,		halting_msg
	call		print
	lw		a0,		kernel_normal_exit				# Set the result code
	halt
### ================================================================================================================================
	

	
### ================================================================================================================================
	.Numeric

	## A special marker that indicates the beginning of the statics.  The value is just a magic cookie, in case any code wants
	## to check that this is the correct location (with high probability).
statics_start_marker:	0xdeadcafe

	## The trap table.  An array of 13 function pointers, to be initialized at runtime.
trap_table:             0
			0
			0
			0
			0
			0
			0
			0
			0
			0
			0
			0
			0

	## The interrupt buffer, used to store auxiliary information at the moment of an interrupt.
interrupt_buffer:	0 0 
	
	## Device table location and codes.
device_table_base:	0x00001000
none_device_code:	0
controller_device_code:	1
ROM_device_code:	2
RAM_device_code:	3
console_device_code:	4
block_device_code:	5

	## Error codes.
kernel_normal_exit:			0xffff0000
kernel_error_RAM_not_found:		0xffff0001
kernel_error_small_RAM:			0xffff0002	
kernel_error_console_not_found:		0xffff0003
kernel_error_unmanaged_interrupt:	0xffff0004

	## Syscall codes
syscall_EXIT:		0xca110001
syscall_RUN: 0xca110002
syscall_PRINT: 0xca110003

	## Constants for printing and console management.
console_width:		80
console_height:		24

	## Other constants.
min_RAM:		0x10000 # 64 KB = 0x40 KB * 0x400 B/KB
bytes_per_page:		0x1000	# 4 KB/page
kernel_size:		0x8000	# 32 KB = 0x20 KB * 0x4 B/KB taken by the kernel.

	## Statically allocated variables.
cursor_column:		0	# The column position of the cursor (always on the last row).
RAM_base:		0
RAM_limit:		0
console_base:		0
console_limit:		0
kernel_base:		0
kernel_limit:		0
DMA_portal_ptr:		0

current_process:		0	# Pointer to currently running process

QUANTA_CYCLES:		1000    # Number of cycles per time quantum
### ================================================================================================================================



### ================================================================================================================================
	.Text

space_char:			" "
cursor_char:			"_"
newline_char:			"\n"
banner_msg:			"Fivish kernel v.2025-03-02\n"
attribution_msg:		"COSC-275 : Systems-II\n"
halting_msg:			"Halting kernel..."
initializing_tt_msg:		"Initializing trap table..."
running_program_msg:		"Running next program ROM...\n"
invalid_syscall_code_msg:	"Invalid syscall code provided.\n"
exit_msg:			"EXIT requested.\n"
all_programs_run_msg:		"All programs have been run.\n"
no_programs_msg:		"ERROR: No programs provided.\n"
default_handler_msg:		"Default interrupt handler invoked.\n"
done_msg:			"done.\n"
failed_msg:			"failed!\n"
blank_line:			"                                                                                "
run_programs_success: "All programs have been run successfully.\n"
debug_received_msg: "Received syscall: 0x"
debug_exit_msg: "EXIT code is: 0x"
sys_call_made_msg: "System call made.\n"
alarm_interupt_msg: "Alarm interupt occured. Switching processes...\n"
### ================================================================================================================================
	.Code
init_process_management:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
kernel_autoL0:
	auipc	a1, %hi(%pcrel(current_process))
	li	a0, 0 
	sw	a0, %lo(%larel(current_process,kernel_autoL0))(a1)
kernel_autoL1:
	auipc	a0, %hi(%pcrel(kernel_L.str))
	addi	a0, a0, %lo(%larel(kernel_L.str,kernel_autoL1))
	call	print 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
kernel_Lfunc_end0:
	#	-- End function 
init_memory:
	#	%bb.0: 
	addi	sp, sp, -48 
	sw	ra, 44(sp) # 4-byte Folded Spill 
	sw	s0, 40(sp) # 4-byte Folded Spill 
	addi	s0, sp, 48 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	lw	a0, -12(s0) 
	sw	a0, -20(s0) 
	lw	a0, -12(s0) 
	addi	a0, a0, -2048 
	addi	a0, a0, -2048 
kernel_autoL2:
	auipc	a1, %hi(%pcrel(statics_limit))
	sw	a0, %lo(%larel(statics_limit,kernel_autoL2))(a1)
kernel_autoL3:
	auipc	a0, %hi(%pcrel(kernel_L.str.1))
	addi	a0, a0, %lo(%larel(kernel_L.str.1,kernel_autoL3))
	call	print 
	j	kernel_LBB1_1 
kernel_LBB1_1:
	lw	a0, -20(s0) 
	lui	a1, 8 
	add	a1, a0, a1 
	lw	a0, -16(s0) 
	bltu	a0, a1, kernel_LBB1_3 
	j	kernel_LBB1_2 
kernel_LBB1_2:
	lw	a0, -20(s0) 
	sw	a0, -24(s0) 
kernel_autoL4:
	auipc	a1, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL4))(a1)
	lw	a2, -24(s0) 
	sw	a0, 0(a2) 
	lw	a0, -24(s0) 
	sw	a0, %lo(%larel(free_list_head,kernel_autoL4))(a1)
	lw	a0, -20(s0) 
	lui	a1, 8 
	add	a0, a0, a1 
	sw	a0, -20(s0) 
	j	kernel_LBB1_1 
kernel_LBB1_3:
kernel_autoL5:
	auipc	a0, %hi(%pcrel(statics_limit))
	lw	a0, %lo(%larel(statics_limit,kernel_autoL5))(a0)
	call	heap_init 
	call	init_process_management 
	li	a0, 0 
	sw	a0, -28(s0) 
kernel_autoL6:
	auipc	a0, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL6))(a0)
	sw	a0, -32(s0) 
	j	kernel_LBB1_4 
kernel_LBB1_4:
	lw	a0, -32(s0) 
	beqz	a0, kernel_LBB1_6 
	j	kernel_LBB1_5 
kernel_LBB1_5:
	lw	a0, -28(s0) 
	addi	a0, a0, 1 
	sw	a0, -28(s0) 
	lw	a0, -32(s0) 
	lw	a0, 0(a0) 
	sw	a0, -32(s0) 
	j	kernel_LBB1_4 
kernel_LBB1_6:
kernel_autoL7:
	auipc	a0, %hi(%pcrel(kernel_L.str.2))
	addi	a0, a0, %lo(%larel(kernel_L.str.2,kernel_autoL7))
	call	print 
	lw	a0, -28(s0) 
	addi	a1, s0, -41 
	sw	a1, -48(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -48(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL8:
	auipc	a0, %hi(%pcrel(kernel_L.str.3))
	addi	a0, a0, %lo(%larel(kernel_L.str.3,kernel_autoL8))
	call	print 
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
kernel_Lfunc_end1:
	#	-- End function 
schedule:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -16(s0) 
	sw	a1, -20(s0) 
kernel_autoL9:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,kernel_autoL9))(a0)
	bnez	a0, kernel_LBB2_2 
	j	kernel_LBB2_1 
kernel_LBB2_1:
kernel_autoL10:
	auipc	a0, %hi(%pcrel(kernel_L.str.4))
	addi	a0, a0, %lo(%larel(kernel_L.str.4,kernel_autoL10))
	call	print 
	li	a0, 0 
	sw	a0, -12(s0) 
	j	kernel_LBB2_3 
kernel_LBB2_2:
	lw	a0, -16(s0) 
kernel_autoL11:
	auipc	a1, %hi(%pcrel(current_process))
	sw	a1, -24(s0) # 4-byte Folded Spill 
	lw	a2, %lo(%larel(current_process,kernel_autoL11))(a1)
	sw	a0, 4(a2) 
	lw	a0, -20(s0) 
	lw	a2, %lo(%larel(current_process,kernel_autoL11))(a1)
	sw	a0, 8(a2) 
	lw	a0, %lo(%larel(current_process,kernel_autoL11))(a1)
	lw	a0, 12(a0) 
	sw	a0, %lo(%larel(current_process,kernel_autoL11))(a1)
kernel_autoL12:
	auipc	a0, %hi(%pcrel(kernel_L.str.5))
	addi	a0, a0, %lo(%larel(kernel_L.str.5,kernel_autoL12))
	call	print 
	lw	a0, -24(s0) # 4-byte Folded Reload 
	lw	a0, %lo(%larel(current_process,kernel_autoL11))(a0)
	sw	a0, -12(s0) 
	j	kernel_LBB2_3 
kernel_LBB2_3:
	lw	a0, -12(s0) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
kernel_Lfunc_end2:
	#	-- End function 
handle_process_exit:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
kernel_autoL13:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,kernel_autoL13))(a0)
	bnez	a0, kernel_LBB3_2 
	j	kernel_LBB3_1 
kernel_LBB3_1:
kernel_autoL14:
	auipc	a0, %hi(%pcrel(kernel_L.str.6))
	addi	a0, a0, %lo(%larel(kernel_L.str.6,kernel_autoL14))
	call	print 
	j	kernel_LBB3_5 
kernel_LBB3_2:
kernel_autoL15:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a1, %lo(%larel(current_process,kernel_autoL15))(a0)
	sw	a1, -12(s0) 
	lw	a0, %lo(%larel(current_process,kernel_autoL15))(a0)
	lw	a0, 0(a0) 
	sw	a0, -16(s0) 
	lw	a0, -12(s0) 
	lw	a1, -16(s0) 
	call	delete_process 
	sw	a0, -20(s0) 
	lw	a0, -20(s0) 
	bnez	a0, kernel_LBB3_4 
	j	kernel_LBB3_3 
kernel_LBB3_3:
kernel_autoL16:
	auipc	a1, %hi(%pcrel(current_process))
	li	a0, 0 
	sw	a0, %lo(%larel(current_process,kernel_autoL16))(a1)
kernel_autoL17:
	auipc	a0, %hi(%pcrel(kernel_L.str.7))
	addi	a0, a0, %lo(%larel(kernel_L.str.7,kernel_autoL17))
	call	print 
	j	kernel_LBB3_5 
kernel_LBB3_4:
	lw	a0, -20(s0) 
kernel_autoL18:
	auipc	a1, %hi(%pcrel(current_process))
	sw	a1, -24(s0) # 4-byte Folded Spill 
	sw	a0, %lo(%larel(current_process,kernel_autoL18))(a1)
kernel_autoL19:
	auipc	a0, %hi(%pcrel(kernel_L.str.8))
	addi	a0, a0, %lo(%larel(kernel_L.str.8,kernel_autoL19))
	call	print 
	lw	a0, -24(s0) # 4-byte Folded Reload 
	lw	a1, %lo(%larel(current_process,kernel_autoL18))(a0)
	lw	a0, 4(a1) 
	lw	a1, 8(a1) 
	call	schedule 
	j	kernel_LBB3_5 
kernel_LBB3_5:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
kernel_Lfunc_end3:
	#	-- End function 
run_programs:
	#	%bb.0: 
	addi	sp, sp, -48 
	sw	ra, 44(sp) # 4-byte Folded Spill 
	sw	s0, 40(sp) # 4-byte Folded Spill 
	addi	s0, sp, 48 
	sw	a0, -12(s0) 
kernel_autoL20:
	auipc	a0, %hi(%pcrel(kernel_L.str.9))
	addi	a0, a0, %lo(%larel(kernel_L.str.9,kernel_autoL20))
	call	print 
	lw	a0, -12(s0) 
	addi	a1, s0, -24 
	sw	a1, -36(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -36(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL21:
	auipc	a0, %hi(%pcrel(kernel_L.str.10))
	addi	a0, a0, %lo(%larel(kernel_L.str.10,kernel_autoL21))
	call	print 
kernel_autoL22:
	auipc	a0, %hi(%pcrel(ROM_device_code))
	lw	a0, %lo(%larel(ROM_device_code,kernel_autoL22))(a0)
	lw	a1, -12(s0) 
	call	find_device 
	sw	a0, -28(s0) 
	lw	a0, -28(s0) 
	bnez	a0, kernel_LBB4_2 
	j	kernel_LBB4_1 
kernel_LBB4_1:
kernel_autoL23:
	auipc	a0, %hi(%pcrel(kernel_L.str.11))
	addi	a0, a0, %lo(%larel(kernel_L.str.11,kernel_autoL23))
	call	print 
	lw	a0, -12(s0) 
	addi	a1, s0, -24 
	sw	a1, -40(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -40(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL24:
	auipc	a0, %hi(%pcrel(kernel_L.str.12))
	addi	a0, a0, %lo(%larel(kernel_L.str.12,kernel_autoL24))
	call	print 
	j	kernel_LBB4_3 
kernel_LBB4_2:
kernel_autoL25:
	auipc	a0, %hi(%pcrel(kernel_L.str.13))
	addi	a0, a0, %lo(%larel(kernel_L.str.13,kernel_autoL25))
	call	print 
kernel_autoL26:
	auipc	a1, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL26))(a1)
	sw	a0, -32(s0) 
	lw	a0, -32(s0) 
	lw	a0, 0(a0) 
	sw	a0, %lo(%larel(free_list_head,kernel_autoL26))(a1)
	lw	a0, -28(s0) 
	lw	a0, 4(a0) 
kernel_autoL27:
	auipc	a1, %hi(%pcrel(DMA_portal_ptr))
	lw	a2, %lo(%larel(DMA_portal_ptr,kernel_autoL27))(a1)
	sw	a0, 0(a2) 
	lw	a0, -32(s0) 
	lw	a2, %lo(%larel(DMA_portal_ptr,kernel_autoL27))(a1)
	sw	a0, 4(a2) 
	lw	a2, -28(s0) 
	lw	a0, 8(a2) 
	lw	a2, 4(a2) 
	sub	a0, a0, a2 
	lw	a1, %lo(%larel(DMA_portal_ptr,kernel_autoL27))(a1)
	sw	a0, 8(a1) 
kernel_autoL28:
	auipc	a0, %hi(%pcrel(current_process))
	sw	a0, -44(s0) # 4-byte Folded Spill 
	lw	a0, %lo(%larel(current_process,kernel_autoL28))(a0)
kernel_autoL29:
	auipc	a3, %hi(%pcrel(next_pid))
	lw	a1, %lo(%larel(next_pid,kernel_autoL29))(a3)
	addi	a2, a1, 1 
	sw	a2, %lo(%larel(next_pid,kernel_autoL29))(a3)
	lw	a3, -32(s0) 
	lui	a2, 32 
	add	a2, a3, a2 
	call	insert_process 
	mv	a1, a0 
	lw	a0, -44(s0) # 4-byte Folded Reload 
	sw	a1, %lo(%larel(current_process,kernel_autoL28))(a0)
	lw	a0, %lo(%larel(current_process,kernel_autoL28))(a0)
	call	load_process_state 
	j	kernel_LBB4_3 
kernel_LBB4_3:
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
kernel_Lfunc_end4:
	#	-- End function 
kernel_L.str:
	.Text
	.asciz	"Process management system initialized.\n"
statics_limit:
	.Numeric
	.word	0                               # 0x0
kernel_L.str.1:
	.Text
	.asciz	"Initializing RAM free block list...\n"
free_list_head:
	.Numeric
	.word	0
kernel_L.str.2:
	.Text
	.asciz	"Created "
kernel_L.str.3:
	.asciz	" free blocks. \n"
kernel_L.str.4:
	.asciz	"No processes to schedule\n"
kernel_L.str.5:
	.asciz	"Scheduling process\n"
kernel_L.str.6:
	.asciz	"No processes to exit\n"
kernel_L.str.7:
	.asciz	"Process exited. No more processes to run.\n"
kernel_L.str.8:
	.asciz	"Process exited. Scheduling next process.\n"
kernel_L.str.9:
	.asciz	"Searching for ROM #"
kernel_L.str.10:
	.asciz	"\n"
kernel_L.str.11:
	.asciz	"ROM #"
kernel_L.str.12:
	.asciz	" not found. \n"
kernel_L.str.13:
	.asciz	"Running program...\n"
next_pid:
	.Numeric
	.word	1                               # 0x1
	.Code
insert_process:
	#	%bb.0: 
	addi	sp, sp, -48 
	sw	ra, 44(sp) # 4-byte Folded Spill 
	sw	s0, 40(sp) # 4-byte Folded Spill 
	addi	s0, sp, 48 
	sw	a0, -16(s0) 
	sw	a1, -20(s0) 
	sw	a2, -24(s0) 
	sw	a3, -28(s0) 
	li	a0, 20 
	call	malloc 
	sw	a0, -32(s0) 
	lw	a0, -32(s0) 
	bnez	a0, process_info_LBB0_2 
	j	process_info_LBB0_1 
process_info_LBB0_1:
process_info_autoL0:
	auipc	a0, %hi(%pcrel(process_info_L.str))
	addi	a0, a0, %lo(%larel(process_info_L.str,process_info_autoL0))
	call	print 
	lw	a0, -16(s0) 
	sw	a0, -12(s0) 
	j	process_info_LBB0_5 
process_info_LBB0_2:
	lw	a0, -20(s0) 
	lw	a1, -32(s0) 
	sw	a0, 0(a1) 
	lw	a0, -24(s0) 
	lw	a1, -32(s0) 
	sw	a0, 4(a1) 
	lw	a0, -28(s0) 
	lw	a1, -32(s0) 
	sw	a0, 8(a1) 
	lw	a0, -16(s0) 
	bnez	a0, process_info_LBB0_4 
	j	process_info_LBB0_3 
process_info_LBB0_3:
	lw	a0, -32(s0) 
	sw	a0, 12(a0) 
	lw	a0, -32(s0) 
	sw	a0, 16(a0) 
	lw	a0, -32(s0) 
	sw	a0, -12(s0) 
	j	process_info_LBB0_5 
process_info_LBB0_4:
	lw	a0, -16(s0) 
	lw	a0, 16(a0) 
	sw	a0, -36(s0) 
	lw	a0, -32(s0) 
	lw	a1, -36(s0) 
	sw	a0, 12(a1) 
	lw	a0, -36(s0) 
	lw	a1, -32(s0) 
	sw	a0, 16(a1) 
	lw	a0, -16(s0) 
	lw	a1, -32(s0) 
	sw	a0, 12(a1) 
	lw	a0, -32(s0) 
	lw	a1, -16(s0) 
	sw	a0, 16(a1) 
	lw	a0, -32(s0) 
	sw	a0, -12(s0) 
	j	process_info_LBB0_5 
process_info_LBB0_5:
	lw	a0, -12(s0) 
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
process_info_Lfunc_end0:
	#	-- End function 
delete_process:
	#	%bb.0: 
	addi	sp, sp, -48 
	sw	ra, 44(sp) # 4-byte Folded Spill 
	sw	s0, 40(sp) # 4-byte Folded Spill 
	addi	s0, sp, 48 
	sw	a0, -16(s0) 
	sw	a1, -20(s0) 
	lw	a0, -16(s0) 
	bnez	a0, process_info_LBB1_2 
	j	process_info_LBB1_1 
process_info_LBB1_1:
	li	a0, 0 
	sw	a0, -12(s0) 
	j	process_info_LBB1_12 
process_info_LBB1_2:
	lw	a0, -16(s0) 
	sw	a0, -24(s0) 
	lw	a0, -16(s0) 
	sw	a0, -28(s0) 
	j	process_info_LBB1_3 
process_info_LBB1_3:
	lw	a0, -24(s0) 
	lw	a0, 0(a0) 
	lw	a1, -20(s0) 
	bne	a0, a1, process_info_LBB1_9 
	j	process_info_LBB1_4 
process_info_LBB1_4:
	lw	a0, -24(s0) 
	lw	a0, 16(a0) 
	sw	a0, -32(s0) 
	lw	a0, -24(s0) 
	lw	a0, 12(a0) 
	sw	a0, -36(s0) 
	lw	a0, -36(s0) 
	lw	a1, -24(s0) 
	bne	a0, a1, process_info_LBB1_6 
	j	process_info_LBB1_5 
process_info_LBB1_5:
	lw	a0, -24(s0) 
	call	free 
	li	a0, 0 
	sw	a0, -12(s0) 
	j	process_info_LBB1_12 
process_info_LBB1_6:
	lw	a0, -36(s0) 
	lw	a1, -32(s0) 
	sw	a0, 12(a1) 
	lw	a0, -32(s0) 
	lw	a1, -36(s0) 
	sw	a0, 16(a1) 
	lw	a0, -24(s0) 
	lw	a1, -16(s0) 
	bne	a0, a1, process_info_LBB1_8 
	j	process_info_LBB1_7 
process_info_LBB1_7:
	lw	a0, -36(s0) 
	sw	a0, -28(s0) 
	j	process_info_LBB1_8 
process_info_LBB1_8:
	lw	a0, -24(s0) 
	call	free 
	lw	a0, -28(s0) 
	sw	a0, -12(s0) 
	j	process_info_LBB1_12 
process_info_LBB1_9:
	lw	a0, -24(s0) 
	lw	a0, 12(a0) 
	sw	a0, -24(s0) 
	j	process_info_LBB1_10 
process_info_LBB1_10:
	lw	a0, -24(s0) 
	lw	a1, -16(s0) 
	bne	a0, a1, process_info_LBB1_3 
	j	process_info_LBB1_11 
process_info_LBB1_11:
	lw	a0, -16(s0) 
	sw	a0, -12(s0) 
	j	process_info_LBB1_12 
process_info_LBB1_12:
	lw	a0, -12(s0) 
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
process_info_Lfunc_end1:
	#	-- End function 
display_processes:
	#	%bb.0: 
	addi	sp, sp, -64 
	sw	ra, 60(sp) # 4-byte Folded Spill 
	sw	s0, 56(sp) # 4-byte Folded Spill 
	addi	s0, sp, 64 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, process_info_LBB2_2 
	j	process_info_LBB2_1 
process_info_LBB2_1:
process_info_autoL1:
	auipc	a0, %hi(%pcrel(process_info_L.str.1))
	addi	a0, a0, %lo(%larel(process_info_L.str.1,process_info_autoL1))
	call	print 
	j	process_info_LBB2_5 
process_info_LBB2_2:
	lw	a0, -12(s0) 
	sw	a0, -16(s0) 
	j	process_info_LBB2_3 
process_info_LBB2_3:
	lw	a0, -16(s0) 
	lw	a0, 0(a0) 
	addi	a1, s0, -25 
	sw	a1, -56(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -16(s0) 
	lw	a0, 4(a0) 
	addi	a1, s0, -34 
	sw	a1, -52(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -16(s0) 
	lw	a0, 8(a0) 
	addi	a1, s0, -43 
	sw	a1, -48(s0) # 4-byte Folded Spill 
	call	int_to_hex 
process_info_autoL2:
	auipc	a0, %hi(%pcrel(process_info_L.str.2))
	addi	a0, a0, %lo(%larel(process_info_L.str.2,process_info_autoL2))
	call	print 
	lw	a0, -56(s0) # 4-byte Folded Reload 
	call	print 
process_info_autoL3:
	auipc	a0, %hi(%pcrel(process_info_L.str.3))
	addi	a0, a0, %lo(%larel(process_info_L.str.3,process_info_autoL3))
	call	print 
	lw	a0, -52(s0) # 4-byte Folded Reload 
	call	print 
process_info_autoL4:
	auipc	a0, %hi(%pcrel(process_info_L.str.4))
	addi	a0, a0, %lo(%larel(process_info_L.str.4,process_info_autoL4))
	call	print 
	lw	a0, -48(s0) # 4-byte Folded Reload 
	call	print 
process_info_autoL5:
	auipc	a0, %hi(%pcrel(process_info_L.str.5))
	addi	a0, a0, %lo(%larel(process_info_L.str.5,process_info_autoL5))
	call	print 
	lw	a0, -16(s0) 
	lw	a0, 12(a0) 
	sw	a0, -16(s0) 
	j	process_info_LBB2_4 
process_info_LBB2_4:
	lw	a0, -16(s0) 
	lw	a1, -12(s0) 
	bne	a0, a1, process_info_LBB2_3 
	j	process_info_LBB2_5 
process_info_LBB2_5:
	lw	ra, 60(sp) # 4-byte Folded Reload 
	lw	s0, 56(sp) # 4-byte Folded Reload 
	addi	sp, sp, 64 
	ret	
process_info_Lfunc_end2:
	#	-- End function 
process_info_L.str:
	.Text
	.asciz	"Memory allocation failed\n"
process_info_L.str.1:
	.asciz	"No processes available\n"
process_info_L.str.2:
	.asciz	"PID: "
process_info_L.str.3:
	.asciz	", SP: "
process_info_L.str.4:
	.asciz	", PC: "
process_info_L.str.5:
	.asciz	"\n"
	.Code
int_to_hex:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	li	a0, 28 
	sw	a0, -20(s0) 
	j	utility_LBB0_1 
utility_LBB0_1:
	lw	a0, -20(s0) 
	bltz	a0, utility_LBB0_4 
	j	utility_LBB0_2 
utility_LBB0_2:
	lw	a0, -12(s0) 
	lw	a1, -20(s0) 
	srl	a0, a0, a1 
	andi	a0, a0, 15 
	sw	a0, -24(s0) 
	lw	a1, -24(s0) 
utility_autoL0:
	auipc	a0, %hi(%pcrel(int_to_hex.hex_digits))
	addi	a0, a0, %lo(%larel(int_to_hex.hex_digits,utility_autoL0))
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	lw	a1, -16(s0) 
	addi	a2, a1, 1 
	sw	a2, -16(s0) 
	sb	a0, 0(a1) 
	j	utility_LBB0_3 
utility_LBB0_3:
	lw	a0, -20(s0) 
	addi	a0, a0, -4 
	sw	a0, -20(s0) 
	j	utility_LBB0_1 
utility_LBB0_4:
	lw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, 0(a1) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end0:
	#	-- End function 
int_to_dec:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	lw	a0, -12(s0) 
	bnez	a0, utility_LBB1_2 
	j	utility_LBB1_1 
utility_LBB1_1:
	lw	a1, -16(s0) 
	li	a0, 48 
	sb	a0, 0(a1) 
	lw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, 1(a1) 
	j	utility_LBB1_10 
utility_LBB1_2:
	li	a0, 0 
	sw	a0, -20(s0) 
	j	utility_LBB1_3 
utility_LBB1_3:
	lw	a0, -12(s0) 
	beqz	a0, utility_LBB1_5 
	j	utility_LBB1_4 
utility_LBB1_4:
	lw	a0, -12(s0) 
	lui	a1, 838861 
	addi	a1, a1, -819 
	mulhu	a2, a0, a1 
	srli	a2, a2, 3 
	li	a3, 10 
	mul	a2, a2, a3 
	sub	a0, a0, a2 
	sw	a0, -24(s0) 
	lw	a0, -12(s0) 
	mulhu	a0, a0, a1 
	srli	a0, a0, 3 
	sw	a0, -12(s0) 
	lw	a0, -24(s0) 
	addi	a0, a0, 48 
	lw	a1, -16(s0) 
	lw	a2, -20(s0) 
	addi	a3, a2, 1 
	sw	a3, -20(s0) 
	add	a1, a1, a2 
	sb	a0, 0(a1) 
	j	utility_LBB1_3 
utility_LBB1_5:
	li	a0, 0 
	sw	a0, -28(s0) 
	j	utility_LBB1_6 
utility_LBB1_6:
	lw	a0, -28(s0) 
	lw	a1, -20(s0) 
	srli	a2, a1, 31 
	add	a1, a1, a2 
	srai	a1, a1, 1 
	bge	a0, a1, utility_LBB1_9 
	j	utility_LBB1_7 
utility_LBB1_7:
	lw	a0, -16(s0) 
	lw	a1, -28(s0) 
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	sb	a0, -29(s0) 
	lw	a1, -16(s0) 
	lw	a0, -20(s0) 
	lw	a2, -28(s0) 
	sub	a0, a0, a2 
	add	a0, a0, a1 
	lbu	a0, -1(a0) 
	add	a1, a1, a2 
	sb	a0, 0(a1) 
	lbu	a0, -29(s0) 
	lw	a2, -16(s0) 
	lw	a1, -20(s0) 
	lw	a3, -28(s0) 
	sub	a1, a1, a3 
	add	a1, a1, a2 
	sb	a0, -1(a1) 
	j	utility_LBB1_8 
utility_LBB1_8:
	lw	a0, -28(s0) 
	addi	a0, a0, 1 
	sw	a0, -28(s0) 
	j	utility_LBB1_6 
utility_LBB1_9:
	lw	a0, -16(s0) 
	lw	a1, -20(s0) 
	add	a1, a0, a1 
	li	a0, 0 
	sb	a0, 0(a1) 
	j	utility_LBB1_10 
utility_LBB1_10:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end1:
	#	-- End function 
copy_str:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	sw	a2, -20(s0) 
	li	a0, 0 
	sw	a0, -24(s0) 
	j	utility_LBB2_1 
utility_LBB2_1:
	lw	a0, -24(s0) 
	lw	a1, -20(s0) 
	addi	a1, a1, -1 
	li	a2, 0 
	sw	a2, -28(s0) # 4-byte Folded Spill 
	bge	a0, a1, utility_LBB2_3 
	j	utility_LBB2_2 
utility_LBB2_2:
	lw	a0, -16(s0) 
	lw	a1, -24(s0) 
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	snez	a0, a0 
	sw	a0, -28(s0) # 4-byte Folded Spill 
	j	utility_LBB2_3 
utility_LBB2_3:
	lw	a0, -28(s0) # 4-byte Folded Reload 
	andi	a0, a0, 1 
	beqz	a0, utility_LBB2_6 
	j	utility_LBB2_4 
utility_LBB2_4:
	lw	a0, -16(s0) 
	lw	a2, -24(s0) 
	add	a0, a0, a2 
	lbu	a0, 0(a0) 
	lw	a1, -12(s0) 
	add	a1, a1, a2 
	sb	a0, 0(a1) 
	j	utility_LBB2_5 
utility_LBB2_5:
	lw	a0, -24(s0) 
	addi	a0, a0, 1 
	sw	a0, -24(s0) 
	j	utility_LBB2_1 
utility_LBB2_6:
	lw	a0, -12(s0) 
	lw	a1, -24(s0) 
	add	a1, a0, a1 
	li	a0, 0 
	sb	a0, 0(a1) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end2:
	#	-- End function 
	.Numeric
int_to_hex.hex_digits:
	.Text
	.ascii	"0123456789abcdef"
	.Code
heap_init:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
heap_alloc_autoL0:
	auipc	a1, %hi(%pcrel(free_head))
	addi	a2, a1, %lo(%larel(free_head,heap_alloc_autoL0))
	li	a0, 0 
	sw	a0, 4(a2) 
	sw	a0, 8(a2) 
	sw	a0, %lo(%larel(free_head,heap_alloc_autoL0))(a1)
heap_alloc_autoL1:
	auipc	a1, %hi(%pcrel(free_tail))
	addi	a2, a1, %lo(%larel(free_tail,heap_alloc_autoL1))
	sw	a0, 4(a2) 
	sw	a0, 8(a2) 
	sw	a0, %lo(%larel(free_tail,heap_alloc_autoL1))(a1)
heap_alloc_autoL2:
	auipc	a0, %hi(%pcrel(heap_limit))
	lw	a0, %lo(%larel(heap_limit,heap_alloc_autoL2))(a0)
	beqz	a0, heap_alloc_LBB0_2 
	j	heap_alloc_LBB0_1 
heap_alloc_LBB0_1:
	j	heap_alloc_LBB0_3 
heap_alloc_LBB0_2:
	lw	a0, -12(s0) 
heap_alloc_autoL3:
	auipc	a1, %hi(%pcrel(heap_limit))
	sw	a0, %lo(%larel(heap_limit,heap_alloc_autoL3))(a1)
heap_alloc_autoL4:
	auipc	a0, %hi(%pcrel(free_head))
	addi	a0, a0, %lo(%larel(free_head,heap_alloc_autoL4))
heap_alloc_autoL5:
	auipc	a1, %hi(%pcrel(free_tail))
	addi	a1, a1, %lo(%larel(free_tail,heap_alloc_autoL5))
	sw	a1, 4(a0) 
	sw	a0, 8(a1) 
	j	heap_alloc_LBB0_3 
heap_alloc_LBB0_3:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
heap_alloc_Lfunc_end0:
	#	-- End function 
allocate:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	lbu	a0, -12(s0) 
	andi	a0, a0, 3 
	bnez	a0, heap_alloc_LBB1_2 
	j	heap_alloc_LBB1_1 
heap_alloc_LBB1_1:
	lw	a0, -12(s0) 
	sw	a0, -24(s0) # 4-byte Folded Spill 
	j	heap_alloc_LBB1_3 
heap_alloc_LBB1_2:
	lw	a0, -12(s0) 
	addi	a0, a0, 4 
	andi	a0, a0, 3 
	sw	a0, -24(s0) # 4-byte Folded Spill 
	j	heap_alloc_LBB1_3 
heap_alloc_LBB1_3:
	lw	a0, -24(s0) # 4-byte Folded Reload 
	sw	a0, -12(s0) 
heap_alloc_autoL6:
	auipc	a0, %hi(%pcrel(heap_alloc_L.str))
	addi	a0, a0, %lo(%larel(heap_alloc_L.str,heap_alloc_autoL6))
	call	print 
heap_alloc_autoL7:
	auipc	a0, %hi(%pcrel(free_head))
	addi	a0, a0, %lo(%larel(free_head,heap_alloc_autoL7))
	lw	a0, 4(a0) 
	sw	a0, -16(s0) 
	j	heap_alloc_LBB1_4 
heap_alloc_LBB1_4:
	lw	a0, -16(s0) 
heap_alloc_autoL8:
	auipc	a1, %hi(%pcrel(free_tail))
	addi	a1, a1, %lo(%larel(free_tail,heap_alloc_autoL8))
	beq	a0, a1, heap_alloc_LBB1_9 
	j	heap_alloc_LBB1_5 
heap_alloc_LBB1_5:
	lw	a0, -16(s0) 
	lw	a0, 0(a0) 
	lw	a1, -12(s0) 
	bltu	a0, a1, heap_alloc_LBB1_7 
	j	heap_alloc_LBB1_6 
heap_alloc_LBB1_6:
	lw	a1, -16(s0) 
	lw	a0, 4(a1) 
	lw	a1, 8(a1) 
	sw	a0, 4(a1) 
	lw	a1, -16(s0) 
	lw	a0, 8(a1) 
	lw	a1, 4(a1) 
	sw	a0, 8(a1) 
	lw	a1, -16(s0) 
	li	a0, 0 
	sw	a0, 4(a1) 
	lw	a1, -16(s0) 
	sw	a0, 8(a1) 
	j	heap_alloc_LBB1_9 
heap_alloc_LBB1_7:
	lw	a0, -16(s0) 
	lw	a0, 4(a0) 
	sw	a0, -16(s0) 
	j	heap_alloc_LBB1_8 
heap_alloc_LBB1_8:
	j	heap_alloc_LBB1_4 
heap_alloc_LBB1_9:
	lw	a0, -16(s0) 
heap_alloc_autoL9:
	auipc	a1, %hi(%pcrel(free_tail))
	addi	a1, a1, %lo(%larel(free_tail,heap_alloc_autoL9))
	bne	a0, a1, heap_alloc_LBB1_11 
	j	heap_alloc_LBB1_10 
heap_alloc_LBB1_10:
heap_alloc_autoL10:
	auipc	a0, %hi(%pcrel(heap_alloc_L.str.1))
	addi	a0, a0, %lo(%larel(heap_alloc_L.str.1,heap_alloc_autoL10))
	call	print 
	lw	a0, -12(s0) 
	addi	a0, a0, 12 
	sw	a0, -20(s0) 
heap_alloc_autoL11:
	auipc	a1, %hi(%pcrel(heap_limit))
	lw	a0, %lo(%larel(heap_limit,heap_alloc_autoL11))(a1)
	sw	a0, -16(s0) 
	lw	a0, -12(s0) 
	lw	a2, -16(s0) 
	sw	a0, 0(a2) 
	lw	a2, -20(s0) 
	lw	a0, %lo(%larel(heap_limit,heap_alloc_autoL11))(a1)
	add	a0, a0, a2 
	sw	a0, %lo(%larel(heap_limit,heap_alloc_autoL11))(a1)
heap_alloc_autoL12:
	auipc	a0, %hi(%pcrel(heap_alloc_L.str.2))
	addi	a0, a0, %lo(%larel(heap_alloc_L.str.2,heap_alloc_autoL12))
	call	print 
	j	heap_alloc_LBB1_11 
heap_alloc_LBB1_11:
heap_alloc_autoL13:
	auipc	a0, %hi(%pcrel(heap_alloc_L.str.3))
	addi	a0, a0, %lo(%larel(heap_alloc_L.str.3,heap_alloc_autoL13))
	call	print 
	lw	a0, -16(s0) 
	addi	a0, a0, 12 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
heap_alloc_Lfunc_end1:
	#	-- End function 
deallocate:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, heap_alloc_LBB2_2 
	j	heap_alloc_LBB2_1 
heap_alloc_LBB2_1:
	j	heap_alloc_LBB2_3 
heap_alloc_LBB2_2:
	lw	a0, -12(s0) 
	addi	a0, a0, -12 
	sw	a0, -16(s0) 
heap_alloc_autoL14:
	auipc	a1, %hi(%pcrel(free_head))
	addi	a1, a1, %lo(%larel(free_head,heap_alloc_autoL14))
	lw	a0, 4(a1) 
	lw	a2, -16(s0) 
	sw	a0, 4(a2) 
	lw	a0, -16(s0) 
	sw	a1, 8(a0) 
	lw	a0, -16(s0) 
	lw	a2, 4(a1) 
	sw	a0, 8(a2) 
	lw	a0, -16(s0) 
	sw	a0, 4(a1) 
	j	heap_alloc_LBB2_3 
heap_alloc_LBB2_3:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
heap_alloc_Lfunc_end2:
	#	-- End function 
free_head:
	.Numeric
	.byte 0 0 0 0 0 0 0 0 0 0 0 0 
free_tail:
	.byte 0 0 0 0 0 0 0 0 0 0 0 0 
heap_limit:
	.word	0                               # 0x0
heap_alloc_L.str:
	.Text
	.asciz	"Searching for free block\n"
heap_alloc_L.str.1:
	.asciz	"No free block found, making a new one\n"
heap_alloc_L.str.2:
	.asciz	"Done allocating memory\n"
heap_alloc_L.str.3:
	.asciz	"Allocated memory\n"
	.Code
malloc:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -16(s0) 
	lw	a0, -16(s0) 
	bnez	a0, memory_alloc_LBB0_2 
	j	memory_alloc_LBB0_1 
memory_alloc_LBB0_1:
	li	a0, 0 
	sw	a0, -12(s0) 
	j	memory_alloc_LBB0_3 
memory_alloc_LBB0_2:
	lw	a0, -16(s0) 
	call	allocate 
	sw	a0, -12(s0) 
	j	memory_alloc_LBB0_3 
memory_alloc_LBB0_3:
	lw	a0, -12(s0) 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
memory_alloc_Lfunc_end0:
	#	-- End function 
free:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	call	deallocate 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
memory_alloc_Lfunc_end1:
	#	-- End function 
