	.data
	findVariableErrorMsg: .asciz "There requested variable does not exist. very sad. the program will end now."
	.text


###SPECIFIC HELPER FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS###
oBracket:
	pop %rax
	#pushes base pointer. a { pushes r8 and moves the rsp to r8. a } squiggle ends the scope by making rsp=(r8) and poping to r8
	push %r8
	mov %rsp, %r8
	push %rax
	ret
cBracket:
	pop %rax
	mov %r8, %rsp
	pop %r8
	push %rax
	ret
findVariable:
/*	pop ptr
	pop len
	while not found:
		pop rax rbx rcx
		cmp lengths
		cmp strings
		if equal then push value and ret
	*/
	mov 16(%rsp), %rax	#pointer
	mov 8(%rsp), %rbx	#len
	mov %rsp, %rcx 	#counter
	//sub $24, %rcx
	findVarLoop:#IF VAR DOES NOT EXIST THERE IS SEG FAULT
		add $24, %rcx		 #/*to define you push ptr, push len, push val*/
		//cmp %rcx, varStart
		//jge findVariableError			I have no idea how to make the error system work... very sad... just get it right :)

		cmpq 8(%rcx), %rbx 	#len compare
		jne findVarLoop

		push %rax
		push %rbx
		push %rcx

		push 16(%rcx)
		push %rax
		push %rbx #len
		call cmpString

		pop %rsi
		pop %rcx
		pop %rbx
		pop %rax

/*
		push %rsi		
		call printInt		

		call printnl		

		push 16(%rcx)		
		call printInt		

		push 16(%rcx)		
		push %rbx		
		call print		
*/

		cmpq $1, %rsi
		je findVariableEnd
		jmp findVarLoop
	findVariableEnd:
		mov (%rcx), %rax
		mov %rax, 16(%rsp)
		ret $8
	findVariableError:
		push $findVariableErrorMsg
		push $76
		call print
		jmp exit
