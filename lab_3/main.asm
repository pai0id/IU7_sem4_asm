STK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
    msg db 'Enter a string of nums (0-5) up to 10 characters: $'
    sum_msg db 'Sum of the second and fourth nums: $'
    newline db 0Ah, 0Dh, '$'
    nums db 10 dup(?)
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG, SS:STK
main:
    mov ax, DSEG
    mov ds, ax

    ; Приглашение ввода
    mov ah, 09h
    lea dx, msg
    int 21h

    ; Ввод
    mov si, offset nums
    mov cx, 10
input_loop:
    mov ah, 01h     ; Ввод цифры
    int 21h
    cmp al, 0Dh     ; Условие конца ввода
    je end_input
    sub al, '0'     ; Перевод в число
    mov [si], al    ; Сохранение
    inc si
    loop input_loop
end_input:

    ; Вычисление
    mov al, nums[1]
    add al, nums[3]
    add al, '0'     ; Перевод в символ

    ; Вывод суммы
    mov ah, 09h
    lea dx, sum_msg
    int 21h

    mov dl, al
    mov ah, 02h
    int 21h

    mov ah, 09h
    lea dx, newline
    int 21h

    mov ah, 4Ch
    int 21h
CSEG ENDS
END main
