.data
lastScope: .long 0
.text
newScope:
    //push last scope
    //update lastScope to this scope
    pushq lastScope
    movq %rsp, lastScope
ret
alloc:
    //push name, len, val
    
    
ret
endscope:
    //%rsp = lastScope
    //pop into lastscope
    mov lastScope, %rsp
    pop lastScope
ret
