	.file	"mont_utils.c"
	.text
	.globl	ADD
	.type	ADD, @function
ADD:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -24(%rbp)
	movl	%esi, %eax
	movl	%edx, -32(%rbp)
	movb	%al, -28(%rbp)
	movl	$-1, -4(%rbp)
	movl	$0, -12(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L2
.L5:
	movl	-4(%rbp), %eax
	subl	-32(%rbp), %eax
	movl	%eax, %edx
	movzbl	-28(%rbp), %eax
	leaq	0(,%rax,4), %rcx
	movq	-24(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	cmpl	%eax, %edx
	jnb	.L3
	movzbl	-28(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-32(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -12(%rbp)
	movl	$1, -8(%rbp)
	jmp	.L4
.L3:
	movzbl	-28(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movl	-32(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -12(%rbp)
	movl	$0, -8(%rbp)
.L4:
	movl	-8(%rbp), %eax
	movl	%eax, -32(%rbp)
	movzbl	-28(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	movq	-24(%rbp), %rax
	addq	%rax, %rdx
	movl	-12(%rbp), %eax
	movl	%eax, (%rdx)
	addb	$1, -28(%rbp)
.L2:
	cmpl	$0, -32(%rbp)
	jne	.L5
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	ADD, .-ADD
	.globl	SUB_COND
	.type	SUB_COND, @function
SUB_COND:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movl	%edx, -68(%rbp)
	movq	%rcx, -80(%rbp)
	movq	%rsp, %rax
	movq	%rax, %rsi
	movl	$0, -12(%rbp)
	movl	$0, -20(%rbp)
	movl	-68(%rbp), %eax
	addl	$1, %eax
	movl	%eax, %edx
	subq	$1, %rdx
	movq	%rdx, -32(%rbp)
	movl	%eax, %edx
	movq	%rdx, %r10
	movl	$0, %r11d
	movl	%eax, %edx
	movq	%rdx, %r8
	movl	$0, %r9d
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %edi
	movl	$0, %edx
	divq	%rdi
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$3, %rax
	shrq	$2, %rax
	salq	$2, %rax
	movq	%rax, -40(%rbp)
	movl	$0, -8(%rbp)
	jmp	.L7
.L8:
	movq	-40(%rbp), %rax
	movl	-8(%rbp), %edx
	movl	$0, (%rax,%rdx,4)
	addl	$1, -8(%rbp)
.L7:
	movl	-8(%rbp), %eax
	cmpl	-68(%rbp), %eax
	jbe	.L8
	movb	$0, -2(%rbp)
	jmp	.L9
.L12:
	movzbl	-2(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %edx
	movzbl	-2(%rbp), %eax
	leaq	0(,%rax,4), %rcx
	movq	-64(%rbp), %rax
	addq	%rcx, %rax
	movl	(%rax), %eax
	subl	%eax, %edx
	movl	%edx, %eax
	subl	-12(%rbp), %eax
	movl	%eax, -20(%rbp)
	movzbl	-2(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movl	(%rax), %eax
	movzbl	-2(%rbp), %edx
	leaq	0(,%rdx,4), %rcx
	movq	-64(%rbp), %rdx
	addq	%rcx, %rdx
	movl	(%rdx), %ecx
	movl	-12(%rbp), %edx
	addl	%ecx, %edx
	cmpl	%edx, %eax
	jb	.L10
	movl	$0, -12(%rbp)
	jmp	.L11
.L10:
	movl	$1, -12(%rbp)
.L11:
	movzbl	-2(%rbp), %edx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movl	-20(%rbp), %ecx
	movl	%ecx, (%rax,%rdx,4)
	movzbl	-2(%rbp), %eax
	addl	$1, %eax
	movb	%al, -2(%rbp)
.L9:
	movzbl	-2(%rbp), %eax
	cmpl	%eax, -68(%rbp)
	jnb	.L12
	cmpl	$0, -12(%rbp)
	jne	.L13
	movb	$0, -1(%rbp)
	jmp	.L14
.L15:
	movzbl	-1(%rbp), %edx
	movzbl	-1(%rbp), %eax
	leaq	0(,%rax,4), %rcx
	movq	-80(%rbp), %rax
	addq	%rax, %rcx
	movq	-40(%rbp), %rax
	movslq	%edx, %rdx
	movl	(%rax,%rdx,4), %eax
	movl	%eax, (%rcx)
	movzbl	-1(%rbp), %eax
	addl	$1, %eax
	movb	%al, -1(%rbp)
.L14:
	movzbl	-1(%rbp), %eax
	cmpl	%eax, -68(%rbp)
	ja	.L15
	jmp	.L16
.L13:
	movb	$0, -13(%rbp)
	jmp	.L17
.L18:
	movzbl	-13(%rbp), %eax
	leaq	0(,%rax,4), %rdx
	movq	-56(%rbp), %rax
	addq	%rdx, %rax
	movzbl	-13(%rbp), %edx
	leaq	0(,%rdx,4), %rcx
	movq	-80(%rbp), %rdx
	addq	%rcx, %rdx
	movl	(%rax), %eax
	movl	%eax, (%rdx)
	movzbl	-13(%rbp), %eax
	addl	$1, %eax
	movb	%al, -13(%rbp)
.L17:
	movzbl	-13(%rbp), %eax
	cmpl	%eax, -68(%rbp)
	ja	.L18
.L16:
	movq	%rsi, %rsp
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	SUB_COND, .-SUB_COND
	.globl	_32mul
	.type	_32mul, @function
_32mul:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, -52(%rbp)
	movl	%esi, -56(%rbp)
	movq	%rdx, -64(%rbp)
	movl	-52(%rbp), %eax
	movzwl	%ax, %eax
	movl	%eax, -4(%rbp)
	movl	-52(%rbp), %eax
	shrl	$16, %eax
	movl	%eax, -8(%rbp)
	movl	-56(%rbp), %eax
	movzwl	%ax, %eax
	movl	%eax, -12(%rbp)
	movl	-56(%rbp), %eax
	shrl	$16, %eax
	movl	%eax, -16(%rbp)
	movl	-8(%rbp), %eax
	imull	-16(%rbp), %eax
	movl	%eax, -20(%rbp)
	movl	-8(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, -24(%rbp)
	movl	-4(%rbp), %eax
	imull	-16(%rbp), %eax
	movl	%eax, -28(%rbp)
	movl	-4(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, -32(%rbp)
	movl	-24(%rbp), %eax
	movzwl	%ax, %edx
	movl	-28(%rbp), %eax
	movzwl	%ax, %eax
	addl	%eax, %edx
	movl	-32(%rbp), %eax
	shrl	$16, %eax
	addl	%edx, %eax
	shrl	$16, %eax
	movl	%eax, -36(%rbp)
	movl	-24(%rbp), %eax
	shrl	$16, %eax
	movl	%eax, %edx
	movl	-20(%rbp), %eax
	addl	%eax, %edx
	movl	-28(%rbp), %eax
	shrl	$16, %eax
	addl	%eax, %edx
	movl	-36(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -40(%rbp)
	movl	-24(%rbp), %eax
	sall	$16, %eax
	movl	%eax, %edx
	movl	-32(%rbp), %eax
	addl	%eax, %edx
	movl	-28(%rbp), %eax
	sall	$16, %eax
	addl	%edx, %eax
	movl	%eax, -44(%rbp)
	movq	-64(%rbp), %rax
	movl	-44(%rbp), %edx
	movl	%edx, (%rax)
	movq	-64(%rbp), %rax
	leaq	4(%rax), %rdx
	movl	-40(%rbp), %eax
	movl	%eax, (%rdx)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	_32mul, .-_32mul
	.ident	"GCC: (GNU) 8.3.1 20191121 (Red Hat 8.3.1-5)"
	.section	.note.GNU-stack,"",@progbits
