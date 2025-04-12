# OS-Project-2

## Implementation Status
Out of the 14 required "features" for this project (the 5 bullet points under "The Setup" section, 4 under "Kernel behavior", 5 undern "kernel functions), 13 have been fully implemented and are functioning as expected based on our tests. The only component not implemented is virtual addressing via the MMU. 

#### The Setup (4/5 implemented)
✓ Third ROM as init program
✓ Additional ROMs as user programs
✓ RUN system call for process creation
✓ EXIT system call for process termination
✓ PRINT system call for console output

#### Kernel Behavior (3/4 implemented)
✓ Fixed-size memory allocation (32 KB per process)
✗ Virtual addressing mode with MMU (not implemented)
✓ Configurable scheduling quanta with ALARM interrupts
✓ CPU scheduler for process management

#### Kernel Functions (5/5 implemented)
✓ malloc() and free() implementation
✓ syscall_handler() with proper dispatching
✓ Doubly-linked list manipulation
✓ RAM block management
✓ Process information structure management

## Known Error
We encountered the following error during development:
```
ERROR: ERETInstruction.execute(): Failed to restore register x1 from stack @0x00003feb
```
This error appears to be related to process switching and stack pointer management. The ERET instruction (we think) requires access to the current process's stack pointer (sp) to function correctly. However, proper process switching requires loading the upcoming process's sp (stored in the process information structure) into the sp register. As a workaround, we commented out the sp loading code, as there doesn't seem to be a way to handle both requirements simultaneously.

## Build Instructions
1. Assemble the initial programs:
   ```
   f-assemble init.asm
   f-assemble do-nothing.asm
   ```
2. Create combo.vmx:
   ```
   f-build combo.vmx kernel-stub.asm kernel.c process_info/process_info.c utility/utility.c heap_allocator/heap_alloc.c memory_allocator/memory_alloc.c
   ```
3. Simulate with multiple programs:
   ```
   f-simulate bios.vmx combo.vmx init.vmx do-nothing.vmx do-nothing.vmx do-nothing.vmx
   ```
**Note: mainMemoryPages has been increased to 64 to accommodate 4 programs (init + 3 user programs).**

## Implementation Details

### File Structure and Functionality

1. **kernel.c**
   - Implements syscall_handler() with support for:
     - EXIT (0xca110001): Process termination with exit status
     - RUN (0xca110002): New process creation from specified ROM
     - PRINT (0xca110003): Console string printing
   - Handles process scheduling and quanta management via ALARM interrupts
   - Manages fixed-size memory allocation (32 KB per process)

2. **heap_allocator/heap_alloc.c**
   - File taken from useful codes shared drive with slight tweaks to integrate with the rest of the code

3. **memory_allocator/memory_alloc.c**
   - Wrapper over heap_alloc that handles malloc and free calls

4. **process_info/process_info.c**
   - Defines and manages process information structure
   - Implements circular linked list for process management
   - Stores process-specific data (stack pointer, memory allocation, etc.) in the kernel heap

5. **utility/utility.c**
   - Very similar if not the exact same as code provided in useful-code directory

6. **init.asm** 
    - A simple init process that makes RUN syscalls for user program 4, 5, and 6 (all "do-nothing.asm")
7. **do-nothing.asm**
    - Does nothing... though the number of instructions in the file has been increased to ~1000 to ensure the ALARM interupt happens a few times.