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
	addi	sp, sp, -48
	sw	ra, 44(sp)                      # 4-byte Folded Spill
	sw	s0, 40(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 48
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	lw	a0, -12(s0)
	sw	a0, -20(s0)
	lw	a0, -12(s0)
	addi	a0, a0, -2048
	addi	a0, a0, -2048
	lui	a1, %hi(statics_limit)
	sw	a0, %lo(statics_limit)(a1)
	lui	a0, %hi(kernel_L.str.1)
	addi	a0, a0, %lo(kernel_L.str.1)
	call	print
	j	kernel_LBB1_1
kernel_LBB1_1:                                # =>This Innerkernel_Loop Header: Depth=1
	lw	a0, -20(s0)
	lui	a1, 8
	add	a1, a0, a1
	lw	a0, -16(s0)
	bltu	a0, a1, kernel_LBB1_3
	j	kernel_LBB1_2
kernel_LBB1_2:                                #   inkernel_Loop: Header=BB1_1 Depth=1
	lw	a0, -20(s0)
	sw	a0, -24(s0)
	lui	a1, %hi(free_list_head)
	lw	a0, %lo(free_list_head)(a1)
	lw	a2, -24(s0)
	sw	a0, 0(a2)
	lw	a0, -24(s0)
	sw	a0, %lo(free_list_head)(a1)
	lw	a0, -20(s0)
	lui	a1, 8
	add	a0, a0, a1
	sw	a0, -20(s0)
	j	kernel_LBB1_1
kernel_LBB1_3:
	lui	a0, %hi(statics_limit)
	lw	a0, %lo(statics_limit)(a0)
	call	heap_init
	call	init_process_management
	li	a0, 0
	sw	a0, -28(s0)
	lui	a0, %hi(free_list_head)
	lw	a0, %lo(free_list_head)(a0)
	sw	a0, -32(s0)
	j	kernel_LBB1_4
kernel_LBB1_4:                                # =>This Innerkernel_Loop Header: Depth=1
	lw	a0, -32(s0)
	beqz	a0, kernel_LBB1_6
	j	kernel_LBB1_5
kernel_LBB1_5:                                #   inkernel_Loop: Header=BB1_4 Depth=1
	lw	a0, -28(s0)
	addi	a0, a0, 1
	sw	a0, -28(s0)
	lw	a0, -32(s0)
	lw	a0, 0(a0)
	sw	a0, -32(s0)
	j	kernel_LBB1_4
kernel_LBB1_6:
	lui	a0, %hi(kernel_L.str.2)
	addi	a0, a0, %lo(kernel_L.str.2)
	call	print
	lw	a0, -28(s0)
	addi	a1, s0, -41
	sw	a1, -48(s0)                     # 4-byte Folded Spill
	call	int_to_hex
	lw	a0, -48(s0)                     # 4-byte Folded Reload
	call	print
	lui	a0, %hi(kernel_L.str.3)
	addi	a0, a0, %lo(kernel_L.str.3)
	call	print
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
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
	sw	a0, 4(a2)
	lw	a0, -20(s0)
	lw	a2, %lo(current_process)(a1)
	sw	a0, 8(a2)
	lw	a0, %lo(current_process)(a1)
	lw	a0, 12(a0)
	sw	a0, %lo(current_process)(a1)
	lui	a0, %hi(kernel_L.str.5)
	addi	a0, a0, %lo(kernel_L.str.5)
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
	lui	a0, %hi(kernel_L.str.6)
	addi	a0, a0, %lo(kernel_L.str.6)
	call	print
	j	kernel_LBB3_5
kernel_LBB3_2:
	lui	a0, %hi(current_process)
	lw	a1, %lo(current_process)(a0)
	sw	a1, -12(s0)
	lw	a0, %lo(current_process)(a0)
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
	lui	a1, %hi(current_process)
	li	a0, 0
	sw	a0, %lo(current_process)(a1)
	lui	a0, %hi(kernel_L.str.7)
	addi	a0, a0, %lo(kernel_L.str.7)
	call	print
	j	kernel_LBB3_5
kernel_LBB3_4:
	lw	a0, -20(s0)
	lui	a1, %hi(current_process)
	sw	a1, -24(s0)                     # 4-byte Folded Spill
	sw	a0, %lo(current_process)(a1)
	lui	a0, %hi(kernel_L.str.8)
	addi	a0, a0, %lo(kernel_L.str.8)
	call	print
	lw	a0, -24(s0)                     # 4-byte Folded Reload
	lw	a1, %lo(current_process)(a0)
	lw	a0, 4(a1)
	lw	a1, 8(a1)
	call	schedule
	j	kernel_LBB3_5
kernel_LBB3_5:
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
	addi	sp, sp, -48
	sw	ra, 44(sp)                      # 4-byte Folded Spill
	sw	s0, 40(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 48
	sw	a0, -12(s0)
	lui	a0, %hi(kernel_L.str.9)
	addi	a0, a0, %lo(kernel_L.str.9)
	call	print
	lw	a0, -12(s0)
	addi	a1, s0, -24
	sw	a1, -36(s0)                     # 4-byte Folded Spill
	call	int_to_hex
	lw	a0, -36(s0)                     # 4-byte Folded Reload
	call	print
	lui	a0, %hi(kernel_L.str.10)
	addi	a0, a0, %lo(kernel_L.str.10)
	call	print
	lui	a0, %hi(ROM_device_code)
	lw	a0, %lo(ROM_device_code)(a0)
	lw	a1, -12(s0)
	call	find_device
	sw	a0, -28(s0)
	lw	a0, -28(s0)
	bnez	a0, kernel_LBB4_2
	j	kernel_LBB4_1
kernel_LBB4_1:
	lui	a0, %hi(kernel_L.str.11)
	addi	a0, a0, %lo(kernel_L.str.11)
	call	print
	lw	a0, -12(s0)
	addi	a1, s0, -24
	sw	a1, -40(s0)                     # 4-byte Folded Spill
	call	int_to_hex
	lw	a0, -40(s0)                     # 4-byte Folded Reload
	call	print
	lui	a0, %hi(kernel_L.str.12)
	addi	a0, a0, %lo(kernel_L.str.12)
	call	print
	j	kernel_LBB4_3
kernel_LBB4_2:
	lui	a0, %hi(kernel_L.str.13)
	addi	a0, a0, %lo(kernel_L.str.13)
	call	print
	lui	a1, %hi(free_list_head)
	lw	a0, %lo(free_list_head)(a1)
	sw	a0, -32(s0)
	lw	a0, -32(s0)
	lw	a0, 0(a0)
	sw	a0, %lo(free_list_head)(a1)
	lw	a0, -28(s0)
	lw	a0, 4(a0)
	lui	a1, %hi(DMA_portal_ptr)
	lw	a2, %lo(DMA_portal_ptr)(a1)
	sw	a0, 0(a2)
	lw	a0, -32(s0)
	lw	a2, %lo(DMA_portal_ptr)(a1)
	sw	a0, 4(a2)
	lw	a2, -28(s0)
	lw	a0, 8(a2)
	lw	a2, 4(a2)
	sub	a0, a0, a2
	lw	a1, %lo(DMA_portal_ptr)(a1)
	sw	a0, 8(a1)
	lui	a0, %hi(current_process)
	sw	a0, -44(s0)                     # 4-byte Folded Spill
	lw	a0, %lo(current_process)(a0)
	lui	a3, %hi(next_pid)
	lw	a1, %lo(next_pid)(a3)
	addi	a2, a1, 1
	sw	a2, %lo(next_pid)(a3)
	lw	a3, -32(s0)
	lui	a2, 32
	add	a2, a3, a2
	call	insert_process
	mv	a1, a0
	lw	a0, -44(s0)                     # 4-byte Folded Reload
	sw	a1, %lo(current_process)(a0)
	lw	a0, %lo(current_process)(a0)
	call	load_process_state
	j	kernel_LBB4_3
kernel_LBB4_3:
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
kernel_Lfunc_end4:
	.size	run_programs, kernel_Lfunc_end4-run_programs
                                        # -- End function
	.type	kernel_L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
kernel_L.str:
	.asciz	"Process management system initialized.\n"
	.size	kernel_L.str, 40

	.type	statics_limit,@object           # @statics_limit
	.section	.sbss,"aw",@nobits
	.p2align	2, 0x0
statics_limit:
	.word	0                               # 0x0
	.size	statics_limit, 4

	.type	kernel_L.str.1,@object                # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
kernel_L.str.1:
	.asciz	"Initializing RAM free block list...\n"
	.size	kernel_L.str.1, 37

	.type	free_list_head,@object          # @free_list_head
	.section	.sbss,"aw",@nobits
	.p2align	2, 0x0
free_list_head:
	.word	0
	.size	free_list_head, 4

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
	.asciz	"Scheduling process\n"
	.size	kernel_L.str.5, 20

	.type	kernel_L.str.6,@object                # @.str.6
kernel_L.str.6:
	.asciz	"No processes to exit\n"
	.size	kernel_L.str.6, 22

	.type	kernel_L.str.7,@object                # @.str.7
kernel_L.str.7:
	.asciz	"Process exited. No more processes to run.\n"
	.size	kernel_L.str.7, 43

	.type	kernel_L.str.8,@object                # @.str.8
kernel_L.str.8:
	.asciz	"Process exited. Scheduling next process.\n"
	.size	kernel_L.str.8, 42

	.type	kernel_L.str.9,@object                # @.str.9
kernel_L.str.9:
	.asciz	"Searching for ROM #"
	.size	kernel_L.str.9, 20

	.type	kernel_L.str.10,@object               # @.str.10
kernel_L.str.10:
	.asciz	"\n"
	.size	kernel_L.str.10, 2

	.type	kernel_L.str.11,@object               # @.str.11
kernel_L.str.11:
	.asciz	"ROM #"
	.size	kernel_L.str.11, 6

	.type	kernel_L.str.12,@object               # @.str.12
kernel_L.str.12:
	.asciz	" not found. \n"
	.size	kernel_L.str.12, 14

	.type	kernel_L.str.13,@object               # @.str.13
kernel_L.str.13:
	.asciz	"Running program...\n"
	.size	kernel_L.str.13, 20

	.type	next_pid,@object                # @next_pid
	.section	.sdata,"aw",@progbits
	.p2align	2, 0x0
next_pid:
	.word	1                               # 0x1
	.size	next_pid, 4

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
	.addrsig_sym insert_process
	.addrsig_sym load_process_state
	.addrsig_sym current_process
	.addrsig_sym statics_limit
	.addrsig_sym free_list_head
	.addrsig_sym ROM_device_code
	.addrsig_sym DMA_portal_ptr
	.addrsig_sym next_pid
