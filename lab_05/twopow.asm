.386
EXTRN num: word

PUBLIC find_two_pow
EXTRN prn_newline: near

OPTION segment:use16
DSEG SEGMENT PARA PUBLIC 'DATA'
    two_pow_msg db "Res: $"
    err_zero_msg db "Error: no pow 2 $"
    buf db 6 dup('$')
DSEG ENDS

OPTION segment:use16
CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG
    
find_two_pow proc near
    mov ax, DSEG
    mov ds, ax

    mov ah, 09h
    lea dx, two_pow_msg
    int 21h

    mov ax, num     ; При нуле нет кратной степени 2
    cmp ax, 0
    jz err_zero

    bsf bx, ax      ; Первая 1 справа - искомая степень

    xor ax, ax

    bts ax, bx      ; Вывод степени двойки
    dec ax

    lea di, buf
    xor cx, cx
    mov bx, 10
 
prn_loop1:         
    xor dx, dx
    div bx
    add dl, '0'
    push dx        
    inc cx         
    test ax, ax     
    jnz prn_loop1  
 
prn_loop2:         
    pop dx         
    mov [di], dl
    inc di
    loop prn_loop2

    mov ah, 09h
	lea dx, buf
    int 21h

    call prn_newline

    ret
err_zero:
    call prn_newline
	mov ah, 09h
	lea dx, err_zero_msg
    int 21h
	call prn_newline
	call prn_newline
	ret
find_two_pow endp
CSEG ENDS
END