        .data
        .text
        .globl  _start
        .type   _start, @function
_start:
/*push %rsp
call printInt2
                        //diabolically confused
push $digs
push $16
call print

push $digs
push $10
push $17

push $test
push $10
call findVariable
push $10
call print

push $nl
push $2
call print

push %rsp
call printInt
*/
push $10
call printInt
jmp exit
