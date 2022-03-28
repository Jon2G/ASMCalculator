            .model small
            .stack
            .data
   
num_1       db 0,0,0,0,0,0,0,0,0
decimal_1   db 0,0,0,0,0,0,0,0,0

num_2       db 0,0,0,0,0,0,0,0,0
decimal_2   db 0,0,0,0,0,0,0,0,0

num_glo_res db 0,0,0,0,0,0,0,0,0,0
dec_glo_res db 0,0,0,0,0,0,0,0,0

display_str db "000009934.876500000+"
            db "000000100.976000000",'$',14 DUP(0)

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
                  
            CMP [di],'+'
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


Suma      proc FAR
          
          mov si,0000h
          mov di,0000h
          
          LEA di,num_glo_res[12h]          
          LEA si,num_1[11h]          
          LEA bx,num_2
          
          mov cx,18
          mov ax,17
          
cic_sum:   
          mov dx,ax
                    
          XLAT
          
          add al,[si]
          add al,acarreo
              
          AAM
          
          mov acarreo,ah 
          mov [di],al
                            
          mov ax,dx
          
          dec ax  
          dec si
          dec di     
          
          LOOP cic_sum
          
          mov al,acarreo
          mov [di],al
          
Suma      endp
          
;Ignorar lo siguiente ya que solo imprime resultado

mov cx,19
LEA di,num_glo_res

ciclo_A:

         mov al,[di]
         add al,30h
         mov [di],al
         inc di
         
         LOOP ciclo_A
         
mov cx,10
LEA di,num_glo_res
mov ah,2
        
cic_imp_ent:

         mov dl,[di]
         int 21h
         inc di
         
         LOOP cic_imp_ent
         
mov dl,'.'
int 21h
mov cx,9
LEA di,dec_glo_res

cic_imp_dec:

         mov dl,[di]
         int 21h
         inc di
         
         LOOP cic_imp_dec
                        