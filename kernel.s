	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"kernel.c"
	.globl	init_process_management         # -- Begin function init_process_management
	.p2align	2
	.type	init_process_management,@function
init_process_management:                # @init_process_management
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	lui	a1, %hi(current_process)
	li	a0, 0
	sw	a0, %lo(current_process)(a1)
	lui	a0, %hi(kernel_L.str)
	addi	a0, a0, %lo(kernel_L.str)
	call	print
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
kernel_Lfunc_end0:
	.size	init_process_management, kernel_Lfunc_end0-init_process_management
                                        # -- End function
	.globl	init_memory                     # -- Begin function init_memory
	.p2align	2
	.type	init_memory,@function
init_memory:                            # @init_memory
# %bb.0:
	addi	sp, sp, -64
	sw	ra, 60(sp)                      # 4-byte Folded Spill
	sw	s0, 56(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 64
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lui	a0, %hi(kernel_end_marker)
	addi	a0, a0, %lo(kernel_end_marker)
	addi	a0, a0, 16
	sw	a0, -20(s0)
	lw	a0, -12(s0)
	sw	a0, -24(s0)
	lui	a0, %hi(kernel_L.str.1)
	addi	a0, a0, %lo(kernel_L.str.1)
	call	print
	j	kernel_LBB1_1
kernel_LBB1_1:                                # =>This Innerkernel_Loop Header: Depth=1
	lw	a0, -24(s0)
	lui	a1, 8
	add	a1, a0, a1
	lw	a0, -16(s0)
	bltu	a0, a1, kernel_LBB1_3
	j	kernel_LBB1_2
kernel_LBB1_2:                                #   inkernel_Loop: Header=BB1_1 Depth=1
	lw	a0, -24(s0)
	sw	a0, -28(s0)
	lui	a1, %hi(free_list_head)
	lw	a0, %lo(free_list_head)(a1)
	lw	a2, -28(s0)
	sw	a0, 0(a2)
	lw	a0, -28(s0)
	sw	a0, %lo(free_list_head)(a1)
	lw	a0, -24(s0)
	lui	a1, 8
	add	a0, a0, a1
	sw	a0, -24(s0)
	j	kernel_LBB1_1
kernel_LBB1_3:
	call	init_process_management
	lw	a0, -20(s0)
	call	heap_init
	lui	a1, %hi(heap_free_list)
	sw	a0, %lo(heap_free_list)(a1)
	li	a0, 0
	sw	a0, -32(s0)
	lui	a0, %hi(free_list_head)
	lw	a0, %lo(free_list_head)(a0)
	sw	a0, -36(s0)
	j	kernel_LBB1_4
kernel_LBB1_4:                                # =>This Innerkernel_Loop Header: Depth=1
	lw	a0, -36(s0)
	beqz	a0, kernel_LBB1_6
	j	kernel_LBB1_5
kernel_LBB1_5:                                #   inkernel_Loop: Header=BB1_4 Depth=1
	lw	a0, -32(s0)
	addi	a0, a0, 1
	sw	a0, -32(s0)
	lw	a0, -36(s0)
	lw	a0, 0(a0)
	sw	a0, -36(s0)
	j	kernel_LBB1_4
kernel_LBB1_6:
	lui	a0, %hi(kernel_L.str.2)
	addi	a0, a0, %lo(kernel_L.str.2)
	call	print
	lw	a0, -32(s0)
	addi	a1, s0, -45
	sw	a1, -52(s0)                     # 4-byte Folded Spill
	call	int_to_hex
	lw	a0, -52(s0)                     # 4-byte Folded Reload
	call	print
	lui	a0, %hi(kernel_L.str.3)
	addi	a0, a0, %lo(kernel_L.str.3)
	call	print
	lw	ra, 60(sp)                      # 4-byte Folded Reload
	lw	s0, 56(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 64
	ret
kernel_Lfunc_end1:
	.size	init_memory, kernel_Lfunc_end1-init_memory
                                        # -- End function
	.globl	schedule                        # -- Begin function schedule
	.p2align	2
	.type	schedule,@function
schedule:                               # @schedule
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -16(s0)
	sw	a1, -20(s0)
	lui	a0, %hi(current_process)
	lw	a0, %lo(current_process)(a0)
	bnez	a0, kernel_LBB2_2
	j	kernel_LBB2_1
kernel_LBB2_1:
	lui	a0, %hi(kernel_L.str.4)
	addi	a0, a0, %lo(kernel_L.str.4)
	call	print
	li	a0, 0
	sw	a0, -12(s0)
	j	kernel_LBB2_3
kernel_LBB2_2:
	lw	a0, -16(s0)
	lui	a1, %hi(current_process)
	sw	a1, -24(s0)                     # 4-byte Folded Spill
	lw	a2, %lo(current_process)(a1)
	sw	a0, 56(a2)
	lw	a0, -20(s0)
	lw	a2, %lo(current_process)(a1)
	sw	a0, 60(a2)
	lw	a0, %lo(current_process)(a1)
	lw	a0, 64(a0)
	sw	a0, %lo(current_process)(a1)
	lui	a0, %hi(kernel_L.str.5)
	addi	a0, a0, %lo(kernel_L.str.5)
	call	print
	lw	a0, -24(s0)                     # 4-byte Folded Reload
	lw	a0, %lo(current_process)(a0)
	addi	a0, a0, 4
	call	print
	lui	a0, %hi(kernel_L.str.6)
	addi	a0, a0, %lo(kernel_L.str.6)
	call	print
	lw	a0, -24(s0)                     # 4-byte Folded Reload
	lw	a0, %lo(current_process)(a0)
	sw	a0, -12(s0)
	j	kernel_LBB2_3
kernel_LBB2_3:
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
kernel_Lfunc_end2:
	.size	schedule, kernel_Lfunc_end2-schedule
                                        # -- End function
	.globl	handle_process_exit             # -- Begin function handle_process_exit
	.p2align	2
	.type	handle_process_exit,@function
handle_process_exit:                    # @handle_process_exit
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	lui	a0, %hi(current_process)
	lw	a0, %lo(current_process)(a0)
	bnez	a0, kernel_LBB3_2
	j	kernel_LBB3_1
kernel_LBB3_1:
	lui	a0, %hi(kernel_L.str.7)
	addi	a0, a0, %lo(kernel_L.str.7)
	call	print
	j	kernel_LBB3_7
kernel_LBB3_2:
	lui	a0, %hi(current_process)
	lw	a1, %lo(current_process)(a0)
	sw	a1, -12(s0)
	lw	a1, %lo(current_process)(a0)
	lw	a1, 0(a1)
	sw	a1, -16(s0)
	lw	a1, %lo(current_process)(a0)
	lw	a1, 68(a1)
	sw	a1, %lo(current_process)(a0)
	lw	a0, %lo(current_process)(a0)
	lw	a1, -12(s0)
	bne	a0, a1, kernel_LBB3_4
	j	kernel_LBB3_3
kernel_LBB3_3:
	lui	a1, %hi(current_process)
	li	a0, 0
	sw	a0, %lo(current_process)(a1)
	j	kernel_LBB3_4
kernel_LBB3_4:
	lw	a1, -16(s0)
	lui	a0, %hi(current_process)
	sw	a0, -20(s0)                     # 4-byte Folded Spill
	addi	a0, a0, %lo(current_process)
	call	delete_process
	lui	a0, %hi(kernel_L.str.8)
	addi	a0, a0, %lo(kernel_L.str.8)
	call	print
	lw	a0, -20(s0)                     # 4-byte Folded Reload
	lw	a0, %lo(current_process)(a0)
	bnez	a0, kernel_LBB3_6
	j	kernel_LBB3_5
kernel_LBB3_5:
	lui	a0, %hi(kernel_L.str.9)
	addi	a0, a0, %lo(kernel_L.str.9)
	call	print
	j	kernel_LBB3_7
kernel_LBB3_6:
	lui	a0, %hi(kernel_L.str.10)
	addi	a0, a0, %lo(kernel_L.str.10)
	call	print
	lui	a0, %hi(current_process)
	lw	a1, %lo(current_process)(a0)
	lw	a0, 56(a1)
	lw	a1, 60(a1)
	call	schedule
	j	kernel_LBB3_7
kernel_LBB3_7:
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
kernel_Lfunc_end3:
	.size	handle_process_exit, kernel_Lfunc_end3-handle_process_exit
                                        # -- End function
	.globl	run_programs                    # -- Begin function run_programs
	.p2align	2
	.type	run_programs,@function
run_programs:                           # @run_programs
# %bb.0:
	addi	sp, sp, -128
	sw	ra, 124(sp)                     # 4-byte Folded Spill
	sw	s0, 120(sp)                     # 4-byte Folded Spill
	addi	s0, sp, 128
	sw	a0, -12(s0)
	lui	a0, %hi(kernel_L.str.11)
	addi	a0, a0, %lo(kernel_L.str.11)
	call	print
	lw	a0, -12(s0)
	addi	a1, s0, -24
	sw	a1, -112(s0)                    # 4-byte Folded Spill
	call	int_to_hex
	lw	a0, -112(s0)                    # 4-byte Folded Reload
	call	print
	lui	a0, %hi(kernel_L.str.6)
	addi	a0, a0, %lo(kernel_L.str.6)
	sw	a0, -108(s0)                    # 4-byte Folded Spill
	call	print
	lui	a0, %hi(kernel_L.str.12)
	addi	a0, a0, %lo(kernel_L.str.12)
	call	print
	lw	a1, -112(s0)                    # 4-byte Folded Reload
	lui	a0, %hi(ROM_device_code)
	sw	a0, -104(s0)                    # 4-byte Folded Spill
	lw	a0, %lo(ROM_device_code)(a0)
	call	int_to_hex
	lw	a0, -112(s0)                    # 4-byte Folded Reload
	call	print
	lui	a0, %hi(kernel_L.str.13)
	addi	a0, a0, %lo(kernel_L.str.13)
	call	print
	lw	a1, -112(s0)                    # 4-byte Folded Reload
	lw	a0, -12(s0)
	call	int_to_hex
	lw	a0, -112(s0)                    # 4-byte Folded Reload
	call	print
	lw	a0, -108(s0)                    # 4-byte Folded Reload
	call	print
	lw	a0, -104(s0)                    # 4-byte Folded Reload
	lw	a0, %lo(ROM_device_code)(a0)
	lw	a1, -12(s0)
	call	find_device
	sw	a0, -28(s0)
	lw	a0, -28(s0)
	bnez	a0, kernel_LBB4_2
	j	kernel_LBB4_1
kernel_LBB4_1:
	lui	a0, %hi(kernel_L.str.14)
	addi	a0, a0, %lo(kernel_L.str.14)
	call	print
	lw	a0, -12(s0)
	addi	a1, s0, -24
	sw	a1, -116(s0)                    # 4-byte Folded Spill
	call	int_to_hex
	lw	a0, -116(s0)                    # 4-byte Folded Reload
	call	print
	lui	a0, %hi(kernel_L.str.15)
	addi	a0, a0, %lo(kernel_L.str.15)
	call	print
	j	kernel_LBB4_9
kernel_LBB4_2:
	lui	a0, %hi(kernel_L.str.16)
	addi	a0, a0, %lo(kernel_L.str.16)
	call	print
	lw	a0, -28(s0)
	lw	a0, 4(a0)
	lui	a1, %hi(DMA_portal_ptr)
	lw	a2, %lo(DMA_portal_ptr)(a1)
	sw	a0, 0(a2)
	lui	a0, %hi(kernel_limit)
	lw	a0, %lo(kernel_limit)(a0)
	lw	a2, %lo(DMA_portal_ptr)(a1)
	sw	a0, 4(a2)
	lw	a2, -28(s0)
	lw	a0, 8(a2)
	lw	a2, 4(a2)
	sub	a0, a0, a2
	lw	a1, %lo(DMA_portal_ptr)(a1)
	sw	a0, 8(a1)
	lui	a1, %hi(kernel_L.str.17)
	addi	a1, a1, %lo(kernel_L.str.17)
	addi	a0, s0, -80
	li	a2, 52
	call	copy_str
	lw	a0, -12(s0)
	addi	a1, s0, -89
	call	int_to_dec
	li	a0, 0
	sw	a0, -96(s0)
	j	kernel_LBB4_3
kernel_LBB4_3:                                # =>This Innerkernel_Loop Header: Depth=1
	lw	a1, -96(s0)
	addi	a0, s0, -80
	add	a0, a0, a1
	lbu	a0, 0(a0)
	beqz	a0, kernel_LBB4_5
	j	kernel_LBB4_4
kernel_LBB4_4:                                #   inkernel_Loop: Header=BB4_3 Depth=1
	lw	a0, -96(s0)
	addi	a0, a0, 1
	sw	a0, -96(s0)
	j	kernel_LBB4_3
kernel_LBB4_5:
	lw	a2, -96(s0)
	addi	a0, s0, -80
	sw	a0, -124(s0)                    # 4-byte Folded Spill
	add	a0, a0, a2
	li	a1, 52
	sub	a2, a1, a2
	addi	a1, s0, -89
	call	copy_str
	lw	a2, -124(s0)                    # 4-byte Folded Reload
	lui	a0, %hi(current_process)
	sw	a0, -120(s0)                    # 4-byte Folded Spill
	addi	a1, a0, %lo(current_process)
	lw	a0, %lo(current_process)(a0)
	seqz	a0, a0
	addi	a0, a0, -1
	and	a0, a0, a1
	sw	a0, -100(s0)
	lw	a0, -100(s0)
	lui	a4, %hi(next_pid)
	lw	a1, %lo(next_pid)(a4)
	addi	a3, a1, 1
	sw	a3, %lo(next_pid)(a4)
	lui	a3, %hi(kernel_limit)
	lw	a4, %lo(kernel_limit)(a3)
	lui	a3, 8
	add	a3, a4, a3
	call	insert_process
	lui	a0, %hi(kernel_L.str.18)
	addi	a0, a0, %lo(kernel_L.str.18)
	call	print
	lw	a0, -120(s0)                    # 4-byte Folded Reload
	lw	a0, %lo(current_process)(a0)
	call	display_processes
	lw	a0, -120(s0)                    # 4-byte Folded Reload
	lw	a0, %lo(current_process)(a0)
	beqz	a0, kernel_LBB4_7
	j	kernel_LBB4_6
kernel_LBB4_6:
	lui	a0, %hi(current_process)
	lw	a1, %lo(current_process)(a0)
	lw	a0, 64(a1)
	bne	a0, a1, kernel_LBB4_8
	j	kernel_LBB4_7
kernel_LBB4_7:
	lui	a0, %hi(kernel_L.str.19)
	addi	a0, a0, %lo(kernel_L.str.19)
	call	print
	li	a1, 0
	mv	a0, a1
	call	schedule
	lui	a0, %hi(kernel_L.str.20)
	addi	a0, a0, %lo(kernel_L.str.20)
	call	print
	lui	a0, %hi(current_process)
	lw	a0, %lo(current_process)(a0)
	call	display_processes
	j	kernel_LBB4_8
kernel_LBB4_8:
	lui	a0, %hi(kernel_L.str.21)
	addi	a0, a0, %lo(kernel_L.str.21)
	call	print
	lui	a0, %hi(kernel_limit)
	lw	a0, %lo(kernel_limit)(a0)
	call	userspace_jump
	j	kernel_LBB4_9
kernel_LBB4_9:
	lw	ra, 124(sp)                     # 4-byte Folded Reload
	lw	s0, 120(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 128
	ret
kernel_Lfunc_end4:
	.size	run_programs, kernel_Lfunc_end4-run_programs
                                        # -- End function
	.type	kernel_L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
kernel_L.str:
	.asciz	"Process management system initialized.\n"
	.size	kernel_L.str, 40

	.type	kernel_L.str.1,@object                # @.str.1
kernel_L.str.1:
	.asciz	"Initializing RAM free block list...\n"
	.size	kernel_L.str.1, 37

	.type	free_list_head,@object          # @free_list_head
	.section	.sbss,"aw",@nobits
	.p2align	2, 0x0
free_list_head:
	.word	0
	.size	free_list_head, 4

	.type	heap_free_list,@object          # @heap_free_list
	.p2align	2, 0x0
heap_free_list:
	.word	0
	.size	heap_free_list, 4

	.type	kernel_L.str.2,@object                # @.str.2
	.section	.rodata.str1.1,"aMS",@progbits,1
kernel_L.str.2:
	.asciz	"Created "
	.size	kernel_L.str.2, 9

	.type	kernel_L.str.3,@object                # @.str.3
kernel_L.str.3:
	.asciz	" free blocks. \n"
	.size	kernel_L.str.3, 16

	.type	kernel_L.str.4,@object                # @.str.4
kernel_L.str.4:
	.asciz	"No processes to schedule\n"
	.size	kernel_L.str.4, 26

	.type	kernel_L.str.5,@object                # @.str.5
kernel_L.str.5:
	.asciz	"Scheduling process: "
	.size	kernel_L.str.5, 21

	.type	kernel_L.str.6,@object                # @.str.6
kernel_L.str.6:
	.asciz	"\n"
	.size	kernel_L.str.6, 2

	.type	kernel_L.str.7,@object                # @.str.7
kernel_L.str.7:
	.asciz	"No processes to exit\n"
	.size	kernel_L.str.7, 22

	.type	kernel_L.str.8,@object                # @.str.8
kernel_L.str.8:
	.asciz	"Process exited. "
	.size	kernel_L.str.8, 17

	.type	kernel_L.str.9,@object                # @.str.9
kernel_L.str.9:
	.asciz	"No more processes to run.\n"
	.size	kernel_L.str.9, 27

	.type	kernel_L.str.10,@object               # @.str.10
kernel_L.str.10:
	.asciz	"Scheduling next process.\n"
	.size	kernel_L.str.10, 26

	.type	kernel_L.str.11,@object               # @.str.11
kernel_L.str.11:
	.asciz	"Searching for ROM #"
	.size	kernel_L.str.11, 20

	.type	kernel_L.str.12,@object               # @.str.12
kernel_L.str.12:
	.asciz	"ROM_device_code: "
	.size	kernel_L.str.12, 18

	.type	kernel_L.str.13,@object               # @.str.13
kernel_L.str.13:
	.asciz	", rom_number: "
	.size	kernel_L.str.13, 15

	.type	kernel_L.str.14,@object               # @.str.14
kernel_L.str.14:
	.asciz	"ROM #"
	.size	kernel_L.str.14, 6

	.type	kernel_L.str.15,@object               # @.str.15
kernel_L.str.15:
	.asciz	" not found. \n"
	.size	kernel_L.str.15, 14

	.type	kernel_L.str.16,@object               # @.str.16
kernel_L.str.16:
	.asciz	"Running program...\n"
	.size	kernel_L.str.16, 20

	.type	kernel_L.str.17,@object               # @.str.17
kernel_L.str.17:
	.asciz	"Program-"
	.size	kernel_L.str.17, 9

	.type	next_pid,@object                # @next_pid
	.section	.sdata,"aw",@progbits
	.p2align	2, 0x0
next_pid:
	.word	1                               # 0x1
	.size	next_pid, 4

	.type	kernel_L.str.18,@object               # @.str.18
	.section	.rodata.str1.1,"aMS",@progbits,1
kernel_L.str.18:
	.asciz	"Process list after insertion:\n"
	.size	kernel_L.str.18, 31

	.type	kernel_L.str.19,@object               # @.str.19
kernel_L.str.19:
	.asciz	"First process - scheduling...\n"
	.size	kernel_L.str.19, 31

	.type	kernel_L.str.20,@object               # @.str.20
kernel_L.str.20:
	.asciz	"After scheduling:\n"
	.size	kernel_L.str.20, 19

	.type	kernel_L.str.21,@object               # @.str.21
kernel_L.str.21:
	.asciz	"Jumping to userspace...\n"
	.size	kernel_L.str.21, 25

	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym init_process_management
	.addrsig_sym print
	.addrsig_sym heap_init
	.addrsig_sym int_to_hex
	.addrsig_sym schedule
	.addrsig_sym delete_process
	.addrsig_sym find_device
	.addrsig_sym copy_str
	.addrsig_sym int_to_dec
	.addrsig_sym insert_process
	.addrsig_sym display_processes
	.addrsig_sym userspace_jump
	.addrsig_sym current_process
	.addrsig_sym kernel_end_marker
	.addrsig_sym free_list_head
	.addrsig_sym heap_free_list
	.addrsig_sym ROM_device_code
	.addrsig_sym DMA_portal_ptr
	.addrsig_sym kernel_limit
	.addrsig_sym next_pid
