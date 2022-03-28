.model small
.data

num1          db 0,0,0,0,0,0,0,0,0,3,'$'    
decimales_1   db 0,0,0,0,0,0,0,0,0,0,'$'

num2          db 0,0,0,0,0,0,0,0,1,5,'$'    
decimales_2   db 0,0,0,0,0,0,0,0,0,0,'$'   

;;;--------------------------------------------------
;;;;;;;;OPERANDOS PARA LA DIVISION
num_res_div db 0,0,0,0,0,0,0,0,0,0,'$'
decimales_Res_div db 0,0,0,0,0,0,0,0,0,0,'$'
resultado_entero_div db 01h
es_negativo_resuido_div db 00h
indefinida db 'Indeterminado' 
dividi_una_vez db 00h
 ;;;---------------------------------------------------------

num_res       db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$'  
decimales_Res db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$'

  
Aux db 00h



ajuste_decimales_1 db 0,0,0,0,0,0,0,0,0,0,'$'
.stack 
.code 
begin proc far
mov ax,@data
mov ds,ax
CALL DIVIDE
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



DIVIDE PROC NEAR
;;REVISAR QUE LA DIVISION NO SEA x/0
    MOV SI,09h
         revisa_indefinidos:
            CMP num2[SI],00H
            JNE no_es_indefinida
            CMP decimales_2[SI],00H
            JNE no_es_indefinida
            DEC SI
            JNS revisa_indefinidos 
        
        MOV CX,0Dh ;longuitud de la palabra "Indeterminado" 
        MOV SI,00h  
        indeterminado_cpy:  
            MOV AL,indefinida[SI]
            MOV num_res[SI],Al
            INC SI
        Loop indeterminado_cpy 
        MOV decimales_Res[00h],07h ;borrar los decimales
        MOV decimales_Res[01h],07h ;borrar los decimales 
        RET
no_es_indefinida:
;;COPIAR LOS OPERANDOS ORIGINALES EN LAS VARIABLES ESPECIALES
;;PARA LA DIVISION   
MOV DI,0000h
aun_hay_resuido:
;------------------------------------------------------------------------------------INICIA_RESTA
    ;DETERMINAR CUAL NUMERO ES MAYOR
    ;reccorer el num1 y num2 desde la posicion 0 
    MOV SI,00h

    cual_es_mayor_div:                           
    INC SI
    MOV AL,num2[SI] 

    ;COMPARAR num1 CON num2
    CMP num1[SI],AL
    ;si num1 es mayor ya podemos restar 
    JA  acomodados_para_la_resta_div
    ;si son iguales_div
    JE  iguales_div
    ;si no significa que num2 es mayor
    JMP  num2_mayor_div

    acomodados_para_la_resta_div:
    JMP ya_puedes_restar_div 

    iguales_div:
    MOV es_negativo_resuido_div,00h ;no hay signo en la parte entera 
    CMP SI,09h ;si el el fin de cadena ambos numeros son exactamente iguales_div en su parte entera 
        JE revisar_parte_decimal
        JMP cual_es_mayor_div 
        ;-----------------------------------------------------------------------------
        revisar_parte_decimal:
        ;revisar su parte decimal para determinar el mayor
            MOV SI,00h
                cual_es_mayor_dec:
                    INC SI
                    MOV AL,decimales_2[SI] 

                    ;COMPARAR num1 CON num2
                    CMP decimales_1[SI],AL
                    ;si num1 es mayor ya podemos restar 
                    JA  acomodados_para_la_resta_div
                    ;si son iguales_div
;                    JE  iguales_div
                    ;si no significa que num2 es mayor
                    JL  num2_mayor_div
                    
                    CMP SI,09h
                    JL cual_es_mayor_dec
                    JMP ya_puedes_restar_div        
        ;-----------------------------------------------------------------------------
                    
    
    ;------------------->inicia ajuste para que num 1 sea siempre mayor
    num2_mayor_div:
    MOV es_negativo_resuido_div,01h
    MOV resultado_entero_div,00h
    JMP la_resta_ya_es_negativa
    ;copiamos el numero mayor (num2) a la variable temporal ajuste_decimales_1
    MOV SI,00h                   
    num2_mayor_div_cpy:
    MOV AL,num2[SI]
    MOV ajuste_decimales_1[SI],AL
    INC SI 
    CMP SI,09h
    JLE num2_mayor_div_cpy
    ;copiamos el numero (num1) menor a num2
    MOV SI,00h                   
    num2_menor_cpy_div:
    MOV AL,num1[SI]
    MOV num2[SI],AL
    INC SI 
    CMP SI,09h
    JLE num2_menor_cpy_div 
    ;copiamos el numero mayor guardado en ajuste_decimales_1 a num1
    MOV SI,00h                   
    num1_ajuste_cpy_div:
    MOV AL,ajuste_decimales_1[SI]
    MOV num1[SI],AL     
    MOV ajuste_decimales_1[SI],00h ;limpiamos la variable temporal 
    INC SI 
    CMP SI,09h
    JLE num1_ajuste_cpy_div
    ;;INVERTIR LOS DECIMALES TAMBIEN
    ;------------------------------------------------------------------
    ;copiamos el numero mayor (decimales_2) a la variable temporal ajuste_decimales_1
    MOV SI,00h                   
    dec2_mayor_cpy_div:
    MOV AL,decimales_2[SI]
    MOV ajuste_decimales_1[SI],AL
    INC SI 
    CMP SI,09h
    JLE dec2_mayor_cpy_div
    ;copiamos el numero (decimales_1) menor a decimales_2
    MOV SI,00h                   
    dec2_menor_cpy_div:
    MOV AL,decimales_1[SI]
    MOV decimales_2[SI],AL
    INC SI 
    CMP SI,09h
    JLE dec2_menor_cpy_div 
    ;copiamos el numero mayor guardado en ajuste_decimales_1 a decimales_1
    MOV SI,00h                   
    dec1_ajuste_cpy_div:
    MOV AL,ajuste_decimales_1[SI]
    MOV decimales_1[SI],AL     
    MOV ajuste_decimales_1[SI],00h ;limpiamos la variable temporal 
    INC SI 
    CMP SI,09h
    JLE dec1_ajuste_cpy_div
;------------------------------------------------------------------
    ya_puedes_restar_div:
    
    MOV dividi_una_vez,01h
    ;RESTAR PARTES DECIMALES
    MOV SI,09h  ;asigna a SI 9 (la ultima posicion del numero)

    JMP siguiente_decimal_res_div ;salta a la etiqueta siguiente_entero_res_div

    fin_decimal_res_div:
    MOV decimales_Res_div[SI],'$' 
    DEC SI
    JMP siguiente_decimal_res_div


    siguiente_decimal_res_div:
    MOV AL,decimales_1[SI]   
    CMP AL,24h          ;si es el fin de cadena
    JE fin_decimal_res_div 



    CMP AL,decimales_2[SI] ;compara al y
    JL pide_prestado_d_div

    JMP resta_conNormalidad_d_div

    pide_prestado_d_div:
    CMP SI,0000h
    JE prestamo_desde_los_enteros_div
    DEC decimales_1[SI-1]
    ADD decimales_1[SI],0Ah

    resta_conNormalidad_d_div:
    MOV AL,decimales_1[SI]
    SUB AL,decimales_2[SI] 

    MOV decimales_Res_div[SI],AL 


    DEC SI
    JNS siguiente_decimal_res_div   
    JMP enteros_res_div
    ;AJUSTAR ACARREO DECIMAL NEGATIVO PARA LOS ENTEROS
    prestamo_desde_los_enteros_div:
    DEC num1[09h]
    MOV decimales_Res_div[0h],00h ;limpiar el acarreo    

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    enteros_res_div:
    ;RESTAR PARTES ENTERAS

    MOV SI,09h  ;asigna a SI 9 (la ultima posicion del numero)

    JMP siguiente_entero_res_div ;salta a la etiqueta siguiente_entero_res_div

    fin_enteros_res_div:
    MOV num_res_div[SI],'$' 
    DEC SI
    JMP siguiente_entero_res_div


    siguiente_entero_res_div:
    MOV AL,num1[SI]   
    CMP AL,24h          ;si es el fin de cadena
    JE fin_enteros_res_div 



    CMP AL,num2[SI] ;compara al y
    JL pide_prestado_e_div

    JMP resta_conNormalidad_e_div

    pide_prestado_e_div:
    DEC num1[SI-1]
    ADD num1[SI],0Ah

    resta_conNormalidad_e_div:
    MOV AL,num1[SI]
    SUB AL,num2[SI] 

    MOV num_res_div[SI],AL 


    DEC SI
    JNS siguiente_entero_res_div 
;-------------------------------------------------------------------------------------FIN_RESTA
;COPIAR NUM_RES_DIV A NUM1
    MOV SI,09H                    
    
        siguiente_resultado_resta:
        ;para su parte entera
        MOV Al,num_res_div[SI]
        MOV num1[SI],Al
        ;para su parte decimal
        MOV AL,decimales_Res_div[SI]
        MOV decimales_1[SI],AL
        
        DEC SI
        JNS siguiente_resultado_resta
    
;;INICIA INCREMENTO DE CONTADOR PARA EL RESULTADO
    
    CMP resultado_entero_div,01h
    JE enteros_div
    JMP decimales_div 
    enteros_div: 

        INC num_res[13h] ;agregamos 1 a la ultima posicion de el resultado entero
            
            ;ajustar los acarreos            
            MOV SI,14h 
                siguiente_posicion_enteros_div:
                DEC SI
                CMP num_res[SI],0Ah
                JLE siguiente_posicion_enteros_div
                JMP fin_incremento_contador
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                XOR AX,AX
                INT 16h
                MOV AL,num_res[SI]
                AAM
                MOV CL,AL
                
                ADD AL,CL
                MOV num_res[SI-1],Ah
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                JMP siguiente_posicion_enteros_div  
            
    decimales_div:
    ;-------------------------------------------------------------------------------------------        
        INC decimales_res[DI] ;agregamos 1 a la posicion actual del resultado decimal
            
            ;ajustar los acarreos            
            MOV SI,14h 
                siguiente_posicion_decimales_div:
                DEC SI
                CMP decimales_res[SI],0Ah
                JLE siguiente_posicion_decimales_div
                JMP fin_incremento_contador
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                XOR AX,AX
                INT 16h
                MOV AL,decimales_res[SI]
                AAM
                MOV CL,AL
                
                ADD AL,CL
                MOV decimales_res[SI-1],Ah
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                JMP siguiente_posicion_decimales_div
    ;-------------------------------------------------------------------------------------------
fin_incremento_contador:  
JMP aun_hay_resuido        
    
        la_resta_ya_es_negativa:
        CMP dividi_una_vez,01h
        JNE resultado_menor_que_cero
        JMP resultado_mayor_que_cero 
        resultado_menor_que_cero:   
            ;;si el resultado es 0.xxxxxxx copiamos el operador num1 a num_res_div para que lo
            ;;multiplique por 10            
            MOV resultado_entero_div,00h
            MOV SI,09h 
            cpy_menor_cero:
                ;para los enteros
                MOV AL,num1[SI]
                MOV Num_res_div[SI],Al
                ;para los decimales
                MOV AL,decimales_1[SI]
                MOV decimales_res_div[SI],Al 
            DEC SI
            JNS cpy_menor_cero
            
        resultado_mayor_que_cero:
        ;------------------------------------------------------------------------------
        ;;MULTIPLICAR EL RESUIDO GUARADO EN NUM_RES_DIV Y DECIAMALES_RES_DIV X10
            ;incrementar el 1 el destino decimal
            INC DI
            CMP DI,14H
            JNE no_periodico_div
            JMP periodico_div
            no_periodico_div:
            MOV SI,09H
                multiplica_siguiente_resuido:
                
                ;multiplicar su parte entera
                MOV AL,Num_res_div[SI]
                MOV AUX,0AH
                MUL Aux
                MOV Num_res_div[SI],Al
                
                ;multiplicar su parte decimal 
                MOV AL,decimales_res_div[SI]
                MUL Aux
                MOV decimales_res_div[SI],Al
                DEC SI                               
                JNS multiplica_siguiente_resuido
        ;------------------------------------------------------------------------------
                ;AJUSTAR LOS ACARREOS PROVOCADOS POR LA MULTIPLICACION POR 10
                    ;para el acarreo decimal
                    MOV SI,09H                  
                    siguiente_res_div_mul10:
                        MOV AL,decimales_res_div[SI] 
                        CMP AL,0AH 
                        JAE acarreo_por_resuido
                        DEC SI
                        
                    JNS siguiente_res_div_mul10
                    JMP fin_res_div_mul10
                    
                    acarreo_por_resuido:                    
                    AAM    
                    MOV decimales_res_div[SI],Al
                    MOV CL,decimales_res_div[SI-1]
                    ADD Ah,CL
                    MOV decimales_res_div[SI-1],Ah                                           
                    JNS siguiente_res_div_mul10
                    
                    fin_res_div_mul10: 
                    ;--------------------------------------------------
                   ;Agregar acarreo pendiente guarado en la primer posicion de decimales_res_div   
                    MOV AL,decimales_res_div[00h]
                    MOV decimales_res_div[00h],00h
                    MOV CL,num_res_div[09h]
                    ADD AL,CL
                    MOV num_res_div[09h],Al
                    ;--------------------------------------------------                    
                    ;para el acarreo entero
                    MOV SI,09H                  
                    siguiente_res_div_mul10_e:
                        MOV AL,num_res_div[SI] 
                        CMP AL,0AH 
                        JAE acarreo_por_resuido_e
                        DEC SI
                        
                    JNS siguiente_res_div_mul10_e
                    JMP fin_res_div_mul10_e
                    acarreo_por_resuido_e:                    
                    AAM    
                    MOV num_res_div[SI],Al
                    MOV CL,num_res_div[SI-1]
                    ADD Ah,CL
                    MOV num_res_div[SI-1],Ah                    
                    JNS siguiente_res_div_mul10_e 
                    
                    fin_res_div_mul10_e:
                    
                ;------------------------------------------------------------------------------
                ;copiar el resuido ajustado a las variables de operacion num1 y decimales_1
                
                        MOV SI,09H                        
                        
                        siguiente_resuido_div:
                        ;para su parte entera
                        MOV Al,num_res_div[SI]
                        MOV num1[SI],Al
                        ;para su parte decimal
                        MOV AL,decimales_Res_div[SI]
                        MOV decimales_1[SI],AL
        
                        DEC SI
                        JNS siguiente_resuido_div
                ;------------------------------------------------------------------------------
                
                ;saltamos a 'restar' el residuo
                   ;XOR AX,AX
                    ;INT 16H
                JMP aun_hay_resuido
periodico_div:                
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera
MOV SI,13h
JMP inicia_ajuste_div
salta_fin_div:
DEC SI
JMP inicia_ajuste_div
inicia_ajuste_div:
MOV AL,num_res[SI]
CMP AL,24h
JE salta_fin_div
ADD AL,30h
MOV num_res[SI],AL
DEC SI
JNS inicia_ajuste_div 
;;ajustar la parte decimal
MOV SI,13h
JMP inicia_ajuste_d_div
salta_fin_d_div:
DEC SI
JMP inicia_ajuste_d_div
inicia_ajuste_d_div:
MOV AL,decimales_Res[SI]
CMP AL,24h
JE salta_fin_d_div
ADD AL,30h
MOV decimales_Res[SI],AL
DEC SI
JNS inicia_ajuste_d_div 

MOV decimales_Res[0h],07h ;limpiar el acarreo



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;NO OLVIDES AGREGAR Y LIMPIAR EL SIGNO DEL RESULTADO MARCADO EN LA VARIABLE hay_signo
;CALL AJUSTE_PARA_IMPRESION
RET        
DIVIDE ENDP 
end begin