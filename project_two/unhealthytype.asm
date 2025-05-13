.model small
.stack 100h

.data
    warning_msg db 0Dh, 0Ah, 'Warning: Your typing is unhealthy!', 0Dh, 0Ah, '$'
    counter db 0

.code
org 100h    ; For .COM file structure

start:
    ; Jump over data declarations
    jmp main

main proc
    ; Set data segment
    mov ax, @data
    mov ds, ax

check_key:
    ; Wait for key press (AH = scan code, AL = ASCII)
    mov ah, 00h
    int 16h

    ; Check if key is '5'
    cmp al, '5'
    je increment_counter

    ; Reset counter for non-'5' keys
    mov counter, 0
    jmp check_exit

increment_counter:
    ; Increase counter and check if >=5
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
    ; Exit if Esc pressed (scan code 01h)
    cmp ah, 01h
    jne check_key

    ; Terminate program
    mov ax, 4C00h
    int 21h
main endp

end start
