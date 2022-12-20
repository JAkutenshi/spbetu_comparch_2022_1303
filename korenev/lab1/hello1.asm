DOSSEG
   .MODEL  SMALL
   .STACK  100h
   .DATA
Greeting  LABEL  BYTE
   DW 'Вас приветствует Коренев Д.А. из группы 1303!',13,10,'$'
   .CODE
   mov  ax, @data
   mov  ds, ax
   mov  dx, OFFSET Greeting
DisplayGreeting:
   mov  ah, 9
   int  21h
   mov  ah, 4ch
   int  21h
   END