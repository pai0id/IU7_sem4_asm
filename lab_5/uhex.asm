.386
EXTRN num: word

PUBLIC prn_uhex
EXTRN prn_newline: near

OPTION segment:use16
DSEG SEGMENT PARA PUBLIC 'DATA'
    uhex_prn_msg db "uhex num: $"
DSEG ENDS

OPTION segment:use16
CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG
    
prn_uhex proc near
    mov ax, DSEG
    mov ds, ax

    mov ah, 09h
    lea dx, uhex_prn_msg
    int 21h

    mov ax, num   

    mov cx, 4
    mov bx, 4

print_loop:
    rol ax, 4
    push ax  
    and ax, 0Fh   
    add al, '0'
    cmp al, '9'   
    jbe skip_correction
    add al, 7
skip_correction:
    mov dl, al    
    mov ah, 02h   
    int 21h
    pop ax   
    dec bx   
    loop print_loop

    call prn_newline

    ret
prn_uhex endp
CSEG ENDS
END