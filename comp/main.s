        .data
thing: .asciz "lalala"
        .text
        .globl  _start
        .type   _start, @function
_start:
push %rsp
call printInt

call printnl

push $thing
push $6
push $50

push $digs
push $9
push $15
			# 11
push $thing
push $6
call findVariable
call printInt



call printnl
			# F

push $thing
push $6
call print

push $digs
push $9
call findVariable
call printInt

call printnl

push $digs
push $10
call findVariable
call printInt

call printnl

pop %rax
pop %rax
pop %rax

push %rsp
call printInt

call printnl

jmp exit
