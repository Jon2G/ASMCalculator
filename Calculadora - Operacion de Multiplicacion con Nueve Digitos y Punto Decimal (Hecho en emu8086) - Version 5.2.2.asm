            .model small
            .stack
            .data
   
num_1       db 0,0,0,0,0,0,0,0,0
decimal_1   db 0,0,0,0,0,0,0,0,0

num_2       db 0,0,0,0,0,0,0,0,0
decimal_2   db 0,0,0,0,0,0,0,0,0

num_res     db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
decimal_res db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

display_str db "000000000.000000001*"
            db "999999999.999999999",'$',14 DUP(0)

acarreo     db 0

            .code
        
inicio:

            mov ax,@data
            mov ds,ax
            
            LEA si,num_1
            LEA di,display_str
            
            JMP ciclo_llen
          
valida:

            inc di
            
ciclo_llen:
                  
            CMP [di],'*'
            JE  valida
          
            CMP [di],'.'
            JE  valida
            
            CMP [di],'$'
            JE  fin
        
            mov al,[di]
            sub al,30h
          
            mov [si],al
          
            inc si
            inc di
          
            JMP ciclo_llen
            
fin:


Multiplic proc FAR                  ;inicio del procedimiento "Multiplic"
          
          mov si,0000h              ;mueve 0 a SI para limpiarlo             
          mov di,0000h              ;mueve 0 a DI para limpiarlo
          
          LEA di,num_res[23h]       ;asigna a DI la direccion marcada por [num_res+23h] del DS          
          LEA si,num_1[11h]         ;asigna a SI la direccion marcada por [num_1+11h] del DS 
          LEA bx,num_2              ;asigna a BX la direccion inicial de la localidad de memoria num_2 en el DS
          
          mov cx,18                 ;asigna 18 a CX para determinar el numero de veces que se repetira el bucle principal
          
p_ciclo_mul:                        ;inicio de la etiqueta denominada "p_ciclo_mul"
     
          PUSH cx                   ;guarda el valor de CX a la pila para no afectar al bucle principal
          PUSH di                   ;guarda el valor de DI a la pila para no afectar los desplazamientos en el segundo bucle
          mov ax,17                 ;asigna 17 a AX,para determinar el desplazamiento inicial para la instruccion XLAT
          mov cx,18                 ;asigna 18 a CX para determinar el numero de veces que se repetira el bucle secundario
          
          s_ciclo_mul:              ;inicio de la etiqueta denominada "s_ciclo_mul"

              mov dx,ax             ;asigna el valor de ax a dx, para guardar ax antes de la instruccion XLAT
                    
              XLAT                  ;asigna a AL el valor de una localidad de memoria marcada por la direccion [BX+AX] del DS
          
              mov dh,[si]           ;asigna a DH el contenido de la direccion de memoria determinada por el desplazamiento si del DS
              mul dh                ;asigna a AL el resultado de AL*DH
              
              AAM                   ;convierte el contenido en AL 
 
              add al,[di]
              add al,acarreo
              mov acarreo,ah
              mov ah,0h
              AAM 
              mov [di],al
              
              mov al,acarreo
              add al,ah
              mov acarreo,al
              
              dec di
              mov dh,0
              mov ax,dx
              dec ax
              
              LOOP s_ciclo_mul
          
          mov ax,[di]
          add al,acarreo
          mov [di],al
          
          POP di                    ;asigna a DI el valor guardado
          POP cx                    ;asigna a CX el valor guardado en la pila
          
          dec si                    ;decrementa el valor de SI
          dec di                    ;decrementa el valor de DI
          
          mov acarreo,0h            ;asigna     
          
          LOOP p_ciclo_mul          ;declaracion del ciclo principal LOOP referenciado con la etiqueta "p_ciclo_mul"
          
Multiplic endp                      ;indica el fin del procedimiento "Multiplic"
          
;Ignorar lo siguiente ya que solo imprime resultado

mov cx,36
LEA di,num_res

ciclo_A:

         mov al,[di]
         add al,30h
         mov [di],al
         inc di
         
         LOOP ciclo_A
         
mov cx,18
PUSH cx
LEA di,num_res
mov ah,2
        
cic_imp_ent:

         mov dl,[di]
         int 21h
         inc di
         
         LOOP cic_imp_ent
         
mov dl,'.'
int 21h
POP cx
LEA di,decimal_res

cic_imp_dec:

         mov dl,[di]
         int 21h
         inc di
         
         LOOP cic_imp_dec
                        