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
_1                              	dd	1
_2                              	dd	2
_3                              	dd	3
_9                              	dd	9
_5                              	dd	5
_4                              	dd	4
_8                              	dd	8
_7                              	dd	7
_Entra_por_el_THEN              	db	"Entra por el THEN",'$', 17 dup (?)
@OUTDISPLAY                     	dd	?
_Entra_por_el_ELSE              	db	"Entra por el ELSE",'$', 17 dup (?)
_3_01                           	dd	3.01
otra                            	dd	?
_1_5                            	dd	1.5
_Encontre_actual                	db	"Encontre actual",'$', 15 dup (?)
_NO_encontre_actual             	db	"NO encontre actual",'$', 18 dup (?)
@aux1                           	dd	?
@aux2                           	dd	?
@aux3                           	dd	?
@aux4                           	dd	?
@aux5                           	dd	?
@aux6                           	dd	?
@aux7                           	dd	?
@aux8                           	dd	?
@aux9                           	dd	?

.CODE

START:
MOV AX,@DATA
MOV DS,AX
MOV es,ax
FINIT
FFREE

fild _1
fild _2
fadd
fstp @aux1
fild _3
fild _2
fmul
fstp @aux2
fld @aux1
fld @aux2
fadd
fstp @aux3
fld @aux3
fst a1
fld a1
fild _1
fadd
fstp @aux4
fld @aux4
fst a2
fild _2
fild _2
fxch
fcom
fstsw ax
sahf
JA startIf1
fld a2
fld a1
fxch
fcom
fstsw ax
sahf
JBE startIf1
fild _9
fld a1
fxch
fcom
fstsw ax
sahf
JA startIf1
fild _5
fild _4
fadd
fstp @aux5
fld @aux5
fild _2
fsub
fstp @aux6
fld @aux6
fild _1
fadd
fstp @aux7
fld @aux7
fild _1
fadd
fstp @aux8
fld @aux8
fild _1
fadd
fstp @aux9
fld @aux9
fld a1
fxch
fcom
fstsw ax
sahf
JBE startIf1
fild _7
fild _8
fxch
fcom
fstsw ax
sahf
JE startIf1
fild _5
fild _4
fxch
fcom
fstsw ax
sahf
JE startIf1
JMP else1
else1:
displayString _Entra_por_el_ELSE
newLine 1
JMP endif1
startIf1:
displayString _Entra_por_el_THEN
newLine 1
endif1:
fld _3_01
fst actual
fld _1_5
fst otra
fild _2
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf2
fild _1
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf2
fld otra
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf2
fild _3
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf2
JMP else2
else2:
displayString _NO_encontre_actual
newLine 1
JMP endif2
startIf2:
displayString _Encontre_actual
newLine 1
endif2:

liberar:
	ffree
	mov ax, 4c00h
	int 21h
	jmp fin
fin:
	End START
