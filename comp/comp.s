	.data
rawIn:	.zero 1024

printIntBuff:	.byte 16
digs:	.asciz "0123456789ABCDEF"
test:	.asciz "0123456789ABCDEF"
#COMMANDS:
starter:	.asciz " .text \n .globl _start \n .type _start, @function \n _start: \n "

nl:	.asciz "\n"

	.text
#============================================================
	#FUNCTIONS FOR THE THING
#NOTES
/*
evaluate all means basically note that it is in a function. It does this with the register that stores the scope .... actually just had a massive brainfart
pushes base pointer. a { pushes r8 and moves the rsp to r8. a } squiggle ends the scope by making rsp=(r8) and poping to r8


*/
eval:	#RECURSIVE
	#mov $0, %rax #depth = 0
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
	#jmp Cx
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
