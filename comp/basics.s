	.data
		arthur: .asciz "monkey\n"
	.text
#============================================================
	#FUNCTIONS GENERIC
printnl:
	push $nl
	push $1
	call print
	ret

printWord:
	pop %rax
	pop %rbx
	push %rax

	mov $0xF000, %rcx
	and %rbx, %rcx
	shr $12, %rcx
	add $digs, %rcx
	push %rbx
	push %rcx
	push $1
	call print
	pop %rbx

	mov $0x0F00, %rcx
	and %rbx, %rcx
	shr $8, %rcx
	add $digs, %rcx
	push %rbx
	push %rcx
	push $1
	call print
	pop %rbx

	mov $0x00F0, %rcx
	and %rbx, %rcx
	shr $4, %rcx
	add $digs, %rcx
	push %rbx
	push %rcx
	push $1
	call print
	pop %rbx

	mov $0x000F, %rcx
	and %rbx, %rcx
	add $digs, %rcx
	push %rbx
	push %rcx
	push $1
	call print
	pop %rbx

	ret

printInt:
	pop %rax
	pop %rbx
	push %rax

	mov $0xFFFF000000000000, %rcx
	and %rbx, %rcx
	shr $48, %rcx
	push %rbx
	push %rcx
	call printWord
	pop %rbx

	mov $0x0000FFFF00000000, %rcx
	and %rbx, %rcx
	shr $32, %rcx
	push %rbx
	push %rcx
	call printWord
	pop %rbx

	mov $0x00000000FFFF0000, %rcx
	and %rbx, %rcx
	shr $16, %rcx
	push %rbx
	push %rcx
	call printWord
	pop %rbx

	mov $0x000000000000FFFF, %rcx
	and %rbx, %rcx
	shr $0, %rcx
	push %rbx
	push %rcx
	call printWord
	pop %rbx

	ret
strCpy:
	pop %rdx
	pop %rcx
	pop %rbx
	pop %rax
	push %rdx
	mov $0, %rdx
	mov $0, %rsi
	strCpyLoop:
		cmp %rsi, %rcx
		je strCpyEnd
		movb (%rax), %dl
		movb %dl, (%rbx)

		inc %rsi
		inc %rax
		inc %rbx

		jmp strCpyLoop
	strCpyEnd:
		ret


printOffStackByte:
	//stack: xxxx 00 00 55 55 12 34 56 78 xxxx -->
	//goes to the address, prints the byte.
	pop %rcx
	pop %rax
	//popb????
	push %rcx
	//gotta be careful with the stack.
	mov %al, %bl
	shr $4, %al
	shl $4, %bl
	shr $4, %bl
	//mask
	movzx %al, %rax
	movzx %bl, %rbx
	push %rax
	push $1
	call print
	push %rbx
	push $1
	call print
	ret

chrInStr:
	#pop %r8			#return addr

	#pop %rcx	#24	#str len
	#pop %rbx	#16	#str ptr
	#pop %rax	#8	#chr lirteral

	mov 24(%rsp), %rcx
	mov 16(%rsp), %rbx
	mov 8(%rsp), %rax
	
	mov $0, %rdx		#starts as 0
	mov $1, %r11		#r11 is = 1 always

	mov $0, %r9
	#dec %rcx
	dec %rbx
	#dec %r9
	chrInStrLoop:
		dec %rcx
		cmpb %al, (%rbx)		#compare chrs
			cmove %rcx, %r9		#satisfy jmp condition
			cmove %r11, %rdx	#make rdx=1
		inc %rcx
		inc %rbx
		inc %r9
		cmp %rcx, %r9			#check jump condition
			#inc %rbx		#increase ptr
			#inc %r9		#i++
			jne chrInStrLoop	#jump
	push %rdx
	#push %r8
	ret $24

cmpString:
	mov 32(%rsp), %rax #pointer 1
	mov 24(%rsp), %rbx #pointer 2
	mov 16(%rsp), %rcx #length
	mov 8(%rsp), %rdx #length

	cmp %rcx, %rdx
	je cmpStringexec
	movq $0, 32(%rsp)
	ret $24

	cmpStringexec:
	push %rax
	push %rbx
	push %rcx
	call cmpStringHelper
	pop %rax
	mov %rax, 32(%rsp)
	ret $24

cmpStringHelper:	#RECURSIVE
	mov 24(%rsp), %rax #pointer 1
	mov 16(%rsp), %rbx #pointer 2
	mov  8(%rsp), %rcx #length

	#BASECASE
	cmp $0, %rcx
	je cmpStringConditional

	#push important stuff
	push (%rax)
	push (%rbx)


	#RECURSE
	inc %rax
	inc %rbx
	dec %rcx
	push %rax
	push %rbx
	push %rcx
	call cmpStringHelper
	pop %rdx

	#repop
	pop %rbx
	pop %rax
	mov $0, %rcx

	cmp %rax, %rbx
	cmove %rdx, %rcx 	#rcx=rdx AND rcx

	#rcx has output for this char
	mov %rcx, 24(%rsp)
	ret $16
	cmpStringConditional:
	movq $1, 24(%rsp) #basecase just returns 1.
	ret $16

print:
	mov 16(%rsp), %rsi
	mov 8(%rsp), %rdx

	mov $1, %rax		#System call number
	mov $1, %rdi		#stdin
	syscall			#Call the kernel

	ret	$16
read:
	mov 16(%rsp), %rsi
	mov 8(%rsp), %rdx

	mov $0, %rax		#System call number
	mov $0, %rdi		#File descriptor for stdout
	syscall			#Call the kernel

	ret $16
exit:
	#EXIT COMPILER
	movq $60, %rax        # syscall number for sys_exit
	xorq %rdi, %rdi       # exit code 0
	syscall



