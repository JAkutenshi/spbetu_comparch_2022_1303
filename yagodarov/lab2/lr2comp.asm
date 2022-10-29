_eol equ '$'
_ind equ 2
_n1 equ 500
_n2 equ -50

assume cs:code, ds:data, ss:my_stack

my_stack segment stack
    dw 12 dup('?')
my_stack ends 

data segment 
    mem1 dw 0
    mem2 dw 0
    mem3 dw 0
    vec1 db 31, 32, 33, 34, 38, 37, 36, 35
    vec2 db 50, 60, -50, -60, 70, 80, -70, -80
    matr db -4, -3, 7, 8, -2, -1, 5, 6, -8, -7, 3, 4, -6, -5, 1, 2
data ends

code segment

; Main procedure
main proc far
    
    push ds 
    sub ax, ax
    push ax
    mov ax, data
    mov ds, ax

; Register addressing
    mov ax, _n1
    mov cx, ax
    mov bl, _eol
    mov bh, _n2
    
; Direct addressing
    mov mem2, _n2
    mov bx, offset vec1
    mov mem1, ax 

; Indirect addressing
    mov al, [bx]
    ; mov mem3, [bx]

; Based addressing
    mov al, [bx]+3
    mov cx, 3[bx]

; Indexed addressing
    mov di, _ind
    mov al, vec2[di]
    ; mov cx, vec2[di]

; Addressing with basing and indexing
    mov bx, 3
    mov al, matr[bx][di]
    ; mov cx, matr[bx][di]
    ; mov ax, matr[bx*4][di]

; Segment-based addressing verification
; Redefining a segment
; ---------------
; - First option
    mov ax, seg vec2
    mov es, ax
    mov ax, es:[bx]
    mov ax, 0

; - Second option
    mov es, ax
    push ds
    pop es
    mov cx, es:[bx-1]
    xchg cx, ax

; - Third option
    mov di, _ind
    mov es:[bx+di], ax

; - Fourth option
    mov bp, sp
    ; mov ax, matr[bp+bx]
    ; mov ax, matr[bp+di+si]
; ---------------

; Using stack segment
    push mem1
    push mem2
    mov bp, sp
    mov dx, [bp]+2
    
    pop ax 
    pop ax

    ret

main endp
; Main procedure ends

code ends
    
end main