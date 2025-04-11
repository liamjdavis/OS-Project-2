	.Code
heap_init:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
heap_alloc_autoL0:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL0))(a0)
	beqz	a0, heap_alloc_LBB0_2 
	j	heap_alloc_LBB0_1 
heap_alloc_LBB0_1:
	j	heap_alloc_LBB0_5 
heap_alloc_LBB0_2:
heap_alloc_autoL1:
	auipc	a0, %hi(%pcrel(heap_space))
	addi	a0, a0, %lo(%larel(heap_space,heap_alloc_autoL1))
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
heap_alloc_autoL2:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a2, %lo(%larel(free_blocks,heap_alloc_autoL2))(a0)
	lw	a3, -12(s0) 
	sw	a2, 0(a3) 
	lw	a2, -12(s0) 
	sw	a1, 4(a2) 
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL2))(a0)
	beqz	a0, heap_alloc_LBB0_4 
	j	heap_alloc_LBB0_3 
heap_alloc_LBB0_3:
	lw	a0, -12(s0) 
heap_alloc_autoL3:
	auipc	a1, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL3))(a1)
	sw	a0, 4(a1) 
	j	heap_alloc_LBB0_4 
heap_alloc_LBB0_4:
	lw	a0, -12(s0) 
heap_alloc_autoL4:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL4))(a1)
	j	heap_alloc_LBB0_5 
heap_alloc_LBB0_5:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
heap_alloc_Lfunc_end0:
	#	-- End function 
allocate:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -16(s0) 
	call	heap_init 
	lw	a0, -16(s0) 
	addi	a0, a0, 3 
	andi	a0, a0, -4 
	sw	a0, -16(s0) 
heap_alloc_autoL5:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL5))(a0)
	sw	a0, -20(s0) 
	j	heap_alloc_LBB1_1 
heap_alloc_LBB1_1:
	lw	a0, -20(s0) 
	beqz	a0, heap_alloc_LBB1_14 
	j	heap_alloc_LBB1_2 
heap_alloc_LBB1_2:
	lw	a0, -20(s0) 
	lw	a0, 8(a0) 
	lw	a1, -16(s0) 
	bltu	a0, a1, heap_alloc_LBB1_13 
	j	heap_alloc_LBB1_3 
heap_alloc_LBB1_3:
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
	beqz	a0, heap_alloc_LBB1_5 
	j	heap_alloc_LBB1_4 
heap_alloc_LBB1_4:
	lw	a1, -20(s0) 
	lw	a0, 4(a1) 
	lw	a1, 0(a1) 
	sw	a0, 4(a1) 
	j	heap_alloc_LBB1_5 
heap_alloc_LBB1_5:
	lw	a0, -20(s0) 
	lw	a0, 4(a0) 
	beqz	a0, heap_alloc_LBB1_7 
	j	heap_alloc_LBB1_6 
heap_alloc_LBB1_6:
	lw	a1, -20(s0) 
	lw	a0, 0(a1) 
	lw	a1, 4(a1) 
	sw	a0, 0(a1) 
	j	heap_alloc_LBB1_8 
heap_alloc_LBB1_7:
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
heap_alloc_autoL6:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL6))(a1)
	j	heap_alloc_LBB1_8 
heap_alloc_LBB1_8:
	lw	a0, -20(s0) 
	lw	a1, 8(a0) 
	lw	a0, -16(s0) 
	addi	a0, a0, 12 
	bgeu	a0, a1, heap_alloc_LBB1_12 
	j	heap_alloc_LBB1_9 
heap_alloc_LBB1_9:
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
heap_alloc_autoL7:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a2, %lo(%larel(free_blocks,heap_alloc_autoL7))(a0)
	lw	a3, -28(s0) 
	sw	a2, 0(a3) 
	lw	a2, -28(s0) 
	sw	a1, 4(a2) 
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL7))(a0)
	beqz	a0, heap_alloc_LBB1_11 
	j	heap_alloc_LBB1_10 
heap_alloc_LBB1_10:
	lw	a0, -28(s0) 
heap_alloc_autoL8:
	auipc	a1, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL8))(a1)
	sw	a0, 4(a1) 
	j	heap_alloc_LBB1_11 
heap_alloc_LBB1_11:
	lw	a0, -28(s0) 
heap_alloc_autoL9:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL9))(a1)
	j	heap_alloc_LBB1_12 
heap_alloc_LBB1_12:
	lw	a0, -20(s0) 
	addi	a0, a0, 12 
	sw	a0, -12(s0) 
	j	heap_alloc_LBB1_15 
heap_alloc_LBB1_13:
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
	sw	a0, -20(s0) 
	j	heap_alloc_LBB1_1 
heap_alloc_LBB1_14:
	li	a0, 0 
	sw	a0, -12(s0) 
	j	heap_alloc_LBB1_15 
heap_alloc_LBB1_15:
	lw	a0, -12(s0) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
heap_alloc_Lfunc_end1:
	#	-- End function 
deallocate:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
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
heap_alloc_autoL10:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL10))(a0)
	sw	a0, -20(s0) 
	j	heap_alloc_LBB2_3 
heap_alloc_LBB2_3:
	lw	a0, -20(s0) 
	beqz	a0, heap_alloc_LBB2_17 
	j	heap_alloc_LBB2_4 
heap_alloc_LBB2_4:
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
heap_alloc_LBB2_6:
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
heap_alloc_autoL11:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL11))(a1)
	j	heap_alloc_LBB2_12 
heap_alloc_LBB2_12:
heap_alloc_autoL12:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL12))(a0)
	lw	a2, -16(s0) 
	sw	a1, 0(a2) 
	lw	a2, -16(s0) 
	li	a1, 0 
	sw	a1, 4(a2) 
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL12))(a0)
	beqz	a0, heap_alloc_LBB2_14 
	j	heap_alloc_LBB2_13 
heap_alloc_LBB2_13:
	lw	a0, -16(s0) 
heap_alloc_autoL13:
	auipc	a1, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL13))(a1)
	sw	a0, 4(a1) 
	j	heap_alloc_LBB2_14 
heap_alloc_LBB2_14:
	lw	a0, -16(s0) 
heap_alloc_autoL14:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL14))(a1)
	j	heap_alloc_LBB2_20 
heap_alloc_LBB2_15:
	j	heap_alloc_LBB2_16 
heap_alloc_LBB2_16:
	lw	a0, -20(s0) 
	lw	a0, 0(a0) 
	sw	a0, -20(s0) 
	j	heap_alloc_LBB2_3 
heap_alloc_LBB2_17:
heap_alloc_autoL15:
	auipc	a0, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL15))(a0)
	lw	a2, -16(s0) 
	sw	a1, 0(a2) 
	lw	a2, -16(s0) 
	li	a1, 0 
	sw	a1, 4(a2) 
	lw	a0, %lo(%larel(free_blocks,heap_alloc_autoL15))(a0)
	beqz	a0, heap_alloc_LBB2_19 
	j	heap_alloc_LBB2_18 
heap_alloc_LBB2_18:
	lw	a0, -16(s0) 
heap_alloc_autoL16:
	auipc	a1, %hi(%pcrel(free_blocks))
	lw	a1, %lo(%larel(free_blocks,heap_alloc_autoL16))(a1)
	sw	a0, 4(a1) 
	j	heap_alloc_LBB2_19 
heap_alloc_LBB2_19:
	lw	a0, -16(s0) 
heap_alloc_autoL17:
	auipc	a1, %hi(%pcrel(free_blocks))
	sw	a0, %lo(%larel(free_blocks,heap_alloc_autoL17))(a1)
	j	heap_alloc_LBB2_20 
heap_alloc_LBB2_20:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
heap_alloc_Lfunc_end2:
	#	-- End function 
free_blocks:
	.Numeric
	.word	0
