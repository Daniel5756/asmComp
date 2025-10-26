#I'm trying this route. I want to write the compiler in itself and hand compile it and try to compile it in itself once I compile it myself. I'm not crazy...
#is a comment
#@calls a function
#. declares new thing (function or allocates a long)
#<> add to .data
#[] is asm
#{ indicates f and } rets

#NC compiler I will compile by had to assembly(?)
.&{
#dereference
	[
	pop %rax #return address
	pop %rbx #addr
	mov %rcx, (%rbx)
	push %rcx
	push %rax
	]
}
.stackFetch{
	[
	pop %rax	
	pop %rbx	#swap
	push %rax	#ret and in
	push %rbx	
	]
	@&  #@ calls a function
	
	]
}
.compr{
#cmp
	stackFetch($1,)
	
}

.if{
#dot initializes and allocates var
	.stackFetch
	[
	cmp tf, $0
		
		
	]
	
};

.stackFetch
