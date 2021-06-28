#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "constantes_propias.h"

struct struct_tabla_simbolos {
    int tipo_token;
    char nombre[150];
    char tipo[8];
    char valor[150];
    char longitud[150];
};

struct struct_tabla_simbolos tablaSimb[2500];

void grabarToken(int, char*, char *, char *, int);
int crearArchivo();
char * mapNombreTipoToken(int);
char * castConst(const char *);
void actualizarTipoDatoAID(char *, char *);
int getPosicionTS();
int getTipo(char * );
int typeDecorator(const int tipo_token);
int resolveType(int tipo1, int tipo2);
char * mapNombreTipoDato(const int);
int yyerror();
#endif