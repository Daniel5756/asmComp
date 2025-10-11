	.text
	.globl	_start
	.type	_start, @function
_start:
	push $rawIn
	push $1024
	call read
	#inputs pgm
	
	mov $rawIn, %rax
	#for character:
	mainLoop:
		
		mov (%rax), %bl
		cmp '(', %bl
		jmp oPar
		cmp ')', %bl
		jmp cPar
		cmp '[', %bl
		jmp oBrk
		cmp ']', %bl
		jmp cBrk
		cmp '{', %bl
		jmp oCrl
		cmp '}', %bl
		jmp cCrl
		cmp ';', %bl
		jmp sCln

		oPar:		#if oPar then check if space before it. if is then 
			
			jmp continue
		cPar:		
			
			jmp continue
		oBrk:		
			
			jmp continue
		cBrk:		
			
			jmp continue
		oCrl:		
			
			jmp continue
		cCrl:		
			
			jmp continue
		sCln:		
			
			jmp continue
		specialF:
		
			eql:		#set var, return none	(x = y);
				
			jmp continue
			add:		#return sum of 2 ins 	(x + y);
				
			jmp continue
			sub:		#
				
			jmp continue
			mul:		#
				
			jmp continue
			div:		#
				
			jmp continue
		continue:

#...
jmp exit
###=========================COMPLEX FUNCTIONS=======================================================




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
	push %r8

	mov $0, %rax		#System call number
	mov $0, %rdi		#File descriptor for stdout
	syscall			#Call the kernel
	#push %r8
	ret
exit:
	#EXIT COMPILER
	movq $60, %rax        # syscall number for sys_exit
	xorq %rdi, %rdi       # exit code 0
	syscall

###=========================  DECLARATIONS  ========================================================
.data

#=======TESTS======



#=======DATA=======

tok:	.zero 256
rawIn:	.zero 1024


/*.data*/

digs:
	#.align 8
	.asciz "0123456789"

#=====SPECIAL CHARACTERS====
symbols:		.asciz "();{}+-*/&"
symbolsLen:	.byte .-symbols -1

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
