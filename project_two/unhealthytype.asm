.model small
.stack 100h

.data
    warning_msg db 0Dh, 0Ah, 'Warning: Your typing is unhealthy!', 0Dh, 0Ah, '$'
    counter db 0

.code
org 100h

start:
    ; Jump over data declarations
    jmp main

main:
    ; Set data segment
    mov ax, @data
    mov ds, ax

check_key:
    ; Wait for key press
    mov ah, 00h
    int 16h
    ; AL = ASCII, AH = Scan code

    mov bl, ah  ; Save scan code for later

    ; Check if key is '5'
    cmp al, '5'
    je increment_counter

    ; Reset counter for non-'5' keys
    mov counter, 0
    jmp check_exit

increment_counter:
    inc counter
    cmp counter, 5
    jl check_exit

    ; Display warning message
    mov ah, 09h
    mov dx, offset warning_msg
    int 21h

    ; Reset counter
    mov counter, 0

check_exit:
    cmp bl, 01h      ; ESC key scan code
    jne check_key

    ; Terminate program
    mov ax, 4C00h
    int 21h

end start
