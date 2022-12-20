.586p
.MODEL FLAT, C
.CODE
function PROC C USES EDI ESI, Digits:dword, len:dword, LBInt:dword, NInt:dword, result:dword, medians:dword
 
    push eax
    push ebx
    push ecx
    push edi
    push esi
 
    mov ecx, len
    mov esi, Digits
    mov edi, LBInt
    mov eax, 0
 
cycle:
        mov ebx, 0
    iter:
        cmp ebx, NInt
        jge out_iter
        push eax 
        mov eax, [esi + 4 * eax]
        cmp eax, [edi + 4 * ebx]
        pop eax
        jl out_iter
        inc ebx
        jmp iter
 
    out_iter:
        dec ebx
        mov edi, result
        push eax
        mov eax, [edi + 4 * ebx]
        inc eax
        mov [edi + 4 * ebx], eax
        pop eax
        mov edi, LBInt
 
    next_num:
        inc eax
        cmp eax, len
        jg get_median
 
loop cycle
 
get_median:
 
    mov ecx, 0
    mov eax, 0
    mov edi, result
 
med_cycle:
    
    cmp ecx, NInt
    jge exit
    
    mov esi, medians
    mov ebx, [edi + 4*ecx]
    
    cmp ebx, 0
    je zero
    
    dec ebx
    shr ebx,1
    add ebx, eax
 
    add eax, [edi + 4*ecx]
    jmp upd
 
zero:
    push edi
    push eax
 
    mov edi, Digits
    mov eax, 0
    mov [esi + 4*ecx], eax
    
    pop eax
    pop edi
    
    inc ecx
    
    jmp med_cycle
    
    
upd:
    push edi
    push eax
    
    mov edi, Digits
    mov eax, [edi + 4*ebx]
    mov [esi + 4*ecx], eax
    
    pop eax
    pop edi
    
    inc ecx
 
jmp med_cycle
 
 
exit:
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop edi
    pop esi
ret
 
function ENDP
END