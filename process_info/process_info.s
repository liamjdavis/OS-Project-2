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
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
process_info_Lfunc_end0:
	.size	insert_process, process_info_Lfunc_end0-insert_process
                                        # -- End function
	.p2align	2                               # -- Begin function my_strncpy
	.type	my_strncpy,@function
my_strncpy:                             # @my_strncpy
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	sw	a2, -20(s0)
	li	a0, 0
	sw	a0, -24(s0)
	j	process_info_LBB1_1
process_info_LBB1_1:                                # =>This Innerprocess_info_Loop Header: Depth=1
	lw	a0, -24(s0)
	lw	a1, -20(s0)
	addi	a1, a1, -1
	li	a2, 0
	sw	a2, -28(s0)                     # 4-byte Folded Spill
	bge	a0, a1, process_info_LBB1_3
	j	process_info_LBB1_2
process_info_LBB1_2:                                #   inprocess_info_Loop: Header=BB1_1 Depth=1
	lw	a0, -16(s0)
	lw	a1, -24(s0)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	snez	a0, a0
	sw	a0, -28(s0)                     # 4-byte Folded Spill
	j	process_info_LBB1_3
process_info_LBB1_3:                                #   inprocess_info_Loop: Header=BB1_1 Depth=1
	lw	a0, -28(s0)                     # 4-byte Folded Reload
	andi	a0, a0, 1
	beqz	a0, process_info_LBB1_6
	j	process_info_LBB1_4
process_info_LBB1_4:                                #   inprocess_info_Loop: Header=BB1_1 Depth=1
	lw	a0, -16(s0)
	lw	a2, -24(s0)
	add	a0, a0, a2
	lbu	a0, 0(a0)
	lw	a1, -12(s0)
	add	a1, a1, a2
	sb	a0, 0(a1)
	j	process_info_LBB1_5
process_info_LBB1_5:                                #   inprocess_info_Loop: Header=BB1_1 Depth=1
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
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
process_info_Lfunc_end1:
	.size	my_strncpy, process_info_Lfunc_end1-my_strncpy
                                        # -- End function
	.globl	delete_process                  # -- Begin function delete_process
	.p2align	2
	.type	delete_process,@function
delete_process:                         # @delete_process
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
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
process_info_LBB2_3:                                # =>This Innerprocess_info_Loop Header: Depth=1
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
process_info_LBB2_9:                                #   inprocess_info_Loop: Header=BB2_3 Depth=1
	lw	a0, -20(s0)
	lw	a0, 64(a0)
	sw	a0, -20(s0)
	j	process_info_LBB2_10
process_info_LBB2_10:                               #   inprocess_info_Loop: Header=BB2_3 Depth=1
	lw	a0, -20(s0)
	lw	a1, -12(s0)
	lw	a1, 0(a1)
	bne	a0, a1, process_info_LBB2_3
	j	process_info_LBB2_11
process_info_LBB2_11:
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
process_info_Lfunc_end2:
	.size	delete_process, process_info_Lfunc_end2-delete_process
                                        # -- End function
	.globl	display_processes               # -- Begin function display_processes
	.p2align	2
	.type	display_processes,@function
display_processes:                      # @display_processes
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
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
process_info_LBB3_3:                                # =>This Innerprocess_info_Loop Header: Depth=1
	lw	a0, -16(s0)
	lw	a0, 64(a0)
	sw	a0, -16(s0)
	j	process_info_LBB3_4
process_info_LBB3_4:                                #   inprocess_info_Loop: Header=BB3_3 Depth=1
	lw	a0, -16(s0)
	lw	a1, -12(s0)
	bne	a0, a1, process_info_LBB3_3
	j	process_info_LBB3_5
process_info_LBB3_5:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
process_info_Lfunc_end3:
	.size	display_processes, process_info_Lfunc_end3-display_processes
                                        # -- End function
	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym malloc
	.addrsig_sym my_strncpy
	.addrsig_sym free
