#adds to data section 
<hello: .asciz "hello world">
#print function
print{[

        mov 8(%rsp), %rsi	#other order because inputs get pushed reversely
        mov 16(%rsp), %rdx	#
        mov $1, %rax            #System call number
        mov $1, %rdi            #stdin
        syscall                 #Call the kernel
        ret     $16	
]}

#usually there would be a standard library for basic functions like print
print(hello);
