	.text
	.globl	_start
	.type	_start, @function
_start:
	##push %rbp #PUSH BOTTOM OF STACK - RBP=(RSP)

	push $'1'
	push $symbols
	push $10
	
	call chrInStr
	
	call printInt
	
	
	
	
	
jmp exit
###=========================COMPLEX FUNCTIONS=======================================================
strCmp:			#RETRUNS 1 IF STR1==STR2; 0 OTHERWISE
	pop %r8

	pop %rdx	#INPUT IS 2 STR* OF SAME LEN
	pop %rcx

	#pop %rbx
	pop %rax

	mov $0, %r9 #i
	mov $0, %rbx #out
	strCmpLoop:
		#rbx+=a[i]-b[i]
		mov (%r9, %rax, 1), %r10
		sub (%r9, %rcx, 1), %r10
		add %r10, %rbx
		
		
		inc %r9
		cmp $0, %r10
		push %r10
		cmovne %rdx, %r9
		
		cmp %r9, %rdx
		jne strCmpLoop

	#push %rbx
	mov $1, %rax
	cmp $0, %rbx
	mov $0, %rbx
	cmovne %rbx, %rax

	push %rax
	
	push %r8
	ret
printInt:		#PRINTS AN INT
	pop %r8
	mov $1000000000, %r9
	printIntLoop:
		mov $0, %rdx		#0:%rax
		mov $10, %rbx		#divide by 10
		mov %r9, %rax		#divide %r9
		div %rbx		#divide %r9/10
		mov %rax, %r9		#put result in %r9

		pop %rax		#pop num
		mov $0, %rdx		#0:%rax
		div %r9			#
		
		push %rdx
		

		push %r8
		#PRINT

		add $digs, %rax
		push %rax
		push $1
		call print

		#END of loop
		pop %r8


		cmp $1, %r9
		jg printIntLoop
	
	push %r8
	ret


chrInStr:
	pop %r8			#return addr

	pop %rcx		#str len
	pop %rbx		#str ptr
	pop %rax		#chr lirteral

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
	push %r8
	ret
###=========================BASIC   FUNCTIONS========================================================
print:
	pop %r8
	pop %rdx		#length
	pop %rsi		#str*

	mov $1, %rax		#System call number
	mov $1, %rdi		#stdin
	syscall			#Call the kernel
	push %r8
	ret
read:
	pop %r8
	pop %rdx		#length
	pop %rsi		#str*

	mov $0, %rax		#System call number
	mov $0, %rdi		#File descriptor for stdout
	syscall			#Call the kernel
	push %r8
	ret
exit:
	#EXIT COMPILER
	movq $60, %rax        # syscall number for sys_exit
	xorq %rdi, %rdi       # exit code 0
	syscall

###=========================  DECLARATIONS  ========================================================
	.data	
digs:
	#.align 8
	.asciz "0123456789"

#=====SPECIAL CHARACTERS====
symbols:		.asciz "();{}+-*/&"
symbolsLen:	.byte .-symbols -1

#=======TESTS======



#=======DATA=======
tok:
	.zero 256
rawIn:
	.zero 1024

#=====MESSAGES=====
nl:		.ascii "\n"

mStart:		.asciz "Compiling starting\n"
mStartLen:	.byte .-mStart - 1

mErrTok:	.asciz "Error: Invalid token syntax somewhere\n"
mErrTokLen:	.byte .-mErrTok - 1

mErrLex:	.asciz "Error: Couldn't think it through :(\n"
mErrLexLen:	.byte .-mErrLex - 1

mEnd:		.asciz "Alright! all done!"
mEndLen:	.byte .-mEnd - 1
