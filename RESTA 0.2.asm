.model small
.data
num1          db 0,0,0,0,0,0,0,0,0,9,'$'    
decimales_1   db 0,0,0,0,0,0,0,0,0,0,'$'   

num2          db 0,0,0,0,0,0,0,0,1,0,'$'    
decimales_2   db 0,0,0,0,0,0,0,0,0,0,'$'   

num_res       db 0,0,0,0,0,0,0,0,0,0,'$'  
decimales_Res db 0,0,0,0,0,0,0,0,0,0,'$' 

ajuste_decimales_1 db 0,0,0,0,0,0,0,0,0,0,'$' 

AUX DB 00h

es_negativo_res db 00h                                                 
                                                 
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
;DETERMINAR CUAL NUMERO ES MAYOR
;reccorer el num1 y num2 desde la posicion 0 
MOV SI,00h

cual_es_mayor_res:
INC SI
MOV AL,num2[SI] 

;COMPARAR NUM1 CON NUM2
CMP num1[SI],AL
;si num1 es mayor ya podemos restar 
JA  acomodados_para_la_resta
;si son iguales
JE  iguales
;si no significa que num2 es mayor
JMP  num2_mayor

acomodados_para_la_resta:
JMP ya_puedes_restar 

iguales:
CMP SI,09h
MOV es_negativo_res,00h ;no hay signo en la parte entera 
;si el el fin de cadena ambos numeros son exactamente iguales
JE acomodados_para_la_resta     
JMP cual_es_mayor_res

num2_mayor:
MOV es_negativo_res,01h
;copiamos el numero mayor (num2) a la variable temporal ajuste_decimales_1
MOV SI,00h                   
num2_mayor_cpy:
MOV AL,num2[SI]
MOV ajuste_decimales_1[SI],AL
INC SI 
CMP SI,09h
JLE num2_mayor_cpy
;copiamos el numero (num1) menor a num2
MOV SI,00h                   
num2_menor_cpy:
MOV AL,num1[SI]
MOV num2[SI],AL
INC SI 
CMP SI,09h
JLE num2_menor_cpy 
;copiamos el numero mayor guardado en ajuste_decimales_1 a num1
MOV SI,00h                   
num1_ajuste_cpy:
MOV AL,ajuste_decimales_1[SI]
MOV num1[SI],AL     
MOV ajuste_decimales_1[SI],00h ;limpiamos la variable temporal 
INC SI 
CMP SI,09h
JLE num1_ajuste_cpy
;;INVERTIR LOS DECIMALES TAMBIEN
;------------------------------------------------------------------
;copiamos el numero mayor (decimales_2) a la variable temporal ajuste_decimales_1
MOV SI,00h                   
dec2_mayor_cpy:
MOV AL,decimales_2[SI]
MOV ajuste_decimales_1[SI],AL
INC SI 
CMP SI,09h
JLE dec2_mayor_cpy
;copiamos el numero (decimales_1) menor a decimales_2
MOV SI,00h                   
dec2_menor_cpy:
MOV AL,decimales_1[SI]
MOV decimales_2[SI],AL
INC SI 
CMP SI,09h
JLE dec2_menor_cpy 
;copiamos el numero mayor guardado en ajuste_decimales_1 a decimales_1
MOV SI,00h                   
dec1_ajuste_cpy:
MOV AL,ajuste_decimales_1[SI]
MOV decimales_1[SI],AL     
MOV ajuste_decimales_1[SI],00h ;limpiamos la variable temporal 
INC SI 
CMP SI,09h
JLE dec1_ajuste_cpy
;------------------------------------------------------------------

ya_puedes_restar:

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
JE prestamo_desde_los_enteros
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera
MOV SI,09h
JMP inicia_ajuste_res
salta_fin_res:
DEC SI
JMP inicia_ajuste_res
inicia_ajuste_res:
MOV AL,num_res[SI]
CMP AL,24h
JE salta_fin_res
ADD AL,30h
MOV num_res[SI],AL
DEC SI
JNS inicia_ajuste_res 
;;ajustar la parte decimal
MOV SI,09h
JMP inicia_ajuste_d_res
salta_fin_d_res:
DEC SI
JMP inicia_ajuste_d_res
inicia_ajuste_d_res:
MOV AL,decimales_Res[SI]
CMP AL,24h
JE salta_fin_d_res
ADD AL,30h
MOV decimales_Res[SI],AL
DEC SI
JNS inicia_ajuste_d_res 

MOV decimales_Res[0h],07h ;limpiar el acarreo



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;NO OLVIDES AGREGAR Y LIMPIAR EL SIGNO DEL RESULTADO MARCADO EN LA VARIABLE hay_signo 
;CALL AJUSTE_PARA_IMPRESION
RET    
RESTA ENDP
end begin