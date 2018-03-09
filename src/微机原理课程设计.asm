porta        equ 288h
portb        equ 289h
portc        equ 28bh
assume cs:code
code   segment
start:
   begin:  mov     dx,portc
           mov     al,82h        ;A口方式0输出,B口方式0,输入
           out     dx,al
;测试8个开关的状态
s1:        mov     dx,portb                ; B 口读入开关状态
           in      al,dx
           mov     ah,0ffh
           ;al读入开关状态
           test    al,ah
           jz      s2   ;开关都是闭合转到s2
           mov     ah,0fBh
           mov     bl,al
           or      al,ah
           cmp     al,0ffh
           mov     al,bl
           jz      s2  ;k2=1转到s2
           ;以下分3种情况
           ;0000 0010---灯全灭
           ;0000 0011---停止闪烁即当前闪烁的灯一直亮
           ;0000 0001---按要求运行

           test    al,01h
           jz      s2   ;0000 0010跳转到s2,灯全灭
           test    al,02h
           jz      flag  ;0000 0001跳转到s3,按要求运行
flag:      mov     cx,4
           mov     al,80h;1000 0000B
           jmp     s3
           ;0000 0011 停止闪烁,全部都亮
flag1:     mov     al,0FFH
           mov     dx,porta
           out     dx,al

           ;测试开关的状态
flag2:     push    dx
           push    ax
           mov     dx,portb
           in      al,dx
           ;检测K2是否闭合
           mov     ah,04h
           test    al,ah
           jz      a11
           pop     ax
           pop     dx
           jmp     light
a11:       mov     ah,02h
           test    al,ah
           jz      a12
           pop     ax
           pop     dx
           jmp     flag1
a12:       pop     ax
           pop     dx
           mov     cx,4
           mov     al,80h;重新开始
           jmp     s3
          ;检测开关状态结束



;开关都是闭合的  或K2=1
s2:        mov     bl,0
           mov     al,bl
           mov     dx,porta
           out     dx,al
           call    delay
           jmp     s1
;K2=1
light:     mov     bl,0
           mov     al,bl
           mov     dx,porta
           out     dx,al
           call    delay
           jmp     flag2
;s3按要求运行
s3:
           mov     dx,porta
           out     dx,al
           call    delay;延时一秒
           push    cx
           mov     cl,2
           shr     al,cl
           pop     cx

           ;测试开关的状态
           push    dx
           push    ax
           mov     dx,portb
           in      al,dx
           ;检测K2是否闭合
           mov     ah,04h
           test    al,ah
           jz      a1
           pop     ax
           pop     dx
           jmp     s2
a1:        mov     ah,02h
           test    al,ah
           jz      a2
           pop     ax
           pop     dx
           jmp     flag1
a2:        pop     ax
           pop     dx
           ;检测开关状态结束

           loop    s3
           mov     cx,5

s4:        mov     al,0aah
           mov     dx,porta
           out     dx,al
           call    delay1
           mov     al,00h
           out     dx,al

           ;测试开关的状态
           push    dx
           push    ax
           mov     dx,portb
           in      al,dx
           ;检测K2是否闭合
           mov     ah,04h
           test    al,ah
           jz      a3
           pop     ax
           pop     dx
           jmp     s2
a3:        mov     ah,02h
           test    al,ah
           jz      a4
           pop     ax
           pop     dx
           jmp     flag1
a4:        pop     ax
           pop     dx
           ;检测开关状态结束

           call    delay1
           loop    s4


           call    delay
           mov     cx,4
           mov     al,40h;0100 0000B
s5:
           mov     dx,porta
           out     dx,al
           call    delay;延时一秒
           push    cx
           mov     cl,2
           shr     al,cl
           pop     cx


           ;测试开关的状态
           push    dx
           push    ax
           mov     dx,portb
           in      al,dx
           ;检测K2是否闭合
           mov     ah,04h
           test    al,ah
           jz      a5
           pop     ax
           pop     dx
           jmp     s2
a5:        mov     ah,02h
           test    al,ah
           jz      a6
           pop     ax
           pop     dx
           jmp     flag1
a6:        pop     ax
           pop     dx
           ;检测开关状态结束

           loop    s5
           mov     cx,5
s6:        mov     al,55h
           mov     dx,porta
           out     dx,al
           call    delay1
           mov     al,00h
           out     dx,al

            ;测试开关的状态
           push    dx
           push    ax
           mov     dx,portb
           in      al,dx
           ;检测K2是否闭合
           mov     ah,04h
           test    al,ah
           jz      a7
           pop     ax
           pop     dx
           jmp     s2
a7:        mov     ah,02h
           test    al,ah
           jz      a8
           pop     ax
           pop     dx
           jmp     flag1
a8:        pop     ax
           pop     dx
           ;检测开关状态结束

           call    delay1
           loop    s6
           call    delay
           jmp     flag
;延时1s子程序
delay proc near
        push cx
        push ax
        mov ax,250
x1:     mov cx,0ffffh
x2:     dec cx
        jnz x2
        dec ax
        jnz x1
        pop ax
        pop cx
        ret
delay endp
;延时闪烁子程序
delay1 proc near
        push cx
        push ax
        mov ax,100
x3:     mov cx,0ffffh
x4:     dec cx
        jnz x4
        dec ax
        jnz x3
        pop ax
        pop cx
        ret
delay1 endp
code   ends
end start








