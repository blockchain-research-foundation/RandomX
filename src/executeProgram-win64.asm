;# Copyright (c) 2018 tevador
;#
;# This file is part of RandomX.
;#
;# RandomX is free software: you can redistribute it and/or modify
;# it under the terms of the GNU General Public License as published by
;# the Free Software Foundation, either version 3 of the License, or
;# (at your option) any later version.
;#
;# RandomX is distributed in the hope that it will be useful,
;# but WITHOUT ANY WARRANTY; without even the implied warranty of
;# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;# GNU General Public License for more details.
;#
;# You should have received a copy of the GNU General Public License
;# along with RandomX.  If not, see<http://www.gnu.org/licenses/>.

PUBLIC executeProgram

.code

executeProgram PROC
	; REGISTER ALLOCATION:
	; rax -> temporary
	; rbx -> MemoryRegisters& memory
	; rcx -> temporary
	; rdx -> temporary
	; rsi -> convertible_t& scratchpad
	; rdi -> "ic" (instruction counter)
	; rbp	-> beginning of VM stack
	; rsp -> end of VM stack
	; r8 	-> "r0"
	; r9 	-> "r1"
	; r10 -> "r2"
	; r11 -> "r3"
	; r12 -> "r4"
	; r13 -> "r5"
	; r14 -> "r6"
	; r15 -> "r7"
	; xmm0 -> temporary
	; xmm1 -> temporary
	; xmm2 -> "f2"
	; xmm3 -> "f3"
	; xmm4 -> "f4"
	; xmm5 -> "f5"
	; xmm6 -> "f6"
	; xmm7 -> "f7"
	; xmm8 -> "f0"
	; xmm9 -> "f1"
	; xmm10 -> absolute value mask

	; STACK STRUCTURE:
	;   |
	;   |
	;   | saved registers
	;   |
	;   v
	; [rbp] RegisterFile& registerFile
	;   |
	;   |
	;   | VM stack
	;   |
	;   v
	; [rsp] last element of VM stack

	; store callee-saved registers
	push rbx
	push rbp
	push rdi
	push rsi
	push r12
	push r13
	push r14
	push r15
	sub rsp, 80
	movdqu xmmword ptr [rsp+64], xmm6
	movdqu xmmword ptr [rsp+48], xmm7
	movdqu xmmword ptr [rsp+32], xmm8
	movdqu xmmword ptr [rsp+16], xmm9
	movdqu xmmword ptr [rsp+0], xmm10

	; function arguments
	push rcx				; RegisterFile& registerFile
	mov rbx, rdx		; MemoryRegisters& memory
	mov rsi, r8			; convertible_t& scratchpad
	push r9

	mov rbp, rsp			; beginning of VM stack
	mov rdi, 1048577	; number of VM instructions to execute + 1

	xorps xmm10, xmm10
	cmpeqpd xmm10, xmm10
	psrlq xmm10, 1		; mask for absolute value = 0x7fffffffffffffff7fffffffffffffff

	; reset rounding mode
	mov dword ptr [rsp-8], 40896
	ldmxcsr dword ptr [rsp-8]

	; load integer registers
	mov r8, qword ptr [rcx+0]
	mov r9, qword ptr [rcx+8]
	mov r10, qword ptr [rcx+16]
	mov r11, qword ptr [rcx+24]
	mov r12, qword ptr [rcx+32]
	mov r13, qword ptr [rcx+40]
	mov r14, qword ptr [rcx+48]
	mov r15, qword ptr [rcx+56]

	; load register f0 hi, lo
	xorps xmm8, xmm8
	cvtsi2sd xmm8, qword ptr [rcx+72]
	pslldq xmm8, 8
	cvtsi2sd xmm8, qword ptr [rcx+64]

	; load register f1 hi, lo
	xorps xmm9, xmm9
	cvtsi2sd xmm9, qword ptr [rcx+88]
	pslldq xmm9, 8
	cvtsi2sd xmm9, qword ptr [rcx+80]

	; load register f2 hi, lo
	xorps xmm2, xmm2
	cvtsi2sd xmm2, qword ptr [rcx+104]
	pslldq xmm2, 8
	cvtsi2sd xmm2, qword ptr [rcx+96]

	; load register f3 hi, lo
	xorps xmm3, xmm3
	cvtsi2sd xmm3, qword ptr [rcx+120]
	pslldq xmm3, 8
	cvtsi2sd xmm3, qword ptr [rcx+112]

	lea rcx, [rcx+64]

	; load register f4 hi, lo
	xorps xmm4, xmm4
	cvtsi2sd xmm4, qword ptr [rcx+72]
	pslldq xmm4, 8
	cvtsi2sd xmm4, qword ptr [rcx+64]

	; load register f5 hi, lo
	xorps xmm5, xmm5
	cvtsi2sd xmm5, qword ptr [rcx+88]
	pslldq xmm5, 8
	cvtsi2sd xmm5, qword ptr [rcx+80]

	; load register f6 hi, lo
	xorps xmm6, xmm6
	cvtsi2sd xmm6, qword ptr [rcx+104]
	pslldq xmm6, 8
	cvtsi2sd xmm6, qword ptr [rcx+96]

	; load register f7 hi, lo
	xorps xmm7, xmm7
	cvtsi2sd xmm7, qword ptr [rcx+120]
	pslldq xmm7, 8
	cvtsi2sd xmm7, qword ptr [rcx+112]

	; program body

	include program.inc

rx_finish:
	; unroll the stack
	mov rsp, rbp

	; save VM register values
	pop rcx
	pop rcx
	mov qword ptr [rcx+0], r8
	mov qword ptr [rcx+8], r9
	mov qword ptr [rcx+16], r10
	mov qword ptr [rcx+24], r11
	mov qword ptr [rcx+32], r12
	mov qword ptr [rcx+40], r13
	mov qword ptr [rcx+48], r14
	mov qword ptr [rcx+56], r15
	movdqa xmmword ptr [rcx+64], xmm8
	movdqa xmmword ptr [rcx+80], xmm9
	movdqa xmmword ptr [rcx+96], xmm2
	movdqa xmmword ptr [rcx+112], xmm3
	lea rcx, [rcx+64]
	movdqa xmmword ptr [rcx+64], xmm4
	movdqa xmmword ptr [rcx+80], xmm5
	movdqa xmmword ptr [rcx+96], xmm6
	movdqa xmmword ptr [rcx+112], xmm7

	; load callee-saved registers
	movdqu xmm10, xmmword ptr [rsp]
	movdqu xmm9, xmmword ptr [rsp+16]
	movdqu xmm8, xmmword ptr [rsp+32]
	movdqu xmm7, xmmword ptr [rsp+48]
	movdqu xmm6, xmmword ptr [rsp+64]
	add rsp, 80
	pop r15
	pop r14
	pop r13
	pop r12
	pop rsi
	pop rdi
	pop rbp
	pop rbx

	; return
	ret	0

rx_read_dataset:
	push r8
	push r9
	push r10
	push r11
	mov rdx, rbx
	movd qword ptr [rsp - 8], xmm1
	movd qword ptr [rsp - 16], xmm2
	sub rsp, 48
	call qword ptr [rbp]
	add rsp, 48
	movd xmm2, qword ptr [rsp - 16]
	movd xmm1, qword ptr [rsp - 8]
	pop r11
	pop r10
	pop r9
	pop r8
	ret 0

rx_read_dataset_r:
	mov edx, dword ptr [rbx]	; ma
	mov rax, qword ptr [rbx+8]	; dataset
	mov rax, qword ptr [rax+rdx]
	add dword ptr [rbx], 8
	xor ecx, dword ptr [rbx+4]	; mx
	mov dword ptr [rbx+4], ecx
	test ecx, 0FFF8h
	jne short rx_read_dataset_r_ret
	and ecx, -8
	mov dword ptr [rbx], ecx
	mov rdx, qword ptr [rbx+8]
	prefetcht0 byte ptr [rdx+rcx]
rx_read_dataset_r_ret:
	ret 0

rx_read_dataset_f:
	mov edx, dword ptr [rbx]	; ma
	mov rax, qword ptr [rbx+8]	; dataset
	cvtdq2pd xmm0, qword ptr [rax+rdx]
	add dword ptr [rbx], 8
	xor ecx, dword ptr [rbx+4]	; mx
	mov dword ptr [rbx+4], ecx
	test ecx, 0FFF8h
	jne short rx_read_dataset_f_ret
	and ecx, -8
	mov dword ptr [rbx], ecx
	prefetcht0 byte ptr [rax+rcx]
rx_read_dataset_f_ret:
	ret 0
executeProgram ENDP

END
