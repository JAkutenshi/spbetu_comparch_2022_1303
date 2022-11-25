assume cs:CODE, ds:DATA, ss:AStack

AStack  segment stack
    db 1024 dup(0)
AStack  ends

DATA    segment
    delay   dw 2000
    KEEP_CS dw 0    
    KEEP_IP dw 0	  
DATA    ends

CODE    segment

FUNC PROC FAR
    push ax                           
    push dx
    mov  dx, ax
    in   al, 61h                      
    push ax                           
    or   al, 00000011b                
    out  61h, al                     
    mov  al,  dl                      
    out  42h, al                      
    mov  cx, delay                    

; Задержка
SOUND_STOP:                      
    push cx
    mov  cx, delay
    SOUND_STOP_2:
        nop                           
        loop SOUND_STOP_2         
    pop  cx
    loop SOUND_STOP

    pop  ax
    and  al, 11111100b
    out  61h, al                      
    
    pop  dx                           
    pop  ax
    mov  al, 20h
   
    out  20h, al

    iret                              
FUNC ENDP

MAIN PROC FAR
    push ds
    xor  ax, ax
    push ax
    mov  ax, DATA
    mov  ds, ax
    mov  ah, 35h                    
    mov  al, 23h 
    int  21h                         
    mov  KEEP_CS, es              
    mov  KEEP_IP, bx 
    
    push ds                         
    mov  dx, offset FUNC 
    mov  ax, seg FUNC    
    mov  ds, ax                     
    mov  ah, 25h                    
    mov  al, 23h                    
    int  21h                        
    pop  ds
    
INPUT_CTRL_LOOP:                    
    in   al, 60h                   
    cmp  al, 1dh                    ; 1d - ctrl
    jne  INPUT_CTRL_LOOP            
INPUT_C_LOOP:
    in   al, 60h
    cmp  al, 9dh                    ; отжатие ctrl
    je   INPUT_CTRL_LOOP            
    cmp  al, 2eh                    ; 2e - c
    jne  INPUT_C_LOOP
    mov al, 10
    int  23h                      

    cli                             

    push ds
    mov  dx, KEEP_IP
    mov  ax, KEEP_CS
    mov  ds, ax
    mov  ah, 25h
    mov  al, 23h
    int  21h                        
    pop  ds

    sti                             

    ret

MAIN ENDP

CODE ENDS
END MAIN


