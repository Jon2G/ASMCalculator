.model small
.stack
.data 
posicion_entrada dw 0000h                                                            
aux db 00h
display_str  db "Utilice las fechas y el teclado numerico para navegar",14 DUP(0),'$'
num1_tiene_decimales db 00h ;0 = false / 1 = true
num2_tiene_decimales db 00h ; 0 = false / 1 = true
.code
begin proc FAR
MOV AX,@DATA
MOV DS,AX
repito:
XOR AX,AX
INT 16H 
CALL ENTRADA_PROC
JMP repito
begin endp 

ENTRADA_PROC proc near 
   ;SalvaRegistros ;Guarda el estado actual de los registros de proposito general       

    CMP AL,029h ;si el caracter es '='
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
JE segundo_punto: 
                 ;si no el es el primero
MOV num1_tiene_decimales,01h 
JMP post_punto

segundo_punto:
MOV num2_tiene_decimales,01h
JMP post_punto   

Enm_Resuelve: 
;revisar si hace falta punto decimal en el segundo numero para agreagarlo
CMP num2_tiene_decimales,01h 
JE  esta_completo
;si no tiene agregalo
INC DI
MOV display_str[DI],"."
INC posicion_entrada 
MOV display_str[DI+1],"0"
INC posicion_entrada 
MOV display_str[DI+2],"0"
INC posicion_entrada
MOV DI,posicion_entrada
MOV num2_tiene_decimales,01h

esta_completo:
MOV display_str[DI],"$"
;limpiamos variables
MOV num1_tiene_decimales,00h
MOV num2_tiene_decimales,00h
MOV aux,00h
MOV AH,4CH
INT 21h
    ;CALL Resolver 
Enm_Salir:       
    ;RecuperaRegistros;Reestablece los registros de proposito general al ultimo estado en el que se salvaron 
RET
ENTRADA_PROC ENDP   
end begin