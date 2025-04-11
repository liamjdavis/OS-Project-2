	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0"
	.file	"memory_alloc.c"
	.globl	malloc                          # -- Begin function malloc
	.p2align	2
	.type	malloc,@function
malloc:                                 # @malloc
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	bnez	a0, memory_alloc_LBB0_2
	j	memory_alloc_LBB0_1
memory_alloc_LBB0_1:
	li	a0, 0
	sw	a0, -12(s0)
	j	memory_alloc_LBB0_3
memory_alloc_LBB0_2:
	lw	a0, -16(s0)
	call	allocate
	sw	a0, -12(s0)
	j	memory_alloc_LBB0_3
memory_alloc_LBB0_3:
	lw	a0, -12(s0)
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
memory_alloc_Lfunc_end0:
	.size	malloc, memory_alloc_Lfunc_end0-malloc
                                        # -- End function
	.globl	free                            # -- Begin function free
	.p2align	2
	.type	free,@function
free:                                   # @free
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	sw	a0, -12(s0)
	lw	a0, -12(s0)
	call	deallocate
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
memory_alloc_Lfunc_end1:
	.size	free, memory_alloc_Lfunc_end1-free
                                        # -- End function
	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym allocate
	.addrsig_sym deallocate
