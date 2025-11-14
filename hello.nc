#adds to data section 
data hello: .asciz "hello world";
#print function
fn print(int* ptr, int len) {
	asm mov 8(%rsp), %rsi;	#other order because inputs get pushed reversely
	asm mov 16(%rsp), %rdx;	#
	asm mov $1, %rax;            #System call number
	asm mov $1, %rdi;            #stdin
	asm syscall;                 #Call the kernel
	asm ret     $16;	
#void
}

#usually there would be a standard library for basic functions like print
fn main() {

	print(hello);

}
