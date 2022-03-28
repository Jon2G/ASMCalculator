            .model small
            .stack
            .data
   
num_1_mul       db 0,0,0,0,0,0,0,0,0
decimal_1_mul   db 0,0,0,0,0,0,0,0,0

num_2_mul       db 0,0,0,0,0,0,0,0,0
decimal_2_mul   db 0,0,0,0,0,0,0,0,0

acarreo     db 0

num_res_mul     db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
decimal_res_mul db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

num1        db 0,9,9,9,9,9,9,9,9,9,'$' 
decimales_1 db 0,9,9,9,9,9,9,9,9,9,'$'   
num2        db 0,9,9,9,9,9,9,9,9,9,'$'  
decimales_2 db 0,9,9,9,9,9,9,9,9,9,'$'

num_res       db 14h dup(0),'$'  
decimales_Res db 14h dup(0),'$'


            .code
        
inicio:

            mov ax,@data
            mov ds,ax
            
Multiplic proc FAR
            
          MOV CX,09h
cpy_mul_e:
          MOV SI,CX
          MOV AL,num1[SI]
          MOV num_1_mul[SI-1],Al  
          
          MOV AL,num2[SI]
          MOV num_2_mul[SI-1],Al
          LOOP cpy_mul_e
          
          MOV CX,09h
cpy_mul_d:
          MOV SI,CX
          MOV AL,decimales_1[SI]
          MOV decimal_1_mul[SI-1],Al  
          
          MOV AL,decimales_1[SI]
          MOV decimal_2_mul[SI-1],Al
          LOOP cpy_mul_d          
                               
          mov si,0000h
          mov di,0000h
          
          LEA di,num_res_mul[23h]          
          LEA si,num_1_mul[11h]          
          LEA bx,num_2_mul
          
          mov cx,18
          
p_ciclo_mul:
     
          PUSH cx
          PUSH di
          mov ax,17
          mov cx,18
          
          s_ciclo_mul:

              mov dx,ax
                    
              XLAT
          
              mov dh,[si]
              mul dh
              
              AAM
 
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
          
          POP di
          POP cx
          
          dec si
          dec di
          
          mov acarreo,0h    
          
          LOOP p_ciclo_mul


mov cx,36
LEA di,num_res_mul

ciclo_A:

         mov al,[di]
         add al,30h
         mov [di],al
         inc di
         
         LOOP ciclo_A
         
       
    MOV CX,11h        
cpy_res_e:      
    MOV SI,CX
    MOV AL,num_res_mul[SI]
    MOV num_res[SI+2],Al
    LOOP cpy_res_e
    MOV CX,11h  
cpy_res_d:        
    MOV SI,CX
    MOV AL,decimal_res_mul[SI]
    MOV decimales_res[SI],Al
    LOOP cpy_res_d  
    
    MOV decimales_res[0h],07h
    MOV decimales_res[12h],30H
    MOV decimales_res[13h],30H
    MOV num_res[00h],30h
    MOV num_res[01h],30h
    MOV num_res[02h],30h                    
Multiplic endp
          

                        