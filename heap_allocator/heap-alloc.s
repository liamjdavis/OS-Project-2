	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0"
	.file	"heap-alloc.c"
	.globl	heap_init                       # -- Begin function heap_init
	.p2align	2
	.type	heap_init,@function
heap_init:                              # @heap_init
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	lui	a0, %hi(free_blocks)
	lw	a0, %lo(free_blocks)(a0)
	beqz	a0, heap-alloc_LBB0_2
	j	heap-alloc_LBB0_1
heap-alloc_LBB0_1:
	j	heap-alloc_LBB0_5
heap-alloc_LBB0_2:
	lui	a0, %hi(heap_space)
	addi	a0, a0, %lo(heap_space)
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
	lui	a0, %hi(free_blocks)
	lw	a2, %lo(free_blocks)(a0)
	lw	a3, -12(s0)
	sw	a2, 0(a3)
	lw	a2, -12(s0)
	sw	a1, 4(a2)
	lw	a0, %lo(free_blocks)(a0)
	beqz	a0, heap-alloc_LBB0_4
	j	heap-alloc_LBB0_3
heap-alloc_LBB0_3:
	lw	a0, -12(s0)
	lui	a1, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a1)
	sw	a0, 4(a1)
	j	heap-alloc_LBB0_4
heap-alloc_LBB0_4:
	lw	a0, -12(s0)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap-alloc_LBB0_5
heap-alloc_LBB0_5:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
heap-alloc_Lfunc_end0:
	.size	heap_init, heap-alloc_Lfunc_end0-heap_init
                                        # -- End function
	.globl	allocate                        # -- Begin function allocate
	.p2align	2
	.type	allocate,@function
allocate:                               # @allocate
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -16(s0)
	call	heap_init
	lw	a0, -16(s0)
	addi	a0, a0, 3
	andi	a0, a0, -4
	sw	a0, -16(s0)
	lui	a0, %hi(free_blocks)
	lw	a0, %lo(free_blocks)(a0)
	sw	a0, -20(s0)
	j	heap-alloc_LBB1_1
heap-alloc_LBB1_1:                                # =>This Innerheap-alloc_Loop Header: Depth=1
	lw	a0, -20(s0)
	beqz	a0, heap-alloc_LBB1_14
	j	heap-alloc_LBB1_2
heap-alloc_LBB1_2:                                #   inheap-alloc_Loop: Header=BB1_1 Depth=1
	lw	a0, -20(s0)
	lw	a0, 8(a0)
	lw	a1, -16(s0)
	bltu	a0, a1, heap-alloc_LBB1_13
	j	heap-alloc_LBB1_3
heap-alloc_LBB1_3:
	lw	a0, -20(s0)
	lw	a0, 0(a0)
	beqz	a0, heap-alloc_LBB1_5
	j	heap-alloc_LBB1_4
heap-alloc_LBB1_4:
	lw	a1, -20(s0)
	lw	a0, 4(a1)
	lw	a1, 0(a1)
	sw	a0, 4(a1)
	j	heap-alloc_LBB1_5
heap-alloc_LBB1_5:
	lw	a0, -20(s0)
	lw	a0, 4(a0)
	beqz	a0, heap-alloc_LBB1_7
	j	heap-alloc_LBB1_6
heap-alloc_LBB1_6:
	lw	a1, -20(s0)
	lw	a0, 0(a1)
	lw	a1, 4(a1)
	sw	a0, 0(a1)
	j	heap-alloc_LBB1_8
heap-alloc_LBB1_7:
	lw	a0, -20(s0)
	lw	a0, 0(a0)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap-alloc_LBB1_8
heap-alloc_LBB1_8:
	lw	a0, -20(s0)
	lw	a1, 8(a0)
	lw	a0, -16(s0)
	addi	a0, a0, 12
	bgeu	a0, a1, heap-alloc_LBB1_12
	j	heap-alloc_LBB1_9
heap-alloc_LBB1_9:
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
	lui	a0, %hi(free_blocks)
	lw	a2, %lo(free_blocks)(a0)
	lw	a3, -28(s0)
	sw	a2, 0(a3)
	lw	a2, -28(s0)
	sw	a1, 4(a2)
	lw	a0, %lo(free_blocks)(a0)
	beqz	a0, heap-alloc_LBB1_11
	j	heap-alloc_LBB1_10
heap-alloc_LBB1_10:
	lw	a0, -28(s0)
	lui	a1, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a1)
	sw	a0, 4(a1)
	j	heap-alloc_LBB1_11
heap-alloc_LBB1_11:
	lw	a0, -28(s0)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap-alloc_LBB1_12
heap-alloc_LBB1_12:
	lw	a0, -20(s0)
	addi	a0, a0, 12
	sw	a0, -12(s0)
	j	heap-alloc_LBB1_15
heap-alloc_LBB1_13:                               #   inheap-alloc_Loop: Header=BB1_1 Depth=1
	lw	a0, -20(s0)
	lw	a0, 0(a0)
	sw	a0, -20(s0)
	j	heap-alloc_LBB1_1
heap-alloc_LBB1_14:
	li	a0, 0
	sw	a0, -12(s0)
	j	heap-alloc_LBB1_15
heap-alloc_LBB1_15:
	lw	a0, -12(s0)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
heap-alloc_Lfunc_end1:
	.size	allocate, heap-alloc_Lfunc_end1-allocate
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
	bnez	a0, heap-alloc_LBB2_2
	j	heap-alloc_LBB2_1
heap-alloc_LBB2_1:
	j	heap-alloc_LBB2_20
heap-alloc_LBB2_2:
	lw	a0, -12(s0)
	addi	a0, a0, -12
	sw	a0, -16(s0)
	lui	a0, %hi(free_blocks)
	lw	a0, %lo(free_blocks)(a0)
	sw	a0, -20(s0)
	j	heap-alloc_LBB2_3
heap-alloc_LBB2_3:                                # =>This Innerheap-alloc_Loop Header: Depth=1
	lw	a0, -20(s0)
	beqz	a0, heap-alloc_LBB2_17
	j	heap-alloc_LBB2_4
heap-alloc_LBB2_4:                                #   inheap-alloc_Loop: Header=BB2_3 Depth=1
	lw	a0, -20(s0)
	lw	a1, 8(a0)
	add	a0, a0, a1
	addi	a0, a0, 12
	lw	a1, -16(s0)
	bne	a0, a1, heap-alloc_LBB2_6
	j	heap-alloc_LBB2_5
heap-alloc_LBB2_5:
	lw	a0, -16(s0)
	lw	a0, 8(a0)
	lw	a1, -20(s0)
	lw	a2, 8(a1)
	add	a0, a0, a2
	addi	a0, a0, 12
	sw	a0, 8(a1)
	j	heap-alloc_LBB2_20
heap-alloc_LBB2_6:                                #   inheap-alloc_Loop: Header=BB2_3 Depth=1
	lw	a0, -16(s0)
	lw	a1, 8(a0)
	add	a0, a0, a1
	addi	a0, a0, 12
	lw	a1, -20(s0)
	bne	a0, a1, heap-alloc_LBB2_15
	j	heap-alloc_LBB2_7
heap-alloc_LBB2_7:
	lw	a0, -20(s0)
	lw	a0, 8(a0)
	lw	a1, -16(s0)
	lw	a2, 8(a1)
	add	a0, a0, a2
	addi	a0, a0, 12
	sw	a0, 8(a1)
	lw	a0, -20(s0)
	lw	a0, 0(a0)
	beqz	a0, heap-alloc_LBB2_9
	j	heap-alloc_LBB2_8
heap-alloc_LBB2_8:
	lw	a1, -20(s0)
	lw	a0, 4(a1)
	lw	a1, 0(a1)
	sw	a0, 4(a1)
	j	heap-alloc_LBB2_9
heap-alloc_LBB2_9:
	lw	a0, -20(s0)
	lw	a0, 4(a0)
	beqz	a0, heap-alloc_LBB2_11
	j	heap-alloc_LBB2_10
heap-alloc_LBB2_10:
	lw	a1, -20(s0)
	lw	a0, 0(a1)
	lw	a1, 4(a1)
	sw	a0, 0(a1)
	j	heap-alloc_LBB2_12
heap-alloc_LBB2_11:
	lw	a0, -20(s0)
	lw	a0, 0(a0)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap-alloc_LBB2_12
heap-alloc_LBB2_12:
	lui	a0, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a0)
	lw	a2, -16(s0)
	sw	a1, 0(a2)
	lw	a2, -16(s0)
	li	a1, 0
	sw	a1, 4(a2)
	lw	a0, %lo(free_blocks)(a0)
	beqz	a0, heap-alloc_LBB2_14
	j	heap-alloc_LBB2_13
heap-alloc_LBB2_13:
	lw	a0, -16(s0)
	lui	a1, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a1)
	sw	a0, 4(a1)
	j	heap-alloc_LBB2_14
heap-alloc_LBB2_14:
	lw	a0, -16(s0)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap-alloc_LBB2_20
heap-alloc_LBB2_15:                               #   inheap-alloc_Loop: Header=BB2_3 Depth=1
	j	heap-alloc_LBB2_16
heap-alloc_LBB2_16:                               #   inheap-alloc_Loop: Header=BB2_3 Depth=1
	lw	a0, -20(s0)
	lw	a0, 0(a0)
	sw	a0, -20(s0)
	j	heap-alloc_LBB2_3
heap-alloc_LBB2_17:
	lui	a0, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a0)
	lw	a2, -16(s0)
	sw	a1, 0(a2)
	lw	a2, -16(s0)
	li	a1, 0
	sw	a1, 4(a2)
	lw	a0, %lo(free_blocks)(a0)
	beqz	a0, heap-alloc_LBB2_19
	j	heap-alloc_LBB2_18
heap-alloc_LBB2_18:
	lw	a0, -16(s0)
	lui	a1, %hi(free_blocks)
	lw	a1, %lo(free_blocks)(a1)
	sw	a0, 4(a1)
	j	heap-alloc_LBB2_19
heap-alloc_LBB2_19:
	lw	a0, -16(s0)
	lui	a1, %hi(free_blocks)
	sw	a0, %lo(free_blocks)(a1)
	j	heap-alloc_LBB2_20
heap-alloc_LBB2_20:
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
heap-alloc_Lfunc_end2:
	.size	deallocate, heap-alloc_Lfunc_end2-deallocate
                                        # -- End function
	.type	free_blocks,@object             # @free_blocks
	.section	.sbss,"aw",@nobits
	.p2align	2, 0x0
free_blocks:
	.word	0
	.size	free_blocks, 4

	.type	heap_space,@object              # @heap_space
	.local	heap_space
	.comm	heap_space,1048576,1
	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym heap_init
	.addrsig_sym free_blocks
	.addrsig_sym heap_space
