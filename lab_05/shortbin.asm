.386
EXTRN num: word

PUBLIC prn_short_sbin
EXTRN prn_newline: near

OPTION segment:use16
DSEG SEGMENT PARA PUBLIC 'DATA'
    shortbin_prn_msg db "short bin num: $"
    buf db 9 dup('$')
DSEG ENDS

OPTION segment:use16
CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG
    
prn_short_sbin proc near
    mov ax, DSEG
    mov ds, ax

    mov ah, 09h
    lea dx, shortbin_prn_msg
    int 21h

    mov ax, num
    xor ah, ah

    bt ax, 7h   ; Проверка на знак
    jnc skip_minus
    push ax
    mov dl, '-'
    mov ah, 02h
    int 21h
    pop ax
    xor ah, ah
    neg al

skip_minus:
    mov cx, 7
    rol al,1  
    lea di, buf
 
btbs_lp:        ; Вывод 7 бит
    rol al,1         
    jc btbs_1
    mov bl, '0'
    mov [di], bl
    jmp btbs_end
btbs_1:
    mov bl, '1'
    mov [di],bl
btbs_end:
    inc di           
    loop btbs_lp

    mov ah, 09h
	lea dx, buf
    int 21h
    
    call prn_newline

    ret
prn_short_sbin endp
CSEG ENDS
END