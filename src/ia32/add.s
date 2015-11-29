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
        
        movl 8(%ebp), %eax  # read parameter from the stack
 
        # while(%eax > 0)
        movl $0, %edx
        movl $0, %esi       # digit counter
        cmpl $0, %eax
        jle end
        begin:
            movl $0, %edx
            movl $10, %ecx
            divl %ecx       # %eax = %eax / 10
            incl %esi       
            addl $48, %edx  # add 48 ('0') to the digit
            pushl %edx      # push %edx % 10

            cmpl $0, %eax
            jg begin
        end:

        # while(%esi > 0)
        cmpl $0, %esi
        jle end2
        begin2:
            decl %esi

            movl $4, %eax    # write syscall
            movl $1, %ebx    # fd=1 stdout
            movl %esp, %ecx  # buffer=digit
            movl $1, %edx    # size=1
            int $0x80        # software interrupt

            addl $4, %esp    # adjusting the stack 4 bytes
            cmpl $0, %esi
            jg begin2
        end2:

        movl $4, %eax    # write syscall
        movl $1, %ebx    # fd=1 stdout
        movl $0x0A, %ecx   # buffer='\n'
        movl $1, %edx    # size=1
        int $0x80        # software interrupt
                 
        movl %ebp, %esp
        popl %ebp
        ret

    _start:
        nop
        # =================
        # Add
        # ================
        pushl $150
        pushl $50
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
