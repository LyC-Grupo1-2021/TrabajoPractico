#ifndef TABLA_SIMBOLOS_H
#define TABLA_SIMBOLOS_H

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "tabla_simbolos.h"
#include "constantes_propias.h"

// Tabla de simbolos
struct struct_tablaSimbolos {
    char nombre[100];
    int tipo;
    char valor[100];
    char longitud[100];
};

struct struct_tablaSimbolos tablaSimbolos[1000];

void tsInsertarToken(int, char *, int, char *);
int tsCrearArchivo();
void tsActualizarTipos(char *, int);
int tsObtenerTipo(char *);
char * obtenerNombreTipo(int);

#endif