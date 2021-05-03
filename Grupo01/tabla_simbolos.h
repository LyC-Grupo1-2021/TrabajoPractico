#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "constantes_propias.h"

struct struct_tabla_simbolos {
    int tipo_token;
    char lexema[150];
    char valor[150];
    char longitud[150];
};

struct struct_tabla_simbolos tablaSimb[2500];

void grabarToken(int, char *, char *, int);
int crearArchivo();
char * mapNombreTipoToken(int);

#endif