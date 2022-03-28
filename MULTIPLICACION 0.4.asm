.model small
.data
num1          db 0,0,0,0,0,0,0,0,0,0,'$'    
decimales_1   db 0,1,2,3,4,5,6,7,8,9,'$'   

num2          db 0,0,0,0,0,0,0,0,0,0,'$'    
decimales_2   db 0,0,0,0,0,0,0,0,0,1,'$'   


over_flow_num_res db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$';multiplicaciones de 9 digitos por 9 digitos puden dar resultados de hasta 18 digitos
                                                                ;estos digitos son "atrapados por la variable de overflow 

over_flow_dec_res db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$'

mult_res db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$'

hay_overFlow db 00h ;bandera para que el en el resultado considere los digitos en over_flow_num_res
hay_acarreo db 00h 

aux db 00h
temp db 00h
.stack 
.code 
begin proc far
mov ax,@data
mov ds,ax
CALL MULTIPLICA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;IMPRIMIR RESULTADO
 
LEA DX,over_flow_num_res 
MOV AH,09
INT 21H  

MOV AH,02  
MOV DL,'.'
INT 21H

LEA DX,over_flow_dec_res 
MOV AH,09h
INT 21H

XOR AX,AX
INT  16H
begin endp 



MULTIPLICA PROC NEAR   
;MULTIPLICAR EL PRIMER DECIMAL DE NUM_2 CON CADA DECIMAL DE NUM_1 SIN IMPORTAR ACARREOS
MOV SI,09h ;indice del multiplicador
MOV DI,09h ;indice del multiplicando 
MOV BX,24h ;representa las posiciones de la suma dentro de la multiplicacion
MOV AUX,00h
MOV TEMP, 00h
siguiente_multiplicador_d:

    siguiente_multiplicando_d: 
        MOV AL,decimales_1[SI] ;movemos el multiplicador a  Al
        MOV DL,decimales_2[DI] ;movemos el multiplicando a Dl
        MUL Dl          ; AL*Dl resultado en Ax
        AAM                  ;desempacamos el resultado de la multiplicacion previa        
        
        SUB BL,AUX 
        ADD mult_res[BX],Al   ;agregamos la parte baja a la posicion de DI en num_res
        ADD mult_res[BX-1],Ah ;agregamos la parte alta a la siguiente posicion de DI en num_res         
;-------------------------------------------------------------------------------------
            ;MULTIPLICAR CADA ENTERO en num1 POR EL DECIMAL INDEXADO POR DI en decimales_2
             siguiente_multiplicando_e: 
             MOV AL,num1[SI] ;movemos el multiplicador a  Al
             MOV DL,decimales_2[DI] ;movemos el multiplicando a Dl
             MUL Dl          ; AL*Dl resultado en Ax
             AAM                  ;desempacamos el resultado de la multiplicacion previa                    
                    
            SUB BL,AUX 
            ADD mult_res[BX-2],Al   ;agregamos la parte baja a la posicion de DI en num_res
            ADD mult_res[BX-3],Ah ;agregamos la parte alta a la siguiente posicion de DI en num_res         
            ;DEC SI               ;decrementamos el indice del multiplicando   
            ;ADD BL,AUX
            ;INC AUX
            ;CMP SI,01H        
            ;JAE siguiente_multiplicando_e 
;-------------------------------------------------------------------------------------               
        
        DEC SI               ;decrementamos el indice del multiplicando   
        ADD BL,AUX
        INC AUX
        CMP SI,01H        
        JAE siguiente_multiplicando_d

        
                             ;incrementamos contador de posiciones de multiplicandos 
    MOV BX,24h
    MOV DI,09h               ;volvemos al primer indice de los multiplicandos  
    DEC DI                   ;decrementamos el indice del multiplicador
    INC TEMP
    MOV CL,temp
    MOV AUX,Cl
    CMP SI,01H
    ;JAE siguiente_multiplicador_e
            
MOV hay_overFlow,01h

XOR AX,AX
INT 16H    
    
    


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
acarreo_del_Acarreo:
MOV hay_acarreo,00h
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
MOV Al,over_flow_dec_res[SI] 
AAM
;;si es el primer numero decimal deselo a los enteros
cmp SI,0000h
JNE no_es_primero
JMP es_primero
;; 
no_es_primero:
ADD over_flow_dec_res[SI-1],Ah
MOV over_flow_dec_res[SI],Al 
DEC SI
JMP siguiente_Acarreo_decimal
es_primero:
;;--> es primero         
MOV over_flow_dec_res[SI],Al 
DEC SI
;;fin el primero

siguiente_Acarreo_decimal:
CMP SI,0FFFFh
JE fin_ajuste_AcarreoDecimal 
CMP over_flow_dec_res[SI],'$'
JE es_fin_decimal   
CMP over_flow_dec_res[SI],0Ah
JAE AcarreoDecimal


DEC SI
JNS siguiente_Acarreo_decimal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fin_ajuste_AcarreoDecimal:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;AJUSTAR LOS ACARREOS ENTEROS
MOV SI,09h  ;los resultados de multiplicaciones 9 enteros*9 enteros pueden llegar a tener hasta 18 digitos
JMP siguiente_Acarreo_entero      
; 
AcarreoEntero: 
MOV hay_acarreo,01h
MOV Al,over_flow_num_res[SI] 
AAM
ADD over_flow_num_res[SI-1],Ah
MOV over_flow_num_res[SI],Al 
DEC SI

siguiente_Acarreo_entero: 
CMP over_flow_num_res[SI],0Ah
JAE AcarreoEntero

DEC SI
JNS siguiente_Acarreo_entero

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CMP hay_acarreo,01h
JNE no_mas_acarreo_mul                       
JMP acarreo_del_Acarreo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
no_mas_acarreo_mul:

MOV DL,02h
MOV AH,02H
INT 21H   
XOR AX,AX
INT 16H
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera
MOV SI,13h
JMP inicia_ajuste
salta_fin:
DEC SI
JMP inicia_ajuste
inicia_ajuste:
MOV AL,over_flow_num_res[SI]
CMP AL,24h
JE salta_fin
ADD AL,30h
MOV over_flow_num_res[SI],AL
DEC SI
JNS inicia_ajuste 
;;ajustar la parte decimal
MOV SI,09h
JMP inicia_ajuste_d
salta_fin_d:
DEC SI
JMP inicia_ajuste_d
inicia_ajuste_d:
MOV AL,over_flow_dec_res[SI]
CMP AL,24h
JE salta_fin_d
ADD AL,30h
MOV over_flow_dec_res[SI],AL
DEC SI
JNS inicia_ajuste_d 

MOV over_flow_dec_res[0h],07h ;limpiar el acarreo                       
RET        
MULTIPLICA ENDP 
end begin