DOSSEG                                      
   .MODEL  SMALL                               
   .STACK  100h                                
   .DATA                                       
Greeting  LABEL  BYTE                          
   DB 'Вас приветствует ст.гр.1303 - Королева П.А.',13,10,'$'
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
