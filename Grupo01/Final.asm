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
otra                            	dd	?
_1_5                            	dd	1.5
_9                              	dd	9
_5                              	dd	5
_4                              	dd	4
_IF_con_OR_true                 	db	"IF con OR true",'$', 14 dup (?)
@OUTDISPLAY                     	dd	?
_Encontre_actual                	db	"Encontre actual",'$', 15 dup (?)
_NO_encontre_actual             	db	"NO encontre actual",'$', 18 dup (?)
_IF_con_OR_false                	db	"IF con OR false",'$', 15 dup (?)
_IF_con_AND_true                	db	"IF con AND true",'$', 15 dup (?)
_IF_con_AND_false               	db	"IF con AND false",'$', 16 dup (?)
_IF_con_NOT_true                	db	"IF con NOT true",'$', 15 dup (?)
_88                             	dd	88
_99                             	dd	99
_Entra_al_seg_if                	db	"Entra al seg if",'$', 15 dup (?)
_IF_con_NOT_false               	db	"IF con NOT false",'$', 16 dup (?)
_7                              	dd	7
actual2                         	dd	?
_8                              	dd	8
_Iterando_actual                	db	"Iterando actual",'$', 15 dup (?)
_Iterando_actual2               	db	"Iterando actual2",'$', 16 dup (?)
@aux1                           	dd	?
@aux2                           	dd	?
@aux3                           	dd	?
@aux4                           	dd	?
@aux5                           	dd	?
@aux6                           	dd	?
@aux7                           	dd	?
@aux8                           	dd	?
@aux9                           	dd	?
@aux10                          	dd	?
@aux11                          	dd	?

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
fild _3
fst actual
fld _1_5
fst otra
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
JMP else1
JMP startIf1
else1:
displayString _IF_con_OR_false
newLine 1
JMP endif1
startIf1:
displayString _IF_con_OR_true
newLine 1
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
JMP startIf2
else2:
displayString _NO_encontre_actual
newLine 1
JMP endif2
startIf2:
displayString _Encontre_actual
newLine 1
endif2:
endif1:
fild _1
fild _1
fxch
fcom
fstsw ax
sahf
JNE else3
fild _2
fild _2
fxch
fcom
fstsw ax
sahf
JNE else3
fild _3
fild _3
fxch
fcom
fstsw ax
sahf
JNB else3
JMP startIf3
else3:
displayString _IF_con_AND_false
newLine 1
JMP endif3
startIf3:
displayString _IF_con_AND_true
newLine 1
endif3:
fild _4
fild _4
fxch
fcom
fstsw ax
sahf
JBE else4
JMP startIf4
else4:
displayString _IF_con_NOT_false
newLine 1
JMP endif4
startIf4:
displayString _IF_con_NOT_true
newLine 1
fild _99
fild _88
fxch
fcom
fstsw ax
sahf
JNAE endif5
startIf5:
displayString _Entra_al_seg_if
newLine 1
endif5:
endif4:
fild _7
fst actual
fild _3
fst actual2
condicionWhile1:
fild _8
fld actual
fxch
fcom
fstsw ax
sahf
JNA endwhile1
fild _1
fld actual
fxch
fcom
fstsw ax
sahf
JNB endwhile1
startWhile1:
fld actual
fild _1
fsub
fstp @aux10
fld @aux10
fst actual
displayString _Iterando_actual
newLine 1
condicionWhile2:
fild _8
fld actual2
fxch
fcom
fstsw ax
sahf
JNA endwhile2
fild _1
fld actual2
fxch
fcom
fstsw ax
sahf
JNB endwhile2
startWhile2:
fld actual2
fild _1
fsub
fstp @aux11
fld @aux11
fst actual2
displayString _Iterando_actual2
newLine 1
JMP condicionWhile2
endwhile2:
JMP condicionWhile1
endwhile1:

liberar:
	ffree
	mov ax, 4c00h
	int 21h
	jmp fin
fin:
	End START
