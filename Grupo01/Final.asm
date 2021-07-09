INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE
.386
.STACK 200h
    .DATA
    MAXTEXTSIZE equ 200
actual                              dd  ?
a1                                  dd  ?
a2                                  dd  ?
a3                                  dd  ?
a4                                  dd  ?
_5                                  dd  5
_2                                  dd  2
_3                                  dd  3
_4                                  dd  4
a6                                  dd  ?
@OUTDISPLAY                         dd  ?
@aux1                               dd  ?
@aux2                               dd  ?
@aux3                               dd  ?
@aux4                               dd  ?

.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV es,ax
FINIT
FFREE

fild _5
fild _2
fadd
fstp @aux1
fild _3
fild _4
fmul
fstp @aux2
fld @aux1
fld @aux2
fadd
fstp @aux3
fld @aux3
fst a3
fst a2
fst a1
fild _3
fild _2
fmul
fstp @aux4
fld @aux4
fst a6
DisplayFloat a1,2
newLine 1
DisplayFloat a2,2
newLine 1
DisplayFloat a6,2
newLine 1

liberar:
    ffree
    mov ax, 4c00h
    int 21h
    jmp fin
fin:
    End START
