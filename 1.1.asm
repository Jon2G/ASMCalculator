;______________________MACROS______________________ 
ERROR MACRO MENSAJE
      SalvaRegistros 
        mov ah,09h
	    mov bl,0F4h ;fondo/texto
	    mov cx, 43h
        LEA Dx,vacia_str   
        GotoXY 05h,02h
	    int 10h         
        int 21h
        GotoXY 05h,03h
	    int 10h
        LEA Dx,MENSAJE  
        int 21h 
        PAUSA 
      RecuperaRegistros    
ENDM
DISPLAY MACRO MENSAJE
    SalvaRegistros 
        mov ah,09h
	    mov bl,0Ah
	    mov cx, 43h
        LEA Dx,vacia_str   
        GotoXY 05h,02h
	    int 10h         
        int 21h
        GotoXY 05h,03h
	    int 10h
        LEA Dx,MENSAJE  
        int 21h
    RecuperaRegistros
ENDM        
ENTRADA MACRO CARACTER 
    SalvaRegistros    
    ;
    CMP CARACTER,03Ah
    JE Enm_Resuelve   
    ;
    MOV DI,0000h
    LEA BX,display_str
    
    XOR DX,DX
    
    MOV DL,CARACTER
     
    MOV [BX+DI],DX
    JMP Enm_Salir 
     
Enm_Resuelve:
    CALL Resolver 
Enm_Salir:       
    RecuperaRegistros       
ENDM
;---------------------PRINT CHAR-------------------
PRINT_CHAR MACRO CARACTER,pX,pY
SalvaRegistros 
    ;GOTOXY pX,pY
    ;
    MOV Ah, 02h     ;goto xy
    MOV Bh, 00
    MOV dh, pY     ;posicion del cursor en y
    MOV dl, pX     ;posicion del cursor en x
    int 10h
    ; 
    MOV DL,CARACTER
    MOV AH,02
    INT 21H
RecuperaRegistros
ENDM
;----------------------COLOR-----------------------
COLOR MACRO ALTO,ANCHO,X,Y,C
SalvaRegistros

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
       
RecuperaRegistros
ENDM
;----------------------PAUSA-----------------------
PAUSA MACRO
SalvaRegistros   
    XOR AX,AX
    INT 16h
RecuperaRegistros
ENDM
;______________________MACR_XY_____________________
GotoXY MACRO gx,gy
    SalvaRegistros
    MOV Ah, 02h     ;goto xy
    MOV Bh, 00
    MOV dh, gy     ;posicion del cursor en y
    MOV dl, gx     ;posicion del cursor en x
    int 10h
    RecuperaRegistros   
endm
;______________________MACR_SALVAR_____________________
SalvaRegistros MACRO
    
    MOV [registros_tbl],Ax
    MOV [registros_tbl+2h],Bx
    MOV [registros_tbl+4h],Cx
    MOV [registros_tbl+6h],Dx
endm
;______________________MACR_RECUPERAR_____________________
RecuperaRegistros MACRO

    MOV Ax,[registros_tbl]    
    MOV Bx,[registros_tbl+2h] 
    MOV Cx,[registros_tbl+4h] 
    MOV Dx,[registros_tbl+6h] 

endm
;______________________MACR_RESTITUIR_____________________
RestituyeRegistros MACRO ;Restituye los registros Ax a Dx en ceros 
MOV Ax,0h
MOV Bx,0h
MOV Cx,0h
MOV Dx,0h
endm
;______________________MACR_IMPRIMIR_____________________
Imprime MACRO cadena,X,Y
    
    SalvaRegistros
    RestituyeRegistros
    MOV ch,X
    MOV cl,Y 
    LEA Bx,cadena

    CALL ImprimirXY  
    RecuperaRegistros
endm  
;
Marco MACRO alto,ancho,X,Y
    SalvaRegistros
    
    mov [temp_tbl],alto
    mov [temp_tbl+1],ancho
    mov [temp_tbl+2],X 
    mov [temp_tbl+3],Y     
    RestituyeRegistros
    CALL MarcoXY 
    RecuperaRegistros
endm 
;
Linea MACRO longuitud,X,Y
    SalvaRegistros
    
    mov [temp_tbl],longuitud
    mov [temp_tbl+2h],X 
    mov [temp_tbl+4h],Y     
    
    CALL LineaXY
    RecuperaRegistros
endm 
;
;______________________END_MACROS______________________  
.model small
.stack
.data
    aux db 00h                              
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
                 db "   Proyecto: --> 'Calculadora' <--",13,13,
                 db "   Profesor: Luis Valles Monta",0A4h,"ez",13,
                 db "   Alumnos:",13,
                 db "   Garc",0A1h,"a Garc",0A1h,"a Jonathan Eduardo",13,
                 db "   Gonz",0A0h,"les Santiesteban Santiago",13,
                 db "   Garc",0A1h,"a Ponce Javier (El compa",0A4h,"ero que si estudia)$"
                 
   despedida_str db "     _    _           _          _",13
                 db "    | |  | |         | |        | |",13,
                 db "   | |__| | __ _ ___| |_ __ _  | |_   _  ___  __ _  ___ ",13,   
                 db "   |  __  |/ _` / __| __/ _` | | | | | |/ _ \/ _` |/ _ \",13,
                 db "   | |  | | (_| \__ | || (_| | | | |_| |  __| (_| | (_) |",13,
                 db "   |_|  |_|\__,_|___/\__\__,_| |_|\__,_|\___|\__, |\___/",13,
                 db "                                              __/ |",13,
                 db "                                             |___/",13,
                 db "   Proyecto: --> 'Calculadora' <--",13,
                 db "   Profesor: Luis Valles Monta",0A4h,"ez",13,
                 db "   Alumnos:",13,
                 db "   Garc",0A1h,"a Garc",0A1h,"a Jonathan Eduardo",13,
                 db "   Gonz",0A0h,"les Santiesteban Santiago",13,
                 db "   Garc",0A1h,"a Ponce Javier (El compa",0A4h,"ero que si estudia)$"
    seleccion db 00h  
    instruc_str  db "Utilice las fechas y el teclado numerico para navegar",14 DUP(0),'$'
    display_str  db 67 DUP('$'),'$'
seleccion_invalida db ">>>>>>>>>>>>>>>>>>>>>>>>>>ENTRADA INVALIDA<<<<<<<<<<<<<<<<<<<<<<<<<$"
    vacia_str    db 67 DUP(20H),'$'  
    
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
                 
.code   
;_________________________________________PROCEDIMIENTO PRINCIPAL_________________________________________
     begin proc FAR
           MOV Ax, @data
           MOV ds, Ax                         
           ;INICIA    
           Call Cls
           ;Call Caratula
           Call Interfaz   
           ;FIN 
           XOR AX,AX
           INT 16H
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
        RestituyeRegistros
        Call Cls
         
        Marco 0Fh,45h,04h,01h ;dibuja el marco principal de la calculadora    
        
        DISPLAY instruc_str       
             
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
        RestituyeRegistros
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
        
        RestituyeRegistros       ;Restituimos los registros de proposito general en 0                                 
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
      CMP Ah,01Ch
      JE entra            
      ;
      CMP AX,0B29h ;si se presiono la telca shif+=
      JE  num_igual
      ; 
      
      ;
      CMP AX,04F39h   ;si es menor que 9 (0-9)
      JLE num_tecla
      ;
  
      JMP Invalida ;salta a la etiqueta Invalida 

num_tecla:
    MOV aux,Al      
    JMP entra
num_igual:
    MOV aux,03Ah
    JMP entra     
entra:
      ENTRADA aux  
      DISPLAY display_str
      PAUSA           
      JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga)                    

Invalida:              
         AND Al,11011111b ;convierte a mayuscula
         CMP Al,51h       ;SI Al==Q 
         JNE  Invalida_Interfaz
         Call Adios       ;termina el programa
         
Invalida_Interfaz:
     ERROR seleccion_invalida
     JMP  inicio_Interfaz ;salta al inicio de la interfaz (recarga) 
            
RestituyeRegistros
RET        
Interfaz endp 

LineaXY proc near        
    MOV Dl,0CDh
    MOV Cl,[temp_tbl] 
    MOV Ah,02h
Impr_linea:
    GotoXY [temp_tbl+2h],[temp_tbl+4h]
    int 21h
    inc [temp_tbl+2h]    
    Loop Impr_linea    
RET        
LineaXY endp
;______________________PROC_ImprimirXY (solo debe ser llamado por macro imprimir)________________ 
ImprimirXY proc near     
    GotoXY ch,cl
    MOV DI,0FFFFh
    MOV Ah,02

    Impr_siguiente:
    INC DI 
    MOV DL,[Bx+DI]  
    CMP DL,13d      
    JE NuevaLinea
    int 21h
    MOV DL,[Bx+DI+1]   
    CMP DL,'$'    
    JE Impr_salir 
    JNE Impr_siguiente
    
    
    JMP Impr_salir
    
    
    NuevaLinea:
    inc cl  
    MOV dh,cl
    GotoXY ch,cl
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
        int 21h                             ;imprime caracter
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
             
        GotoXY [temp_tbl+2h],Bl 
        int 21h
        INC Bl
        Loop Car_columnaDer    
RET
MarcoXY endp   
;______________________PROC_CARATULA________________
Caratula proc near               
        
        Call Cls
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
        MOV AH,4CH
        INT 21H   ;retorna el control al dos
RET 
Adios endp
;______________________PROC_Resolver________________  
Resolver proc near
    
        MOV AH,4CH
        INT 21H   ;retorna el control al dos        
RET
Resolver endp    
;
end begin