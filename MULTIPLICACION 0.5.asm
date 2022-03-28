.model small
.data
;num1          db 0,1,2,3,4,5,6,7,8,9,'$'    
;decimales_1   db 0,1,2,3,4,5,6,7,8,9,'$'   

;num2          db 0,1,2,3,4,5,6,7,8,9,'$'    
;decimales_2   db 0,1,2,3,4,5,6,7,8,9,'$'  
;num1          db 0,0,0,0,0,0,0,5,3,1,'$'    
;decimales_1   db 0,3,1,0,0,0,0,0,0,0,'$'   

;num2          db 0,0,0,0,0,0,0,0,1,7,'$'    
;decimales_2   db 0,0,0,0,0,0,0,0,0,0,'$'                                   
                                 ;.
;num_1_mult db 0,1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,'$'
;num_2_mult db 0,1,2,3,4,5,6,7,8,9,1,2,3,4,5,6,7,8,9,'$' 

num_1_mult db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,1,7,'$'
num_2_mult db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,1,4,'$'

over_flow_res db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
num_res_mult db  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$' 
;over_flow_num_res db 0,0,0,0,0,0,0,0,0,0     ;multiplicaciones de 9 digitos por 9 digitos puden dar resultados de hasta 18 digitos
;num_res           db 0,0,0,0,0,0,0,0,0,0,'$' ;estos digitos son "atrapados por la variable de overflow 

;over_flow_dec_res db 0,0,0,0,0,0,0,0,0,0
;decimales_Res     db 0,0,0,0,0,0,0,0,0,0,'$' 

hay_overFlow db 00h ;bandera para que el en el resultado considere los digitos en over_flow_num_res
hay_acarreo db 00h 

aux db 00h
.stack 
.code 
begin proc far
mov ax,@data
mov ds,ax
CALL MULTIPLICA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;IMPRIMIR RESULTADO
 
LEA DX,num_res_mult 
MOV AH,09
INT 21H  

XOR AX,AX
INT  16H
begin endp 



MULTIPLICA PROC NEAR
;MULTIPLICAR PARTES ENTERAS SIN IMPORTAR ACARREOS
MOV SI,12h ;indice del multiplicador
MOV DI,12h ;indice del multiplicando 
MOV BX,00h ;representa las posiciones de la suma dentro de la multiplicacion

siguiente_multiplicador_e:

    siguiente_multiplicando_e: 
        MOV AL,num_1_mult[SI] ;movemos el multiplicador a  Al
        MOV DL,num_2_mult[DI] ;movemos el multiplicando a Dl
        MUL Dl          ; AL*Dl resultado en Ax
        AAM                  ;desempacamos el resultado de la multiplicacion previa        
        
        SUB DI,BX                ;decrementamos Di por la posicion de los multiplicandos
        ADD num_res_mult[DI],Al   ;agregamos la parte baja a la posicion de DI en num_res
        ADD num_res_mult[DI-1],Ah ;agregamos la parte alta a la siguiente posicion de DI en num_res         
        ADD DI,BX            ;restauramos Di para obtener la posicion real de el siguiente multiplicando
        DEC DI               ;decrementamos el indice del multiplicando   
        CMP DI,01H
        JAE siguiente_multiplicando_e
                             ;incrementamos contador de posiciones de multiplicandos 
    INC BX                   ;incrementamos el desplazamiento de la suma
    MOV DI,12h               ;volvemos al primer indice de los multiplicandos  
    DEC SI                   ;decrementamos el indice del multiplicador
    CMP SI,01H
    JAE siguiente_multiplicador_e
            
MOV hay_overFlow,01h


XOR AX,AX
INT 16H
acarreo_del_Acarreo:
MOV hay_acarreo,00h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;AJUSTAR LOS ACARREOS ENTEROS
MOV SI,25h  ;los resultados de multiplicaciones 9 enteros*9 enteros pueden llegar a tener hasta 18 digitos
JMP siguiente_Acarreo_entero      
; 
AcarreoEntero: 
MOV hay_acarreo,01h
MOV Al,over_flow_res[SI] 
AAM
ADD over_flow_res[SI-1],Ah
MOV over_flow_res[SI],Al 
DEC SI

siguiente_Acarreo_entero: 
CMP over_flow_res[SI],0Ah
JAE AcarreoEntero

DEC SI
JNS siguiente_Acarreo_entero

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CMP hay_acarreo,01h
JNE no_mas_acarreo_mul                       
JMP acarreo_del_Acarreo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
no_mas_acarreo_mul:

;;CONJUGAR LA PARTE ENTERA CON LA PARTE DECIMAL
;;AGREGANDO COMO DESPLAZAMIENTO LA CANTIDAD DE DIGITOS DECIMALES QUE CONTIENE 
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
MOV AL,num_res_mult[SI]
CMP AL,24h
JE salta_fin
ADD AL,30h
MOV num_res_mult[SI],AL
DEC SI
JNS inicia_ajuste 
                      
RET        
MULTIPLICA ENDP 
end begin