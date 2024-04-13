.model tiny

CSEG SEGMENT
    assume CS:CSEG, DS:CSEG
    org 100h

main:
    jmp init

    og_handler      dd ?
    is_init         db 1
    cur_speed       db 1Fh
    cur_time        db 0

resident proc near
    push ax
    push cx
    push dx
    pushf

    mov ah, 02h
    int 1Ah

    cmp dh, cur_time
    je skip

    mov cur_time, dh
    dec cur_speed

    cmp cur_speed, 1Fh
    jbe set_speed

    mov cur_speed, 1Fh

set_speed:
    mov al, 0F3h
    out 60h, al

    mov al, cur_speed
    out 60h, al

skip:
    pop dx
    pop cx
    pop ax
    popf
    jmp cs:og_handler
resident endp

init:
    mov ax, 351Ch
    int 21h

    cmp es:is_init, 1
    je exit

    mov word ptr og_handler, bx
    mov word ptr og_handler[2], es

    mov ax, 251Ch
    mov dx, offset resident
    int 21h

    mov dx, offset init_msg
    mov ah, 09h
    int 21h

    mov dx, offset init
    int 27h

exit:
    mov dx, offset exit_msg
    mov ah, 09h
    int 21h

    mov al, 0F3h
    out 60h, al

    mov al, 0
    out 60h, al
    
    mov dx, word ptr es:og_handler
    mov ds, word ptr es:og_handler[2]
    mov ax, 251ch
    int 21h

    mov ah, 49h
    int 21h

    mov ax, 4c00h
    int 21h

    init_msg db 'My handler on', '$'
    exit_msg db 'My handler off', '$'

CSEG ENDS
END main
