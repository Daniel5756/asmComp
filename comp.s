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
#MAIN LOOP JUST GOES LIKE
#find all ';' and '\n' and '#'
#.if there is a ';' or '\n' next char is a (ignore spaces) start
#compare first chars to the key words and call the right function
#AFTER LOOP:
#print data
jmp exit
============================================================
	#FUNCTIONS FOR THE THING
eval:
	mov $0, %rax #depth = 0
	#for char: if '(' depth++ if ')' depth -- if ', ' and depth 0: push its stringiness and call recursively, if '/ /' ignore until next \n.
	#the result of the evaluation is in the stack
	ret
def:
	#nonono, push it to this stack: ptr, len type, ptr, len, type, ... then I can pop out when scope ends
	ret
fn:
	#add label and 
	#resolve each line and print ret thing at the end (need to ).
	#need to end scope at the end, so some register has the old rsp and it has to restore to that.
	ret
for:
	#print (evaluated) statement in parentheses. pritn 'Cx'
	#eval statement 2 and cmp to jump to end


	#eval each line after antil }


	#eval 3rd statement
	#jmp
	#print 'cx' as end
	ret
while:
	#print 'Cx'
	#eval statement
	#cmp


	#eval each line


	#print 'cx:'
	jmp Cx
	ret
if:
	#print 'Cx'
	#eval statement
	#cmp


	#eval each line


	#print cx
	ret
struct:
	#go line by line and add each variable to hash table for structs and add the struct name to the defn hastable
	#THE HASHTABLE has to keep track of the type of struct and has more stuff for ints and primitives. the 'type' is a pointer to this table.
	#It does this with a -1 ptr as the separation
	#so the structs have a hash table and when referenced, you get s.var = *(s+var) (only if var is in the type that s is) (type 0=int, 1=float, 2=char, all else is structs)
	#
	ret
push:
	#lit just eval the statement
	ret
pop:
	#pop to the varible (deref from stack table to stack and whatever :(...)
	ret
asm:
	#lit just print the thing after asm
	ret
data:
	#add to buffer and print at the end
	ret
retr:
	ret

#THATS THE COMPILER!!!


###HELPER FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS######FUNCTIONS###
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

cmpString:	#RECURSIVE
	mov 24(%rsp), %rax #pointer 1
	mov 16(%rsp), %rbx #pointer 2
	mov  8(%rsp), %rcx #length
	
	cmp %rcx, 0
	je cmpStringConditional
	#call itself
	##check if this character matches
	
	inc %rax
	inc %rbx
	dec %rcx
	push %rax
	#++++++++++++++++++++++++++++++++++++++++++JNVIWNI
	mov (%rax), %rcx
	mov %rcx, %rax
	mov (%rbx), %rcx
	mov %rcx, %rbx
	mov $0, %rcx
	mov $1, %rdx
	cmp %rax, %rbx
	cmove %rdx, %rcx
	mov %rcx, 24(%rsp)
	ret $16
cmpStringConditional:
	mov $1, 24(%rsp)
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



