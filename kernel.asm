	.Code
init_process_management:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
kernel_autoL0:
	auipc	a1, %hi(%pcrel(current_process))
	li	a0, 0 
	sw	a0, %lo(%larel(current_process,kernel_autoL0))(a1)
kernel_autoL1:
	auipc	a0, %hi(%pcrel(kernel_L.str))
	addi	a0, a0, %lo(%larel(kernel_L.str,kernel_autoL1))
	call	print 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
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
	lw	a0, -12(s0) 
	addi	a0, a0, -2048 
	addi	a0, a0, -2048 
kernel_autoL2:
	auipc	a1, %hi(%pcrel(statics_limit))
	sw	a0, %lo(%larel(statics_limit,kernel_autoL2))(a1)
kernel_autoL3:
	auipc	a0, %hi(%pcrel(kernel_L.str.1))
	addi	a0, a0, %lo(%larel(kernel_L.str.1,kernel_autoL3))
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
kernel_autoL4:
	auipc	a1, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL4))(a1)
	lw	a2, -24(s0) 
	sw	a0, 0(a2) 
	lw	a0, -24(s0) 
	sw	a0, %lo(%larel(free_list_head,kernel_autoL4))(a1)
	lw	a0, -20(s0) 
	lui	a1, 8 
	add	a0, a0, a1 
	sw	a0, -20(s0) 
	j	kernel_LBB1_1 
kernel_LBB1_3:
kernel_autoL5:
	auipc	a0, %hi(%pcrel(statics_limit))
	lw	a0, %lo(%larel(statics_limit,kernel_autoL5))(a0)
	call	heap_init 
	call	init_process_management 
	li	a0, 0 
	sw	a0, -28(s0) 
kernel_autoL6:
	auipc	a0, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL6))(a0)
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
kernel_autoL7:
	auipc	a0, %hi(%pcrel(kernel_L.str.2))
	addi	a0, a0, %lo(%larel(kernel_L.str.2,kernel_autoL7))
	call	print 
	lw	a0, -28(s0) 
	addi	a1, s0, -41 
	sw	a1, -48(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -48(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL8:
	auipc	a0, %hi(%pcrel(kernel_L.str.3))
	addi	a0, a0, %lo(%larel(kernel_L.str.3,kernel_autoL8))
	call	print 
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
kernel_Lfunc_end1:
	#	-- End function 
schedule:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -16(s0) 
	sw	a1, -20(s0) 
kernel_autoL9:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,kernel_autoL9))(a0)
	bnez	a0, kernel_LBB2_2 
	j	kernel_LBB2_1 
kernel_LBB2_1:
kernel_autoL10:
	auipc	a0, %hi(%pcrel(kernel_L.str.4))
	addi	a0, a0, %lo(%larel(kernel_L.str.4,kernel_autoL10))
	call	print 
	li	a0, 0 
	sw	a0, -12(s0) 
	j	kernel_LBB2_3 
kernel_LBB2_2:
	lw	a0, -16(s0) 
kernel_autoL11:
	auipc	a1, %hi(%pcrel(current_process))
	sw	a1, -24(s0) # 4-byte Folded Spill 
	lw	a2, %lo(%larel(current_process,kernel_autoL11))(a1)
	sw	a0, 4(a2) 
	lw	a0, -20(s0) 
	lw	a2, %lo(%larel(current_process,kernel_autoL11))(a1)
	sw	a0, 8(a2) 
	lw	a0, %lo(%larel(current_process,kernel_autoL11))(a1)
	lw	a0, 12(a0) 
	sw	a0, %lo(%larel(current_process,kernel_autoL11))(a1)
kernel_autoL12:
	auipc	a0, %hi(%pcrel(kernel_L.str.5))
	addi	a0, a0, %lo(%larel(kernel_L.str.5,kernel_autoL12))
	call	print 
	lw	a0, -24(s0) # 4-byte Folded Reload 
	lw	a0, %lo(%larel(current_process,kernel_autoL11))(a0)
	sw	a0, -12(s0) 
	j	kernel_LBB2_3 
kernel_LBB2_3:
	lw	a0, -12(s0) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
kernel_Lfunc_end2:
	#	-- End function 
handle_process_exit:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
kernel_autoL13:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,kernel_autoL13))(a0)
	bnez	a0, kernel_LBB3_2 
	j	kernel_LBB3_1 
kernel_LBB3_1:
kernel_autoL14:
	auipc	a0, %hi(%pcrel(kernel_L.str.6))
	addi	a0, a0, %lo(%larel(kernel_L.str.6,kernel_autoL14))
	call	print 
	j	kernel_LBB3_5 
kernel_LBB3_2:
kernel_autoL15:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a1, %lo(%larel(current_process,kernel_autoL15))(a0)
	sw	a1, -12(s0) 
	lw	a0, %lo(%larel(current_process,kernel_autoL15))(a0)
	lw	a0, 0(a0) 
	sw	a0, -16(s0) 
	lw	a0, -12(s0) 
	lw	a1, -16(s0) 
	call	delete_process 
	sw	a0, -20(s0) 
	lw	a0, -20(s0) 
	bnez	a0, kernel_LBB3_4 
	j	kernel_LBB3_3 
kernel_LBB3_3:
kernel_autoL16:
	auipc	a1, %hi(%pcrel(current_process))
	li	a0, 0 
	sw	a0, %lo(%larel(current_process,kernel_autoL16))(a1)
kernel_autoL17:
	auipc	a0, %hi(%pcrel(kernel_L.str.7))
	addi	a0, a0, %lo(%larel(kernel_L.str.7,kernel_autoL17))
	call	print 
	j	kernel_LBB3_5 
kernel_LBB3_4:
	lw	a0, -20(s0) 
kernel_autoL18:
	auipc	a1, %hi(%pcrel(current_process))
	sw	a1, -24(s0) # 4-byte Folded Spill 
	sw	a0, %lo(%larel(current_process,kernel_autoL18))(a1)
kernel_autoL19:
	auipc	a0, %hi(%pcrel(kernel_L.str.8))
	addi	a0, a0, %lo(%larel(kernel_L.str.8,kernel_autoL19))
	call	print 
	lw	a0, -24(s0) # 4-byte Folded Reload 
	lw	a1, %lo(%larel(current_process,kernel_autoL18))(a0)
	lw	a0, 4(a1) 
	lw	a1, 8(a1) 
	call	schedule 
	j	kernel_LBB3_5 
kernel_LBB3_5:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
kernel_Lfunc_end3:
	#	-- End function 
run_programs:
	#	%bb.0: 
	addi	sp, sp, -48 
	sw	ra, 44(sp) # 4-byte Folded Spill 
	sw	s0, 40(sp) # 4-byte Folded Spill 
	addi	s0, sp, 48 
	sw	a0, -12(s0) 
kernel_autoL20:
	auipc	a0, %hi(%pcrel(kernel_L.str.9))
	addi	a0, a0, %lo(%larel(kernel_L.str.9,kernel_autoL20))
	call	print 
	lw	a0, -12(s0) 
	addi	a1, s0, -24 
	sw	a1, -36(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -36(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL21:
	auipc	a0, %hi(%pcrel(kernel_L.str.10))
	addi	a0, a0, %lo(%larel(kernel_L.str.10,kernel_autoL21))
	call	print 
kernel_autoL22:
	auipc	a0, %hi(%pcrel(ROM_device_code))
	lw	a0, %lo(%larel(ROM_device_code,kernel_autoL22))(a0)
	lw	a1, -12(s0) 
	call	find_device 
	sw	a0, -28(s0) 
	lw	a0, -28(s0) 
	bnez	a0, kernel_LBB4_2 
	j	kernel_LBB4_1 
kernel_LBB4_1:
kernel_autoL23:
	auipc	a0, %hi(%pcrel(kernel_L.str.11))
	addi	a0, a0, %lo(%larel(kernel_L.str.11,kernel_autoL23))
	call	print 
	lw	a0, -12(s0) 
	addi	a1, s0, -24 
	sw	a1, -40(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -40(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL24:
	auipc	a0, %hi(%pcrel(kernel_L.str.12))
	addi	a0, a0, %lo(%larel(kernel_L.str.12,kernel_autoL24))
	call	print 
	j	kernel_LBB4_3 
kernel_LBB4_2:
kernel_autoL25:
	auipc	a0, %hi(%pcrel(kernel_L.str.13))
	addi	a0, a0, %lo(%larel(kernel_L.str.13,kernel_autoL25))
	call	print 
kernel_autoL26:
	auipc	a1, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL26))(a1)
	sw	a0, -32(s0) 
	lw	a0, -32(s0) 
	lw	a0, 0(a0) 
	sw	a0, %lo(%larel(free_list_head,kernel_autoL26))(a1)
	lw	a0, -28(s0) 
	lw	a0, 4(a0) 
kernel_autoL27:
	auipc	a1, %hi(%pcrel(DMA_portal_ptr))
	lw	a2, %lo(%larel(DMA_portal_ptr,kernel_autoL27))(a1)
	sw	a0, 0(a2) 
	lw	a0, -32(s0) 
	lw	a2, %lo(%larel(DMA_portal_ptr,kernel_autoL27))(a1)
	sw	a0, 4(a2) 
	lw	a2, -28(s0) 
	lw	a0, 8(a2) 
	lw	a2, 4(a2) 
	sub	a0, a0, a2 
	lw	a1, %lo(%larel(DMA_portal_ptr,kernel_autoL27))(a1)
	sw	a0, 8(a1) 
kernel_autoL28:
	auipc	a0, %hi(%pcrel(current_process))
	sw	a0, -44(s0) # 4-byte Folded Spill 
	lw	a0, %lo(%larel(current_process,kernel_autoL28))(a0)
kernel_autoL29:
	auipc	a3, %hi(%pcrel(next_pid))
	lw	a1, %lo(%larel(next_pid,kernel_autoL29))(a3)
	addi	a2, a1, 1 
	sw	a2, %lo(%larel(next_pid,kernel_autoL29))(a3)
	lw	a3, -32(s0) 
	lui	a2, 32 
	add	a2, a3, a2 
	call	insert_process 
	mv	a1, a0 
	lw	a0, -44(s0) # 4-byte Folded Reload 
	sw	a1, %lo(%larel(current_process,kernel_autoL28))(a0)
	lw	a0, %lo(%larel(current_process,kernel_autoL28))(a0)
	call	load_process_state 
	j	kernel_LBB4_3 
kernel_LBB4_3:
	lw	ra, 44(sp) # 4-byte Folded Reload 
	lw	s0, 40(sp) # 4-byte Folded Reload 
	addi	sp, sp, 48 
	ret	
kernel_Lfunc_end4:
	#	-- End function 
kernel_L.str:
	.Text
	.asciz	"Process management system initialized.\n"
statics_limit:
	.Numeric
	.word	0                               # 0x0
kernel_L.str.1:
	.Text
	.asciz	"Initializing RAM free block list...\n"
free_list_head:
	.Numeric
	.word	0
kernel_L.str.2:
	.Text
	.asciz	"Created "
kernel_L.str.3:
	.asciz	" free blocks. \n"
kernel_L.str.4:
	.asciz	"No processes to schedule\n"
kernel_L.str.5:
	.asciz	"Scheduling process\n"
kernel_L.str.6:
	.asciz	"No processes to exit\n"
kernel_L.str.7:
	.asciz	"Process exited. No more processes to run.\n"
kernel_L.str.8:
	.asciz	"Process exited. Scheduling next process.\n"
kernel_L.str.9:
	.asciz	"Searching for ROM #"
kernel_L.str.10:
	.asciz	"\n"
kernel_L.str.11:
	.asciz	"ROM #"
kernel_L.str.12:
	.asciz	" not found. \n"
kernel_L.str.13:
	.asciz	"Running program...\n"
next_pid:
	.Numeric
	.word	1                               # 0x1
