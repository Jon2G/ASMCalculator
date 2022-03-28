.model small
.stack
.data 
posicion_entrada dw 0000h                                                            
aux db 00h
display_str  db "Utilice las fechas y el teclado numerico para navegar",14 DUP(0),'$'
resultado_str db "11.00+11.00=00000022.",20h,"000000000$"
num_res       db 0,0,0,0,0,0,0,0,2,2,'$'  
decimales_Res db 20h,0,0,0,0,0,0,0,0,0,'$'
.code
begin proc FAR
MOV AX,@DATA
MOV DS,AX
repito:
XOR AX,AX
INT 16H 
CALL AJUSTE_PARA_IMPRESION
JMP repito
begin endp 

AJUSTE_PARA_IMPRESION PROC NEAR
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera 
MOV aux,0h      
MOV SI,0000h

MOV CX,09H
ajusteAsciiEntero:
MOV AL,num_res[SI]
    ;si es espacio
    CMP AL,20h    
    JE  borralo
    JMP no_borres_enteros
    borralo:
        MOV AL,08h
        JMP regresa_borrar_enteros
no_borres_enteros:
ADD AL,30H

regresa_borrar_enteros:
;fin es espacio
MOV BX,0000h
MOV Bl,aux
MOV resultado_str[BX],AL
 
INC aux
INC SI 
DEC CX
JNS ajusteAsciiEntero

MOV BX,0000h
MOV Bl,aux
MOV resultado_str[BX],'.'

INC SI
INC aux

MOV DI,0000H       
MOV CX,09H
ajusteAsciiDecimal:
MOV AL,decimales_Res[DI]
    ;si es espacio
    CMP AL,20h    
    JE  borralo_decimales
    JMP no_borres_decimales
    borralo_decimales:
        MOV AL,08h
        JMP regresa_borrar_decimales
no_borres_decimales:
ADD AL,30H

regresa_borrar_decimales:
;fin es espacio
MOV BX,0000h
MOV Bl,aux
MOV resultado_str[BX],AL

INC aux
INC DI
INC SI                
DEC CX
JNS ajusteAsciiDecimal 

MOV BX,0000h
MOV Bl,aux
MOV resultado_str[BX],'$'      
RET
AJUSTE_PARA_IMPRESION ENDP 
end begin