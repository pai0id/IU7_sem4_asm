PUBLIC mtr
PUBLIC n_max
PUBLIC m_max
PUBLIC m
PUBLIC max_size
PUBLIC size_mtr
PUBLIC newline
EXTRN del_max_row: near
EXTRN prn_mtr: near

STK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
    entr_n db 'Enter n: $'      ; Приглашения ввода 
    entr_m db 'Enter m: $'
    entr_num db 'Enter $'
    entr_comma db ',$'
    entr_colon db '(1-9): $'
    mtr_msg db 'Matrix:$'       ; Сообщения вывода матрицы
    res_msg db 'Result:$'
    err_msg db 'ERROR $'        ; Сообщение об ошибке
    newline db 0Ah, 0Dh, '$'    ; \n
    mtr db 81 dup(0)            ; Матрица
    n db ?
    m db ?
    i db ?
    j db ?
    n_max db 9
    m_max db 9
    size_mtr db ?
    max_size db 81
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG, SS:STK
main:
    mov ax, DSEG
    mov ds, ax

    mov ah, 09h
    lea dx, entr_n
    int 21h

    ; Ввод n
    mov ah, 01h
    int 21h
    sub al, '0'
    mov n, al
    mov ah, 09h
    lea dx, newline
    int 21h
    ; ----------

    ; Ошибка в n
    cmp n, 9
    jg err_inp
    cmp n, 1
    jl err_inp
    ; ----------

    mov ah, 09h
    lea dx, entr_m
    int 21h

    ; Ввод n
    mov ah, 01h
    int 21h
    sub al, '0'
    mov m, al
    mov ah, 09h
    lea dx, newline
    int 21h
    ; ----------

    ; Ошибка в m
    cmp m, 9
    jg err_inp
    cmp m, 1
    jl err_inp
    ; ----------

    ; Вычисление размера матрицы
    mov al, n
    mul m
    mov size_mtr, al
    ; ----------

    ; Ввод элементов матрицы
    mov si, offset mtr
    mov cl, size_mtr

    mov si, 0
    mov i, 0
    mov j, 0

    mov ah, 02h 
    mov dl, 0Ah
    int 21h
read_mtr:
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al

    mov dl, ' '
    mov ah, 02h
    int 21h    
    mov dl, bl

    mov al, i
    mov bl, 9
    mul bl
    add al, j
    mov si, ax

    mov mtr[si], dl
    
    inc j

    mov al, j
    cmp al, m
    je newline_prn
cont:
    loop read_mtr
    ; --------------------

    ; Вывод исходной матрицы
    mov ah, 09h
    lea dx, newline
    int 21h
    mov ah, 09h
    lea dx, mtr_msg
    int 21h
    mov ah, 09h
    lea dx, newline
    int 21h
    call prn_mtr
    ; ----------

    ; Удаление максимальной строки
    call del_max_row
    ; ----------

    ; Вывод результирующей матрицы
    mov ah, 09h
    lea dx, res_msg
    int 21h
    mov ah, 09h
    lea dx, newline
    int 21h
    call prn_mtr
    ; ----------
    
    mov ax, 4c00h
    int 21h
newline_prn:
    inc i
    mov j, 0
    
    mov ah, 02h 
    mov dl, 0Ah
    int 21h
    jmp cont
err_inp:
    mov ah, 09h
    lea dx, newline
    int 21h
    mov ah, 09h
    lea dx, err_msg
    int 21h
    mov ah, 09h
    lea dx, newline
    int 21h
    mov ax, 4c01h
    int 21h

CSEG ENDS
END main