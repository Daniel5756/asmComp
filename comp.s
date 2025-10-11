	.data
rawIn:	.zero 1024


test:	.asciz "gnfejiownbgi"
#COMMANDS:
starter:	.asciz " .text \n .globl _start \n .type _start, @function \n "
nl:	.asciz "\n"
myCall: .asciz "call "
myPush:	.asciz "push "
fullData:	.zero 100
fullDataPtr:	.long 0
startData: 	.asciz ".data \n mem: .zero 1024 \n mallocPtr: .long 0 \n"


	.text
	.globl	_start
	.type	_start, @function
_start:
	push $'g'
	push $test
	push $'10'
	call chrInStr
	
	
	
	
	mov $fullData, fullDataPtr
	push $rawIn
	push $1024
	call read
	#inputs pgm
	
	mov $rawIn, %rax
	#for character:
	mainLoop:
		
		mov (%rax), %bl
		cmpb $'(', %bl
		je oPar
		cmpb $')', %bl
		je cPar
		cmpb $'[', %bl
		je oBrk
		cmpb $']', %bl
		je cBrk
		cmpb $'{', %bl
		je oCrl
		cmpb $'}', %bl
		je cCrl
		cmpb $';', %bl
		je sCln

		oPar:		#if oPar then check if space before it. if is then 
			cmpb $' ', -1(%rax)
			je specialF
			#REG CASE (PRINT CALL FUNCTION)
			#PRINT CALL AND THE FUNCTION
			oParLoop:
				#count len before current index until a special character or a space: so abcd( results in -4 because a is at -4
###PICK UP LEFT OFF HERE MAKE THIS FUNCTION ABOVE FOR PRINTING GAHHHHHH (AS A FUNCTION)
##########while ((rax) ! in "(){}[];") {
##########	rax++
##########	if (rax) != ' ': count ++
##########return count
##########


				
				
				
				
				
			jmp continue
		cPar:		#
			
			jmp continue
		oBrk:		#
			
			jmp continue
		cBrk:		#
			
			jmp continue
		oCrl:		#
			
			jmp continue
		cCrl:		#
			
			jmp continue
		sCln:		#
			
			jmp continue
		specialF:
			cmpb $'=', -1(%rax)
			je eqls
			cmpb $'+', -1(%rax)
			je addt
			cmpb $'-', -1(%rax)
			je subt
			cmpb $'*', -1(%rax)
			je mult
			cmpb $'/', -1(%rax)
			je divd
			#jmp lexerror
			
			eqls:		#set var, return none	(x = y);
				
			jmp continue
			addt:		#return sum of 2 ins 	(x + y);
				
			jmp continue
			subt:		#
				
			jmp continue
			mult:		#
				
			jmp continue
			divd:		#
				
			jmp continue
		

		
		continue:




jmp exit

###FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS###
printInt:		#PRINTS AN INT
	pop %rax
	pop %rbx
	push %rax
	push $rbx
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
	
	#push %r8
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
	ret $3



print:
	mov 16(%rsp), %rsi
	mov 8(%rsp), %rdx



	mov $1, %rax		#System call number
	mov $1, %rdi		#stdin
	syscall			#Call the kernel

	ret	$2
read:
	mov 16(%rsp), %rsi
	mov 8(%rsp), %rdx

	mov $0, %rax		#System call number
	mov $0, %rdi		#File descriptor for stdout
	syscall			#Call the kernel

	ret
exit:
	#EXIT COMPILER
	movq $60, %rax        # syscall number for sys_exit
	xorq %rdi, %rdi       # exit code 0
	syscall



