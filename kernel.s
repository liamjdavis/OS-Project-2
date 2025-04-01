	.text
	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0"
	.file	"kernel.c"
	.globl	int_to_hex                      # -- Begin function int_to_hex
	.p2align	2
	.type	int_to_hex,@function
int_to_hex:                             # @int_to_hex
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	sw	a0, -12(s0)
	sw	a1, -16(s0)
	li	a0, 28
	sw	a0, -20(s0)
	j	kernel_LBB0_1
kernel_LBB0_1:                                # =>This Innerkernel_Loop Header: Depth=1
	lw	a0, -20(s0)
	bltz	a0, kernel_LBB0_4
	j	kernel_LBB0_2
kernel_LBB0_2:                                #   inkernel_Loop: Header=BB0_1 Depth=1
	lw	a0, -12(s0)
	lw	a1, -20(s0)
	srl	a0, a0, a1
	andi	a0, a0, 15
	sw	a0, -24(s0)
	lw	a1, -24(s0)
	lui	a0, %hi(hex_digits)
	addi	a0, a0, %lo(hex_digits)
	add	a0, a0, a1
	lbu	a0, 0(a0)
	lw	a1, -16(s0)
	addi	a2, a1, 1
	sw	a2, -16(s0)
	sb	a0, 0(a1)
	j	kernel_LBB0_3
kernel_LBB0_3:                                #   inkernel_Loop: Header=BB0_1 Depth=1
	lw	a0, -20(s0)
	addi	a0, a0, -4
	sw	a0, -20(s0)
	j	kernel_LBB0_1
kernel_LBB0_4:
	lw	a1, -16(s0)
	li	a0, 0
	sb	a0, 0(a1)
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
kernel_Lfunc_end0:
	.size	int_to_hex, kernel_Lfunc_end0-int_to_hex
                                        # -- End function
	.globl	run_programs                    # -- Begin function run_programs
	.p2align	2
	.type	run_programs,@function
run_programs:                           # @run_programs
# %bb.0:
	addi	sp, sp, -32
	sw	ra, 28(sp)                      # 4-byte Folded Spill
	sw	s0, 24(sp)                      # 4-byte Folded Spill
	addi	s0, sp, 32
	lui	a0, %hi(kernel_L.str)
	addi	a0, a0, %lo(kernel_L.str)
	call	print
	lui	a0, %hi(run_programs.next_program_ROM)
	sw	a0, -28(s0)                     # 4-byte Folded Spill
	lw	a0, %lo(run_programs.next_program_ROM)(a0)
	addi	a1, s0, -17
	sw	a1, -32(s0)                     # 4-byte Folded Spill
	call	int_to_hex
	lw	a0, -32(s0)                     # 4-byte Folded Reload
	call	print
	lui	a0, %hi(kernel_L.str.1)
	addi	a0, a0, %lo(kernel_L.str.1)
	call	print
	lw	a3, -28(s0)                     # 4-byte Folded Reload
	lui	a0, %hi(ROM_device_code)
	lw	a0, %lo(ROM_device_code)(a0)
	lw	a1, %lo(run_programs.next_program_ROM)(a3)
	addi	a2, a1, 1
	sw	a2, %lo(run_programs.next_program_ROM)(a3)
	call	find_device
	sw	a0, -24(s0)
	lw	a0, -24(s0)
	bnez	a0, kernel_LBB1_2
	j	kernel_LBB1_1
kernel_LBB1_1:
	j	kernel_LBB1_3
kernel_LBB1_2:
	lui	a0, %hi(kernel_L.str.2)
	addi	a0, a0, %lo(kernel_L.str.2)
	call	print
	lw	a0, -24(s0)
	lw	a0, 4(a0)
	lui	a2, %hi(DMA_portal_ptr)
	lw	a1, %lo(DMA_portal_ptr)(a2)
	sw	a0, 0(a1)
	lui	a0, %hi(kernel_limit)
	lw	a1, %lo(kernel_limit)(a0)
	lw	a3, %lo(DMA_portal_ptr)(a2)
	sw	a1, 4(a3)
	lw	a3, -24(s0)
	lw	a1, 8(a3)
	lw	a3, 4(a3)
	sub	a1, a1, a3
	lw	a2, %lo(DMA_portal_ptr)(a2)
	sw	a1, 8(a2)
	lw	a0, %lo(kernel_limit)(a0)
	call	userspace_jump
	j	kernel_LBB1_3
kernel_LBB1_3:
	lw	ra, 28(sp)                      # 4-byte Folded Reload
	lw	s0, 24(sp)                      # 4-byte Folded Reload
	addi	sp, sp, 32
	ret
kernel_Lfunc_end1:
	.size	run_programs, kernel_Lfunc_end1-run_programs
                                        # -- End function
	.type	hex_digits,@object              # @hex_digits
	.data
hex_digits:
	.ascii	"0123456789abcdef"
	.size	hex_digits, 16

	.type	run_programs.next_program_ROM,@object # @run_programs.next_program_ROM
	.section	.sdata,"aw",@progbits
	.p2align	2, 0x0
run_programs.next_program_ROM:
	.word	3                               # 0x3
	.size	run_programs.next_program_ROM, 4

	.type	kernel_L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
kernel_L.str:
	.asciz	"Searching for ROM #"
	.size	kernel_L.str, 20

	.type	kernel_L.str.1,@object                # @.str.1
kernel_L.str.1:
	.asciz	"\n"
	.size	kernel_L.str.1, 2

	.type	kernel_L.str.2,@object                # @.str.2
kernel_L.str.2:
	.asciz	"Running program...\n"
	.size	kernel_L.str.2, 20

	.ident	"Ubuntu clang version 18.1.3 (1ubuntu1)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym int_to_hex
	.addrsig_sym print
	.addrsig_sym find_device
	.addrsig_sym userspace_jump
	.addrsig_sym hex_digits
	.addrsig_sym run_programs.next_program_ROM
	.addrsig_sym ROM_device_code
	.addrsig_sym DMA_portal_ptr
	.addrsig_sym kernel_limit
