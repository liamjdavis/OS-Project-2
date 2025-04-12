	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_zmmul1p0"
	.file	"heap_alloc.c"
	.globl	heap_init                       # -- Begin function heap_init
	.p2align	2
	.type	heap_init,@function
heap_init:                              # @heap_init
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lui	a1, %hi(free_head)
	addi	a2, a1, %lo(free_head)
	li	a0, 0
	sw	a0, 4(a2)
	sw	a0, 8(a2)
	sw	a0, %lo(free_head)(a1)
	lui	a1, %hi(free_tail)
	addi	a2, a1, %lo(free_tail)
	sw	a0, 4(a2)
	sw	a0, 8(a2)
	sw	a0, %lo(free_tail)(a1)
	lui	a0, %hi(heap_limit)
	lw	a0, %lo(heap_limit)(a0)
	beqz	a0, heap_alloc_LBB0_2
	j	heap_alloc_LBB0_1
heap_alloc_LBB0_1:
	j	heap_alloc_LBB0_3
heap_alloc_LBB0_2:
	lw	a0, -12(s0)
	lui	a1, %hi(heap_limit)
	sw	a0, %lo(heap_limit)(a1)
	lui	a0, %hi(free_head)
	addi	a0, a0, %lo(free_head)
	lui	a1, %hi(free_tail)
	addi	a1, a1, %lo(free_tail)
	sw	a1, 4(a0)
	sw	a0, 8(a1)
	j	heap_alloc_LBB0_3
heap_alloc_LBB0_3:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
heap_alloc_Lfunc_end0:
	.size	heap_init, heap_alloc_Lfunc_end0-heap_init
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
	sw	a0, -12(s0)
	lbu	a0, -12(s0)
	andi	a0, a0, 3
	bnez	a0, heap_alloc_LBB1_2
	j	heap_alloc_LBB1_1
heap_alloc_LBB1_1:
	lw	a0, -12(s0)
	sw	a0, -24(s0)                     # 4-byte Folded Spill
	j	heap_alloc_LBB1_3
heap_alloc_LBB1_2:
	lw	a0, -12(s0)
	addi	a0, a0, 4
	andi	a0, a0, 3
	sw	a0, -24(s0)                     # 4-byte Folded Spill
	j	heap_alloc_LBB1_3
heap_alloc_LBB1_3:
	lw	a0, -24(s0)                     # 4-byte Folded Reload
	sw	a0, -12(s0)
	lui	a0, %hi(heap_alloc_L.str)
	addi	a0, a0, %lo(heap_alloc_L.str)
	call	print
	lui	a0, %hi(free_head)
	addi	a0, a0, %lo(free_head)
	lw	a0, 4(a0)
	sw	a0, -16(s0)
	j	heap_alloc_LBB1_4
heap_alloc_LBB1_4:                                # =>This Innerheap_alloc_Loop Header: Depth=1
	lw	a0, -16(s0)
	lui	a1, %hi(free_tail)
	addi	a1, a1, %lo(free_tail)
	beq	a0, a1, heap_alloc_LBB1_9
	j	heap_alloc_LBB1_5
heap_alloc_LBB1_5:                                #   inheap_alloc_Loop: Header=BB1_4 Depth=1
	lw	a0, -16(s0)
	lw	a0, 0(a0)
	lw	a1, -12(s0)
	bltu	a0, a1, heap_alloc_LBB1_7
	j	heap_alloc_LBB1_6
heap_alloc_LBB1_6:
	lw	a1, -16(s0)
	lw	a0, 4(a1)
	lw	a1, 8(a1)
	sw	a0, 4(a1)
	lw	a1, -16(s0)
	lw	a0, 8(a1)
	lw	a1, 4(a1)
	sw	a0, 8(a1)
	lw	a1, -16(s0)
	li	a0, 0
	sw	a0, 4(a1)
	lw	a1, -16(s0)
	sw	a0, 8(a1)
	j	heap_alloc_LBB1_9
heap_alloc_LBB1_7:                                #   inheap_alloc_Loop: Header=BB1_4 Depth=1
	lw	a0, -16(s0)
	lw	a0, 4(a0)
	sw	a0, -16(s0)
	j	heap_alloc_LBB1_8
heap_alloc_LBB1_8:                                #   inheap_alloc_Loop: Header=BB1_4 Depth=1
	j	heap_alloc_LBB1_4
heap_alloc_LBB1_9:
	lw	a0, -16(s0)
	lui	a1, %hi(free_tail)
	addi	a1, a1, %lo(free_tail)
	bne	a0, a1, heap_alloc_LBB1_11
	j	heap_alloc_LBB1_10
heap_alloc_LBB1_10:
	lui	a0, %hi(heap_alloc_L.str.1)
	addi	a0, a0, %lo(heap_alloc_L.str.1)
	call	print
	lw	a0, -12(s0)
	addi	a0, a0, 12
	sw	a0, -20(s0)
	lui	a1, %hi(heap_limit)
	lw	a0, %lo(heap_limit)(a1)
	sw	a0, -16(s0)
	lw	a0, -12(s0)
	lw	a2, -16(s0)
	sw	a0, 0(a2)
	lw	a2, -20(s0)
	lw	a0, %lo(heap_limit)(a1)
	add	a0, a0, a2
	sw	a0, %lo(heap_limit)(a1)
	lui	a0, %hi(heap_alloc_L.str.2)
	addi	a0, a0, %lo(heap_alloc_L.str.2)
	call	print
	j	heap_alloc_LBB1_11
heap_alloc_LBB1_11:
	lui	a0, %hi(heap_alloc_L.str.3)
	addi	a0, a0, %lo(heap_alloc_L.str.3)
	call	print
	lw	a0, -16(s0)
	addi	a0, a0, 12
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
heap_alloc_Lfunc_end1:
	.size	allocate, heap_alloc_Lfunc_end1-allocate
                                        # -- End function
	.globl	deallocate                      # -- Begin function deallocate
	.p2align	2
	.type	deallocate,@function
deallocate:                             # @deallocate
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	bnez	a0, heap_alloc_LBB2_2
	j	heap_alloc_LBB2_1
heap_alloc_LBB2_1:
	j	heap_alloc_LBB2_3
heap_alloc_LBB2_2:
	lw	a0, -12(s0)
	addi	a0, a0, -12
	sw	a0, -16(s0)
	lui	a1, %hi(free_head)
	addi	a1, a1, %lo(free_head)
	lw	a0, 4(a1)
	lw	a2, -16(s0)
	sw	a0, 4(a2)
	lw	a0, -16(s0)
	sw	a1, 8(a0)
	lw	a0, -16(s0)
	lw	a2, 4(a1)
	sw	a0, 8(a2)
	lw	a0, -16(s0)
	sw	a0, 4(a1)
	j	heap_alloc_LBB2_3
heap_alloc_LBB2_3:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
heap_alloc_Lfunc_end2:
	.size	deallocate, heap_alloc_Lfunc_end2-deallocate
                                        # -- End function
	.type	free_head,@object               # @free_head
	.bss
	.globl	free_head
	.p2align	2, 0x0
free_head:
	.zero	12
	.size	free_head, 12

	.type	free_tail,@object               # @free_tail
	.globl	free_tail
	.p2align	2, 0x0
free_tail:
	.zero	12
	.size	free_tail, 12

	.type	heap_limit,@object              # @heap_limit
	.section	.sbss,"aw",@nobits
	.p2align	2, 0x0
heap_limit:
	.word	0                               # 0x0
	.size	heap_limit, 4

	.type	heap_alloc_L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
heap_alloc_L.str:
	.asciz	"Searching for free block\n"
	.size	heap_alloc_L.str, 26

	.type	heap_alloc_L.str.1,@object                # @.str.1
heap_alloc_L.str.1:
	.asciz	"No free block found, making a new one\n"
	.size	heap_alloc_L.str.1, 39

	.type	heap_alloc_L.str.2,@object                # @.str.2
heap_alloc_L.str.2:
	.asciz	"Done allocating memory\n"
	.size	heap_alloc_L.str.2, 24

	.type	heap_alloc_L.str.3,@object                # @.str.3
heap_alloc_L.str.3:
	.asciz	"Allocated memory\n"
	.size	heap_alloc_L.str.3, 18

	.ident	"clang version 19.1.6"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym print
	.addrsig_sym free_head
	.addrsig_sym free_tail
	.addrsig_sym heap_limit
