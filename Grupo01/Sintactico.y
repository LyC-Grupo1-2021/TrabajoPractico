%{
    #include <stdio.h>
    #include <stdlib.h>
    //Usuarios de linux usar "curses.h", usuarios de windows usar "conio.h"
    //#include <conio.h>
    #include <curses.h>
    #include "y.tab.h"

    #include "tabla_simbolos.h"
	  #include "constantes_propias.h"
    #include "arbol_sintactico/arbol_sintactico.h"

    int yystopparser=0;
    int yylineno;    
    FILE  *yyin;
    char * yytext;

    int yyerror(const char *);
    int yylex();

    //Declaración de punteros árbol sintáctico
    nodo* mainPtr = NULL;
    nodo* programaPtr = NULL;
    nodo* sentenciaPtr = NULL;
    nodo* ifPtr = NULL;
    nodo* whilePtr = NULL;
    nodo* condicion_simplePtr = NULL;
    nodo* condicionPtr = NULL;
    nodo* operador_logPtr = NULL;
    nodo* operador_compPtr = NULL;
    nodo* en_listaPtr = NULL;
    nodo* lista_expresionesPtr = NULL;
    nodo* bloque_declarativoPtr = NULL;
    nodo* multiple_declaracionesPtr = NULL;
    nodo* sentencia_declarativaPtr = NULL;
    nodo* lista_variablesPtr = NULL;
    nodo* tipo_datoPtr = NULL;
    nodo* lista_asignacionPtr = NULL;
    nodo* asignacionPtr = NULL;
    nodo* lecturaPtr = NULL;
    nodo* impresionPtr = NULL;
    nodo* expresionPtr = NULL;
    nodo* terminoPtr = NULL;
    nodo* factorPtr = NULL;
%}

%union {
    int intval;
    float val;
    char *str_val;
}

%token DIGITO
%token LETRA_MAY
%token LETRA_MIN
%token LETRA
%token <str_val> CONST_INTEGER
%token <str_val> CONST_FLOAT
%token <str_val> CONST_STRING
%token PUNTO
%token COMA
%token PYC
%token OP_ASIG
%token COMENTARIO
%token COMENTARIO2
%token <str_val> ID
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
%token COR_A
%token COR_C

%start programaPrima

%%
  programaPrima:
    main {
      printf("\n----------------\nCompilacion OK\n----------------\n");
      crearArchivo();
    }
  ;
  main:
    bloque_declarativo programa {printf("\t{bloque_declarativo programa} es main\n");}
  ;
  
  bloque_declarativo:
    DECVAR multiple_declaraciones ENDDEC {
      printf("\t{DECVAR lista_variables OP_ASIG tipo_dato ENDDEC PYC} es bloque_declarativo\n");
    } 
  ;
  multiple_declaraciones:
    sentencia_declarativa {printf("\t{sentencia_declarativa} es multiple_declaraciones\n");}|
    multiple_declaraciones sentencia_declarativa {printf("\t{multiple_declaraciones sentencia_declarativa} es multiple_declaraciones\n");}
  ;
  sentencia_declarativa:
    lista_variables OP_ASIG tipo_dato PYC {printf("\t{lista_variables} es sentencia_declarativa\n");}
  ;
  lista_variables:
    ID {printf("\t lista_variables es {ID}\n");}|
    lista_variables COMA ID {printf("\t{lista_variables COMA ID} es lista_variables\n");}
  ;
  tipo_dato:
    STRING  {printf("\t{STRING} es tipo_dato\n");}|  
    FLOAT   {printf("\t{FLOAT} es tipo_dato\n");}|
    INTEGER {printf("\t{INTEGER} es tipo_dato\n");}  
  ;
  programa:
    sentencia  {printf("\t{sentencia} es programa\n");}|
    programa sentencia {printf("\t{programa sentencia} es programa\n");}
  ;
  sentencia:
    impresion {printf("\t{sentencia impresion} es sentencia\n");}|
    lectura {printf("\t{lectura} es sentencia\n");}|
    lista_asignacion {printf("\t{lista_asignacion} es sentencia\n");}|
    en_lista {printf("\t{en_lista} es sentencia\n");}|
    while {printf("\t{while} es sentencia\n");}|
    if  {printf("\t{if} es sentencia\n");}
  ;
  if:
    IF PAR_A condicion PAR_C LLAVE_A programa LLAVE_C {printf("\t{IF PAR_A condicion PAR_C LLAVE_A programa LLAVE_C ELSE LLAVE_A programa LLAVE_C} es if\n");}|
    IF PAR_A condicion PAR_C LLAVE_A programa LLAVE_C ELSE LLAVE_A programa LLAVE_C {printf("\t{IF PAR_A condicion PAR_C LLAVE_A programa LLAVE_C ELSE LLAVE_A programa LLAVE_C} es if\n");}
  ;
  while:
    WHILE PAR_A condicion PAR_C LLAVE_A programa LLAVE_C {printf("\t{ WHILE PAR_A condicion PAR_C LLAVE_A programa LLAVE_C}, es while\n");}
  ;
  condicion_simple:
    factor operador_comp factor {printf("\t {factor operador_comp factor} es condicion\n");}
  ;
  condicion:
    condicion_simple {printf("\t {condicion_simple} es condicion\n");}|
    NOT PAR_A condicion_simple PAR_C {printf("\t {NOT PAR_A condicion PAR_C} es condicion\n");}|
    condicion_simple operador_log condicion_simple {printf("\t {condicion operador_log condicion} es condicion\n");}
  ;
  operador_log:
    AND {printf("\t {AND} operador_log");}|
    OR {printf("\t {OR} es operador_log\n");}
  ;
  operador_comp:
    OP_MENOR {
      printf("\t {OP_MENOR} es operador\n");
      operador_compPtr = crearHoja("<");
    }|
    OP_MAYOR {
      printf("\t {OP_MAYOR} es operador\n");
      operador_compPtr = crearHoja(">");
    }|
    OP_MENOR_IG {
      printf("\t {OP_MENOR_IG} es operador\n");
      operador_compPtr = crearHoja("<=");
    }|
    OP_MAYOR_IG {
      printf("\t {OP_MAYOR_IG} es operador\n");
      operador_compPtr = crearHoja(">=");
    }|
    OP_DIST {
      printf("\t {OP_DIST} es operador\n");
      operador_compPtr = crearHoja("!=");
    }|
    OP_IGUAL {
      printf("\t {OP_IGUAL} es operador\n");
      operador_compPtr = crearHoja("==");
    }
  ;
  en_lista:
    INLIST PAR_A ID PYC COR_A lista_expresiones COR_C PAR_C PYC {printf("\t{INLIST PAR_A ID PYC COR_A lista_expresiones COR_C PAR_C PYC} es en_lista\n");}
  ;
  lista_expresiones:
    expresion {printf("\t{expresion} es lista_expresiones\n");}|
    lista_expresiones PYC expresion {printf("\t{lista_expresiones PYC expresion} es lista_expresiones\n");}
  ; 
  lista_asignacion:
    asignacion OP_ASIG expresion PYC {
      printf("\t{asignacion OP_ASIG expresion PYC} es lista_asignacion\n");
      lista_asignacionPtr = crearNodo(":", asignacionPtr, expresionPtr);
      escribirGragh(lista_asignacionPtr);
    };
  ;
  asignacion:
    asignacion OP_ASIG ID {
      printf("\t {asignacion OP_ASIG ID} es asignacion\n");
      asignacionPtr = crearNodo(":", asignacionPtr, crearHoja(yytext));
    }|
    ID {printf("\t{ID} es asignacion\n");}
  ;

  lectura:
    READ CONST_STRING PYC {printf("\t{READ CONST_STRING PYC} es lectura\n");}|
    READ expresion PYC {printf("\t{READ expresion PYC} es lectura\n");}
  ;
  impresion:
    WRITE CONST_STRING PYC {printf("\t{WRITE CONST_STRING PYC} es impresion\n");}|
    WRITE expresion PYC {printf("\t{WRITE expresion PYC} es impresion\n");}
  ;
  expresion:
    expresion SUM termino {
      printf("\t{expresion SUM termino} es expresion\n");
      expresionPtr = crearNodo("+", expresionPtr, terminoPtr);
    }|
    expresion RES termino {
      printf("\t{expresion RES termino} es expresion\n");
      expresionPtr = crearNodo("-", expresionPtr, terminoPtr);
    }|
    termino {
      printf("\t{termino} es expresion\n");
      expresionPtr = terminoPtr;
    };
  termino:
    termino MULT factor {
      printf("\t{termino MULT factor} es termino\n");
      terminoPtr = crearNodo("*", terminoPtr, factorPtr);
    }|
    termino DIV factor {
      printf("\t{termino DIV factor} es termino\n");
      terminoPtr = crearNodo("/", terminoPtr, factorPtr);
    }|
    factor {
      printf("\t{factor} es termino\n");
      terminoPtr = factorPtr;
    }
  ;
  factor:
    PAR_A expresion PAR_C {
      printf("\t{PAR_A expresion PAR_C} es factor\n");
      factorPtr = expresionPtr;
    }|
    ID {
      printf("\t{ID} es factor\n");
      factorPtr = crearHoja(yytext);
    }|
    CONST_INTEGER {
      printf("\t{CONST_INTEGER} es factor\n");
      factorPtr = crearHoja(yytext);
    }|
    CONST_FLOAT { 
      printf("\t{CONST_FLOAT} es factor\n");      
      factorPtr = crearHoja(yytext);
    }
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

int yyerror(const char *s)
{
  printf("Error de sintáxis\n");
  printf("Nro. de linea: %d \t %s\n", yylineno, s);
  exit(1);
}   