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
                 db "   Garc",0A1h,"a Ponce Javier (El compa",0A4h,"ero que si estudia)",13
                 db "    Giovanni Pablo Mart",0A1h,"nez",13
                 db "    Gonz",0A0h,"les Santiesteban Santiago","$"
                 
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
                 db "   Garc",0A1h,"a Ponce Javier (El compa",0A4h,"ero que si estudia)",13
                 db "   Giovanni Pablo Mart",0A1h,"nez",13
                 db "   Gonz",0A0h,"les Santiesteban Santiago","$"
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
;;;;;;;;;;;;;;;;;;;;;OPERANDOS PARA LA SUMA 
num1          db 0,0,0,0,0,0,0,0,0,0,'$'    
decimales_1   db 0,0,0,0,0,0,0,0,0,0,'$'   
num2          db 0,0,0,0,0,0,0,0,0,0,'$'    
decimales_2   db 0,0,0,0,0,0,0,0,0,0,'$'   
num_res       db 0,0,0,0,0,0,0,0,0,0,'$'  
decimales_Res db 0,0,0,0,0,0,0,0,0,0,'$' 
;Acarreo_ParaEntero db 0 
len_display dw 0 ;longuitud de la cadena display previa a la operacion   
operacion db 00h ;;<------------------------DETECTA LA OPERACION INVOCADA DESPUES DEL AJUSTE PRE-OPERACIONAL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                                
                 
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
inicio_Interfaz:  
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
    MOV Dx, 184Fh ;tama?o de la pantalla ()
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
Resolver proc near
         
         CALL AJUSTA_OPERANDOS
         CMP operacion,'+'
         JE Suma_Op
         JMP Agrega_pila
Suma_Op:
CALL SUMA          
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
            MOV CX,15h ;longuitud del resultado
            MOV SI,0000h ;Posicion inicial del resultado
copy_result_str:
            INC DI
;;RESULTADO DESPUES DE SIGNO
            MOV AL,resultado_str[SI]
            MOV pila_operaciones[DI],AL
            INC SI
            LOOP copy_result_str
            ;;agrega el salto de linea en la pila
            INC DI
            MOV pila_operaciones[DI],13d
            INC DI  
            MOV pila_operaciones[DI],'$';finaliza la cadena
            ;;ajusta la posicion de la pila 
	        INC posicion_pila		   
	        mov posicion_pila,di
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
    LEA SI,display_str
    MOV CX,-1
DO:
    LODSB
    INC CX
    CMP AL,'$'
    JNE DO
;;la longuitud se almacena en CX
DEC CX    ;saltamos el fin de cadena
MOV SI,CX ;iniciamos si en la ultima posicion
MOV DI,0Ah ;iniciamos el DI en la ultima posicion de el destino (decimales_1)
MOV len_display,Cx 
COPY_1:
    MOV SI,CX
    MOV AL,display_str[SI]
    ;MOV display_str[SI],'$' ;rellena la cadena con fines de cadena
        
    CMP AL,'.'
    JE Num_1
    
    DEC DI 
    SUB AL,30h
    MOV decimales_1[DI],Al      
    LOOP COPY_1
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Num_1:
DEC CX     ;saltamos el punto decimal
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
    CMP AL,0F6h ;entre ? (alt +246)
    JE Decimal_2
    
    
    DEC DI 
    SUB AL,30h
    MOV num1[DI],Al      
    LOOP Copy_num1  
    
Decimal_2: 
MOV operacion,AL ;almacenamos el signo de la operacion
DEC CX     ;saltamos el punto decimal
MOV SI,CX  ;iniciamos si en la ultima posicion
MOV DI,0Ah ;iniciamos el DI en la ultima posicion de el destino (decimales_2)

Copy_deci2:
    MOV SI,CX
    MOV AL,display_str[SI]
    ;MOV display_str[SI],'$' ;rellena la cadena con fines de cadena
        
    CMP AL,'.'
    JE Num_2
    
    DEC DI 
    SUB AL,30h
    MOV decimales_2[DI],Al      
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



                                                                                                     
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
RET
AJUSTA_OPERANDOS ENDP
;______________________PROC_SUMA________________ 
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
;ADD Acarreo_ParaEntero,Ah
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
 
 
;;;;;;;;;;;;;;;;AGREGAR ACARREO PENDIENTE  
MOV AL,num_res[09h]
ADD AL,decimales_res[0h]
MOV decimales_res[0h],20h
MOV num_res[09h],AL 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Enviar resultado listo para impresion a display_str
CALL AJUSTE_PARA_IMPRESION     
RET    
SUMA ENDP

;______________________PROC_AJUSTE ASCII POST OPERACIONAL________________ 


AJUSTE_PARA_IMPRESION PROC NEAR
CALL AJUSTE_CEROS_IZQUIERDA ;remover ceros a la izquierda antes de imprimir
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera 
MOV aux,0h      
MOV SI,0000h

MOV CX,09H
ajusteAsciiEntero:
MOV AL,num_res[SI]
    ;si es espacio
    CMP AL,20h    
    JE  borralo
    JMP no_borres_enteros
    borralo:
        MOV AL,07h
        JMP regresa_borrar_enteros
no_borres_enteros:
ADD AL,30H

regresa_borrar_enteros:
;fin es espacio
MOV BX,0000h
MOV Bl,aux
MOV resultado_str[BX],AL
 
INC aux
INC SI 
DEC CX
JNS ajusteAsciiEntero

MOV BX,0000h
MOV Bl,aux
MOV resultado_str[BX],'.'

INC SI
INC aux

MOV DI,0000H       
MOV CX,09H
ajusteAsciiDecimal:
MOV AL,decimales_Res[DI]
    ;si es espacio
    CMP AL,20h    
    JE  borralo_decimales
    JMP no_borres_decimales
    borralo_decimales:
        MOV AL,07h
        JMP regresa_borrar_decimales
no_borres_decimales:
ADD AL,30H

regresa_borrar_decimales:
;fin es espacio
MOV BX,0000h
MOV Bl,aux
MOV resultado_str[BX],AL

INC aux
INC DI
INC SI                
DEC CX
JNS ajusteAsciiDecimal 

MOV BX,0000h
MOV Bl,aux
MOV resultado_str[BX],'$'      
RET
AJUSTE_PARA_IMPRESION ENDP 
;---------------------ENTRADA-------------------
ENTRADA_PROC proc near 
   SalvaRegistros ;Guarda el estado actual de los registros de proposito general       
    ;revisar si es el primer caracter de una entrada nueva
CMP posicion_entrada,0h
JE limpia_variables_resultados
JMP no_es_primera_entrada

;limpia las cadenas operacionales de resultados
limpia_variables_resultados:
MOV DI,0h  
MOV len_display,0h
MOV operacion,0h
limpia_siguiente:
    MOV num1[DI],0h
    MOV decimales_1[DI],0h
    MOV num2[DI],0h
    MOV decimales_2[DI],0h 
    MOV num_res[DI],0h
    MOV decimales_Res[DI],0h
INC DI
CMP DI,09h
JLE limpia_siguiente ;limpia las cadenas operacionales de resultados
MOV DI,0h  
MOV len_display,0h
MOV operacion,0h
;;;;;;;;;;;;;;;; 
no_es_primera_entrada:

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
CMP aux,01h ;si ya se habia presionado un signo operacional resuelve la operacion actual
JE  Enm_Resuelve
MOV aux,01h ;indicamos en aux que estamos ingresando el segundo numero 
;Revisamos si le falta punto al numero 1
CMP num1_tiene_decimales,01h ;si  tiene punto (true) puedes continuar 
JE  post_operacional
;si no tiene agregalo
MOV display_str[DI],"."
INC posicion_entrada 
MOV display_str[DI+1],"0"
INC posicion_entrada 
MOV display_str[DI+2],"0"
INC posicion_entrada
MOV DI,posicion_entrada
MOV num1_tiene_decimales,01h ;indicamos que num1 tiene decimales            
JMP post_operacional
     
Es_punto:                   
CMP aux,01h ;si estamos despues del signo operacional
JE segundo_punto 
                 ;si no el es el primero
MOV num1_tiene_decimales,01h 

segundo_punto:
MOV num2_tiene_decimales,01h
JMP post_punto   

Enm_Resuelve:
;revisar si hace falta el ultimo punto para agregarlo
CMP num2_tiene_decimales,01h
JNE agrega_segundo_punto 
JMP si_tiene_punto
agrega_segundo_punto:
MOV num2_tiene_decimales,01h
MOV DI,posicion_entrada
MOV display_str[DI],"."
INC posicion_entrada 
MOV display_str[DI+1],"0"
INC posicion_entrada 
MOV display_str[DI+2],"0"
INC posicion_entrada 
MOV display_str[DI+3],"$"
INC posicion_entrada 
MOV DI,posicion_entrada

JMP si_tiene_punto  
;limpiamos variables
si_tiene_punto:
MOV num1_tiene_decimales,00h
MOV num2_tiene_decimales,00h
MOV aux,00h
CALL Resolver 

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
CMP num_res[DI],0h
JNE no_hay_mas_ceros_enteros;si el numero es diferente de cero ya terminamos el ajuste  
;si es cero removerlo!
MOV num_res[DI],20h 
INC DI
CMP DI,08h ;evitar el ultimo cero por si el resultado es cero (0+0=0)
JLE siguiente_cero       

;;ajustar la parte decimal
no_hay_mas_ceros_enteros:  

MOV DI,01h
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