.model small
.data 

temp db ?
choice db ?

Input1  dw 5 dup ('$')
Input2  dw 5 dup ('$')
answer  dw 10 dup ('$')
temp1   dw 10 dup ('$')

DFilaArri db 0C9h,0CDh,0BBh 
DColumna  db 0BAh
DFilaAba  db 0C8h,0CDh,0BCh

DTitle db "________________Calculator________________","$"
Dadd   db "A- Addition","$"
Dsub   db "S- Subtraction","$"
Dmul   db "M- Multiplication","$"
Ddiv   db "D- Division","$"
Dexit  db "E-Exit","$"

Dprompt db "Please Select An Operation:","$"

DispA  db "Addition","$"
DispS  db "Subtraction","$"
DispM  db "Multiplication","$"
DispD  db "Division","$"

Dprompt1 db "Enter 1st Number:","$"
Dprompt2 db "Enter 2nd Number:","$"
Danswer  db "Answer:","$"
Dnega db '-','$'
Drem db '+ remainder',"$"

DError db "Invalid Choice. Pleas Enter The Corresponding Letters.", "$"
Dloop db "Press Any Key To Continue. . .","$"

.code
begin proc far

Inicio:

    mov ax, @data
    mov ds, ax

Caratula:    
;___________________________________________    
    mov ah, 06h   ;limpia la pantalla
    mov al, 00h   ;inicio del cuadro
    mov bh, 0A1h  ;color blanco
    mov cx, 0000h ;color blanco
    mov dx, 184Fh ;tamaño de la pantalla blanca
    int 10h

    mov ah, 02h     ;goto xy
    mov bh, 00
    mov dh, 0h     ;posicion del cursor en y
    mov dl, 0h     ;posicion del cursor en x
    int 10h
        lea bx, DFilaArri ;asigna la direccion inicial de la cadena fila       
        mov dl,[bx]   ;asina a dl en primer caracter (esquina izquierda)  
        mov ah,02   ;asigna 2 a ah (Imprime caracter)       
        int 21h      ;imprime caracter
        mov CX,4Eh     ;asigna 4Eh a cx (78 decimal que es el ancho de la pantalla)
        inc bx ;incrementa bx para obtener el siguiente caracter (linea)
        mov dl,[bx] ;asigna a dl el segundo caracter (linea)     
Car_filaArr:
        int 21h     ;imprime caracter
Loop Car_filaArr  
    inc bx ;incrementa bx para obtener el siguiente caracter (esquina derecha)
    mov dl,[bx] ;asigna a dl el segundo caracter (esquina derecha) 
    int 21h   ;imprime caracter

    mov ah, 02h     ;goto xy
    mov bh, 00
    mov dh, 20d     ;posicion del cursor en y
    mov dl, 0h     ;posicion del cursor en x
    int 10h
    
lea bx,DFilaAba
        mov dl,[bx]   ;asina a dl en primer caracter (esquina izquierda)  
        mov ah,02   ;asigna 2 a ah (Imprime caracter)       
        int 21h      ;imprime caracter
        mov CX,4Eh     ;asigna 4Eh a cx (78 decimal que es el ancho de la pantalla)
        inc bx ;incrementa bx para obtener el siguiente caracter (linea)
        mov dl,[bx] ;asigna a dl el segundo caracter (linea)  
Car_filaAba:   
        int 21h     ;imprime caracter
Loop Car_filaAba  
    inc bx ;incrementa bx para obtener el siguiente caracter (esquina derecha)
    mov dl,[bx] ;asigna a dl el segundo caracter (esquina derecha) 
    int 21h   ;imprime caracter
;____________________________________________
   ;Display add
    mov ah, 02h
    mov dh, 03
    mov dl, 22h
    int 10h

    lea dx, Dadd
    mov ah, 09h
    int 21h

   ;Display sub 
    mov ah, 02h
    mov dh, 04
    mov dl, 22h
    int 10h

    lea dx, Dsub
    mov ah, 09h
    int 21h

   ;Dislay mul 
    mov ah, 02h
    mov dh, 05
    mov dl, 22h
    int 10h

    lea dx, Dmul
    mov ah, 09h
    int 21h

   ;Display div
    mov ah, 02h
    mov dh, 06
    mov dl, 22h
    int 10h

    lea dx, Ddiv
    mov ah, 09h
    int 21h

   ;Display Exit
    mov ah, 02h
    mov dh, 07
    mov dl, 22h
    int 10h

    lea dx, Dexit
    mov ah, 09h
    int 21h

   ;Display Prompt Message
    mov ah, 02h
    mov dh, 09
    mov dl, 1Ah
    int 10h

    lea dx, Dprompt
    mov ah, 09h
    int 21h

   ;Capture choice
    mov ah, 1
    int 21h

   ;Stores choice to al 
    mov choice, al
;____________________________________________


;Input first number__________________________

    ;Set Cursor
    mov ah, 02h
    mov bh, 00
    mov dh, 11
    mov dl, 1Ah
    int 10h

    ;Display Dprompt1
    mov ah, 09h
    lea dx, Dprompt1
    int 21h

    mov ax, 000h
    lea si, input1
    mov cx, 0000h

inputfirst:

    ;INPUT FIRST NUMBER
    mov ah, 1               ; input number
    int 21h           

    cmp al, 0dh             ; detect 'enter' press
    je exitfirst

    sub al, 30h             ; get decimal value

    mov byte ptr[si],al     ; point address of al to si pointer
    inc si                  ; proceed to next index

    jmp inputfirst

exitfirst:

    lea si, input1          ; point address of input1 to si
    mov bx, 0000h           ; clear bx
    mov bh, [si]            ; copy value of si to bh
    mov bl, [si+1]          ; copy value of the next index of si to bl

    mov ax, 10              ; initialize ax by 10
    mul bh                  ; multiply ax by bh

    add bl, al              ; add bl and al to complete decimal number
    mov bh, 00              ; clear bh

    mov input1, bx          ; save bx to input1    



;Input second number____________________________

    ;Set Cursor
    mov ah, 02h
    mov bh, 00
    mov dh, 13
    mov dl, 1Ah   
    int 10h

    ;DISPLAY MSG8
    mov ah, 09h
    lea dx, Dprompt2
    int 21h

    mov ax, 0000h       ; clear ax
    mov bx, 0000h       ; clear bx
    lea si, Input2      ; point address of num2 to si
    mov cx, 0000h       ; clear cx

inputsecond: 

    ;INPUT SECOND NUMBER
    mov ah, 1           ; input character
    int 21h

    cmp al, 0dh         ; detect 'enter' press
    je exitsecond

    sub al, 30h         ; get decimal value

    mov byte ptr[si],al ; point address of al to pointer si
    inc si              ; proceed to next index

    jmp inputsecond

exitsecond:  

    lea si, Input2      ; point adress of num2 to si
    mov bx, 0000h       ; clear bx
    mov bh, [si]        ; copy value of si to bh
    mov bl, [si+1]      ; copy value of the next index of si to bl

    mov ax, 10          ; initialize ax by 10
    mul bh              ; multiply ax by bh

    add bl, al          ; add bl and al to complete decimal number
    mov bh, 00          ; clear bh

    mov Input2, bx      ; save bx to num2



;Testing choice__________________________________    
    cmp choice, 'A'    
    jne Test1
    call addition

Test1:    
    cmp choice, 'a'     
    jne Test2
    call addition

Test2:
    cmp choice, 'S'   
    jne Test3
    call subtraction

Test3:
    cmp choice, 's'   
    jne Test4
    call subtraction

Test4:    
    cmp choice, 'M'  
    jne Test5
    call multiplication

Test5:    
    cmp choice, 'm'   
    jne Test6
    call multiplication

Test6:        
    cmp choice, 'D'  
    jne Test7
    call division

Test7:        
    cmp choice, 'd'  
    jne Test8
    call division 

Test8:

    ;Set Cursor Position
    mov ah, 02h
    mov bh, 00
    mov dx, 1115h     
    int 10h

    ;Display Error Message
    mov ah, 09h
    lea dx, DError
    int 21h

    jmp Caratula


stop:

    mov ax, 0000h     ; clear ax
    mov ax, answer    ; copy value of result to ax
    lea si, temp1      ; point address of temp to si
    call conversion

    ;Set Cursor
    mov ah, 02h
    mov bh, 00                 
    mov dx, 1115h     
    int 10h

    ;Displays answer
    mov ah, 09h
    lea dx, Danswer
    int 21h

    ;displays temp1 
    mov ah, 09h
    lea dx, temp1
    int 21h      

exit:
    mov ah, 4ch
    int 21h 

;_________________________________________
;Proceedures_____________________

;Conversion______________________________________
conversion proc near

        mov cx, 0000h     ; Reset cx
        mov bx, 10        ; set value for division

loop1:
        mov dx, 0         ; set first decimal value to 0
        div bx            ; Divide by 10
        add dl, '0'       ; Add by 30h to match ASCII
        push dx           ; copy value to stack
        inc cx            ; increment counter cx
        cmp ax, 9         ; compare value of ax to 9
        jg loop1          ; until ax value > 9, jump to loop1

        add al, '0'       ; Add by 30h to match ASCII
        mov [si], al      ; copy value to si

loop2:
        pop ax            ; get the last value from stack
        inc si            ; increment counter cx                    
        mov [si], al      ; copy value to si
        loop loop2        ; jump to loop2 
        ret

conversion endp
;_________________________________________________

;Operation Proceedures_____________________

;Addtion_____________
addition proc near

    mov ax, 0000h       ; clear ax
    mov bx, 0000h       ; clear bx
    mov ax, Input1      ; copy value of num1 to ax
    mov bx, Input2      ; copy value of num2 to bx
    add ax, bx        

    mov answer, ax      ; copy value of ax to result

    jmp stop

addition endp
;_____________________

;Subtraction__________
subtraction proc near

    mov ax, 0000h     ; clear ax
    mov bx, 0000h     ; clear bx
    mov ax, Input1      ; copy value of num1 to ax
    mov bx, Input2      ; copy value of num2 to bx

    cmp bx, ax        ; compare ax and bx
    jg secondgreat    ; if second input is greater, jump to secondgreat

    sub ax, bx        ; if first input is greater, proceed to subtraction
    mov answer, ax    ; copy value of ax to result

    jmp stop

secondgreat:

    mov ax, Input2      ; copy value of num2 to ax
    mov bx, Input1      ; copy value of num1 to bx
    sub ax, bx
    mov answer, ax    ; copy value of ax to result

    lea si, temp1      ; point address of temp to si
    call conversion

    ;SETTING CURSOR TO POSITION
    mov ah, 02h
    mov bh, 00
    mov dx, 1115h     ; Row 17, Column 21
    int 10h

    ;Display answer
    mov ah, 09h
    lea dx, Danswer
    int 21h   

    ;display negative sign
    mov ah,09h
    lea dx, Dnega
    int 21h

    ;DISPLAY TEMP1
    mov ah, 09h
    mov dx, offset temp1
    int 21h

    jmp exit

subtraction endp
;_____________________

;Multiplication_______
multiplication proc near

    mov ax, 0000h     ; clear ax
    mov bx, 0000h     ; clear bx
    mov ax, Input1      ; copy value of num1 to ax
    mov bx, Input2      ; copy value of num2 to bx
    mul bx            ; multiply ax by bx

    mov answer, ax    ; copy value of ax to result

    jmp stop

multiplication endp
;_____________________

;Division_____________
division proc near

    mov ax, 0000h     ; clear ax
    mov bx, 0000h     ; clear bx
    mov ax, Input1      ; copy value of num1 to ax
    mov bx, Input2      ; copy value of num2 to bx
    div bl            ; divide ax by bl

    mov temp, al     ; copy value of al to temp1

    cmp ah, 00h       ; clear ah
    je noremainder

    mov ah, 00h       ; clear ah
    mov al, temp     ; copy value temp1 to al
    mov answer, ax    ; copy value of ax to result

    mov ax, 0000h     ; clear ax
    mov ax, answer    ; copy value of result to ax
    lea si, temp1      ; point address of temp to si
    call conversion

    ;SETTING CURSOR TO POSITION
    mov ah, 02h
    mov bh, 00
    mov dx, 1115h     ; Row 17, Column 15
    int 10h

    ;DISPLAY MSG9
    mov ah, 09h
    lea dx, Danswer
    int 21h

    ;DISPLAY TEMP
    mov ah, 09h
    lea dx, temp1
    int 21h 

    ;DISPLAY MSG11  
    mov ah, 09h
    lea dx, Drem
    int 21h

    jmp exit

noremainder:

    mov ah, 00h       ; clear ah
    mov al, temp     ; copy value of temp1 to al

    mov answer, ax    ; copy value of ax to result
    jmp stop

division endp
;_____________________

;_________________________________________________________

;End of program



End begin