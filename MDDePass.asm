; 2002.10.19
.MODEL TINY
.CODE
.286
        org  80h
ParamStr db  ?
        org  100h
start:
        mov  si,offset ParamStr
        mov  dx,offset Usage
        xor  ax,ax
        lodsb
        or   al,al
        jz   ExitPrint
        mov  cx,ax
        mov  di,si
        lodsb
        repe scasb
        jcxz ExitPrint
        mov  dx,di
        dec  dx
        inc  cx
        repne scasb 
        xor  ax,ax
        dec  di
        stosb

        mov  si,dx
        call MD_decode
        mov  dx,si

ExitPrint:
        mov  ah,9
        int  21h
        ret

MD_decode  proc near
; In/Out: si -> string in asciz

        push si
        xor  dx,dx
        xor  cx,cx
        mov  di,si
        push offset MD_xlat2
        mov  bx,offset MD_xlat1
loop1:
        xor  ax,ax
        lodsb
        or   al,al
        jz   short exit

        xlat
        cmp  al,'@'
        jnb  short exit

        shl  dx,6
        add  cl,6
        or   dx,ax
        cmp  cl,8
        jb   short next
        sub  cl,8
        mov  ax,dx
        shr  ax,cl

        mov  ah,cl  ; save bx
        mov  cx,bx  ;

        pop  bx     
        sub  al,[bx]
        inc  bx     
        push bx     

        mov  bx,cx  ; restore bx
        mov  cl,ah  ; 

        stosb
next:
        jmp short loop1
exit:
;        xor  al,al
        mov  al,'$' ; for this realisation
        stosb
        pop  bx
        pop  si
        retn
MD_decode  endp

Usage    db 'MDaemon',27h,'s password decoder by r0dent'
         db 0Dh,0Ah,0Dh,0Ah
         db '   Usage: MDDePass <encoded string (password)>'
         db 0Dh,0Ah,'$'

MD_xlat1 db '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@>@@@?456789:;<=@@'
         db '@@@@@',0,1,2,3,4,5,6,7,8,9,0Ah
         db 0Bh,0Ch,0Dh,0Eh,0Fh,10h,11h,12h,13h,14h,15h,16h,17h,18h,19h,'@'
         db '@@@@@',1Ah,1Bh,1Ch,1Dh,1Eh,1Fh,' !"#$%&',27h,'()*+,-./0123@@'
         db '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
         db '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
         db '@@@@@@@@@@@'

MD_xlat2 db 'The setup process could not create a required account called'
         db ' MDaemon.  This problem could be the result of an invalid te'
         db 'mplate string.  Please check your template settings in MDAEM'
         db 'ON.INI and verify that they will produce a valid user accoun'
         db 't.',0
end start
