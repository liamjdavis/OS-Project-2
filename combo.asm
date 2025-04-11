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
### Procedure: do_exit

do_exit:

	## Prologue.
	addi		sp,		sp,		-8
	sw		ra,		4(sp)						# Preserve ra
	sw		fp,		0(sp)						# Preserve fp
	addi		fp,		sp,		8				# Set fp
	
	## Show that we got here.
	la		a0,		exit_msg					# Print EXIT occurrence.
	call		print

	## Try to load the next ROM.
	call		run_programs

	## Epilogue: If we are here, no program ran, so restore and return.
	lw		ra,		4(sp)						# Restore ra
	lw		fp,		0(sp)						# Restore fp
	addi		sp,		sp,		8
	ret
### ================================================================================================================================


	
### ================================================================================================================================
### Procedure: syscall_handler

syscall_handler:

	## Reset kernel's stack and frame pointers.
	lw		fp,		kernel_limit
	lw		sp,		kernel_limit

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

	## An exit was requested.  Move onto the next ROM.
	call		do_exit

	## If we are here, then the end of the ROMs was reached.
	la		a0,		all_programs_run_msg
	call		print

	j syscall_handler_halt

	## Fall through...

handle_run:
    # Instead of calling run_program, call run_programs
    call run_programs
    
    # Set success return value
    li a0, 0
    eret

handle_print:
	# Move string pointer to a0
	mv a0, a1
	call print
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
### Procedure: alarm_handler

alarm_handler:
	## Reset kernel's stack and frame pointers
	lw		fp,		kernel_limit
	lw		sp,		kernel_limit

    ## Check if scheduler is active
    lw      t0,     scheduler_active
    beqz    t0,     alarm_handler_return  
	
	## Debug message
	la		a0,		alarm_received_msg
	call		print
	
	## Save user PC from exception PC (epc) register
	csrr		t0,		epc
	sw		t0,		saved_user_pc, t6
	
	## Save user registers to saved_registers array
	## Note: We're now in kernel mode with kernel stack, 
	## so we can safely save all registers
	
	## Save all registers
	la		t0,		saved_registers
	
	## Save argument registers (a0-a7)
	sw		a0,		0(t0)     # a0 at offset 0
	sw		a1,		4(t0)     # a1 at offset 4
	sw		a2,		8(t0)     # a2 at offset 8
	sw		a3,		12(t0)    # a3 at offset 12
	sw		a4,		16(t0)    # a4 at offset 16
	sw		a5,		20(t0)    # a5 at offset 20
	sw		a6,		24(t0)    # a6 at offset 24
	sw		a7,		28(t0)    # a7 at offset 28
	
	## Save temp registers (t0-t6)
	## Save t0's value from stack since we're using it
	sw		t1,		36(t0)    # t1 at offset 36
	sw		t2,		40(t0)    # t2 at offset 40
	sw		t3,		44(t0)    # t3 at offset 44
	sw		t4,		48(t0)    # t4 at offset 48
	sw		t5,		52(t0)    # t5 at offset 52
	sw		t6,		56(t0)    # t6 at offset 56
	
	## Save saved registers (s0-s11)
	sw		s0,		64(t0)    # s0 at offset 64
	sw		s1,		68(t0)    # s1 at offset 68
	sw		s2,		72(t0)    # s2 at offset 72
	sw		s3,		76(t0)    # s3 at offset 76
	sw		s4,		80(t0)    # s4 at offset 80
	sw		s5,		84(t0)    # s5 at offset 84
	sw		s6,		88(t0)    # s6 at offset 88
	sw		s7,		92(t0)    # s7 at offset 92
	sw		s8,		96(t0)    # s8 at offset 96
	sw		s9,		100(t0)   # s9 at offset 100
	sw		s10,		104(t0)   # s10 at offset 104
	sw		s11,		108(t0)   # s11 at offset 108
	
	## Save ra, sp, and fp
	sw		ra,		124(t0)   # ra at offset 124
	
	## Save the user sp and fp - we're using RAM_limit for both initially
	## as set in userspace_jump, but in the future we'll use the actual values from
	## the process's PCB
	lw		t1,		RAM_limit
	sw		t1,		116(t0)   # sp at offset 116
	sw		t1,		120(t0)   # fp at offset 120
	
	## Save to dedicated variables for scheduler
	sw		t1,		saved_user_sp, t6
	sw		t1,		saved_user_fp, t6
	
	## Call the scheduler to perform context switch
	call		scheduler_handle_alarm
	
	## Set up for the next time quantum
	lw		t0,		time_quantum
	csrr		t1,		ck
	add		t1,		t1,		t0
	csrw		al,		t1
	
	## Restore context of the new process
	lw		t0,		saved_user_pc
	csrw		epc,		t0
	
	## Load new process's stack and frame pointers
	lw		t0,		saved_user_sp
	lw		t1,		saved_user_fp
	
	## Restore all registers from saved_registers array
	la		t2,		saved_registers
	
	## Restore argument registers (a0-a7) except for the ones we need
	lw		s0,		0(t2)     # Save a0 in s0 for now
	lw		s1,		4(t2)     # Save a1 in s1 for now 
	lw		a2,		8(t2)
	lw		a3,		12(t2)
	lw		a4,		16(t2)
	lw		a5,		20(t2)
	lw		a6,		24(t2)
	lw		a7,		28(t2)
	
	## Restore saved registers (s2-s11)
	lw		s2,		72(t2)
	lw		s3,		76(t2)
	lw		s4,		80(t2)
	lw		s5,		84(t2)
	lw		s6,		88(t2)
	lw		s7,		92(t2)
	lw		s8,		96(t2)
	lw		s9,		100(t2)
	lw		s10,		104(t2)
	lw		s11,		108(t2)
	
	## Restore most temporaries except those we need
	lw		t3,		44(t2)
	lw		t4,		48(t2)
	lw		t5,		52(t2)
	lw		t6,		56(t2)
	
	## Restore ra
	lw		ra,		124(t2)
	
	## Now restore the remaining registers at the very end
	mv		sp,		t0      # Restore SP
	mv		fp,		t1      # Restore FP
	lw		t1,		36(t2)   # t1
	lw		t2,		40(t2)   # t2
	mv		a0,		s0      # Restore a0 from s0
	mv		a1,		s1      # Restore a1 from s1
	
	## Return to user mode
	eret

alarm_handler_return:
    eret
### ================================================================================================================================
	
### ================================================================================================================================
### Procedure: init_trap_table

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

    ## Set the TBR to point to the trap table
    csrw		tb,		a0					# tb = trap_base
    ret
### ================================================================================================================================



### ================================================================================================================================
### Procedure: userspace_jump

userspace_jump:
    ## Set up stack/frame pointers for userspace
    lw      sp,     RAM_limit
    lw      fp,     RAM_limit
    
    ## Save the target PC - we will jump to this address
    csrw    epc,    a0
    
    ## Add a check for scheduler_active before enabling alarm
    lw      t0,     scheduler_active
    beqz    t0,     skip_alarm_setup    # Skip alarm setup if scheduler not active
    
    ## Set up alarm for time-based scheduling
    lw      t0,     time_quantum        # Load time quantum value
    csrr    t1,     ck                  # Get current clock value
    add     t1,     t1,     t0          # Calculate when alarm should trigger
    csrw    al,     t1                  # Set alarm register
    
    ## Enable alarm in mode register (bit 4)
    csrr    t0,     md                  # Get current mode
    ori     t0,     t0,     0x10        # Set alarm bit (bit 4)
    csrw    md,     t0                  # Update mode register
    
skip_alarm_setup:
    ## Jump to user space
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
	
	## Call run_programs() to invoke each program ROM in turn.
	call		run_programs
	
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

	## Interrupt codes
CLOCK_ALARM:		0x0c		# CLOCK_ALARM interrupt code (3rd entry in trap table)

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
DMA_portal_ptr:			0

	## Scheduling-related variables
current_process:	0	# Current running process ID
scheduler_active:	0	# Flag indicating if scheduler is active
time_quantum:		10000	# Default time quantum (clock cycles)
saved_user_pc:		0	# Saved program counter for current process
saved_user_sp:		0	# Saved stack pointer for current process
saved_user_fp:		0	# Saved frame pointer for current process
saved_registers:	0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0	# Space for all 32 registers

heap_space: 0x10000000
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
run_programs_success:		"All programs have been run successfully.\n"
debug_received_msg:		"Received syscall: 0x"
debug_exit_msg:			"EXIT code is: 0x"
alarm_received_msg:		"Alarm interrupt received.\n"
scheduler_start_msg:		"Starting scheduler with quantum of "
scheduler_cycles_msg:		" cycles.\n"

### ================================================================================================================================
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
	j	kernel_LBB0_1 
kernel_LBB0_1:
	lw	a0, -20(s0) 
	bltz	a0, kernel_LBB0_4 
	j	kernel_LBB0_2 
kernel_LBB0_2:
	lw	a0, -12(s0) 
	lw	a1, -20(s0) 
	srl	a0, a0, a1 
	andi	a0, a0, 15 
	sw	a0, -24(s0) 
	lw	a1, -24(s0) 
kernel_autoL0:
	auipc	a0, %hi(%pcrel(hex_digits))
	addi	a0, a0, %lo(%larel(hex_digits,kernel_autoL0))
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	lw	a1, -16(s0) 
	addi	a2, a1, 1 
	sw	a2, -16(s0) 
	sb	a0, 0(a1) 
	j	kernel_LBB0_3 
kernel_LBB0_3:
	lw	a0, -20(s0) 
	addi	a0, a0, -4 
	sw	a0, -20(s0) 
	j	kernel_LBB0_1 
kernel_LBB0_4:
	lw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, 0(a1) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
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
kernel_autoL1:
	auipc	a0, %hi(%pcrel(kernel_L.str))
	addi	a0, a0, %lo(%larel(kernel_L.str,kernel_autoL1))
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
kernel_autoL2:
	auipc	a1, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL2))(a1)
	lw	a2, -24(s0) 
	sw	a0, 0(a2) 
	lw	a0, -24(s0) 
	sw	a0, %lo(%larel(free_list_head,kernel_autoL2))(a1)
	lw	a0, -20(s0) 
	lui	a1, 8 
	add	a0, a0, a1 
	sw	a0, -20(s0) 
	j	kernel_LBB1_1 
kernel_LBB1_3:
	li	a0, 0 
	sw	a0, -28(s0) 
kernel_autoL3:
	auipc	a0, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL3))(a0)
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
kernel_autoL4:
	auipc	a0, %hi(%pcrel(kernel_L.str.1))
	addi	a0, a0, %lo(%larel(kernel_L.str.1,kernel_autoL4))
	call	print 
	lw	a0, -28(s0) 
	addi	a1, s0, -41 
	sw	a1, -48(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -48(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL5:
	auipc	a0, %hi(%pcrel(kernel_L.str.2))
	addi	a0, a0, %lo(%larel(kernel_L.str.2,kernel_autoL5))
	call	print 
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
kernel_Lfunc_end1:
	#	-- End function 
run_programs:
	#	%bb.0: 
	addi	sp, sp, -48 
	sw	ra, 44(sp) # 4-byte Folded Spill 
	sw	s0, 40(sp) # 4-byte Folded Spill 
	addi	s0, sp, 48 
kernel_autoL6:
	auipc	a0, %hi(%pcrel(kernel_L.str.3))
	addi	a0, a0, %lo(%larel(kernel_L.str.3,kernel_autoL6))
	call	print 
kernel_autoL7:
	auipc	a0, %hi(%pcrel(run_programs.next_program_ROM))
	sw	a0, -28(s0) # 4-byte Folded Spill 
	lw	a0, %lo(%larel(run_programs.next_program_ROM,kernel_autoL7))(a0)
	addi	a1, s0, -17 
	sw	a1, -32(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -32(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL8:
	auipc	a0, %hi(%pcrel(kernel_L.str.4))
	addi	a0, a0, %lo(%larel(kernel_L.str.4,kernel_autoL8))
	call	print 
	lw	a3, -28(s0) # 4-byte Folded Reload 
kernel_autoL9:
	auipc	a0, %hi(%pcrel(ROM_device_code))
	lw	a0, %lo(%larel(ROM_device_code,kernel_autoL9))(a0)
	lw	a1, %lo(%larel(run_programs.next_program_ROM,kernel_autoL7))(a3)
	addi	a2, a1, 1 
	sw	a2, %lo(%larel(run_programs.next_program_ROM,kernel_autoL7))(a3)
	call	find_device 
	sw	a0, -24(s0) 
	lw	a0, -24(s0) 
	bnez	a0, kernel_LBB2_2 
	j	kernel_LBB2_1 
kernel_LBB2_1:
	j	kernel_LBB2_5 
kernel_LBB2_2:
kernel_autoL10:
	auipc	a0, %hi(%pcrel(scheduler_active))
	lw	a0, %lo(%larel(scheduler_active,kernel_autoL10))(a0)
	bnez	a0, kernel_LBB2_4 
	j	kernel_LBB2_3 
kernel_LBB2_3:
kernel_autoL11:
	auipc	a0, %hi(%pcrel(kernel_L.str.5))
	addi	a0, a0, %lo(%larel(kernel_L.str.5,kernel_autoL11))
	call	print 
	call	scheduler_init 
kernel_autoL12:
	auipc	a0, %hi(%pcrel(scheduler_start_msg))
	lw	a0, %lo(%larel(scheduler_start_msg,kernel_autoL12))(a0)
	call	print 
kernel_autoL13:
	auipc	a0, %hi(%pcrel(time_quantum))
	lw	a0, %lo(%larel(time_quantum,kernel_autoL13))(a0)
	addi	a1, s0, -17 
	sw	a1, -36(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -36(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL14:
	auipc	a0, %hi(%pcrel(scheduler_cycles_msg))
	lw	a0, %lo(%larel(scheduler_cycles_msg,kernel_autoL14))(a0)
	call	print 
	j	kernel_LBB2_4 
kernel_LBB2_4:
kernel_autoL15:
	auipc	a0, %hi(%pcrel(kernel_L.str.6))
	addi	a0, a0, %lo(%larel(kernel_L.str.6,kernel_autoL15))
	call	print 
	lw	a0, -24(s0) 
	lw	a0, 4(a0) 
kernel_autoL16:
	auipc	a2, %hi(%pcrel(DMA_portal_ptr))
	lw	a1, %lo(%larel(DMA_portal_ptr,kernel_autoL16))(a2)
	sw	a0, 0(a1) 
kernel_autoL17:
	auipc	a0, %hi(%pcrel(kernel_limit))
	sw	a0, -40(s0) # 4-byte Folded Spill 
	lw	a1, %lo(%larel(kernel_limit,kernel_autoL17))(a0)
	lw	a3, %lo(%larel(DMA_portal_ptr,kernel_autoL16))(a2)
	sw	a1, 4(a3) 
	lw	a3, -24(s0) 
	lw	a1, 8(a3) 
	lw	a3, 4(a3) 
	sub	a1, a1, a3 
	lw	a2, %lo(%larel(DMA_portal_ptr,kernel_autoL16))(a2)
	sw	a1, 8(a2) 
	lw	a0, %lo(%larel(kernel_limit,kernel_autoL17))(a0)
kernel_autoL18:
	auipc	a1, %hi(%pcrel(RAM_limit))
	lw	a2, %lo(%larel(RAM_limit,kernel_autoL18))(a1)
	mv	a1, a2 
	call	scheduler_add_process 
	lw	a0, -40(s0) # 4-byte Folded Reload 
	lw	a0, %lo(%larel(kernel_limit,kernel_autoL17))(a0)
	call	userspace_jump 
	j	kernel_LBB2_5 
kernel_LBB2_5:
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
kernel_Lfunc_end2:
	#	-- End function 
	.Numeric
hex_digits:
	.Text
	.ascii	"0123456789abcdef"
kernel_L.str:
	.asciz	"Initializing RAM free block list...\n"
free_list_head:
	.Numeric
	.word	0
kernel_L.str.1:
	.Text
	.asciz	"Created "
kernel_L.str.2:
	.asciz	" free blocks."
run_programs.next_program_ROM:
	.Numeric
	.word	3                               # 0x3
kernel_L.str.3:
	.Text
	.asciz	"Searching for ROM #"
kernel_L.str.4:
	.asciz	"\n"
kernel_L.str.5:
	.asciz	"Initializing scheduler...\n"
kernel_L.str.6:
	.asciz	"Running program...\n"

#================================================================================================================
	.Code
enqueue:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	lw	a0, -12(s0) 
	beqz	a0, scheduler_LBB0_2 
	j	scheduler_LBB0_1 
scheduler_LBB0_1:
	lw	a0, -16(s0) 
	bnez	a0, scheduler_LBB0_3 
	j	scheduler_LBB0_2 
scheduler_LBB0_2:
scheduler_autoL0:
	auipc	a0, %hi(%pcrel(scheduler_L.str))
	addi	a0, a0, %lo(%larel(scheduler_L.str,scheduler_autoL0))
	call	print 
	j	scheduler_LBB0_9 
scheduler_LBB0_3:
	lw	a1, -16(s0) 
	li	a0, 0 
	sw	a0, 148(a1) 
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	bnez	a0, scheduler_LBB0_5 
	j	scheduler_LBB0_4 
scheduler_LBB0_4:
	lw	a0, -16(s0) 
	lw	a1, -12(s0) 
	sw	a0, 0(a1) 
	lw	a0, -16(s0) 
	sw	a0, 148(a0) 
	j	scheduler_LBB0_9 
scheduler_LBB0_5:
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	sw	a0, -20(s0) 
	j	scheduler_LBB0_6 
scheduler_LBB0_6:
	lw	a0, -20(s0) 
	lw	a0, 148(a0) 
	lw	a1, -12(s0) 
	lw	a1, 0(a1) 
	beq	a0, a1, scheduler_LBB0_8 
	j	scheduler_LBB0_7 
scheduler_LBB0_7:
	lw	a0, -20(s0) 
	lw	a0, 148(a0) 
	sw	a0, -20(s0) 
	j	scheduler_LBB0_6 
scheduler_LBB0_8:
	lw	a0, -16(s0) 
	lw	a1, -20(s0) 
	sw	a0, 148(a1) 
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	lw	a1, -16(s0) 
	sw	a0, 148(a1) 
	j	scheduler_LBB0_9 
scheduler_LBB0_9:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
scheduler_Lfunc_end0:
	#	-- End function 
dequeue:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -16(s0) 
	lw	a0, -16(s0) 
	lw	a0, 0(a0) 
	bnez	a0, scheduler_LBB1_2 
	j	scheduler_LBB1_1 
scheduler_LBB1_1:
	li	a0, 0 
	sw	a0, -12(s0) 
	j	scheduler_LBB1_9 
scheduler_LBB1_2:
	lw	a0, -16(s0) 
	lw	a0, 0(a0) 
	sw	a0, -20(s0) 
	lw	a1, -20(s0) 
	lw	a0, 148(a1) 
	bne	a0, a1, scheduler_LBB1_4 
	j	scheduler_LBB1_3 
scheduler_LBB1_3:
	lw	a1, -16(s0) 
	li	a0, 0 
	sw	a0, 0(a1) 
	j	scheduler_LBB1_8 
scheduler_LBB1_4:
	lw	a0, -20(s0) 
	sw	a0, -24(s0) 
	j	scheduler_LBB1_5 
scheduler_LBB1_5:
	lw	a0, -24(s0) 
	lw	a0, 148(a0) 
	lw	a1, -20(s0) 
	beq	a0, a1, scheduler_LBB1_7 
	j	scheduler_LBB1_6 
scheduler_LBB1_6:
	lw	a0, -24(s0) 
	lw	a0, 148(a0) 
	sw	a0, -24(s0) 
	j	scheduler_LBB1_5 
scheduler_LBB1_7:
	lw	a0, -20(s0) 
	lw	a0, 148(a0) 
	lw	a1, -16(s0) 
	sw	a0, 0(a1) 
	lw	a0, -16(s0) 
	lw	a0, 0(a0) 
	lw	a1, -24(s0) 
	sw	a0, 148(a1) 
	j	scheduler_LBB1_8 
scheduler_LBB1_8:
	lw	a1, -20(s0) 
	li	a0, 0 
	sw	a0, 148(a1) 
	lw	a0, -20(s0) 
	sw	a0, -12(s0) 
	j	scheduler_LBB1_9 
scheduler_LBB1_9:
	lw	a0, -12(s0) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
scheduler_Lfunc_end1:
	#	-- End function 
scheduler_init:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL1:
	auipc	a1, %hi(%pcrel(ready_queue))
	li	a0, 0 
	sw	a0, %lo(%larel(ready_queue,scheduler_autoL1))(a1)
scheduler_autoL2:
	auipc	a1, %hi(%pcrel(current_process))
	sw	a0, %lo(%larel(current_process,scheduler_autoL2))(a1)
scheduler_autoL3:
	auipc	a2, %hi(%pcrel(next_pid))
	li	a1, 1 
	sw	a1, %lo(%larel(next_pid,scheduler_autoL3))(a2)
scheduler_autoL4:
	auipc	a1, %hi(%pcrel(scheduler_active))
	sw	a0, %lo(%larel(scheduler_active,scheduler_autoL4))(a1)
scheduler_autoL5:
	auipc	a0, %hi(%pcrel(time_quantum))
	lw	a0, %lo(%larel(time_quantum,scheduler_autoL5))(a0)
	bnez	a0, scheduler_LBB2_2 
	j	scheduler_LBB2_1 
scheduler_LBB2_1:
scheduler_autoL6:
	auipc	a1, %hi(%pcrel(time_quantum))
	lui	a0, 2 
	addi	a0, a0, 1808 
	sw	a0, %lo(%larel(time_quantum,scheduler_autoL6))(a1)
	j	scheduler_LBB2_2 
scheduler_LBB2_2:
scheduler_autoL7:
	auipc	a1, %hi(%pcrel(saved_user_pc))
	li	a0, 0 
	sw	a0, %lo(%larel(saved_user_pc,scheduler_autoL7))(a1)
scheduler_autoL8:
	auipc	a1, %hi(%pcrel(saved_user_sp))
	sw	a0, %lo(%larel(saved_user_sp,scheduler_autoL8))(a1)
scheduler_autoL9:
	auipc	a1, %hi(%pcrel(saved_user_fp))
	sw	a0, %lo(%larel(saved_user_fp,scheduler_autoL9))(a1)
	sw	a0, -12(s0) 
	j	scheduler_LBB2_3 
scheduler_LBB2_3:
	lw	a1, -12(s0) 
	li	a0, 31 
	blt	a0, a1, scheduler_LBB2_6 
	j	scheduler_LBB2_4 
scheduler_LBB2_4:
	lw	a0, -12(s0) 
	slli	a1, a0, 2 
scheduler_autoL10:
	auipc	a0, %hi(%pcrel(saved_registers))
	addi	a0, a0, %lo(%larel(saved_registers,scheduler_autoL10))
	add	a1, a0, a1 
	li	a0, 0 
	sw	a0, 0(a1) 
	j	scheduler_LBB2_5 
scheduler_LBB2_5:
	lw	a0, -12(s0) 
	addi	a0, a0, 1 
	sw	a0, -12(s0) 
	j	scheduler_LBB2_3 
scheduler_LBB2_6:
scheduler_autoL11:
	auipc	a0, %hi(%pcrel(scheduler_L.str.1))
	addi	a0, a0, %lo(%larel(scheduler_L.str.1,scheduler_autoL11))
	call	print 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end2:
	#	-- End function 
scheduler_add_process:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	sw	a2, -20(s0) 
	li	a0, 152 
	call	malloc 
	sw	a0, -24(s0) 
	lw	a0, -24(s0) 
	bnez	a0, scheduler_LBB3_2 
	j	scheduler_LBB3_1 
scheduler_LBB3_1:
scheduler_autoL12:
	auipc	a0, %hi(%pcrel(scheduler_L.str.2))
	addi	a0, a0, %lo(%larel(scheduler_L.str.2,scheduler_autoL12))
	call	print 
	j	scheduler_LBB3_7 
scheduler_LBB3_2:
	lw	a0, -24(s0) 
	sw	a0, -28(s0) 
	li	a0, 0 
	sw	a0, -32(s0) 
	j	scheduler_LBB3_3 
scheduler_LBB3_3:
	lw	a1, -32(s0) 
	li	a0, 151 
	bltu	a0, a1, scheduler_LBB3_6 
	j	scheduler_LBB3_4 
scheduler_LBB3_4:
	lw	a0, -28(s0) 
	lw	a1, -32(s0) 
	add	a1, a0, a1 
	li	a0, 0 
	sb	a0, 0(a1) 
	j	scheduler_LBB3_5 
scheduler_LBB3_5:
	lw	a0, -32(s0) 
	addi	a0, a0, 1 
	sw	a0, -32(s0) 
	j	scheduler_LBB3_3 
scheduler_LBB3_6:
scheduler_autoL13:
	auipc	a2, %hi(%pcrel(next_pid))
	lw	a0, %lo(%larel(next_pid,scheduler_autoL13))(a2)
	addi	a1, a0, 1 
	sw	a1, %lo(%larel(next_pid,scheduler_autoL13))(a2)
	lw	a1, -24(s0) 
	sw	a0, 0(a1) 
	lw	a1, -24(s0) 
	li	a0, 0 
	sw	a0, 4(a1) 
	lw	a1, -12(s0) 
	lw	a2, -24(s0) 
	sw	a1, 136(a2) 
	lw	a1, -16(s0) 
	lw	a2, -24(s0) 
	sw	a1, 140(a2) 
	lw	a1, -20(s0) 
	lw	a2, -24(s0) 
	sw	a1, 144(a2) 
	lw	a1, -24(s0) 
	sw	a0, 148(a1) 
	lw	a1, -24(s0) 
scheduler_autoL14:
	auipc	a0, %hi(%pcrel(ready_queue))
	addi	a0, a0, %lo(%larel(ready_queue,scheduler_autoL14))
	call	enqueue 
	j	scheduler_LBB3_7 
scheduler_LBB3_7:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
scheduler_Lfunc_end3:
	#	-- End function 
scheduler_get_current_process:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL15:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL15))(a0)
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end4:
	#	-- End function 
scheduler_get_next_process:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL16:
	auipc	a0, %hi(%pcrel(ready_queue))
	lw	a0, %lo(%larel(ready_queue,scheduler_autoL16))(a0)
	bnez	a0, scheduler_LBB5_2 
	j	scheduler_LBB5_1 
scheduler_LBB5_1:
	li	a0, 0 
	sw	a0, -12(s0) 
	j	scheduler_LBB5_6 
scheduler_LBB5_2:
scheduler_autoL17:
	auipc	a0, %hi(%pcrel(ready_queue))
	addi	a0, a0, %lo(%larel(ready_queue,scheduler_autoL17))
	call	dequeue 
	sw	a0, -16(s0) 
	lw	a1, -16(s0) 
	li	a0, 1 
	sw	a0, 4(a1) 
scheduler_autoL18:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL18))(a0)
	beqz	a0, scheduler_LBB5_5 
	j	scheduler_LBB5_3 
scheduler_LBB5_3:
scheduler_autoL19:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL19))(a0)
	lw	a0, 4(a0) 
	li	a1, 1 
	bne	a0, a1, scheduler_LBB5_5 
	j	scheduler_LBB5_4 
scheduler_LBB5_4:
scheduler_autoL20:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a2, %lo(%larel(current_process,scheduler_autoL20))(a0)
	li	a1, 0 
	sw	a1, 4(a2) 
	lw	a1, %lo(%larel(current_process,scheduler_autoL20))(a0)
scheduler_autoL21:
	auipc	a0, %hi(%pcrel(ready_queue))
	addi	a0, a0, %lo(%larel(ready_queue,scheduler_autoL21))
	call	enqueue 
	j	scheduler_LBB5_5 
scheduler_LBB5_5:
	lw	a0, -16(s0) 
	sw	a0, -12(s0) 
	j	scheduler_LBB5_6 
scheduler_LBB5_6:
	lw	a0, -12(s0) 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end5:
	#	-- End function 
save_context:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL22:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL22))(a0)
	bnez	a0, scheduler_LBB6_2 
	j	scheduler_LBB6_1 
scheduler_LBB6_1:
	j	scheduler_LBB6_6 
scheduler_LBB6_2:
scheduler_autoL23:
	auipc	a0, %hi(%pcrel(saved_user_pc))
	lw	a0, %lo(%larel(saved_user_pc,scheduler_autoL23))(a0)
scheduler_autoL24:
	auipc	a1, %hi(%pcrel(current_process))
	lw	a2, %lo(%larel(current_process,scheduler_autoL24))(a1)
	sw	a0, 136(a2) 
scheduler_autoL25:
	auipc	a0, %hi(%pcrel(saved_user_sp))
	lw	a0, %lo(%larel(saved_user_sp,scheduler_autoL25))(a0)
	lw	a2, %lo(%larel(current_process,scheduler_autoL24))(a1)
	sw	a0, 140(a2) 
scheduler_autoL26:
	auipc	a0, %hi(%pcrel(saved_user_fp))
	lw	a0, %lo(%larel(saved_user_fp,scheduler_autoL26))(a0)
	lw	a1, %lo(%larel(current_process,scheduler_autoL24))(a1)
	sw	a0, 144(a1) 
	li	a0, 0 
	sw	a0, -12(s0) 
	j	scheduler_LBB6_3 
scheduler_LBB6_3:
	lw	a1, -12(s0) 
	li	a0, 31 
	blt	a0, a1, scheduler_LBB6_6 
	j	scheduler_LBB6_4 
scheduler_LBB6_4:
	lw	a0, -12(s0) 
	slli	a2, a0, 2 
scheduler_autoL27:
	auipc	a0, %hi(%pcrel(saved_registers))
	addi	a0, a0, %lo(%larel(saved_registers,scheduler_autoL27))
	add	a0, a0, a2 
	lw	a0, 0(a0) 
scheduler_autoL28:
	auipc	a1, %hi(%pcrel(current_process))
	lw	a1, %lo(%larel(current_process,scheduler_autoL28))(a1)
	add	a1, a1, a2 
	sw	a0, 8(a1) 
	j	scheduler_LBB6_5 
scheduler_LBB6_5:
	lw	a0, -12(s0) 
	addi	a0, a0, 1 
	sw	a0, -12(s0) 
	j	scheduler_LBB6_3 
scheduler_LBB6_6:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end6:
	#	-- End function 
restore_context:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, scheduler_LBB7_2 
	j	scheduler_LBB7_1 
scheduler_LBB7_1:
	j	scheduler_LBB7_6 
scheduler_LBB7_2:
	lw	a0, -12(s0) 
	lw	a0, 136(a0) 
scheduler_autoL29:
	auipc	a1, %hi(%pcrel(saved_user_pc))
	sw	a0, %lo(%larel(saved_user_pc,scheduler_autoL29))(a1)
	lw	a0, -12(s0) 
	lw	a0, 140(a0) 
scheduler_autoL30:
	auipc	a1, %hi(%pcrel(saved_user_sp))
	sw	a0, %lo(%larel(saved_user_sp,scheduler_autoL30))(a1)
	lw	a0, -12(s0) 
	lw	a0, 144(a0) 
scheduler_autoL31:
	auipc	a1, %hi(%pcrel(saved_user_fp))
	sw	a0, %lo(%larel(saved_user_fp,scheduler_autoL31))(a1)
	li	a0, 0 
	sw	a0, -16(s0) 
	j	scheduler_LBB7_3 
scheduler_LBB7_3:
	lw	a1, -16(s0) 
	li	a0, 31 
	blt	a0, a1, scheduler_LBB7_6 
	j	scheduler_LBB7_4 
scheduler_LBB7_4:
	lw	a0, -12(s0) 
	lw	a1, -16(s0) 
	slli	a2, a1, 2 
	add	a0, a0, a2 
	lw	a0, 8(a0) 
scheduler_autoL32:
	auipc	a1, %hi(%pcrel(saved_registers))
	addi	a1, a1, %lo(%larel(saved_registers,scheduler_autoL32))
	add	a1, a1, a2 
	sw	a0, 0(a1) 
	j	scheduler_LBB7_5 
scheduler_LBB7_5:
	lw	a0, -16(s0) 
	addi	a0, a0, 1 
	sw	a0, -16(s0) 
	j	scheduler_LBB7_3 
scheduler_LBB7_6:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end7:
	#	-- End function 
context_switch:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	call	save_context 
	call	scheduler_get_next_process 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, scheduler_LBB8_2 
	j	scheduler_LBB8_1 
scheduler_LBB8_1:
	j	scheduler_LBB8_3 
scheduler_LBB8_2:
	lw	a1, -12(s0) 
scheduler_autoL33:
	auipc	a0, %hi(%pcrel(current_process))
	sw	a1, %lo(%larel(current_process,scheduler_autoL33))(a0)
	lw	a0, %lo(%larel(current_process,scheduler_autoL33))(a0)
	call	restore_context 
	j	scheduler_LBB8_3 
scheduler_LBB8_3:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end8:
	#	-- End function 
scheduler_handle_alarm:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL34:
	auipc	a0, %hi(%pcrel(ready_queue))
	lw	a0, %lo(%larel(ready_queue,scheduler_autoL34))(a0)
	bnez	a0, scheduler_LBB9_3 
	j	scheduler_LBB9_1 
scheduler_LBB9_1:
scheduler_autoL35:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL35))(a0)
	bnez	a0, scheduler_LBB9_3 
	j	scheduler_LBB9_2 
scheduler_LBB9_2:
scheduler_autoL36:
	auipc	a0, %hi(%pcrel(scheduler_L.str.3))
	addi	a0, a0, %lo(%larel(scheduler_L.str.3,scheduler_autoL36))
	call	print 
	j	scheduler_LBB9_6 
scheduler_LBB9_3:
scheduler_autoL37:
	auipc	a0, %hi(%pcrel(scheduler_active))
	lw	a0, %lo(%larel(scheduler_active,scheduler_autoL37))(a0)
	bnez	a0, scheduler_LBB9_5 
	j	scheduler_LBB9_4 
scheduler_LBB9_4:
	j	scheduler_LBB9_6 
scheduler_LBB9_5:
	call	context_switch 
	j	scheduler_LBB9_6 
scheduler_LBB9_6:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end9:
	#	-- End function 
scheduler_terminate_current:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL38:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL38))(a0)
	bnez	a0, scheduler_LBB10_2 
	j	scheduler_LBB10_1 
scheduler_LBB10_1:
	j	scheduler_LBB10_6 
scheduler_LBB10_2:
scheduler_autoL39:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a2, %lo(%larel(current_process,scheduler_autoL39))(a0)
	li	a1, 3 
	sw	a1, 4(a2) 
	lw	a0, %lo(%larel(current_process,scheduler_autoL39))(a0)
	sw	a0, -12(s0) 
	call	scheduler_get_next_process 
	sw	a0, -16(s0) 
	lw	a0, -16(s0) 
	bnez	a0, scheduler_LBB10_4 
	j	scheduler_LBB10_3 
scheduler_LBB10_3:
scheduler_autoL40:
	auipc	a1, %hi(%pcrel(current_process))
	li	a0, 0 
	sw	a0, %lo(%larel(current_process,scheduler_autoL40))(a1)
	j	scheduler_LBB10_5 
scheduler_LBB10_4:
	lw	a1, -16(s0) 
scheduler_autoL41:
	auipc	a0, %hi(%pcrel(current_process))
	sw	a1, %lo(%larel(current_process,scheduler_autoL41))(a0)
	lw	a0, %lo(%larel(current_process,scheduler_autoL41))(a0)
	call	restore_context 
	j	scheduler_LBB10_5 
scheduler_LBB10_5:
	lw	a0, -12(s0) 
	call	free 
	j	scheduler_LBB10_6 
scheduler_LBB10_6:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end10:
	#	-- End function 
scheduler_L.str:
	.Text
	.asciz	"Invalid queue or process\n"
ready_queue:
	.Numeric
	.word	0
next_pid:
	.word	1                               # 0x1
scheduler_L.str.1:
	.Text
	.asciz	"Scheduler initialized successfully.\n"
scheduler_L.str.2:
	.asciz	"Failed to allocate PCB\n"
scheduler_L.str.3:
	.asciz	"Alarm received but no processes to schedule\n"
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
	.Code
insert_process:
	#	%bb.0: 
	addi	sp, sp, -48 
	sw	ra, 44(sp) # 4-byte Folded Spill 
	sw	s0, 40(sp) # 4-byte Folded Spill 
	addi	s0, sp, 48 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	sw	a2, -20(s0) 
	sw	a3, -24(s0) 
	sw	a4, -28(s0) 
	li	a0, 72 
	call	malloc 
	sw	a0, -32(s0) 
	lw	a0, -32(s0) 
	bnez	a0, process_info_LBB0_2 
	j	process_info_LBB0_1 
process_info_LBB0_1:
	j	process_info_LBB0_5 
process_info_LBB0_2:
	lw	a0, -16(s0) 
	lw	a1, -32(s0) 
	sw	a0, 0(a1) 
	lw	a0, -32(s0) 
	addi	a0, a0, 4 
	lw	a1, -20(s0) 
	li	a2, 50 
	call	my_strncpy 
	lw	a0, -24(s0) 
	lw	a1, -32(s0) 
	sw	a0, 56(a1) 
	lw	a0, -28(s0) 
	lw	a1, -32(s0) 
	sw	a0, 60(a1) 
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	bnez	a0, process_info_LBB0_4 
	j	process_info_LBB0_3 
process_info_LBB0_3:
	lw	a0, -32(s0) 
	sw	a0, 64(a0) 
	lw	a0, -32(s0) 
	sw	a0, 68(a0) 
	lw	a0, -32(s0) 
	lw	a1, -12(s0) 
	sw	a0, 0(a1) 
	j	process_info_LBB0_5 
process_info_LBB0_4:
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	lw	a0, 68(a0) 
	sw	a0, -36(s0) 
	lw	a0, -32(s0) 
	lw	a1, -36(s0) 
	sw	a0, 64(a1) 
	lw	a0, -36(s0) 
	lw	a1, -32(s0) 
	sw	a0, 68(a1) 
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	lw	a1, -32(s0) 
	sw	a0, 64(a1) 
	lw	a0, -32(s0) 
	lw	a1, -12(s0) 
	lw	a1, 0(a1) 
	sw	a0, 68(a1) 
	j	process_info_LBB0_5 
process_info_LBB0_5:
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
process_info_Lfunc_end0:
	#	-- End function 
my_strncpy:
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
	j	process_info_LBB1_1 
process_info_LBB1_1:
	lw	a0, -24(s0) 
	lw	a1, -20(s0) 
	addi	a1, a1, -1 
	li	a2, 0 
	sw	a2, -28(s0) # 4-byte Folded Spill 
	bge	a0, a1, process_info_LBB1_3 
	j	process_info_LBB1_2 
process_info_LBB1_2:
	lw	a0, -16(s0) 
	lw	a1, -24(s0) 
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	snez	a0, a0 
	sw	a0, -28(s0) # 4-byte Folded Spill 
	j	process_info_LBB1_3 
process_info_LBB1_3:
	lw	a0, -28(s0) # 4-byte Folded Reload 
	andi	a0, a0, 1 
	beqz	a0, process_info_LBB1_6 
	j	process_info_LBB1_4 
process_info_LBB1_4:
	lw	a0, -16(s0) 
	lw	a2, -24(s0) 
	add	a0, a0, a2 
	lbu	a0, 0(a0) 
	lw	a1, -12(s0) 
	add	a1, a1, a2 
	sb	a0, 0(a1) 
	j	process_info_LBB1_5 
process_info_LBB1_5:
	lw	a0, -24(s0) 
	addi	a0, a0, 1 
	sw	a0, -24(s0) 
	j	process_info_LBB1_1 
process_info_LBB1_6:
	lw	a0, -12(s0) 
	lw	a1, -24(s0) 
	add	a1, a0, a1 
	li	a0, 0 
	sb	a0, 0(a1) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
process_info_Lfunc_end1:
	#	-- End function 
delete_process:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	bnez	a0, process_info_LBB2_2 
	j	process_info_LBB2_1 
process_info_LBB2_1:
	j	process_info_LBB2_11 
process_info_LBB2_2:
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	sw	a0, -20(s0) 
	j	process_info_LBB2_3 
process_info_LBB2_3:
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
	lw	a1, -16(s0) 
	bne	a0, a1, process_info_LBB2_9 
	j	process_info_LBB2_4 
process_info_LBB2_4:
	lw	a1, -20(s0) 
	lw	a0, 64(a1) 
	bne	a0, a1, process_info_LBB2_6 
	j	process_info_LBB2_5 
process_info_LBB2_5:
	lw	a0, -20(s0) 
	call	free 
	lw	a1, -12(s0) 
	li	a0, 0 
	sw	a0, 0(a1) 
	j	process_info_LBB2_11 
process_info_LBB2_6:
	lw	a0, -20(s0) 
	lw	a0, 68(a0) 
	sw	a0, -24(s0) 
	lw	a0, -20(s0) 
	lw	a0, 64(a0) 
	sw	a0, -28(s0) 
	lw	a0, -28(s0) 
	lw	a1, -24(s0) 
	sw	a0, 64(a1) 
	lw	a0, -24(s0) 
	lw	a1, -28(s0) 
	sw	a0, 68(a1) 
	lw	a0, -20(s0) 
	lw	a1, -12(s0) 
	lw	a1, 0(a1) 
	bne	a0, a1, process_info_LBB2_8 
	j	process_info_LBB2_7 
process_info_LBB2_7:
	lw	a0, -28(s0) 
	lw	a1, -12(s0) 
	sw	a0, 0(a1) 
	j	process_info_LBB2_8 
process_info_LBB2_8:
	lw	a0, -20(s0) 
	call	free 
	j	process_info_LBB2_11 
process_info_LBB2_9:
	lw	a0, -20(s0) 
	lw	a0, 64(a0) 
	sw	a0, -20(s0) 
	j	process_info_LBB2_10 
process_info_LBB2_10:
	lw	a0, -20(s0) 
	lw	a1, -12(s0) 
	lw	a1, 0(a1) 
	bne	a0, a1, process_info_LBB2_3 
	j	process_info_LBB2_11 
process_info_LBB2_11:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
process_info_Lfunc_end2:
	#	-- End function 
display_processes:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, process_info_LBB3_2 
	j	process_info_LBB3_1 
process_info_LBB3_1:
	j	process_info_LBB3_5 
process_info_LBB3_2:
	lw	a0, -12(s0) 
	sw	a0, -16(s0) 
	j	process_info_LBB3_3 
process_info_LBB3_3:
	lw	a0, -16(s0) 
	lw	a0, 64(a0) 
	sw	a0, -16(s0) 
	j	process_info_LBB3_4 
process_info_LBB3_4:
	lw	a0, -16(s0) 
	lw	a1, -12(s0) 
	bne	a0, a1, process_info_LBB3_3 
	j	process_info_LBB3_5 
process_info_LBB3_5:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
process_info_Lfunc_end3:
	#	-- End function 
	.Code
heap_init:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
heap_alloc_autoL0:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL0))(a0)
	beqz	a0, heap_alloc_LBB0_2 
	j	heap_alloc_LBB0_1 
heap_alloc_LBB0_1:
	j	heap_alloc_LBB0_5 
heap_alloc_LBB0_2:
heap_alloc_autoL1:
	auipc	a0, %hi(%pcrel(heap_space))
	addi	a0, a0, %lo(%larel(heap_space,heap_alloc_autoL1))
	sw	a0, -12(s0) 
	lw	a1, -12(s0) 
	lui	a0, 256 
	addi	a0, a0, -12 
	sw	a0, 8(a1) 
	lw	a0, -12(s0) 
	li	a1, 0 
	sw	a1, 0(a0) 
	lw	a0, -12(s0) 
	sw	a1, 4(a0) 
heap_alloc_autoL2:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a2, %lo(%larel(free_blocks,heap_alloc_autoL2))(a0)
	lw	a3, -12(s0) 
	sw	a2, 0(a3) 
	lw	a2, -12(s0) 
	sw	a1, 4(a2) 
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL2))(a0)
	beqz	a0, heap_alloc_LBB0_4 
	j	heap_alloc_LBB0_3 
heap_alloc_LBB0_3:
	lw	a0, -12(s0) 
heap_alloc_autoL3:
	auipc	a1, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL3))(a1)
	sw	a0, 4(a1) 
	j	heap_alloc_LBB0_4 
heap_alloc_LBB0_4:
	lw	a0, -12(s0) 
heap_alloc_autoL4:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL4))(a1)
	j	heap_alloc_LBB0_5 
heap_alloc_LBB0_5:
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
	sw	a0, -16(s0) 
	call	heap_init 
	lw	a0, -16(s0) 
	addi	a0, a0, 3 
	andi	a0, a0, -4 
	sw	a0, -16(s0) 
heap_alloc_autoL5:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL5))(a0)
	sw	a0, -20(s0) 
	j	heap_alloc_LBB1_1 
heap_alloc_LBB1_1:
	lw	a0, -20(s0) 
	beqz	a0, heap_alloc_LBB1_14 
	j	heap_alloc_LBB1_2 
heap_alloc_LBB1_2:
	lw	a0, -20(s0) 
	lw	a0, 8(a0) 
	lw	a1, -16(s0) 
	bltu	a0, a1, heap_alloc_LBB1_13 
	j	heap_alloc_LBB1_3 
heap_alloc_LBB1_3:
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
	beqz	a0, heap_alloc_LBB1_5 
	j	heap_alloc_LBB1_4 
heap_alloc_LBB1_4:
	lw	a1, -20(s0) 
	lw	a0, 4(a1) 
	lw	a1, 0(a1) 
	sw	a0, 4(a1) 
	j	heap_alloc_LBB1_5 
heap_alloc_LBB1_5:
	lw	a0, -20(s0) 
	lw	a0, 4(a0) 
	beqz	a0, heap_alloc_LBB1_7 
	j	heap_alloc_LBB1_6 
heap_alloc_LBB1_6:
	lw	a1, -20(s0) 
	lw	a0, 0(a1) 
	lw	a1, 4(a1) 
	sw	a0, 0(a1) 
	j	heap_alloc_LBB1_8 
heap_alloc_LBB1_7:
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
heap_alloc_autoL6:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL6))(a1)
	j	heap_alloc_LBB1_8 
heap_alloc_LBB1_8:
	lw	a0, -20(s0) 
	lw	a1, 8(a0) 
	lw	a0, -16(s0) 
	addi	a0, a0, 12 
	bgeu	a0, a1, heap_alloc_LBB1_12 
	j	heap_alloc_LBB1_9 
heap_alloc_LBB1_9:
	lw	a0, -20(s0) 
	lw	a1, -16(s0) 
	add	a0, a0, a1 
	addi	a0, a0, 12 
	sw	a0, -24(s0) 
	lw	a0, -24(s0) 
	sw	a0, -28(s0) 
	lw	a0, -28(s0) 
	li	a1, 0 
	sw	a1, 0(a0) 
	lw	a0, -28(s0) 
	sw	a1, 4(a0) 
	lw	a0, -20(s0) 
	lw	a0, 8(a0) 
	lw	a2, -16(s0) 
	sub	a0, a0, a2 
	addi	a0, a0, -12 
	lw	a2, -28(s0) 
	sw	a0, 8(a2) 
	lw	a0, -16(s0) 
	lw	a2, -20(s0) 
	sw	a0, 8(a2) 
heap_alloc_autoL7:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a2, %lo(%larel(free_blocks,heap_alloc_autoL7))(a0)
	lw	a3, -28(s0) 
	sw	a2, 0(a3) 
	lw	a2, -28(s0) 
	sw	a1, 4(a2) 
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL7))(a0)
	beqz	a0, heap_alloc_LBB1_11 
	j	heap_alloc_LBB1_10 
heap_alloc_LBB1_10:
	lw	a0, -28(s0) 
heap_alloc_autoL8:
	auipc	a1, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL8))(a1)
	sw	a0, 4(a1) 
	j	heap_alloc_LBB1_11 
heap_alloc_LBB1_11:
	lw	a0, -28(s0) 
heap_alloc_autoL9:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL9))(a1)
	j	heap_alloc_LBB1_12 
heap_alloc_LBB1_12:
	lw	a0, -20(s0) 
	addi	a0, a0, 12 
	sw	a0, -12(s0) 
	j	heap_alloc_LBB1_15 
heap_alloc_LBB1_13:
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
	sw	a0, -20(s0) 
	j	heap_alloc_LBB1_1 
heap_alloc_LBB1_14:
	li	a0, 0 
	sw	a0, -12(s0) 
	j	heap_alloc_LBB1_15 
heap_alloc_LBB1_15:
	lw	a0, -12(s0) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
heap_alloc_Lfunc_end1:
	#	-- End function 
deallocate:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, heap_alloc_LBB2_2 
	j	heap_alloc_LBB2_1 
heap_alloc_LBB2_1:
	j	heap_alloc_LBB2_20 
heap_alloc_LBB2_2:
	lw	a0, -12(s0) 
	addi	a0, a0, -12 
	sw	a0, -16(s0) 
heap_alloc_autoL10:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL10))(a0)
	sw	a0, -20(s0) 
	j	heap_alloc_LBB2_3 
heap_alloc_LBB2_3:
	lw	a0, -20(s0) 
	beqz	a0, heap_alloc_LBB2_17 
	j	heap_alloc_LBB2_4 
heap_alloc_LBB2_4:
	lw	a0, -20(s0) 
	lw	a1, 8(a0) 
	add	a0, a0, a1 
	addi	a0, a0, 12 
	lw	a1, -16(s0) 
	bne	a0, a1, heap_alloc_LBB2_6 
	j	heap_alloc_LBB2_5 
heap_alloc_LBB2_5:
	lw	a0, -16(s0) 
	lw	a0, 8(a0) 
	lw	a1, -20(s0) 
	lw	a2, 8(a1) 
	add	a0, a0, a2 
	addi	a0, a0, 12 
	sw	a0, 8(a1) 
	j	heap_alloc_LBB2_20 
heap_alloc_LBB2_6:
	lw	a0, -16(s0) 
	lw	a1, 8(a0) 
	add	a0, a0, a1 
	addi	a0, a0, 12 
	lw	a1, -20(s0) 
	bne	a0, a1, heap_alloc_LBB2_15 
	j	heap_alloc_LBB2_7 
heap_alloc_LBB2_7:
	lw	a0, -20(s0) 
	lw	a0, 8(a0) 
	lw	a1, -16(s0) 
	lw	a2, 8(a1) 
	add	a0, a0, a2 
	addi	a0, a0, 12 
	sw	a0, 8(a1) 
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
	beqz	a0, heap_alloc_LBB2_9 
	j	heap_alloc_LBB2_8 
heap_alloc_LBB2_8:
	lw	a1, -20(s0) 
	lw	a0, 4(a1) 
	lw	a1, 0(a1) 
	sw	a0, 4(a1) 
	j	heap_alloc_LBB2_9 
heap_alloc_LBB2_9:
	lw	a0, -20(s0) 
	lw	a0, 4(a0) 
	beqz	a0, heap_alloc_LBB2_11 
	j	heap_alloc_LBB2_10 
heap_alloc_LBB2_10:
	lw	a1, -20(s0) 
	lw	a0, 0(a1) 
	lw	a1, 4(a1) 
	sw	a0, 0(a1) 
	j	heap_alloc_LBB2_12 
heap_alloc_LBB2_11:
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
heap_alloc_autoL11:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL11))(a1)
	j	heap_alloc_LBB2_12 
heap_alloc_LBB2_12:
heap_alloc_autoL12:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL12))(a0)
	lw	a2, -16(s0) 
	sw	a1, 0(a2) 
	lw	a2, -16(s0) 
	li	a1, 0 
	sw	a1, 4(a2) 
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL12))(a0)
	beqz	a0, heap_alloc_LBB2_14 
	j	heap_alloc_LBB2_13 
heap_alloc_LBB2_13:
	lw	a0, -16(s0) 
heap_alloc_autoL13:
	auipc	a1, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL13))(a1)
	sw	a0, 4(a1) 
	j	heap_alloc_LBB2_14 
heap_alloc_LBB2_14:
	lw	a0, -16(s0) 
heap_alloc_autoL14:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL14))(a1)
	j	heap_alloc_LBB2_20 
heap_alloc_LBB2_15:
	j	heap_alloc_LBB2_16 
heap_alloc_LBB2_16:
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
	sw	a0, -20(s0) 
	j	heap_alloc_LBB2_3 
heap_alloc_LBB2_17:
heap_alloc_autoL15:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL15))(a0)
	lw	a2, -16(s0) 
	sw	a1, 0(a2) 
	lw	a2, -16(s0) 
	li	a1, 0 
	sw	a1, 4(a2) 
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL15))(a0)
	beqz	a0, heap_alloc_LBB2_19 
	j	heap_alloc_LBB2_18 
heap_alloc_LBB2_18:
	lw	a0, -16(s0) 
heap_alloc_autoL16:
	auipc	a1, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL16))(a1)
	sw	a0, 4(a1) 
	j	heap_alloc_LBB2_19 
heap_alloc_LBB2_19:
	lw	a0, -16(s0) 
heap_alloc_autoL17:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL17))(a1)
	j	heap_alloc_LBB2_20 
heap_alloc_LBB2_20:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
heap_alloc_Lfunc_end2:
	#	-- End function 
free_blocks:
	.Numeric
	.word	0
