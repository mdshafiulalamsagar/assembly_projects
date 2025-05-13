org 100h           

jmp start          


warning_msg db 0Dh, 0Ah, 'Warning: Your typing is unhealthy!', 0Dh, 0Ah, '$'
counter      db 0


start:


check_key:
    mov ah, 00h
    int 16h        
    mov bl, ah       

    inc counter
    cmp counter, 5
    jl check_exit    

    ; Print message
    mov ah, 09h
    mov dx, offset warning_msg
    int 21h

    ; Reset counter
    mov counter, 0

check_exit:
    cmp bl, 01h       
    jne check_key     

    ; Exit program
    mov ax, 4C00h
    int 21h
