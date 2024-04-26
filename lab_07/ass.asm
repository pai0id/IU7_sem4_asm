section .text
    global asmFunc

asmFunc:
    ; sysv_abi
    mov rcx, rdx ; размер
    inc rcx

    mov rbx, rdi ; dst

    cmp rdi, rsi ; src
    jg copy_from_the_end

copy_at_first:
        rep movsb
        jmp finish

copy_from_the_end:
        add rdi, rcx
        add rsi, rcx
        dec rdi
        dec rsi

        std
        rep movsb
        cld

finish:
        ret
