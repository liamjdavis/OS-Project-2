# Init process to run ROMs 4, 5, and 6
# This is the init process that will request execution of ROMs 4-6

.Code
# Entry point
_start:
    # Request execution of ROM 4
    li a0, 4          # Load ROM number into a0
    li a7, 1          # System call number 1 for ROM execution
    ecall             # Make the system call

    # Request execution of ROM 6
    li a0, 6          # Load ROM number into a0
    li a7, 1          # System call number 1 for ROM execution
    ecall             # Make the system call

    # Request execution of ROM 5
    li a0, 5          # Load ROM number into a0
    li a7, 1          # System call number 1 for ROM execution
    ecall             # Make the system call

    # Halt after all ROMs are requested
    li a7, 93         # System call number 93 for exit
    ecall             # Make the system call to exit

.Text
msg_error: "Failed to execute ROM\n" 