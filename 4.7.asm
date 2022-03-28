
;-----------------------------------------------------------------------------------------------------------
;DECLARACION DE MACROS 
;-----------------------------------------------------------------------------------------------------------
ENTRADA MACRO CARACTER                                                      	;Delcaracion de la Macro 'ENTRADA' con los parametros: CARACTER
;El proposito de esta macro es enviar a Al el caracter que
;esta apunto de entrar al display por medio del procedimiento
;ENTRADA_PROC (Actua como paso de parametros)
	MOV Al,CARACTER                                                             ;Asigna el contenido de CARACTER a Al
	CALL ENTRADA_PROC                                                           ;Llamada al procedimiento 'ENTRADA_PROC'
ENDM                                                                        	;Fin de la Macro
;----------------------ERROR-----------------------
ERROR MACRO MENSAJE                                                         	;Delcaracion de la Macro 'ERROR' con los parametros: MENSAJE
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general
	mov ah,09h                                                                  ;asigna 9 a ah (imprime cadena)
	mov bl,0F4h                                                                 ;fondo/texto
	mov cx, 43h                                                                 ;Asigna 43h a cx
	LEA Dx,vacia_str                                                            ;asigna a Dx la direccion inicial desplazamiento de la variable 'vacia_str'
	GotoXY 05h,02h                                                              ;mueve el cursor a las coordenadas (5,2)
	int 10h                                                                     ;Interrupcion 10h (Servicios de Pantalla)
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	GotoXY 05h,03h                                                              ;mueve el cursor a las coordenadas (5,3)
	int 10h                                                                     ;Interrupcion 10h (Servicios de Pantalla)
	LEA Dx,MENSAJE                                                              ;asigna a Dx la direccion inicial desplazamiento de la variable 'MENSAJE'
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	PAUSA                                                                       ;Llamada a la Macro PAUSA
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
ENDM                                                                        	;Fin de la Macro
DISPLAY MACRO MENSAJE                                                       	;Delcaracion de la Macro 'DISPLAY' con los parametros: MENSAJE
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general
	mov ah,09h                                                                  ;asigna 9 a ah (imprime cadena)
	mov bl,0Ah                                                                  ;Asigna 0Ah a bl
	mov cx, 43h                                                                 ;Asigna 43h a cx
	LEA Dx,vacia_str                                                            ;asigna a Dx la direccion inicial desplazamiento de la variable 'vacia_str'
	GotoXY 05h,02h                                                              ;mueve el cursor a las coordenadas (5,2)
	int 10h                                                                     ;Interrupcion 10h (Servicios de Pantalla)
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	GotoXY 05h,03h                                                              ;mueve el cursor a las coordenadas (5,3)
	int 10h                                                                     ;Interrupcion 10h (Servicios de Pantalla)
	    ;
	GotoXY 05h,03h                                                              ;mueve el cursor a las coordenadas (5,3)
	mov ah,09h                                                                  ;asigna 9 a ah (imprime cadena)
	LEA Dx,vacia_str                                                            ;asigna a Dx la direccion inicial desplazamiento de la variable 'vacia_str'
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	GotoXY 05h,03h                                                              ;mueve el cursor a las coordenadas (5,3)
	mov ah,09h                                                                  ;asigna 9 a ah (imprime cadena)
	    ;
	LEA Dx,MENSAJE                                                              ;asigna a Dx la direccion inicial desplazamiento de la variable 'MENSAJE'
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
ENDM                                                                        	;Fin de la Macro
;---------------------PRINT CHAR-------------------
PRINT_CHAR MACRO CARACTER,pX,pY                                             	;Delcaracion de la Macro 'PRINT_CHAR' con los parametros: CARACTER,pX,pY
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general
    ;GOTOXY pX,pY  ;mueve el cursor a las coordenadas (Px,Py)
    ;este segmento es solo para emu en bolrand se elimina
	MOV Ah, 02h                                                                 ;goto xy
	MOV Bh, 00                                                                  ;Asigna el contenido de 00 a Bh
	MOV dh, pY                                                                  ;posicion del cursor en y
	MOV dl, pX                                                                  ;posicion del cursor en x
	int 10h                                                                     ;Interrupcion 10h (Servicios de Pantalla)
    ;fin solo para emu 
	MOV DL,CARACTER                                                             ;Asigna el contenido de CARACTER a DL
	MOV AH,02                                                                   ;Asigna 02 a AH
	INT 21H                                                                     ;Interrupcion 21h (funciones de el DOS API)
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
ENDM                                                                        	;Fin de la Macro
;----------------------COLOR-----------------------
COLOR MACRO ALTO,ANCHO,X,Y,C                                                	;Delcaracion de la Macro 'COLOR' con los parametros: ALTO,ANCHO,X,Y,C
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general

	MOV DX,0000h                                                                ;Asigna 0000h a DX
	MOV CX,0000h                                                                ;Asigna 0000h a CX
      
	MOV CL,X                                                                    ;posicion inicial en x
	MOV CH,Y                                                                    ;posicion inicial en y
      ;
	MOV AL,X                                                                    ;Asigna el contenido de X a AL
	ADD AL,ANCHO                                                                ;Suma el valor de AL con el de ANCHO, el resultado queda en AL
	MOV DL,AL                                                                   ;posicion final en x
      ;
      
	MOV AL,Y                                                                    ;Asigna el contenido de Y a AL
	ADD AL,ALTO                                                                 ;Suma el valor de AL con el de ALTO, el resultado queda en AL
	MOV DH,AL                                                                   ;posicion final en y
        
          
	MOV AH,06H                                                                  ;Asigna 06H a AH
	MOV AL,00H                                                                  ;Asigna 00H a AL
	MOV BH,C                                                                    ;color de fondo y letra despues de borrar
      
	INT 10H                                                                     ;Interrupcion 10h (Servicios de Pantalla)
       
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
ENDM                                                                        	;Fin de la Macro
;----------------------PAUSA-----------------------
PAUSA MACRO                                                                 	;Delcaracion de la Macro 'PAUSA' con los parametros:
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general
	XOR AX,AX                                                                   ;Resituye el registro  AX a ceros por medio de XOR
	INT 16h                                                                     ;Interrupcion 16h (funciones de llamada al teclado)
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
ENDM                                                                        	;Fin de la Macro
;______________________MACR_XY_____________________
GotoXY MACRO gx,gy                                                          	;Delcaracion de la Macro 'GotoXY' con los parametros: gx,gy
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general
	MOV Ah, 02h                                                                 ;goto xy
	MOV Bh, 00                                                                  ;Asigna el contenido de 00 a Bh
	MOV dh, gy                                                                  ;posicion del cursor en y
	MOV dl, gx                                                                  ;posicion del cursor en x
	int 10h                                                                     ;Interrupcion 10h (Servicios de Pantalla)
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
	endm                                                                        ;Fin de la Macro
;______________________MACR_SALVAR_____________________ 
;Guarda el estado actual de los registros de proposito general en la direccion
;de tabla indicada por el desplazamiento "registros_tbl
SalvaRegistros MACRO                                                        	;Delcaracion de la Macro 'SalvaRegistros' con los parametros:
    
	MOV [registros_tbl],Ax                                                      ;Asigna el contenido de Ax a [registros_tbl]
	MOV [registros_tbl+2h],Bx                                                   ;Asigna el contenido de Bx a [registros_tbl+2h]
	MOV [registros_tbl+4h],Cx                                                   ;Asigna el contenido de Cx a [registros_tbl+4h]
	MOV [registros_tbl+6h],Dx                                                   ;Asigna el contenido de Dx a [registros_tbl+6h]
	endm                                                                        ;Fin de la Macro
;______________________MACR_RECUPERAR_____________________ 
;Reestablece los registros de proposito general al ultimo estado 
;en el que se salvaron en la direccion de tabla indicada por el desplazamiento "registros_tbl
RecuperaRegistros MACRO                                                     	;Delcaracion de la Macro 'RecuperaRegistros' con los parametros:

	MOV Ax,[registros_tbl]                                                      ;Asigna el contenido de [registros_tbl] a Ax
	MOV Bx,[registros_tbl+2h]                                                   ;Asigna el contenido de [registros_tbl+2h] a Bx
	MOV Cx,[registros_tbl+4h]                                                   ;Asigna el contenido de [registros_tbl+4h] a Cx
	MOV Dx,[registros_tbl+6h]                                                   ;Asigna el contenido de [registros_tbl+6h] a Dx

	endm                                                                        ;Fin de la Macro
;______________________MACR_RESTITUIR_____________________  
;Restituye los registros Ax a Dx en ceros 
RestituyeRegistros MACRO                                                    	;Delcaracion de la Macro 'RestituyeRegistros' con los parametros:
	XOR AX,AX                                                                   ;Resituye el registro  AX a ceros por medio de XOR
	XOR BX,BX                                                                   ;Resituye el registro  BX a ceros por medio de XOR
	XOR CX,CX                                                                   ;Resituye el registro  CX a ceros por medio de XOR
	XOR DX,DX                                                                   ;Resituye el registro  DX a ceros por medio de XOR
	endm                                                                        ;Fin de la Macro
;-----------------------------------------------------------------------------------------------------------
;Esta macro llama al procedimiento ImprimirXY que 
;imprime una cadena en las coordendas dadas por X y Y
;el proposito de la macro es enviar los paramteros al procedimiento
;salvando y restaurando posteriormente el estado de los registros
Imprime MACRO cadena,X,Y                                                    	;Delcaracion de la Macro 'Imprime' con los parametros: cadena,X,Y
    
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general
	RestituyeRegistros                                                          ;Restituye los registros de prosito general en 0
	MOV ch,X                                                                    ;Asigna el contenido de X a ch
	MOV cl,Y                                                                    ;Asigna el contenido de Y a cl
	LEA Bx,cadena                                                               ;asigna a Bx la direccion inicial desplazamiento de la variable 'cadena'

	CALL ImprimirXY                                                             ;Llamada al procedimiento 'ImprimirXY'
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
	endm                                                                        ;Fin de la Macro
;
Marco MACRO alto,ancho,X,Y                                                  	;Delcaracion de la Macro 'Marco' con los parametros: alto,ancho,X,Y
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general
    
	mov [temp_tbl],alto                                                         ;Asigna el contenido de alto a [temp_tbl]
	mov [temp_tbl+1],ancho                                                      ;Asigna el contenido de ancho a [temp_tbl+1]
	mov [temp_tbl+2],X                                                          ;Asigna el contenido de X a [temp_tbl+2]
	mov [temp_tbl+3],Y                                                          ;Asigna el contenido de Y a [temp_tbl+3]
	RestituyeRegistros                                                          ;Restituye los registros de prosito general en 0
	CALL MarcoXY                                                                ;Llamada al procedimiento 'MarcoXY'
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
	endm                                                                        ;Fin de la Macro
;
Linea MACRO longuitud,X,Y                                                   	;Delcaracion de la Macro 'Linea' con los parametros: longuitud,X,Y
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general
    
	mov [temp_tbl],longuitud                                                    ;Asigna el contenido de longuitud a [temp_tbl]
	mov [temp_tbl+2h],X                                                         ;Asigna el contenido de X a [temp_tbl+2h]
	mov [temp_tbl+4h],Y                                                         ;Asigna el contenido de Y a [temp_tbl+4h]
    
	CALL LineaXY                                                                ;Llamada al procedimiento 'LineaXY'
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
	endm                                                                        ;Fin de la Macro
;FIN DE LAS MACROS
;-----------------------------------------------------------------------------------------------------------
	.model small                                                                ;Directiva de inicio simplificada para el modelo de datos 'SMALL'
	.stack                                                                      ;Directiva de inicializacion de la pila simplificada
;INICIA SEGMENTO DE DATOS
;-----------------------------------------------------------------------------------------------------------
	.data                                                                       ;Directiva de inicializacion de el segmento de datos simplificado
	resultado_str      db 44h dup(0),"$"                                        ;
	posicion_pila      dw 0000h                                                 ;
;VARIABLES PARA LEER LA ENTRADA
	posicion_entrada   dw 0000h                                                 ;
;-----------------------------------------------------------------------------------------------------------   
	renglones_pila     db 00h                                                   ;cuenta los renglones de la pila de operaciones
	aux                db 00h                                                   ;variable auxiliar
	registros_tbl      dw 0000h,0000h,0000h,0000h                               ;guarda el estado previo de los registros
	temp_tbl           db 00h,00h,00h,00h                                       ;actua como un segmento de datos extra temporal de un byte
	caratula_str       db "                    ______  _____ "                  ;Caratula del programa
	db "_____ __  __ ______ ",13,                                               ;
	db "                   |  ____|/ ____|"                                     ;
	db "_   _|  \/  |  ____|",13,                                               ;
	db "                   | |__  | (___  "                                     ;
	db " | | | \  / | |__",13,                                                  ;
	db "                   |  __|  \___ \ "                                     ;
	db " | | | |\/| |  __|",13,                                                 ;
	db "                   | |____ ____) |"                                     ;
	db "_| |_| |  | | |____ ",13,                                               ;
	db "                   |______|_____/|"                                     ;
	db "_____|_|  |_|______|",13,                                               ;
	db "     _____ _    _ _      _    _ _ "                                     ;
	db "   _         _____          _   _ " ,13,                                ;
	db "    / ____| |  | | |    | |  | | |"                                     ;
	db "  | |  /\   / ____|   /\   | \ | |",13,                                 ;
	db "   | |    | |  | | |    | |__| | |"                                     ;
	db "  | | /  \ | |       /  \  |  \| |",13,                                 ;
	db "   | |    | |  | | |    |  __  | |"                                     ;
	db "  | |/ /\ \| |      / /\ \ | . ` |",13,                                 ;
	db "   | |____| |__| | |____| |  | | |"                                     ;
	db "__| / ____ | |____ / ____ \| |\  |",13,                                 ;
	db "    \_____|\____/|______|_|  |_|\_"                                     ;
	db "___/_/    \_\_____/_/    \_|_| \_|",13,13,13,                           ;
	db "   Proyecto: --> 'Calculadora' <--",13,13,13,13,13,13                   ;
    db "Presione una tecla para continuar.","$"                                 ;
	despedida_str      db "     _    _           _          _",13               ;Declaracion de mensaje de despedida
	db "    | |  | |         | |        | |",13,                                ;
	db "   | |__| | __ _ ___| |_ __ _  | |_   _  ___  __ _  "                   ;
	db "___ ",13,                                                               ;
	db "   |  __  |/ _` / __| __/ _` | | | | | |/ _ \/ _` |/"                   ;
	db " _ \",13,                                                               ;
	db "   | |  | | (_| \__ | || (_| | | | |_| |  __| (_| | "                   ;
	db "(_) |",13,                                                              ;
	db "   |_|  |_|\__,_|___/\__\__,_| |_|\__,_|\___|\__, |\"                   ;
	db "___/",13,                                                               ;
	db "                                              __/ |",13,                ;
	db "                                             |___/",13,                 ;   
	db "   Proyecto: --> 'Calculadora' <--",13,13,13,13,13,13                   ;
    db "   Presione una tecla para salir.","$"                                  ;
	display_str        db "Utilice el mouse para navegar"                       ;Declaracion de variable para el display
	db 30 DUP(0),'$'                                                            ;
	seleccion_invalida db ">>>>>>>>>>>>>>>>>>>>>>>>>>ENTRADA INVALIDA<<<<<<<"   ;
	db "<<<<<<<<<<<<<<<<<<",07h,"$"                                             ;
	div_x_cero         db ">>>>>>>>>>>>>>>>>ERROR MATEMATICO DIVISION POR CE"   ;Declaracion de mensaje por error division entre cero
	db "RO<<<<<<<<<<<<<<<<",07h,"$"                                             ;
	Mas10_numeros      db ">>>>>DESBORADMIENTO INTERNO (NO PUEDE HABER MAS D"   ;Declaracion de mensaje por desbordamiento de digitos
	db "E 9 DIGITOS)<<<<<<",07h,"$"                                             ;
	sintax_error_msj   db ">>>>>>>>>>>>>>>>>>>>>>>>>>ERROR SINTACTICO<<<<<<<"   ;Declaracion de mensaje por error de sintaxis
	db "<<<<<<<<<<<<<<<<<<",07h,"$"                                             ;
	vacia_str          db 67 DUP(0),'$'                                         ;Cadena vacia
	suma_Simbolo       db "             ",13,                                   ;Texto para el boton 'Suma'
	db "      +     ",13,                                                       ;
	db "-->  SUMA <--","$"                                                      ;
	resta_Simbolo      db "               ",13,                                 ;Texto para el boton 'Resta'
	db "      -        ",13,                                                    ;
	db "--> RESTA <--","$"                                                      ;
	mul_Simbolo        db "                ",13,                                ;Texto para el boton 'Multiplica'
	db "      x         ",13,                                                   ;
	db "->MULTIPLICA<-","$"                                                     ;
	div_Simbolo        db "                ",13,                                ;Texto para el boton 'Divide'
	db "       ",0F6h,"        ",13,                                            ;
	db "--> DIVIDE <--","$"                                                     ;
	pila_operaciones   db "Utilice el mouse para navegar.",13                   ;Declaracion de texto que aparecera en la memoria operacional                                     
	db "Para realizar una operaci",0A2h,"n (+,-,x,/) ingrese el primer n"       ;
	db 0A3h,"mero,",13                                                          ;
    db "la operaci",0A2h,"n que desea realizar, el segundo n",0A3h,"mero y",    ;
    db "presione el",13                                                         ;
	db "signo igual (=).",13                                                    ;
	db "Puede continuar haciendo las operaciones que necesite.",13              ;
	db "Para salir del programa presione la tecla ESC en cualquier momento.$"   ;
	sin_punto db 0h                                                             ;variable que nos indica que no debe imprimirse el punto decimal
;-----------------------------------------------------------------------------------------------------------
;OPERANDOS PARA LA SUMA Y RESTA                                                 ;
	num1          db 0Ah dup(0),'$'                                             ;
	decimales_1   db 0Ah dup(0),'$'                                             ;
	num2          db 0Ah dup(0),'$'                                             ;
	decimales_2   db 0Ah dup(0),'$'                                             ;
	num_res       db 14h dup(0),'$'                                             ;
	decimales_Res db 14h dup(0),'$'                                             ;
	ajuste_decimales_1 db 0Ah dup(0),'$'                                        ;
	ajuste_decimales_2 db 0Ah dup(0),'$'                                        ;
	Acarreo_ParaEntero db 0                                                     ;
	operacion db 0h                                                             ;ALMACENA LA OPERACION INVOCADA DESPUES DEL AJUSTE PRE-OPERACIONAL
	hay_acarreo db 00h                                                          ;
;-----------------------------------------------------------------------------------------------------------
;OPERANDOS PARA LA DIVISION                                                     ;
	num_res_div db 0Ah dup(0),'$'                                               ;
	decimales_Res_div db 0Ah dup(0),'$'                                         ;
	resultado_entero_div db 01h                                                 ;
	es_negativo_resuido_div db 00h                                              ;
	indefinida db 'Indeterminado'                                               ;
	dividi_una_vez db 00h                                                       ;
;-----------------------------------------------------------------------------------------------------------  
;OPERANDOS PARA LA MULTIPLICACION                                               ;
	num_1_mul       db 0,0,0,0,0,0,0,0,0                                        ;
	decimal_1_mul   db 0,0,0,0,0,0,0,0,0                                        ;
	num_2_mul       db 0,0,0,0,0,0,0,0,0                                        ;
	decimal_2_mul   db 0,0,0,0,0,0,0,0,0                                        ;
	num_res_mul     db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0                      ;
	decimal_res_mul db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0                      ;
	acarreo     db 0                                                            ;
;-----------------------------------------------------------------------------------------------------------                
;VARIABLES PARA LA LEY DE LOS SIGNOS 
	num1_signo db 00h                                                           ;
	num2_signo db 00h                                                           ;
	es_negativo_res db 00h                                                      ;
;----------------------------------------------------------------------------------------------------------- 
;VARIABLES PARA LA INTERACCION CON EL MOUSE Y TECLADO
	curX dw 0                                                                   ;
	curY dw 0                                                                   ;
	seleccion db 00h                                                            ;
;-----------------------------------------------------------------------------------------------------------
	.code                                                                       ;Directiva simplificada de inicio del segmento de Codigo
;_________________________________________PROCEDIMIENTO PRINCIPAL_________________________________________
	begin proc FAR                                                              ;Inicia procedimiento principal
	MOV Ax, @data                                                               ;Asigna el contenido de @data a Ax
	MOV ds, Ax                                                                  ;Asigna el contenido de Ax a ds
;INICIA    
	Call Cls                                                                    ;Llamada al procedimiento 'Cls'
    Call Caratula                                                               ;Llamada al procedimiento 'Caratula'
	mov posicion_pila,00h                                                       ;Asigna 00h a posicion_pila
	Call Interfaz                                                               ;Llamada al procedimiento 'Interfaz'
;FIN            
	MOV Ah,4ch                                                                  ;Asigna 4ch a Ah
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)

SALIR:                                                                      	;Etiqueta 'SALIR'
	MOV Ah,4ch                                                                  ;Asigna 4ch a Ah
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	begin endp                                                                  ;Fin del procedimiento
;______________________PROCEDIMIENTOS______________________  

;______________________PROC_INTERFAZ________________ 
	Interfaz proc near                                                          ;Inicia prodecimiento cercano 'Interfaz'
inicio_Interfaz:                                                            	;Etiqueta 'inicio_Interfaz'
	RestituyeRegistros                                                          ;Restituye los registros de prosito general en 0
	Call Cls                                                                    ;Llamada al procedimiento 'Cls'
         
	Marco 0Fh,45h,04h,01h                                                       ;dibuja el marco principal de la calculadora
                
DISPLAY display_str                                                         	;Llamada a la Macro DISPLAY con los parametros : display_str
	Marco 03h,45h,04h,01h                                                       ;dibuja el display de la calculadora

;---------BOTONES--------------------------------        
        ;-->dibujar cuadro para la suma
	CMP seleccion,00h                                                           ;Compara seleccion con 00h
	JNE no_0                                                                    ;Salta si no es igual a la etiqueta 'no_0'
COLOR 04h,0Eh,06h,05h,0A9h                                                  	;Llamada a la Macro COLOR con los parametros : 04h,0Eh,06h,05h,0A9h
no_0:                                                                       	;Etiqueta 'no_0'
	Imprime suma_Simbolo,06h,06h                                                ;imprime el contenido de la cadena suma_simbolo en las
	Marco 04h,0Eh,06h,05h                                                       ;coordenadas especificadas
                                     
        ;-->dibujar cuadro para la resta        
	CMP seleccion,01h                                                           ;Compara seleccion con 01h
	JNE no_1                                                                    ;Salta si no es igual a la etiqueta 'no_1'
COLOR 04h,0Eh,16h,05h,0A9h                                                  	;Llamada a la Macro COLOR con los parametros : 04h,0Eh,16h,05h,0A9h
no_1:                                                                       	;Etiqueta 'no_1'
	Imprime resta_Simbolo,16h,06h                                               ;imprime el contenido de la cadena suma_simbolo en las
	Marco 04h,0Eh,16h,05h                                                       ;coordenadas especificadas
                                        ;llama a la macro marco

        ;-->dibujar cuadro para la multiplicacion
	CMP seleccion,02h                                                           ;Compara seleccion con 02h
	JNE no_2                                                                    ;Salta si no es igual a la etiqueta 'no_2'
COLOR 04h,0Fh,026h,05h,0A9h                                                 	;Llamada a la Macro COLOR con los parametros : 04h,0Fh,026h,05h,0A9h
no_2:                                                                       	;Etiqueta 'no_2'
	Imprime mul_Simbolo,026h,06h                                                ;imprime el contenido de la cadena suma_simbolo en las
	Marco 04h,0Fh,026h,05h                                                      ;coordenadas especificadas
                                         
        ;-->dibujar cuadro para la division 
	CMP seleccion,03h                                                           ;Compara seleccion con 03h
	JNE no_3                                                                    ;Salta si no es igual a la etiqueta 'no_3'
COLOR 04h,0Fh,037h,05h,0A9h                                                 	;Llamada a la Macro COLOR con los parametros : 04h,0Fh,037h,05h,0A9h
no_3:                                                                       	;Etiqueta 'no_3'
	Imprime div_Simbolo,037h,06h                                                ;imprime el contenido de la cadena suma_simbolo en las
	Marco 04h,0Fh,037h,05h                                                      ;coordenadas especificadas
        
;--------PANEL NUMERICO--------------------
	RestituyeRegistros                                                          ;Restituye los registros de prosito general en 0
	MOV aux,01H                                                                 ;ASIGNA 1 a aux (variable auxiliar que sirve como contador)
pnl_imprime:                                                                	;Etiqueta 'pnl_imprime'

	MOV AL,06H                                                                  ;Asigna 6 a Al (posicion inicial en x de los cuadros)
	MUL aux                                                                     ;Multiplica aux*Al para obtener la siguiente posicion de x
	ADD aux,03h                                                                 ;aumenta aux en 3 para obtener el valor de la seleccion de el cuadro actual
	MOV Dl,aux                                                                  ;mueve el valor del cuadro actual a Dl para compararlo
	SUB aux,03h                                                                 ;resta aux para no afectar al contador
	CMP seleccion,Dl                                                            ;compara el valor de la seleccion con el valor del cuadro actual
	JNE no_colorees                                                             ;salta si el cuadro no es la seleccion actual
	COLOR 04h,04h,AL,0Ah,0A9h                                                   ;Dibuja un cuadro de color verde el la posicion de Al y 0Ah
no_colorees:                                                                	;Etiqueta 'no_colorees'
	MOV Cl,30h                                                                  ;Asigna 30h a Cl (caracter inicial 0)
	ADD CL,aux                                                                  ;Suma 1 a Cl para obtener el siguiente numero
	ADD AL,02h                                                                  ;Suma 2 a Al para obtener la posicion en x de el numero
	DEC CL                                                                      ;Decrementa Cl para que los numeros empiezen en 0
	PRINT_CHAR Cl,Al,0Ch                                                        ;Imprime el numero Cl en la posicion de Al y 0Ch
	SUB Al,02h                                                                  ;Resta 02h a Al para obtener la posicion inical de el cuadro en x de modo que coincida con el cuadro de color
	Marco 04h,04h,Al,0Ah                                                        ;Dibuja un marco de 4x4 en la posicion Al,0Ah
	INC aux                                                                     ;incrementa aux (contador) en 1
	CMP aux,0Ch                                                                 ;compara aux==12
	JE pnl_end                                                                  ; salta al fin si aux==12
	JMP pnl_imprime                                                             ;salta a imprimir el siguiente cuadro si aux!=12
pnl_end:                                                                    	;etiqueta para salir
        ;-->dibujar el signo =
PRINT_CHAR 3Dh,44h,0Ch                                                      	;como se imprimio el caracter ':' debemos reemplazarlo por '='
                   
;--------PILA DE OPERACIONES------------------------
;here
;inicio_Interfaz:
Marco 08h,45h,04h,10h                                                       	;Llamada a la Macro Marco con los parametros : 08h,45h,04h,10h
imprime pila_operaciones,05h,11h                                            	;Llamada a la Macro imprime con los parametros : pila_operaciones,05h,11h

;--------ESQUINAS DE LOS CUADROS-------------------- 
	PRINT_CHAR 0CCh,04h,04h                                                     ;esquina superior izquierda
	PRINT_CHAR 0CCh,04h,10h                                                     ;esquina media izquierda
        
	PRINT_CHAR 0B9h,49h,04h                                                     ;esquina superior derecha
	PRINT_CHAR 0B9h,49h,10h                                                     ;esquina media derecha
   
	RestituyeRegistros                                                          ;Restituye los registros de prosito general en 0

	CALL MOUSE                                                                  ;Llamada al procedimiento 'MOUSE'

nuevo_click:                                                                	;Etiqueta 'nuevo_click'

;--------Leer flechas y cambiar seleccion-----------;               
               
	CMP AX,4D00h                                                                ;si se presiono derecha
	JE Derecha                                                                  ;salta a la etiqueta Derecha
	CMP AX,4B00h                                                                ;si se presiono izquierda
	JE Izquierda                                                                ;salta a la etiqueta Izquierda
	CMP AX,4800h                                                                ;Compara AX con 4800h
	JE Arriba                                                                   ;Salta si es igual a la etiqueta 'Arriba'
	CMP AX,5000h                                                                ;Compara AX con 5000h
	JE Abajo                                                                    ;Salta si es igual a la etiqueta 'Abajo'
	CMP AX,01C0Dh                                                               ;Compara AX con 01C0Dh
	JE Enter_                                                                   ;Salta si es igual a la etiqueta 'Enter_'
	CMP AX,0E08h                                                                ;Compara AX con 0E08h
	JNE no_retroceso                                                            ;Salta si no es igual a la etiqueta 'no_retroceso'
	JMP entra                                                                   ;Salta a la etiqueta 'entra'
no_retroceso:                                                               	;Etiqueta 'no_retroceso'
	CMP AX,5239h                                                                ;Compara AX con 5239h
	JLE NUM_01                                                                  ;Salta a la etiqueta 'NUM_01' si es menor o igual
	CMP AX,532Eh                                                                ;Compara AX con 532Eh
	JE  NUM_01                                                                  ;Salta si es igual a la etiqueta 'NUM_01'
	JMP Invalida                                                                ;salta a la etiqueta Invalida
        
Derecha:                                                                    	;Etiqueta 'Derecha'
	INC seleccion                                                               ;Incrementa en uno el valor de seleccion
	CMP seleccion,04h                                                           ;si la seleccion es igual a 4
	JE Bajar                                                                    ;Salta a la etiqueta bajar
	CMP seleccion,0Fh                                                           ;si la seleccion es igual a 15
	JE  Subir                                                                   ;Salta a la etiqueta subir
	JMP inicio_Interfaz                                                         ;salta al inicio de la interfaz (recarga)
Izquierda:                                                                  	;Etiqueta 'Izquierda'
	DEC seleccion                                                               ;Decrementa en uno el valor de seleccion
	CMP seleccion,0FFh                                                          ;si la seleccion es negativa
	JE Ultimo                                                                   ;Salta a la etiqueta ultimo
	JMP inicio_Interfaz                                                         ;salta al inicio de la interfaz (recarga)
Arriba:                                                                     	;Etiqueta 'Arriba'
	CMP seleccion,03h                                                           ;Compara seleccion con 03h
	JLE Abajo                                                                   ;Salta a la etiqueta 'Abajo' si es menor o igual
	CMP seleccion,06h                                                           ;Compara seleccion con 06h
	JLE Subir                                                                   ;Salta a la etiqueta 'Subir' si es menor o igual
	CMP seleccion,09h                                                           ;Compara seleccion con 09h
	JLE RestaBtn                                                                ;Salta a la etiqueta 'RestaBtn' si es menor o igual
	CMP seleccion,0Ch                                                           ;Compara seleccion con 0Ch
	JLE MulBtn                                                                  ;Salta a la etiqueta 'MulBtn' si es menor o igual
	CMP seleccion,0Fh                                                           ;si la seleccion es igual a 15
	JLE DivBtn                                                                  ;Salta a la etiqueta 'DivBtn' si es menor o igual
	JMP Abajo                                                                   ;Salta a la etiqueta 'Abajo'
NUM_01:                                                                     	;Etiqueta 'NUM_01'
	JMP NUM                                                                     ;Salta a la etiqueta 'NUM'
Abajo:                                                                      	;Etiqueta 'Abajo'
	CMP seleccion,00h                                                           ;Compara seleccion con 00h
	JLE Btn1                                                                    ;Salta a la etiqueta 'Btn1' si es menor o igual
	CMP seleccion,01h                                                           ;Compara seleccion con 01h
	JLE Btn3                                                                    ;Salta a la etiqueta 'Btn3' si es menor o igual
	CMP seleccion,02h                                                           ;Compara seleccion con 02h
	JLE Btn6                                                                    ;Salta a la etiqueta 'Btn6' si es menor o igual
	CMP seleccion,03h                                                           ;Compara seleccion con 03h
	JLE Btn9                                                                    ;Salta a la etiqueta 'Btn9' si es menor o igual
	JMP Arriba                                                                  ;Salta a la etiqueta 'Arriba'
Enter_:                                                                     	;Etiqueta 'Enter_'
	CMP seleccion,00h                                                           ;Compara seleccion con 00h
	JE MAS                                                                      ;Salta si es igual a la etiqueta 'MAS'
	CMP seleccion,01h                                                           ;Compara seleccion con 01h
	JE MENOS                                                                    ;Salta si es igual a la etiqueta 'MENOS'
	CMP seleccion,02h                                                           ;Compara seleccion con 02h
	JE POR                                                                      ;Salta si es igual a la etiqueta 'POR'
	CMP seleccion,03h                                                           ;Compara seleccion con 03h
	JE ENTRE                                                                    ;Salta si es igual a la etiqueta 'ENTRE'
	JNE NUM                                                                     ;Salta si no es igual a la etiqueta 'NUM'
Bajar:                                                                      	;Etiqueta 'Bajar'
	MOV seleccion,04h                                                           ;asigna 4 a la seleccion (valor del primer boton de la segunda fila)
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
Subir:                                                                      	;Etiqueta 'Subir'
	MOV seleccion,00h                                                           ;asigna 0 a la seleccion (valor del primer boton de la primer fila)
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
Ultimo:                                                                     	;Etiqueta 'Ultimo'
	MOV seleccion,0Eh                                                           ;Asigna 0Eh a seleccion
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
RestaBtn:                                                                   	;Etiqueta 'RestaBtn'
	MOV seleccion,01h                                                           ;Asigna 01h a seleccion
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
MulBtn:                                                                     	;Etiqueta 'MulBtn'
	MOV seleccion,02h                                                           ;Asigna 02h a seleccion
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
DivBtn:                                                                     	;Etiqueta 'DivBtn'
	MOV seleccion,03h                                                           ;Asigna 03h a seleccion
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
Btn1:                                                                       	;Etiqueta 'Btn1'
	MOV seleccion,05h                                                           ;Asigna 05h a seleccion
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
Btn3:                                                                       	;Etiqueta 'Btn3'
	MOV seleccion,07h                                                           ;Asigna 07h a seleccion
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
Btn6:                                                                       	;Etiqueta 'Btn6'
	MOV seleccion,0Ah                                                           ;Asigna 0Ah a seleccion
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
Btn9:                                                                       	;Etiqueta 'Btn9'
	MOV seleccion,0Dh                                                           ;Asigna 0Dh a seleccion
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
MAS:                                                                        	;Etiqueta 'MAS'
	MOV aux,'+'                                                                 ;Asigna el contenido de '+' a aux
	JMP  entra                                                                  ;Salta a la etiqueta 'entra'
MENOS:                                                                      	;Etiqueta 'MENOS'
	MOV aux,'-'                                                                 ;Asigna el contenido de '-' a aux
	JMP  entra                                                                  ;Salta a la etiqueta 'entra'
POR:                                                                        	;Etiqueta 'POR'
	MOV aux,'x'                                                                 ;Asigna el contenido de 'x' a aux
	JMP  entra                                                                  ;Salta a la etiqueta 'entra'
ENTRE:                                                                      	;Etiqueta 'ENTRE'
	MOV aux,0F6h                                                                ;Asigna 0F6h a aux
	JMP  entra                                                                  ;Salta a la etiqueta 'entra'
NUM:                                                                        	;Etiqueta 'NUM'
	MOV Dl,seleccion                                                            ;Asigna el contenido de seleccion a Dl
	SUB Dl,04h                                                                  ;Resta 04h a Dl
	ADD Dl,30h                                                                  ;AGREGA 30h a Dl
	MOV aux,Dl                                                                  ;Asigna el contenido de Dl a aux
	CMP AL,2Bh                                                                  ;Compara AL con 2Bh
	JE MAS                                                                      ;Salta si es igual a la etiqueta 'MAS'
	CMP AL,2Dh                                                                  ;Compara AL con 2Dh
	JE MENOS                                                                    ;Salta si es igual a la etiqueta 'MENOS'
	CMP AL,2Fh                                                                  ;Compara AL con 2Fh
	JE ENTRE                                                                    ;Salta si es igual a la etiqueta 'ENTRE'
	CMP AL,2Ah                                                                  ;Compara AL con 2Ah
	JE POR                                                                      ;Salta si es igual a la etiqueta 'POR'
	CMP AX,1C0Dh                                                                ;Compara AX con 1C0Dh
	JE entra                                                                    ;Salta si es igual a la etiqueta 'entra'
	CMP Al,39h                                                                  ;Compara Al con 39h
	JE num_tecla                                                                ;Salta si es igual a la etiqueta 'num_tecla'
	CMP Al,38h                                                                  ;Compara Al con 38h
	JE num_tecla                                                                ;Salta si es igual a la etiqueta 'num_tecla'
	CMP Al,37h                                                                  ;Compara Al con 37h
	JE num_tecla                                                                ;Salta si es igual a la etiqueta 'num_tecla'
	CMP Al,36h                                                                  ;Compara Al con 36h
	JE num_tecla                                                                ;Salta si es igual a la etiqueta 'num_tecla'
	CMP Al,35h                                                                  ;Compara Al con 35h
	JE num_tecla                                                                ;Salta si es igual a la etiqueta 'num_tecla'
	CMP Al,34h                                                                  ;Compara Al con 34h
	JE num_tecla                                                                ;Salta si es igual a la etiqueta 'num_tecla'
	CMP Al,33h                                                                  ;Compara Al con 33h
	JE num_tecla                                                                ;Salta si es igual a la etiqueta 'num_tecla'
	CMP Al,32h                                                                  ;Compara Al con 32h
	JE num_tecla                                                                ;Salta si es igual a la etiqueta 'num_tecla'
	CMP Al,31h                                                                  ;Compara Al con 31h
	JE num_tecla                                                                ;Salta si es igual a la etiqueta 'num_tecla'
	CMP Al,30h                                                                  ;Compara Al con 30h
	JE num_tecla                                                                ;Salta si es igual a la etiqueta 'num_tecla'
	CMP AX,0B3Dh                                                                ;si se presiono la telca shif+=
	JE  num_igual                                                               ;Salta si es igual a la etiqueta 'num_igual'
	CMP Al,2Eh                                                                  ;si se presiono la telca . (izquierdo)
	JE  num_tecla                                                               ;Salta si es igual a la etiqueta 'num_tecla'
	JMP Invalida                                                                ;salta a la etiqueta Invalida

num_tecla:                                                                  	;Etiqueta 'num_tecla'
	MOV aux,Al                                                                  ;Asigna el contenido de Al a aux
	JMP entra                                                                   ;Salta a la etiqueta 'entra'
num_igual:                                                                  	;Etiqueta 'num_igual'
	MOV aux,03Ah                                                                ;Asigna 03Ah a aux
	JMP entra                                                                   ;Salta a la etiqueta 'entra'
entra:                                                                      	;Etiqueta 'entra'
ENTRADA Aux                                                                 	;Llamada a la Macro ENTRADA con los parametros : Aux
DISPLAY display_str                                                         	;Llamada a la Macro DISPLAY con los parametros : display_str
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)

Invalida:                                                                   	;Etiqueta 'Invalida'
	CMP AX,0E08h                                                                ;Compara AX con 0E08h
	JNE inv_                                                                    ;Salta si no es igual a la etiqueta 'inv_'
	JMP entra                                                                   ;Salta a la etiqueta 'entra'
inv_:                                                                       	;Etiqueta 'inv_'
	CMP Ax,011Bh                                                                ;SI Al es la tecla ESC
	JNE  Invalida_Interfaz                                                      ;Salta si no es igual a la etiqueta 'Invalida_Interfaz'
	Call Adios                                                                  ;termina el programa
         
Invalida_Interfaz:                                                          	;Etiqueta 'Invalida_Interfaz'
ERROR seleccion_invalida                                                    	;Llamada a la Macro ERROR con los parametros : seleccion_invalida
	JMP  inicio_Interfaz                                                        ;salta al inicio de la interfaz (recarga)
            
	RestituyeRegistros                                                          ;Restituye los registros de prosito general en 0
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	Interfaz endp                                                               ;Fin del procedimiento

	LineaXY proc near                                                           ;Inicia prodecimiento cercano 'LineaXY'
	MOV Dl,0CDh                                                                 ;Asigna 0CDh a Dl
	MOV Cl,[temp_tbl]                                                           ;Asigna el contenido de [temp_tbl] a Cl
	MOV Ah,02h                                                                  ;Asigna 02h a Ah
Impr_linea:                                                                 	;Etiqueta 'Impr_linea'
	GotoXY [temp_tbl+2h],[temp_tbl+4h]                                          ;mueve el cursor a las coordenadas ([temp_tbl+2h],[temp_tbl+4h])
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	inc [temp_tbl+2h]                                                           ;Incrementa en uno el valor de [temp_tbl+2h]
	Loop Impr_linea                                                             ;Salta a la etiqueta 'Impr_linea' y decrementa CX mientras no sea cero
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	LineaXY endp                                                                ;Fin del procedimiento
;______________________PROC_ImprimirXY (solo debe ser llamado por macro imprimir)________________ 
	ImprimirXY proc near                                                        ;Inicia prodecimiento cercano 'ImprimirXY'
	GotoXY ch,cl                                                                ;mueve el cursor a las coordenadas (ch,cl)
	MOV DI,0FFFFh                                                               ;Asigna 0FFFFh a DI
	MOV Ah,02                                                                   ;Asigna 02 a Ah

Impr_siguiente:                                                             	;Etiqueta 'Impr_siguiente'
	INC DI                                                                      ;Incrementa en uno el valor de DI
	MOV DL,[Bx+DI]                                                              ;Asigna el contenido de [Bx+DI] a DL
	CMP DL,13d                                                                  ;Compara DL con 13d
	JE NuevaLinea                                                               ;Salta si es igual a la etiqueta 'NuevaLinea'
	CMP DL,'$'                                                                  ;Compara DL con '$'
	JE Impr_salir                                                               ;Salta si es igual a la etiqueta 'Impr_salir'
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	JMP Impr_siguiente                                                          ;Salta a la etiqueta 'Impr_siguiente'

NuevaLinea:                                                                 	;Etiqueta 'NuevaLinea'
	inc cl                                                                      ;Incrementa en uno el valor de cl
	MOV dh,cl                                                                   ;Asigna el contenido de cl a dh
	GotoXY ch,cl                                                                ;mueve el cursor a las coordenadas (ch,cl)
	JMP Impr_siguiente                                                          ;Salta a la etiqueta 'Impr_siguiente'
Impr_salir:                                                                 	;Etiqueta 'Impr_salir'
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	ImprimirXY endp                                                             ;Fin del procedimiento
;______________________CLS_PROC______________________
	Cls proc near                                                               ;Inicia prodecimiento cercano 'Cls'
        
	MOV ch, 32                                                                  ;asigna 32 a ch (oculta buffer del cursor)
	MOV Ah, 1                                                                   ;instruccion 1 de la int 10
	int 10h                                                                     ;Interrupcion 10h (Servicios de Pantalla)
    
	MOV Ah, 06h                                                                 ;limpia la pantalla
	MOV al, 00h                                                                 ;coordenas de inicio en x
MOV Bh, 0F1h                                                                	;F:Color Blanco(Fondo),1:Azul(Texto)
	MOV Cx, 0000h                                                               ;coordenas de inicio en y
	MOV Dx, 184Fh                                                               ;tama�o de la pantalla ()
	int 10h                                                                     ;Interrupcion 10h (Servicios de Pantalla)
 
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	Cls endp                                                                    ;Fin del procedimiento
;______________________MarcoXY solo llamado por la Macro Marco______________________
	MarcoXY proc near                                                           ;Inicia prodecimiento cercano 'MarcoXY'
        
	GotoXY [temp_tbl+2h],[temp_tbl+3h]                                          ;mueve el cursor a las coordenadas especificadas
	MOV dl,0C9h                                                                 ;asina a dl en primer caracter (esquina izquierda)
	MOV Ah,02                                                                   ;Asigna 02 a Ah
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
        
	MOV Cl,[temp_tbl+1h]                                                        ;asigna a Cl el ancho del cuadro
	DEC Cl                                                                      ;decrementa Cl para obtener el valor real de el ancho
	MOV dl,0CDh                                                                 ;asigna a dl el segundo caracter (linea)
Car_filaArr:                                                                	;Etiqueta 'Car_filaArr'
        
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	Loop Car_filaArr                                                            ;Salta a la etiqueta 'Car_filaArr' y decrementa CX mientras no sea cero
        
	MOV dl,0BBh                                                                 ;asigna a dl el segundo caracter (esquina derecha)
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
        
	MOV Al,[temp_tbl+3h]                                                        ;mueve a al el valor de la coordenada en Y
	ADD Al,[temp_tbl]                                                           ;suma (Y+alto) para obtener la posicion de la esquina inferior izquierda
        
	GotoXY [temp_tbl+2h],Al                                                     ;mueve el cursor a las coordenadas especificadas
        
	MOV dl,0C8h                                                                 ;asina a dl el caracter (esquina izquierda)
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
        
	MOV Cl,[temp_tbl+1h]                                                        ;asigna a Cl el ancho del cuadro
	DEC Cl                                                                      ;decrementa Cl para obtener el valor real de el ancho
	MOV dl,0CDh                                                                 ;asigna a dl el segundo caracter (linea)

Car_filaAba:                                                                	;Etiqueta 'Car_filaAba'
        
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	Loop Car_filaAba                                                            ;Salta a la etiqueta 'Car_filaAba' y decrementa CX mientras no sea cero
        
	MOV dl,0BCh                                                                 ;asigna a dl el caracter (esquina inferior derecha)
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
        
	MOV DL,0BAh                                                                 ;asigna a dl el caracter (columna)
	MOV Bl,[temp_tbl+3h]                                                        ;mueve a Bl el valor de la coordenada en Y
	INC Bl                                                                      ;incrementa al para saltar la esquina superior
	MOV Cl,[temp_tbl]                                                           ;Asigna el contenido de [temp_tbl] a Cl
	DEC Cl                                                                      ;decrementa Cl para obtener el valor real de el ancho
Car_columnaIzq:                                                             	;Etiqueta 'Car_columnaIzq'
                                                       
	GotoXY [temp_tbl+2h],Bl                                                     ;mueve el cursor a las coordenadas especificadas
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	Inc Bl                                                                      ;incrementa Bl para bajar una posicion en Y
	Loop Car_columnaIzq                                                         ;salta mientras Cl no sea 0
  
	MOV Al,[temp_tbl+2h]                                                        ;asigna a Al el valor de X
	ADD Al,[temp_tbl+1h]                                                        ;suma (x+ancho) para obtener el ancho del marco
	MOV [temp_tbl+2h],Al                                                        ;mueve a X el valor del ancho del marco
        
	MOV Bl,[temp_tbl+3h]                                                        ;mueve a Bl el valor de la coordenada en Y
	INC Bl                                                                      ;incrementa al para saltar la esquina superior
	MOV Cl,[temp_tbl]                                                           ;Asigna el contenido de [temp_tbl] a Cl
	DEC Cl                                                                      ;decrementa Cl para obtener el valor real de el ancho
	MOV DL,0BAh                                                                 ;asigna a dl el caracter (columna)
Car_columnaDer:                                                             	;Etiqueta 'Car_columnaDer'
             
	GotoXY [temp_tbl+2h],Bl                                                     ;mueve el cursor a las coordenadas especificadas
	int 21h                                                                     ;Interrupcion 21h (funciones de el DOS API)
	INC Bl                                                                      ;incrementa al para saltar la esquina superior
	Loop Car_columnaDer                                                         ;Salta a la etiqueta 'Car_columnaDer' y decrementa CX mientras no sea cero
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	MarcoXY endp                                                                ;Fin del procedimiento
;______________________PROC_CARATULA________________
	Caratula proc near                                                          ;Inicia prodecimiento cercano 'Caratula'
	Call Cls                                                                    ;Llamada al procedimiento 'Cls'
Marco 16h,4Eh,0h,1h                                                         	;Llamada a la Macro Marco con los parametros : 16h,4Eh,0h,1h
Imprime caratula_str,02h,02H                                                	;Llamada a la Macro Imprime con los parametros : caratula_str,02h,02H
	XOR Ax,Ax                                                                   ;Resituye el registro  Ax a ceros por medio de XOR
	int 16h                                                                     ;Interrupcion 16h (funciones de llamada al teclado)
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	Caratula endp                                                               ;Fin del procedimiento
;______________________PROC_Adios________________
	Adios proc near                                                             ;Inicia prodecimiento cercano 'Adios'
        
	Call Cls                                                                    ;Llamada al procedimiento 'Cls'
Marco 16h,4Eh,0h,1h                                                         	;Llamada a la Macro Marco con los parametros : 16h,4Eh,0h,1h
Imprime despedida_str,02h,02H                                               	;Llamada a la Macro Imprime con los parametros : despedida_str,02h,02H
GotoXY 0h,017h                                                              	;Llamada a la Macro GotoXY con los parametros : 0h,017h
	MOV AH,4CH                                                                  ;Asigna 4CH a AH
	INT 21H                                                                     ;Interrupcion 21h (funciones de el DOS API)
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	Adios endp                                                                  ;Fin del procedimiento
;______________________PROC_Resolver________________  
	RESOLVER proc near                                                          ;Inicia prodecimiento cercano 'RESOLVER'
	CALL AJUSTA_OPERANDOS                                                       ;Llamada al procedimiento 'AJUSTA_OPERANDOS'
	CMP operacion,'+'                                                           ;Compara operacion con '+'
	JE Suma_Op                                                                  ;Salta si es igual a la etiqueta 'Suma_Op'
	CMP operacion,'-'                                                           ;Compara operacion con '-'
	JE Resta_Op                                                                 ;Salta si es igual a la etiqueta 'Resta_Op'
	CMP operacion,'x'                                                           ;Compara operacion con 'x'
	JE Multiplicacion_Op                                                        ;Salta si es igual a la etiqueta 'Multiplicacion_Op'
	CMP operacion,0F6h                                                          ;Compara operacion con 0F6h
	JE  Division_Op                                                             ;Salta si es igual a la etiqueta 'Division_Op'
	JMP Agrega_pila                                                             ;Salta a la etiqueta 'Agrega_pila'
Suma_Op:                                                                    	;Etiqueta 'Suma_Op'
	CALL SUMA                                                                   ;Llamada al procedimiento 'SUMA'
	JMP Agrega_pila                                                             ;Salta a la etiqueta 'Agrega_pila'
Resta_Op:                                                                   	;Etiqueta 'Resta_Op'
	CALL RESTA                                                                  ;Llamada al procedimiento 'RESTA'
	JMP Agrega_pila                                                             ;Salta a la etiqueta 'Agrega_pila'
Multiplicacion_Op:                                                          	;Etiqueta 'Multiplicacion_Op'
	CALL MULTIPLICA                                                             ;Llamada al procedimiento 'MULTIPLICA'
	JMP Agrega_pila                                                             ;Salta a la etiqueta 'Agrega_pila'
Division_Op:                                                                	;Etiqueta 'Division_Op'
	CALL DIVIDE                                                                 ;Llamada al procedimiento 'DIVIDE'
 
	JMP Agrega_pila                                                             ;Salta a la etiqueta 'Agrega_pila'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ENVIAR A LA PILA LA OPERACION
Agrega_pila:                                                                	;Etiqueta 'Agrega_pila'
	cmp renglones_pila,07h                                                      ;Compara renglones_pila con 07h
	JAE reinicia_pila                                                           ;Salta a la etiqueta 'reinicia_pila' si es mayor o igual
	JMP continuar                                                               ;Salta a la etiqueta 'continuar'
reinicia_pila:                                                              	;Etiqueta 'reinicia_pila'
	mov renglones_pila,00h                                                      ;Asigna 00h a renglones_pila
	mov posicion_pila,00h                                                       ;Asigna 00h a posicion_pila
continuar:                                                                  	;Etiqueta 'continuar'
        ;;Envia la ultima operacion a la pila de operaciones
	MOV SI,0000h                                                                ;Asigna 0000h a SI
	mov DI,posicion_pila                                                        ;Asigna el contenido de posicion_pila a DI
agregar_operacion:                                                          	;Etiqueta 'agregar_operacion'
		       
	MOV AL,display_str[SI]                                                      ;Asigna el contenido de display_str[SI] a AL
	CMP AL,'$'                                                                  ;Compara AL con '$'
	JE agregar_resultado                                                        ;Salta si es igual a la etiqueta 'agregar_resultado'
	MOV pila_operaciones[DI],AL                                                 ;Asigna el contenido de AL a pila_operaciones[DI]
		     
	INC SI                                                                      ;Incrementa en uno el valor de SI
	INC DI                                                                      ;Incrementa en uno el valor de DI
	JMP agregar_operacion                                                       ;Salta a la etiqueta 'agregar_operacion'
		    
agregar_resultado:                                                          	;Etiqueta 'agregar_resultado'
	MOV pila_operaciones[DI],'='                                                ;Asigna el contenido de '=' a pila_operaciones[DI]
	MOV SI,0000h                                                                ;Asigna 0000h a SI
copy_result_str:                                                            	;Etiqueta 'copy_result_str'
            ;;RESULTADO DESPUES DE SIGNO =
	MOV AL,resultado_str[SI]                                                    ;Asigna el contenido de resultado_str[SI] a AL
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP AL,07h                                                                  ;Compara AL con 07h
	JNE add_restdo                                                              ;Salta si no es igual a la etiqueta 'add_restdo'
	JMP copy_result_str                                                         ;Salta a la etiqueta 'copy_result_str'
add_restdo:                                                                 	;Etiqueta 'add_restdo'
	CMP AL,'$'                                                                  ;Compara AL con '$'
	JE fin_add_restdo                                                           ;Salta si es igual a la etiqueta 'fin_add_restdo'
	INC DI                                                                      ;Incrementa en uno el valor de DI
	MOV pila_operaciones[DI],AL                                                 ;Asigna el contenido de AL a pila_operaciones[DI]
	JMP copy_result_str                                                         ;Salta a la etiqueta 'copy_result_str'

fin_add_restdo:                                                             	;Etiqueta 'fin_add_restdo'

            ;;agrega el salto de linea en la pila
	INC DI                                                                      ;Incrementa en uno el valor de DI
	MOV pila_operaciones[DI],13d                                                ;Asigna 13d a pila_operaciones[DI]
	INC DI                                                                      ;Incrementa en uno el valor de DI
	mov posicion_pila,DI                                                        ;Asigna el contenido de DI a posicion_pila
	mov pila_operaciones[DI],'$'                                                ;Asigna el contenido de '$' a pila_operaciones[DI]
	inc renglones_pila                                                          ;
        ;;Fin Envia                        
vacia:                                                                      	;limpiar el display
	MOV display_str[0],'$'                                                      ;corta la cadena del display
	MOV posicion_entrada,0h                                                     ;establece la posicion de la cadena display en cero
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	Resolver endp                                                               ;Fin del procedimiento
;______________________PROC_AJUSTE_PRE_OPERACIONAL________________ 
AJUSTA_OPERANDOS PROC NEAR                                                  	;Inicia prodecimiento cercano 'AJUSTA_OPERANDOS'
;en este procedimiento aux contiene el numero que estamos procesando
;0 para el numero_1 y 1 para el numero_2     
	MOV aux,00h                                                                 ;lo iniciamos en 0 para el primer operando
	MOV operacion,00h                                                           ;Asigna 00h a operacion
;LEER LA OPERACION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;LEER LA OPERACION DESDE EL PRIMER DIGITO MAS A LA IZQUIERDA
	MOV SI,00h                                                                  ;Asigna 00h a SI

siguiente_caracter_de_entrada:                                              	;Etiqueta 'siguiente_caracter_de_entrada'
    
	MOV AL,display_str[SI]                                                      ;Asigna el contenido de display_str[SI] a AL
    
	CMP Al,'-'                                                                  ;Compara Al con '-'
	JE signo_negativo_detectado                                                 ;Salta si es igual a la etiqueta 'signo_negativo_detectado'
	CMP Al,'+'                                                                  ;Compara Al con '+'
	JE signo_positivo_detectado                                                 ;Salta si es igual a la etiqueta 'signo_positivo_detectado'
	CMP Al,'x'                                                                  ;Compara Al con 'x'
	JE operador_detectado                                                       ;Salta si es igual a la etiqueta 'operador_detectado'
	CMP Al,0F6h                                                                 ;Compara Al con 0F6h
	JE operador_detectado                                                       ;Salta si es igual a la etiqueta 'operador_detectado'
	JMP numero                                                                  ;Salta a la etiqueta 'numero'
signo_negativo_detectado:                                                   	;Etiqueta 'signo_negativo_detectado'
	CMP aux,00h                                                                 ;si aux es 1 estamos procesando los signos del primer operando
	JNE segundo_operando_negativo                                               ;de lo contrario estamos procesando el signo de el segundo operando
	XOR num1_signo, 01b                                                         ;Aplica la operacion XOR con num1_signo y  01b
	JMP continue                                                                ;Salta a la etiqueta 'continue'
segundo_operando_negativo:                                                  	;Etiqueta 'segundo_operando_negativo'
	XOR num2_signo, 01b                                                         ;Aplica la operacion XOR con num2_signo y  01b

signo_positivo_detectado:                                                   	;Etiqueta 'signo_positivo_detectado'
	CMP aux,00h                                                                 ;si aux es 1 estamos procesando los signos del primer operando
	JNE posible_operacional_suma                                                ;Salta si no es igual a la etiqueta 'posible_operacional_suma'
                     ;si no se toma como signo operacional si es que no existe alguno de mayor jerarquia
                     ; como (*,/,-)
	JMP continue                                                                ;Salta a la etiqueta 'continue'
operador_detectado:                                                         	;Etiqueta 'operador_detectado'
                   
                 ; si hay un doble operador
	CMP operacion,'x'                                                           ;Compara operacion con 'x'
	JE sintaxs_error_jmp                                                        ;Salta si es igual a la etiqueta 'sintaxs_error_jmp'
	CMP operacion,0F6h                                                          ;Compara operacion con 0F6h
	JE sintaxs_error_jmp                                                        ;Salta si es igual a la etiqueta 'sintaxs_error_jmp'
	CMP aux,00h                                                                 ;si aux es 1 estamos procesando los signos del primer operando
	JE sintaxs_error_jmp                                                        ;Salta si es igual a la etiqueta 'sintaxs_error_jmp'
	MOV operacion,Al                                                            ;Asigna el contenido de Al a operacion
                 ;
	JMP continue                                                                ;Salta a la etiqueta 'continue'
posible_operacional_suma:                                                   	;Etiqueta 'posible_operacional_suma'
	CMP operacion,'x'                                                           ;Compara operacion con 'x'
	JE continue                                                                 ;Salta si es igual a la etiqueta 'continue'
	CMP operacion,'-'                                                           ;Compara operacion con '-'
	JE continue                                                                 ;Salta si es igual a la etiqueta 'continue'
	CMP operacion,0F6h                                                          ;Compara operacion con 0F6h
	JE continue                                                                 ;Salta si es igual a la etiqueta 'continue'
                 ;solo se asigna el operador suma si no existe uno de mayor jerarquia de lo contrario
                 ;el signo mas se considera un indicador de signo
	MOV operacion,'+'                                                           ;Asigna el contenido de '+' a operacion
    
continue:                                                                   	;Etiqueta 'continue'
	INC SI                                                                      ;Incrementa en uno el valor de SI
;CMP SI,POSICION_ENTRADA 
;JL siguiente_caracter_de_entrada 
	JMP siguiente_caracter_de_entrada                                           ;Salta a la etiqueta 'siguiente_caracter_de_entrada'
numero:                                                                     	;Etiqueta 'numero'
	MOV DI,09h                                                                  ;iniciamos el destino en la ultima posicion de los numeros enteros
    ;
	JMP siguiente_numero                                                        ;Salta a la etiqueta 'siguiente_numero'
sintaxs_error_jmp:                                                          	;Etiqueta 'sintaxs_error_jmp'
	JMP sintaxs_error                                                           ;Salta a la etiqueta 'sintaxs_error'
    ;
siguiente_numero:                                                           	;Etiqueta 'siguiente_numero'
	MOV AL,display_str[SI]                                                      ;Asigna el contenido de display_str[SI] a AL
	CMP AL,'.'                                                                  ;si se estan comenzando los numeros decimales
	JE decimal                                                                  ;Salta si es igual a la etiqueta 'decimal'
    
	SUB AL,30h                                                                  ;restamos 30h para obtener el numero real
    
	CMP AL,09h                                                                  ;Compara AL con 09h
	JA no_mas_numero                                                            ;si ya terminaron los numeros
        
	ADD AL,30h                                                                  ;AGREGA 30h a AL
	CMP aux,00h                                                                 ;si aux es 1 estamos procesando los signos del primer operando
	JNE num_2_e                                                                 ;si no es de el numero 1 y es entero
            
	MOV num1[DI],Al                                                             ;Asigna el contenido de Al a num1[DI]
	DEC DI                                                                      ;Decrementa en uno el valor de DI
	JNS continue_numero                                                         ;Salta a la etiqueta 'continue_numero' si no hay signo el ZF
	JMP mas_10_numeros                                                          ;Salta a la etiqueta 'mas_10_numeros'
num_2_e:                                                                    	;Etiqueta 'num_2_e'
	MOV num2[DI],Al                                                             ;Asigna el contenido de Al a num2[DI]
	DEC DI                                                                      ;Decrementa en uno el valor de DI
	JNS continue_numero                                                         ;Salta a la etiqueta 'continue_numero' si no hay signo el ZF
	JMP mas_10_numeros                                                          ;Salta a la etiqueta 'mas_10_numeros'
               
    
continue_numero:                                                            	;Etiqueta 'continue_numero'
	INC SI                                                                      ;Incrementa en uno el valor de SI
	JMP siguiente_numero                                                        ;Salta a la etiqueta 'siguiente_numero'
        
no_mas_numero:                                                              	;Etiqueta 'no_mas_numero'
    
	XOR aux,01b                                                                 ;si aux era 0 lo volvemos 1
	CMP aux,00h                                                                 ;si aux es 1 estamos procesando los signos del primer operando
	JE termine                                                                  ;Salta si es igual a la etiqueta 'termine'
	JMP siguiente_caracter_de_entrada                                           ;Salta a la etiqueta 'siguiente_caracter_de_entrada'
                                      ;numero o simbolos si es que existen  
decimal:                                                                    	;Etiqueta 'decimal'
	MOV DI,01h                                                                  ;Asigna 01h a DI
continue_decimal:                                                           	;Etiqueta 'continue_decimal'
	INC SI                                                                      ;Incrementa en uno el valor de SI
	MOV Al,display_str[SI]                                                      ;Asigna el contenido de display_str[SI] a Al
	CMP AL,'.'                                                                  ;si se estan comenzando los numeros decimales
	JE no_mas_numero_d                                                          ;Salta si es igual a la etiqueta 'no_mas_numero_d'
	CMP AL,'-'                                                                  ;Compara AL con '-'
	JE no_mas_numero_d                                                          ;Salta si es igual a la etiqueta 'no_mas_numero_d'
	CMP AL,'x'                                                                  ;Compara AL con 'x'
	JE no_mas_numero_d                                                          ;Salta si es igual a la etiqueta 'no_mas_numero_d'
	CMP AL,0F6h                                                                 ;entre � (alt +246)
	JE no_mas_numero_d                                                          ;Salta si es igual a la etiqueta 'no_mas_numero_d'
    
	JMP entrada_correcta_decimal                                                ;Salta a la etiqueta 'entrada_correcta_decimal'
    
entrada_correcta_decimal:                                                   	;Etiqueta 'entrada_correcta_decimal'
	SUB AL,30h                                                                  ;restamos 30h para obtener el numero real
	CMP AL,09h                                                                  ;Compara AL con 09h
	JA no_mas_numero_d                                                          ;si ya terminaron los numeros
                ;ADD AL,30h
	CMP aux,00h                                                                 ;si aux es 1 estamos procesando los signos del primer operando
	JNE num_2_e_d                                                               ;Salta si no es igual a la etiqueta 'num_2_e_d'
                    
	MOV decimales_1[DI],Al                                                      ;Asigna el contenido de Al a decimales_1[DI]
	INC DI                                                                      ;Incrementa en uno el valor de DI
	CMP DI,0Bh                                                                  ;Compara DI con 0Bh
	JL  continue_decimal                                                        ;Salta a la etiqueta 'continue_decimal' si es menor
	JMP mas_10_numeros                                                          ;Salta a la etiqueta 'mas_10_numeros'
                    
num_2_e_d:                                                                  	;Etiqueta 'num_2_e_d'
                     
	MOV decimales_2[DI],Al                                                      ;Asigna el contenido de Al a decimales_2[DI]
	INC DI                                                                      ;Incrementa en uno el valor de DI
	CMP DI,0Bh                                                                  ;Compara DI con 0Bh
	JL  continue_decimal                                                        ;Salta a la etiqueta 'continue_decimal' si es menor
	JMP mas_10_numeros                                                          ;Salta a la etiqueta 'mas_10_numeros'
                                        
no_mas_numero_d:                                                            	;Etiqueta 'no_mas_numero_d'
	JMP no_mas_numero                                                           ;Salta a la etiqueta 'no_mas_numero'
    
termine:                                                                    	;Etiqueta 'termine'
    ;si ambos son negativos o positivos=>
	MOV AL,num2_signo                                                           ;Asigna el contenido de num2_signo a AL
	CMP num1_signo,Al                                                           ;Compara num1_signo con Al
	JE signos_iguales                                                           ;Salta si es igual a la etiqueta 'signos_iguales'
	JMP signos_diferentes                                                       ;Salta a la etiqueta 'signos_diferentes'
signos_iguales:                                                             	;Etiqueta 'signos_iguales'
            ;si la operacion es suma,division o multipliacion
	CMP operacion,'x'                                                           ;Compara operacion con 'x'
	JE diferente_mul                                                            ;+*+=>  (+) le correponde a la multiplicacion
	CMP operacion,0F6h                                                          ;Compara operacion con 0F6h
	JE diferente_mul                                                            ;+*+=>  (+) le correponde a la multiplicacion
	CMP operacion,'+'                                                           ;Compara operacion con '+'
	JE iguales_mult                                                             ;+-+ => (+,-) le corresponde a la resta
	CMP operacion,'-'                                                           ;Compara operacion con '-'
	JE iguales_suma_neg                                                         ;Salta si es igual a la etiqueta 'iguales_suma_neg'
    
signos_diferentes:                                                          	;Etiqueta 'signos_diferentes'
	MOV AL,num2_signo                                                           ;Asigna el contenido de num2_signo a AL
	CMP num1_signo,Al                                                           ;Compara num1_signo con Al
	JA neg_pos                                                                  ;si el signo del primer operando es (-) y el segundo es (+) => (-)>(+)=?
	JMP pos_neg                                                                 ;si el signo del primer operando es (+) y el segundo es (-) => (+)>(-)=?
        ;si el signo del primer operando es (-) y el segundo es (+) => (-)>(+)=?
neg_pos:                                                                    	;Etiqueta 'neg_pos'
	CMP operacion,'+'                                                           ;Compara operacion con '+'
	JE  resta_invertida                                                             ;con los operandos invertidos
	CMP operacion,'-'                                                           ;Compara operacion con '-'
	JE resta_invertida                                                          ;con los operandos invertidos
	CMP operacion,'x'                                                           ;Compara operacion con 'x'
	JE diferente_mul                                                            ;+*+=>  (+) le correponde a la multiplicacion
	CMP operacion,0F6h                                                          ;Compara operacion con 0F6h
	JE diferente_mul                                                            ;+*+=>  (+) le correponde a la multiplicacion
	JMP ley_signos_end                                                          ;Salta a la etiqueta 'ley_signos_end'
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;   
resta_normi:                                                                    ;Etiqueta 'resta_normi'
    MOV operacion,'-'                                                           ;Asigna el contenido de '-' a operacion 
    MOV es_negativo_res,0h                                                      ;Asinga 0h a es_negativo_res
    JMP ley_signos_end                                                          ;Salta a la etiqueta 'ley_signos_end'
iguales_mult:                                                               	;Etiqueta 'iguales_mult'
    ;el resultado conservara su signo
	MOV es_negativo_res,Al                                                      ;Asigna el contenido de Al a es_negativo_res
	JMP ley_signos_end                                                          ;Salta a la etiqueta 'ley_signos_end'
    
iguales_suma_neg:                                                           	;Etiqueta 'iguales_suma_neg'
	MOV operacion,'+'                                                           ;Asigna el contenido de '+' a operacion
	MOV es_negativo_res,Al                                                      ;Asigna el contenido de Al a es_negativo_res
	JMP ley_signos_end                                                          ;Salta a la etiqueta 'ley_signos_end'
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
diferente_mul:                                                              	;Etiqueta 'diferente_mul'
	MOV AL,num2_signo                                                           ;Asigna el contenido de num2_signo a AL
	XOR AL,num1_signo                                                           ;Aplica la operacion XOR con AL y num1_signo
	MOV es_negativo_res,Al                                                      ;Asigna el contenido de Al a es_negativo_res
	JMP ley_signos_end                                                          ;Salta a la etiqueta 'ley_signos_end'
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
resta_invertida:                                                            	;Etiqueta 'resta_invertida'
    ;copiamos el numero num2 a la variable temporal ajuste_decimales_1
	MOV SI,00h                                                                  ;Asigna 00h a SI
num2_inversion_cpy:                                                         	;Etiqueta 'num2_inversion_cpy'
	MOV AL,num2[SI]                                                             ;Asigna el contenido de num2[SI] a AL
	MOV ajuste_decimales_1[SI],AL                                               ;Asigna el contenido de AL a ajuste_decimales_1[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE num2_inversion_cpy                                                      ;Salta a la etiqueta 'num2_inversion_cpy' si es menor o igual
    ;copiamos el numero (num1) menor a num2
	MOV SI,00h                                                                  ;Asigna 00h a SI
num2_inversion1_cpy:                                                        	;Etiqueta 'num2_inversion1_cpy'
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	MOV num2[SI],AL                                                             ;Asigna el contenido de AL a num2[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE num2_inversion1_cpy                                                     ;Salta a la etiqueta 'num2_inversion1_cpy' si es menor o igual
    ;copiamos el numero en ajuste_decimales_1 a num1
	MOV SI,00h                                                                  ;Asigna 00h a SI
num1_inversion_cpy:                                                         	;Etiqueta 'num1_inversion_cpy'
	MOV AL,ajuste_decimales_1[SI]                                               ;Asigna el contenido de ajuste_decimales_1[SI] a AL
	MOV num1[SI],AL                                                             ;Asigna el contenido de AL a num1[SI]
	MOV ajuste_decimales_1[SI],00h                                              ;limpiamos la variable temporal
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE num1_inversion_cpy                                                      ;Salta a la etiqueta 'num1_inversion_cpy' si es menor o igual
    ;;INVERTIR LOS DECIMALES TAMBIEN
    ;------------------------------------------------------------------
    ;copiamos el numero mayor (decimales_2) a la variable temporal ajuste_decimales_1
	MOV SI,00h                                                                  ;Asigna 00h a SI
dec2_inversion_cpy:                                                         	;Etiqueta 'dec2_inversion_cpy'
	MOV AL,decimales_2[SI]                                                      ;Asigna el contenido de decimales_2[SI] a AL
	MOV ajuste_decimales_1[SI],AL                                               ;Asigna el contenido de AL a ajuste_decimales_1[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE dec2_inversion_cpy                                                      ;Salta a la etiqueta 'dec2_inversion_cpy' si es menor o igual
    ;copiamos el numero (decimales_1) menor a decimales_2
	MOV SI,00h                                                                  ;Asigna 00h a SI
dec2_inversion1_cpy:                                                        	;Etiqueta 'dec2_inversion1_cpy'
	MOV AL,decimales_1[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	MOV decimales_2[SI],AL                                                      ;Asigna el contenido de AL a decimales_2[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE dec2_inversion1_cpy                                                     ;Salta a la etiqueta 'dec2_inversion1_cpy' si es menor o igual
    ;copiamos el numero mayor guardado en ajuste_decimales_1 a decimales_1
	MOV SI,00h                                                                  ;Asigna 00h a SI
dec1_inversion_cpy:                                                         	;Etiqueta 'dec1_inversion_cpy'
	MOV AL,ajuste_decimales_1[SI]                                               ;Asigna el contenido de ajuste_decimales_1[SI] a AL
	MOV decimales_1[SI],AL                                                      ;Asigna el contenido de AL a decimales_1[SI]
	MOV ajuste_decimales_1[SI],00h                                              ;limpiamos la variable temporal
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE dec1_inversion_cpy                                                      ;Salta a la etiqueta 'dec1_inversion_cpy' si es menor o igual
	MOV operacion,'-'                                                           ;Asigna el contenido de '-' a operacion
	JMP ley_signos_end                                                          ;Salta a la etiqueta 'ley_signos_end'
;------------------------------------------------------------------
    ;si el signo del primer operando es (+) y el segundo es (-) => (+)>(-)=?
    
pos_neg:                                                                    	;Etiqueta 'pos_neg'
	CMP operacion,'+'                                                           ;Compara operacion con '+'
	JE resta_invertida                                                          ;con los operandos invertidos
	CMP operacion,'-'                                                           ;Compara operacion con '-'
	JE suma_pos                                                                 ;
	CMP operacion ,'x'                                                          ;se multiplican los signos en ambos casos (-)*(-)=+ (+)*(+)=+ -*+=-
	JE pos_neg_mul                                                              ;Salta si es igual a la etiqueta 'pos_neg_mul'
	CMP operacion,0F6h                                                          ;Compara operacion con 0F6h
	JE pos_neg_mul                                                              ;Salta si es igual a la etiqueta 'pos_neg_mul'
suma_pos:                                                                   	;Etiqueta 'suma_pos'
	MOV operacion,'+'                                                           ;Asigna el contenido de '+' a operacion
	MOV es_negativo_res,00h                                                     ;Asigna 00h a es_negativo_res
	JMP ley_signos_end                                                          ;Salta a la etiqueta 'ley_signos_end'
    
pos_neg_mul:                                                                	;Etiqueta 'pos_neg_mul'
	MOV AL,num2_signo                                                           ;Asigna el contenido de num2_signo a AL
	XOR AL,num1_signo                                                           ;Aplica la operacion XOR con AL y num1_signo
	MOV es_negativo_res,Al                                                      ;Asigna el contenido de Al a es_negativo_res
	JMP ley_signos_end                                                          ;Salta a la etiqueta 'ley_signos_end'
             
ley_signos_end:                                                             	;Etiqueta 'ley_signos_end'

;;INVERTIMOS LAS PARTES ENTERAS DE LOS OPERANDOS PORQUE SE GUARDARON AL REVEZ
;lo copiamos ajustado a una variable auxiliar para ajustes de este tipo
	MOV CX,09h                                                                  ;Asigna 09h a CX
	MOV SI,00h                                                                  ;Asigna 00h a SI
Count_1:                                                                    	;Etiqueta 'Count_1'
	INC SI                                                                      ;Incrementa en uno el valor de SI
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	CMP AL,00h                                                                  ;Compara AL con 00h
	JNE fin_count1                                                              ;Salta si no es igual a la etiqueta 'fin_count1'
	Loop Count_1                                                                ;Salta a la etiqueta 'Count_1' y decrementa CX mientras no sea cero
fin_count1:                                                                 	;Etiqueta 'fin_count1'
	MOV BX,SI                                                                   ;Asigna el contenido de SI a BX


	MOV DI,09h                                                                  ;iniciamos el destino en la ultima posicion de los numeros enteros
return_num1:                                                                	;Etiqueta 'return_num1'
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	MOV ajuste_decimales_1[DI],Al                                               ;Asigna el contenido de Al a ajuste_decimales_1[DI]
	DEC DI                                                                      ;Decrementa en uno el valor de DI
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,0Ah                                                                  ;Compara SI con 0Ah
	JL return_num1                                                              ;Salta a la etiqueta 'return_num1' si es menor
;pasamos de la variable temporal ajustada a la definitiva
	MOV CX,09h                                                                  ;Asigna 09h a CX
adjust_num1:                                                                	;Etiqueta 'adjust_num1'
	MOV DI,CX                                                                   ;Asigna el contenido de CX a DI
	MOV AL,ajuste_decimales_1[DI]                                               ;Asigna el contenido de ajuste_decimales_1[DI] a AL
	SUB AL,30h                                                                  ;restamos 30h para obtener el numero real
	CMP AL,0D0h                                                                 ;Compara AL con 0D0h
	JE  fix_al1                                                                 ;Salta si es igual a la etiqueta 'fix_al1'
fixed_al1:                                                                  	;Etiqueta 'fixed_al1'
	MOV num1[DI],AL                                                             ;Asigna el contenido de AL a num1[DI]
	DEC CX                                                                      ;Decrementa en uno el valor de CX
	JNS adjust_num1                                                             ;Salta a la etiqueta 'adjust_num1' si no hay signo el ZF

;para el numero 2
	MOV CX,09h                                                                  ;Asigna 09h a CX
	MOV SI,00h                                                                  ;Asigna 00h a SI
Count_2:                                                                    	;Etiqueta 'Count_2'
	INC SI                                                                      ;Incrementa en uno el valor de SI
	MOV AL,num2[SI]                                                             ;Asigna el contenido de num2[SI] a AL
	CMP AL,00h                                                                  ;Compara AL con 00h
	JNE fin_count2                                                              ;Salta si no es igual a la etiqueta 'fin_count2'
	Loop Count_2                                                                ;Salta a la etiqueta 'Count_2' y decrementa CX mientras no sea cero
  
fin_count2:                                                                 	;Etiqueta 'fin_count2'
	MOV BX,SI                                                                   ;Asigna el contenido de SI a BX

	MOV DI,09h                                                                  ;iniciamos el destino en la ultima posicion de los numeros enteros
return_num2:                                                                	;Etiqueta 'return_num2'
	MOV AL,num2[SI]                                                             ;Asigna el contenido de num2[SI] a AL
	MOV ajuste_decimales_2[DI],Al                                               ;Asigna el contenido de Al a ajuste_decimales_2[DI]
	DEC DI                                                                      ;Decrementa en uno el valor de DI
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,0Ah                                                                  ;Compara SI con 0Ah
	JL return_num2                                                              ;Salta a la etiqueta 'return_num2' si es menor

;pasamos de la variable temporal ajustada a la definitiva
	MOV CX,09h                                                                  ;Asigna 09h a CX
adjust_num2:                                                                	;Etiqueta 'adjust_num2'
	MOV DI,CX                                                                   ;Asigna el contenido de CX a DI
	MOV AL,ajuste_decimales_2[DI]                                               ;Asigna el contenido de ajuste_decimales_2[DI] a AL
	SUB AL,30h                                                                  ;restamos 30h para obtener el numero real
	CMP AL,0D0h                                                                 ;Compara AL con 0D0h
	JE  fix_al2                                                                 ;Salta si es igual a la etiqueta 'fix_al2'
fixed_al2:                                                                  	;Etiqueta 'fixed_al2'
	MOV num2[DI],AL                                                             ;Asigna el contenido de AL a num2[DI]
	DEC CX                                                                      ;Decrementa en uno el valor de CX
	JNS adjust_num2                                                             ;Salta a la etiqueta 'adjust_num2' si no hay signo el ZF

	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
fix_al1:                                                                    	;Etiqueta 'fix_al1'
	ADD AL,30h                                                                  ;AGREGA 30h a AL
	JMP fixed_al1                                                               ;Salta a la etiqueta 'fixed_al1'

fix_al2:                                                                    	;Etiqueta 'fix_al2'
	ADD AL,30h                                                                  ;AGREGA 30h a AL
	JMP fixed_al2                                                               ;Salta a la etiqueta 'fixed_al2'

	JMP fin_ajusta_operandos                                                    ;Salta a la etiqueta 'fin_ajusta_operandos'
mas_10_numeros:                                                             	;Etiqueta 'mas_10_numeros'
ERROR Mas10_numeros                                                         	;Llamada a la Macro ERROR con los parametros : Mas10_numeros
	MOV resultado_str[00h],'E'                                                  ;Asigna el contenido de 'E' a resultado_str[00h]
	MOV resultado_str[01h],'R'                                                  ;Asigna el contenido de 'R' a resultado_str[01h]
	MOV resultado_str[02h],'R'                                                  ;Asigna el contenido de 'R' a resultado_str[02h]
	MOV resultado_str[03h],'O'                                                  ;Asigna el contenido de 'O' a resultado_str[03h]
	MOV resultado_str[04h],'R'                                                  ;Asigna el contenido de 'R' a resultado_str[04h]
	MOV resultado_str[05h],'$'                                                  ;Asigna el contenido de '$' a resultado_str[05h]
	MOV operacion,00h                                                           ;Asigna 00h a operacion
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
sintaxs_error:                                                              	;Etiqueta 'sintaxs_error'
ERROR sintax_error_msj                                                      	;Llamada a la Macro ERROR con los parametros : sintax_error_msj
	MOV resultado_str[00h],'E'                                                  ;Asigna el contenido de 'E' a resultado_str[00h]
	MOV resultado_str[01h],'R'                                                  ;Asigna el contenido de 'R' a resultado_str[01h]
	MOV resultado_str[02h],'R'                                                  ;Asigna el contenido de 'R' a resultado_str[02h]
	MOV resultado_str[03h],'O'                                                  ;Asigna el contenido de 'O' a resultado_str[03h]
	MOV resultado_str[04h],'R'                                                  ;Asigna el contenido de 'R' a resultado_str[04h]
	MOV resultado_str[05h],'$'                                                  ;Asigna el contenido de '$' a resultado_str[05h]
	MOV operacion,00h                                                           ;Asigna 00h a operacion
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
fin_ajusta_operandos:                                                       	;Etiqueta 'fin_ajusta_operandos'
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	AJUSTA_OPERANDOS ENDP                                                       ;Fin del procedimiento
;______________________PROC_SUMA________________ 
SUMA PROC NEAR                                                              	;Inicia prodecimiento cercano 'SUMA'
;SUMAR PARTES ENTERAS SIN IMPORTAR ACARREOS
	MOV DI,13h                                                                  ;Asigna 13h a DI
	MOV SI,09h                                                                  ;Asigna 09h a SI
	JMP siguiente_entero                                                        ;Salta a la etiqueta 'siguiente_entero'
fin_enteros:                                                                	;Etiqueta 'fin_enteros'
	MOV num_res[SI],'$'                                                         ;Asigna el contenido de '$' a num_res[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP siguiente_entero                                                        ;Salta a la etiqueta 'siguiente_entero'


siguiente_entero:                                                           	;Etiqueta 'siguiente_entero'
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE fin_enteros                                                              ;Salta si es igual a la etiqueta 'fin_enteros'
	ADD AL,num2[SI]                                                             ;Suma el valor de AL con el de num2[SI], el resultado queda en AL

	MOV num_res[DI],AL                                                          ;Asigna el contenido de AL a num_res[DI]

	DEC DI                                                                      ;Decrementa en uno el valor de DI
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS siguiente_entero                                                        ;Salta a la etiqueta 'siguiente_entero' si no hay signo el ZF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MOV num1[0Ah],'$'                                                           ;Asigna el contenido de '$' a num1[0Ah]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SUMAR PARTES DECIMALES SIN IMPORTAR ACARREOS
	MOV SI,0Ah                                                                  ;Asigna 0Ah a SI
	JMP siguiente_decimal                                                       ;Salta a la etiqueta 'siguiente_decimal'
fin_decimales:                                                              	;Etiqueta 'fin_decimales'
;MOV decimales_Res[SI],'$'
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP siguiente_decimal                                                       ;Salta a la etiqueta 'siguiente_decimal'
 
siguiente_decimal:                                                          	;Etiqueta 'siguiente_decimal'
	MOV AL,decimales_1[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE fin_decimales                                                            ;Salta si es igual a la etiqueta 'fin_decimales'
	ADD AL,decimales_2[SI]                                                      ;Suma el valor de AL con el de decimales_2[SI], el resultado queda en AL

	MOV decimales_Res[SI],AL                                                    ;Asigna el contenido de AL a decimales_Res[SI]

	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS siguiente_decimal                                                       ;Salta a la etiqueta 'siguiente_decimal' si no hay signo el ZF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JMP primer_vezSumando                                                       ;Salta a la etiqueta 'primer_vezSumando'
acarreo_del_Acarreo:                                                        	;Etiqueta 'acarreo_del_Acarreo'
	MOV hay_acarreo,00h                                                         ;Asigna 00h a hay_acarreo
primer_vezSumando:                                                          	;Etiqueta 'primer_vezSumando'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;AJUSTAR LOS ACARREOS DECIMALES
	MOV SI,0Ah                                                                  ;Asigna 0Ah a SI
	JMP siguiente_Acarreo_decimal                                               ;Salta a la etiqueta 'siguiente_Acarreo_decimal'
;
es_fin_decimal:                                                             	;Etiqueta 'es_fin_decimal'
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP siguiente_Acarreo_decimal                                               ;Salta a la etiqueta 'siguiente_Acarreo_decimal'
; 
AcarreoDecimal:                                                             	;Etiqueta 'AcarreoDecimal'
	MOV hay_acarreo,01h                                                         ;Asigna 01h a hay_acarreo
	MOV Al,decimales_Res[SI]                                                    ;Asigna el contenido de decimales_Res[SI] a Al
AAM                                                                         	;Desempaca AL (Divide Al entre 10 cociente:resuido AH:AL)
;;si es el primer numero decimal deselo a los enteros
	cmp SI,0000h                                                                ;Compara SI con 0000h
	JNE no_es_primero                                                           ;Salta si no es igual a la etiqueta 'no_es_primero'
	JMP es_primero                                                              ;Salta a la etiqueta 'es_primero'
;; 
no_es_primero:                                                              	;Etiqueta 'no_es_primero'
	ADD decimales_Res[SI-1],Ah                                                  ;AGREGA Ah a decimales_Res[SI-1]
	MOV decimales_Res[SI],Al                                                    ;Asigna el contenido de Al a decimales_Res[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP siguiente_Acarreo_decimal                                               ;Salta a la etiqueta 'siguiente_Acarreo_decimal'
es_primero:                                                                 	;Etiqueta 'es_primero'
;;--> es primero         
	MOV decimales_Res[SI],Al                                                    ;Asigna el contenido de Al a decimales_Res[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
;;fin el primero

siguiente_Acarreo_decimal:                                                  	;Etiqueta 'siguiente_Acarreo_decimal'
	CMP SI,0FFFFh                                                               ;Compara SI con 0FFFFh
	JE fin_ajuste_AcarreoDecimal                                                ;Salta si es igual a la etiqueta 'fin_ajuste_AcarreoDecimal'
	CMP decimales_Res[SI],'$'                                                   ;Compara decimales_Res[SI] con '$'
	JE es_fin_decimal                                                           ;Salta si es igual a la etiqueta 'es_fin_decimal'
	CMP decimales_Res[SI],0Ah                                                   ;Compara decimales_Res[SI] con 0Ah
	JAE AcarreoDecimal                                                          ;Salta a la etiqueta 'AcarreoDecimal' si es mayor o igual


	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS siguiente_Acarreo_decimal                                               ;Salta a la etiqueta 'siguiente_Acarreo_decimal' si no hay signo el ZF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
fin_ajuste_AcarreoDecimal:                                                  	;Etiqueta 'fin_ajuste_AcarreoDecimal'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;AJUSTAR LOS ACARREOS ENTEROS
	MOV SI,13h                                                                  ;Asigna 13h a SI
	JMP siguiente_Acarreo_entero                                                ;Salta a la etiqueta 'siguiente_Acarreo_entero'
;
es_fin_entero:                                                              	;Etiqueta 'es_fin_entero'
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JS  acarreos_pendientes_suma                                                ;Salta a la etiqueta 'acarreos_pendientes_suma' si hay signo el ZF
	JMP siguiente_Acarreo_entero                                                ;Salta a la etiqueta 'siguiente_Acarreo_entero'
; 
AcarreoEntero:                                                              	;Etiqueta 'AcarreoEntero'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CMP SI,0000h
	MOV hay_acarreo,01h                                                         ;Asigna 01h a hay_acarreo
	MOV Al,num_res[SI]                                                          ;Asigna el contenido de num_res[SI] a Al
AAM                                                                         	;Desempaca AL (Divide Al entre 10 cociente:resuido AH:AL)

	ADD num_res[SI-1],Ah                                                        ;AGREGA Ah a num_res[SI-1]
	MOV num_res[SI],Al                                                          ;Asigna el contenido de Al a num_res[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI

siguiente_Acarreo_entero:                                                   	;Etiqueta 'siguiente_Acarreo_entero'

	CMP decimales_Res[SI-1],'$'                                                 ;Compara decimales_Res[SI-1] con '$'
	JE es_fin_entero                                                            ;Salta si es igual a la etiqueta 'es_fin_entero'
	CMP num_res[SI],0Ah                                                         ;Compara num_res[SI] con 0Ah
	JAE AcarreoEntero                                                           ;Salta a la etiqueta 'AcarreoEntero' si es mayor o igual


	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS siguiente_Acarreo_entero                                                ;Salta a la etiqueta 'siguiente_Acarreo_entero' si no hay signo el ZF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
acarreos_pendientes_suma:                                                   	;Etiqueta 'acarreos_pendientes_suma'
;;;;;;;;;;;;;;;;AGREGAR ACARREOS PENDIENTES
	MOV AL,num_res[13h]                                                         ;Asigna el contenido de num_res[13h] a AL
	ADD AL,decimales_Res[0h]                                                    ;Suma el valor de AL con el de decimales_Res[0h], el resultado queda en AL
	MOV num_res[13h],Al                                                         ;Asigna el contenido de Al a num_res[13h]
	MOV decimales_Res[0h],00h                                                   ;limpiar el acarreo

	CMP hay_acarreo,01h                                                         ;Compara hay_acarreo con 01h
	JNE no_mas_acarreo                                                          ;Salta si no es igual a la etiqueta 'no_mas_acarreo'
	JMP acarreo_del_Acarreo                                                     ;Salta a la etiqueta 'acarreo_del_Acarreo'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera
no_mas_acarreo:                                                             	;Etiqueta 'no_mas_acarreo'
	MOV SI,13h                                                                  ;Asigna 13h a SI
	JMP inicia_ajuste                                                           ;Salta a la etiqueta 'inicia_ajuste'
salta_fin:                                                                  	;Etiqueta 'salta_fin'
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP inicia_ajuste                                                           ;Salta a la etiqueta 'inicia_ajuste'
inicia_ajuste:                                                              	;Etiqueta 'inicia_ajuste'
	MOV AL,num_res[SI]                                                          ;Asigna el contenido de num_res[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE salta_fin                                                                ;Salta si es igual a la etiqueta 'salta_fin'
	ADD AL,30h                                                                  ;AGREGA 30h a AL
	MOV num_res[SI],AL                                                          ;lo devuelve convertido en ascii a la posicion de donde lo tomo
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS inicia_ajuste                                                           ;Salta a la etiqueta 'inicia_ajuste' si no hay signo el ZF
;;ajustar la parte decimal
	MOV SI,13h                                                                  ;Asigna 13h a SI
	JMP inicia_ajuste_d                                                         ;Salta a la etiqueta 'inicia_ajuste_d'
salta_fin_d:                                                                	;Etiqueta 'salta_fin_d'
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP inicia_ajuste_d                                                         ;Salta a la etiqueta 'inicia_ajuste_d'
inicia_ajuste_d:                                                            	;Etiqueta 'inicia_ajuste_d'
	MOV AL,decimales_Res[SI]                                                    ;Asigna el contenido de decimales_Res[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE salta_fin_d                                                              ;Salta si es igual a la etiqueta 'salta_fin_d'
	ADD AL,30h                                                                  ;AGREGA 30h a AL
	MOV decimales_Res[SI],AL                                                    ;Asigna el contenido de AL a decimales_Res[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS inicia_ajuste_d                                                         ;Salta a la etiqueta 'inicia_ajuste_d' si no hay signo el ZF

	MOV decimales_Res[0h],07h                                                   ;limpiar el acarreo

	CALL AJUSTE_PARA_IMPRESION                                                  ;Llamada al procedimiento 'AJUSTE_PARA_IMPRESION'
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	SUMA ENDP                                                                   ;Fin del procedimiento
;----------------------RESTA PROC------------------------------------------
RESTA PROC NEAR                                                             	;Inicia prodecimiento cercano 'RESTA'
;DETERMINAR CUAL NUMERO ES MAYOR
;reccorer el num1 y num2 desde la posicion 0 
	MOV SI,00h                                                                  ;Asigna 00h a SI

cual_es_mayor_res:                                                          	; etiqueta
	INC SI                                                                      ;Incrementa en uno el valor de SI
	MOV AL,num2[SI]                                                             ;Asigna el contenido de num2[SI] a AL
    MOV AH,num1[SI]
;COMPARAR NUM1 CON NUM2
	CMP AH,AL                                                                   ;compara el contenido de AL con num1[SI]
                                                                                ;si num1 es mayor ya podemos restar 
	JA  acomodados_para_la_resta                                                ;salta a la etiqueta  acomodados_para_la_resta si es mayor
	JL  num2_mayor
	CMP SI,09h 
	JE  iguales                                                                 ;salta a la etiqueta iguales si son iguales
	JMP cual_es_mayor_res                                                       ;salta a la etiqueta cual_es_mayor_res
acomodados_para_la_resta:                                                   	;etiqueta
	MOV es_negativo_res,01h                                                     ;asigna 01h a es_negativo_res
	JMP ya_puedes_restar                                                        ;salta a la etiqueta ya_puedes_restar
iguales:                                                                    	;etiqueta
	    ;REVISAR LOS DECIMALES
	MOV SI,01H
decim_mayor:
	 MOV AL,decimales_2[SI]
	 MOV AH,decimales_1[SI]
	 CMP AL,AH
	 JA  num2_mayor
	 JL  acomodados_para_la_resta
	 CMP SI,09H 
	 INC SI
	 JE ya_puedes_restar                                                        ; si son iguales salta a acomodados_para_la_resta	
;---------------------------------------------------------------------------------------------------------------------------------
num2_mayor:                                                                 	;etiqueta
;copiamos el numero mayor (num2) a la variable temporal ajuste_decimales_1
	MOV SI,00h                                                                  ;Asigna 00h a SI
num2_mayor_cpy:                                                             	;etiqueta
	MOV AL,num2[SI]                                                             ;Asigna el contenido de num2[SI] a AL
	MOV ajuste_decimales_1[SI],AL                                               ;Asigna el contenido de AL a ajuste_decimales_1[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE num2_mayor_cpy                                                          ;salta a num2_mayor_cpy si es menor o igual
;copiamos el numero (num1) menor a num2
	MOV SI,00h                                                                  ;Asigna 00h a SI
num2_menor_cpy:                                                             	;etiqueta
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	MOV num2[SI],AL                                                             ;Asigna el contenido de AL a num2[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE num2_menor_cpy                                                          ;salta a num2_mayor_cpy si es menor o igual
;copiamos el numero mayor guardado en ajuste_decimales_1 a num1
	MOV SI,00h                                                                  ;Asigna 00h a SI
num1_ajuste_cpy:                                                            	;etiqueta
	MOV AL,ajuste_decimales_1[SI]                                               ;Asigna el contenido de ajuste_decimales_1[SI] a AL
	MOV num1[SI],AL                                                             ;Asigna el contenido de AL a num1[SI]
	MOV ajuste_decimales_1[SI],00h                                              ;limpiamos la variable temporal
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE num1_ajuste_cpy                                                         ;salta a num1_mayor_cpy si es menor o igual
;;INVERTIR LOS DECIMALES TAMBIEN
;------------------------------------------------------------------
;copiamos el numero mayor (decimales_2) a la variable temporal ajuste_decimales_1
	MOV SI,00h                                                                  ;Asigna 00h a SI
dec2_mayor_cpy:                                                             	;etiqueta
	MOV AL,decimales_2[SI]                                                      ;Asigna el contenido de decimales_2[SI] a AL
	MOV ajuste_decimales_1[SI],AL                                               ;Asigna el contenido de AL a ajuste_decimales_1[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE dec2_mayor_cpy                                                          ;salta a dec2_mayor_cpy si es menor o igual
;copiamos el numero (decimales_1) menor a decimales_2
	MOV SI,00h                                                                  ;Asigna 00h a SI
dec2_menor_cpy:                                                             	;etiqueta
	MOV AL,decimales_1[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	MOV decimales_2[SI],AL                                                      ;Asigna el contenido de AL a decimales_2[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE dec2_menor_cpy                                                          ;salta a dec2_mayor_cpy si es menor o igual
;copiamos el numero mayor guardado en ajuste_decimales_1 a decimales_1
	MOV SI,00h                                                                  ;Asigna 00h a SI
dec1_ajuste_cpy:                                                            	;etiqueta
	MOV AL,ajuste_decimales_1[SI]                                               ;Asigna el contenido de ajuste_decimales_1[SI] a AL
	MOV decimales_1[SI],AL                                                      ;Asigna el contenido de AL a decimales_1[SI]
	MOV ajuste_decimales_1[SI],00h                                              ;limpiamos la variable temporal
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE dec1_ajuste_cpy                                                         ;salta a dec1_mayor_cpy si es menor o igual
MOV es_negativo_res,00h;asigna 01h a es_negativo_res
;------------------------------------------------------------------

ya_puedes_restar:                                                           	;Etiqueta 'ya_puedes_restar'
;RESTAR PARTES DECIMALES
	MOV SI,09h                                                                  ;Asigna 09h a SI
	JMP siguiente_decimal_res                                                   ;salta a la etiqueta siguiente_entero_res
 
fin_decimal_res:                                                            	;etiqueta
	MOV decimales_Res[SI],'$'                                                   ;asigna fin de cadena  a decimales_Res[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP siguiente_decimal_res                                                   ;salta a la etiqueta siguiente_entero_res


siguiente_decimal_res:                                                      	;etiqueta
	MOV AL,decimales_1[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE fin_decimal_res                                                          ; salta a la etiqueta fin_decimal_res si es igual
	CMP AL,decimales_2[SI]                                                      ;asigna el contenido de la direccion de memoria de decimales_2 direccionada por SI a AL
	JL pide_prestado_d                                                          ;salta a la etiqueta pide_prestado_d si es menor
	JMP resta_conNormalidad_d                                                   ; salta a la etiqueta resta_conNormalidad_d
       
       
pide_prestado_d:                                                            	;etiqueta
	CMP SI,0000h                                                                ;compara si el SI esta limpio
	JE prestamo_desde_los_enteros                                               ; si es igual salta a prestamo_desde_los_enteros
	DEC decimales_1[SI-1]                                                       ;decrementa decimales_1[SI-1]
	ADD decimales_1[SI],0Ah                                                     ;suma 0Ah a decimales_1[SI]

resta_conNormalidad_d:                                                      	;etiqueta
	MOV AL,decimales_1[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	SUB AL,decimales_2[SI]                                                      ;asigna el contenido de la direccion de memoria de decimales_2 direccionada por SI a AL
	MOV decimales_Res[SI],AL                                                    ;Asigna el contenido de AL a decimales_Res[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS siguiente_decimal_res                                                   ;salta a siguiente_decimal_res si no tiene signo
	JMP enteros_res                                                             ;salta a la etiqueta enteros_res

;AJUSTAR ACARREO DECIMAL NEGATIVO PARA LOS ENTEROS
prestamo_desde_los_enteros:                                                 	;etiqueta
	DEC num1[09h]                                                               ;decrementa num1[09h]
	MOV decimales_Res[0h],00h                                                   ;limpiar el acarreo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

;RESTAR PARTES ENTERAS
enteros_res:                                                                	;etiqueta
	MOV SI,09h                                                                  ;Asigna 09h a SI
	MOV DI,13h                                                                  ;Asigna 13h a DI
	JMP siguiente_entero_res                                                    ;salta a la etiqueta siguiente_entero_res

fin_enteros_res:                                                            	;etiqueta
	MOV num_res[SI],'$'                                                         ;Asigna el contenido de '$' a num_res[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP siguiente_entero_res                                                    ;salta a la etiqueta siguiente_entero_res


siguiente_entero_res:                                                       	;etiqueta
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE fin_enteros_res                                                          ;salta a fin_enteros_res si es igual
	CMP AL,num2[SI]                                                             ;compara el contenido de num2[SI] con AL
	JL pide_prestado_e                                                          ;salta a pide_prestado_e si es menor
	JMP resta_conNormalidad_e                                                   ;salta a la etiqueta resta_conNormalidad_e
  
  
pide_prestado_e:                                                            	;etiqueta
	DEC num1[SI-1]                                                              ;decrementa num1[SI-1]
	ADD num1[SI],0Ah                                                            ;suma 0Ah a num1[SI]

resta_conNormalidad_e:                                                      	;etiqueta
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	SUB AL,num2[SI]                                                             ;asigna el contenido de la direccion de memoria de num2 direccionada por SI a AL
	MOV num_res[DI],AL                                                          ;Asigna el contenido de AL a num_res[DI]
	DEC DI                                                                      ;Decrementa en uno el valor de DI
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS siguiente_entero_res                                                    ;salta a siguiente_entero_res si no tiene signo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera
	MOV SI,13h                                                                  ;Asigna 13h a SI
	JMP inicia_ajuste_res                                                       ;salta a la etiqueta inicia_ajuste_res

salta_fin_res:                                                              	;etiqueta
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP inicia_ajuste_res                                                       ;salta a la etiqueta inicia_ajuste_res

inicia_ajuste_res:                                                          	;etiqueta
	MOV AL,num_res[SI]                                                          ;Asigna el contenido de num_res[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE salta_fin_res                                                            ;Si es igual salta a salta_fin_res
	ADD AL,30h                                                                  ;AGREGA 30h a AL
	MOV num_res[SI],AL                                                          ;lo devuelve convertido en ascii a la posicion de donde lo tomo
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS inicia_ajuste_res                                                       ;salta a inicia_ajuste_res si no tiene signo
;;ajustar la parte decimal
	MOV SI,13h                                                                  ;Asigna 13h a SI
	JMP inicia_ajuste_d_res                                                     ;salta a la etiqueta inicia_ajuste_res

salta_fin_d_res:                                                            	;etiqueta
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP inicia_ajuste_d_res                                                     ;salta a la etiqueta inicia_ajuste_res

inicia_ajuste_d_res:                                                        	;etiqueta
	MOV AL,decimales_Res[SI]                                                    ;Asigna el contenido de decimales_Res[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE salta_fin_d_res                                                          ;Si es igual salta a salta_fin_res
	ADD AL,30h                                                                  ;AGREGA 30h a AL
	MOV decimales_Res[SI],AL                                                    ;Asigna el contenido de AL a decimales_Res[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS inicia_ajuste_d_res                                                     ;salta a inicia_ajuste_res si no tiene signo
	MOV decimales_Res[0h],07h                                                   ;limpiar el acarreo
	CALL AJUSTE_PARA_IMPRESION                                                  ;Llamada al procedimiento 'AJUSTE_PARA_IMPRESION'
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	RESTA ENDP                                                                  ;fin del procedimento resta
;-------------------------------MULTIPLICA----------------------------------------------
MULTIPLICA PROC NEAR                                                        	;Inicia prodecimiento cercano 'MULTIPLICA'
            
	MOV CX,09h                                                                  ;Asigna 09h a CX
cpy_mul_e:                                                                  	;Etiqueta 'cpy_mul_e'
	MOV SI,CX                                                                   ;Asigna el contenido de CX a SI
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	MOV num_1_mul[SI-1],Al                                                      ;Asigna el contenido de Al a num_1_mul[SI-1]
          
	MOV AL,num2[SI]                                                             ;Asigna el contenido de num2[SI] a AL
	MOV num_2_mul[SI-1],Al                                                      ;Asigna el contenido de Al a num_2_mul[SI-1]
	LOOP cpy_mul_e                                                              ;Salta a la etiqueta 'cpy_mul_e' y decrementa CX mientras no sea cero
          
	MOV CX,09h                                                                  ;Asigna 09h a CX
cpy_mul_d:                                                                  	;Etiqueta 'cpy_mul_d'
	MOV SI,CX                                                                   ;Asigna el contenido de CX a SI
	MOV AL,decimales_1[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	MOV decimal_1_mul[SI-1],Al                                                  ;Asigna el contenido de Al a decimal_1_mul[SI-1]
          
	MOV AL,decimales_2[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	MOV decimal_2_mul[SI-1],Al                                                  ;Asigna el contenido de Al a decimal_2_mul[SI-1]
	LOOP cpy_mul_d                                                              ;Salta a la etiqueta 'cpy_mul_d' y decrementa CX mientras no sea cero
                               
	mov si,0000h                                                                ;Asigna 0000h a si
	mov di,0000h                                                                ;Asigna 0000h a di
          
LEA di,num_res_mul[23h]                                                     	;Asigna a DX la direccion inicial de desplzamiento de la variable: 'di,num_res_mul[23h]'
LEA si,num_1_mul[11h]                                                       	;Asigna a DX la direccion inicial de desplzamiento de la variable: 'si,num_1_mul[11h]'
LEA bx,num_2_mul                                                            	;Asigna a DX la direccion inicial de desplzamiento de la variable: 'bx,num_2_mul'
          
	mov cx,18                                                                   ;Asigna 18 a cx
          
p_ciclo_mul:                                                                	;Etiqueta 'p_ciclo_mul'
     
	PUSH cx                                                                     ;Envia cx a la pila
	PUSH di                                                                     ;Envia di a la pila
	mov ax,17                                                                   ;Asigna 17 a ax
	mov cx,18                                                                   ;Asigna 18 a cx
          
s_ciclo_mul:                                                                	;Etiqueta 's_ciclo_mul'

	mov dx,ax                                                                   ;Asigna el contenido de ax a dx
                    
	XLAT                                                                        ;Transfiere el contenido de la direccion de memoria dada por la suma de (BX + Al) a Al
          
	mov dh,[si]                                                                 ;Asigna el contenido de [si] a dh
	mul dh                                                                      ;Multiplica Al por dh
              
AAM                                                                         	;Desempaca AL (Divide Al entre 10 cociente:resuido AH:AL)
 
	add al,[di]                                                                 ;Suma el valor de al con el de [di], el resultado queda en al
	add al,acarreo                                                              ;Suma el valor de al con el de acarreo, el resultado queda en al
	mov acarreo,ah                                                              ;Asigna ah a acarreo
	mov ah,0h                                                                   ;Asigna 0h a ah
AAM                                                                         	;Desempaca AL (Divide Al entre 10 cociente:resuido AH:AL)
	mov [di],al                                                                 ;Asigna el contenido de al a [di]
              
	mov al,acarreo                                                              ;Asigna el contenido de acarreo a al
	add al,ah                                                                   ;AGREGA ah a al
	mov acarreo,al                                                              ;Asigna el contenido de al a acarreo
              
	dec di                                                                      ;Decrementa en uno el valor de di
	mov dh,0                                                                    ;Asigna 0 a dh
	mov ax,dx                                                                   ;Asigna el contenido de dx a ax
	dec ax                                                                      ;Decrementa en uno el valor de ax
              
	LOOP s_ciclo_mul                                                            ;Salta a la etiqueta 's_ciclo_mul' y decrementa CX mientras no sea cero
          
	mov ax,[di]                                                                 ;Asigna el contenido de [di] a ax
	add al,acarreo                                                              ;Suma el valor de al con el de acarreo, el resultado queda en al
	mov [di],al                                                                 ;Asigna el contenido de al a [di]
          
	POP di                                                                      ;Saca di de la pila
	POP cx                                                                      ;Saca cx de la pila
          
	dec si                                                                      ;Decrementa en uno el valor de si
	dec di                                                                      ;Decrementa en uno el valor de di
          
	mov acarreo,0h                                                              ;Asigna 0h a acarreo
          
	LOOP p_ciclo_mul                                                            ;Salta a la etiqueta 'p_ciclo_mul' y decrementa CX mientras no sea cero


	mov cx,36                                                                   ;Asigna 36 a cx
LEA di,num_res_mul                                                          	;Asigna a DX la direccion inicial de desplzamiento de la variable: 'di,num_res_mul'
ciclo_A:                                                                    	;Etiqueta 'ciclo_A'
	mov al,[di]                                                                 ;Asigna el contenido de [di] a al
	add al,30h                                                                  ;AGREGA 30h a al
	mov [di],al                                                                 ;Asigna el contenido de al a [di]
	inc di                                                                      ;Incrementa en uno el valor de di         
	LOOP ciclo_A                                                                ;Salta a la etiqueta 'ciclo_A' y decrementa CX mientras no sea cero                
	MOV CX,11h                                                                  ;Asigna 11h a CX
cpy_res_e:                                                                  	;Etiqueta 'cpy_res_e'
	MOV SI,CX                                                                   ;Asigna el contenido de CX a SI
	MOV AL,num_res_mul[SI]                                                      ;Asigna el contenido de num_res_mul[SI] a AL
	MOV num_res[SI+2],Al                                                        ;Asigna el contenido de Al a num_res[SI+2]
	LOOP cpy_res_e                                                              ;Salta a la etiqueta 'cpy_res_e' y decrementa CX mientras no sea cero
	MOV CX,13h                                                                  ;Asigna 11h a CX
cpy_res_d:                                                                      ;Etiqueta 'cpy_res_d
    SUB CX,02h                                                                  ;Resta 2h a CX
	JS end_cpy_d                                                                ;Salta si no hay signo
	MOV SI,CX                                                                   ;Asigna el contenido de CX a SI
	MOV AL,decimal_res_mul[SI]                                                  ;Asigna el contenido de decimal_res_mul[SI] a AL
	MOV decimales_res[SI+1],Al                                                  ;Asigna el contenido de Al a decimales_res[SI+1]
	ADD CX,02h                                                                  ;Suma 2h a CX
	LOOP cpy_res_d                                                              ;Salta a la etiqueta 'cpy_res_d' y decrementa CX mientras no sea cero
end_cpy_d:                                                                      ;Etiqueta 'end_cpy_d'
	MOV num_res[00h],30h                                                        ;Asigna 30h a num_res[00h]
	MOV num_res[01h],30h                                                        ;Asigna 30h a num_res[01h]
	MOV num_res[02h],30h                                                        ;Asigna 30h a num_res[02h]
    MOV decimales_res[0h],07h                                                   ;Asigna 07h a decimales_res[0h]
    MOV decimales_res[13h],30h                                                  ;Asigna 30h a decimales_res[14h]
	CALL AJUSTE_PARA_IMPRESION                                                  ;Llamada al procedimiento 'AJUSTE_PARA_IMPRESION'
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	MULTIPLICA ENDP                                                             ;Fin del procedimiento
;;;;----------------------------------DIVIDE------------------------------
DIVIDE PROC NEAR                                                            	;Inicia prodecimiento cercano 'DIVIDE'
	MOV resultado_entero_div,01h                                                ;Asigna 01h a resultado_entero_div
;----------------------------------------------------------------------------------
;;REVISAR QUE LA DIVISION NO SEA x/0
	MOV SI,09h                                                                  ;Asigna 09h a SI
revisa_indefinidos:                                                         	;Etiqueta 'revisa_indefinidos'
	CMP num2[SI],00H                                                            ;Compara num2[SI] con 00H
	JNE no_es_indefinida_jmp                                                    ;Salta si no es igual a la etiqueta 'no_es_indefinida_jmp'
	CMP decimales_2[SI],00H                                                     ;Compara decimales_2[SI] con 00H
	JNE no_es_indefinida_jmp                                                    ;Salta si no es igual a la etiqueta 'no_es_indefinida_jmp'
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS revisa_indefinidos                                                      ;Salta a la etiqueta 'revisa_indefinidos' si no hay signo el ZF
        
	MOV CX,0Dh                                                                  ;longuitud de la palabra "Indeterminado"
	MOV SI,00h                                                                  ;Asigna 00h a SI
	JMP indeterminado_cpy                                                       ;Salta a la etiqueta 'indeterminado_cpy'
no_es_indefinida_jmp:                                                       	;Etiqueta 'no_es_indefinida_jmp'
	JMP no_es_indefinida                                                        ;Salta a la etiqueta 'no_es_indefinida'
indeterminado_cpy:                                                          	;Etiqueta 'indeterminado_cpy'
	MOV AL,indefinida[SI]                                                       ;Asigna el contenido de indefinida[SI] a AL
	MOV num_res[SI],Al                                                          ;Asigna el contenido de Al a num_res[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	Loop indeterminado_cpy                                                      ;Salta a la etiqueta 'indeterminado_cpy' y decrementa CX mientras no sea cero
	MOV decimales_Res[00h],07h                                                  ;borrar los decimales
	MOV decimales_Res[01h],07h                                                  ;borrar los decimales
	CALL AJUSTE_PARA_IMPRESION                                                  ;Llamada al procedimiento 'AJUSTE_PARA_IMPRESION'
ERROR div_x_cero                                                            	;Llamada a la Macro ERROR con los parametros : div_x_cero
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_indefinida:                                                           	;Etiqueta 'no_es_indefinida'
;;COPIAR LOS OPERANDOS ORIGINALES EN LAS VARIABLES ESPECIALES
;;PARA LA DIVISION   
	MOV DI,0000h                                                                ;Asigna 0000h a DI
aun_hay_resuido:                                                            	;Etiqueta 'aun_hay_resuido'
;------------------------------------------------------------------------------------INICIA_RESTA
    ;DETERMINAR CUAL NUMERO ES MAYOR
    ;reccorer el num1 y num2 desde la posicion 0 
	MOV SI,00h                                                                  ;Asigna 00h a SI

cual_es_mayor_div:                                                          	;Etiqueta 'cual_es_mayor_div'
	INC SI                                                                      ;Incrementa en uno el valor de SI
	MOV AL,num2[SI]                                                             ;Asigna el contenido de num2[SI] a AL

    ;COMPARAR num1 CON num2
	CMP num1[SI],AL                                                             ;compara el contenido de AL con num1[SI]
    ;si num1 es mayor ya podemos restar 
	JA  acomodados_para_la_resta_div                                            ;Salta si es mayor a la etiqueta 'acomodados_para_la_resta_div'
    ;si son iguales_div
	JE  iguales_div                                                             ;Salta si es igual a la etiqueta 'iguales_div'
    ;si no significa que num2 es mayor
	JMP  num2_mayor_div                                                         ;Salta a la etiqueta 'num2_mayor_div'

acomodados_para_la_resta_div:                                               	;Etiqueta 'acomodados_para_la_resta_div'
	JMP ya_puedes_restar_div                                                    ;Salta a la etiqueta 'ya_puedes_restar_div'

iguales_div:                                                                	;Etiqueta 'iguales_div'
	MOV es_negativo_resuido_div,00h                                             ;no hay signo en la parte entera
	CMP SI,09h                                                                  ;Compara SI con 09h
	JE revisar_parte_decimal                                                    ;Salta si es igual a la etiqueta 'revisar_parte_decimal'
	JMP cual_es_mayor_div                                                       ;Salta a la etiqueta 'cual_es_mayor_div'
        ;-----------------------------------------------------------------------------
revisar_parte_decimal:                                                      	;Etiqueta 'revisar_parte_decimal'
        ;revisar su parte decimal para determinar el mayor
	MOV SI,00h                                                                  ;Asigna 00h a SI
cual_es_mayor_dec:                                                          	;Etiqueta 'cual_es_mayor_dec'
	INC SI                                                                      ;Incrementa en uno el valor de SI
	MOV AL,decimales_2[SI]                                                      ;Asigna el contenido de decimales_2[SI] a AL

                    ;COMPARAR num1 CON num2
	CMP decimales_1[SI],AL                                                      ;Compara decimales_1[SI] con AL
                    ;si num1 es mayor ya podemos restar 
	JA  acomodados_para_la_resta_div                                            ;Salta si es mayor a la etiqueta 'acomodados_para_la_resta_div'
                    ;si no significa que num2 es mayor
	JL  num2_mayor_div                                                          ;Salta a la etiqueta 'num2_mayor_div' si es menor
                    
	CMP SI,09h                                                                  ;Compara SI con 09h
	JL cual_es_mayor_dec                                                        ;Salta a la etiqueta 'cual_es_mayor_dec' si es menor
	JMP ya_puedes_restar_div                                                    ;Salta a la etiqueta 'ya_puedes_restar_div'
        ;-----------------------------------------------------------------------------
                    
    
    ;------------------->inicia ajuste para que num 1 sea siempre mayor
num2_mayor_div:                                                             	;Etiqueta 'num2_mayor_div'
	MOV es_negativo_resuido_div,01h                                             ;Asigna 01h a es_negativo_resuido_div
	MOV resultado_entero_div,00h                                                ;Asigna 00h a resultado_entero_div
	JMP la_resta_ya_es_negativa                                                 ;Salta a la etiqueta 'la_resta_ya_es_negativa'
    ;copiamos el numero mayor (num2) a la variable temporal ajuste_decimales_1
	MOV SI,00h                                                                  ;Asigna 00h a SI
num2_mayor_div_cpy:                                                         	;Etiqueta 'num2_mayor_div_cpy'
	MOV AL,num2[SI]                                                             ;Asigna el contenido de num2[SI] a AL
	MOV ajuste_decimales_1[SI],AL                                               ;Asigna el contenido de AL a ajuste_decimales_1[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE num2_mayor_div_cpy                                                      ;Salta a la etiqueta 'num2_mayor_div_cpy' si es menor o igual
    ;copiamos el numero (num1) menor a num2
	MOV SI,00h                                                                  ;Asigna 00h a SI
num2_menor_cpy_div:                                                         	;Etiqueta 'num2_menor_cpy_div'
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	MOV num2[SI],AL                                                             ;Asigna el contenido de AL a num2[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE num2_menor_cpy_div                                                      ;Salta a la etiqueta 'num2_menor_cpy_div' si es menor o igual
    ;copiamos el numero mayor guardado en ajuste_decimales_1 a num1
	MOV SI,00h                                                                  ;Asigna 00h a SI
num1_ajuste_cpy_div:                                                        	;Etiqueta 'num1_ajuste_cpy_div'
	MOV AL,ajuste_decimales_1[SI]                                               ;Asigna el contenido de ajuste_decimales_1[SI] a AL
	MOV num1[SI],AL                                                             ;Asigna el contenido de AL a num1[SI]
	MOV ajuste_decimales_1[SI],00h                                              ;limpiamos la variable temporal
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE num1_ajuste_cpy_div                                                     ;Salta a la etiqueta 'num1_ajuste_cpy_div' si es menor o igual
    ;;INVERTIR LOS DECIMALES TAMBIEN
    ;------------------------------------------------------------------
    ;copiamos el numero mayor (decimales_2) a la variable temporal ajuste_decimales_1
	MOV SI,00h                                                                  ;Asigna 00h a SI
dec2_mayor_cpy_div:                                                         	;Etiqueta 'dec2_mayor_cpy_div'
	MOV AL,decimales_2[SI]                                                      ;Asigna el contenido de decimales_2[SI] a AL
	MOV ajuste_decimales_1[SI],AL                                               ;Asigna el contenido de AL a ajuste_decimales_1[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE dec2_mayor_cpy_div                                                      ;Salta a la etiqueta 'dec2_mayor_cpy_div' si es menor o igual
    ;copiamos el numero (decimales_1) menor a decimales_2
	MOV SI,00h                                                                  ;Asigna 00h a SI
dec2_menor_cpy_div:                                                         	;Etiqueta 'dec2_menor_cpy_div'
	MOV AL,decimales_1[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	MOV decimales_2[SI],AL                                                      ;Asigna el contenido de AL a decimales_2[SI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE dec2_menor_cpy_div                                                      ;Salta a la etiqueta 'dec2_menor_cpy_div' si es menor o igual
    ;copiamos el numero mayor guardado en ajuste_decimales_1 a decimales_1
	MOV SI,00h                                                                  ;Asigna 00h a SI
dec1_ajuste_cpy_div:                                                        	;Etiqueta 'dec1_ajuste_cpy_div'
	MOV AL,ajuste_decimales_1[SI]                                               ;Asigna el contenido de ajuste_decimales_1[SI] a AL
	MOV decimales_1[SI],AL                                                      ;Asigna el contenido de AL a decimales_1[SI]
	MOV ajuste_decimales_1[SI],00h                                              ;limpiamos la variable temporal
	INC SI                                                                      ;Incrementa en uno el valor de SI
	CMP SI,09h                                                                  ;Compara SI con 09h
	JLE dec1_ajuste_cpy_div                                                     ;Salta a la etiqueta 'dec1_ajuste_cpy_div' si es menor o igual
;------------------------------------------------------------------
ya_puedes_restar_div:                                                       	;Etiqueta 'ya_puedes_restar_div'
    
	MOV dividi_una_vez,01h                                                      ;Asigna 01h a dividi_una_vez
    ;RESTAR PARTES DECIMALES
	MOV SI,09h                                                                  ;Asigna 09h a SI

	JMP siguiente_decimal_res_div                                               ;salta a la etiqueta siguiente_entero_res_div

fin_decimal_res_div:                                                        	;Etiqueta 'fin_decimal_res_div'
	MOV decimales_Res_div[SI],'$'                                               ;Asigna el contenido de '$' a decimales_Res_div[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP siguiente_decimal_res_div                                               ;salta a la etiqueta siguiente_entero_res_div


siguiente_decimal_res_div:                                                  	;Etiqueta 'siguiente_decimal_res_div'
	MOV AL,decimales_1[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE fin_decimal_res_div                                                      ;Salta si es igual a la etiqueta 'fin_decimal_res_div'



	CMP AL,decimales_2[SI]                                                      ;asigna el contenido de la direccion de memoria de decimales_2 direccionada por SI a AL
	JL pide_prestado_d_div                                                      ;Salta a la etiqueta 'pide_prestado_d_div' si es menor

	JMP resta_conNormalidad_d_div                                               ;Salta a la etiqueta 'resta_conNormalidad_d_div'

pide_prestado_d_div:                                                        	;Etiqueta 'pide_prestado_d_div'
	CMP SI,0000h                                                                ;compara si el SI esta limpio
	JE prestamo_desde_los_enteros_div                                           ;Salta si es igual a la etiqueta 'prestamo_desde_los_enteros_div'
	DEC decimales_1[SI-1]                                                       ;decrementa decimales_1[SI-1]
	ADD decimales_1[SI],0Ah                                                     ;suma 0Ah a decimales_1[SI]

resta_conNormalidad_d_div:                                                  	;Etiqueta 'resta_conNormalidad_d_div'
	MOV AL,decimales_1[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	SUB AL,decimales_2[SI]                                                      ;asigna el contenido de la direccion de memoria de decimales_2 direccionada por SI a AL

	MOV decimales_Res_div[SI],AL                                                ;Asigna el contenido de AL a decimales_Res_div[SI]


	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS siguiente_decimal_res_div                                               ;Salta a la etiqueta 'siguiente_decimal_res_div' si no hay signo el ZF
	JMP enteros_res_div                                                         ;Salta a la etiqueta 'enteros_res_div'
    ;AJUSTAR ACARREO DECIMAL NEGATIVO PARA LOS ENTEROS
prestamo_desde_los_enteros_div:                                             	;Etiqueta 'prestamo_desde_los_enteros_div'
	DEC num1[09h]                                                               ;decrementa num1[09h]
	MOV decimales_Res_div[0h],00h                                               ;limpiar el acarreo

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

enteros_res_div:                                                            	;Etiqueta 'enteros_res_div'
    ;RESTAR PARTES ENTERAS

	MOV SI,09h                                                                  ;Asigna 09h a SI

	JMP siguiente_entero_res_div                                                ;salta a la etiqueta siguiente_entero_res_div

fin_enteros_res_div:                                                        	;Etiqueta 'fin_enteros_res_div'
	MOV num_res_div[SI],'$'                                                     ;Asigna el contenido de '$' a num_res_div[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP siguiente_entero_res_div                                                ;salta a la etiqueta siguiente_entero_res_div


siguiente_entero_res_div:                                                   	;Etiqueta 'siguiente_entero_res_div'
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE fin_enteros_res_div                                                      ;Salta si es igual a la etiqueta 'fin_enteros_res_div'



	CMP AL,num2[SI]                                                             ;compara el contenido de num2[SI] con AL
	JL pide_prestado_e_div                                                      ;Salta a la etiqueta 'pide_prestado_e_div' si es menor

	JMP resta_conNormalidad_e_div                                               ;Salta a la etiqueta 'resta_conNormalidad_e_div'

pide_prestado_e_div:                                                        	;Etiqueta 'pide_prestado_e_div'
	DEC num1[SI-1]                                                              ;decrementa num1[SI-1]
	ADD num1[SI],0Ah                                                            ;suma 0Ah a num1[SI]

resta_conNormalidad_e_div:                                                  	;Etiqueta 'resta_conNormalidad_e_div'
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	SUB AL,num2[SI]                                                             ;asigna el contenido de la direccion de memoria de num2 direccionada por SI a AL

	MOV num_res_div[SI],AL                                                      ;Asigna el contenido de AL a num_res_div[SI]


	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS siguiente_entero_res_div                                                ;Salta a la etiqueta 'siguiente_entero_res_div' si no hay signo el ZF
;-------------------------------------------------------------------------------------FIN_RESTA
;COPIAR NUM_RES_DIV A NUM1
	MOV SI,09H                                                                  ;Asigna 09H a SI
    
siguiente_resultado_resta:                                                  	;Etiqueta 'siguiente_resultado_resta'
        ;para su parte entera
	MOV Al,num_res_div[SI]                                                      ;Asigna el contenido de num_res_div[SI] a Al
	MOV num1[SI],Al                                                             ;Asigna el contenido de Al a num1[SI]
        ;para su parte decimal
	MOV AL,decimales_Res_div[SI]                                                ;Asigna el contenido de decimales_Res_div[SI] a AL
	MOV decimales_1[SI],AL                                                      ;Asigna el contenido de AL a decimales_1[SI]
        
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS siguiente_resultado_resta                                               ;Salta a la etiqueta 'siguiente_resultado_resta' si no hay signo el ZF
    
;;INICIA INCREMENTO DE CONTADOR PARA EL RESULTADO
    
	CMP resultado_entero_div,01h                                                ;Compara resultado_entero_div con 01h
	JE enteros_div                                                              ;Salta si es igual a la etiqueta 'enteros_div'
	JMP decimales_div                                                           ;Salta a la etiqueta 'decimales_div'
enteros_div:                                                                	;Etiqueta 'enteros_div'

	INC num_res[13h]                                                            ;agregamos 1 a la ultima posicion de el resultado entero
            ;ajustar los acarreos            
	MOV SI,14h                                                                  ;Asigna 14h a SI
siguiente_posicion_enteros_div:                                             	;Etiqueta 'siguiente_posicion_enteros_div'
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JS fin_incremento_contador                                                  ;Salta a la etiqueta 'fin_incremento_contador' si hay signo el ZF
	CMP num_res[SI],0Ah                                                         ;Compara num_res[SI] con 0Ah
	JL siguiente_posicion_enteros_div                                           ;Salta a la etiqueta 'siguiente_posicion_enteros_div' si es menor
	JAE desempaca_div_e                                                         ;Salta a la etiqueta 'desempaca_div_e' si es mayor o igual
	JMP fin_incremento_contador                                                 ;Salta a la etiqueta 'fin_incremento_contador'
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
desempaca_div_e:                                                            	;Etiqueta 'desempaca_div_e'
	MOV AL,num_res[SI]                                                          ;Asigna el contenido de num_res[SI] a AL
AAM                                                                         	;Desempaca AL (Divide Al entre 10 cociente:resuido AH:AL)
	MOV num_res[SI],AL                                                          ;lo devuelve convertido en ascii a la posicion de donde lo tomo
	ADD num_res[SI-1],Ah                                                        ;AGREGA Ah a num_res[SI-1]
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JMP siguiente_posicion_enteros_div                                          ;Salta a la etiqueta 'siguiente_posicion_enteros_div'
            
decimales_div:                                                              	;Etiqueta 'decimales_div'
    ;-------------------------------------------------------------------------------------------        
	INC decimales_res[DI]                                                       ;agregamos 1 a la posicion actual del resultado decimal
            
            ;ajustar los acarreos            
	MOV SI,14h                                                                  ;Asigna 14h a SI
siguiente_posicion_decimales_div:                                           	;Etiqueta 'siguiente_posicion_decimales_div'
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	CMP decimales_res[SI],0Ah                                                   ;Compara decimales_res[SI] con 0Ah
	JLE siguiente_posicion_decimales_div                                        ;Salta a la etiqueta 'siguiente_posicion_decimales_div' si es menor o igual
	JMP fin_incremento_contador                                                 ;Salta a la etiqueta 'fin_incremento_contador'
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	XOR AX,AX                                                                   ;Resituye el registro  AX a ceros por medio de XOR
	INT 16h                                                                     ;Interrupcion 16h (funciones de llamada al teclado)
	MOV AL,decimales_res[SI]                                                    ;Asigna el contenido de decimales_res[SI] a AL
AAM                                                                         	;Desempaca AL (Divide Al entre 10 cociente:resuido AH:AL)
	MOV CL,AL                                                                   ;Asigna el contenido de AL a CL
                
	ADD AL,CL                                                                   ;Suma el valor de AL con el de CL, el resultado queda en AL
	MOV decimales_res[SI-1],Ah                                                  ;Asigna Ah a decimales_res[SI-1]
                ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JMP siguiente_posicion_decimales_div                                        ;Salta a la etiqueta 'siguiente_posicion_decimales_div'
    ;-------------------------------------------------------------------------------------------
fin_incremento_contador:                                                    	;Etiqueta 'fin_incremento_contador'
	JMP aun_hay_resuido                                                         ;Salta a la etiqueta 'aun_hay_resuido'
    
la_resta_ya_es_negativa:                                                    	;Etiqueta 'la_resta_ya_es_negativa'
	CMP dividi_una_vez,01h                                                      ;Compara dividi_una_vez con 01h
	JNE resultado_menor_que_cero                                                ;Salta si no es igual a la etiqueta 'resultado_menor_que_cero'
	JMP resultado_mayor_que_cero                                                ;Salta a la etiqueta 'resultado_mayor_que_cero'
resultado_menor_que_cero:                                                   	;Etiqueta 'resultado_menor_que_cero'
            ;;si el resultado es 0.xxxxxxx copiamos el operador num1 a num_res_div para que lo
            ;;multiplique por 10            
	MOV resultado_entero_div,00h                                                ;Asigna 00h a resultado_entero_div
	MOV SI,09h                                                                  ;Asigna 09h a SI
cpy_menor_cero:                                                             	;Etiqueta 'cpy_menor_cero'
                ;para los enteros
	MOV AL,num1[SI]                                                             ;Asigna el contenido de num1[SI] a AL
	MOV Num_res_div[SI],Al                                                      ;Asigna el contenido de Al a Num_res_div[SI]
                ;para los decimales
	MOV AL,decimales_1[SI]                                                      ;Asigna el contenido de decimales_1[SI] a AL
	MOV decimales_res_div[SI],Al                                                ;Asigna el contenido de Al a decimales_res_div[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS cpy_menor_cero                                                          ;Salta a la etiqueta 'cpy_menor_cero' si no hay signo el ZF
            
resultado_mayor_que_cero:                                                   	;Etiqueta 'resultado_mayor_que_cero'
        ;------------------------------------------------------------------------------
        ;;MULTIPLICAR EL RESUIDO GUARADO EN NUM_RES_DIV Y DECIAMALES_RES_DIV X10
            ;incrementar el 1 el destino decimal
	INC DI                                                                      ;Incrementa en uno el valor de DI
	CMP DI,14H                                                                  ;Compara DI con 14H
	JNE no_periodico_div                                                        ;Salta si no es igual a la etiqueta 'no_periodico_div'
	JMP periodico_div                                                           ;Salta a la etiqueta 'periodico_div'
no_periodico_div:                                                           	;Etiqueta 'no_periodico_div'
	MOV SI,09H                                                                  ;Asigna 09H a SI
multiplica_siguiente_resuido:                                               	;Etiqueta 'multiplica_siguiente_resuido'
                
                ;multiplicar su parte entera
	MOV AL,Num_res_div[SI]                                                      ;Asigna el contenido de Num_res_div[SI] a AL
	MOV AUX,0AH                                                                 ;Asigna 0AH a AUX
	MUL Aux                                                                     ;Multiplica Al por Aux
	MOV Num_res_div[SI],Al                                                      ;Asigna el contenido de Al a Num_res_div[SI]
                
                ;multiplicar su parte decimal 
	MOV AL,decimales_res_div[SI]                                                ;Asigna el contenido de decimales_res_div[SI] a AL
	MUL Aux                                                                     ;Multiplica Al por Aux
	MOV decimales_res_div[SI],Al                                                ;Asigna el contenido de Al a decimales_res_div[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS multiplica_siguiente_resuido                                            ;Salta a la etiqueta 'multiplica_siguiente_resuido' si no hay signo el ZF
        ;------------------------------------------------------------------------------
                ;AJUSTAR LOS ACARREOS PROVOCADOS POR LA MULTIPLICACION POR 10
                    ;para el acarreo decimal
	MOV SI,09H                                                                  ;Asigna 09H a SI
siguiente_res_div_mul10:                                                    	;Etiqueta 'siguiente_res_div_mul10'
	MOV AL,decimales_res_div[SI]                                                ;Asigna el contenido de decimales_res_div[SI] a AL
	CMP AL,0AH                                                                  ;Compara AL con 0AH
	JAE acarreo_por_resuido                                                     ;Salta a la etiqueta 'acarreo_por_resuido' si es mayor o igual
	DEC SI                                                                      ;Decrementa en uno el valor de SI
                        
	JNS siguiente_res_div_mul10                                                 ;Salta a la etiqueta 'siguiente_res_div_mul10' si no hay signo el ZF
	JMP fin_res_div_mul10                                                       ;Salta a la etiqueta 'fin_res_div_mul10'
                    
acarreo_por_resuido:                                                        	;Etiqueta 'acarreo_por_resuido'
AAM                                                                         	;Desempaca AL (Divide Al entre 10 cociente:resuido AH:AL)
	MOV decimales_res_div[SI],Al                                                ;Asigna el contenido de Al a decimales_res_div[SI]
	MOV CL,decimales_res_div[SI-1]                                              ;Asigna el contenido de decimales_res_div[SI-1] a CL
	ADD Ah,CL                                                                   ;Suma el valor de Ah con el de CL, el resultado queda en Ah
	MOV decimales_res_div[SI-1],Ah                                              ;Asigna Ah a decimales_res_div[SI-1]
	JNS siguiente_res_div_mul10                                                 ;Salta a la etiqueta 'siguiente_res_div_mul10' si no hay signo el ZF
                    
fin_res_div_mul10:                                                          	;Etiqueta 'fin_res_div_mul10'
                    ;--------------------------------------------------
                   ;Agregar acarreo pendiente guarado en la primer posicion de decimales_res_div   
	MOV AL,decimales_res_div[00h]                                               ;Asigna el contenido de decimales_res_div[00h] a AL
	MOV decimales_res_div[00h],00h                                              ;Asigna 00h a decimales_res_div[00h]
	MOV CL,num_res_div[09h]                                                     ;Asigna el contenido de num_res_div[09h] a CL
	ADD AL,CL                                                                   ;Suma el valor de AL con el de CL, el resultado queda en AL
	MOV num_res_div[09h],Al                                                     ;Asigna el contenido de Al a num_res_div[09h]
                    ;--------------------------------------------------                    
                    ;para el acarreo entero
	MOV SI,09H                                                                  ;Asigna 09H a SI
siguiente_res_div_mul10_e:                                                  	;Etiqueta 'siguiente_res_div_mul10_e'
	MOV AL,num_res_div[SI]                                                      ;Asigna el contenido de num_res_div[SI] a AL
	CMP AL,0AH                                                                  ;Compara AL con 0AH
	JAE acarreo_por_resuido_e                                                   ;Salta a la etiqueta 'acarreo_por_resuido_e' si es mayor o igual
	DEC SI                                                                      ;Decrementa en uno el valor de SI
                        
	JNS siguiente_res_div_mul10_e                                               ;Salta a la etiqueta 'siguiente_res_div_mul10_e' si no hay signo el ZF
	JMP fin_res_div_mul10_e                                                     ;Salta a la etiqueta 'fin_res_div_mul10_e'
acarreo_por_resuido_e:                                                      	;Etiqueta 'acarreo_por_resuido_e'
AAM                                                                         	;Desempaca AL (Divide Al entre 10 cociente:resuido AH:AL)
	MOV num_res_div[SI],Al                                                      ;Asigna el contenido de Al a num_res_div[SI]
	MOV CL,num_res_div[SI-1]                                                    ;Asigna el contenido de num_res_div[SI-1] a CL
	ADD Ah,CL                                                                   ;Suma el valor de Ah con el de CL, el resultado queda en Ah
	MOV num_res_div[SI-1],Ah                                                    ;Asigna Ah a num_res_div[SI-1]
	JNS siguiente_res_div_mul10_e                                               ;Salta a la etiqueta 'siguiente_res_div_mul10_e' si no hay signo el ZF
                    
fin_res_div_mul10_e:                                                        	;Etiqueta 'fin_res_div_mul10_e'
                    
                ;------------------------------------------------------------------------------
                ;copiar el resuido ajustado a las variables de operacion num1 y decimales_1
                
	MOV SI,09H                                                                  ;Asigna 09H a SI
                        
siguiente_resuido_div:                                                      	;Etiqueta 'siguiente_resuido_div'
                        ;para su parte entera
	MOV Al,num_res_div[SI]                                                      ;Asigna el contenido de num_res_div[SI] a Al
	MOV num1[SI],Al                                                             ;Asigna el contenido de Al a num1[SI]
                        ;para su parte decimal
	MOV AL,decimales_Res_div[SI]                                                ;Asigna el contenido de decimales_Res_div[SI] a AL
	MOV decimales_1[SI],AL                                                      ;Asigna el contenido de AL a decimales_1[SI]
        
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS siguiente_resuido_div                                                   ;Salta a la etiqueta 'siguiente_resuido_div' si no hay signo el ZF
                ;------------------------------------------------------------------------------
                
                ;saltamos a 'restar' el residuo
	JMP aun_hay_resuido                                                         ;Salta a la etiqueta 'aun_hay_resuido'
periodico_div:                                                              	;Etiqueta 'periodico_div'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera
	MOV SI,13h                                                                  ;Asigna 13h a SI
	JMP inicia_ajuste_div                                                       ;Salta a la etiqueta 'inicia_ajuste_div'
salta_fin_div:                                                              	;Etiqueta 'salta_fin_div'
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP inicia_ajuste_div                                                       ;Salta a la etiqueta 'inicia_ajuste_div'
inicia_ajuste_div:                                                          	;Etiqueta 'inicia_ajuste_div'
	MOV AL,num_res[SI]                                                          ;Asigna el contenido de num_res[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE salta_fin_div                                                            ;Salta si es igual a la etiqueta 'salta_fin_div'
	ADD AL,30h                                                                  ;AGREGA 30h a AL
	MOV num_res[SI],AL                                                          ;lo devuelve convertido en ascii a la posicion de donde lo tomo
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS inicia_ajuste_div                                                       ;Salta a la etiqueta 'inicia_ajuste_div' si no hay signo el ZF
;;ajustar la parte decimal
	MOV SI,13h                                                                  ;Asigna 13h a SI
	JMP inicia_ajuste_d_div                                                     ;Salta a la etiqueta 'inicia_ajuste_d_div'
salta_fin_d_div:                                                            	;Etiqueta 'salta_fin_d_div'
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JMP inicia_ajuste_d_div                                                     ;Salta a la etiqueta 'inicia_ajuste_d_div'
inicia_ajuste_d_div:                                                        	;Etiqueta 'inicia_ajuste_d_div'
	MOV AL,decimales_Res[SI]                                                    ;Asigna el contenido de decimales_Res[SI] a AL
	CMP AL,24h                                                                  ;si es el fin de cadena
	JE salta_fin_d_div                                                          ;Salta si es igual a la etiqueta 'salta_fin_d_div'
	ADD AL,30h                                                                  ;AGREGA 30h a AL
	MOV decimales_Res[SI],AL                                                    ;Asigna el contenido de AL a decimales_Res[SI]
	DEC SI                                                                      ;Decrementa en uno el valor de SI
	JNS inicia_ajuste_d_div                                                     ;Salta a la etiqueta 'inicia_ajuste_d_div' si no hay signo el ZF

	MOV decimales_Res[0h],07h                                                   ;limpiar el acarreo

	CALL AJUSTE_PARA_IMPRESION                                                  ;Llamada al procedimiento 'AJUSTE_PARA_IMPRESION'
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	DIVIDE ENDP                                                                 ;Fin del procedimiento
;-------------------------------------------------------------------------
;______________________PROC_AJUSTE ASCII POST OPERACIONAL________________ 
AJUSTE_PARA_IMPRESION PROC NEAR                                             	;Inicia prodecimiento cercano 'AJUSTE_PARA_IMPRESION'
	CALL AJUSTE_CEROS_IZQUIERDA                                                 ;remover ceros a la izquierda antes de imprimir
;;AJUSTAR PARA IMPRESION
;;ajustar la parte entera 
	MOV DI,0000H                                                                ;Asigna 0000H a DI
	MOV SI,0000H                                                                ;Asigna 0000H a SI
;REVISAMOS SI TIENE SIGNO PARA MOSTRARLO EN EL RESULTADO
	CMP es_negativo_res,01h                                                     ;Compara es_negativo_res con 01h
	JE  agrega_signo_resultado                                                  ;Salta si es igual a la etiqueta 'agrega_signo_resultado'

	JMP sin_signo_resultado                                                     ;Salta a la etiqueta 'sin_signo_resultado'
agrega_signo_resultado:                                                     	;Etiqueta 'agrega_signo_resultado'
	MOV resultado_str[DI],'-'                                                   ;Asigna el contenido de '-' a resultado_str[DI]
	INC DI                                                                      ;Incrementa en uno el valor de DI
sin_signo_resultado:                                                        	;Etiqueta 'sin_signo_resultado'
	MOV es_negativo_res,00h                                                     ;Asigna 00h a es_negativo_res
	MOV CX,14H                                                                  ;longuitud del resultado en su parte entera
                                                
siguiente_resultado_str:                                                    	;Etiqueta 'siguiente_resultado_str'
	MOV AL,num_res[SI]                                                          ;Asigna el contenido de num_res[SI] a AL
	MOV resultado_str[DI],AL                                                    ;Asigna el contenido de AL a resultado_str[DI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	INC DI                                                                      ;Incrementa en uno el valor de DI
	LOOP siguiente_resultado_str                                                ;Salta a la etiqueta 'siguiente_resultado_str' y decrementa CX mientras no sea cero
    CMP sin_punto,01h                                                           ;Compara sin_punto con 01h
    JE  sin_punto_impresion                                                     ;Salta si es igual a 'sin_punto_impresion'
	MOV resultado_str[DI],'.'                                                   ;Asigna el contenido de '.' a resultado_str[DI]
	INC DI                                                                      ;Incrementa en uno el valor de DI
    sin_punto_impresion:                                                        ;Etiqueta 'sin_punto_impresion'
	MOV CX,014H                                                                 ;longuitud del resultado en su parte decimal exceptuando el primer decimal
	MOV SI,0001H                                                                ;INICIAMOS DESPUES DEL PRIMER DIGITO DECIMAL
	MOV decimales_res[0h],07h                                                   ;Asigna 07h a decimales_res[0h]

siguiente_decimal_str:                                                      	;Etiqueta 'siguiente_decimal_str'
	MOV AL,decimales_res[SI]                                                    ;Asigna el contenido de decimales_res[SI] a AL
	MOV resultado_str[DI],AL                                                    ;Asigna el contenido de AL a resultado_str[DI]
	INC SI                                                                      ;Incrementa en uno el valor de SI
	INC DI                                                                      ;Incrementa en uno el valor de DI
	LOOP siguiente_decimal_str                                                  ;Salta a la etiqueta 'siguiente_decimal_str' y decrementa CX mientras no sea cero

	MOV resultado_str[DI],'$'                                                   ;Termina la cadena del resultado
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	AJUSTE_PARA_IMPRESION ENDP                                                  ;Fin del procedimiento
;---------------------ENTRADA-------------------
ENTRADA_PROC proc near                                                      	;Inicia prodecimiento cercano 'ENTRADA_'
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general
   ;Guarda el estado actual de los registros de proposito general       
	CMP posicion_entrada,00h                                                    ;Compara posicion_entrada con 00h
	JE primer_entrada                                                           ;Salta si es igual a la etiqueta 'primer_entrada'
    
	JMP no_primer_entrada                                                       ;Salta a la etiqueta 'no_primer_entrada'
        
primer_entrada:                                                             	;Etiqueta 'primer_entrada'
	MOV resultado_entero_div,00h                                                ;Asigna 00h a resultado_entero_div
	MOV es_negativo_resuido_div,00h                                             ;no hay signo en la parte entera
	MOV num1_signo,00h                                                          ;Asigna 00h a num1_signo
	MOV num2_signo,00h                                                          ;Asigna 00h a num2_signo
	MOV es_negativo_res,00h                                                     ;Asigna 00h a es_negativo_res
	MOV operacion,00h                                                           ;Asigna 00h a operacion
	MOV dividi_una_vez,00h                                                      ;Asigna 00h a dividi_una_vez
	MOV acarreo,00h                                                             ;Asigna 00h a acarreo
	MOV DI,0000H                                                                ;Asigna 0000H a DI
    MOV sin_punto,0h                                                            ;Asigna 0h a sin_punto
limpia_anterior_entrada:                                                    	;Etiqueta 'limpia_anterior_entrada'
	MOV num1[DI],00h                                                            ;Asigna 00h a num1[DI]
	MOV num2[DI],00h                                                            ;Asigna 00h a num2[DI]
	MOV decimales_1[DI],00h                                                     ;Asigna 00h a decimales_1[DI]
	MOV decimales_2[DI],00h                                                     ;Asigna 00h a decimales_2[DI]
	MOV num_res_div[DI],00h                                                     ;Asigna 00h a num_res_div[DI]
	MOV decimales_Res_div[DI],00h                                               ;Asigna 00h a decimales_Res_div[DI]
	MOV ajuste_decimales_1[DI],00h                                              ;Asigna 00h a ajuste_decimales_1[DI]
	MOV ajuste_decimales_2[DI],00h                                              ;Asigna 00h a ajuste_decimales_2[DI]
	MOV num_1_mul[DI],00h                                                       ;Asigna 00h a num_1_mul[DI]
	MOV num_2_mul[DI],00h                                                       ;Asigna 00h a num_2_mul[DI]
	MOV decimal_1_mul[DI],00h                                                   ;Asigna 00h a decimal_1_mul[DI]
	MOV decimal_2_mul[DI],00h                                                   ;Asigna 00h a decimal_2_mul[DI]
	INC DI                                                                      ;Incrementa en uno el valor de DI
	CMP DI,09H                                                                  ;Compara DI con 09H
	JLE limpia_anterior_entrada                                                 ;Salta a la etiqueta 'limpia_anterior_entrada' si es menor o igual
	MOV DI,0000H                                                                ;Asigna 0000H a DI
limpia_anterior_resultado:                                                  	;Etiqueta 'limpia_anterior_resultado'
	MOV num_res[DI],00h                                                         ;Asigna 00h a num_res[DI]
	MOV decimales_Res[DI],00h                                                   ;Asigna 00h a decimales_Res[DI]
	INC DI                                                                      ;Incrementa en uno el valor de DI
	CMP DI,13H                                                                  ;Compara DI con 13H
	JLE limpia_anterior_resultado                                               ;Salta a la etiqueta 'limpia_anterior_resultado' si es menor o igual
	MOV DI,0000H                                                                ;Asigna 0000H a DI
clean_mult:                                                                 	;Etiqueta 'clean_mult'
	MOV num_res_mul[DI],00H                                                     ;Asigna 00H a num_res_mul[DI]
	MOV decimal_res_mul[DI],00H                                                 ;Asigna 00H a decimal_res_mul[DI]
	INC DI                                                                      ;Incrementa en uno el valor de DI
	CMP DI,11H                                                                  ;Compara DI con 11H
	JLE clean_mult                                                              ;Salta a la etiqueta 'clean_mult' si es menor o igual
	MOV DI,0000H                                                                ;Asigna 0000H a DI
	JMP no_primer_entrada                                                       ;Salta a la etiqueta 'no_primer_entrada'
     
no_primer_entrada:                                                          	;Etiqueta 'no_primer_entrada'
	CMP AL,03Ah                                                                 ;si el caracter es '='
	JE Enm_Resuelve                                                             ;Salta si es igual a la etiqueta 'Enm_Resuelve'
	CMP AX,0E0Ch                                                                ;si el caracter nos indica un retroceso
	JE retrocede                                                                ;Salta si es igual a la etiqueta 'retrocede'
	JMP no_retrocede                                                            ;Salta a la etiqueta 'no_retrocede'
posicion_cero:                                                              	;Etiqueta 'posicion_cero'
	MOV DI,0000h                                                                ;Asigna 0000h a DI
	JMP borra_entrada                                                           ;Salta a la etiqueta 'borra_entrada'
retrocede:                                                                  	;Etiqueta 'retrocede'
	MOV DI,posicion_entrada                                                     ;Asigna el contenido de posicion_entrada a DI
	DEC DI                                                                      ;Decrementa en uno el valor de DI
	JS posicion_cero                                                            ;Salta a la etiqueta 'posicion_cero' si hay signo el ZF
borra_entrada:                                                              	;Etiqueta 'borra_entrada'
	MOV posicion_entrada,DI                                                     ;Asigna el contenido de DI a posicion_entrada
	MOV display_str[DI],"$"                                                     ;Asigna el contenido de "$" a display_str[DI]
	JMP Enm_Salir                                                               ;Salta a la etiqueta 'Enm_Salir'
no_retrocede:                                                               	;Etiqueta 'no_retrocede'
	MOV DI,posicion_entrada                                                     ;Asigna el contenido de posicion_entrada a DI
	MOV DL,AL                                                                   ;posicion final en x
	MOV display_str[DI],Dl                                                      ;Asigna el contenido de Dl a display_str[DI]
	MOV display_str[DI+1],"$"                                                   ;Asigna el contenido de "$" a display_str[DI+1]
	INC posicion_entrada                                                        ;Incrementa en uno el valor de posicion_entrada
	JMP Enm_Salir                                                               ;Salta a la etiqueta 'Enm_Salir'
    
Enm_Resuelve:                                                               	;Etiqueta 'Enm_Resuelve'
	CALL RESOLVER                                                               ;Llamada al procedimiento 'RESOLVER'

Enm_Salir:                                                                  	;Etiqueta 'Enm_Salir'
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
ENTRADA_PROC ENDP                                                           	;Fin del procedimiento

;----------------------------REMOVER CEROS A LA IZQUIERDA PROC-----------------------------
AJUSTE_CEROS_IZQUIERDA PROC NEAR                                            	;Inicia prodecimiento cercano 'AJUSTE_CEROS_IZQUIERDA'
;;REMOVER LOS CEROS A LA IZUIERDA DEL RESULTADO Y REEMPLAZARLOS CON 20h
;;ajustar la parte entera
	MOV DI,00h                                                                  ;Asigna 00h a DI
siguiente_cero:                                                             	;Etiqueta 'siguiente_cero'
	CMP num_res[DI],30h                                                         ;si el digito mas a la izquierda es cero
	JNE no_hay_mas_ceros_enteros                                                ;si el numero es diferente de cero ya terminamos el ajuste
    ;si es cero y no es el unico removerlo!
	CMP DI,13h                                                                  ;Compara DI con 00h
	JE resultado_es_cero                                                        ;Salta si es igual a 'resultado_es_cero'
	MOV num_res[DI],07h                                                         ;reemplazar ceros por 07h (campana)
	INC DI                                                                      ;Incrementa en uno el valor de DI
	CMP DI,13h                                                                  ;evitar el ultimo cero por si el resultado es cero (0+0=0)
	JLE siguiente_cero                                                          ;Salta a la etiqueta 'siguiente_cero' si es menor o igual
    JMP no_hay_mas_ceros_enteros                                                ;Salta a la etiqueta 'resultado_es_cero'
resultado_es_cero:                                                              ;Etiqueta 'resultado_es_cero'
    MOV num_res[DI],30h                                                         ;Asigna 30h a num_res[DI]
;;ajustar la parte decimal
no_hay_mas_ceros_enteros:                                                   	;Etiqueta 'no_hay_mas_ceros_enteros'

	MOV DI,13h                                                                  ;Asigna 13h a DI
siguiente_cero_decimal:                                                     	;Etiqueta 'siguiente_cero_decimal'
	CMP decimales_Res[DI],30h                                                   ;Compara decimales_Res[DI] con 30h
	JNE fin_ajuste_cero_decimal                                                 ;si el numero es diferente de cero ya terminamos el ajuste
;si es cero removerlo!
	MOV decimales_Res[DI],07h                                                   ;Asigna 07h a decimales_Res[DI]
	DEC DI                                                                      ;Decrementa en uno el valor de DI
	CMP DI,01h                                                                  ;si el resultado es cero salta a 'sin_punto_x_cero'
	JL  sin_punto_x_cero                                                        ;hasta el principio de los decimales
	JAE siguiente_cero_decimal                                                  ;Salta a la etiqueta 'siguiente_cero_decimal' si es mayor o igual
fin_ajuste_cero_decimal:                                                    	;Etiqueta 'fin_ajuste_cero_decimal'
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	sin_punto_x_cero:                                                           ;etiqueta 'sin_punto_x_cero'
	MOV sin_punto,01h                                                           ;enciende la bandera que nos indica que no hay punto
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	AJUSTE_CEROS_IZQUIERDA ENDP                                                 ;Fin del procedimiento
;----------------------MOUSE Y TECLADO
MOUSE PROC NEAR                                                             	;Inicia prodecimiento cercano 'MOUSE'
	SalvaRegistros                                                              ;Guarda el estado actual de los registros de proposito general
	RestituyeRegistros                                                          ;Restituye los registros de prosito general en 0

check_mouse_buttons:                                                        	;Etiqueta 'check_mouse_buttons'
	mov ax, 05h                                                                 ;asignamosa Ax 05 para que junto con la int 33 y
	MOV bx,00h                                                                  ;en bx enviamos el boton del mouse el cual queremos saber si se presiono
            ;click izquierdo=0, cick derecho=1            
	int 33h                                                                     ;regresa la veces que se preisono en bx y las coordenadas X,Y del mouse en CX,DX
	mov curX, cx                                                                ;Asigna el contenido de cx a curX
	mov curY, dx                                                                ;Asigna el contenido de dx a curY
	cmp bx, 1                                                                   ; si se presiono al menos una vez
	JAE click                                                                   ;ocultar el mouse y ejecutar la seleccion
;ESPERAR POR EL TECLADO
	XOR AX,AX                                                                   ;Resituye el registro  AX a ceros por medio de XOR
	mov ah, 01h                                                                 ;Asigna 01h a ah
	int 16h                                                                     ;Interrupcion 16h (funciones de llamada al teclado)
	jnz TECLA_PRESIONADA                                                        ;Salta a la etiqueta 'TECLA_PRESIONADA' si no hay signo el ZF
	jmp check_mouse_buttons                                                     ;Salta a la etiqueta 'check_mouse_buttons'

TECLA_PRESIONADA:                                                           	;Etiqueta 'TECLA_PRESIONADA'
	MOV registros_tbl[0h],AX                                                    ;Asigna el contenido de AX a registros_tbl[0h]
	MOV AH,0Ch                                                                  ;Asigna 0Ch a AH
	MOV AL,0                                                                    ;Asigna 0 a AL
	INT 21H                                                                     ;Interrupcion 21h (funciones de el DOS API)
	RecuperaRegistros                                                           ;Reestablece los registros de proposito general al ultimo estado en el que se salvaron
	ret                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
click:                                                                      	;Etiqueta 'click'
	XOR BX,BX                                                                   ;Resituye el registro  BX a ceros por medio de XOR
	JMP click_valido                                                            ;Salta a la etiqueta 'click_valido'
click_invalido:                                                             	;Etiqueta 'click_invalido'
	JMP check_mouse_buttons                                                     ;Salta a la etiqueta 'check_mouse_buttons'
click_valido:                                                               	;Etiqueta 'click_valido'
;LOS BOTONES DE LOS OPERADORES Y NUMEROS EN X VAN DESDE 28h HASTA 70h EN Y
	CMP curY,28h                                                                ;si es menor o igual que 28h no esta en ningun boton
	JL  click_invalido                                                          ;Salta a la etiqueta 'click_invalido' si es menor

	CMP curY,70h                                                                ;si es mayor o igual que 70h no esta en ningun boton
	JAE  click_invalido                                                         ;Salta a la etiqueta 'click_invalido' si es mayor o igual
  
	CMP curY,50h                                                                ;los botones numeros y igual van desde el 50h en Y
	JAE numeros                                                                 ;si es mayor o igual a 50h estamos en el panel de operadores
	JMP operadores                                                              ;si es menor que 50h estamos el en panel numerico

operadores:                                                                 	;Etiqueta 'operadores'
    ;COMPARAMOS SOBRE QUE OPERACION SE DIO CLICK
    
    ;la suma va del 30h al A0h
	CMP CurX,0A0h                                                               ;Compara CurX con 0A0h
	JA  no_es_suma                                                              ;Salta si es mayor a la etiqueta 'no_es_suma'
	MOV seleccion,00h                                                           ;asigna 0 a la seleccion (valor del primer boton de la primer fila)
	MOV AL,2BH                                                                  ;Asigna 2BH a AL
	ret                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_suma:                                                                 	;Etiqueta 'no_es_suma'
    ;la resta va hasta el 110h
	CMP CurX,130h                                                               ;Compara CurX con 130h
	JA no_es_resta                                                              ;Salta si es mayor a la etiqueta 'no_es_resta'
	MOV seleccion,01h                                                           ;Asigna 01h a seleccion
	MOV AL,2Dh                                                                  ;Asigna 2Dh a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_resta:                                                                	;Etiqueta 'no_es_resta'
    ;la multiplicacion va hasta el 1AA
	CMP CurX,1AAh                                                               ;Compara CurX con 1AAh
	JA no_es_multiplica                                                         ;Salta si es mayor a la etiqueta 'no_es_multiplica'
	MOV seleccion,02h                                                           ;Asigna 02h a seleccion
	MOV AL,2Ah                                                                  ;Asigna 2Ah a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_multiplica:                                                           	;Etiqueta 'no_es_multiplica'
    ;la division va hasta el 1F0h
	CMP CurX,230h                                                               ;Compara CurX con 230h
	JA no_es_divide                                                             ;Salta si es mayor a la etiqueta 'no_es_divide'
	MOV seleccion,03h                                                           ;Asigna 03h a seleccion
	MOV AL,2Fh                                                                  ;Asigna 2Fh a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_divide:                                                               	;Etiqueta 'no_es_divide'
    ;si no fue ningun operando el click es erroneo
	JMP check_mouse_buttons                                                     ;Salta a la etiqueta 'check_mouse_buttons'
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
numeros:                                                                    	;Etiqueta 'numeros'
    ;el numero 0 va desde el 30h al 50h
	CMP CurX,50h                                                                ;Compara CurX con 50h
	JA no_es_cero                                                               ;Salta si es mayor a la etiqueta 'no_es_cero'
	MOV SELECCION,04h                                                           ;Asigna 04h a SELECCION
	MOV AL,30h                                                                  ;Asigna 30h a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_cero:                                                                 	;Etiqueta 'no_es_cero'
    
    ;el numero 1 va desde el 50h al 70h
	CMP CurX,80h                                                                ;Compara CurX con 80h
	JA no_es_uno                                                                ;Salta si es mayor a la etiqueta 'no_es_uno'
	MOV SELECCION,05h                                                           ;Asigna 05h a SELECCION
	MOV AL,31h                                                                  ;Asigna 31h a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_uno:                                                                  	;Etiqueta 'no_es_uno'
    ;el numero 2 va desde el 70h al A0h
	CMP CurX,0B0h                                                               ;Compara CurX con 0B0h
	JA no_es_dos                                                                ;Salta si es mayor a la etiqueta 'no_es_dos'
	MOV SELECCION,06h                                                           ;Asigna 06h a SELECCION
	MOV AL,32h                                                                  ;Asigna 32h a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_dos:                                                                  	;Etiqueta 'no_es_dos'
    ;el numero 3 va desde el 90h al B0h
	CMP CurX,0E0h                                                               ;Compara CurX con 0E0h
	JA no_es_tres                                                               ;Salta si es mayor a la etiqueta 'no_es_tres'
	MOV SELECCION,07h                                                           ;Asigna 07h a SELECCION
	MOV AL,33h                                                                  ;Asigna 33h a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_tres:                                                                 	;Etiqueta 'no_es_tres'
    ;el numero 4 va desde el 30h al 50h
	CMP CurX,0110h                                                              ;Compara CurX con 0110h
	JA no_es_cuatro                                                             ;Salta si es mayor a la etiqueta 'no_es_cuatro'
	MOV SELECCION,08h                                                           ;Asigna 08h a SELECCION
	MOV AL,34h                                                                  ;Asigna 34h a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_cuatro:                                                               	;Etiqueta 'no_es_cuatro'
    ;el numero 5 va desde el 30h al 50h
	CMP CurX,0140h                                                              ;Compara CurX con 0140h
	JA no_es_cinco                                                              ;Salta si es mayor a la etiqueta 'no_es_cinco'
	MOV SELECCION,09h                                                           ;Asigna 09h a SELECCION
	MOV AL,35h                                                                  ;Asigna 35h a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_cinco:                                                                	;Etiqueta 'no_es_cinco'
    ;el numero 6 va desde el 30h al 50h
	CMP CurX,170h                                                               ;Compara CurX con 170h
	JA no_es_seis                                                               ;Salta si es mayor a la etiqueta 'no_es_seis'
	MOV SELECCION,0Ah                                                           ;Asigna 0Ah a SELECCION
	MOV AL,36h                                                                  ;Asigna 36h a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_seis:                                                                 	;Etiqueta 'no_es_seis'
    ;el numero 7 va desde el 30h al 50h
	CMP CurX,1A0h                                                               ;Compara CurX con 1A0h
	JA no_es_siete                                                              ;Salta si es mayor a la etiqueta 'no_es_siete'
	MOV SELECCION,0Bh                                                           ;Asigna 0Bh a SELECCION
	MOV AL,37h                                                                  ;Asigna 37h a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_siete:                                                                	;Etiqueta 'no_es_siete'
    ;el numero 8 va desde el 30h al 50h
	CMP CurX,1D0h                                                               ;Compara CurX con 1D0h
	JA no_es_ocho                                                               ;Salta si es mayor a la etiqueta 'no_es_ocho'
	MOV SELECCION,0Ch                                                           ;Asigna 0Ch a SELECCION
	MOV AL,38h                                                                  ;Asigna 38h a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_ocho:                                                                 	;Etiqueta 'no_es_ocho'
    ;el numero 9 va desde el 30h al 50h
	CMP CurX,200h                                                               ;Compara CurX con 200h
	JA no_es_nueve                                                              ;Salta si es mayor a la etiqueta 'no_es_nueve'
	MOV SELECCION,0Dh                                                           ;Asigna 0Dh a SELECCION
	MOV AL,39h                                                                  ;Asigna 39h a AL
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_nueve:                                                                	;Etiqueta 'no_es_nueve'
    ;el signo = va desde el 30h al 50h
	CMP CurX,230h                                                               ;Compara CurX con 230h
	JA no_es_igual                                                              ;Salta si es mayor a la etiqueta 'no_es_igual'
	MOV SELECCION,0Eh                                                           ;Asigna 0Eh a SELECCION
	MOV AX,0B3Dh                                                                ;Asigna 0B3Dh a AX
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
no_es_igual:                                                                	;Etiqueta 'no_es_igual'
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
STOP:                                                                       	;Etiqueta 'STOP'
	XOR AX,AX                                                                   ;Resituye el registro  AX a ceros por medio de XOR
	INT 16H                                                                     ;Interrupcion 16h (funciones de llamada al teclado)
	RET                                                                         ;Retorna el control a la direccion de el SP desde donde se llamo
	MOUSE endp                                                                  ;Fin del procedimiento
	end begin                                                                   ;Fin de programa