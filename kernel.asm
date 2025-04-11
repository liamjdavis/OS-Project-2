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
	addi	sp, sp, -64 
	sw	ra, 60(sp) # 4-byte Folded Spill 
	sw	s0, 56(sp) # 4-byte Folded Spill 
	addi	s0, sp, 64 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
kernel_autoL2:
	auipc	a0, %hi(%pcrel(kernel_end_marker))
	addi	a0, a0, %lo(%larel(kernel_end_marker,kernel_autoL2))
	addi	a0, a0, 16 
	sw	a0, -20(s0) 
	lw	a0, -12(s0) 
	sw	a0, -24(s0) 
kernel_autoL3:
	auipc	a0, %hi(%pcrel(kernel_L.str.1))
	addi	a0, a0, %lo(%larel(kernel_L.str.1,kernel_autoL3))
	call	print 
	j	kernel_LBB1_1 
kernel_LBB1_1:
	lw	a0, -24(s0) 
	lui	a1, 8 
	add	a1, a0, a1 
	lw	a0, -16(s0) 
	bltu	a0, a1, kernel_LBB1_3 
	j	kernel_LBB1_2 
kernel_LBB1_2:
	lw	a0, -24(s0) 
	sw	a0, -28(s0) 
kernel_autoL4:
	auipc	a1, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL4))(a1)
	lw	a2, -28(s0) 
	sw	a0, 0(a2) 
	lw	a0, -28(s0) 
	sw	a0, %lo(%larel(free_list_head,kernel_autoL4))(a1)
	lw	a0, -24(s0) 
	lui	a1, 8 
	add	a0, a0, a1 
	sw	a0, -24(s0) 
	j	kernel_LBB1_1 
kernel_LBB1_3:
	call	init_process_management 
	lw	a0, -20(s0) 
	call	heap_init 
kernel_autoL5:
	auipc	a1, %hi(%pcrel(heap_free_list))
	sw	a0, %lo(%larel(heap_free_list,kernel_autoL5))(a1)
	li	a0, 0 
	sw	a0, -32(s0) 
kernel_autoL6:
	auipc	a0, %hi(%pcrel(free_list_head))
	lw	a0, %lo(%larel(free_list_head,kernel_autoL6))(a0)
	sw	a0, -36(s0) 
	j	kernel_LBB1_4 
kernel_LBB1_4:
	lw	a0, -36(s0) 
	beqz	a0, kernel_LBB1_6 
	j	kernel_LBB1_5 
kernel_LBB1_5:
	lw	a0, -32(s0) 
	addi	a0, a0, 1 
	sw	a0, -32(s0) 
	lw	a0, -36(s0) 
	lw	a0, 0(a0) 
	sw	a0, -36(s0) 
	j	kernel_LBB1_4 
kernel_LBB1_6:
kernel_autoL7:
	auipc	a0, %hi(%pcrel(kernel_L.str.2))
	addi	a0, a0, %lo(%larel(kernel_L.str.2,kernel_autoL7))
	call	print 
	lw	a0, -32(s0) 
	addi	a1, s0, -45 
	sw	a1, -52(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -52(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL8:
	auipc	a0, %hi(%pcrel(kernel_L.str.3))
	addi	a0, a0, %lo(%larel(kernel_L.str.3,kernel_autoL8))
	call	print 
	lw	ra, 60(sp) # 4-byte Folded Reload 
	lw	s0, 56(sp) # 4-byte Folded Reload 
	addi	sp, sp, 64 
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
	sw	a0, 56(a2) 
	lw	a0, -20(s0) 
	lw	a2, %lo(%larel(current_process,kernel_autoL11))(a1)
	sw	a0, 60(a2) 
	lw	a0, %lo(%larel(current_process,kernel_autoL11))(a1)
	lw	a0, 64(a0) 
	sw	a0, %lo(%larel(current_process,kernel_autoL11))(a1)
kernel_autoL12:
	auipc	a0, %hi(%pcrel(kernel_L.str.5))
	addi	a0, a0, %lo(%larel(kernel_L.str.5,kernel_autoL12))
	call	print 
	lw	a0, -24(s0) # 4-byte Folded Reload 
	lw	a0, %lo(%larel(current_process,kernel_autoL11))(a0)
	addi	a0, a0, 4 
	call	print 
kernel_autoL13:
	auipc	a0, %hi(%pcrel(kernel_L.str.6))
	addi	a0, a0, %lo(%larel(kernel_L.str.6,kernel_autoL13))
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
kernel_autoL14:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,kernel_autoL14))(a0)
	bnez	a0, kernel_LBB3_2 
	j	kernel_LBB3_1 
kernel_LBB3_1:
kernel_autoL15:
	auipc	a0, %hi(%pcrel(kernel_L.str.7))
	addi	a0, a0, %lo(%larel(kernel_L.str.7,kernel_autoL15))
	call	print 
	j	kernel_LBB3_7 
kernel_LBB3_2:
kernel_autoL16:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a1, %lo(%larel(current_process,kernel_autoL16))(a0)
	sw	a1, -12(s0) 
	lw	a1, %lo(%larel(current_process,kernel_autoL16))(a0)
	lw	a1, 0(a1) 
	sw	a1, -16(s0) 
	lw	a1, %lo(%larel(current_process,kernel_autoL16))(a0)
	lw	a1, 68(a1) 
	sw	a1, %lo(%larel(current_process,kernel_autoL16))(a0)
	lw	a0, %lo(%larel(current_process,kernel_autoL16))(a0)
	lw	a1, -12(s0) 
	bne	a0, a1, kernel_LBB3_4 
	j	kernel_LBB3_3 
kernel_LBB3_3:
kernel_autoL17:
	auipc	a1, %hi(%pcrel(current_process))
	li	a0, 0 
	sw	a0, %lo(%larel(current_process,kernel_autoL17))(a1)
	j	kernel_LBB3_4 
kernel_LBB3_4:
	lw	a1, -16(s0) 
kernel_autoL18:
	auipc	a0, %hi(%pcrel(current_process))
	sw	a0, -20(s0) # 4-byte Folded Spill 
	addi	a0, a0, %lo(%larel(current_process,kernel_autoL18))
	call	delete_process 
kernel_autoL19:
	auipc	a0, %hi(%pcrel(kernel_L.str.8))
	addi	a0, a0, %lo(%larel(kernel_L.str.8,kernel_autoL19))
	call	print 
	lw	a0, -20(s0) # 4-byte Folded Reload 
	lw	a0, %lo(%larel(current_process,kernel_autoL18))(a0)
	bnez	a0, kernel_LBB3_6 
	j	kernel_LBB3_5 
kernel_LBB3_5:
kernel_autoL20:
	auipc	a0, %hi(%pcrel(kernel_L.str.9))
	addi	a0, a0, %lo(%larel(kernel_L.str.9,kernel_autoL20))
	call	print 
	j	kernel_LBB3_7 
kernel_LBB3_6:
kernel_autoL21:
	auipc	a0, %hi(%pcrel(kernel_L.str.10))
	addi	a0, a0, %lo(%larel(kernel_L.str.10,kernel_autoL21))
	call	print 
kernel_autoL22:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a1, %lo(%larel(current_process,kernel_autoL22))(a0)
	lw	a0, 56(a1) 
	lw	a1, 60(a1) 
	call	schedule 
	j	kernel_LBB3_7 
kernel_LBB3_7:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
kernel_Lfunc_end3:
	#	-- End function 
run_programs:
	#	%bb.0: 
	addi	sp, sp, -128 
	sw	ra, 124(sp) # 4-byte Folded Spill 
	sw	s0, 120(sp) # 4-byte Folded Spill 
	addi	s0, sp, 128 
	sw	a0, -12(s0) 
kernel_autoL23:
	auipc	a0, %hi(%pcrel(kernel_L.str.11))
	addi	a0, a0, %lo(%larel(kernel_L.str.11,kernel_autoL23))
	call	print 
	lw	a0, -12(s0) 
	addi	a1, s0, -24 
	sw	a1, -112(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -112(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL24:
	auipc	a0, %hi(%pcrel(kernel_L.str.6))
	addi	a0, a0, %lo(%larel(kernel_L.str.6,kernel_autoL24))
	sw	a0, -108(s0) # 4-byte Folded Spill 
	call	print 
kernel_autoL25:
	auipc	a0, %hi(%pcrel(kernel_L.str.12))
	addi	a0, a0, %lo(%larel(kernel_L.str.12,kernel_autoL25))
	call	print 
	lw	a1, -112(s0) # 4-byte Folded Reload 
kernel_autoL26:
	auipc	a0, %hi(%pcrel(ROM_device_code))
	sw	a0, -104(s0) # 4-byte Folded Spill 
	lw	a0, %lo(%larel(ROM_device_code,kernel_autoL26))(a0)
	call	int_to_hex 
	lw	a0, -112(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL27:
	auipc	a0, %hi(%pcrel(kernel_L.str.13))
	addi	a0, a0, %lo(%larel(kernel_L.str.13,kernel_autoL27))
	call	print 
	lw	a1, -112(s0) # 4-byte Folded Reload 
	lw	a0, -12(s0) 
	call	int_to_hex 
	lw	a0, -112(s0) # 4-byte Folded Reload 
	call	print 
	lw	a0, -108(s0) # 4-byte Folded Reload 
	call	print 
	lw	a0, -104(s0) # 4-byte Folded Reload 
	lw	a0, %lo(%larel(ROM_device_code,kernel_autoL26))(a0)
	lw	a1, -12(s0) 
	call	find_device 
	sw	a0, -28(s0) 
	lw	a0, -28(s0) 
	bnez	a0, kernel_LBB4_2 
	j	kernel_LBB4_1 
kernel_LBB4_1:
kernel_autoL28:
	auipc	a0, %hi(%pcrel(kernel_L.str.14))
	addi	a0, a0, %lo(%larel(kernel_L.str.14,kernel_autoL28))
	call	print 
	lw	a0, -12(s0) 
	addi	a1, s0, -24 
	sw	a1, -116(s0) # 4-byte Folded Spill 
	call	int_to_hex 
	lw	a0, -116(s0) # 4-byte Folded Reload 
	call	print 
kernel_autoL29:
	auipc	a0, %hi(%pcrel(kernel_L.str.15))
	addi	a0, a0, %lo(%larel(kernel_L.str.15,kernel_autoL29))
	call	print 
	j	kernel_LBB4_9 
kernel_LBB4_2:
kernel_autoL30:
	auipc	a0, %hi(%pcrel(kernel_L.str.16))
	addi	a0, a0, %lo(%larel(kernel_L.str.16,kernel_autoL30))
	call	print 
	lw	a0, -28(s0) 
	lw	a0, 4(a0) 
kernel_autoL31:
	auipc	a1, %hi(%pcrel(DMA_portal_ptr))
	lw	a2, %lo(%larel(DMA_portal_ptr,kernel_autoL31))(a1)
	sw	a0, 0(a2) 
kernel_autoL32:
	auipc	a0, %hi(%pcrel(kernel_limit))
	lw	a0, %lo(%larel(kernel_limit,kernel_autoL32))(a0)
	lw	a2, %lo(%larel(DMA_portal_ptr,kernel_autoL31))(a1)
	sw	a0, 4(a2) 
	lw	a2, -28(s0) 
	lw	a0, 8(a2) 
	lw	a2, 4(a2) 
	sub	a0, a0, a2 
	lw	a1, %lo(%larel(DMA_portal_ptr,kernel_autoL31))(a1)
	sw	a0, 8(a1) 
kernel_autoL33:
	auipc	a1, %hi(%pcrel(kernel_L.str.17))
	addi	a1, a1, %lo(%larel(kernel_L.str.17,kernel_autoL33))
	addi	a0, s0, -80 
	li	a2, 52 
	call	copy_str 
	lw	a0, -12(s0) 
	addi	a1, s0, -89 
	call	int_to_dec 
	li	a0, 0 
	sw	a0, -96(s0) 
	j	kernel_LBB4_3 
kernel_LBB4_3:
	lw	a1, -96(s0) 
	addi	a0, s0, -80 
	add	a0, a0, a1 
	lbu	a0, 0(a0) 
	beqz	a0, kernel_LBB4_5 
	j	kernel_LBB4_4 
kernel_LBB4_4:
	lw	a0, -96(s0) 
	addi	a0, a0, 1 
	sw	a0, -96(s0) 
	j	kernel_LBB4_3 
kernel_LBB4_5:
	lw	a2, -96(s0) 
	addi	a0, s0, -80 
	sw	a0, -124(s0) # 4-byte Folded Spill 
	add	a0, a0, a2 
	li	a1, 52 
	sub	a2, a1, a2 
	addi	a1, s0, -89 
	call	copy_str 
	lw	a2, -124(s0) # 4-byte Folded Reload 
kernel_autoL34:
	auipc	a0, %hi(%pcrel(current_process))
	sw	a0, -120(s0) # 4-byte Folded Spill 
	addi	a1, a0, %lo(%larel(current_process,kernel_autoL34))
	lw	a0, %lo(%larel(current_process,kernel_autoL34))(a0)
	seqz	a0, a0 
	addi	a0, a0, -1 
	and	a0, a0, a1 
	sw	a0, -100(s0) 
	lw	a0, -100(s0) 
kernel_autoL35:
	auipc	a4, %hi(%pcrel(next_pid))
	lw	a1, %lo(%larel(next_pid,kernel_autoL35))(a4)
	addi	a3, a1, 1 
	sw	a3, %lo(%larel(next_pid,kernel_autoL35))(a4)
kernel_autoL36:
	auipc	a3, %hi(%pcrel(kernel_limit))
	lw	a4, %lo(%larel(kernel_limit,kernel_autoL36))(a3)
	lui	a3, 8 
	add	a3, a4, a3 
	call	insert_process 
kernel_autoL37:
	auipc	a0, %hi(%pcrel(kernel_L.str.18))
	addi	a0, a0, %lo(%larel(kernel_L.str.18,kernel_autoL37))
	call	print 
	lw	a0, -120(s0) # 4-byte Folded Reload 
	lw	a0, %lo(%larel(current_process,kernel_autoL34))(a0)
	call	display_processes 
	lw	a0, -120(s0) # 4-byte Folded Reload 
	lw	a0, %lo(%larel(current_process,kernel_autoL34))(a0)
	beqz	a0, kernel_LBB4_7 
	j	kernel_LBB4_6 
kernel_LBB4_6:
kernel_autoL38:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a1, %lo(%larel(current_process,kernel_autoL38))(a0)
	lw	a0, 64(a1) 
	bne	a0, a1, kernel_LBB4_8 
	j	kernel_LBB4_7 
kernel_LBB4_7:
kernel_autoL39:
	auipc	a0, %hi(%pcrel(kernel_L.str.19))
	addi	a0, a0, %lo(%larel(kernel_L.str.19,kernel_autoL39))
	call	print 
	li	a1, 0 
	mv	a0, a1 
	call	schedule 
kernel_autoL40:
	auipc	a0, %hi(%pcrel(kernel_L.str.20))
	addi	a0, a0, %lo(%larel(kernel_L.str.20,kernel_autoL40))
	call	print 
kernel_autoL41:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,kernel_autoL41))(a0)
	call	display_processes 
	j	kernel_LBB4_8 
kernel_LBB4_8:
kernel_autoL42:
	auipc	a0, %hi(%pcrel(kernel_L.str.21))
	addi	a0, a0, %lo(%larel(kernel_L.str.21,kernel_autoL42))
	call	print 
kernel_autoL43:
	auipc	a0, %hi(%pcrel(kernel_limit))
	lw	a0, %lo(%larel(kernel_limit,kernel_autoL43))(a0)
	call	userspace_jump 
	j	kernel_LBB4_9 
kernel_LBB4_9:
	lw	ra, 124(sp) # 4-byte Folded Reload 
	lw	s0, 120(sp) # 4-byte Folded Reload 
	addi	sp, sp, 128 
	ret	
kernel_Lfunc_end4:
	#	-- End function 
kernel_L.str:
	.Text
	.asciz	"Process management system initialized.\n"
kernel_L.str.1:
	.asciz	"Initializing RAM free block list...\n"
free_list_head:
	.Numeric
	.word	0
heap_free_list:
	.word	0
kernel_L.str.2:
	.Text
	.asciz	"Created "
kernel_L.str.3:
	.asciz	" free blocks. \n"
kernel_L.str.4:
	.asciz	"No processes to schedule\n"
kernel_L.str.5:
	.asciz	"Scheduling process: "
kernel_L.str.6:
	.asciz	"\n"
kernel_L.str.7:
	.asciz	"No processes to exit\n"
kernel_L.str.8:
	.asciz	"Process exited. "
kernel_L.str.9:
	.asciz	"No more processes to run.\n"
kernel_L.str.10:
	.asciz	"Scheduling next process.\n"
kernel_L.str.11:
	.asciz	"Searching for ROM #"
kernel_L.str.12:
	.asciz	"ROM_device_code: "
kernel_L.str.13:
	.asciz	", rom_number: "
kernel_L.str.14:
	.asciz	"ROM #"
kernel_L.str.15:
	.asciz	" not found. \n"
kernel_L.str.16:
	.asciz	"Running program...\n"
kernel_L.str.17:
	.asciz	"Program-"
next_pid:
	.Numeric
	.word	1                               # 0x1
kernel_L.str.18:
	.Text
	.asciz	"Process list after insertion:\n"
kernel_L.str.19:
	.asciz	"First process - scheduling...\n"
kernel_L.str.20:
	.asciz	"After scheduling:\n"
kernel_L.str.21:
	.asciz	"Jumping to userspace...\n"
