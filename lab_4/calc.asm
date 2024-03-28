EXTRN mtr:       byte
EXTRN n:         byte
EXTRN m:         byte
EXTRN size_mtr:  byte
EXTRN newline:   byte
PUBLIC del_max_row      ; Удаление максимальной строки
PUBLIC prn_mtr          ; Вывод матрицы

DSEG SEGMENT PARA PUBLIC 'DATA'
    max_sum db 0h
    max_sum_row db 0h
    curr_sum db 0h
    curr_row db 0h
    st_del_row db ?
    end_del_row db ?
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG
del_max_row proc near   ; Удаление максимальной строки
	mov si, offset mtr
    mov cl, size_mtr

    ; Нахождение id строки
find_max_sum_loop:
    mov dl, [si]
    inc si
    mov ah, 0h
    mov al, curr_sum
    add al, dl
    mov curr_sum, al

    mov ah, 0h
    mov al, size_mtr
    sub al, cl
    mov bl, m
    div bl
    mov curr_row, al
    inc ah
    cmp ah, m
    je is_eq
    jmp end_check
is_eq:
    mov al, curr_sum
    cmp al, max_sum
    jg is_new_max
    jmp end_gt_check
is_new_max:
    mov al, curr_sum
    mov max_sum, al
    mov al, curr_row
    mov max_sum_row, al
end_gt_check:
    mov curr_row, 0h
    mov curr_sum, 0h
end_check:
    
    loop find_max_sum_loop
    ; --------------------

    ; Удаление строки
    mov al, max_sum_row
    inc ax
    mul m

    mov cl, size_mtr
    sub cx, ax
    jz decs

    mov si, offset mtr
    add si, ax

    mov al, max_sum_row
    mul m
    mov di, offset mtr
    add di, ax

move_loop:
    mov al, [si]
    mov [di], al
    inc di
    inc si
    loop move_loop

decs:
    dec n
    mov al, size_mtr
    sub al, m
    mov size_mtr, al
    ; --------------------

	ret
del_max_row endp

prn_mtr proc near   ; Вывод матрицы
    mov si, offset mtr
    mov cl, size_mtr
    cmp cl, 0
    jz end_prn
prn_loop:
    mov ah, 0h
    mov al, size_mtr
    sub al, cl
    mov bl, m
    div bl
    cmp ah, 0
    jz is_z
    jmp end_check
is_z:
    mov ah, 09h
    lea dx, newline
    int 21h
end_check:
    
    mov dl, [si]
    inc si
    add dl, '0'
    mov ah, 02h
    int 21h
    mov dl, ' '
    mov ah, 02h
    int 21h
    loop prn_loop

end_prn:
    mov ah, 09h
    lea dx, newline
    int 21h
    mov ah, 09h
    lea dx, newline
    int 21h
    ret
prn_mtr endp
CSEG ENDS
END