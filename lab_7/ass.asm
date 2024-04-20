section .text
    global asmFunc

asmFunc:
    ; mov rbp, rsp

    ; mov rdi, [rbp + 8]  ; Accessing the first argument
    ; mov rsi, [rbp + 12]  ; Accessing the second argument
    ; mov rcx, [rbp + 24]  ; Accessing the third argument
    mov rcx, rdx

    mov rbx, rdi

    cmp rdi, rsi
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
