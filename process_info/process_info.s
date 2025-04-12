	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"process_info.c"
	.globl	insert_process                  # -- Begin function insert_process
	.p2align	2
	.type	insert_process,@function
insert_process:                         # @insert_process
# %bb.0:
	addi	sp, sp, -48
	sw	ra, 44(sp)                      # 4-byte Folded Spill
	sw	s0, 40(sp)                      # 4-byte Folded Spill
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
	lui	a0, %hi(process_info_L.str)
	addi	a0, a0, %lo(process_info_L.str)
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
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
process_info_Lfunc_end0:
	.size	insert_process, process_info_Lfunc_end0-insert_process
                                        # -- End function
	.globl	delete_process                  # -- Begin function delete_process
	.p2align	2
	.type	delete_process,@function
delete_process:                         # @delete_process
# %bb.0:
	addi	sp, sp, -48
	sw	ra, 44(sp)                      # 4-byte Folded Spill
	sw	s0, 40(sp)                      # 4-byte Folded Spill
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
process_info_LBB1_3:                                # =>This Innerprocess_info_Loop Header: Depth=1
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
process_info_LBB1_9:                                #   inprocess_info_Loop: Header=BB1_3 Depth=1
	lw	a0, -24(s0)
	lw	a0, 12(a0)
	sw	a0, -24(s0)
	j	process_info_LBB1_10
process_info_LBB1_10:                               #   inprocess_info_Loop: Header=BB1_3 Depth=1
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
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
process_info_Lfunc_end1:
	.size	delete_process, process_info_Lfunc_end1-delete_process
                                        # -- End function
	.globl	display_processes               # -- Begin function display_processes
	.p2align	2
	.type	display_processes,@function
display_processes:                      # @display_processes
# %bb.0:
	addi	sp, sp, -64
	sw	ra, 60(sp)                      # 4-byte Folded Spill
	sw	s0, 56(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 64
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	bnez	a0, process_info_LBB2_2
	j	process_info_LBB2_1
process_info_LBB2_1:
	lui	a0, %hi(process_info_L.str.1)
	addi	a0, a0, %lo(process_info_L.str.1)
	call	print
	j	process_info_LBB2_5
process_info_LBB2_2:
	lw	a0, -12(s0)
	sw	a0, -16(s0)
	j	process_info_LBB2_3
process_info_LBB2_3:                                # =>This Innerprocess_info_Loop Header: Depth=1
	lw	a0, -16(s0)
	lw	a0, 0(a0)
	addi	a1, s0, -25
	sw	a1, -56(s0)                     # 4-byte Folded Spill
	call	int_to_hex
	lw	a0, -16(s0)
	lw	a0, 4(a0)
	addi	a1, s0, -34
	sw	a1, -52(s0)                     # 4-byte Folded Spill
	call	int_to_hex
	lw	a0, -16(s0)
	lw	a0, 8(a0)
	addi	a1, s0, -43
	sw	a1, -48(s0)                     # 4-byte Folded Spill
	call	int_to_hex
	lui	a0, %hi(process_info_L.str.2)
	addi	a0, a0, %lo(process_info_L.str.2)
	call	print
	lw	a0, -56(s0)                     # 4-byte Folded Reload
	call	print
	lui	a0, %hi(process_info_L.str.3)
	addi	a0, a0, %lo(process_info_L.str.3)
	call	print
	lw	a0, -52(s0)                     # 4-byte Folded Reload
	call	print
	lui	a0, %hi(process_info_L.str.4)
	addi	a0, a0, %lo(process_info_L.str.4)
	call	print
	lw	a0, -48(s0)                     # 4-byte Folded Reload
	call	print
	lui	a0, %hi(process_info_L.str.5)
	addi	a0, a0, %lo(process_info_L.str.5)
	call	print
	lw	a0, -16(s0)
	lw	a0, 12(a0)
	sw	a0, -16(s0)
	j	process_info_LBB2_4
process_info_LBB2_4:                                #   inprocess_info_Loop: Header=BB2_3 Depth=1
	lw	a0, -16(s0)
	lw	a1, -12(s0)
	bne	a0, a1, process_info_LBB2_3
	j	process_info_LBB2_5
process_info_LBB2_5:
	lw	ra, 60(sp)                      # 4-byte Folded Reload
	lw	s0, 56(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 64
	ret
process_info_Lfunc_end2:
	.size	display_processes, process_info_Lfunc_end2-display_processes
                                        # -- End function
	.type	process_info_L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
process_info_L.str:
	.asciz	"Memory allocation failed\n"
	.size	process_info_L.str, 26

	.type	process_info_L.str.1,@object                # @.str.1
process_info_L.str.1:
	.asciz	"No processes available\n"
	.size	process_info_L.str.1, 24

	.type	process_info_L.str.2,@object                # @.str.2
process_info_L.str.2:
	.asciz	"PID: "
	.size	process_info_L.str.2, 6

	.type	process_info_L.str.3,@object                # @.str.3
process_info_L.str.3:
	.asciz	", SP: "
	.size	process_info_L.str.3, 7

	.type	process_info_L.str.4,@object                # @.str.4
process_info_L.str.4:
	.asciz	", PC: "
	.size	process_info_L.str.4, 7

	.type	process_info_L.str.5,@object                # @.str.5
process_info_L.str.5:
	.asciz	"\n"
	.size	process_info_L.str.5, 2

	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym malloc
	.addrsig_sym print
	.addrsig_sym free
	.addrsig_sym int_to_hex
