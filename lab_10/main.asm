bits 64

global main

%define GTK_WIN_POS_CENTER 1
%define GTK_WIN_WIDTH 750
%define GTK_WIN_HEIGHT 30
%define GTK_ORIENTATION_HORIZONTAL 0
%define LAYOUT_BOX_SPACING 5

extern exit
extern gtk_init
extern gtk_main
extern g_object_set
extern gtk_main_quit
extern gtk_window_new
extern gtk_widget_show
extern g_signal_connect
extern gtk_window_set_title
extern g_signal_connect_data
extern gtk_window_set_position
extern gtk_settings_get_default
extern gtk_widget_set_size_request
extern gtk_window_set_default_size
extern gtk_box_new
extern gtk_spin_button_new_with_range
extern gtk_spin_button_set_value
extern gtk_spin_button_get_value
extern gtk_widget_show_all
extern gtk_button_new_with_label
extern gtk_label_new
extern gtk_box_pack_start
extern gtk_container_add
extern gtk_widget_set_margin_top
extern gtk_widget_set_margin_bottom
extern gtk_widget_set_margin_start
extern gtk_widget_set_margin_end
extern gtk_label_set_text
extern gtk_entry_get_text
extern gtk_entry_buffer_new
extern sprintf
extern secantMethod

section .bss
    window: resq 1
    gbox: resq 1
    a_label: resq 1
    a_spin: resq 1
    b_label: resq 1
    b_spin: resq 1
    it_label: resq 1
    it_spin: resq 1
    button: resq 1
    output_label: resq 1

section .rodata
    signal:
    .destroy: db "destroy", 0
    .clicked: db "clicked", 0

section .data
    title: db "secantMethod", 0
    a_label_text: db "a = ", 0
    b_label_text: db "b = ", 0
    it_label_text: db "iterations = ", 0
    button_label: db "calc", 0
    err_msg_text: db "Ошибочка", 0
    
    border_val: dq 0.0
    border_min: dq -100.0
    border_it_min: dq 1.0
    border_max: dq 100.0
    border_inc_step: dq 0.1
    border_inc_int_step: dq 1.0

    a: dq 0.0
    b: dq 0.0
    it: dq 0

    float_buffer: dq 0
    float_format: db "%lf", 0

    int_buffer: dq 0
    int_format: db "%d", 0

    res_format: db "res = %lf", 0
    res_buffer: db 128 dup (0)

section .text
    _destroy_window:
        jmp gtk_main_quit

    _on_button_clicked:
        push rbp
        mov rbp, rsp

        mov rdi, qword [rel b_spin]
        call gtk_spin_button_get_value
        movq qword [b], xmm0

        mov rdi, qword [rel a_spin]
        call gtk_spin_button_get_value
        movq qword [a], xmm0

        mov rdi, qword [rel it_spin]
        call gtk_spin_button_get_value
        cvtsd2si rax, xmm0
        mov qword [it], rax

        movq xmm0, qword [a]
        movq xmm1, qword [b]
        mov rdi, qword [it]

        call secantMethod
        cmp rdx, 0
        jne _err

    _ok:
        mov rax, 1
        mov rdi, res_buffer
        mov rsi, res_format
        call sprintf

        mov rdi, qword [rel output_label]
        mov rsi, res_buffer
        call gtk_label_set_text

        pop rbp
        ret

    _err:
        mov rdi, qword [rel output_label]
        mov rsi, err_msg_text
        call gtk_label_set_text

        pop rbp
        ret

    main:
        push rbp
        mov rbp, rsp
        xor rdi, rdi
        xor rsi, rsi
        call gtk_init

        xor rdi, rdi
        call gtk_window_new
        mov qword [ rel window ], rax

        mov rdi, qword [ rel window ]
        mov rsi, title
        call gtk_window_set_title

        mov rdi, qword [ rel window ]
        mov rsi, GTK_WIN_WIDTH
        mov rdx, GTK_WIN_HEIGHT
        call gtk_window_set_default_size

        mov rdi, qword [ rel window ]
        mov rsi, GTK_WIN_POS_CENTER
        call gtk_window_set_position

        mov rdi, qword [ rel window ]
        mov rsi, signal.destroy
        mov rdx, _destroy_window
        xor rcx, rcx
        xor r8d, r8d
        xor r9d, r9d
        call g_signal_connect_data

        mov rdi, GTK_ORIENTATION_HORIZONTAL
        mov rsi, LAYOUT_BOX_SPACING
        call gtk_box_new
        mov qword [rel gbox], rax

        mov rdi, qword [rel window]
        mov rsi, qword [rel gbox]
        call gtk_container_add

        mov rdi, a_label_text
        call gtk_label_new
        mov qword [rel a_label], rax
        
        mov rdi, qword [rel gbox]
        mov rsi, qword [rel a_label]
        call gtk_container_add

        movq xmm0, qword [border_min]
        movq xmm1, qword [border_max]
        movq xmm2, qword [border_inc_step]

        call gtk_spin_button_new_with_range
        mov qword [rel a_spin], rax

        movq xmm0, qword [border_val]
        mov rdi, rax
        call gtk_spin_button_set_value

        mov rdi, qword [rel gbox]
        mov rsi, qword [rel a_spin]
        call gtk_container_add

        mov rdi, b_label_text
        call gtk_label_new
        mov qword [rel b_label], rax
        
        mov rdi, qword [rel gbox]
        mov rsi, qword [rel b_label]
        call gtk_container_add

        movq xmm0, qword [border_min]
        movq xmm1, qword [border_max]
        movq xmm2, qword [border_inc_step]

        call gtk_spin_button_new_with_range
        mov qword [rel b_spin], rax

        movq xmm0, qword [border_val]
        mov rdi, rax
        call gtk_spin_button_set_value

        mov rdi, qword [rel gbox]
        mov rsi, qword [rel b_spin]
        call gtk_container_add

        mov rdi, it_label_text
        call gtk_label_new
        mov qword [rel it_label], rax
        
        mov rdi, qword [rel gbox]
        mov rsi, qword [rel it_label]
        call gtk_container_add

        movq xmm0, qword [border_it_min]
        movq xmm1, qword [border_max]
        movq xmm2, qword [border_inc_int_step]

        call gtk_spin_button_new_with_range
        mov qword [rel it_spin], rax

        movq xmm0, qword [border_val]
        mov rdi, rax
        call gtk_spin_button_set_value

        mov rdi, qword [rel gbox]
        mov rsi, qword [rel it_spin]
        call gtk_container_add

        mov rdi, button_label
        call gtk_button_new_with_label
        mov qword [rel button], rax

        mov rdi, qword [rel gbox]
        mov rsi, qword [rel button]
        call gtk_container_add

        mov rdi, qword [rel button]
        mov rsi, signal.clicked
        mov rdx, _on_button_clicked
        xor rcx, rcx
        xor r8d, r8d
        xor r9d, r9d
        call g_signal_connect_data

        xor rdi, rdi
        call gtk_label_new
        mov qword [rel output_label], rax

        mov rdi, qword [rel gbox]
        mov rsi, qword [rel output_label]
        call gtk_container_add

        mov rdi, qword [ rel window ]
        call gtk_widget_show_all

        call gtk_main
        ret
