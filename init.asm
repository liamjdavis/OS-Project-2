# Init process to run ROMs 4, 5, and 6
# This is the init process that will request execution of ROMs 4-6

.Code
# Entry point
_start:
    # Request execution of ROM 4
    li a1, 4          # Load ROM number into a1
    li a0, 0xca110002 # System call number for ROM execution
    ecall             # Make the system call

    # Request execution of ROM 6
    li a1, 6          # Load ROM number into a0
    li a0, 0xca110002 # System call number for ROM execution
    ecall             # Make the system call

    # Request execution of ROM 5
    li a1, 5          # Load ROM number into a0
    li a0, 0xca110002 # System call number for ROM execution
    ecall             # Make the system call

    # Halt after all ROMs are requested
    li a0, 0xca110001 # System call number for exit
    ecall             # Make the system call to exit

.Text
msg_error: "Failed to execute ROM\n" 