	.file	"util.cpp"
	.text
	.globl	_Z29measure_one_block_access_timem
	.type	_Z29measure_one_block_access_timem, @function
_Z29measure_one_block_access_timem:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
#APP
# 28 "util.cpp" 1
	mov %rax, %r8
	lfence
	rdtsc
	mov %eax, %edi
	mov (%r8), %r8
	lfence
	rdtsc
	sub %edi, %eax
	
# 0 "" 2
#NO_APP
	movl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	_Z29measure_one_block_access_timem, .-_Z29measure_one_block_access_timem
	.globl	_Z13touch_addressm
	.type	_Z13touch_addressm, @function
_Z13touch_addressm:
.LFB14:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
#APP
# 41 "util.cpp" 1
	mov %rax, %r9
	mov %rax, %r9

# 0 "" 2
#NO_APP
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	_Z13touch_addressm, .-_Z13touch_addressm
	.ident	"GCC: (Debian 8.3.0-6) 8.3.0"
	.section	.note.GNU-stack,"",@progbits
