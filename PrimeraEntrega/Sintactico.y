%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <conio.h>
    #include "y.tab.h"

    int yystopparser=0;
    FILE  *yyin;

    int yyerror();
    int yylex();
%}

%token DIGITO
%token LETRA_MAY
%token LETRA_MIN
%token LETRA
%token CONST_INTEGER
%token CONST_FLOAT
%token CONST_STRING
%token PUNTO
%token COMA
%token PYC
%token OP_ASIG
%token COMENTARIO
%token COMENTARIO2
%token ID
%token IF
%token ELSE
%token WHILE
%token DECVAR
%token ENDDEC
%token INTEGER
%token FLOAT
%token STRING
%token WRITE
%token READ
%token INLIST
%token SUM
%token RES
%token DIV
%token MULT
%token OP_MENOR_IG
%token OP_MAYOR_IG
%token OP_MAYOR
%token OP_MENOR
%token OP_DIST
%token OP_IGUAL
%token AND
%token OR
%token NOT
%token PAR_A
%token PAR_C
%token LLAVE_A
%token LLAVE_C

%start programaPrima

%%
  programaPrima:
    programa {printf("\n----------------\nCompilacion OK\n----------------\n");}
  ;
  programa:
    programa sentencia {printf("\t{programa sentencia} es programa\n");}|
  ;
  sentencia:
    impresion {printf("\t{sentencia impresion} es sentencia\n");}|
    bloque_declarativo {printf("\t{bloque_declarativo} es sentencia\n");}|
    asignacion {printf("\t{asignacion} es sentencia\n");}
  ;
  bloque_declarativo:
    DECVAR lista_variables OP_ASIG tipo_dato PYC ENDDEC {printf("\t{DECVAR lista_variables OP_ASIG tipo_dato ENDDEC PYC} es bloque_declarativo\n");} 
  ;
  lista_variables:
    termino {printf("\t{ID} es lista_variables\n");}|
    lista_variables COMA termino {printf("\t{lista_variables} COMA ID es lista_variables\n");}
  ;
  tipo_dato:
    STRING  {printf("\t{STRING} es tipo_dato\n");}|  
    FLOAT   {printf("\t{FLOAT} es tipo_dato\n");}|
    INTEGER {printf("\t{INTEGER} es tipo_dato\n");}  
  ;
  asignacion:
    lista_asignacion OP_ASIG expresion PYC {printf("\t{lista_asignacion OP_ASIG expresion PYC} es asignacion\n");};
  ;
  lista_asignacion:
    ID {printf("\t{ID} es lista_asignacion\n");}|
    lista_asignacion OP_ASIG ID {printf("\t {lista_asignacion OP_ASIG ID} es lista_asignacion\n");}
  ;
  impresion:
    WRITE CONST_STRING PYC {printf("\t{WRITE CONST_STRING PYC} es impresion\n");}|
    WRITE expresion PYC {printf("\t{WRITE expresion PYC} es impresion\n");}
  ;
  expresion:
    termino {printf("\t{termino} es expresion\n");}|
    expresion SUM termino {printf("\t{expresion SUM termino} es expresion\n");} |
    expresion RES termino {printf("\t{expresion RES termino} es expresion\n");}
    ;
  termino:
    factor {printf("\t{factor} es termino\n");}
  ;
  factor:
    ID {printf("\t{ID} es factor\n");}|
    CONST_INTEGER {printf("\t{CONST_INTEGER} es factor\n");}
  ;
%%

int main(int argc, char *argv[])
{
    yyin = fopen(argv[1], "rt");

  if(yyin == NULL){
    printf("Error de archivo: %s\n", argv[1]);
    exit(1);
  }else{
    yyparse();
  }

  fclose(yyin);
  return 0;
}

int yyerror()
{
  printf("Error sintactico\n");
  exit(1);
}   