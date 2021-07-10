INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE
.386
.STACK 200h
	.DATA
	MAXTEXTSIZE equ 200
actual                          	dd	?
a1                              	dd	?
a2                              	dd	?
a3                              	dd	?
a4                              	dd	?
a5                              	dd	?
a6                              	dd	?
b1                              	dd	?
c1                              	dd	?
_Ingrese_un_numero              	db	"Ingrese un numero",'$', 17 dup (?)
@OUTDISPLAY                     	dd	?
@STDIN                          	dd	?
_a1                             	db	"a1",'$', 2 dup (?)
_a2                             	db	"a2",'$', 2 dup (?)
_IF                             	db	"IF",'$', 2 dup (?)
_a1_es_mayor_a_a2               	db	"a1 es mayor a a2",'$', 16 dup (?)
_a1_es_menor_a_a2               	db	"a1 es menor a a2",'$', 16 dup (?)

.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV es,ax
FINIT
FFREE

displayString _Ingrese_un_numero
newLine 1
GetFloat a1
displayString _Ingrese_un_numero
newLine 1
GetFloat a2
displayString _a1
newLine 1
DisplayFloat a1,2
newLine 1
displayString _a2
newLine 1
DisplayFloat a2,2
newLine 1
displayString _IF
newLine 1
fld a2
fld a1
fxch
fcom
fstsw ax
sahf
JNA else1
startIf1:
displayString _a1_es_menor_a_a2
newLine 1
JMP endif1
else1:
displayString _a1_es_mayor_a_a2
newLine 1
endif1:

liberar:
	ffree
	mov ax, 4c00h
	int 21h
	jmp fin
fin:
	End START
