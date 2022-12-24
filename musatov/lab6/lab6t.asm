.MODEL FLAT, C
.CODE

func PROC C numRanDat: dword, nInt: dword, nums: dword, ints: dword, res: dword
    push esi
    push edi
    push eax
    push ebx
    push ecx
    push edx
    mov ecx, numRanDat
    mov esi, nums
    mov edi, ints
    mov eax, 0
    mov edx, nInt
    inc edx
    lp:
        mov ebx, 0
        checking:
            cmp ebx, edx
            jge skip
            push eax
            mov eax, [esi + eax * 4]
            cmp eax, [edi + ebx * 4]
            pop eax
            jl out_num
            inc ebx
            jmp checking
        out_num:
            dec ebx
            cmp ebx, -1
            je skip
            push ecx
            mov ecx, [esi + eax * 4]
            test ecx, 1
            pop ecx
            jz skip
            mov esi, res
            push eax
            mov eax, [esi + ebx * 4]
            inc eax
            mov [esi + ebx * 4], eax
            pop eax
            mov esi, nums
        skip:
            inc eax
    loop lp
    finish:
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop edi
    pop esi
    ret
func ENDP
END