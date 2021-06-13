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
    void agregarVariable();
    void actualizarTipoDeclaracionID(char *);
    
    nodo* apilar(nodo*);
    nodo* desapilar();

    //Declaración de punteros árbol sintáctico
    nodo* programaPtr = NULL;
    nodo* sentenciaPtr = NULL;
    nodo* ifPtr = NULL;
    nodo* ifBodyPtr = NULL;
    nodo* whilePtr = NULL;
    nodo* condicion_simplePtr = NULL;
    nodo* condicion_simple2Ptr = NULL;
    nodo* condicionPtr = NULL;
    nodo* operador_logPtr = NULL;
    nodo* operador_compPtr = NULL;
    nodo* en_listaPtr = NULL;
    nodo* lista_expresionesPtr = NULL;
    nodo* lista_expresionesAntPtr = NULL;
    nodo* lista_asignacionPtr = NULL;
    nodo* asignacionPtr = NULL;
    nodo* lecturaPtr = NULL;
    nodo* impresionPtr = NULL;
    nodo* terminoPtr = NULL;
    nodo* factorPtr = NULL;
    nodo* ptrIdList = NULL;

    t_pila pila = NULL;

    char * idsAsignacionTipo[100]; //Array usado para asociar los tipos a los id (sirve para tabla simbolos)
    int indexAsignacionTipo = 0; //Index array 
%}

%union {
    int intval;
    float val;
    char *str_val;
}

%token <str_val> ID
%token <str_val> CONST_INTEGER
%token <str_val> CONST_FLOAT
%token <str_val> CONST_STRING

%token DIGITO
%token LETRA_MAY
%token LETRA_MIN
%token LETRA
%token PUNTO
%token COMA
%token PYC
%token OP_ASIG
%token COMENTARIO
%token COMENTARIO2
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
%token <str_val> AND
%token <str_val> OR
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
    bloque_declarativo programa {
      printf("\t{bloque_declarativo programa} es main\n");
      escribirGragh(programaPtr);
    }
  ;
  
  bloque_declarativo:
    DECVAR multiple_declaraciones ENDDEC {
      printf("\t{DECVAR multiple_declaraciones ENDDEC} es bloque_declarativo\n");
    } 
  ;
  multiple_declaraciones:
    sentencia_declarativa {printf("\t{sentencia_declarativa} es multiple_declaraciones\n");}|
    multiple_declaraciones sentencia_declarativa {printf("\t{multiple_declaraciones sentencia_declarativa} es multiple_declaraciones\n");}
  ;
  sentencia_declarativa:
    lista_variables OP_ASIG STRING PYC {
      printf("\t{lista_variables OP_ASIG STRING PYC}\n");
      actualizarTipoDeclaracionID("STRING");
    }|
    lista_variables OP_ASIG FLOAT PYC {
      printf("\t{lista_variables OP_ASIG FLOAT PYC}\n");
      actualizarTipoDeclaracionID("FLOAT");
    }|
    lista_variables OP_ASIG INTEGER PYC {
      printf("\t{lista_variables OP_ASIG INTEGER PYC}\n");
      actualizarTipoDeclaracionID("INTEGER");
    }
  ;
  lista_variables:
    ID {
      printf("\t lista_variables es {ID}\n");
      agregarVariable();
    }|
    lista_variables COMA ID {
      printf("\t{lista_variables COMA ID} es lista_variables\n");
      agregarVariable();
    }
  ;
  programa:
    sentencia  {
      printf("\t{sentencia} es programa\n");
      programaPtr = sentenciaPtr;
      apilar(sentenciaPtr);
    }|
    programa sentencia {
      printf("\t{programa sentencia} es programa\n");
      programaPtr = crearNodo("programa", desapilar(), sentenciaPtr);
      apilar(programaPtr);
    }
    
  ;
  sentencia:
    impresion {
      printf("\t{sentencia impresion} es sentencia\n");
      sentenciaPtr = impresionPtr;
    }|
    lectura {
      printf("\t{lectura} es sentencia\n");
      sentenciaPtr = lecturaPtr;
    }|
    lista_asignacion {
      printf("\t{lista_asignacion} es sentencia\n");
      sentenciaPtr = lista_asignacionPtr;
    }|
    en_lista {
      printf("\t{en_lista} es sentencia\n");
      sentenciaPtr = en_listaPtr;
    }|
    if  {
      printf("\t{if} es sentencia\n");
      sentenciaPtr = ifPtr;
    }|
    while {
      printf("\t{while} es sentencia\n");
      sentenciaPtr = whilePtr;
    }
  ;
  if:
    IF PAR_A condicion PAR_C LLAVE_A programa LLAVE_C {
      printf("\t{IF PAR_A condicion PAR_C LLAVE_A programa LLAVE_C ELSE LLAVE_A programa LLAVE_C} es if\n");
      nodo* auxDerPtr=desapilar();
      nodo* auxIzqPtr=desapilar();
      ifPtr = crearNodo("IF", auxIzqPtr, auxDerPtr);
    }|
    IF PAR_A condicion PAR_C LLAVE_A programa LLAVE_C ELSE LLAVE_A programa LLAVE_C {
      printf("\t{IF PAR_A condicion PAR_C LLAVE_A programa LLAVE_C ELSE LLAVE_A programa LLAVE_C} es if\n");
      nodo* auxIzqPtr=desapilar();
      nodo* auxDerPtr=desapilar();
      ifBodyPtr = crearNodo("body", auxIzqPtr, auxDerPtr);
      ifPtr = crearNodo("IF", desapilar(), ifBodyPtr);
    }
  ;
  while:
    WHILE PAR_A condicion PAR_C LLAVE_A programa LLAVE_C {
      printf("\t{ WHILE PAR_A condicion PAR_C LLAVE_A programa LLAVE_C}, es while\n");
      nodo* auxDerPtr=desapilar();
      nodo* auxIzqPtr=desapilar();
      whilePtr = crearNodo("WHILE", auxIzqPtr, auxDerPtr);
  }
  ;
  condicion_simple:
    expresion operador_comp expresion {
      printf("\t {factor operador_comp factor} es condicion\n");
      condicion_simplePtr = crearNodo(operador_compPtr->dato, desapilar(), desapilar());
    }
  ;
  condicion:
    condicion_simple {
      printf("\t {condicion_simple} es condicion\n");
      condicionPtr = condicion_simplePtr;
      apilar(condicionPtr);
    }|
    NOT PAR_A condicion_simple PAR_C { //TODO: Preguntar si el NOT genera un nodo o si cambia el orden del body en el if
      printf("\t {NOT PAR_A condicion PAR_C} es condicion\n");
      condicionPtr = crearNodo("not", condicion_simplePtr, NULL);
      apilar(condicionPtr);
    }|
    condicion_simple {condicion_simple2Ptr = condicion_simplePtr;} operador_log condicion_simple {
      printf("\t {condicion operador_log condicion} es condicion\n");
      condicionPtr = crearNodo(operador_logPtr->dato, condicion_simple2Ptr, condicion_simplePtr);
      apilar(condicionPtr);
    }
  ;
  operador_log:
    AND {
      printf("\t {AND} operador_log");
      operador_logPtr = crearHoja("and");
    }|
    OR {
      printf("\t {OR} es operador_log\n");
      operador_logPtr = crearHoja("or");
    }
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
    INLIST PAR_A ID {ptrIdList = crearHoja($3);} PYC COR_A lista_expresiones COR_C PAR_C PYC {
      printf("\t{INLIST PAR_A ID PYC COR_A lista_expresiones COR_C PAR_C PYC} es en_lista\n");
      en_listaPtr = lista_expresionesPtr;
    }
  ;
  lista_expresiones:
    expresion {
      printf("\t{expresion} es lista_expresiones\n");
      lista_expresionesPtr = crearNodo(":", crearHoja("@aux"), desapilar());
      lista_expresionesPtr = crearNodo("==", lista_expresionesPtr, ptrIdList);
      lista_expresionesPtr = crearNodo("IF", lista_expresionesPtr, crearHoja("ret true")); 
    }|
    lista_expresiones PYC expresion {
      printf("\t{lista_expresiones PYC expresion} es lista_expresiones\n");
      lista_expresionesAntPtr = lista_expresionesPtr; // Para no perderlo
      lista_expresionesPtr = crearNodo(":", crearHoja("@aux"), desapilar());
      lista_expresionesPtr = crearNodo("==", lista_expresionesPtr, crearHoja("a")); //TODO CAMBIAR POR EL LEXEMA Y NO HARCODEAR
      lista_expresionesPtr = crearNodo("IF", lista_expresionesPtr, crearHoja("ret true")); 
      lista_expresionesPtr = crearNodo(";", lista_expresionesAntPtr, lista_expresionesPtr);
    }
  ; 
  lista_asignacion:
    asignacion OP_ASIG expresion PYC {
      printf("\t{asignacion OP_ASIG expresion PYC} es lista_asignacion\n");
      lista_asignacionPtr = crearNodo(":", asignacionPtr, desapilar());
    };
  ;
  asignacion:
    asignacion OP_ASIG ID {
      printf("\t {asignacion OP_ASIG ID} es asignacion\n");
      asignacionPtr = crearNodo(":", asignacionPtr, crearHoja($3));
    }|
    ID {
      printf("\t{ID} es asignacion\n");
      asignacionPtr = crearHoja($1);
    }
  ;

  lectura:
    READ CONST_STRING PYC {
      printf("\t{READ CONST_STRING PYC} es lectura\n");
      lecturaPtr = crearNodo("READ", crearHoja($2), NULL);
    }|
    READ expresion PYC {
      printf("\t{READ expresion PYC} es lectura\n");
      lecturaPtr = crearNodo("READ", desapilar(), NULL);
    }
  ;
  impresion:
    WRITE CONST_STRING PYC {
      printf("\t{WRITE CONST_STRING PYC} es impresion\n");
      impresionPtr = crearNodo("WRITE", crearHoja($2), NULL);
    }|
    WRITE expresion PYC {
      printf("\t{WRITE expresion PYC} es impresion\n");
      impresionPtr = crearNodo("WRITE", desapilar(), NULL);
    }
  ;
  expresion:
    expresion SUM termino {
      printf("\t{expresion SUM termino} es expresion\n");
      apilar(crearNodo("+", desapilar(), terminoPtr));
    }|
    expresion RES termino {
      printf("\t{expresion RES termino} es expresion\n");
      apilar(crearNodo("-", desapilar(), terminoPtr));
    }|
    termino {
      printf("\t{termino} es expresion\n");
      apilar(terminoPtr);
    };
  termino:
    termino MULT {
      apilar(terminoPtr);
    } factor {
      printf("\t{termino MULT factor} es termino\n");
      terminoPtr = crearNodo("*",  desapilar(), factorPtr);
    }|

    termino DIV {
      apilar(terminoPtr);
    }factor {
      printf("\t{termino DIV factor} es termino\n");
      terminoPtr = crearNodo("/", desapilar(), factorPtr);
    }|

    factor {
      printf("\t{factor} es termino\n");
      terminoPtr = factorPtr;
    }
  ;
  factor:
    PAR_A expresion PAR_C {
      printf("\t{PAR_A expresion PAR_C} es factor\n");
      factorPtr = desapilar();
    }|
    ID {
      printf("\t{ID} es factor\n");
      factorPtr = crearHoja($1);
    }|
    CONST_INTEGER {
      printf("\t{CONST_INTEGER} es factor\n");
      factorPtr = crearHoja(castConst($1));
    }|
    CONST_FLOAT { 
      printf("\t{CONST_FLOAT} es factor\n");      
      factorPtr = crearHoja(castConst($1));
    }
  ;
%%



void agregarVariable() {
    char * aux = (char *) malloc(sizeof(char) * (strlen(yylval.str_val) + 1));
    strcpy(aux, yylval.str_val);
    idsAsignacionTipo[indexAsignacionTipo] = aux;
    indexAsignacionTipo++;
    return;
}


void actualizarTipoDeclaracionID(char * tipo) {
    int i;
    for (i = 0; i < indexAsignacionTipo; i++) {
        actualizarTipoDatoAID(idsAsignacionTipo[i], tipo);
    }
    indexAsignacionTipo = 0;
}

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

nodo * apilar(nodo *arg) {
    apilarDinamica(&pila, &arg);
}

nodo * desapilar() {
    nodo * ret = NULL;
    desapilarDinamica(&pila, &ret);
    return ret;
}