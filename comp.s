	.data
rawIn:	.zero 1024

printIntBuff:	.asciz "0000000000000000"
digs:	.asciz "0123456789ABCDEF"
test:	.asciz "123456789ABCDEF0"
#COMMANDS:
starter:	.asciz " .text \n .globl _start \n .type _start, @function \n _start: \n "

nl:	.asciz "\n"
myCall: .asciz "call "
myPush:	.asciz "push "
myRet:	.asciz "ret "
myPop:	.asciz "pop "

currVar: 	.zero 40 #thing buffer
currVarReset: 	.zero 40 #reset buff

fullData:	.zero 100
fullDataPtr:	.long 0
startData: 	.asciz ".data \n mem: .zero 1024 \n mallocPtr: .long 0 \n"

name: .long 0
data: .long 0
inAsm: .long 0
numTolkens: .long 0
mainIndex: .long 0

	.text
	.globl	_start
	.type	_start, @function
_start:
	push $100
	call printInt
	
	jmp exit
	
	
	movq $fullData, fullDataPtr
	push $rawIn
	push $1024
	call read
	#inputs pgm
	movq $0, name 
	movq $0, data 
	movq $0, inAsm
	movq $0, numTolkens
	movq $rawIn, mainIndex
	#for character
	.mainLoop:				#
		#char = (mainIndex)
	squareContinue:				#square and carrot continued both check for the open bracket then loop until the end and then push the tolken
		cmpb $'[', (mainIndex)
		jne carrotContinue
		movq mainIndex, %rax
		movq $0, inAsm
		mov mainIndex, %rax
		inc %rax
		#CONTINUE UNTIL ']'
		squareBracketLoop:
			cmpb $']', (mainIndex)
			je squareBracketEnd
			incq mainIndex
			incq inAsm
			
			
			jmp squareBracketLoop
		squareBracketEnd:
			push %rax
			push inAsm
			push $0		#asm tolken
	carrotContinue:
###CARROT BRACKET
		cmpb $'<', (mainIndex)
		jne curlyContinue
		movq mainIndex, %rax
		movq $0, data
		mov mainIndex, %rax
		inc %rax
		#CONTINUE UNTIL ']'
		carrotBracketLoop:
			cmpb $'>', (mainIndex)
			je carrotBracketEnd
			incq mainIndex
			incq data
			
			
			jmp carrotBracketLoop
		carrotBracketEnd:
			push %rax
			push data
			push $1		#data tolken
			
	curlyContinue:
###CURLY BRACKET						##HAVE TO CHANGE
		cmpb $'{', (mainIndex)
		jne curlyContinue
		movq mainIndex, %rax
		movq $0, name
		mov mainIndex, %rax
		inc %rax
		#CONTINUE UNTIL ']'
		curlyBracketLoop:
			cmpb $'}', (mainIndex)
			je curlyBracketEnd
			incq mainIndex
			incq name
			
			
			jmp curlyBracketLoop
		curlyBracketEnd:
			push %rax
			push name
			push $1		#data tolken
			
		
jmp exit
/*

name = 0
data = 0
inAsm = 0
numTolkens=0
for char:
	if char is '[': index to asm, if ']' print that
	
	if char is '<': copy text to compiler .data string until '>' (and add nl)
	
	if char not in special:
		numTolkens++
		push index
		name = 1
	if char in special (special="()<>[]{},+*-/=...")
		if name > 0:
			push name #name is a len counter
			name = 0
			if char == '('
				push 'f' #function
			if char in " ,)+*-/="
				push 'v' #variable
			else: what the hell are you doing
	if char in "+*-/=":
		pop rax,rbx,rcx
		push &"add"[sub,mul,div], 3, 'f'
		push rcx,rbx,rax    #this just puts the operation token from (x + y) to +(x,y)

###PICK UP LEFT OFF HERE MAKE THIS FUNCTION ABOVE FOR PRINTING GAHHHHHH (AS A FUNCTION)
##########compile of "(a = f(b(c), d(e));
##########compiles to:
#push e
#call d
#push c
#call b
#call f
#push a
#call =
/*
it goes along.
keeps track of inside/outside quotes
if outside <>
 if it sees no ( right after buffer: push its pointer and len and that its a constant
 if it sees ( right after it is call and it pushes pointer and len and that its a function
 if it sees a +- * / = then use special function case and still push the same stuff
if in <> add that to compiler .data char[] and turn it into a bunch of spaces in the string buffer to not confuse the next step

now push 1 by 1
if its a function print "call "
if its a constant print "push "
then print the buffer
then \n
then repeat

slightly less pseudo looking code:
		

*/



jmp exit

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



