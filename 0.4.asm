;______________________MACROS______________________
;______________________MACR_XY_____________________
GotoXY MACRO x,y
    SalvaRegistros
    MOV Ah, 02h     ;goto xy
    MOV Bh, 00
    MOV dh, y     ;posicion del cursor en y
    MOV dl, x     ;posicion del cursor en x
    int 10h
    RecuperaRegistros   
GotoXY endm
;______________________MACR_SALVAR_____________________
SalvaRegistros MACRO
    
    MOV [registros_dir],Ax
    MOV [registros_dir+2h],Bx
    MOV [registros_dir+4h],Cx
    MOV [registros_dir+6h],Dx
SalvaRegistros endm
;______________________MACR_RECUPERAR_____________________
RecuperaRegistros MACRO

    MOV Ax,[registros_dir]    
    MOV Bx,[registros_dir+2h] 
    MOV Cx,[registros_dir+4h] 
    MOV Dx,[registros_dir+6h] 

RecuperaRegistros endm
;______________________MACR_RESTITUIR_____________________
RestituyeRegistros 
MOV Ax,0h
MOV Bx,0h
MOV Cx,0h
MOV Dx,0h
RestituyeRegistros endm
;______________________MACR_IMPRIMIR_____________________
Imprime MACRO cadena,X,Y
    SalvaRegistros
    MOV ch,X
    MOV cl,Y 
    GotoXY ch,cl
    LEA Bx,caratula_str
    MOV DI,0FFFFh
    MOV Ah,02

    Impr_siguiente:
    INC DI   
    CMP [Bx+DI],13d      
    JE NuevaLinea 
    MOV DL,[Bx+DI]
    int 21h   
    CMP [Bx+DI+1],'$' 
    JNE Impr_siguiente
    
    JMP Impr_salir
    
    
    NuevaLinea:
    inc cl  
    MOV dh,cl
    GotoXY ch,cl
    JMP Impr_siguiente
    
    Impr_salir:    
            RecuperaRegistros
Imprime endm
;______________________END_MACROS______________________  
.model small
.stack
.data  
    registros_tbl dw 0h,0h,0h,0h
    registros_dir dw 1234h,1234h,1234h,1234h
    temp equ 00h
    DFilaArri db 0C9h,0CDh,0BBh 
    DFilaAba  db 0C8h,0CDh,0BCh  
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
                 db "    \_____|\____/|______|_|  |_|\____/_/    \_\_____/_/    \_|_| \_|",13,13,13
                 db "   Proyecto: --> 'Calculadora' <--",13,13
                 db "   Profesor: Luis Valles Monta",0A4h,"ez",13
                 db "   Alumnos:",13
                 db "   Garc",0A1h,"a Garc",0A1h,"a Jonathan Eduardo",13
                 db "   Gonz",0A0h,"les Santiesteban Santiago",13
                 db "   Garc",0A1h,"a Javier$"
    seleccion db 00h             
.code   
     begin proc FAR
           MOV Ax, @data
           MOV ds, Ax                         
           LEA Bx,registros_tbl  
           MOV registros_dir,Bx
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
;______________________PROC_INTERFAZ________________ 
Interfaz proc near
    RestituyeRegistros
        
Interfaz endp    
;______________________PROC_CARATULA________________
Caratula proc near               
        Call Cls
        GotoXY 0h,01h ;mueve el cursor a las coordenadas (0,1)
               
        LEA Bx, DFilaArri ;asigna la direccion inicial de la cadena fila       
        MOV dl,[Bx]   ;asina a dl en primer caracter (esquina izquierda)  
        MOV Ah,02   ;asigna 2 a Ah (Imprime caracter)       
        int 21h      ;imprime caracter
        MOV Cx,4Eh     ;asigna 4Eh a Cx (78 decimal que es el ancho de la pantalla)
        inc Bx ;incrementa Bx para obtener el siguiente caracter (linea)
        MOV dl,[Bx] ;asigna a dl el segundo caracter (linea)     
        
Car_filaArr:
        int 21h     ;imprime caracter
        Loop Car_filaArr  
        
        inc Bx ;incrementa Bx para obtener el siguiente caracter (esquina derecha)
        MOV dl,[Bx] ;asigna a dl el segundo caracter (esquina derecha) 
        int 21h   ;imprime caracter
        
        GotoXY 0h,17h
        lea Bx,DFilaAba
        MOV dl,[Bx]   ;asina a dl en primer caracter (esquina izquierda)  
        MOV Ah,02   ;asigna 2 a Ah (Imprime caracter)       
        int 21h      ;imprime caracter
        MOV Cx,4Eh     ;asigna 4Eh a Cx (78 decimal que es el ancho de la pantalla)
        inc Bx ;incrementa Bx para obtener el siguiente caracter (linea)
        MOV dl,[Bx] ;asigna a dl el segundo caracter (linea)  
Car_filaAba:   
        int 21h     ;imprime caracter
        Loop Car_filaAba  
        
        inc Bx ;incrementa Bx para obtener el siguiente caracter (esquina derecha)
        MOV dl,[Bx] ;asigna a dl el segundo caracter (esquina derecha) 
        int 21h   ;imprime caracter
        
        MOV DL,0BAh
        MOV Ah,02  
        MOV DH,2h          
        MOV Cx,15h   
Car_columnaIzq:    
  
        SalvaRegistros   
        GotoXY 0h,DH
        RecuperaRegistros         
        int 21h 
        INC DH

        Loop Car_columnaIzq 
        
        MOV Cx,15h
        MOV DH,02h
Car_columnaDer:  
        
        SalvaRegistros
        GotoXY 4Fh,DH 
        RecuperaRegistros
        int 21h
        INC DH
        Loop Car_columnaDer
        
        Imprime caratula_str,02h,02H    

        XOR Ax,Ax
        int 16h
RET 
Caratula endp     
end begin