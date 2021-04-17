%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <conio.h>
	
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

CONST_ENTE 		{DIGITO}+
CONST_FLOAT 	{DIGITO}+{PUNTO}{DIGITO}+
CONS_CAD		["].*["]

PUNTO 			"."
COMA 			","
OP_ASIG 		":"

COMENTARIO 		[/][*].*[*][/]
ID 				({LETRA}({LETRA}|{DIGITO}|[_])*({LETRA}|{DIGITO}))|{LETRA} 

IF 				"if"
ELSE 			"else"
WHILE 			"while"
DECVAR 			"DECVAR"
ENDDEC 			"ENDDEC"
INTEGER 		"Integer"
FLOAT 			"Float"
WRITE 			"write"

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

PYC 			";"
PAR_A 			"("
PAR_C 			")"
LLAVE_A 		"{"
LLAVE_C 		"}"

%%
{CONST_FLOAT} 	{printf("%s -> CONST_FLOAT\n", yytext); auxFloat = atof(yytext);if(auxFloat > +3.4E+38 || auxFloat < -3.4E+38){ printf("El numero real supera los limites.\n"); yyerror();}
{CONST_ENTE} 	{printf("%s -> CONST_ENTE\n", yytext); auxInt = atoi(yytext); if(auxInt > 32767 || auxInt < -32768){ printf("El numero entero supera los limites.\n"); yyerror();}
{CONS_CAD} 		{printf("%s -> CONS_CAD\n", yytext); strcpy(auxCad, yytext);if(strlen(auxCad) > 32){ printf("La cadena supera el limite.\n"); yyerror();}}
{COMA} 			{printf("%s -> COMA\n", yytext);}
{COMENTARIO} 	{printf("%s -> COMENTARIO\n", yytext);}
{IF} 			{printf("%s -> IF\n", yytext);}
{ELSE} 			{printf("%s -> ELSE\n", yytext);}
{WHILE} 		{printf("%s -> WHILE\n", yytext);}
{DECVAR} 		{printf("%s -> DECVAR\n", yytext);}
{ENDDEC} 		{printf("%s -> ENDDEC\n", yytext);}
{INTEGER} 		{printf("%s -> INTEGER\n", yytext);}
{FLOAT} 		{printf("%s -> FLOAT\n", yytext);}
{WRITE} 		{printf("%s -> WRITE\n", yytext);}
{SUM} 			{printf("%s -> SUM\n", yytext);}
{RES} 			{printf("%s -> RES\n", yytext);}
{DIV} 			{printf("%s -> DIV\n", yytext);}
{MULT} 			{printf("%s -> MULT\n", yytext);}
{OP_MENOR_IG} 	{printf("%s -> OP_MENOR_IG\n", yytext);}
{OP_MAYOR_IG} 	{printf("%s -> OP_MAYOR_IG\n", yytext);}
{OP_MAYOR} 		{printf("%s -> OP_MAYOR\n", yytext);}
{OP_MENOR} 		{printf("%s -> OP_MENOR\n", yytext);}
{OP_ASIG} 		{printf("%s -> OP_ASIG\n", yytext);}
{OP_DIST} 		{printf("%s -> OP_DIST\n", yytext);}
{OP_IGUAL} 		{printf("%s -> OP_IGUAL\n", yytext);}
{PYC} 			{printf("%s -> PYC\n", yytext);}
{PAR_A} 		{printf("%s -> PAR_A\n", yytext);}
{PAR_C} 		{printf("%s -> PAR_C\n", yytext);}
{LLAVE_A} 		{printf("%s -> LLAVE_A\n", yytext);}
{LLAVE_C} 		{printf("%s -> LLAVE_C\n", yytext);}
{ID} 			{printf("%s -> ID\n", yytext); strcpy(auxId, yytext);if(strlen(auxId) > 16){ printf("La variable %s es demasiado larga.\n", yytext); yyerror();}

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
    printf("Token no reconocido: %s\n", yytext);
    exit(1);
}