section .data
    five: dq 5.0
    two: dq 2.0
    eps: dq 1e-8
    x: dq 0
    it: dq 0
    x0: dq 0
    x1: dq 0
    x2: dq 0
    f0: dq 0
    f1: dq 0

section .text
    global secantMethod

    f:
        push rbp
        mov rbp, rsp

        movq qword [x], xmm0
        fld qword [x]
        fmul qword [x]
        fsub qword [five]
        fsin
        fmul qword [two]
        fstp qword [x]
        movq xmm0, qword [x]
        
        pop rbp
        ret

    secantMethod:
        push rbp
        mov rbp, rsp

        movq qword [x0], xmm0
        movq qword [x1], xmm1
        mov qword [it], rdi

        movq xmm0, qword [x0]
        call f
        movq qword [f0], xmm0
        fld qword [f0]
        movq xmm0, qword [x1]
        call f
        movq qword [f1], xmm0
        fmul qword [f1]

        fld qword [eps]
        fcompp
        fstsw ax
        sahf
        jb _err

        mov rcx, qword [it]
        _main_loop:
            fld qword [f1]
            fsub qword [f0]
            fabs
            fld qword [eps]
            fcompp
            fstsw ax
            sahf
            ja _err

            fld qword [x1]
            fld qword [f1]
            fld qword [x1]
            fsub qword [x0]
            fld qword [f1]
            fsub qword [f0]
            fdivp
            fmulp
            fsubp
            fstp qword [x2]

            fld qword [x2]
            fsub qword [x1]
            fabs
            fld qword [eps]
            fcompp
            fstsw ax
            sahf
            ja _found

            movq xmm0, qword [x1]
            movq qword [x0], xmm0
            movq xmm0, qword [x2]
            movq qword [x1], xmm0

            movq xmm0, qword [x0]
            call f
            movq qword [f0], xmm0
            movq xmm0, qword [x1]
            call f
            movq qword [f1], xmm0

            dec rcx
            jnz _main_loop

        jmp _ok

    _err:
        mov rdx, 1
        jmp _exit
    _ok:
        movq xmm0, qword [x1]
        mov rdx, 0
        jmp _exit
    _found:
        movq xmm0, qword [x2]
        mov rdx, 0
        jmp _exit
    _exit:
        pop rbp
        ret
