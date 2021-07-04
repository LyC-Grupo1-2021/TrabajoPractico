INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE
.386
.STACK 200h
    .DATA
    MAXTEXTSIZE equ 200
var                                 dd  ?
_2                                  dd  2
_3                                  dd  3
_MARZU                              db  "MARZU",'$', 5 dup (?)
@OUTDISPLAY                         dd  ?
@aux1                               dd  ?

.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV es,ax
FINIT
FFREE

fild _2
fild _3
fadd
fstp @aux1
fld @aux1
fstp var
displayString _MARZU
newLine 1

liberar:
    ffree
    mov ax, 4c00h
    int 21h
    jmp fin
fin:
    End START
