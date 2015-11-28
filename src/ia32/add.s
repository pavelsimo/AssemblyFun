.data

.text
    .globl _start
    .type Add, @function    # Add(int a, int b)
    .type Print, @function  # Print(int n)

    Add:
        pushl %ebp
        movl %esp, %ebp

        movl 8(%ebp), %eax
        movl 12(%ebp), %ebx
        addl %ebx, %eax        
        
        movl %ebp, %esp
        popl %ebp
        ret

    Print:
        pushl %ebp
        movl %esp, %ebp

        movl $0, %edx
        movl 8(%ebp), %eax
        movl $5, %ecx
        divl %ecx 

        movl %ebp, %esp
        popl %ebp
        ret

    _start:
        nop
        # =================
        # Add
        # ================
        pushl $10
        pushl $20
        call Add
        addl $8, %esp   # adjust the stack pointer
        
        # =================
        # Print
        # =================
        push %eax       # using the return value of Add
        call Print
        addl $4, %esp   # adjust the stack pointer

    Exit:
        movl $1, %eax   # _exit(int status) syscall 
        movl $0, %ebx   # status=1
        int $0x80
