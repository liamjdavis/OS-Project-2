	.Code
int_to_hex:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	li	a0, 28 
	sw	a0, -20(s0) 
	j	utility_LBB0_1 
utility_LBB0_1:
	lw	a0, -20(s0) 
	bltz	a0, utility_LBB0_4 
	j	utility_LBB0_2 
utility_LBB0_2:
	lw	a0, -12(s0) 
	lw	a1, -20(s0) 
	srl	a0, a0, a1 
	andi	a0, a0, 15 
	sw	a0, -24(s0) 
	lw	a1, -24(s0) 
utility_autoL0:
	auipc	a0, %hi(%pcrel(int_to_hex.hex_digits))
	addi	a0, a0, %lo(%larel(int_to_hex.hex_digits,utility_autoL0))
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	lw	a1, -16(s0) 
	addi	a2, a1, 1 
	sw	a2, -16(s0) 
	sb	a0, 0(a1) 
	j	utility_LBB0_3 
utility_LBB0_3:
	lw	a0, -20(s0) 
	addi	a0, a0, -4 
	sw	a0, -20(s0) 
	j	utility_LBB0_1 
utility_LBB0_4:
	lw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, 0(a1) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end0:
	#	-- End function 
int_to_dec:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	lw	a0, -12(s0) 
	bnez	a0, utility_LBB1_2 
	j	utility_LBB1_1 
utility_LBB1_1:
	lw	a1, -16(s0) 
	li	a0, 48 
	sb	a0, 0(a1) 
	lw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, 1(a1) 
	j	utility_LBB1_10 
utility_LBB1_2:
	li	a0, 0 
	sw	a0, -20(s0) 
	j	utility_LBB1_3 
utility_LBB1_3:
	lw	a0, -12(s0) 
	beqz	a0, utility_LBB1_5 
	j	utility_LBB1_4 
utility_LBB1_4:
	lw	a0, -12(s0) 
	lui	a1, 838861 
	addi	a1, a1, -819 
	mulhu	a2, a0, a1 
	srli	a2, a2, 3 
	li	a3, 10 
	mul	a2, a2, a3 
	sub	a0, a0, a2 
	sw	a0, -24(s0) 
	lw	a0, -12(s0) 
	mulhu	a0, a0, a1 
	srli	a0, a0, 3 
	sw	a0, -12(s0) 
	lw	a0, -24(s0) 
	addi	a0, a0, 48 
	lw	a1, -16(s0) 
	lw	a2, -20(s0) 
	addi	a3, a2, 1 
	sw	a3, -20(s0) 
	add	a1, a1, a2 
	sb	a0, 0(a1) 
	j	utility_LBB1_3 
utility_LBB1_5:
	li	a0, 0 
	sw	a0, -28(s0) 
	j	utility_LBB1_6 
utility_LBB1_6:
	lw	a0, -28(s0) 
	lw	a1, -20(s0) 
	srli	a2, a1, 31 
	add	a1, a1, a2 
	srai	a1, a1, 1 
	bge	a0, a1, utility_LBB1_9 
	j	utility_LBB1_7 
utility_LBB1_7:
	lw	a0, -16(s0) 
	lw	a1, -28(s0) 
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	sb	a0, -29(s0) 
	lw	a1, -16(s0) 
	lw	a0, -20(s0) 
	lw	a2, -28(s0) 
	sub	a0, a0, a2 
	add	a0, a0, a1 
	lbu	a0, -1(a0) 
	add	a1, a1, a2 
	sb	a0, 0(a1) 
	lbu	a0, -29(s0) 
	lw	a2, -16(s0) 
	lw	a1, -20(s0) 
	lw	a3, -28(s0) 
	sub	a1, a1, a3 
	add	a1, a1, a2 
	sb	a0, -1(a1) 
	j	utility_LBB1_8 
utility_LBB1_8:
	lw	a0, -28(s0) 
	addi	a0, a0, 1 
	sw	a0, -28(s0) 
	j	utility_LBB1_6 
utility_LBB1_9:
	lw	a0, -16(s0) 
	lw	a1, -20(s0) 
	add	a1, a0, a1 
	li	a0, 0 
	sb	a0, 0(a1) 
	j	utility_LBB1_10 
utility_LBB1_10:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end1:
	#	-- End function 
copy_str:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	sw	a2, -20(s0) 
	li	a0, 0 
	sw	a0, -24(s0) 
	j	utility_LBB2_1 
utility_LBB2_1:
	lw	a0, -24(s0) 
	lw	a1, -20(s0) 
	addi	a1, a1, -1 
	li	a2, 0 
	sw	a2, -28(s0) # 4-byte Folded Spill 
	bge	a0, a1, utility_LBB2_3 
	j	utility_LBB2_2 
utility_LBB2_2:
	lw	a0, -16(s0) 
	lw	a1, -24(s0) 
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	snez	a0, a0 
	sw	a0, -28(s0) # 4-byte Folded Spill 
	j	utility_LBB2_3 
utility_LBB2_3:
	lw	a0, -28(s0) # 4-byte Folded Reload 
	andi	a0, a0, 1 
	beqz	a0, utility_LBB2_6 
	j	utility_LBB2_4 
utility_LBB2_4:
	lw	a0, -16(s0) 
	lw	a2, -24(s0) 
	add	a0, a0, a2 
	lbu	a0, 0(a0) 
	lw	a1, -12(s0) 
	add	a1, a1, a2 
	sb	a0, 0(a1) 
	j	utility_LBB2_5 
utility_LBB2_5:
	lw	a0, -24(s0) 
	addi	a0, a0, 1 
	sw	a0, -24(s0) 
	j	utility_LBB2_1 
utility_LBB2_6:
	lw	a0, -12(s0) 
	lw	a1, -24(s0) 
	add	a1, a0, a1 
	li	a0, 0 
	sb	a0, 0(a1) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
utility_Lfunc_end2:
	#	-- End function 
	.Numeric
int_to_hex.hex_digits:
	.Text
	.ascii	"0123456789abcdef"
