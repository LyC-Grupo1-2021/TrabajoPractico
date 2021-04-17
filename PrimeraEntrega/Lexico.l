%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <conio.h>
    #include <string.h>
	
	#define MAXLENID 16
	#define MAXLENSTR 32
	
	float auxFloat;
	int auxInt;
	char auxCad[100];
	char auxId[100];
	
    FILE *yyin;
    int yylvan;
    int yyerror(void);
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

%%
{CONST_FLOAT} 	{printf("%s -> CONST_FLOAT\n", yytext); auxFloat = atof(yytext);if(auxFloat > +3.4E+30 || auxFloat < -3.4E+38){ printf("El numero real supera los limites.\n"); yyerror();}}
{CONST_INTEGER} {printf("%s -> CONST_INTEGER\n", yytext); auxInt = atoi(yytext); if(auxInt > 32767 || auxInt < -32768){ printf("El numero entero no debe ser superior a 32767 ni inferior a -32768.\n"); yyerror();}}
{CONST_STRING} 	{printf("%s -> CONST_STRING\n", yytext); strcpy(auxCad, yytext);if(strlen(auxCad) > MAXLENSTR){ printf("El largo maximo de la cadena es %d\n", MAXLENSTR); yyerror();}}
{COMA} 			{printf("%s -> COMA\n", yytext);}
{COMENTARIO2} 	{printf("%s -> COMENTARIO2\n", yytext);}
{COMENTARIO} 	{printf("%s -> COMENTARIO\n", yytext);}
{IF} 			{printf("%s -> IF\n", yytext);}
{ELSE} 			{printf("%s -> ELSE\n", yytext);}
{WHILE} 		{printf("%s -> WHILE\n", yytext);}
{DECVAR} 		{printf("%s -> DECVAR\n", yytext);}
{ENDDEC} 		{printf("%s -> ENDDEC\n", yytext);}
{INTEGER} 		{printf("%s -> INTEGER\n", yytext);}
{FLOAT} 		{printf("%s -> FLOAT\n", yytext);}
{STRING} 		{printf("%s -> STRING\n", yytext);}
{WRITE} 		{printf("%s -> WRITE\n", yytext);}
{READ} 			{printf("%s -> READ\n", yytext);}
{SUM} 			{printf("%s -> SUM\n", yytext);}
{RES} 			{printf("%s -> RES\n", yytext);}
{DIV} 			{printf("%s -> DIV\n", yytext);}
{MULT} 			{printf("%s -> MULT\n", yytext);}
{OP_MAYOR} 		{printf("%s -> OP_MAYOR\n", yytext);}
{OP_MAYOR_IG} 	{printf("%s -> OP_MAYOR_IG\n", yytext);}
{OP_MENOR} 		{printf("%s -> OP_MENOR\n", yytext);}
{OP_MENOR_IG} 	{printf("%s -> OP_MENOR_IG\n", yytext);}
{OP_ASIG} 		{printf("%s -> OP_ASIG\n", yytext);}
{OP_DIST} 		{printf("%s -> OP_DIST\n", yytext);}
{OP_IGUAL} 		{printf("%s -> OP_IGUAL\n", yytext);}
{AND} 			{printf("%s -> AND\n", yytext);}
{OR} 			{printf("%s -> OR\n", yytext);}
{NOT} 			{printf("%s -> NOT\n", yytext);}
{PYC} 			{printf("%s -> PYC\n", yytext);}
{PAR_A} 		{printf("%s -> PAR_A\n", yytext);}
{PAR_C} 		{printf("%s -> PAR_C\n", yytext);}
{LLAVE_A} 		{printf("%s -> LLAVE_A\n", yytext);}
{LLAVE_C} 		{printf("%s -> LLAVE_C\n", yytext);}
{ID} 			{printf("%s -> ID\n", yytext); strcpy(auxId, yytext);if(strlen(auxId) > MAXLENID){ printf("La variable %s no debe superar los %d caracteres.\n", yytext, MAXLENID); yyerror();}}

"\t"
"\n"
"\n\t"
"\r\n"
" "
.  yyerror();
%%

int main(int argc, char* argv[])
{
    if((yyin = fopen(argv[1], "rt")) == NULL){
        printf("\nNo se logro abrir el archivo: %s\n", argv[1]);
        return 1;
    }
    yylex();
    fclose(yyin);
}

int yyerror(void){
    printf("Token no reconocido: %s en linea %d\n", yytext, yylineno);
    exit(1);
}