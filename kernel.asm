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
	j	kernel_LBB0_1 
kernel_LBB0_1:
	lw	a0, -20(s0) 
	bltz	a0, kernel_LBB0_4 
	j	kernel_LBB0_2 
kernel_LBB0_2:
	lw	a0, -12(s0) 
	lw	a1, -20(s0) 
	srl	a0, a0, a1 
	andi	a0, a0, 15 
	sw	a0, -24(s0) 
	lw	a1, -24(s0) 
kernel_autoL0:
	auipc	a0, %hi(%pcrel(hex_digits))
	addi	a0, a0, %lo(%larel(hex_digits,kernel_autoL0))
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	lw	a1, -16(s0) 
	addi	a2, a1, 1 
	sw	a2, -16(s0) 
	sb	a0, 0(a1) 
	j	kernel_LBB0_3 
kernel_LBB0_3:
	lw	a0, -20(s0) 
	addi	a0, a0, -4 
	sw	a0, -20(s0) 
	j	kernel_LBB0_1 
kernel_LBB0_4:
	lw	a1, -16(s0) 
	li	a0, 0 
	sb	a0, 0(a1) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
kernel_Lfunc_end0:
	#	-- End function 
init_memory:
	#	%bb.0: 
	addi	sp, sp, -48 
	sw	ra, 44(sp) # 4-byte Folded Spill 
	sw	s0, 40(sp) # 4-byte Folded Spill 
	addi	s0, sp, 48 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	lw	a0, -12(s0) 
	sw	a0, -20(s0) 
kernel_autoL1:
	auipc	a0, %hi(%pcrel(kernel_L.str))
	addi	a0, a0, %lo(%larel(kernel_L.str,kernel_autoL1))
	call	print 
	j	kernel_LBB1_1 
kernel_LBB1_1:
	lw	a0, -20(s0) 
	lui	a1, 8 
	add	a1, a0, a1 
	lw	a0, -16(s0) 
	bltu	a0, a1, kernel_LBB1_3 
	j	kernel_LBB1_2 
kernel_LBB1_2:
	lw	a0, -20(s0) 
	sw	a0, -24(s0) 
kernel_autoL2:
	auipc	a1, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL2))(a1)
	lw	a2, -24(s0) 
	sw	a0, 0(a2) 
	lw	a0, -24(s0) 
	sw	a0, %lo(%larel(free_list_head,kernel_autoL2))(a1)
	lw	a0, -20(s0) 
	lui	a1, 8 
	add	a0, a0, a1 
	sw	a0, -20(s0) 
	j	kernel_LBB1_1 
kernel_LBB1_3:
	li	a0, 0 
	sw	a0, -28(s0) 
kernel_autoL3:
	auipc	a0, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL3))(a0)
	sw	a0, -32(s0) 
	j	kernel_LBB1_4 
kernel_LBB1_4:
	lw	a0, -32(s0) 
	beqz	a0, kernel_LBB1_6 
	j	kernel_LBB1_5 
kernel_LBB1_5:
	lw	a0, -28(s0) 
	addi	a0, a0, 1 
	sw	a0, -28(s0) 
	lw	a0, -32(s0) 
	lw	a0, 0(a0) 
	sw	a0, -32(s0) 
	j	kernel_LBB1_4 
kernel_LBB1_6:
kernel_autoL4:
	auipc	a0, %hi(%pcrel(kernel_L.str.1))
	addi	a0, a0, %lo(%larel(kernel_L.str.1,kernel_autoL4))
	call	print 
	lw	a0, -28(s0) 
	addi	a1, s0, -41 
	sw	a1, -48(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -48(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL5:
	auipc	a0, %hi(%pcrel(kernel_L.str.2))
	addi	a0, a0, %lo(%larel(kernel_L.str.2,kernel_autoL5))
	call	print 
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
kernel_Lfunc_end1:
	#	-- End function 
run_programs:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
kernel_autoL6:
	auipc	a0, %hi(%pcrel(kernel_L.str.3))
	addi	a0, a0, %lo(%larel(kernel_L.str.3,kernel_autoL6))
	call	print 
kernel_autoL7:
	auipc	a0, %hi(%pcrel(run_programs.next_program_ROM))
	sw	a0, -28(s0) # 4-byte Folded Spill 
	lw	a0, %lo(%larel(run_programs.next_program_ROM,kernel_autoL7))(a0)
	addi	a1, s0, -17 
	sw	a1, -32(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -32(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL8:
	auipc	a0, %hi(%pcrel(kernel_L.str.4))
	addi	a0, a0, %lo(%larel(kernel_L.str.4,kernel_autoL8))
	call	print 
	lw	a3, -28(s0) # 4-byte Folded Reload 
kernel_autoL9:
	auipc	a0, %hi(%pcrel(ROM_device_code))
	lw	a0, %lo(%larel(ROM_device_code,kernel_autoL9))(a0)
	lw	a1, %lo(%larel(run_programs.next_program_ROM,kernel_autoL7))(a3)
	addi	a2, a1, 1 
	sw	a2, %lo(%larel(run_programs.next_program_ROM,kernel_autoL7))(a3)
	call	find_device 
	sw	a0, -24(s0) 
	lw	a0, -24(s0) 
	bnez	a0, kernel_LBB2_2 
	j	kernel_LBB2_1 
kernel_LBB2_1:
	j	kernel_LBB2_3 
kernel_LBB2_2:
kernel_autoL10:
	auipc	a0, %hi(%pcrel(kernel_L.str.5))
	addi	a0, a0, %lo(%larel(kernel_L.str.5,kernel_autoL10))
	call	print 
	lw	a0, -24(s0) 
	lw	a0, 4(a0) 
kernel_autoL11:
	auipc	a2, %hi(%pcrel(DMA_portal_ptr))
	lw	a1, %lo(%larel(DMA_portal_ptr,kernel_autoL11))(a2)
	sw	a0, 0(a1) 
kernel_autoL12:
	auipc	a0, %hi(%pcrel(kernel_limit))
	lw	a1, %lo(%larel(kernel_limit,kernel_autoL12))(a0)
	lw	a3, %lo(%larel(DMA_portal_ptr,kernel_autoL11))(a2)
	sw	a1, 4(a3) 
	lw	a3, -24(s0) 
	lw	a1, 8(a3) 
	lw	a3, 4(a3) 
	sub	a1, a1, a3 
	lw	a2, %lo(%larel(DMA_portal_ptr,kernel_autoL11))(a2)
	sw	a1, 8(a2) 
	lw	a0, %lo(%larel(kernel_limit,kernel_autoL12))(a0)
	call	userspace_jump 
	j	kernel_LBB2_3 
kernel_LBB2_3:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
kernel_Lfunc_end2:
	#	-- End function 
	.Numeric
hex_digits:
	.Text
	.ascii	"0123456789abcdef"
kernel_L.str:
	.asciz	"Initializing memory free list...\n"
free_list_head:
	.Numeric
	.word	0
kernel_L.str.1:
	.Text
	.asciz	"Created "
kernel_L.str.2:
	.asciz	" free blocks."
run_programs.next_program_ROM:
	.Numeric
	.word	3                               # 0x3
kernel_L.str.3:
	.Text
	.asciz	"Searching for ROM #"
kernel_L.str.4:
	.asciz	"\n"
kernel_L.str.5:
	.asciz	"Running program...\n"
