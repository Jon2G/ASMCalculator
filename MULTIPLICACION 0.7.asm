.model small
.data
num1          db 0,0,0,0,0,0,0,1,1,1,'$'    
decimales_1   db 0,0,0,0,0,0,0,0,0,0,'$'

num2          db 0,0,0,0,0,0,0,1,1,1,'$'    
decimales_2   db 0,0,0,0,0,0,0,0,0,0,'$'   

;;;--------------------------------------------------
;;;;;;;;OPERANDOS PARA LA MULTIPLICACION
num_1_mult db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$'
num_2_mult db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$'

Deci_1 db 00h 
Deci_2 db 00h 
Deci db 00h

over_flow_res db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
num_res_mult db  0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$' 
;multiplicaciones de 9 digitos por 9 digitos puden dar resultados de hasta 18 digitos
;estos digitos son "atrapados" por la variable de overflow 
 ;;;---------------------------------------------------------

num_res       db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$'  
decimales_Res db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$'
 
;hay_overFlow db 00h ;bandera para que el en el resultado considere los digitos en over_flow_num_res
hay_acarreo db 00h 

Aux db 00h
.stack 
.code 
begin proc far
mov ax,@data
mov ds,ax
CALL MULTIPLICA
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



MULTIPLICA PROC NEAR
;;CONTAR LA CANTIDAD DE DECIMALES EN CADA NUMERO
;PARA EL NUMERO 1
JMP inicia_cuenta_decimal1

aun_hay_decimales_1:
    INC Deci_1      
    DEC SI
    JMP deci1_contado
    
inicia_cuenta_decimal1:
    MOV Deci_1,09h
    MOV SI,09h     
    
    deci1_contado: 
        MOV Al,decimales_1[SI]
        CMP Al,00h
        JE  aun_hay_decimales_1
        INC Deci_1
        

MOV AX,SI
MOV Deci_1,Al
;PARA EL NUMERO 2
JMP inicia_cuenta_decimal2

aun_hay_decimales_2:
    INC Deci_2      
    DEC SI
    JMP deci2_contado
    
inicia_cuenta_decimal2:
    MOV Deci_2,00h
    MOV SI,09h     
    
    deci2_contado: 
        MOV Al,decimales_2[SI]
        CMP Al,00h
        JE  aun_hay_decimales_2
        INC Deci_2
        
MOV AX,SI
MOV Deci_2,Al

MOV AL,Deci_2
CMP AL,Deci_1
JE  igual_cantidad_decimales
JNE diferente_cantidad_deciamales
                            
diferente_cantidad_deciamales:
    MOV AL,Deci_2
    ADD AL,Deci_1 

igual_cantidad_decimales:
; 
    MOV AL,Deci_2
    ADD AL,Deci_1 
    ;
    MOV Deci,Al
                            
;SI NO TIENE DECIMALES
CMP Deci,00h
JS  sin_decimales
MOV Al,Deci
MOV Aux,Al
              
JMP ya_puedes_ajustar_mult:              
sin_decimales:         
MOV Al,00H 
Mov Deci,Al
MOV Aux,Al  
ya_puedes_ajustar_mult:

;COPIAR LOS NUMEROS DE LAS VARIABLES num1,decimales_1 y num1,decimales2 en sus partes ajustadas
;para la multiplicacion num_1_mult,num_2_mult
MOV SI,09h ;iniciamos el indice fuente en la ultima posicion de los decimales
MOV DI,12h ;iniciamos el indice fuente en la ultima posicion de las variables ajustadas para la suma

ajusta_dec1_mul:
MOV Al,decimales_1[SI]
MOV num_1_mult[DI],Al  
MOV decimales_1[SI],00h
DEC SI
DEC DI
CMP DI,09h
JA ajusta_dec1_mul

MOV SI,09h

ajusta_ent1_mul:
MOV Al,num1[SI]
MOV num_1_mult[DI],Al
MOV num1[SI],00h
DEC SI
DEC DI
CMP DI,00h
JA ajusta_ent1_mul 
;;para el numero dos
MOV SI,09h ;iniciamos el indice fuente en la ultima posicion de los decimales
MOV DI,12h ;iniciamos el indice fuente en la ultima posicion de las variables ajustadas para la suma

ajusta_dec2_mul:
MOV Al,decimales_2[SI]
MOV num_2_mult[DI],Al
MOV decimales_2[SI],00h
DEC SI
DEC DI
CMP DI,09h
JA ajusta_dec2_mul

MOV SI,09h

ajusta_ent2_mul:
MOV Al,num2[SI]
MOV num_2_mult[DI],Al
MOV num2[SI],00h
DEC SI
DEC DI
CMP DI,00h
JA ajusta_ent2_mul    

;MULTIPLICAR PARTES ENTERAS SIN IMPORTAR ACARREOS
MOV SI,12h ;indice del multiplicador
MOV DI,12h ;indice del multiplicando 
MOV BX,00h ;representa las posiciones de la suma dentro de la multiplicacion

siguiente_multiplicador_e:

    siguiente_multiplicando_e: 
        MOV AL,num_1_mult[SI] ;movemos el multiplicador a  Al
        MOV DL,num_2_mult[DI] ;movemos el multiplicando a Dl
        MUL Dl                ; AL*Dl resultado en Ax
        AAM                   ;desempacamos el resultado de la multiplicacion previa        
        
        SUB DI,BX                 ;decrementamos Di por la posicion de los multiplicandos
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
            
;MOV hay_overFlow,01h

acarreo_del_Acarreo_mul:
MOV hay_acarreo,00h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;AJUSTAR LOS ACARREOS ENTEROS
MOV SI,25h  ;los resultados de multiplicaciones 9 enteros*9 enteros pueden llegar a tener hasta 18 digitos
JMP siguiente_Acarreo_entero_mul      
; 
AcarreoEntero_mul: 
MOV hay_acarreo,01h
MOV Al,over_flow_res[SI] 
AAM
ADD over_flow_res[SI-1],Ah
MOV over_flow_res[SI],Al 
DEC SI

siguiente_Acarreo_entero_mul: 
CMP over_flow_res[SI],0Ah                       
JAE AcarreoEntero_mul

DEC SI
JNS siguiente_Acarreo_entero_mul

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CMP hay_acarreo,01h
JNE no_mas_acarreo_mul                       
JMP acarreo_del_Acarreo_mul
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
no_mas_acarreo_mul:

;;SEPARAR LA PARTE ENTERA DE LA PARTE DECIMAL
;;AGREGANDO COMO DESPLAZAMIENTO LA CANTIDAD DE DIGITOS DECIMALES QUE CONTIENE 
INC SI

;;AJUSTAR PARA IMPRESION
MOV SI,25h 
MOV DI,01h
JMP inicia_ajuste_mul
salta_ceros:
DEC SI
JMP inicia_ajuste_mul
inicia_ajuste_mul:
;si no tiene decimales
CMP Deci,00h
JE  sin_decimales_mul

MOV AL,over_flow_res[SI]
CMP AL,00h
JE salta_ceros
;;ADD AL,30h   
;;  
xor cx,cx
MOV Cl,Deci
MOV DI,CX
;;
MOV decimales_Res[DI],AL
;;
;MOV CX,DI
;SUB Cl,Aux
;MOV DI,CX 
;;
DEC Deci                
CMP Deci,00h
JE  despues_del_punto
INC DI
DEC SI 
JNS inicia_ajuste_mul 

JMP despues_del_punto
sin_decimales_mul:
;XOR AX,AX
;INT 16H  
MOV SI,14H
JMP despues_del_punto
despues_del_punto:
MOV DI,13h        
DEC SI

cpy_despues_del_punto:  
MOV AL,over_flow_res[SI]
MOV num_Res[DI],Al 
DEC SI
DEC DI
JNS cpy_despues_del_punto                     
;
;;AJUSTAR PARA IMPRESION TIPO ASCII
MOV SI,13h
JMP inicia_ajuste_ascii_mult
salta_fin_ascii:
DEC SI
JMP inicia_ajuste_ascii_mult
inicia_ajuste_ascii_mult:
MOV AL,num_res[SI]
CMP AL,24h
JE salta_fin_ascii
ADD AL,30h
MOV num_res[SI],AL
DEC SI
JNS inicia_ajuste_ascii_mult 
;;ajustar la parte decimal
MOV SI,13h
JMP inicia_ajuste_ascii_mult_d
salta_fin_d_mul:
DEC SI
JMP inicia_ajuste_ascii_mult_d
inicia_ajuste_ascii_mult_d:
MOV AL,decimales_Res[SI]
CMP AL,24h
JE salta_fin_d_mul
ADD AL,30h
MOV decimales_Res[SI],AL
DEC SI
JNS inicia_ajuste_ascii_mult_d

MOV decimales_Res[0h],07h ;limpiar el acarreo
;CALL AJUSTE_PARA_IMPRESION
RET        
MULTIPLICA ENDP 
end begin