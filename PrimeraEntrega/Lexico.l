%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <conio.h>
    #include <string.h>
    #include "y.tab.h"
	
	#define MAXLENID 16
	#define MAXLENSTR 32
	
	float auxFloat;
	int auxInt;
	char auxCad[100];
	char auxId[100];
	
    FILE *yyin;
    int yylvan;
    int yyerror();
%}

%option noyywrap
%option yylineno

DIGITO 			[0-9]
LETRA_MAY 		[A-Z]
LETRA_MIN 		[a-z]
LETRA 			{LETRA_MAY}|{LETRA_MIN}

CONST_INTEGER 	{DIGITO}+
CONST_FLOAT 	{DIGITO}+{PUNTO}{DIGITO}+|{DIGITO}+{PUNTO}|{PUNTO}{DIGITO}+
CONST_STRING	["].*["]

PUNTO 			"."
COMA 			","
PYC 			";"
OP_ASIG 		":"

COMENTARIO 		[-][/].*[/][-]
COMENTARIO2 	[-][/].*{COMENTARIO}.*[/][-]

ID 				({LETRA}({LETRA}|{DIGITO}|[_])*({LETRA}|{DIGITO}))|{LETRA} 

IF 				"if"
ELSE 			"else"
WHILE 			"while"
DECVAR 			"DECVAR"
ENDDEC 			"ENDDEC"
INTEGER 		"Integer"
FLOAT 			"Float"
STRING			"String"
WRITE 			"write"
READ 			"read"
INLIST          "INLIST"

SUM 			"+"
RES 			"-"
DIV 			"/"
MULT 			"*"

OP_MENOR_IG 	"<="
OP_MAYOR_IG 	">="
OP_MAYOR 		">"
OP_MENOR 		"<"
OP_DIST 		"!="
OP_IGUAL 		"=="

AND         	"and"
OR         		"or"
NOT       		"not"

PAR_A 			"("
PAR_C 			")"
LLAVE_A 		"{"
LLAVE_C 		"}"
COR_A           "["
COR_C           "]"

%%
{CONST_FLOAT} 	{printf("%s -> CONST_FLOAT\n", yytext); auxFloat = atof(yytext);if(auxFloat > +3.4E+30 || auxFloat < -3.4E+38){ printf("El numero real supera los limites.\n"); yyerror();} return CONST_FLOAT;}
{CONST_INTEGER} {printf("%s -> CONST_INTEGER\n", yytext); auxInt = atoi(yytext); if(auxInt > 32767 || auxInt < -32768){ printf("El numero entero no debe ser superior a 32767 ni inferior a -32768.\n"); yyerror();} return CONST_INTEGER;}
{CONST_STRING} 	{printf("%s -> CONST_STRING\n", yytext); strcpy(auxCad, yytext);if(strlen(auxCad) > MAXLENSTR){ printf("El largo maximo de la cadena es %d\n", MAXLENSTR); yyerror();} return CONST_STRING;}
{COMA} 			{printf("%s -> COMA\n", yytext); return COMA;}
{COMENTARIO2} 	{printf("%s -> COMENTARIO2\n", yytext); return COMENTARIO2;}
{COMENTARIO} 	{printf("%s -> COMENTARIO\n", yytext); return COMENTARIO;}
{IF} 			{printf("%s -> IF\n", yytext); return IF;}
{ELSE} 			{printf("%s -> ELSE\n", yytext); return ELSE;}
{WHILE} 		{printf("%s -> WHILE\n", yytext); return WHILE;}
{DECVAR} 		{printf("%s -> DECVAR\n", yytext); return DECVAR;}
{ENDDEC} 		{printf("%s -> ENDDEC\n", yytext); return ENDDEC;}
{INTEGER} 		{printf("%s -> INTEGER\n", yytext); return INTEGER;}
{FLOAT} 		{printf("%s -> FLOAT\n", yytext); return FLOAT;}
{STRING} 		{printf("%s -> STRING\n", yytext); return STRING;}
{WRITE} 		{printf("%s -> WRITE\n", yytext); return WRITE;}
{READ} 			{printf("%s -> READ\n", yytext); return READ;}
{INLIST}        {printf("%s -> INLIST\n", yytext); return INLIST;}
{SUM} 			{printf("%s -> SUM\n", yytext); return SUM;}
{RES} 			{printf("%s -> RES\n", yytext); return RES;}
{DIV} 			{printf("%s -> DIV\n", yytext); return DIV;}
{MULT} 			{printf("%s -> MULT\n", yytext); return MULT;}
{OP_MAYOR} 		{printf("%s -> OP_MAYOR\n", yytext); return OP_MAYOR;}
{OP_MAYOR_IG} 	{printf("%s -> OP_MAYOR_IG\n", yytext); return OP_MAYOR_IG;}
{OP_MENOR} 		{printf("%s -> OP_MENOR\n", yytext); return OP_MENOR;}
{OP_MENOR_IG} 	{printf("%s -> OP_MENOR_IG\n", yytext); return OP_MENOR_IG;}
{OP_ASIG} 		{printf("%s -> OP_ASIG\n", yytext); return OP_ASIG;}
{OP_DIST} 		{printf("%s -> OP_DIST\n", yytext); return OP_DIST;}
{OP_IGUAL} 		{printf("%s -> OP_IGUAL\n", yytext); return OP_IGUAL;}
{AND} 			{printf("%s -> AND\n", yytext); return AND;}
{OR} 			{printf("%s -> OR\n", yytext); return OR;}
{NOT} 			{printf("%s -> NOT\n", yytext); return NOT;}
{PYC} 			{printf("%s -> PYC\n", yytext); return PYC;}
{PAR_A} 		{printf("%s -> PAR_A\n", yytext); return PAR_A;}
{PAR_C} 		{printf("%s -> PAR_C\n", yytext); return PAR_C;}
{COR_A}         {printf("%s -> COR_A\n", yytext); return COR_A;}
{COR_C}         {printf("%s -> COR_C\n", yytext); return COR_C;}
{LLAVE_A} 		{printf("%s -> LLAVE_A\n", yytext); return LLAVE_A;}
{LLAVE_C} 		{printf("%s -> LLAVE_C\n", yytext); return LLAVE_C;}
{ID} 			{printf("%s -> ID\n", yytext); strcpy(auxId, yytext);if(strlen(auxId) > MAXLENID){ printf("La variable %s no debe superar los %d caracteres.\n", yytext, MAXLENID); yyerror();} return ID;}

"\t"
"\n"
"\n\t"
"\r\n"
" "
.  yyerror();
%%
