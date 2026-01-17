        .data
thing: .asciz "lalala"
        .text
        .globl  _start
        .type   _start, @function
_start:
#TEST FINDVAR
push $thing
push $6
push $50

push $digs
push $9
push $15

push $5
push $5
push $5
			# 11
push $digs
push $8
call findVariable
call printInt

call printnl

push $thing
call printInt
call printnl
push $digs
call printInt
call printnl
jmp exit
