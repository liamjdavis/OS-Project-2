	.Code
malloc:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
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
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
memory_alloc_Lfunc_end0:
	#	-- End function 
free:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	call	deallocate 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
memory_alloc_Lfunc_end1:
	#	-- End function 
