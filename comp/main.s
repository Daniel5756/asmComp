        .data
thing: .asciz "lalala"
varStart:	.long 0
        .text
        .globl  _start
        .type   _start, @function
_start:
#TEST FINDVAR
mov %rsp, varStart

push $thing
call printInt
call printnl

push $digs
call printInt
call printnl


//push thingies
push $thing
push $6
push $50

push $digs
push $9
push $15

push $5
push $5
push $5

//find and print
push $thing
push $6
call findVariable
call printInt

call printnl

jmp exit
