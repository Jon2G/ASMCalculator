.model small
.stack
.data 
num_res       db 0,0,0,0,0,0,0,0,0,2,'$'  
decimales_Res db 0,0,0,0,0,0,0,0,0,2,'$' 
.code
begin proc FAR
MOV AX,@DATA
MOV DS,AX
repito:
XOR AX,AX
INT 16H 
CALL AJUSTE_CEROS_IZQUIERDA
JMP repito
begin endp 

AJUSTE_CEROS_IZQUIERDA PROC NEAR
;;REMOVER LOS CEROS A LA IZUIERDA DEL RESULTADO Y REEMPLAZARLOS CON 20h
;;ajustar la parte entera
MOV DI,00h
siguiente_cero:
CMP num_res[DI],0h
JNE no_hay_mas_ceros_enteros;si el numero es diferente de cero ya terminamos el ajuste  
;si es cero removerlo!
MOV num_res[DI],20h 
INC DI
CMP DI,08h ;evitar el ultimo cero por si el resultado es cero (0+0=0)
JLE siguiente_cero       

;;ajustar la parte decimal
no_hay_mas_ceros_enteros:  

MOV DI,00h
siguiente_cero_decimal:
CMP decimales_Res[DI],0h
JNE fin_ajuste_cero_decimal;si el numero es diferente de cero ya terminamos el ajuste  
;si es cero removerlo!
MOV decimales_Res[DI],20h 
INC DI
CMP DI,08h ;evitar el ultimo cero por si el resultado es cero (0+0=0)
JLE siguiente_cero_decimal
fin_ajuste_cero_decimal:     
RET
AJUSTE_CEROS_IZQUIERDA ENDP 
end begin