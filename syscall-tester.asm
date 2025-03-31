.Code

_start:
    # Set up stack pointer
    lw      sp,     stack_top

    # Test PRINT syscall
    la      a0,     hello_msg
    call    print
    
    # Test RUN syscall with a valid ROM number
    li      a0,     1           # Try to run ROM #1
    call    run
    
    # Check return value from RUN
    mv      s0,     a0          # Save return value
    la      a0,     run_result_msg
    call    print
    
    # Convert return value to character and print
    mv      a0,     s0          # Restore return value
    addi    a0,     a0,     48  # Convert number to ASCII ('0' = 48)
    la      t0,     result_msg
    sb      a0,     0(t0)       # Store ASCII character at first byte of result_msg
    la      a0,     result_msg
    call    print
    
    # Test EXIT syscall
    li      a0,     0           # Exit status 0
    call    exit
    
    # Should never reach here
    la      a0,     error_msg
    call    print
    halt

# ----- SYSCALL WRAPPERS -----
# Instead of including syscall-wrappers.asm, put the code directly here

# exit()
#   Arguments:
#     a0:  The exit status of the terminating process.
exit:
    mv      a1,     a0          # Move the exit status into a1 (arg[1])
    lw      a0,     SYSCALL_EXIT_CODE    # Load the exit syscall code into a0 (arg[0])
    ecall
    ebreak                      # If we reach here, something is terribly wrong.

# run()
#   Arguments:
#     a0:  The ROM number to load into the new process
#   Returns:
#     a0:  0 = success, 1 = invalid ROM number, 2 = insufficient RAM, 3 = other error
run:
    mv      a1,     a0          # Move the ROM number into a1 (arg[1])
    lw      a0,     SYSCALL_RUN_CODE     # Load the run syscall code into a0 (arg[0])
    ecall
    ret                         # The return value of the syscall is the return value of this wrapper function.

# print()
#   Arguments:
#     a0:  The null-terminated string (char array) to print to the console.
print:
    mv      a1,     a0          # Move the string pointer into a1 (arg[1])
    lw      a0,     SYSCALL_PRINT_CODE   # Load the print syscall code into a0 (arg[0])
    ecall
    ret

    .Numeric
stack_top:          0x10000     # Just a placeholder, the kernel will set the actual stack

# System call codes
SYSCALL_EXIT_CODE:  0xca110001
SYSCALL_RUN_CODE:   0xca110002
SYSCALL_PRINT_CODE: 0xca110003

    .Text
hello_msg:          "Hello from test program! Testing syscalls...\n"
run_result_msg:     "RUN syscall returned: "
result_msg:         "X\n"
error_msg:          "ERROR: Should not reach here after EXIT syscall!\n"