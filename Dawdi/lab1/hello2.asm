; HELLO2 - �祡��� �ணࠬ�� N2  ���.ࠡ.#1 �� ���樯���� "���⥪��� ��������"
;          �ணࠬ�� �ᯮ���� ��楤��� ��� ���� ��ப�
;
;      �����  ���������

EOFLine  EQU  '$'         ; ��।������ ᨬ���쭮� ����⠭��
                          ;     "����� ��ப�"

; �⥪  �ணࠬ��

ASSUME CS:CODE, SS:AStack

AStack    SEGMENT  STACK
          DW 12 DUP('!')    ; �⢮����� 12 ᫮� �����
AStack    ENDS

; ����� �ணࠬ��

DATA      SEGMENT

;  ��४⨢� ���ᠭ�� ������

HELLO     DB 'Hello Worlds!', 0AH, 0DH,EOFLine
GREETING  DB 'Student from 4350 - $'
DATA      ENDS

; ��� �ணࠬ��

CODE      SEGMENT
; ��楤�� ���� ��ப�
WriteMsg  PROC  NEAR
          mov   AH,9
          int   21h  ; �맮� �㭪樨 DOS �� ���뢠���
          ret
WriteMsg  ENDP

; �������� ��楤��
Main      PROC  FAR
          push  DS       ;\  ���࠭���� ���� ��砫� PSP � �⥪�
          sub   AX,AX    ; > ��� ��᫥���饣� ����⠭������� ��
          push  AX       ;/  ������� ret, �������饩 ��楤���.
          mov   AX,DATA             ; ����㧪� ᥣ���⭮��
          mov   DS,AX               ; ॣ���� ������.
          mov   DX, OFFSET HELLO    ; �뢮� �� �࠭ ��ࢮ�
          call  WriteMsg            ; ��ப� �ਢ���⢨�.
          mov   DX, OFFSET GREETING ; �뢮� �� �࠭ ��ன
          call  WriteMsg            ; ��ப� �ਢ���⢨�.
          ret                       ; ��室 � DOS �� �������,
                                    ; ��室�饩�� � 1-�� ᫮�� PSP.
Main      ENDP
CODE      ENDS
          END Main