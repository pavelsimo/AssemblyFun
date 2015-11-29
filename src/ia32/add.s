.data

.text
    .globl _start
    .type Add, @function       # Add(int a, int b)
    .type Print, @function     # Print(int n)

    # \p1 - fd
    # \p2 - buffer
    # \p3 - size
    .macro WRITE p1, p2, p3
       movl $4, %eax         # write(int fd, const void *buf, size_t count)
       movl \p1, %ebx        # fd
       movl \p2, %ecx        # buffer
       movl \p3, %edx        # size
       int $0x80             # software interrupt
    .endm

    # \p1 - status
    .macro EXIT p1
        movl $1, %eax    # exit(int status)
        movl \p1, %ebx   # status
        int $0x80
    .endm

    # \p1 - x
    .macro ABS \p1
     # sarl  $31, %eax         #  shift arithmetic right : x >>> 31 , eax now represents y
     # xorl  -8(%sbp), %edx    #  %edx = x XOR y
    .endm
    

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
        jge begin
        pushl $1
        pushl $0x2d         # - (0x2d)
        pushl $1
        WRITE 16(%ebp), 12(%ebp), 8(%ebp)
        # print -
        # abs(%eax)
           
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
            WRITE $1, %esp, $1
            addl $4, %esp    # adjusting the stack 4 bytes
            cmpl $0, %esi
            jg begin2
        end2:

        pushl $0x0A  # \n
        WRITE $1, %esp, $1
        addl $4, %esp
                 
        movl %ebp, %esp
        popl %ebp
        ret

    _start:
        nop
        # =================
        # Add
        # ================
        pushl $-220
        pushl $200
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
