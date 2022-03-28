;______________________MACROS______________________ 
;---------------------PRINT CHAR-------------------
PRINT_CHAR MACRO CARACTER,X,Y
SalvaRegistros  
    GOTOXY X,Y
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
GotoXY MACRO x,y
    SalvaRegistros
    MOV Ah, 02h     ;goto xy
    MOV Bh, 00
    MOV dh, y     ;posicion del cursor en y
    MOV dl, x     ;posicion del cursor en x
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

    registros_tbl dw 0000h,0000h,0000h,0000h ;guarda el estado previo de los registros      
    temp_tbl db 00h,00h,00h,00h ;actua como un segmento de datos extra temporal de un byte     
    temp equ 00h 
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
    seleccion db 00h  
    display_str  db "Utilice las fechas y el teclado numerico para navegar              $"
    vacia_str    db "                                                                   $"  
    
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
                 
.code   
;_________________________________________PROCEDIMIENTO PRINCIPAL_________________________________________
     begin proc FAR
           MOV Ax, @data
           MOV ds, Ax                         
           ;INICIA
                Call Caratula
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
        RestituyeRegistros
        Call Cls
         
        Marco 0Fh,45h,04h,01h ;dibuja el marco principal de la calculadora    
                
        mov ah,09h
	    mov bl,0Ah
	    mov cx, 43h
        LEA Dx,vacia_str   
        GotoXY 05h,02h
	    int 10h         
        int 21h
        GotoXY 05h,03h
	    int 10h
        LEA Dx,display_str  
        int 21h
             
        Marco 03h,45h,04h,01h ;dibuja el display de la calculadora     

;---------BOTONES--------------------------------        
        ;-->dibujar cuadro para la suma
        COLOR 04h,0Eh,06h,05h,0A9h
        Imprime suma_Simbolo,06h,06h ;imprime el contenido de la cadena suma_simbolo en las
        Marco 04h,0Eh,06h,05h        ;coordenadas especificadas
                                     
        ;-->dibujar cuadro para la resta        
        COLOR 04h,0Eh,16h,05h,0A9h
        Imprime resta_Simbolo,16h,06h   ;imprime el contenido de la cadena suma_simbolo en las
        Marco 04h,0Eh,16h,05h           ;coordenadas especificadas          
                                        ;llama a la macro marco

        ;-->dibujar cuadro para la multiplicacion
        COLOR 04h,0Fh,026h,05h,0A9h                                      
        Imprime mul_Simbolo,026h,06h   ;imprime el contenido de la cadena suma_simbolo en las
        Marco 04h,0Fh,026h,05h         ;coordenadas especificadas
                                         
        ;-->dibujar cuadro para la division 
        COLOR 04h,0Fh,037h,05h,0A9h                                                                                 
        Imprime div_Simbolo,037h,06h   ;imprime el contenido de la cadena suma_simbolo en las
        Marco 04h,0Fh,037h,05h         ;coordenadas especificadas
        
;--------PANEL NUMERICO-------------------- 
RestituyeRegistros
        MOV CX,0FFFFh 
        MOV Al,06h 
        MOV DL,2Fh
num_pad:
        INC CX   
        INC Dl                                                      
        ;COLOR 04h,04h,Al,0Ah,0A9h
        PRINT_CHAR Dl,Al,0Ch                                                                                 
        ;Marco 04h,04h,06h,0Ah         
       ADD Al,04h 
       ADD Al,Ch
       INC Al 
       CMP CX,09h 
       JE num_pad_exit
       JMP num_pad            
num_pad_exit:                           
        XOR Ax,Ax
        int 16h
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
    MOV Dx, 184Fh ;tamaño de la pantalla ()
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
        ;SUB Cl,2h                           ;decrementa Cl en 2 para obtener el valor real del alto 
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
        ;SUB Cl,2h                           ;decrementa Cl en 2 para obtener el valor real del alto 
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
end begin