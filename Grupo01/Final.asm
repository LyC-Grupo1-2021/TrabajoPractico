INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE
.386
.STACK 200h
	.DATA
	MAXTEXTSIZE equ 200
actual                          	dd	?
actual2                         	dd	?
a1                              	dd	?
a2                              	dd	?
a3                              	dd	?
a4                              	dd	?
a5                              	dd	?
a6                              	dd	?
b1                              	dd	?
c1                              	dd	?
d1                              	dd	?
d2                              	dd	?
d3                              	dd	?
d4                              	dd	?
otra                            	dd	?
_1                              	dd	1
_2                              	dd	2
_3                              	dd	3
_1_5                            	dd	1.5
_Ingrese_un_valor_a_D4_que_se   	db	"Ingrese un valor a D4 que se",'$', 28 dup (?)
@OUTDISPLAY                     	dd	?
_usara_en_AsigMult              	db	"usara en AsigMult",'$', 17 dup (?)
@STDIN                          	dd	?
_5                              	dd	5
_AsigMult_d1_d2_d3_d4           	db	"AsigMult d1:d2:d3+d4",'$', 20 dup (?)
_Valor_de_D1_luego_de_AsigMult  	db	"Valor de D1 luego de AsigMult",'$', 29 dup (?)
_Valor_de_D2_luego_de_AsigMult  	db	"Valor de D2 luego de AsigMult",'$', 29 dup (?)
_IF_simple                      	db	"IF simple",'$', 9 dup (?)
_Se_encontro_actual_en_INLIST   	db	"Se encontro actual en INLIST",'$', 28 dup (?)
_4                              	dd	4
_NO_encontro_actual_en_INLIST   	db	"NO encontro actual en INLIST",'$', 28 dup (?)
_9                              	dd	9
_IF_con_OR_que_da_true          	db	"IF con OR que da true",'$', 21 dup (?)
_NO_enc_ntr__actual_en_INLIST   	db	"NO encontro actual en INLIST",'$', 28 dup (?)
_IF_con_OR_que_da_false         	db	"IF con OR que da false",'$', 22 dup (?)
_IF_con_A_D_que_da_true         	db	"IF con AND que da true",'$', 22 dup (?)
_IF_con_A_D_que_da_false        	db	"IF con AND que da false",'$', 23 dup (?)
_IF_con_NOT_que_da_true         	db	"IF con NOT que da true",'$', 22 dup (?)
_88                             	dd	88
_99                             	dd	99
_Entra_al_seg_if                	db	"Entra al seg if",'$', 15 dup (?)
_IF_con__OT_que_da_false        	db	"IF con NOT que da false",'$', 23 dup (?)
_Iteracion_dentro_de_un_if      	db	"Iteracion dentro de un if",'$', 25 dup (?)
_8                              	dd	8
_Itera_actual_en_primer_while   	db	"Itera actual en primer while",'$', 28 dup (?)
_I_era_ac_ual2_en_segundo_while 	db	"Itera actual2 en segundo while",'$', 30 dup (?)
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
@aux12                          	dd	?
@aux13                          	dd	?
@aux14                          	dd	?
@aux15                          	dd	?
@aux16                          	dd	?
@aux17                          	dd	?
@aux18                          	dd	?
@aux19                          	dd	?
@aux20                          	dd	?
@aux21                          	dd	?

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
displayString _Ingrese_un_valor_a_D4_que_se
newLine 1
displayString _usara_en_AsigMult
newLine 1
GetFloat d4
fild _3
fild _5
fadd
fstp @aux5
fld @aux5
fild _3
fmul
fstp @aux6
fld @aux6
fst d3
fld d3
fld d4
fadd
fstp @aux7
fld @aux7
fst d2
fst d1
displayString _AsigMult_d1_d2_d3_d4
newLine 1
displayString _Valor_de_D1_luego_de_AsigMult
newLine 1
DisplayFloat d1,2
newLine 1
displayString _Valor_de_D2_luego_de_AsigMult
newLine 1
DisplayFloat d2,2
newLine 1
fild _1
fild _1
fxch
fcom
fstsw ax
sahf
JNE endif1
startIf1:
displayString _IF_simple
newLine 1
endif1:
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
JMP endif2
startIf2:
displayString _Se_encontro_actual_en_INLIST
newLine 1
endif2:
fild _4
fild _5
fmul
fstp @aux8
fild _3
fld @aux8
fadd
fstp @aux9
fld @aux9
fst c1
fild _2
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf3
fild _1
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf3
fld otra
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf3
fild _4
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf3
JMP else3
JMP startIf3
else3:
displayString _NO_encontro_actual_en_INLIST
newLine 1
JMP endif3
startIf3:
displayString _Se_encontro_actual_en_INLIST
newLine 1
endif3:
fild _4
fild _5
fmul
fstp @aux10
fild _3
fld @aux10
fadd
fstp @aux11
fld @aux11
fst c1
fild _2
fild _2
fxch
fcom
fstsw ax
sahf
JA startIf4
fld a2
fld a1
fxch
fcom
fstsw ax
sahf
JBE startIf4
fild _9
fld a1
fxch
fcom
fstsw ax
sahf
JA startIf4
fild _5
fild _4
fadd
fstp @aux12
fld @aux12
fld a1
fxch
fcom
fstsw ax
sahf
JBE startIf4
JMP else4
JMP startIf4
else4:
displayString _IF_con_OR_que_da_false
newLine 1
JMP endif4
startIf4:
displayString _IF_con_OR_que_da_true
newLine 1
fild _2
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf5
fild _1
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf5
fld otra
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf5
fild _3
fld actual
fxch
fcom
fstsw ax
sahf
JE startIf5
JMP else5
JMP startIf5
else5:
displayString _NO_enc_ntr__actual_en_INLIST
newLine 1
JMP endif5
startIf5:
displayString _Se_encontro_actual_en_INLIST
newLine 1
endif5:
endif4:
fild _4
fild _5
fmul
fstp @aux13
fild _3
fld @aux13
fadd
fstp @aux14
fld @aux14
fst c1
fild _1
fild _1
fxch
fcom
fstsw ax
sahf
JNE else6
fild _2
fild _2
fxch
fcom
fstsw ax
sahf
JNE else6
fild _3
fild _3
fxch
fcom
fstsw ax
sahf
JNB else6
JMP startIf6
else6:
displayString _IF_con_A_D_que_da_false
newLine 1
JMP endif6
startIf6:
displayString _IF_con_A_D_que_da_true
newLine 1
endif6:
fild _4
fild _5
fmul
fstp @aux15
fild _3
fld @aux15
fadd
fstp @aux16
fld @aux16
fst c1
fild _4
fild _4
fxch
fcom
fstsw ax
sahf
JBE else7
JMP startIf7
else7:
displayString _IF_con__OT_que_da_false
newLine 1
JMP endif7
startIf7:
displayString _IF_con_NOT_que_da_true
newLine 1
fild _99
fild _88
fxch
fcom
fstsw ax
sahf
JNAE endif8
startIf8:
displayString _Entra_al_seg_if
newLine 1
endif8:
endif7:
fild _1
fst b1
fild _1
fld b1
fxch
fcom
fstsw ax
sahf
JNE endif9
startIf9:
condicionWhile1:
fild _3
fld b1
fxch
fcom
fstsw ax
sahf
JNA endwhile1
startWhile1:
displayString _Iteracion_dentro_de_un_if
newLine 1
fld b1
fild _1
fadd
fstp @aux17
fld @aux17
fst b1
JMP condicionWhile1
endwhile1:
endif9:
fild _4
fst actual
fild _3
fst actual2
fild _4
fild _5
fmul
fstp @aux18
fild _3
fld @aux18
fadd
fstp @aux19
fld @aux19
fst c1
condicionWhile2:
fild _8
fld actual
fxch
fcom
fstsw ax
sahf
JNA endwhile2
fild _1
fld actual
fxch
fcom
fstsw ax
sahf
JNB endwhile2
startWhile2:
fld actual
fild _1
fsub
fstp @aux20
fld @aux20
fst actual
displayString _Itera_actual_en_primer_while
newLine 1
condicionWhile3:
fild _8
fld actual2
fxch
fcom
fstsw ax
sahf
JNA endwhile3
fild _1
fld actual2
fxch
fcom
fstsw ax
sahf
JNB endwhile3
startWhile3:
fld actual2
fild _1
fsub
fstp @aux21
fld @aux21
fst actual2
displayString _I_era_ac_ual2_en_segundo_while
newLine 1
JMP condicionWhile3
endwhile3:
JMP condicionWhile2
endwhile2:

liberar:
	ffree
	mov ax, 4c00h
	int 21h
	jmp fin
fin:
	End START
