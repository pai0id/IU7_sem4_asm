global _asmFunc
section .text
_asmFunc:
    ; Аргументы:
    ;   rdi = указатель на исходную строку
    ;   rsi = указатель на целевую строку
    ;   rdx = длина копируемой строки

    ; Проверка, если длина равна нулю
    test    rdx, rdx
    jz      .end

    ; Копирование строки
    .copy_loop:
        ; Загрузка байта из исходной строки
        movzx   eax, byte [rdi]

        ; Запись байта в целевую строку
        mov     [rsi], al

        ; Переход к следующему байту
        inc     rdi
        inc     rsi
        dec     rdx

        ; Проверка, достигли ли конца строки
        test    rdx, rdx
        jnz     .copy_loop

    .end:
    ret

