	.data
rawIn:	.zero 1024

printIntBuff:	.asciz "0000000000000000"
digs:	.asciz "0123456789ABCDEF"
test:	.asciz "123456789ABCDEF0"
#COMMANDS:
starter:	.asciz " .text \n .globl _start \n .type _start, @function \n _start: \n "

nl:	.asciz "\n"
	.text
	.globl	_start
	.type	_start, @function
_start:
	push $rawIn
	call read
	#
	
	#evaluate expression:
	#a(b, c(d,e));
	#push e
	#push d
	#call c
	#push b
	#call a


	##if(expression) {statements}
	#
	#evaluate expression
	#pop %rax
	#cmp $0, %rax
	#je C0
	#
	#evaluate statements
	#
	#C0:

	#while(expression) {statements}
	#L0:
	#eval expr
	#pop %rax
	#cmp $0, %rax
	#
	#evaluate statememnts
	#
	#jmp L0
	#L0c
	jmp exit

	#make 'let':
	#add this to heap array: [StringPtrName, scope ptr],[''],['']
	#
	
	#
###FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS###
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
		
		

printInt:		#PRINTS AN INT base 16
	mov 8(%rsp), %rax
	
	mov $printIntBuff, %rbx
	movq $0, (%rbx)
	movq $0, 8(%rbx)
	add $15, %rbx
	printIntLoop:
		mov %rax, %rcx
		and $15, %rcx		#bitmask
		shr $4, %rax


		add $digs, %rcx		#ptr from bitmask
		mov (%rcx), %dl
		mov %dl, (%rbx)
		dec %rbx

		#END of loop


		cmp $0, %rax		#if %rax is more than 
		jne printIntLoop

	printIntLoop2:
		push $printIntBuff
		push $16
		call print
	printIntRet:

	ret $8


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



