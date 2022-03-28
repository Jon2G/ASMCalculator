.model small
.data
num1          db 0,0,0,0,0,0,0,0,1,7,'$'    
decimales_1   db 0,5,0,0,0,0,0,0,0,0,'$'   

num2          db 0,0,0,0,0,0,0,0,2,2,'$'    
decimales_2   db 0,9,6,0,0,0,0,0,0,0,'$'   

num_res       db 0,0,0,0,0,0,0,0,0,0,'$'  
decimales_Res db 0,0,0,0,0,0,0,0,0,0,'$' 

AUX DB 00h

hay_acarreo db 00h                                                 
                                                 
;;num1 >num2
.stack 
.code 
begin proc far
mov ax,@data
mov ds,ax

CALL RESTA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;IMPRIMIR RESULTADO
 
LEA DX,num_res 
MOV AH,09
INT 21H  

MOV AH,02  
MOV DL,'.'
INT 21H

LEA DX,decimales_Res 
MOV AH,09
INT 21H

MOV AX,0
INT  16H
begin endp 
;;;;;;;;;;;PROCEDIMIENTOS
RESTA PROC NEAR
;RESTAR PARTES DECIMALES
MOV SI,09h  ;asigna a SI 9 (la ultima posicion del numero)

JMP siguiente_decimal_res ;salta a la etiqueta siguiente_entero_res

fin_decimal_res:
MOV decimales_Res[SI],'$' 
DEC SI
JMP siguiente_decimal_res


siguiente_decimal_res:
MOV AL,decimales_1[SI]   
CMP AL,24h          ;si es el fin de cadena
JE fin_decimal_res 



CMP AL,decimales_2[SI] ;compara al y
JL pide_prestado_d

JMP resta_conNormalidad_d

pide_prestado_d:
CMP SI,0000h
JE prestamo_desde_los_enteros:
DEC decimales_1[SI-1]
ADD decimales_1[SI],0Ah

resta_conNormalidad_d:
MOV AL,decimales_1[SI]
SUB AL,decimales_2[SI] 

MOV decimales_Res[SI],AL 


DEC SI
JNS siguiente_decimal_res   
JMP enteros_res
;AJUSTAR ACARREO DECIMAL NEGATIVO PARA LOS ENTEROS
prestamo_desde_los_enteros:
DEC num1[09h]
MOV decimales_Res[0h],00h ;limpiar el acarreo    

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

enteros_res:
;RESTAR PARTES ENTERAS

MOV SI,09h  ;asigna a SI 9 (la ultima posicion del numero)

JMP siguiente_entero_res ;salta a la etiqueta siguiente_entero_res

fin_enteros_res:
MOV num_res[SI],'$' 
DEC SI
JMP siguiente_entero_res


siguiente_entero_res:
MOV AL,num1[SI]   
CMP AL,24h          ;si es el fin de cadena
JE fin_enteros_res 



CMP AL,num2[SI] ;compara al y
JL pide_prestado_e

JMP resta_conNormalidad_e

pide_prestado_e:
DEC num1[SI-1]
ADD num1[SI],0Ah

resta_conNormalidad_e:
MOV AL,num1[SI]
SUB AL,num2[SI] 

MOV num_res[SI],AL 


DEC SI
JNS siguiente_entero_res 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 

RET    
ENDP
end begin