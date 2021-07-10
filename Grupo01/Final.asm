INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE
.386
.STACK 200h
	.DATA
	TRUE equ 1
	MAXTEXTSIZE equ 200
actual                          	dd	?
otra                            	dd	?
_2_5                            	dd	2.5
_5                              	dd	5
_2                              	dd	2
@aux                            	dd	?
@resultInlist                   	dd	?
_1                              	dd	1
_3                              	dd	3
_Encontre_actual                	db	"Encontre actual",'$', 15 dup (?)
@OUTDISPLAY                     	dd	?
_NO_encontre_actual             	db	"NO encontre actual",'$', 18 dup (?)
@aux1                           	dd	?

.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV es,ax
FINIT
FFREE

fld _2_5
fst actual
fild _5
fild _2
fdiv
fstp @aux1
fld @aux1
fst otra
fild @aux
fist _2
fld actual
fld :
fxch
fcom
fstsw ax
sahf
JNE endif2
startIf2:
fld @resultInlist
fst TRUE
endif2:
fild @aux
fist _1
fld actual
fld :
fxch
fcom
fstsw ax
sahf
JNE endif3
startIf3:
fld @resultInlist
fst TRUE
endif3:
fild @aux
fst otra
fld actual
fld :
fxch
fcom
fstsw ax
sahf
JNE endif4
startIf4:
fld @resultInlist
fst TRUE
endif4:
fild @aux
fist _3
fld actual
fld :
fxch
fcom
fstsw ax
sahf
JNE endif5
startIf5:
fld @resultInlist
fst TRUE
endif5:
fld TRUE
fld @resultInlist
fxch
fcom
fstsw ax
sahf
JNE endif1
fild @resultInlist
fild TRUE
fcom
fstsw ax
sahf
startIf1:
displayString _NO_encontre_actual
newLine 1
JMP endif1
else1:
displayString _Encontre_actual
newLine 1
endif1:

liberar:
	ffree
	mov ax, 4c00h
	int 21h
	jmp fin
fin:
	End START
