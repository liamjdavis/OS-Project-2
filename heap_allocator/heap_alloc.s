	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"heap_alloc.c"
	.globl	heap_init                       # -- Begin function heap_init
	.p2align	2
	.type	heap_init,@function
heap_init:                              # @heap_init
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -16(s0)
	lui	a0, %hi(free_blocks)
	lw	a0, %lo(free_blocks)(a0)
	beqz	a0, heap_alloc_LBB0_2
	j	heap_alloc_LBB0_1
heap_alloc_LBB0_1:
	lui	a0, %hi(free_blocks)
	lw	a0, %lo(free_blocks)(a0)
	sw	a0, -12(s0)
	j	heap_alloc_LBB0_8
heap_alloc_LBB0_2:
	lw	a0, -16(s0)
	lui	a1, %hi(heap_space)
	sw	a0, %lo(heap_space)(a1)
	lui	a0, %hi(kernel_limit)
	lw	a0, %lo(kernel_limit)(a0)
	lw	a1, -16(s0)
	sub	a1, a0, a1
	lui	a0, %hi(heap_size)
	sw	a1, %lo(heap_size)(a0)
	lw	a1, %lo(heap_size)(a0)
	li	a0, 12
	bltu	a0, a1, heap_alloc_LBB0_4
	j	heap_alloc_LBB0_3
heap_alloc_LBB0_3:
	lui	a1, %hi(heap_space)
	li	a0, 0
	sw	a0, %lo(heap_space)(a1)
	lui	a1, %hi(heap_size)
	sw	a0, %lo(heap_size)(a1)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	sw	a0, -12(s0)
	j	heap_alloc_LBB0_8
heap_alloc_LBB0_4:
	lui	a0, %hi(heap_space)
	lw	a0, %lo(heap_space)(a0)
	sw	a0, -20(s0)
	lui	a0, %hi(heap_size)
	lw	a0, %lo(heap_size)(a0)
	addi	a0, a0, -12
	lw	a1, -20(s0)
	sw	a0, 8(a1)
	lw	a1, -20(s0)
	li	a0, 0
	sw	a0, 0(a1)
	lw	a1, -20(s0)
	sw	a0, 4(a1)
	lw	a1, -20(s0)
	lui	a0, %hi(free_blocks)
	sw	a1, %lo(free_blocks)(a0)
	lw	a0, %lo(free_blocks)(a0)
	beqz	a0, heap_alloc_LBB0_6
	j	heap_alloc_LBB0_5
heap_alloc_LBB0_5:
	lui	a0, %hi(free_blocks)
	lw	a0, %lo(free_blocks)(a0)
	lw	a0, 8(a0)
	bnez	a0, heap_alloc_LBB0_7
	j	heap_alloc_LBB0_6
heap_alloc_LBB0_6:
	lui	a1, %hi(heap_space)
	li	a0, 0
	sw	a0, %lo(heap_space)(a1)
	lui	a1, %hi(heap_size)
	sw	a0, %lo(heap_size)(a1)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	sw	a0, -12(s0)
	j	heap_alloc_LBB0_8
heap_alloc_LBB0_7:
	lui	a0, %hi(free_blocks)
	lw	a0, %lo(free_blocks)(a0)
	sw	a0, -12(s0)
	j	heap_alloc_LBB0_8
heap_alloc_LBB0_8:
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
heap_alloc_Lfunc_end0:
	.size	heap_init, heap_alloc_Lfunc_end0-heap_init
                                        # -- End function
	.globl	allocate                        # -- Begin function allocate
	.p2align	2
	.type	allocate,@function
allocate:                               # @allocate
# %bb.0:
	addi	sp, sp, -48
	sw	ra, 44(sp)                      # 4-byte Folded Spill
	sw	s0, 40(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 48
	sw	a0, -16(s0)
	lui	a0, %hi(free_blocks)
	lw	a0, %lo(free_blocks)(a0)
	bnez	a0, heap_alloc_LBB1_2
	j	heap_alloc_LBB1_1
heap_alloc_LBB1_1:
	li	a0, 0
	sw	a0, -12(s0)
	j	heap_alloc_LBB1_17
heap_alloc_LBB1_2:
	lw	a0, -16(s0)
	addi	a0, a0, 3
	andi	a0, a0, -4
	sw	a0, -16(s0)
	li	a0, 12
	sw	a0, -20(s0)
	lw	a1, -16(s0)
	lw	a0, -20(s0)
	add	a0, a0, a1
	addi	a0, a0, -12
	sw	a0, -24(s0)
	lui	a0, %hi(free_blocks)
	lw	a0, %lo(free_blocks)(a0)
	sw	a0, -28(s0)
	j	heap_alloc_LBB1_3
heap_alloc_LBB1_3:                                # =>This Innerheap_alloc_Loop Header: Depth=1
	lw	a0, -28(s0)
	beqz	a0, heap_alloc_LBB1_16
	j	heap_alloc_LBB1_4
heap_alloc_LBB1_4:                                #   inheap_alloc_Loop: Header=BB1_3 Depth=1
	lw	a0, -28(s0)
	lw	a0, 8(a0)
	lw	a1, -24(s0)
	bltu	a0, a1, heap_alloc_LBB1_15
	j	heap_alloc_LBB1_5
heap_alloc_LBB1_5:
	lw	a0, -28(s0)
	lw	a0, 0(a0)
	beqz	a0, heap_alloc_LBB1_7
	j	heap_alloc_LBB1_6
heap_alloc_LBB1_6:
	lw	a1, -28(s0)
	lw	a0, 4(a1)
	lw	a1, 0(a1)
	sw	a0, 4(a1)
	j	heap_alloc_LBB1_7
heap_alloc_LBB1_7:
	lw	a0, -28(s0)
	lw	a0, 4(a0)
	beqz	a0, heap_alloc_LBB1_9
	j	heap_alloc_LBB1_8
heap_alloc_LBB1_8:
	lw	a1, -28(s0)
	lw	a0, 0(a1)
	lw	a1, 4(a1)
	sw	a0, 0(a1)
	j	heap_alloc_LBB1_10
heap_alloc_LBB1_9:
	lw	a0, -28(s0)
	lw	a0, 0(a0)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap_alloc_LBB1_10
heap_alloc_LBB1_10:
	lw	a0, -28(s0)
	lw	a1, 8(a0)
	lw	a0, -24(s0)
	addi	a0, a0, 12
	bgeu	a0, a1, heap_alloc_LBB1_14
	j	heap_alloc_LBB1_11
heap_alloc_LBB1_11:
	lw	a0, -28(s0)
	lw	a1, -20(s0)
	add	a0, a0, a1
	lw	a1, -16(s0)
	add	a0, a0, a1
	sw	a0, -32(s0)
	lw	a0, -32(s0)
	sw	a0, -36(s0)
	lw	a0, -36(s0)
	li	a1, 0
	sw	a1, 0(a0)
	lw	a0, -36(s0)
	sw	a1, 4(a0)
	lw	a0, -28(s0)
	lw	a0, 8(a0)
	lw	a2, -24(s0)
	sub	a0, a0, a2
	addi	a0, a0, -12
	lw	a2, -36(s0)
	sw	a0, 8(a2)
	lw	a0, -24(s0)
	lw	a2, -28(s0)
	sw	a0, 8(a2)
	lui	a0, %hi(free_blocks)
	lw	a2, %lo(free_blocks)(a0)
	lw	a3, -36(s0)
	sw	a2, 0(a3)
	lw	a2, -36(s0)
	sw	a1, 4(a2)
	lw	a0, %lo(free_blocks)(a0)
	beqz	a0, heap_alloc_LBB1_13
	j	heap_alloc_LBB1_12
heap_alloc_LBB1_12:
	lw	a0, -36(s0)
	lui	a1, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a1)
	sw	a0, 4(a1)
	j	heap_alloc_LBB1_13
heap_alloc_LBB1_13:
	lw	a0, -36(s0)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap_alloc_LBB1_14
heap_alloc_LBB1_14:
	lw	a0, -28(s0)
	addi	a0, a0, 15
	andi	a0, a0, -4
	sw	a0, -12(s0)
	j	heap_alloc_LBB1_17
heap_alloc_LBB1_15:                               #   inheap_alloc_Loop: Header=BB1_3 Depth=1
	lw	a0, -28(s0)
	lw	a0, 0(a0)
	sw	a0, -28(s0)
	j	heap_alloc_LBB1_3
heap_alloc_LBB1_16:
	li	a0, 0
	sw	a0, -12(s0)
	j	heap_alloc_LBB1_17
heap_alloc_LBB1_17:
	lw	a0, -12(s0)
	lw	ra, 44(sp)                      # 4-byte Folded Reload
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 48
	ret
heap_alloc_Lfunc_end1:
	.size	allocate, heap_alloc_Lfunc_end1-allocate
                                        # -- End function
	.globl	deallocate                      # -- Begin function deallocate
	.p2align	2
	.type	deallocate,@function
deallocate:                             # @deallocate
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
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
	lui	a0, %hi(free_blocks)
	lw	a0, %lo(free_blocks)(a0)
	sw	a0, -20(s0)
	j	heap_alloc_LBB2_3
heap_alloc_LBB2_3:                                # =>This Innerheap_alloc_Loop Header: Depth=1
	lw	a0, -20(s0)
	beqz	a0, heap_alloc_LBB2_17
	j	heap_alloc_LBB2_4
heap_alloc_LBB2_4:                                #   inheap_alloc_Loop: Header=BB2_3 Depth=1
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
heap_alloc_LBB2_6:                                #   inheap_alloc_Loop: Header=BB2_3 Depth=1
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
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap_alloc_LBB2_12
heap_alloc_LBB2_12:
	lui	a0, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a0)
	lw	a2, -16(s0)
	sw	a1, 0(a2)
	lw	a2, -16(s0)
	li	a1, 0
	sw	a1, 4(a2)
	lw	a0, %lo(free_blocks)(a0)
	beqz	a0, heap_alloc_LBB2_14
	j	heap_alloc_LBB2_13
heap_alloc_LBB2_13:
	lw	a0, -16(s0)
	lui	a1, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a1)
	sw	a0, 4(a1)
	j	heap_alloc_LBB2_14
heap_alloc_LBB2_14:
	lw	a0, -16(s0)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap_alloc_LBB2_20
heap_alloc_LBB2_15:                               #   inheap_alloc_Loop: Header=BB2_3 Depth=1
	j	heap_alloc_LBB2_16
heap_alloc_LBB2_16:                               #   inheap_alloc_Loop: Header=BB2_3 Depth=1
	lw	a0, -20(s0)
	lw	a0, 0(a0)
	sw	a0, -20(s0)
	j	heap_alloc_LBB2_3
heap_alloc_LBB2_17:
	lui	a0, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a0)
	lw	a2, -16(s0)
	sw	a1, 0(a2)
	lw	a2, -16(s0)
	li	a1, 0
	sw	a1, 4(a2)
	lw	a0, %lo(free_blocks)(a0)
	beqz	a0, heap_alloc_LBB2_19
	j	heap_alloc_LBB2_18
heap_alloc_LBB2_18:
	lw	a0, -16(s0)
	lui	a1, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a1)
	sw	a0, 4(a1)
	j	heap_alloc_LBB2_19
heap_alloc_LBB2_19:
	lw	a0, -16(s0)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap_alloc_LBB2_20
heap_alloc_LBB2_20:
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
heap_alloc_Lfunc_end2:
	.size	deallocate, heap_alloc_Lfunc_end2-deallocate
                                        # -- End function
	.type	free_blocks,@object             # @free_blocks
	.section	.sbss,"aw",@nobits
	.p2align	2, 0x0
free_blocks:
	.word	0
	.size	free_blocks, 4

	.type	heap_space,@object              # @heap_space
	.p2align	2, 0x0
heap_space:
	.word	0
	.size	heap_space, 4

	.type	heap_size,@object               # @heap_size
	.p2align	2, 0x0
heap_size:
	.word	0                               # 0x0
	.size	heap_size, 4

	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym free_blocks
	.addrsig_sym heap_space
	.addrsig_sym kernel_limit
	.addrsig_sym heap_size
