PUBLIC read_uoct
EXTRN num: word
EXTRN prn_newline: near

DSEG SEGMENT PARA PUBLIC 'DATA'
    buffer db 7 dup(0)
    inp_num_msg db "Input uoct num: $"
    err_wrong_num db "WRONG NUM $"    ; Сообщение об ошибке
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG
    
read_uoct proc near
    mov ax, DSEG
    mov ds, ax

entry_loop:
    mov ah, 09h
    lea dx, inp_num_msg
    int 21h

    ; Ввод
    lea si, buffer
    mov cx, 6
input_loop:
    mov ah, 01h     ; Ввод цифры
    int 21h
    cmp al, 0Dh     ; Условие конца ввода
    je convert
    sub al, '0'     ; Перевод в число

    cmp al, 7
    jg err_inp
    cmp al, 0
    jl err_inp

    mov [si], al    ; Сохранение
    inc si
    loop input_loop

convert:
    cmp si, offset buffer
    je entry_loop
    dec si
    mov bx, 0  ; Степень 8
    mov num, 0  ; Число

curr_num_loop:
    mov ax, 1h
    mov dx, 8h

    mov cx, bx
    cmp cx, 0
    jz out_loop
mul_loop:
    mul dx
    mov dx, 8h
    loop mul_loop
out_loop:

    xchg dx, ax
    mov ah, 0
    mov al, [si]
    mul dx
    jo err_inp

    mov dx, num
    add dx, ax
    jo err_inp
    mov num, dx

    cmp si, offset buffer
    je end_convert

    dec si
    inc bx
    jmp curr_num_loop

err_inp:
    call prn_newline
	mov ah, 09h
	lea dx, err_wrong_num
    int 21h
	call prn_newline
	call prn_newline
	jmp entry_loop

end_convert:
    call prn_newline
    ret
read_uoct endp
CSEG ENDS
END