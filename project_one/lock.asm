.model small
.stack 100h
.data
    correct_pin db '1234', '$'
    input_pin db 5 dup('$')
    msg_welcome db 'Enter 4-digit PIN:', 13, 10, '$'
    msg_success db 'Access Granted!', 13, 10, '$'
    msg_failure db 'Access Denied!', 13, 10, '$'
    msg_locked  db 'System Locked.', 13, 10, '$'
.code
main:
    mov ax, @data
    mov ds, ax

    mov cx, 3              ; Allow 3 attempts

try_again:
    ; Show welcome message
    lea dx, msg_welcome
    mov ah, 09h
    int 21h

    ; Take 4-digit input
    lea si, input_pin
    mov bx, 0

read_loop:
    mov ah, 01h            ; Read a character
    int 21h
    mov [si+bx], al        ; Store input
    mov dl, al             ; Echo input
    mov ah, 02h
    int 21h
    inc bx
    cmp bx, 4
    jne read_loop
    mov [si+bx], '$'       ; Null-terminate string

    ; Compare input_pin with correct_pin
    lea si, input_pin
    lea di, correct_pin
    mov bx, 0
    mov dx, 0              ; Match flag: 0 = match, 1 = mismatch

compare_loop:
    mov al, [si+bx]
    mov ah, [di+bx]
    cmp al, ah
    jne not_matched
    inc bx
    cmp bx, 4
    jne compare_loop
    jmp matched

not_matched:
    mov dx, 1              ; set mismatch flag

matched:
    cmp dx, 0
    je show_success

    ; If mismatch
    lea dx, msg_failure
    mov ah, 09h
    int 21h
    loop try_again
    jmp locked

show_success:
    lea dx, msg_success
    mov ah, 09h
    int 21h
    jmp exit

locked:
    lea dx, msg_locked
    mov ah, 09h
    int 21h

exit:
    mov ah, 4ch
    int 21h
end main
