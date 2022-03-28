pila segment para stack 'stack'
db 100 dup(0)
pila ends     

datos segment para 'data'
mensaje db "Hola",07,13,10,"$"  
;
pixfila_a dw 80
pixcol_a dw 140
;
datos ends

codigo segment para 'code'
     
     assume cs:codigo,ds:datos,ss:pila
     
     begin proc FAR
     
        mov ax,datos
        mov ds,ax
        
        mov dx,offset mensaje
        mov ah,09
        int 21h
        ;
        macro_letra_a MACRO pixf,pixc
local pinta1a,pinta2a,pinta3a,pinta4a
MOV DL, 0
MOV DH,0
MOV ax,pixf
MOV bx,320
MUL bx
ADD ax,pixc
MOV DI,ax
MOV AL,15

MOV cx, DI
ADD cx, 30

pinta1h:
         MOV ES:[DI], AL
         ADD DI, 320
         INC DL
         CMP DL, 30
         jbe pinta1h

         MOV ax,320
         MOV bx,10
         MUL bx
         SUB DI,ax

         MOV AL,15

pinta2h:
         MOV ES:[DI], AL
         INC DI
         INC DH
         CMP DH, 30
         jbe pinta2h

         MOV DL, 0
         MOV DI,cx

pinta3h:
         MOV ES:[DI], AL
         ADD DI, 320
         INC DL
         CMP DL, 30
         jbe pinta3h
         
         MOV DL, 0
         MOV DI,cx

pinta4h:
         MOV ES:[DI], AL
         INC DI
         INC DH
         CMP DH, 30
         jbe pinta4h

         
      ENDM

MOV AX,datos
MOV DS,AX

MOV ah,0
MOV al,13h
int 10h

MOV AX, 0A000h
MOV ES, AX

macro_letra_a pixfila_a,pixcol_a

MOV AH,0
INT 16h

CMP AX, 011Bh
JE SALIR
        ;
       SALIR: mov ah,4ch
        int 21h  
     begin endp
codigo ends
end begin