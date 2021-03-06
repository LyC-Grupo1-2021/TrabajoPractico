%{
    #include <stdio.h>
    #include <stdlib.h>
    //Usuarios de linux usar "curses.h", usuarios de windows usar "conio.h"
    #include <conio.h>
    //#include <curses.h>
    #include <string.h> 
    #include "y.tab.h"
	
    #include "tabla_simbolos.h"
	#include "constantes_propias.h"
    #include "arbol_sintactico/arbol_sintactico.h"

    FILE *yyin;
    int yyerror();

    void procesarFloat();
    void procesarInt();
    void procesarString();
    void procesarId();

%}

%option noyywrap
%option yylineno

DIGITO 			[0-9]
LETRA_MAY 		[A-Z]
LETRA_MIN 		[a-z]
LETRA 			{LETRA_MAY}|{LETRA_MIN}
CARACTER        [a-z,A-Z,0-9,=,>,<,!,:,+,".",\-,*,/,?,_,","]

CONST_INTEGER 	[-]?{DIGITO}+
CONST_FLOAT 	[-]?{DIGITO}+{PUNTO}{DIGITO}+|[-]?{DIGITO}+{PUNTO}|[-]?{PUNTO}{DIGITO}+
CONST_STRING	["]({CARACTER}|" ")*["]

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
{COMENTARIO2} 	{printf("%s -> COMENTARIO2\n", yytext);}
{COMENTARIO} 	{printf("%s -> COMENTARIO\n", yytext);}
{CONST_FLOAT} 	{procesarFloat(); return CONST_FLOAT;}
{CONST_INTEGER} {procesarInt(); return CONST_INTEGER;}
{CONST_STRING} 	{procesarString(); return CONST_STRING;}
{COMA} 			{printf("%s -> COMA\n", yytext); return COMA;}
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
{ID} 			{procesarId(); return ID;}

"\t"
"\n"
"\n\t"
"\r\n"
" "

. yyerror("Error de léxico");
%%


void procesarFloat() {
    float num  = atof(yytext);
    yylval.str_val = strdup(yytext);
    char nombre[50];
    strcpy(nombre, strdup(yytext));

    char* ptrPunto = strchr(nombre, '.');
    if (ptrPunto != NULL) {
        *ptrPunto = '_';
    }

    if(num > +3.4E+30 || num < -3.4E+38){
        printf("El numero real supera los limites.\n");
        exit(-1);
    }

    printf("%s -> CONST_FLOAT\n", yytext);
    grabarToken(TOKEN_CTE_FLOAT, "FLOAT", castConst(nombre), yytext, 0);

}

void procesarInt() {
    int num = atoi(yytext);
    yylval.str_val = strdup(yytext);
	if (num > LIM_INT_POS || num < LIM_INT_NEG) {
		printf("El numero entero no debe ser superior a %d ni inferior a -%d.\n", LIM_INT_POS, LIM_INT_NEG);
		exit(-1);
	}

    printf("%s -> CONST_INTEGER\n", yytext);
	grabarToken(TOKEN_CTE_INTEGER, "INTEGER", castConst(strdup(yytext)), yytext, 0);
}

void procesarString(){
   int longitud = strlen(yytext)-2;
    char* auxCad = (char *) malloc(longitud + 1);
    strncpy(auxCad, yytext+1, longitud);
    auxCad[longitud] = '\0';

    // Reemplaza cada caracter invalido por un guion bajo
    int idx = 0;
    char caracteresRaros[] = {';', ' ', ':', '=', ',', '(', ')', '[', ']', '.', '+'};
    char *ptrCaracter;
    for(idx = 0; idx < strlen(caracteresRaros); idx++) {
        ptrCaracter = strchr(auxCad, caracteresRaros[idx]);
        while (ptrCaracter != NULL) {
            *ptrCaracter = '_';
            ptrCaracter = strchr(auxCad, caracteresRaros[idx]);
        }
    }
    yylval.str_val = strdup(auxCad);
    yytext[strlen(yytext)-1] = '\0';
	strcpy(auxCad, yytext + 1); 
    if (strlen(auxCad) > MAXLENSTR) {
        printf("El largo maximo de la cadena es: %d caracteres\n", yytext);
        exit(-1);
    }
    printf("%s -> CONST_STRING\n", yytext);
    grabarToken(TOKEN_CTE_STRING, "STRING", castConst(yylval.str_val), strdup(auxCad), strlen(auxCad));
}

void procesarId() {
	char auxId[100];
    strcpy(auxId, yytext);
    yylval.str_val = strdup(yytext);

    if(strlen(auxId) > MAXLENID) { 
        printf("La variable %s no debe superar los %d caracteres.\n", yytext, MAXLENID);
        exit(-1);
    }
    printf("%s -> ID\n", yytext);
	grabarToken(TOKEN_ID, "", strdup(yytext), "", strlen(yytext));
}