.model tiny

CSEG SEGMENT
    assume CS:CSEG, DS:CSEG
    org 100h  ;PSP

main:
    jmp init

    og_handler      dd ?    ; Оригинальный обработчик
    is_init         db 1    ; Флаг проинициализированности
    cur_speed       db 1Fh  ; Последняя скорость
    cur_time        db 0    ; Последнее зафиксированное время

resident proc near

    mov ah, 02h     ; Считывание текущего времени
    int 1Ah

    cmp dh, cur_time    ; Изменяю скорость, только когда прошла секунда
    je skip

    mov cur_time, dh
    dec cur_speed

    cmp cur_speed, 1Fh  ; Зацикливаю скорость
    jbe set_speed

    mov cur_speed, 1Fh

set_speed:
    mov al, 0F3h
    out 60h, al

    mov al, cur_speed   ; Изменяю скорость
    out 60h, al

skip:
    jmp cs:og_handler   ; Вызов оригинального обработчика
resident endp

init:
    mov ax, 351Ch
    int 21h

    cmp es:is_init, 1   ; Если программа уже в памяти, отключаю
    je exit

    mov word ptr og_handler, bx     ; Сохраняю оригинальный обработчик
    mov word ptr og_handler[2], es

    mov ax, 251Ch
    mov dx, offset resident     ; Задаю новый обработчик
    int 21h

    mov dx, offset init_msg     ; Вывожу сообщение
    mov ah, 09h
    int 21h

    mov dx, offset init     ; Удаляю ненужную часть программы
    int 27h

exit:
    mov dx, offset exit_msg     ; Вывожу сообщение
    mov ah, 09h
    int 21h

    mov al, 0F3h       ; Возвращаю исходную скорость
    out 60h, al

    mov al, 0
    out 60h, al
    
    mov dx, word ptr es:og_handler      ; Возвращаю исходный обработчик
    mov ds, word ptr es:og_handler[2]
    mov ax, 251ch
    int 21h

    mov ah, 49h     ; Высвобождаю память
    int 21h

    mov ax, 4c00h   ; Завершаю программу
    int 21h

    init_msg db 'My handler on', '$'    ; Сообщения
    exit_msg db 'My handler off', '$'

CSEG ENDS
END main
