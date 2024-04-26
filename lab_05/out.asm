EXTRN prn_newline: near
PUBLIC end_prog

CSEG SEGMENT PARA PUBLIC 'CODE'
    assume CS:CSEG

end_prog proc near  ; Завершает программу
    call prn_newline
    mov ax, 4c00h
    int 21h
end_prog endp

CSEG ENDS
END
