EXTRN end_prog: near
EXTRN read_uoct: near
EXTRN prn_uhex: near
EXTRN prn_short_sbin: near
EXTRN find_two_pow: near
PUBLIC prn_newline
PUBLIC num

STK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
    menu_text db "1. Enter uoct"	; Меню
              db 0Ah, 0Dh
              db "2. Convert to uhex"
              db 0Ah, 0Dh
              db "3. Convert to short bin"
              db 0Ah, 0Dh
              db "4. Find nearest pow of 2"
              db 0Ah, 0Dh
              db "0. Exit"
              db 0Ah, 0Dh
              db "Enter command: $"
	err_wrong_option db "WRONG OPTION $"    ; Сообщение об ошибке
    newline db 0Ah, 0Dh, "$"    ; \n
	f_id db ?
		
    f_arr     dw 5 DUP (0) 	; Массив указателей на подпрограммы
    num dw 0
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG, DS:DSEG, SS:STK
prn_newline proc near	; Вывод \n
	mov ah, 09h
    lea dx, newline
    int 21h
	ret
prn_newline endp

main:
	mov ax, DSEG
    mov ds, ax

    mov f_arr[0], end_prog
    mov f_arr[2], read_uoct
    mov f_arr[4], prn_uhex
    mov f_arr[6], prn_short_sbin
    mov f_arr[8], find_two_pow

    call read_uoct

menu_loop:
    mov ah, 09h
    lea dx, offset menu_text	; Вывод меню
    int 21h

	; Ввод команды
    mov ah, 01h
    int 21h
    sub al, '0'
    mov f_id, al
    call prn_newline
    ; ----------

    ; Ошибка в номере команды
    cmp f_id, 4
    jg err_inp
    cmp f_id, 0
    jl err_inp
    ; ----------

	call prn_newline

    mov ah, 0h
    mov al, f_id
    mov dl, 2
    mul dl
    mov bx, ax
    call f_arr[bx]  ; Вызов выбранной функции

	call prn_newline

	jmp menu_loop
err_inp:
	call prn_newline
	mov ah, 09h
	lea dx, err_wrong_option
    int 21h
	call prn_newline
	call prn_newline
	jmp menu_loop
CSEG ENDS
END main
