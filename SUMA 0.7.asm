.model small
.data
num1          db 0,0,0,0,0,0,1,7,7,7,'$'    
decimales_1   db 0,6,5,7,0,0,0,0,0,0,'$'   

num2          db 0,0,0,0,0,0,0,0,0,5,'$'    
decimales_2   db 0,4,6,0,0,0,0,0,0,0,'$'   

num_res       db 0,0,0,0,0,0,0,0,0,0,'$'  
decimales_Res db 0,0,0,0,0,0,0,0,0,0,'$' 

hay_acarreo db 0h
.stack 
.code 
begin proc far
mov ax,@data
mov ds,ax
CALL SUMA
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

XOR AX,AX
INT  16H
begin endp 
;;;;;;;;;;;PROCEDIMIENTOS
SUMA PROC NEAR
;SUMAR PARTES ENTERAS SIN IMPORTAR ACARREOS
MOV SI,09h
JMP siguiente_entero
fin_enteros:
MOV num_res[SI],'$' 
DEC SI
JMP siguiente_entero


siguiente_entero:
MOV AL,num1[SI]
CMP AL,24h ;si es el fin de cadena
JE fin_enteros 
ADD AL,num2[SI] 

MOV num_res[SI],AL 

DEC SI
JNS siguiente_entero 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV num1[0Ah],'$' 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SUMAR PARTES DECIMALES SIN IMPORTAR ACARREOS
MOV SI,0Ah
JMP siguiente_decimal
fin_decimales:
MOV decimales_Res[SI],'$'
DEC SI
JMP siguiente_decimal
 
siguiente_decimal:
MOV AL,decimales_1[SI] 
CMP AL,24h ;si es el fin de cadena
JE fin_decimales
ADD AL,decimales_2[SI]

MOV decimales_Res[SI],AL  

DEC SI
JNS siguiente_decimal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
JMP primer_vezSumando
acarreo_del_Acarreo:
MOV hay_acarreo,00h
primer_vezSumando:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;AJUSTAR LOS ACARREOS DECIMALES
MOV SI,0Ah 
JMP siguiente_Acarreo_decimal    
;
es_fin_decimal:
DEC SI    
JMP siguiente_Acarreo_decimal
; 
AcarreoDecimal:           
MOV hay_acarreo,01h
MOV Al,decimales_Res[SI] 
AAM
;;si es el primer numero decimal deselo a los enteros
cmp SI,0000h
JNE no_es_primero
JMP es_primero
;; 
no_es_primero:
ADD decimales_Res[SI-1],Ah
MOV decimales_Res[SI],Al 
DEC SI
JMP siguiente_Acarreo_decimal
es_primero:
;;--> es primero         
MOV decimales_Res[SI],Al 
DEC SI
;;fin el primero

siguiente_Acarreo_decimal:
CMP SI,0FFFFh
JE fin_ajuste_AcarreoDecimal 
CMP decimales_Res[SI],'$'
JE es_fin_decimal   
CMP decimales_Res[SI],0Ah
JAE AcarreoDecimal


DEC SI
JNS siguiente_Acarreo_decimal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fin_ajuste_AcarreoDecimal:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;AJUSTAR LOS ACARREOS ENTEROS
MOV SI,09h
JMP siguiente_Acarreo_entero
;
es_fin_entero:
DEC SI        
;MOV posicion_ultimo_entero,SI
JMP siguiente_Acarreo_entero
; 
AcarreoEntero: 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CMP SI,0000h
MOV hay_acarreo,01h
MOV Al,num_res[SI] 
AAM

ADD num_res[SI-1],Ah
MOV num_res[SI],Al 
DEC SI

siguiente_Acarreo_entero:

CMP decimales_Res[SI-1],'$'
JE es_fin_entero  
CMP num_res[SI],0Ah
JAE AcarreoEntero


DEC SI
JNS siguiente_Acarreo_entero
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 
;;;;;;;;;;;;;;;;AGREGAR ACARREOS PENDIENTES
MOV AL,num_res[09h]
ADD AL,decimales_Res[0h]
MOV num_res[09h],Al 
MOV decimales_Res[0h],00h ;limpiar el acarreo    

CMP hay_acarreo,01h                       
JE acarreo_del_Acarreo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera
MOV SI,09h
JMP inicia_ajuste
salta_fin:
DEC SI
JMP inicia_ajuste
inicia_ajuste:
MOV AL,num_res[SI]
CMP AL,24h
JE salta_fin
ADD AL,30h
MOV num_res[SI],AL
DEC SI
JNS inicia_ajuste 
;;ajustar la parte decimal
MOV SI,09h
JMP inicia_ajuste_d
salta_fin_d:
DEC SI
JMP inicia_ajuste_d
inicia_ajuste_d:
MOV AL,decimales_Res[SI]
CMP AL,24h
JE salta_fin_d
ADD AL,30h
MOV decimales_Res[SI],AL
DEC SI
JNS inicia_ajuste_d 

MOV decimales_Res[0h],07h ;limpiar el acarreo                       
RET        
SUMA ENDP
end begin