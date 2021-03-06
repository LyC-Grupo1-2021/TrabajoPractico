#ifndef ARBOL_SINTACTICO_H
#define ARBOL_SINTACTICO_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../tabla_simbolos.h"
#include "../constantes_propias.h"

// Estructura para el arbol sintactico
typedef struct nodo{
    char dato[150];
    struct nodo* hijoDer;
    struct nodo* hijoIzq;
    int tipo;
}nodo;

// Estructura para el dato de la pila dinamica
typedef nodo* t_dato;

// Estructura para el nodo de la pila dinamica
typedef struct s_nodo
{
    t_dato dato;
    struct s_nodo* psig;
} t_nodo;

// Estructura para la pila dinamica
typedef t_nodo* t_pila;

nodo* crearNodo(const char* , nodo* , nodo* );
nodo* crearHoja(const char*, int);
void liberarMemoria(nodo* );
void llenarGragh(nodo* , FILE*, int );
void escribirGragh(nodo*);
int esHoja(nodo *hoja);

int apilarDinamica(t_pila *, const t_dato *);
int desapilarDinamica(t_pila *,t_dato *);
int verTopeDinamica(t_pila *,t_dato *);
#endif