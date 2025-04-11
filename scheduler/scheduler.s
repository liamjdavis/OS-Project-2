	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0"
	.file	"scheduler.c"
	.globl	enqueue                         # -- Begin function enqueue
	.p2align	2
	.type	enqueue,@function
enqueue:                                # @enqueue
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
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
	lui	a0, %hi(scheduler_L.str)
	addi	a0, a0, %lo(scheduler_L.str)
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
scheduler_LBB0_6:                                # =>This Innerscheduler_Loop Header: Depth=1
	lw	a0, -20(s0)
	lw	a0, 148(a0)
	lw	a1, -12(s0)
	lw	a1, 0(a1)
	beq	a0, a1, scheduler_LBB0_8
	j	scheduler_LBB0_7
scheduler_LBB0_7:                                #   inscheduler_Loop: Header=BB0_6 Depth=1
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
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
scheduler_Lfunc_end0:
	.size	enqueue, scheduler_Lfunc_end0-enqueue
                                        # -- End function
	.globl	dequeue                         # -- Begin function dequeue
	.p2align	2
	.type	dequeue,@function
dequeue:                                # @dequeue
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
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
scheduler_LBB1_5:                                # =>This Innerscheduler_Loop Header: Depth=1
	lw	a0, -24(s0)
	lw	a0, 148(a0)
	lw	a1, -20(s0)
	beq	a0, a1, scheduler_LBB1_7
	j	scheduler_LBB1_6
scheduler_LBB1_6:                                #   inscheduler_Loop: Header=BB1_5 Depth=1
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
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
scheduler_Lfunc_end1:
	.size	dequeue, scheduler_Lfunc_end1-dequeue
                                        # -- End function
	.globl	scheduler_init                  # -- Begin function scheduler_init
	.p2align	2
	.type	scheduler_init,@function
scheduler_init:                         # @scheduler_init
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	lui	a1, %hi(ready_queue)
	li	a0, 0
	sw	a0, %lo(ready_queue)(a1)
	lui	a1, %hi(current_process)
	sw	a0, %lo(current_process)(a1)
	lui	a2, %hi(next_pid)
	li	a1, 1
	sw	a1, %lo(next_pid)(a2)
	lui	a1, %hi(scheduler_active)
	sw	a0, %lo(scheduler_active)(a1)
	lui	a0, %hi(time_quantum)
	lw	a0, %lo(time_quantum)(a0)
	bnez	a0, scheduler_LBB2_2
	j	scheduler_LBB2_1
scheduler_LBB2_1:
	lui	a1, %hi(time_quantum)
	lui	a0, 2
	addi	a0, a0, 1808
	sw	a0, %lo(time_quantum)(a1)
	j	scheduler_LBB2_2
scheduler_LBB2_2:
	lui	a1, %hi(saved_user_pc)
	li	a0, 0
	sw	a0, %lo(saved_user_pc)(a1)
	lui	a1, %hi(saved_user_sp)
	sw	a0, %lo(saved_user_sp)(a1)
	lui	a1, %hi(saved_user_fp)
	sw	a0, %lo(saved_user_fp)(a1)
	sw	a0, -12(s0)
	j	scheduler_LBB2_3
scheduler_LBB2_3:                                # =>This Innerscheduler_Loop Header: Depth=1
	lw	a1, -12(s0)
	li	a0, 31
	blt	a0, a1, scheduler_LBB2_6
	j	scheduler_LBB2_4
scheduler_LBB2_4:                                #   inscheduler_Loop: Header=BB2_3 Depth=1
	lw	a0, -12(s0)
	slli	a1, a0, 2
	lui	a0, %hi(saved_registers)
	addi	a0, a0, %lo(saved_registers)
	add	a1, a0, a1
	li	a0, 0
	sw	a0, 0(a1)
	j	scheduler_LBB2_5
scheduler_LBB2_5:                                #   inscheduler_Loop: Header=BB2_3 Depth=1
	lw	a0, -12(s0)
	addi	a0, a0, 1
	sw	a0, -12(s0)
	j	scheduler_LBB2_3
scheduler_LBB2_6:
	lui	a0, %hi(scheduler_L.str.1)
	addi	a0, a0, %lo(scheduler_L.str.1)
	call	print
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
scheduler_Lfunc_end2:
	.size	scheduler_init, scheduler_Lfunc_end2-scheduler_init
                                        # -- End function
	.globl	scheduler_add_process           # -- Begin function scheduler_add_process
	.p2align	2
	.type	scheduler_add_process,@function
scheduler_add_process:                  # @scheduler_add_process
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
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
	lui	a0, %hi(scheduler_L.str.2)
	addi	a0, a0, %lo(scheduler_L.str.2)
	call	print
	j	scheduler_LBB3_7
scheduler_LBB3_2:
	lw	a0, -24(s0)
	sw	a0, -28(s0)
	li	a0, 0
	sw	a0, -32(s0)
	j	scheduler_LBB3_3
scheduler_LBB3_3:                                # =>This Innerscheduler_Loop Header: Depth=1
	lw	a1, -32(s0)
	li	a0, 151
	bltu	a0, a1, scheduler_LBB3_6
	j	scheduler_LBB3_4
scheduler_LBB3_4:                                #   inscheduler_Loop: Header=BB3_3 Depth=1
	lw	a0, -28(s0)
	lw	a1, -32(s0)
	add	a1, a0, a1
	li	a0, 0
	sb	a0, 0(a1)
	j	scheduler_LBB3_5
scheduler_LBB3_5:                                #   inscheduler_Loop: Header=BB3_3 Depth=1
	lw	a0, -32(s0)
	addi	a0, a0, 1
	sw	a0, -32(s0)
	j	scheduler_LBB3_3
scheduler_LBB3_6:
	lui	a2, %hi(next_pid)
	lw	a0, %lo(next_pid)(a2)
	addi	a1, a0, 1
	sw	a1, %lo(next_pid)(a2)
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
	lui	a0, %hi(ready_queue)
	addi	a0, a0, %lo(ready_queue)
	call	enqueue
	j	scheduler_LBB3_7
scheduler_LBB3_7:
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
scheduler_Lfunc_end3:
	.size	scheduler_add_process, scheduler_Lfunc_end3-scheduler_add_process
                                        # -- End function
	.globl	scheduler_get_current_process   # -- Begin function scheduler_get_current_process
	.p2align	2
	.type	scheduler_get_current_process,@function
scheduler_get_current_process:          # @scheduler_get_current_process
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	lui	a0, %hi(current_process)
	lw	a0, %lo(current_process)(a0)
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
scheduler_Lfunc_end4:
	.size	scheduler_get_current_process, scheduler_Lfunc_end4-scheduler_get_current_process
                                        # -- End function
	.globl	scheduler_get_next_process      # -- Begin function scheduler_get_next_process
	.p2align	2
	.type	scheduler_get_next_process,@function
scheduler_get_next_process:             # @scheduler_get_next_process
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	lui	a0, %hi(ready_queue)
	lw	a0, %lo(ready_queue)(a0)
	bnez	a0, scheduler_LBB5_2
	j	scheduler_LBB5_1
scheduler_LBB5_1:
	li	a0, 0
	sw	a0, -12(s0)
	j	scheduler_LBB5_6
scheduler_LBB5_2:
	lui	a0, %hi(ready_queue)
	addi	a0, a0, %lo(ready_queue)
	call	dequeue
	sw	a0, -16(s0)
	lw	a1, -16(s0)
	li	a0, 1
	sw	a0, 4(a1)
	lui	a0, %hi(current_process)
	lw	a0, %lo(current_process)(a0)
	beqz	a0, scheduler_LBB5_5
	j	scheduler_LBB5_3
scheduler_LBB5_3:
	lui	a0, %hi(current_process)
	lw	a0, %lo(current_process)(a0)
	lw	a0, 4(a0)
	li	a1, 1
	bne	a0, a1, scheduler_LBB5_5
	j	scheduler_LBB5_4
scheduler_LBB5_4:
	lui	a0, %hi(current_process)
	lw	a2, %lo(current_process)(a0)
	li	a1, 0
	sw	a1, 4(a2)
	lw	a1, %lo(current_process)(a0)
	lui	a0, %hi(ready_queue)
	addi	a0, a0, %lo(ready_queue)
	call	enqueue
	j	scheduler_LBB5_5
scheduler_LBB5_5:
	lw	a0, -16(s0)
	sw	a0, -12(s0)
	j	scheduler_LBB5_6
scheduler_LBB5_6:
	lw	a0, -12(s0)
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
scheduler_Lfunc_end5:
	.size	scheduler_get_next_process, scheduler_Lfunc_end5-scheduler_get_next_process
                                        # -- End function
	.globl	save_context                    # -- Begin function save_context
	.p2align	2
	.type	save_context,@function
save_context:                           # @save_context
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	lui	a0, %hi(current_process)
	lw	a0, %lo(current_process)(a0)
	bnez	a0, scheduler_LBB6_2
	j	scheduler_LBB6_1
scheduler_LBB6_1:
	j	scheduler_LBB6_6
scheduler_LBB6_2:
	lui	a0, %hi(saved_user_pc)
	lw	a0, %lo(saved_user_pc)(a0)
	lui	a1, %hi(current_process)
	lw	a2, %lo(current_process)(a1)
	sw	a0, 136(a2)
	lui	a0, %hi(saved_user_sp)
	lw	a0, %lo(saved_user_sp)(a0)
	lw	a2, %lo(current_process)(a1)
	sw	a0, 140(a2)
	lui	a0, %hi(saved_user_fp)
	lw	a0, %lo(saved_user_fp)(a0)
	lw	a1, %lo(current_process)(a1)
	sw	a0, 144(a1)
	li	a0, 0
	sw	a0, -12(s0)
	j	scheduler_LBB6_3
scheduler_LBB6_3:                                # =>This Innerscheduler_Loop Header: Depth=1
	lw	a1, -12(s0)
	li	a0, 31
	blt	a0, a1, scheduler_LBB6_6
	j	scheduler_LBB6_4
scheduler_LBB6_4:                                #   inscheduler_Loop: Header=BB6_3 Depth=1
	lw	a0, -12(s0)
	slli	a2, a0, 2
	lui	a0, %hi(saved_registers)
	addi	a0, a0, %lo(saved_registers)
	add	a0, a0, a2
	lw	a0, 0(a0)
	lui	a1, %hi(current_process)
	lw	a1, %lo(current_process)(a1)
	add	a1, a1, a2
	sw	a0, 8(a1)
	j	scheduler_LBB6_5
scheduler_LBB6_5:                                #   inscheduler_Loop: Header=BB6_3 Depth=1
	lw	a0, -12(s0)
	addi	a0, a0, 1
	sw	a0, -12(s0)
	j	scheduler_LBB6_3
scheduler_LBB6_6:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
scheduler_Lfunc_end6:
	.size	save_context, scheduler_Lfunc_end6-save_context
                                        # -- End function
	.globl	restore_context                 # -- Begin function restore_context
	.p2align	2
	.type	restore_context,@function
restore_context:                        # @restore_context
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
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
	lui	a1, %hi(saved_user_pc)
	sw	a0, %lo(saved_user_pc)(a1)
	lw	a0, -12(s0)
	lw	a0, 140(a0)
	lui	a1, %hi(saved_user_sp)
	sw	a0, %lo(saved_user_sp)(a1)
	lw	a0, -12(s0)
	lw	a0, 144(a0)
	lui	a1, %hi(saved_user_fp)
	sw	a0, %lo(saved_user_fp)(a1)
	li	a0, 0
	sw	a0, -16(s0)
	j	scheduler_LBB7_3
scheduler_LBB7_3:                                # =>This Innerscheduler_Loop Header: Depth=1
	lw	a1, -16(s0)
	li	a0, 31
	blt	a0, a1, scheduler_LBB7_6
	j	scheduler_LBB7_4
scheduler_LBB7_4:                                #   inscheduler_Loop: Header=BB7_3 Depth=1
	lw	a0, -12(s0)
	lw	a1, -16(s0)
	slli	a2, a1, 2
	add	a0, a0, a2
	lw	a0, 8(a0)
	lui	a1, %hi(saved_registers)
	addi	a1, a1, %lo(saved_registers)
	add	a1, a1, a2
	sw	a0, 0(a1)
	j	scheduler_LBB7_5
scheduler_LBB7_5:                                #   inscheduler_Loop: Header=BB7_3 Depth=1
	lw	a0, -16(s0)
	addi	a0, a0, 1
	sw	a0, -16(s0)
	j	scheduler_LBB7_3
scheduler_LBB7_6:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
scheduler_Lfunc_end7:
	.size	restore_context, scheduler_Lfunc_end7-restore_context
                                        # -- End function
	.globl	context_switch                  # -- Begin function context_switch
	.p2align	2
	.type	context_switch,@function
context_switch:                         # @context_switch
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
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
	lui	a0, %hi(current_process)
	sw	a1, %lo(current_process)(a0)
	lw	a0, %lo(current_process)(a0)
	call	restore_context
	j	scheduler_LBB8_3
scheduler_LBB8_3:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
scheduler_Lfunc_end8:
	.size	context_switch, scheduler_Lfunc_end8-context_switch
                                        # -- End function
	.globl	scheduler_handle_alarm          # -- Begin function scheduler_handle_alarm
	.p2align	2
	.type	scheduler_handle_alarm,@function
scheduler_handle_alarm:                 # @scheduler_handle_alarm
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	lui	a0, %hi(ready_queue)
	lw	a0, %lo(ready_queue)(a0)
	bnez	a0, scheduler_LBB9_3
	j	scheduler_LBB9_1
scheduler_LBB9_1:
	lui	a0, %hi(current_process)
	lw	a0, %lo(current_process)(a0)
	bnez	a0, scheduler_LBB9_3
	j	scheduler_LBB9_2
scheduler_LBB9_2:
	lui	a0, %hi(scheduler_L.str.3)
	addi	a0, a0, %lo(scheduler_L.str.3)
	call	print
	j	scheduler_LBB9_6
scheduler_LBB9_3:
	lui	a0, %hi(scheduler_active)
	lw	a0, %lo(scheduler_active)(a0)
	bnez	a0, scheduler_LBB9_5
	j	scheduler_LBB9_4
scheduler_LBB9_4:
	j	scheduler_LBB9_6
scheduler_LBB9_5:
	call	context_switch
	j	scheduler_LBB9_6
scheduler_LBB9_6:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
scheduler_Lfunc_end9:
	.size	scheduler_handle_alarm, scheduler_Lfunc_end9-scheduler_handle_alarm
                                        # -- End function
	.globl	scheduler_terminate_current     # -- Begin function scheduler_terminate_current
	.p2align	2
	.type	scheduler_terminate_current,@function
scheduler_terminate_current:            # @scheduler_terminate_current
# %bb.0:
	addi	sp, sp, -16
	sw	ra, 12(sp)                      # 4-byte Folded Spill
	sw	s0, 8(sp)                       # 4-byte Folded Spill
	addi	s0, sp, 16
	lui	a0, %hi(current_process)
	lw	a0, %lo(current_process)(a0)
	bnez	a0, scheduler_LBB10_2
	j	scheduler_LBB10_1
scheduler_LBB10_1:
	j	scheduler_LBB10_6
scheduler_LBB10_2:
	lui	a0, %hi(current_process)
	lw	a2, %lo(current_process)(a0)
	li	a1, 3
	sw	a1, 4(a2)
	lw	a0, %lo(current_process)(a0)
	sw	a0, -12(s0)
	call	scheduler_get_next_process
	sw	a0, -16(s0)
	lw	a0, -16(s0)
	bnez	a0, scheduler_LBB10_4
	j	scheduler_LBB10_3
scheduler_LBB10_3:
	lui	a1, %hi(current_process)
	li	a0, 0
	sw	a0, %lo(current_process)(a1)
	j	scheduler_LBB10_5
scheduler_LBB10_4:
	lw	a1, -16(s0)
	lui	a0, %hi(current_process)
	sw	a1, %lo(current_process)(a0)
	lw	a0, %lo(current_process)(a0)
	call	restore_context
	j	scheduler_LBB10_5
scheduler_LBB10_5:
	lw	a0, -12(s0)
	call	free
	j	scheduler_LBB10_6
scheduler_LBB10_6:
	lw	ra, 12(sp)                      # 4-byte Folded Reload
	lw	s0, 8(sp)                       # 4-byte Folded Reload
	addi	sp, sp, 16
	ret
scheduler_Lfunc_end10:
	.size	scheduler_terminate_current, scheduler_Lfunc_end10-scheduler_terminate_current
                                        # -- End function
	.type	scheduler_L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
scheduler_L.str:
	.asciz	"Invalid queue or process\n"
	.size	scheduler_L.str, 26

	.type	ready_queue,@object             # @ready_queue
	.section	.sbss,"aw",@nobits
	.p2align	2, 0x0
ready_queue:
	.word	0
	.size	ready_queue, 4

	.type	current_process,@object         # @current_process
	.p2align	2, 0x0
current_process:
	.word	0
	.size	current_process, 4

	.type	next_pid,@object                # @next_pid
	.section	.sdata,"aw",@progbits
	.p2align	2, 0x0
next_pid:
	.word	1                               # 0x1
	.size	next_pid, 4

	.type	scheduler_L.str.1,@object                # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
scheduler_L.str.1:
	.asciz	"Scheduler initialized successfully.\n"
	.size	scheduler_L.str.1, 37

	.type	scheduler_L.str.2,@object                # @.str.2
scheduler_L.str.2:
	.asciz	"Failed to allocate PCB\n"
	.size	scheduler_L.str.2, 24

	.type	scheduler_L.str.3,@object                # @.str.3
scheduler_L.str.3:
	.asciz	"Alarm received but no processes to schedule\n"
	.size	scheduler_L.str.3, 45

	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym enqueue
	.addrsig_sym print
	.addrsig_sym dequeue
	.addrsig_sym malloc
	.addrsig_sym scheduler_get_next_process
	.addrsig_sym save_context
	.addrsig_sym restore_context
	.addrsig_sym context_switch
	.addrsig_sym free
	.addrsig_sym ready_queue
	.addrsig_sym current_process
	.addrsig_sym next_pid
	.addrsig_sym scheduler_active
	.addrsig_sym time_quantum
	.addrsig_sym saved_user_pc
	.addrsig_sym saved_user_sp
	.addrsig_sym saved_user_fp
	.addrsig_sym saved_registers
