.model small
.stack
.data
 display_str  db "123456789.1234567891+-+100.99",14 DUP(0),'$'
 num1          db 0,0,0,0,0,0,0,0,0,0,'$'    
decimales_1   db 0,0,0,0,0,0,0,0,0,0,'$'   
num2          db 0,0,0,0,0,0,0,0,0,0,'$'    
decimales_2   db 0,0,0,0,0,0,0,0,0,0,'$' 
ajuste_decimales_1 db 0,0,0,0,0,0,0,0,0,0,'$'  
ajuste_decimales_2 db 0,0,0,0,0,0,0,0,0,0,'$' 
POSICION_ENTRADA dw 0007h 
len_display dw 013h 
operacion db 00h    

num1_signo db 00h
num2_signo db 00h 

aux db 00h

es_negativo_res db 00h
.code
begin proc far
repito:     

MOV AX,@DATA
MOV DS,AX
 
CALL AJUSTA_OPERANDOS
XOR AX,AX
INT 16h
JMP repito    
begin endp   
AJUSTA_OPERANDOS PROC NEAR  
;en este procedimiento aux contiene el numero que estamos procesando
;0 para el numero_1 y 1 para el numero_2     
MOV aux,00h ;lo iniciamos en 0 para el primer operando
;LEER LA OPERACION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;LEER LA OPERACION DESDE EL PRIMER DIGITO MAS A LA IZQUIERDA
    MOV SI,00h

siguiente_caracter_de_entrada:
    
    MOV AL,display_str[SI]
    
    CMP Al,'-'
    JE signo_negativo_detectado
    CMP Al,'+'
    JE signo_positivo_detectado
    CMP Al,'x'  
    JE operador_detectado
    CMP Al,0F6h
    JE operador_detectado
    JMP numero     
        signo_negativo_detectado: 
                 CMP aux,00h ;si aux es 1 estamos procesando los signos del primer operando
                 JNE segundo_operando_negativo ;de lo contrario estamos procesando el signo de el segundo operando 
                 XOR num1_signo, 01b
                 JMP continue
                    segundo_operando_negativo: 
                    XOR num2_signo, 01b                                            

        signo_positivo_detectado:
                 CMP aux,00h ;si estamos en el primer operando se ignora el signo '+'
                 JNE posible_operacional_suma
                     ;si no se toma como signo operacional si es que no existe alguno de mayor jerarquia
                     ; como (*,/,-)
                 JMP continue       
        operador_detectado:
                 MOV operacion,Al  
                 JMP continue
        posible_operacional_suma: 
                 CMP operacion,'x'
                 JE continue 
                 CMP operacion,'-'
                 JE continue 
                 CMP operacion,0F6h ;entre ÷ (alt +246)
                 JE continue  
                 ;solo se asigna el operador suma si no existe uno de mayor jerarquia de lo contrario
                 ;el signo mas se considera un indicador de signo
                 MOV operacion,'+'
continue:
    INC SI    
;CMP SI,POSICION_ENTRADA 
;JL siguiente_caracter_de_entrada 
JMP siguiente_caracter_de_entrada     
    numero:         
    MOV DI,09h ;iniciamos el destino en la ultima posicion de los numeros enteros
    
    siguiente_numero:
    MOV AL,display_str[SI]
    CMP AL,'.' ;si se estan comenzando los numeros decimales
    JE decimal
    
    SUB AL,30h ;restamos 30h para obtener el numero real
    
    CMP AL,09h 
    JA no_mas_numero ;si ya terminaron los numeros
        
        ADD AL,30h
        CMP aux,00h
        JNE num_2_e ;si no es de el numero 1 y es entero    
            
            MOV num1[DI],Al    
            DEC DI
            JS mas_10_numeros
            JMP continue_numero        
            num_2_e: 
            MOV num2[DI],Al    
            DEC DI
            JS mas_10_numeros
            JMP continue_numero  
    
    continue_numero:
    INC SI
    JMP siguiente_numero
    
    no_mas_numero:
    
    XOR aux,01b ;si aux era 0 lo volvemos 1
    CMP aux,00h ;si aux es 0 ya terminamos ambos numeros
    JE termine
    JMP siguiente_caracter_de_entrada ;termino de llenar el numero procesado y regresa por mas 
                                      ;numero o simbolos si es que existen  
    JMP decimal
    mas_10_numeros:
    ;ERROR 10Mas_numeros
    RET
    
    decimal:    
    MOV DI,01h 
    continue_decimal:
    INC SI ;saltamos el punto decimal
    MOV Al,display_str[SI]
    CMP AL,'.'
    JE no_mas_numero_d
    CMP AL,'-'
    JE no_mas_numero_d
    CMP AL,'x'
    JE no_mas_numero_d 
    CMP AL,0F6h ;entre ÷ (alt +246)
    JE no_mas_numero_d
    
    JMP entrada_correcta_decimal 
    
    entrada_correcta_decimal:
        SUB AL,30h 
            CMP AL,09h 
            JA no_mas_numero_d ;si ya terminaron los numeros      
                ;ADD AL,30h
                CMP aux,00h
                    JNE num_2_e_d
                    
                    MOV decimales_1[DI],Al
                    INC DI
                    CMP DI,0Bh
                    JAE mas_10_numeros 
                    JMP continue_decimal
                    
                     num_2_e_d:
                     
                     MOV decimales_2[DI],Al
                     INC DI 
                     CMP DI,0Bh
                     JAE mas_10_numeros
                     JMP continue_decimal
                                        
         no_mas_numero_d:
        JMP no_mas_numero
    
termine:           
    ;si ambos son negativos o positivos=>
    MOV AL,num2_signo
    CMP num1_signo,Al 
        JE signos_iguales
        JMP signos_diferentes
        signos_iguales:
            ;si la operacion es suma,division o multipliacion
            CMP operacion,'x'      ;-*- => (+) le correponde a la multiplicacion
                JE diferente_mul   ;+*+=>  (+) le correponde a la multiplicacion
            CMP operacion,0F6h     ;-/- => (+) le correponde a la division
                JE diferente_mul   ;+/+ => (+) le correponde a la division        
            CMP operacion,'+'      ;-+- => (-) le corresponde a la suma 
                JE iguales_mult        ;+-+ => (+,-) le corresponde a la resta
            CMP operacion,'-'      ;(-)-(-) => (-) le corresponde a la suma 
                JE iguales_suma_neg    
    
    signos_diferentes:
    MOV AL,num2_signo
    CMP num1_signo,Al
        JA neg_pos ;si el signo del primer operando es (-) y el segundo es (+) => (-)>(+)=?
        JMP pos_neg ;si el signo del primer operando es (+) y el segundo es (-) => (+)>(-)=?
        ;si el signo del primer operando es (-) y el segundo es (+) => (-)>(+)=?
        neg_pos:
            CMP operacion,'+'       ;-1 + 2 => (2-1) le corresponde a la resta y puede haber signo despues
                JE resta_invertida  ;con los operandos invertidos 
            CMP operacion,'-'       ;(-1)-(+9) => (9-1)  le corresponde a la resta y puede haber signo despues 
                JE resta_invertida  ;con los operandos invertidos  
            CMP operacion,'x'       ;se multiplican los signos en ambos casos (-)*(-)=+ (+)*(+)=+ -*+=-
                JE diferente_mul 
            CMP operacion,0F6h
                JE diferente_mul
    JMP ley_signos_end
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
    iguales_mult: 
    ;el resultado conservara su signo
    MOV es_negativo_res,Al   
    JMP ley_signos_end 
    
    iguales_suma_neg:
    MOV operacion,'+'
    MOV es_negativo_res,Al
    JMP ley_signos_end  
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    diferente_mul:
    MOV AL,num2_signo
    XOR AL,num1_signo
    MOV es_negativo_res,Al 
    JMP ley_signos_end
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    resta_invertida:
    ;copiamos el numero num2 a la variable temporal ajuste_decimales_1
    MOV SI,00h                   
    num2_inversion_cpy:
    MOV AL,num2[SI]
    MOV ajuste_decimales_1[SI],AL
    INC SI 
    CMP SI,09h
    JLE num2_inversion_cpy
    ;copiamos el numero (num1) menor a num2
    MOV SI,00h                   
    num2_inversion1_cpy:
    MOV AL,num1[SI]
    MOV num2[SI],AL
    INC SI 
    CMP SI,09h
    JLE num2_inversion1_cpy 
    ;copiamos el numero en ajuste_decimales_1 a num1
    MOV SI,00h                   
    num1_inversion_cpy:
    MOV AL,ajuste_decimales_1[SI]
    MOV num1[SI],AL     
    MOV ajuste_decimales_1[SI],00h ;limpiamos la variable temporal 
    INC SI 
    CMP SI,09h
    JLE num1_inversion_cpy
    ;;INVERTIR LOS DECIMALES TAMBIEN
    ;------------------------------------------------------------------
    ;copiamos el numero mayor (decimales_2) a la variable temporal ajuste_decimales_1
    MOV SI,00h                   
    dec2_inversion_cpy:
    MOV AL,decimales_2[SI]
    MOV ajuste_decimales_1[SI],AL
    INC SI 
    CMP SI,09h
    JLE dec2_inversion_cpy
    ;copiamos el numero (decimales_1) menor a decimales_2
    MOV SI,00h                   
    dec2_inversion1_cpy:
    MOV AL,decimales_1[SI]
    MOV decimales_2[SI],AL
    INC SI 
    CMP SI,09h
    JLE dec2_inversion1_cpy 
    ;copiamos el numero mayor guardado en ajuste_decimales_1 a decimales_1
    MOV SI,00h                   
    dec1_inversion_cpy:
    MOV AL,ajuste_decimales_1[SI]
    MOV decimales_1[SI],AL     
    MOV ajuste_decimales_1[SI],00h ;limpiamos la variable temporal 
    INC SI 
    CMP SI,09h
    JLE dec1_inversion_cpy 
    MOV operacion,'-'
    JMP ley_signos_end 
;------------------------------------------------------------------
    ;si el signo del primer operando es (+) y el segundo es (-) => (+)>(-)=?
    
    pos_neg:
            CMP operacion,'+'       ; 1+-+100 => (100-1) le corresponde a la resta invertida y puede haber signo
                JE resta_invertida        
            CMP operacion,'-'       ;(+1)-(-9) => (9+1)  le corresponde a la suma y no habra signo
                JE suma_pos  ;
            CMP operacion ,'x'       ;se multiplican los signos en ambos casos (-)*(-)=+ (+)*(+)=+ -*+=-
                JE pos_neg_mul 
            CMP operacion,0F6h
                JE pos_neg_mul
    suma_pos:
    MOV operacion,'+'
    MOV es_negativo_res,00h 
    JMP ley_signos_end
    
    pos_neg_mul:
    MOV AL,num2_signo
    XOR AL,num1_signo
    MOV es_negativo_res,Al 
    JMP ley_signos_end
             
ley_signos_end:    

;;INVERTIMOS LAS PARTES ENTERAS DE LOS OPERANDOS PORQUE SE GUARDARON AL REVEZ
;lo copiamos ajustado a una variable auxiliar para ajustes de este tipo
MOV CX,09h
MOV SI,00h     
Count_1:
INC SI
MOV AL,num1[SI]
CMP AL,00h     
JNE fin_count1 
Loop Count_1  
fin_count1:
MOV BX,SI 


MOV DI,09h
return_num1:
MOV AL,num1[SI]
MOV ajuste_decimales_1[DI],Al
DEC DI
INC SI
CMP SI,0Ah
JL return_num1
;pasamos de la variable temporal ajustada a la definitiva
MOV CX,09h
adjust_num1:                   
MOV DI,CX
MOV AL,ajuste_decimales_1[DI]  
SUB AL,30h
CMP AL,0D0h
JE  fix_al1 
fixed_al1:
MOV num1[DI],AL
DEC CX
JNS adjust_num1 

;para el numero 2
MOV CX,09h
MOV SI,00h     
Count_2:
INC SI
MOV AL,num2[SI]
CMP AL,00h
JNE fin_count2 
Loop Count_2
  
fin_count2:
MOV BX,SI 

MOV DI,09h
return_num2:
MOV AL,num2[SI]
MOV ajuste_decimales_2[DI],Al
DEC DI
INC SI
CMP SI,0Ah
JL return_num2  

;pasamos de la variable temporal ajustada a la definitiva
MOV CX,09h
adjust_num2:                   
MOV DI,CX
MOV AL,ajuste_decimales_2[DI]  
SUB AL,30h
CMP AL,0D0h
JE  fix_al2  
fixed_al2:
MOV num2[DI],AL
DEC CX
JNS adjust_num2

RET
fix_al1:
ADD AL,30h
JMP fixed_al1 

fix_al2:
ADD AL,30h
JMP fixed_al2

RET
AJUSTA_OPERANDOS ENDP        
end begin 