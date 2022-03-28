                                                                              ;______________________MACROS______________________ 
;----------------------ENTRADA---------------------
ENTRADA MACRO CARACTER
    MOV Al,CARACTER
    CALL ENTRADA_PROC
ENDM    
;----------------------ERROR-----------------------
ERROR MACRO MENSAJE
      SalvaRegistros ;Guarda el estado actual de los registros de proposito general
        mov ah,09h ;asigna 9 a ah (imprime cadena)
	    mov bl,0F4h ;fondo/texto
	    mov cx, 43h
        LEA Dx,vacia_str  ;asigna a Dx la direccion inicial desplazamiento de la variable 'vacia_str'  
        GotoXY 05h,02h    ;mueve el cursor a las coordenadas (5,2)
	    int 10h         
        int 21h
        GotoXY 05h,03h ;mueve el cursor a las coordenadas (5,3)
	    int 10h
        LEA Dx,MENSAJE ;asigna a Dx la direccion inicial desplazamiento de la variable 'MENSAJE'  
        int 21h 
        PAUSA 
      RecuperaRegistros ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron   
ENDM
DISPLAY MACRO MENSAJE
    SalvaRegistros   ;Guarda el estado actual de los registros de proposito general             
        mov ah,09h  ;asigna 9 a ah (imprime cadena)
	    mov bl,0Ah
	    mov cx, 43h
        LEA Dx,vacia_str ;asigna a Dx la direccion inicial desplazamiento de la variable 'vacia_str'   
        GotoXY 05h,02h  ;mueve el cursor a las coordenadas (5,2)
	    int 10h         
        int 21h
        GotoXY 05h,03h ;mueve el cursor a las coordenadas (5,3)
	    int 10h
	    ;
	    GotoXY 05h,03h ;mueve el cursor a las coordenadas (5,3)
	    mov ah,09h     ;asigna 9 a ah (imprime cadena)
	    LEA Dx,vacia_str;asigna a Dx la direccion inicial desplazamiento de la variable 'vacia_str'
	    int 21h         ;imprime cadena
	    GotoXY 05h,03h ;mueve el cursor a las coordenadas (5,3)
	    mov ah,09h     ;asigna 9 a ah (imprime cadena)
	    ;
        LEA Dx,MENSAJE ;asigna a Dx la direccion inicial desplazamiento de la variable 'MENSAJE' 
        int 21h        
    RecuperaRegistros  ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
ENDM  
;---------------------PRINT CHAR-------------------
PRINT_CHAR MACRO CARACTER,pX,pY
SalvaRegistros ;Guarda el estado actual de los registros de proposito general 
    ;GOTOXY pX,pY  ;mueve el cursor a las coordenadas (Px,Py)
    ;este segmento es solo para emu en bolrand se elimina
    MOV Ah, 02h     ;goto xy
    MOV Bh, 00
    MOV dh, pY     ;posicion del cursor en y
    MOV dl, pX     ;posicion del cursor en x
    int 10h
    ;fin solo para emu 
    MOV DL,CARACTER
    MOV AH,02
    INT 21H
RecuperaRegistros ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
ENDM
;----------------------COLOR-----------------------
COLOR MACRO ALTO,ANCHO,X,Y,C
SalvaRegistros;Guarda el estado actual de los registros de proposito general

      MOV DX,0000h
      MOV CX,0000h
      
      MOV CL,X ;posicion inicial en x
      MOV CH,Y ;posicion inicial en y
      ;
      MOV AL,X
      ADD AL,ANCHO
      MOV DL,AL ;posicion final en x  
      ;
      
      MOV AL,Y
      ADD AL,ALTO
      MOV DH,AL ;posicion final en y 
        
          
      MOV AH,06H
      MOV AL,00H
      MOV BH,C   ;color de fondo y letra despues de borrar
      
      INT 10H             
       
RecuperaRegistros ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
ENDM
;----------------------PAUSA-----------------------
PAUSA MACRO
SalvaRegistros;Guarda el estado actual de los registros de proposito general   
    XOR AX,AX
    INT 16h
RecuperaRegistros;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
ENDM
;______________________MACR_XY_____________________
GotoXY MACRO gx,gy
    SalvaRegistros;Guarda el estado actual de los registros de proposito general
    MOV Ah, 02h    ;asigna 2 a ah (desplaza cursor de la int 10h)
    MOV Bh, 00     ;restituye Bh a 0
    MOV dh, gy     ;posicion del cursor en y
    MOV dl, gx     ;posicion del cursor en x
    int 10h        ;mueve el curso a las coordenadas dadas por (dl,dh)
    RecuperaRegistros;Reestablece los registros de proposito general al ultimo estado en el que se salvaron   
endm
;______________________MACR_SALVAR_____________________ 
;Guarda el estado actual de los registros de proposito general en la direccion
;de tabla indicada por el desplazamiento "registros_tbl
SalvaRegistros MACRO
    
    MOV [registros_tbl],Ax
    MOV [registros_tbl+2h],Bx
    MOV [registros_tbl+4h],Cx
    MOV [registros_tbl+6h],Dx
endm
;______________________MACR_RECUPERAR_____________________ 
;Reestablece los registros de proposito general al ultimo estado 
;en el que se salvaron en la direccion de tabla indicada por el desplazamiento "registros_tbl
RecuperaRegistros MACRO

    MOV Ax,[registros_tbl]    
    MOV Bx,[registros_tbl+2h] 
    MOV Cx,[registros_tbl+4h] 
    MOV Dx,[registros_tbl+6h] 

endm
;______________________MACR_RESTITUIR_____________________  
;Restituye los registros Ax a Dx en ceros 
RestituyeRegistros MACRO 
    MOV Ax,0000h
    MOV Bx,0000h
    MOV Cx,0000h
    MOV Dx,0000h
    endm
;______________________MACR_IMPRIMIR_____________________
Imprime MACRO cadena,X,Y
    
    SalvaRegistros ;Guarda el estado actual de los registros de proposito general
    RestituyeRegistros ;Restituye los registros de prosito general en 0
    MOV ch,X
    MOV cl,Y 
    LEA Bx,cadena ;asigna a Bx la direccion inicial desplazamiento de la variable 'cadena'

    CALL ImprimirXY  
    RecuperaRegistros;Reestablece los registros de proposito general al ultimo estado en el que se salvaron 
endm  
;
Marco MACRO alto,ancho,X,Y
    SalvaRegistros   ;Guarda el estado actual de los registros de proposito general
    
    mov [temp_tbl],alto
    mov [temp_tbl+1],ancho
    mov [temp_tbl+2],X 
    mov [temp_tbl+3],Y     
    RestituyeRegistros ;Restituye los registros de prosito general en 0
    CALL MarcoXY 
    RecuperaRegistros ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
endm 
;
Linea MACRO longuitud,X,Y
    SalvaRegistros  ;Guarda el estado actual de los registros de proposito general
    
    mov [temp_tbl],longuitud
    mov [temp_tbl+2h],X 
    mov [temp_tbl+4h],Y     
    
    CALL LineaXY
    RecuperaRegistros ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
endm 
;
;______________________END_MACROS______________________  
.model small
.stack
.data 
    resultado_str db "Resultado de la operacion n.n                                       ","$"
    posicion_pila dw 0000h 
    
    ;VARIABLES PARA LEER LA ENTRADA
    posicion_entrada dw 0000h
    num1_tiene_decimales db 00h ;0 = false / 1 = true
    num2_tiene_decimales db 00h ; 0 = false / 1 = true
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    
    renglones_pila db 00h ;cuenta los renglones de la pila de operaciones
    aux db 00h ;variable auxiliar                              
    registros_tbl dw 0000h,0000h,0000h,0000h ;guarda el estado previo de los registros      
    temp_tbl db 00h,00h,00h,00h ;actua como un segmento de datos extra temporal de un byte     
    caratula_str db "                    ______  _____ _____ __  __ ______ ",13,
                 db "                   |  ____|/ ____|_   _|  \/  |  ____|",13, 
                 db "                   | |__  | (___   | | | \  / | |__",13,
                 db "                   |  __|  \___ \  | | | |\/| |  __|",13,
                 db "                   | |____ ____) |_| |_| |  | | |____ ",13,
                 db "                   |______|_____/|_____|_|  |_|______|",13,
                 db "     _____ _    _ _      _    _ _    _         _____          _   _ " ,13,
                 db "    / ____| |  | | |    | |  | | |  | |  /\   / ____|   /\   | \ | |",13,
                 db "   | |    | |  | | |    | |__| | |  | | /  \ | |       /  \  |  \| |",13,
                 db "   | |    | |  | | |    |  __  | |  | |/ /\ \| |      / /\ \ | . ` |",13,
                 db "   | |____| |__| | |____| |  | | |__| / ____ | |____ / ____ \| |\  |",13,
                 db "    \_____|\____/|______|_|  |_|\____/_/    \_\_____/_/    \_|_| \_|",13,13,13,
                 db "   Proyecto: --> 'Calculadora' <--",13,
                 db "   Profesor: Luis Valles Monta",0A4h,"ez",13,
                 db "   Alumnos:",13,
                 db "   Garc",0A1h,"a Garc",0A1h,"a Jonathan Eduardo",13,                 
                 db "   Garc",0A1h,"a Ponce Javier",13
                 db "    Giovanni Pablo Mart",0A1h,"nez",13
                 db "    Gonz",0A0h,"lez Santiesteban Santiago","$"
                 
   despedida_str db "     _    _           _          _",13
                 db "    | |  | |         | |        | |",13,
                 db "   | |__| | __ _ ___| |_ __ _  | |_   _  ___  __ _  ___ ",13,   
                 db "   |  __  |/ _` / __| __/ _` | | | | | |/ _ \/ _` |/ _ \",13,
                 db "   | |  | | (_| \__ | || (_| | | | |_| |  __| (_| | (_) |",13,
                 db "   |_|  |_|\__,_|___/\__\__,_| |_|\__,_|\___|\__, |\___/",13,
                 db "                                              __/ |",13,
                 db "                                             |___/",13,
                 db "   Proyecto: --> 'Calculadora' <--",13,13
                 db "   Profesor: Luis Valles Monta",0A4h,"ez",13,13
                 db "   Alumnos:",13
                 db "   Garc",0A1h,"a Garc",0A1h,"a Jonathan Eduardo",13                 
                 db "   Garc",0A1h,"a Ponce Javier",13
                 db "   Giovanni Pablo Mart",0A1h,"nez",13
                 db "   Gonz",0A0h,"lez Santiesteban Santiago","$"
    seleccion db 00h  
    display_str  db "Utilice las fechas y el teclado numerico para navegar",14 DUP(0),'$'     
seleccion_invalida db ">>>>>>>>>>>>>>>>>>>>>>>>>>ENTRADA INVALIDA<<<<<<<<<<<<<<<<<<<<<<<<<$"
    vacia_str    db 67 DUP(0),'$'  
    
    suma_Simbolo db "             ",13,
                 db "      +     ",13,
                 db "-->  SUMA <--","$"
                 
   resta_Simbolo db "               ",13,                               
                 db "      -        ",13,
                 db "--> RESTA <--","$" 
                 
   mul_Simbolo   db "                ",13,                               
                 db "      x         ",13,
                 db "->MULTIPLICA<-","$"          
                 
   div_Simbolo   db "                ",13,                               
                 db "       ",0F6h,"        ",13,
                 db "--> DIVIDE <--","$"
                 
pila_operaciones db " ----> Utilice las flechas y el teclado numerico para navegar <----",13 
                 db " ---------------->Sus operaciones aparaceran aqui<-----------------",13
                 db 67 DUP(0B0H),13
                 db 67 DUP(0B0H),13
                 db 12 DUP(0B0H),"Presione (q) en cualquier momento para salir",11 DUP(0B0H),13
                 db 67 DUP(0B0H),13
                 db 67 DUP(0B0H),
                 db "$" 

;OPERANDOS PARA LA RESTA
es_negativo_res db 00h
;;;;;;;;;;;;;;;;;;;;;OPERANDOS PARA LA SUMA 
num1          db 0,0,0,0,0,0,0,0,0,0,'$'    
decimales_1   db 0,0,0,0,0,0,0,0,0,0,'$'   
num2          db 0,0,0,0,0,0,0,0,0,0,'$'    
decimales_2   db 0,0,0,0,0,0,0,0,0,0,'$'   
num_res       db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$'  
decimales_Res db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'$' 
ajuste_decimales_1 db 0,0,0,0,0,0,0,0,0,0,'$'  
ajuste_decimales_2 db 0,0,0,0,0,0,0,0,0,0,'$'
Acarreo_ParaEntero db 0 
len_display dw 0 ;longuitud de la cadena display previa a la operacion   
operacion db 0h ;;<------------------------DETECTA LA OPERACION INVOCADA DESPUES DEL AJUSTE PRE-OPERACIONAL 
despues_de_sgnOperacion db 00h 
hay_acarreo db 00h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                                
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
;;;--------------------------------------------------
;;;;;;;;OPERANDOS PARA LA DIVISION
num_res_div db 0,0,0,0,0,0,0,0,0,0,'$'
decimales_Res_div db 0,0,0,0,0,0,0,0,0,0,'$'
resultado_entero_div db 01h
es_negativo_resuido_div db 00h
indefinida db 'Indeterminado' 
dividi_una_vez db 00h
 ;;;---------------------------------------------------------                 
.code   
;_________________________________________PROCEDIMIENTO PRINCIPAL_________________________________________
     begin proc FAR
           MOV Ax, @data
           MOV ds, Ax                         
           ;INICIA    
           Call Cls
           ;Call Caratula
       ;Inica variables globales de uso local
        mov posicion_pila,00h 
        ;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;CALL RESOLVER
           Call Interfaz                
           ;FIN            
           MOV Ah,4ch
           int 21h 

       SALIR: 
       MOV Ah,4ch
       int 21h 
     begin endp        
;______________________PROCEDIMIENTOS______________________  

;______________________PROC_INTERFAZ________________ 
Interfaz proc near        
;inicio_Interfaz:  
        RestituyeRegistros ;Restituye los registros de prosito general en 0
        Call Cls
         
        Marco 0Fh,45h,04h,01h ;dibuja el marco principal de la calculadora    
                
        DISPLAY display_str                    
        Marco 03h,45h,04h,01h ;dibuja el display de la calculadora     

;---------BOTONES--------------------------------        
        ;-->dibujar cuadro para la suma
        CMP seleccion,00h
        JNE no_0
        COLOR 04h,0Eh,06h,05h,0A9h
no_0:
        Imprime suma_Simbolo,06h,06h ;imprime el contenido de la cadena suma_simbolo en las
        Marco 04h,0Eh,06h,05h        ;coordenadas especificadas
                                     
        ;-->dibujar cuadro para la resta        
        CMP seleccion,01h
        JNE no_1
        COLOR 04h,0Eh,16h,05h,0A9h
no_1:
        Imprime resta_Simbolo,16h,06h   ;imprime el contenido de la cadena suma_simbolo en las
        Marco 04h,0Eh,16h,05h           ;coordenadas especificadas          
                                        ;llama a la macro marco

        ;-->dibujar cuadro para la multiplicacion
        CMP seleccion,02h
        JNE no_2
        COLOR 04h,0Fh,026h,05h,0A9h                                      
no_2:        
        Imprime mul_Simbolo,026h,06h   ;imprime el contenido de la cadena suma_simbolo en las
        Marco 04h,0Fh,026h,05h         ;coordenadas especificadas
                                         
        ;-->dibujar cuadro para la division 
        CMP seleccion,03h
        JNE no_3
        COLOR 04h,0Fh,037h,05h,0A9h                                                                                 
no_3:
        Imprime div_Simbolo,037h,06h   ;imprime el contenido de la cadena suma_simbolo en las
        Marco 04h,0Fh,037h,05h         ;coordenadas especificadas
        
;--------PANEL NUMERICO--------------------
        RestituyeRegistros;Restituye los registros de prosito general en 0
        MOV aux,01H  ;ASIGNA 1 a aux (variable auxiliar que sirve como contador)        
pnl_imprime:

        MOV AL,06H   ;Asigna 6 a Al (posicion inicial en x de los cuadros)     
        MUL aux      ;Multiplica aux*Al para obtener la siguiente posicion de x
        ADD aux,03h         ;aumenta aux en 3 para obtener el valor de la seleccion de el cuadro actual   
        MOV Dl,aux          ;mueve el valor del cuadro actual a Dl para compararlo
        SUB aux,03h         ;resta aux para no afectar al contador        
        CMP seleccion,Dl    ;compara el valor de la seleccion con el valor del cuadro actual
        JNE no_colorees     ;salta si el cuadro no es la seleccion actual        
        COLOR 04h,04h,AL,0Ah,0A9h  ;Dibuja un cuadro de color verde el la posicion de Al y 0Ah
no_colorees:                
        MOV Cl,30h    ;Asigna 30h a Cl (caracter inicial 0)
        ADD CL,aux    ;Suma 1 a Cl para obtener el siguiente numero
        ADD AL,02h    ;Suma 2 a Al para obtener la posicion en x de el numero        
        DEC CL        ;Decrementa Cl para que los numeros empiezen en 0              
        PRINT_CHAR Cl,Al,0Ch ;Imprime el numero Cl en la posicion de Al y 0Ch         
        SUB Al,02h    ;Resta 02h a Al para obtener la posicion inical de el cuadro en x de modo que coincida con el cuadro de color                                                                                               
        Marco 04h,04h,Al,0Ah ;Dibuja un marco de 4x4 en la posicion Al,0Ah               
        INC aux       ;incrementa aux (contador) en 1
        CMP aux,0Ch   ;compara aux==12
        JE pnl_end    ; salta al fin si aux==12
       JMP pnl_imprime ;salta a imprimir el siguiente cuadro si aux!=12  
pnl_end:               ;etiqueta para salir
        ;-->dibujar el signo =
        PRINT_CHAR 3Dh,44h,0Ch ;como se imprimio el caracter ':' debemos reemplazarlo por '='                                                                                
                   
;--------PILA DE OPERACIONES------------------------
;here
inicio_Interfaz:
        Marco 08h,45h,04h,10h
        imprime pila_operaciones,05h,11h   

;--------ESQUINAS DE LOS CUADROS-------------------- 
        PRINT_CHAR 0CCh,04h,04h  ;esquina superior izquierda
        PRINT_CHAR 0CCh,04h,10h  ;esquina media izquierda   
        
        PRINT_CHAR 0B9h,49h,04h  ;esquina superior derecha
        PRINT_CHAR 0B9h,49h,10h  ;esquina media derecha        
   
        RestituyeRegistros     ;Restituye los registros de prosito general en 0                                 

        MOV AL,0FFh
        int 16h                  ;Leer tecla (Ah=0)
;--------Leer flechas y cambiar seleccion-----------;               
               
        CMP AX,4D00h ;si se presiono derecha
        JE Derecha ;salta a la etiqueta Derecha
        CMP AX,4B00h ;si se presiono izquierda
        JE Izquierda ;salta a la etiqueta Izquierda
        CMP AX,4800h
        JE Arriba
        CMP AX,5000h
        JE Abajo 
        CMP AX,01C0Dh
        JE Enter_   
        CMP AX,5239h
        JLE NUM_01
        CMP AX,532Eh
        JE  NUM_01
        JMP Invalida ;salta a la etiqueta Invalida       
        
Derecha:
        INC seleccion
        CMP seleccion,04h ;si la seleccion es igual a 4
        JE Bajar      ;Salta a la etiqueta bajar
        CMP seleccion,0Fh ;si la seleccion es igual a 15 
        JE  Subir      ;Salta a la etiqueta subir
        JMP inicio_Interfaz ;salta al inicio de la interfaz (recarga)
Izquierda:
        DEC seleccion   
        CMP seleccion,0FFh ;si la seleccion es negativa
        JE Ultimo      ;Salta a la etiqueta ultimo
        JMP inicio_Interfaz ;salta al inicio de la interfaz (recarga)
Arriba:    
       CMP seleccion,03h
       JLE Abajo 
       CMP seleccion,06h
       JLE Subir
       CMP seleccion,09h        
       JLE RestaBtn
       CMP seleccion,0Ch
       JLE MulBtn
       CMP seleccion,0Fh
       JLE DivBtn
       JMP Abajo 
NUM_01:
      JMP NUM       
Abajo:
      CMP seleccion,00h
      JLE Btn1
      CMP seleccion,01h
      JLE Btn3
      CMP seleccion,02h
      JLE Btn6
      CMP seleccion,03h
      JLE Btn9      
      JMP Arriba 
Enter_:         
      CMP seleccion,00h
      JE MAS
      CMP seleccion,01h
      JE MENOS
      CMP seleccion,02h
      JE POR
      CMP seleccion,03h
      JE ENTRE
      JNE NUM      
Bajar:
        MOV seleccion,04h ;asigna 4 a la seleccion (valor del primer boton de la segunda fila)
        JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga)       
Subir:
        MOV seleccion,00h  ;asigna 0 a la seleccion (valor del primer boton de la primer fila)
        JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga)   
Ultimo:
        MOV seleccion,0Eh
        JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga)             
RestaBtn:
       MOV seleccion,01h
       JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga) 
MulBtn:
       MOV seleccion,02h
       JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga)
DivBtn:
       MOV seleccion,03h 
       JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga)
Btn1:
      MOV seleccion,05h
      JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga)   
Btn3:
      MOV seleccion,07h
      JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga) 
Btn6: 
      MOV seleccion,0Ah
      JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga) 
Btn9:
      MOV seleccion,0Dh
      JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga)  
MAS:
      MOV aux,'+'
      JMP  entra 
MENOS:       
      MOV aux,'-'  
      JMP  entra
POR:  
      MOV aux,'x' 
      JMP  entra
ENTRE:
      MOV aux,0F6h  
      JMP  entra    
NUM:    
      MOV Dl,seleccion
      SUB Dl,04h
      ADD Dl,30h
      MOV aux,Dl 
      CMP AX,4E2Bh
      JE MAS 
      CMP AX,4A2Dh
      JE MENOS
      CMP AX,352Fh
      JE ENTRE
      CMP AX,1B2Ah
      JE POR
      CMP AX,1C0Dh
      JE entra
      CMP Al,39h      
      JE num_tecla
      CMP Al,38h
      JE num_tecla
      CMP Al,37h
      JE num_tecla            
      CMP Al,36h
      JE num_tecla
      CMP Al,35h
      JE num_tecla
      CMP Al,34h
      JE num_tecla
      CMP Al,33h
      JE num_tecla
      CMP Al,32h
      JE num_tecla
      CMP Al,31h
      JE num_tecla
      CMP Al,30h
      JE num_tecla                                          
      CMP AX,0B3Dh ;si se presiono la telca shif+=
      JE  num_igual
      CMP Al,2Eh ;si se presiono la telca . (izquierdo)
      JE  num_tecla
      ;CMP AX,532Eh ;si se presiono la telca . (num pad)
      ;JE  num_igual
      JMP Invalida ;salta a la etiqueta Invalida 

num_tecla:
    MOV aux,Al      
    JMP entra
num_igual:
    MOV aux,03Ah
    JMP entra     
entra:
      ENTRADA Aux  
      DISPLAY display_str          
      JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga)                    

Invalida:              
         AND Al,11011111b ;convierte a mayuscula
         CMP Al,'Q'       ;SI Al==Q 
         JNE  Invalida_Interfaz
         Call Adios       ;termina el programa
         
Invalida_Interfaz:
     ERROR seleccion_invalida
     JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga) 
            
RestituyeRegistros ;Restituye los registros de prosito general en 0
RET        
Interfaz endp 

LineaXY proc near        
    MOV Dl,0CDh
    MOV Cl,[temp_tbl] 
    MOV Ah,02h
Impr_linea:
    GotoXY [temp_tbl+2h],[temp_tbl+4h] ;mueve el cursor a las coordenadas ([temp_tbl+2h],[temp_tbl+4h])
    int 21h
    inc [temp_tbl+2h]    
    Loop Impr_linea    
RET        
LineaXY endp
;______________________PROC_ImprimirXY (solo debe ser llamado por macro imprimir)________________ 
ImprimirXY proc near     
    GotoXY ch,cl ;mueve el cursor a las coordenadas (ch,cl)
    MOV DI,0FFFFh
    MOV Ah,02

    Impr_siguiente:
    INC DI 
    MOV DL,[Bx+DI]  
    CMP DL,13d      
    JE NuevaLinea
    CMP DL,'$'    
    JE Impr_salir
    int 21h   
    JMP Impr_siguiente

    NuevaLinea:
    inc cl  
    MOV dh,cl
    GotoXY ch,cl ;mueve el cursor a las coordenadas (ch,cl)
    ;cmp [Bx+DI+1],'$'
    ;INC DI 
    ;cmp [Bx+DI],'$'
    ;JE  Impr_salir 
    ;DEC DI
    JMP Impr_siguiente
    Impr_salir:
RET    
ImprimirXY endp  
;______________________CLS_PROC______________________
Cls proc near
        
    MOV ch, 32 ;asigna 32 a ch (oculta buffer del cursor)
    MOV Ah, 1  ;instruccion 1 de la int 10
    int 10h    ;(modo de video para texto)
    
    MOV Ah, 06h   ;limpia la pantalla
    MOV al, 00h   ;coordenas de inicio en x
    MOV Bh, 0F1h  ;F:Color Blanco(Fondo),1:Azul(Texto)
    MOV Cx, 0000h ;coordenas de inicio en y
    MOV Dx, 184Fh ;tama�o de la pantalla ()
    int 10h
 
RET   
Cls endp 
;______________________MarcoXY solo llamado por la Macro Marco______________________
MarcoXY proc near       
        
        GotoXY [temp_tbl+2h],[temp_tbl+3h]  ;mueve el cursor a las coordenadas especificadas                    
        MOV dl,0C9h                         ;asina a dl en primer caracter (esquina izquierda)  
        MOV Ah,02                           ;asigna 2 a Ah (Imprime caracter)       
        int 21h                             ;imprime caracter
        
        MOV Cl,[temp_tbl+1h]                ;asigna a Cl el ancho del cuadro        
        DEC Cl                              ;decrementa Cl para obtener el valor real de el ancho    
        MOV dl,0CDh                         ;asigna a dl el segundo caracter (linea)           
Car_filaArr:
        
        int 21h                             ;imprime caracter
        Loop Car_filaArr  
        
        MOV dl,0BBh                         ;asigna a dl el segundo caracter (esquina derecha) 
        int 21h                             ;imprime caracter
        
        MOV Al,[temp_tbl+3h]                ;mueve a al el valor de la coordenada en Y
        ADD Al,[temp_tbl]                   ;suma (Y+alto) para obtener la posicion de la esquina inferior izquierda
        
        GotoXY [temp_tbl+2h],Al             ;mueve el cursor a las coordenadas especificadas
        
        MOV dl,0C8h                         ;asina a dl el caracter (esquina izquierda)      
        int 21h                             ;imprime caracter
        
        MOV Cl,[temp_tbl+1h]                ;asigna a Cl el ancho del cuadro
        DEC Cl                              ;decrementa Cl para obtener el valor real de el ancho 
        MOV dl,0CDh                         ;asigna a dl caracter (linea)  

Car_filaAba:   
        
        int 21h                             ;imprime caracter
        Loop Car_filaAba  
        
        MOV dl,0BCh                         ;asigna a dl el caracter (esquina inferior derecha) 
        int 21h                             ;imprime caracter
        
        MOV DL,0BAh                         ;asigna a dl el caracter (columna)
        MOV Bl,[temp_tbl+3h]                ;mueve a Bl el valor de la coordenada en Y
        INC Bl                              ;incrementa al para saltar la esquina superior
        MOV Cl,[temp_tbl]                   ;asigna a Cl el alto  
        DEC Cl
Car_columnaIzq:       
                                                       
        GotoXY [temp_tbl+2h],Bl             ;mueve el cursor a las coordenadas especificadas 
        int 21h                             ;imprime caracter  666 Maldaaaaaaaaaaaaaaaaaaaaaaaaaaad D: 
        Inc Bl                              ;incrementa Bl para bajar una posicion en Y
        Loop Car_columnaIzq                 ;salta mientras Cl no sea 0
  
        MOV Al,[temp_tbl+2h]                ;asigna a Al el valor de X
        ADD Al,[temp_tbl+1h]                ;suma (x+ancho) para obtener el ancho del marco
        MOV [temp_tbl+2h],Al                ;mueve a X el valor del ancho del marco
        
        MOV Bl,[temp_tbl+3h]                ;mueve a Bl el valor de la coordenada en Y
        INC Bl                              ;incrementa al para saltar la esquina superior
        MOV Cl,[temp_tbl]                   ;asigna a Cl el alto   
        DEC Cl
        MOV DL,0BAh                         ;asigna a dl el caracter (columna)
Car_columnaDer:          
             
        GotoXY [temp_tbl+2h],Bl             ;mueve el cursor a las coordenadas ([temp_tbl+2h],Bl)
        int 21h
        INC Bl
        Loop Car_columnaDer    
RET
MarcoXY endp   
;______________________PROC_CARATULA________________
Caratula proc near                       
        Call Cls  ; procedimiento Cls (Limpiar pantalla xD)
        Marco 16h,4Eh,0h,1h      
        Imprime caratula_str,02h,02H                    
        XOR Ax,Ax
        int 16h
RET 
Caratula endp         
;______________________PROC_Adios________________
Adios proc near               
        
        Call Cls
        Marco 16h,4Eh,0h,1h      
        Imprime despedida_str,02h,02H                    
        GotoXY 0h,017h
        MOV AH,4CH
        INT 21H   ;retorna el control al dos
RET 
Adios endp
;______________________PROC_Resolver________________  
RESOLVER proc near        
         CALL AJUSTA_OPERANDOS
         CMP operacion,'+'
         JE Suma_Op
         CMP operacion,'-'
         JE Resta_Op 
         CMP operacion,'x'
         JE Multiplicacion_Op
         CMP operacion,0F6h
         JE  Division_Op
         JMP Agrega_pila
Suma_Op:
CALL SUMA 
JMP Agrega_pila 
Resta_Op:
CALL RESTA
JMP Agrega_pila
Multiplicacion_Op:
CALL MULTIPLICA
Division_Op:
CALL DIVIDE
 
JMP Agrega_pila      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ENVIAR A LA PILA LA OPERACION
Agrega_pila:
        cmp renglones_pila,07h
        JAE reinicia_pila
JMP continuar
reinicia_pila:
    mov renglones_pila,00h
    mov posicion_pila,00h  
continuar:        
        ;;Envia la ultima operacion a la pila de operaciones
            MOV SI,0000h            	    	
		    mov DI,posicion_pila 
agregar_operacion:
		       
		    MOV AL,display_str[SI]
		    CMP AL,'$'
		    JE agregar_resultado 
		    MOV pila_operaciones[DI],AL
		     
		    INC SI
		    INC DI
		    JMP agregar_operacion 
		    
agregar_resultado:
            MOV pila_operaciones[DI],'='
            MOV SI,0000h ;Posicion inicial del resultado
copy_result_str:
            ;;RESULTADO DESPUES DE SIGNO =
            MOV AL,resultado_str[SI]
            INC SI 
            CMP AL,07h 
            JNE add_restdo
            JMP copy_result_str
add_restdo:
CMP AL,'$'
JE fin_add_restdo  
INC DI          
MOV pila_operaciones[DI],AL
JMP copy_result_str

fin_add_restdo:            

            ;;agrega el salto de linea en la pila
            INC DI
            MOV pila_operaciones[DI],13d
            INC DI		   
	        mov posicion_pila,DI  
	        mov pila_operaciones[DI],'$'
	        inc renglones_pila ;;incrementa el numero de renglones de la pila
        ;;Fin Envia                        
vacia: ;limpiar el display
MOV display_str[0],'$';corta la cadena del display
MOV posicion_entrada,0h ;establece la posicion de la cadena display en cero     
RET     
Resolver endp    
;______________________PROC_AJUSTE_PRE_OPERACIONAL________________ 
AJUSTA_OPERANDOS PROC NEAR   
;LEER LA OPERACION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;OBTENER LA POSICION DEL ULTIMO NUMERO EN DISPLAY_STR (LONGUITUD)  
MOV CX,POSICION_ENTRADA
;;la longuitud se almacena en CX
DEC CX    ;saltamos el fin de cadena
MOV SI,CX ;iniciamos si en la ultima posicion
MOV DI,0Ah ;iniciamos el DI en la segunda posicion de el destino (decimales_1)
MOV len_display,Cx 
COPY_1:
    MOV SI,CX
    MOV AL,display_str[SI]
        
    CMP AL,'.'
    JNE Num_1
    CMP AL,'+'
    JNE Num_1
    CMP AL,'-'
    JNE Num_1
    CMP AL,'x'
    JNE Num_1
    CMP AL,0F6h ;entre � (alt +246)
    JNE Num_1
    
    
    DEC DI 
    SUB AL,30h
    MOV ajuste_decimales_1[DI],Al      
    LOOP COPY_1
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Num_1:
PAUSA
;DEC CX     ;saltamos el punto decimal o el signo operacional
MOV SI,CX  ;iniciamos si en la ultima posicion
MOV DI,0Ah ;iniciamos el DI en la ultima posicion de el destino (num1)    
  Copy_num1:
    
    MOV SI,CX
    MOV AL,display_str[SI]
    ;MOV display_str[SI],'$' ;rellena la cadena con fines de cadena
        
    CMP AL,'+'
    JE Decimal_2
    CMP AL,'-'
    JE Decimal_2
    CMP AL,'x'
    JE Decimal_2
    CMP AL,0F6h ;entre � (alt +246)
    JE Decimal_2
    
    
    DEC DI 
    SUB AL,30h
    MOV num1[DI],Al      
    LOOP Copy_num1  
    
Decimal_2: 
MOV operacion,AL ;almacenamos el signo de la operacion
DEC CX     ;saltamos el punto decimal
MOV SI,CX  ;iniciamos si en la ultima posicion
MOV DI,0Ah ;iniciamos el DI en la primer posicion de el destino (decimales_2)

Copy_deci2:
    MOV SI,CX
    MOV AL,display_str[SI]

    ;MOV display_str[SI],'$' ;rellena la cadena con fines de cadena
        
    CMP AL,'.'
    JE Num_2
    
    DEC DI 
    SUB AL,30h
    MOV ajuste_decimales_2[DI],Al      
    LOOP Copy_deci2


Num_2:
DEC CX     ;saltamos el punto decimal
MOV SI,CX  ;iniciamos si en la ultima posicion
MOV DI,0Ah ;iniciamos el DI en la ultima posicion de el destino (decimales_2)

Copy_num2:
    MOV SI,CX
    MOV AL,display_str[SI] 
    ;MOV display_str[SI],'$' ;rellena la cadena con fines de cadena           
    DEC DI 
    SUB AL,30h
    MOV num2[DI],Al
    DEC CX      
    JNS Copy_num2


;Recorrer los decimales a la izquierda para obtener sus valores reales 
;DECIMALES DEL NUMERO 1
MOV SI,0001H
MOV DI,0001H

recorrido_1:
MOV AL,ajuste_decimales_1[SI]                       
INC SI
CMP AL,00H     ;si el numero es cero ignoralo       
JE recorrido_1
CMP AL,24h ;si el el fin de cadena ignoralo
JE  inicia_decimales2_recorrido

DEC SI
;copiamos los decimales a la variable temporal para el ajuste a partir de aqui
copiar_recorrido_1:
MOV decimales_1[DI],AL 
INC SI                
INC DI
MOV AL,ajuste_decimales_1[SI]
CMP SI,0AH
JL recorrido_1        
 
;DECIMALES NUMERO 2
inicia_decimales2_recorrido:
MOV SI,0001H
MOV DI,0001H

recorrido_2:
MOV AL,ajuste_decimales_2[SI]                       
CMP AL,24h ;si el el fin de cadena ignoralo
JE fin_recorrido_2
 
INC SI
CMP AL,00H     ;si el numero es cero ignoralo       
JE recorrido_2

DEC SI
;copiamos los decimales a la variable temporal para el ajuste a partir de aqui
copiar_recorrido_2:
MOV decimales_2[DI],AL 
INC SI                
INC DI
MOV AL,ajuste_decimales_2[SI]
CMP SI,0AH
JL recorrido_2 

fin_recorrido_2:
; 
;invertir decimales
;Copiar los decimales ajustados a la variable definitiva

;;ELIMINAR LOS FINES DE CADENA DE LOS OPERANDOS PARA EVITAR ERRORES

;;PARA LOS DECIMALES DE NUM1
MOV SI,00H
reemplazar_decimales:
    INC SI    
    CMP decimales_1[SI],'$'
    JE  quitar_fin_d1  
    
reempla_decimal1:
    CMP decimales_2[SI],'$'
    JE  quitar_fin_d2 

reempla_decimal2:

    CMP SI,0Ah
    JLE reemplazar_decimales


quitar_fin_d1:
    MOV decimales_1[SI],0h
    CMP SI,0Ah
    JLE reempla_decimal1

quitar_fin_d2:
    MOV decimales_2[SI],0h
    CMP SI,0Ah
    JLE reempla_decimal2



                                                                                                     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
RET
AJUSTA_OPERANDOS ENDP
;______________________PROC_SUMA________________ 
SUMA PROC NEAR
;SUMAR PARTES ENTERAS SIN IMPORTAR ACARREOS
MOV DI,13h
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

MOV num_res[DI],AL 

DEC DI
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
MOV SI,13h
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
JNE no_mas_acarreo                       
JMP acarreo_del_Acarreo

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera
no_mas_acarreo:
MOV SI,13h      ;inicia el indice fuente en la ultima posicion de el resultado entero
JMP inicia_ajuste
salta_fin:
DEC SI
JMP inicia_ajuste
inicia_ajuste:
MOV AL,num_res[SI]
CMP AL,24h
JE salta_fin
ADD AL,30h   ;agrega 30h para convertilo en el caracter ascii que le corresponde a ese numero
MOV num_res[SI],AL ;lo devuelve convertido en ascii a la posicion de donde lo tomo
DEC SI
JNS inicia_ajuste 
;;ajustar la parte decimal
MOV SI,13h
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

CALL AJUSTE_PARA_IMPRESION                      
RET        
SUMA ENDP
;----------------------RESTA PROC------------------------------------------
RESTA PROC NEAR
;DETERMINAR CUAL NUMERO ES MAYOR
;reccorer el num1 y num2 desde la posicion 0 
MOV SI,00h
MOV es_negativo_res,00h
cual_es_mayor_res:
INC SI
MOV AL,num2[SI] 

;COMPARAR NUM1 CON NUM2
CMP num1[SI],AL
;si num2 es mayor ya podemos restar 
JA  acomodados_para_la_resta
;si son iguales
JE  iguales
;si no significa que num2 es mayor
JMP  num2_mayor

acomodados_para_la_resta:
MOV es_negativo_res,01h
JMP ya_puedes_restar 

iguales:                                                     
MOV es_negativo_res,00h
CMP SI,09h 
;si el el fin de cadena ambos numeros son exactamente iguales 
JE acomodados_para_la_resta     
JMP cual_es_mayor_res

num2_mayor: 
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
MOV es_negativo_res,00h
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

MOV SI,09h    ;asigna a SI 9 (la ultima posicion del numero)
MOV DI,13h 

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

MOV num_res[DI],AL 

DEC DI
DEC SI
JNS siguiente_entero_res 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera
MOV SI,13h
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
MOV SI,13h
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
CALL AJUSTE_PARA_IMPRESION
RET    
RESTA ENDP
;-------------------------------MULTIPLICA----------------------------------------------
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
              
JMP ya_puedes_ajustar_mult              
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
CALL AJUSTE_PARA_IMPRESION
RET        
MULTIPLICA ENDP
;;;;----------------------------------DIVIDE------------------------------
DIVIDE PROC NEAR
MOV resultado_entero_div,01h
;;VOLTEAR LOS OPERANDOS                                                            
    MOV SI,09h
    invertir_para_div:
        ;para la parte entera
        MOV AL,num1[SI]
        MOV AH,num2[SI]
    
        MOV num2[SI],Al
        MOV num1[SI],Ah
        
        ;para la parte decimal
        MOV Al,decimales_1[SI]
        MOV Ah,decimales_2[SI]
    
        MOV decimales_2[SI],Al
        MOV decimales_1[SI],Ah
    
    DEC SI
    JNS invertir_para_div
;----------------------------------------------------------------------------------
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
CALL AJUSTE_PARA_IMPRESION
RET        
DIVIDE ENDP
;-------------------------------------------------------------------------
;______________________PROC_AJUSTE ASCII POST OPERACIONAL________________ 
AJUSTE_PARA_IMPRESION PROC NEAR
CALL AJUSTE_CEROS_IZQUIERDA ;remover ceros a la izquierda antes de imprimir

;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera 
MOV DI,0000H
MOV SI,0000H
;REVISAMOS SI TIENE SIGNO PARA MOSTRARLO EN EL RESULTADO
;CALL CLS
;MOV AH,02
;MOV DL,es_negativo_res
;INT 21H
;PAUSA
CMP es_negativo_res,01h
JE  agrega_signo_resultado

JMP sin_signo_resultado
agrega_signo_resultado: 
MOV resultado_str[DI],'-' 
INC DI 
sin_signo_resultado:                                                
MOV es_negativo_res,00h
MOV CX,14H              ;longuitud del resultado en su parte entera
                                                
siguiente_resultado_str:                        
MOV AL,num_res[SI]                        
MOV resultado_str[DI],AL 
INC SI
INC DI
LOOP siguiente_resultado_str

MOV resultado_str[DI],'.'
INC DI 

MOV CX,014H ;longuitud del resultado en su parte decimalexceptuando el primer decimal
MOV SI,0001H ;INICIAMOS DESPUES DEL PRIMER DIGITO DECIMAL 
MOV decimales_res[0h],07h

siguiente_decimal_str:
MOV AL,decimales_res[SI]                        
MOV resultado_str[DI],AL 
INC SI
INC DI
LOOP siguiente_decimal_str

MOV resultado_str[DI],'$';Termina la cadena del resultado 
     
RET
AJUSTE_PARA_IMPRESION ENDP 
;---------------------ENTRADA-------------------
ENTRADA_PROC proc near 
   ;SalvaRegistros ;Guarda el estado actual de los registros de proposito general       
    CMP posicion_entrada,00h
    JE primer_entrada
    
    JMP no_primer_entrada 
        
        primer_entrada: 
        MOV resultado_entero_div,00h
        MOV es_negativo_resuido_div,00h
        MOV dividi_una_vez,00h
        MOV DI,0000H 
            limpia_anterior_entrada:
            MOV num1[DI],00h 
            MOV num2[DI],00h
            MOV decimales_1[DI],00h
            MOV decimales_2[DI],00h  
            MOV num_res_div[DI],00h      
            MOV decimales_Res_div[DI],00h
            MOV ajuste_decimales_1[DI],00h
            MOV ajuste_decimales_2[DI],00h
            INC DI
            CMP DI,09H
            JLE limpia_anterior_entrada 
                
                MOV DI,0000H
                
                limpia_anterior_resultado:
                MOV num_res[DI],00h 
                MOV decimales_Res[DI],00h
                MOV num_1_mult[DI],00h
                MOV num_2_mult[DI],00H
                INC DI
                CMP DI,13H
                JLE limpia_anterior_resultado 
                
                    MOV DI,0000H
                
                    limpia_operandos_mult:  
                    MOV over_flow_res[DI],00h 
                    INC DI
                    CMP DI,26H
                    JLE limpia_operandos_mult 
            
    JMP no_primer_entrada
     
no_primer_entrada:    
    CMP AL,03Ah ;si el caracter es '='
    JE Enm_Resuelve   
    
    MOV DI,posicion_entrada
            
    MOV DL,AL
    
    ;SI es un punto
    CMP AL,'.'
    JE Es_punto 
    
post_punto:
    
    ;si se presiona un signo operacional
    CMP AL,'+'
    JE signo_operacional
    CMP AL,'-'
    JE signo_operacional
    CMP AL,0F6h
    JE signo_operacional
    CMP AL,'x'
    JE signo_operacional
    
post_operacional: 

    MOV display_str[DI],Dl
    MOV display_str[DI+1],"$"
    INC posicion_entrada
    JMP Enm_Salir 
    
;JMPS    
signo_operacional: 
CMP despues_de_sgnOperacion,01h ;si ya se habia presionado un signo operacional resuelve la operacion actual
JE  Enm_Resuelve
MOV despues_de_sgnOperacion,01h ;indicamos en aux que estamos ingresando el segundo numero 
;INC posicion_entrada
;Revisamos si le falta punto al numero 1
CMP num1_tiene_decimales,01h ;si  tiene punto (true) puedes continuar 
JE  post_operacional
;si no tiene agregalo
;MOV display_str[DI],"."
;INC posicion_entrada 
;MOV display_str[DI+1],"0"
;INC posicion_entrada 
;MOV display_str[DI+2],"0"
;INC posicion_entrada
MOV DI,posicion_entrada
MOV num1_tiene_decimales,01h ;indicamos que num1 tiene decimales            
JMP post_operacional
     
Es_punto:                   
CMP despues_de_sgnOperacion,01h ;si estamos despues del signo operacional
JE segundo_punto 
                 ;si no el es el primero
MOV num1_tiene_decimales,01h 
JMP post_punto

segundo_punto:
MOV num2_tiene_decimales,01h
JMP post_punto   

Enm_Resuelve: 
;revisar si hace falta punto decimal en el segundo numero para agreagarlo
;CMP num2_tiene_decimales,01h
;JE  esta_completo
;si no tiene agregalo
MOV DI,posicion_entrada 
;MOV display_str[DI],"."
;INC posicion_entrada 
;MOV display_str[DI+1],"0"
;INC posicion_entrada 
;MOV display_str[DI+2],"0"
;INC posicion_entrada
MOV DI,posicion_entrada
MOV num2_tiene_decimales,01h

esta_completo:    
MOV DI,posicion_entrada
MOV display_str[DI],"$"
;limpiamos variables
MOV num1_tiene_decimales,00h
MOV num2_tiene_decimales,00h
MOV despues_de_sgnOperacion,00h 
CALL RESOLVER

Enm_Salir:       
    RecuperaRegistros;Reestablece los registros de proposito general al ultimo estado en el que se salvaron 
RET
ENTRADA_PROC ENDP

;----------------------------REMOVER CEROS A LA IZQUIERDA PROC-----------------------------
AJUSTE_CEROS_IZQUIERDA PROC NEAR
;;REMOVER LOS CEROS A LA IZUIERDA DEL RESULTADO Y REEMPLAZARLOS CON 20h
;;ajustar la parte entera
MOV DI,00h
siguiente_cero:
CMP num_res[DI],30h             ;si el digito mas a la izquierda es cero
JNE no_hay_mas_ceros_enteros    ;si el numero es diferente de cero ya terminamos el ajuste  
;si es cero removerlo!
;CARITAS 01H
MOV num_res[DI],07h             ;reemplazar ceros por 07h (campana)
INC DI
CMP DI,13h                      ;evitar el ultimo cero por si el resultado es cero (0+0=0)
JLE siguiente_cero       

;;ajustar la parte decimal
no_hay_mas_ceros_enteros:  

MOV DI,013h                      ;iniciamos el DI en el digito mas a la derecha en los decimales
siguiente_cero_decimal:
CMP decimales_Res[DI],30h
JNE fin_ajuste_cero_decimal;si el numero es diferente de cero ya terminamos el ajuste  
;si es cero removerlo!
MOV decimales_Res[DI],07h 
DEC DI
CMP DI,02h ;hasta el principio de los decimales
JAE siguiente_cero_decimal
fin_ajuste_cero_decimal:    
RET
AJUSTE_CEROS_IZQUIERDA ENDP     
;--------------DEBUG ME-----------------------
DEBUG proc near 
SalvaRegistros   
MOV AH,09H
LEA DX,num_res
INT 21H   
MOV AH,02H
MOV DL,'.'
INT 21H
MOV AH,09H   
LEA DX,decimales_Res
INT 21H
PAUSA
RecuperaRegistros
RET    
DEBUG ENDP    
end begin