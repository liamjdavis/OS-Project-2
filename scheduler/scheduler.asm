	.Code
enqueue:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	lw	a0, -12(s0) 
	beqz	a0, scheduler_LBB0_2 
	j	scheduler_LBB0_1 
scheduler_LBB0_1:
	lw	a0, -16(s0) 
	bnez	a0, scheduler_LBB0_3 
	j	scheduler_LBB0_2 
scheduler_LBB0_2:
scheduler_autoL0:
	auipc	a0, %hi(%pcrel(scheduler_L.str))
	addi	a0, a0, %lo(%larel(scheduler_L.str,scheduler_autoL0))
	call	print 
	j	scheduler_LBB0_9 
scheduler_LBB0_3:
	lw	a1, -16(s0) 
	li	a0, 0 
	sw	a0, 148(a1) 
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	bnez	a0, scheduler_LBB0_5 
	j	scheduler_LBB0_4 
scheduler_LBB0_4:
	lw	a0, -16(s0) 
	lw	a1, -12(s0) 
	sw	a0, 0(a1) 
	lw	a0, -16(s0) 
	sw	a0, 148(a0) 
	j	scheduler_LBB0_9 
scheduler_LBB0_5:
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	sw	a0, -20(s0) 
	j	scheduler_LBB0_6 
scheduler_LBB0_6:
	lw	a0, -20(s0) 
	lw	a0, 148(a0) 
	lw	a1, -12(s0) 
	lw	a1, 0(a1) 
	beq	a0, a1, scheduler_LBB0_8 
	j	scheduler_LBB0_7 
scheduler_LBB0_7:
	lw	a0, -20(s0) 
	lw	a0, 148(a0) 
	sw	a0, -20(s0) 
	j	scheduler_LBB0_6 
scheduler_LBB0_8:
	lw	a0, -16(s0) 
	lw	a1, -20(s0) 
	sw	a0, 148(a1) 
	lw	a0, -12(s0) 
	lw	a0, 0(a0) 
	lw	a1, -16(s0) 
	sw	a0, 148(a1) 
	j	scheduler_LBB0_9 
scheduler_LBB0_9:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
scheduler_Lfunc_end0:
	#	-- End function 
dequeue:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -16(s0) 
	lw	a0, -16(s0) 
	lw	a0, 0(a0) 
	bnez	a0, scheduler_LBB1_2 
	j	scheduler_LBB1_1 
scheduler_LBB1_1:
	li	a0, 0 
	sw	a0, -12(s0) 
	j	scheduler_LBB1_9 
scheduler_LBB1_2:
	lw	a0, -16(s0) 
	lw	a0, 0(a0) 
	sw	a0, -20(s0) 
	lw	a1, -20(s0) 
	lw	a0, 148(a1) 
	bne	a0, a1, scheduler_LBB1_4 
	j	scheduler_LBB1_3 
scheduler_LBB1_3:
	lw	a1, -16(s0) 
	li	a0, 0 
	sw	a0, 0(a1) 
	j	scheduler_LBB1_8 
scheduler_LBB1_4:
	lw	a0, -20(s0) 
	sw	a0, -24(s0) 
	j	scheduler_LBB1_5 
scheduler_LBB1_5:
	lw	a0, -24(s0) 
	lw	a0, 148(a0) 
	lw	a1, -20(s0) 
	beq	a0, a1, scheduler_LBB1_7 
	j	scheduler_LBB1_6 
scheduler_LBB1_6:
	lw	a0, -24(s0) 
	lw	a0, 148(a0) 
	sw	a0, -24(s0) 
	j	scheduler_LBB1_5 
scheduler_LBB1_7:
	lw	a0, -20(s0) 
	lw	a0, 148(a0) 
	lw	a1, -16(s0) 
	sw	a0, 0(a1) 
	lw	a0, -16(s0) 
	lw	a0, 0(a0) 
	lw	a1, -24(s0) 
	sw	a0, 148(a1) 
	j	scheduler_LBB1_8 
scheduler_LBB1_8:
	lw	a1, -20(s0) 
	li	a0, 0 
	sw	a0, 148(a1) 
	lw	a0, -20(s0) 
	sw	a0, -12(s0) 
	j	scheduler_LBB1_9 
scheduler_LBB1_9:
	lw	a0, -12(s0) 
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
scheduler_Lfunc_end1:
	#	-- End function 
scheduler_init:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL1:
	auipc	a1, %hi(%pcrel(ready_queue))
	li	a0, 0 
	sw	a0, %lo(%larel(ready_queue,scheduler_autoL1))(a1)
scheduler_autoL2:
	auipc	a1, %hi(%pcrel(current_process))
	sw	a0, %lo(%larel(current_process,scheduler_autoL2))(a1)
scheduler_autoL3:
	auipc	a2, %hi(%pcrel(next_pid))
	li	a1, 1 
	sw	a1, %lo(%larel(next_pid,scheduler_autoL3))(a2)
scheduler_autoL4:
	auipc	a1, %hi(%pcrel(scheduler_active))
	sw	a0, %lo(%larel(scheduler_active,scheduler_autoL4))(a1)
scheduler_autoL5:
	auipc	a0, %hi(%pcrel(time_quantum))
	lw	a0, %lo(%larel(time_quantum,scheduler_autoL5))(a0)
	bnez	a0, scheduler_LBB2_2 
	j	scheduler_LBB2_1 
scheduler_LBB2_1:
scheduler_autoL6:
	auipc	a1, %hi(%pcrel(time_quantum))
	lui	a0, 2 
	addi	a0, a0, 1808 
	sw	a0, %lo(%larel(time_quantum,scheduler_autoL6))(a1)
	j	scheduler_LBB2_2 
scheduler_LBB2_2:
scheduler_autoL7:
	auipc	a1, %hi(%pcrel(saved_user_pc))
	li	a0, 0 
	sw	a0, %lo(%larel(saved_user_pc,scheduler_autoL7))(a1)
scheduler_autoL8:
	auipc	a1, %hi(%pcrel(saved_user_sp))
	sw	a0, %lo(%larel(saved_user_sp,scheduler_autoL8))(a1)
scheduler_autoL9:
	auipc	a1, %hi(%pcrel(saved_user_fp))
	sw	a0, %lo(%larel(saved_user_fp,scheduler_autoL9))(a1)
	sw	a0, -12(s0) 
	j	scheduler_LBB2_3 
scheduler_LBB2_3:
	lw	a1, -12(s0) 
	li	a0, 31 
	blt	a0, a1, scheduler_LBB2_6 
	j	scheduler_LBB2_4 
scheduler_LBB2_4:
	lw	a0, -12(s0) 
	slli	a1, a0, 2 
scheduler_autoL10:
	auipc	a0, %hi(%pcrel(saved_registers))
	addi	a0, a0, %lo(%larel(saved_registers,scheduler_autoL10))
	add	a1, a0, a1 
	li	a0, 0 
	sw	a0, 0(a1) 
	j	scheduler_LBB2_5 
scheduler_LBB2_5:
	lw	a0, -12(s0) 
	addi	a0, a0, 1 
	sw	a0, -12(s0) 
	j	scheduler_LBB2_3 
scheduler_LBB2_6:
scheduler_autoL11:
	auipc	a0, %hi(%pcrel(scheduler_L.str.1))
	addi	a0, a0, %lo(%larel(scheduler_L.str.1,scheduler_autoL11))
	call	print 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end2:
	#	-- End function 
scheduler_add_process:
	#	%bb.0: 
	addi	sp, sp, -32 
	sw	ra, 28(sp) # 4-byte Folded Spill 
	sw	s0, 24(sp) # 4-byte Folded Spill 
	addi	s0, sp, 32 
	sw	a0, -12(s0) 
	sw	a1, -16(s0) 
	sw	a2, -20(s0) 
	li	a0, 152 
	call	malloc 
	sw	a0, -24(s0) 
	lw	a0, -24(s0) 
	bnez	a0, scheduler_LBB3_2 
	j	scheduler_LBB3_1 
scheduler_LBB3_1:
scheduler_autoL12:
	auipc	a0, %hi(%pcrel(scheduler_L.str.2))
	addi	a0, a0, %lo(%larel(scheduler_L.str.2,scheduler_autoL12))
	call	print 
	j	scheduler_LBB3_7 
scheduler_LBB3_2:
	lw	a0, -24(s0) 
	sw	a0, -28(s0) 
	li	a0, 0 
	sw	a0, -32(s0) 
	j	scheduler_LBB3_3 
scheduler_LBB3_3:
	lw	a1, -32(s0) 
	li	a0, 151 
	bltu	a0, a1, scheduler_LBB3_6 
	j	scheduler_LBB3_4 
scheduler_LBB3_4:
	lw	a0, -28(s0) 
	lw	a1, -32(s0) 
	add	a1, a0, a1 
	li	a0, 0 
	sb	a0, 0(a1) 
	j	scheduler_LBB3_5 
scheduler_LBB3_5:
	lw	a0, -32(s0) 
	addi	a0, a0, 1 
	sw	a0, -32(s0) 
	j	scheduler_LBB3_3 
scheduler_LBB3_6:
scheduler_autoL13:
	auipc	a2, %hi(%pcrel(next_pid))
	lw	a0, %lo(%larel(next_pid,scheduler_autoL13))(a2)
	addi	a1, a0, 1 
	sw	a1, %lo(%larel(next_pid,scheduler_autoL13))(a2)
	lw	a1, -24(s0) 
	sw	a0, 0(a1) 
	lw	a1, -24(s0) 
	li	a0, 0 
	sw	a0, 4(a1) 
	lw	a1, -12(s0) 
	lw	a2, -24(s0) 
	sw	a1, 136(a2) 
	lw	a1, -16(s0) 
	lw	a2, -24(s0) 
	sw	a1, 140(a2) 
	lw	a1, -20(s0) 
	lw	a2, -24(s0) 
	sw	a1, 144(a2) 
	lw	a1, -24(s0) 
	sw	a0, 148(a1) 
	lw	a1, -24(s0) 
scheduler_autoL14:
	auipc	a0, %hi(%pcrel(ready_queue))
	addi	a0, a0, %lo(%larel(ready_queue,scheduler_autoL14))
	call	enqueue 
	j	scheduler_LBB3_7 
scheduler_LBB3_7:
	lw	ra, 28(sp) # 4-byte Folded Reload 
	lw	s0, 24(sp) # 4-byte Folded Reload 
	addi	sp, sp, 32 
	ret	
scheduler_Lfunc_end3:
	#	-- End function 
scheduler_get_current_process:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL15:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL15))(a0)
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end4:
	#	-- End function 
scheduler_get_next_process:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL16:
	auipc	a0, %hi(%pcrel(ready_queue))
	lw	a0, %lo(%larel(ready_queue,scheduler_autoL16))(a0)
	bnez	a0, scheduler_LBB5_2 
	j	scheduler_LBB5_1 
scheduler_LBB5_1:
	li	a0, 0 
	sw	a0, -12(s0) 
	j	scheduler_LBB5_6 
scheduler_LBB5_2:
scheduler_autoL17:
	auipc	a0, %hi(%pcrel(ready_queue))
	addi	a0, a0, %lo(%larel(ready_queue,scheduler_autoL17))
	call	dequeue 
	sw	a0, -16(s0) 
	lw	a1, -16(s0) 
	li	a0, 1 
	sw	a0, 4(a1) 
scheduler_autoL18:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL18))(a0)
	beqz	a0, scheduler_LBB5_5 
	j	scheduler_LBB5_3 
scheduler_LBB5_3:
scheduler_autoL19:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL19))(a0)
	lw	a0, 4(a0) 
	li	a1, 1 
	bne	a0, a1, scheduler_LBB5_5 
	j	scheduler_LBB5_4 
scheduler_LBB5_4:
scheduler_autoL20:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a2, %lo(%larel(current_process,scheduler_autoL20))(a0)
	li	a1, 0 
	sw	a1, 4(a2) 
	lw	a1, %lo(%larel(current_process,scheduler_autoL20))(a0)
scheduler_autoL21:
	auipc	a0, %hi(%pcrel(ready_queue))
	addi	a0, a0, %lo(%larel(ready_queue,scheduler_autoL21))
	call	enqueue 
	j	scheduler_LBB5_5 
scheduler_LBB5_5:
	lw	a0, -16(s0) 
	sw	a0, -12(s0) 
	j	scheduler_LBB5_6 
scheduler_LBB5_6:
	lw	a0, -12(s0) 
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end5:
	#	-- End function 
save_context:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL22:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL22))(a0)
	bnez	a0, scheduler_LBB6_2 
	j	scheduler_LBB6_1 
scheduler_LBB6_1:
	j	scheduler_LBB6_6 
scheduler_LBB6_2:
scheduler_autoL23:
	auipc	a0, %hi(%pcrel(saved_user_pc))
	lw	a0, %lo(%larel(saved_user_pc,scheduler_autoL23))(a0)
scheduler_autoL24:
	auipc	a1, %hi(%pcrel(current_process))
	lw	a2, %lo(%larel(current_process,scheduler_autoL24))(a1)
	sw	a0, 136(a2) 
scheduler_autoL25:
	auipc	a0, %hi(%pcrel(saved_user_sp))
	lw	a0, %lo(%larel(saved_user_sp,scheduler_autoL25))(a0)
	lw	a2, %lo(%larel(current_process,scheduler_autoL24))(a1)
	sw	a0, 140(a2) 
scheduler_autoL26:
	auipc	a0, %hi(%pcrel(saved_user_fp))
	lw	a0, %lo(%larel(saved_user_fp,scheduler_autoL26))(a0)
	lw	a1, %lo(%larel(current_process,scheduler_autoL24))(a1)
	sw	a0, 144(a1) 
	li	a0, 0 
	sw	a0, -12(s0) 
	j	scheduler_LBB6_3 
scheduler_LBB6_3:
	lw	a1, -12(s0) 
	li	a0, 31 
	blt	a0, a1, scheduler_LBB6_6 
	j	scheduler_LBB6_4 
scheduler_LBB6_4:
	lw	a0, -12(s0) 
	slli	a2, a0, 2 
scheduler_autoL27:
	auipc	a0, %hi(%pcrel(saved_registers))
	addi	a0, a0, %lo(%larel(saved_registers,scheduler_autoL27))
	add	a0, a0, a2 
	lw	a0, 0(a0) 
scheduler_autoL28:
	auipc	a1, %hi(%pcrel(current_process))
	lw	a1, %lo(%larel(current_process,scheduler_autoL28))(a1)
	add	a1, a1, a2 
	sw	a0, 8(a1) 
	j	scheduler_LBB6_5 
scheduler_LBB6_5:
	lw	a0, -12(s0) 
	addi	a0, a0, 1 
	sw	a0, -12(s0) 
	j	scheduler_LBB6_3 
scheduler_LBB6_6:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end6:
	#	-- End function 
restore_context:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, scheduler_LBB7_2 
	j	scheduler_LBB7_1 
scheduler_LBB7_1:
	j	scheduler_LBB7_6 
scheduler_LBB7_2:
	lw	a0, -12(s0) 
	lw	a0, 136(a0) 
scheduler_autoL29:
	auipc	a1, %hi(%pcrel(saved_user_pc))
	sw	a0, %lo(%larel(saved_user_pc,scheduler_autoL29))(a1)
	lw	a0, -12(s0) 
	lw	a0, 140(a0) 
scheduler_autoL30:
	auipc	a1, %hi(%pcrel(saved_user_sp))
	sw	a0, %lo(%larel(saved_user_sp,scheduler_autoL30))(a1)
	lw	a0, -12(s0) 
	lw	a0, 144(a0) 
scheduler_autoL31:
	auipc	a1, %hi(%pcrel(saved_user_fp))
	sw	a0, %lo(%larel(saved_user_fp,scheduler_autoL31))(a1)
	li	a0, 0 
	sw	a0, -16(s0) 
	j	scheduler_LBB7_3 
scheduler_LBB7_3:
	lw	a1, -16(s0) 
	li	a0, 31 
	blt	a0, a1, scheduler_LBB7_6 
	j	scheduler_LBB7_4 
scheduler_LBB7_4:
	lw	a0, -12(s0) 
	lw	a1, -16(s0) 
	slli	a2, a1, 2 
	add	a0, a0, a2 
	lw	a0, 8(a0) 
scheduler_autoL32:
	auipc	a1, %hi(%pcrel(saved_registers))
	addi	a1, a1, %lo(%larel(saved_registers,scheduler_autoL32))
	add	a1, a1, a2 
	sw	a0, 0(a1) 
	j	scheduler_LBB7_5 
scheduler_LBB7_5:
	lw	a0, -16(s0) 
	addi	a0, a0, 1 
	sw	a0, -16(s0) 
	j	scheduler_LBB7_3 
scheduler_LBB7_6:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end7:
	#	-- End function 
context_switch:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
	call	save_context 
	call	scheduler_get_next_process 
	sw	a0, -12(s0) 
	lw	a0, -12(s0) 
	bnez	a0, scheduler_LBB8_2 
	j	scheduler_LBB8_1 
scheduler_LBB8_1:
	j	scheduler_LBB8_3 
scheduler_LBB8_2:
	lw	a1, -12(s0) 
scheduler_autoL33:
	auipc	a0, %hi(%pcrel(current_process))
	sw	a1, %lo(%larel(current_process,scheduler_autoL33))(a0)
	lw	a0, %lo(%larel(current_process,scheduler_autoL33))(a0)
	call	restore_context 
	j	scheduler_LBB8_3 
scheduler_LBB8_3:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end8:
	#	-- End function 
scheduler_handle_alarm:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL34:
	auipc	a0, %hi(%pcrel(ready_queue))
	lw	a0, %lo(%larel(ready_queue,scheduler_autoL34))(a0)
	bnez	a0, scheduler_LBB9_3 
	j	scheduler_LBB9_1 
scheduler_LBB9_1:
scheduler_autoL35:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL35))(a0)
	bnez	a0, scheduler_LBB9_3 
	j	scheduler_LBB9_2 
scheduler_LBB9_2:
scheduler_autoL36:
	auipc	a0, %hi(%pcrel(scheduler_L.str.3))
	addi	a0, a0, %lo(%larel(scheduler_L.str.3,scheduler_autoL36))
	call	print 
	j	scheduler_LBB9_6 
scheduler_LBB9_3:
scheduler_autoL37:
	auipc	a0, %hi(%pcrel(scheduler_active))
	lw	a0, %lo(%larel(scheduler_active,scheduler_autoL37))(a0)
	bnez	a0, scheduler_LBB9_5 
	j	scheduler_LBB9_4 
scheduler_LBB9_4:
	j	scheduler_LBB9_6 
scheduler_LBB9_5:
	call	context_switch 
	j	scheduler_LBB9_6 
scheduler_LBB9_6:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end9:
	#	-- End function 
scheduler_terminate_current:
	#	%bb.0: 
	addi	sp, sp, -16 
	sw	ra, 12(sp) # 4-byte Folded Spill 
	sw	s0, 8(sp) # 4-byte Folded Spill 
	addi	s0, sp, 16 
scheduler_autoL38:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a0, %lo(%larel(current_process,scheduler_autoL38))(a0)
	bnez	a0, scheduler_LBB10_2 
	j	scheduler_LBB10_1 
scheduler_LBB10_1:
	j	scheduler_LBB10_6 
scheduler_LBB10_2:
scheduler_autoL39:
	auipc	a0, %hi(%pcrel(current_process))
	lw	a2, %lo(%larel(current_process,scheduler_autoL39))(a0)
	li	a1, 3 
	sw	a1, 4(a2) 
	lw	a0, %lo(%larel(current_process,scheduler_autoL39))(a0)
	sw	a0, -12(s0) 
	call	scheduler_get_next_process 
	sw	a0, -16(s0) 
	lw	a0, -16(s0) 
	bnez	a0, scheduler_LBB10_4 
	j	scheduler_LBB10_3 
scheduler_LBB10_3:
scheduler_autoL40:
	auipc	a1, %hi(%pcrel(current_process))
	li	a0, 0 
	sw	a0, %lo(%larel(current_process,scheduler_autoL40))(a1)
	j	scheduler_LBB10_5 
scheduler_LBB10_4:
	lw	a1, -16(s0) 
scheduler_autoL41:
	auipc	a0, %hi(%pcrel(current_process))
	sw	a1, %lo(%larel(current_process,scheduler_autoL41))(a0)
	lw	a0, %lo(%larel(current_process,scheduler_autoL41))(a0)
	call	restore_context 
	j	scheduler_LBB10_5 
scheduler_LBB10_5:
	lw	a0, -12(s0) 
	call	free 
	j	scheduler_LBB10_6 
scheduler_LBB10_6:
	lw	ra, 12(sp) # 4-byte Folded Reload 
	lw	s0, 8(sp) # 4-byte Folded Reload 
	addi	sp, sp, 16 
	ret	
scheduler_Lfunc_end10:
	#	-- End function 
scheduler_L.str:
	.Text
	.asciz	"Invalid queue or process\n"
ready_queue:
	.Numeric
	.word	0
current_process:
	.word	0
next_pid:
	.word	1                               # 0x1
scheduler_L.str.1:
	.Text
	.asciz	"Scheduler initialized successfully.\n"
scheduler_L.str.2:
	.asciz	"Failed to allocate PCB\n"
scheduler_L.str.3:
	.asciz	"Alarm received but no processes to schedule\n"
