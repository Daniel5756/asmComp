	.data
		arthur: .asciz "monkey\n"
	.text
#============================================================
	#FUNCTIONS GENERIC
printInt:
	#xx xx xx xx xx xx xx xx
	pop %rax
	pop %rbx
	push %rax
	mov %rbx, %rdx
	mov $0xF000000000000000, %rcx
	printIntLoop:
	mov %rdx, %rbx
	and %rcx, %rbx

	push %rcx
	push %rdx
	push %rbx
	call cutZeroes
	pop %rbx #HAS PTR
	
	add $digs, %rbx
	
	
	push %rbx
	push $1
	call print

	pop %rdx
	pop %rcx

			/*OK so I have fprgotten how to use assembly. I am slowly refiguring it out*/
	shr $4,%rcx
	cmp $0, %rcx
	je printIntEnd
	jmp printIntLoop
	printIntEnd:
	ret


cutZeroes:
	pop %rax
	pop %rbx
	push %rax
cutZeroesLoop:
	#mov 1, %rcx
	#and %rbx, %rcx
	#RCX HAS MOD 2

	mov %rbx, %rdx
	shr $1, %rdx

	cmp $0, %rdx
	cmove %rdx, %rbx
	jne cutZeroesLoop

	cutZeroesEnd:
	pop %rax
	push %rbx
	push %rax
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

cmpString:	#RECURSIVE
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
	call cmpString
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



