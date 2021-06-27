#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include "../arbol_sintactico/arbol_sintactico.h"

int toAssembler(nodo *);
int printHeader();
int printData();
int printInstructions(nodo *);
int printFooter();
char * checkEmptyValue(char *);
void pushLabel(const int);
void recorrerArbolParaAssembler(FILE *, nodo*);
int getTopLabelStack(const int);
int popLabel(const int);
void setOperation(FILE *, nodo *);
int isArithmetic(const char *);
char *determinarCargaPila(const nodo *, const nodo *);
char *determinarDescargaPila(const nodo *);
char* getArithmeticInstruction(const char *);
int isComparation(const char *);

int pedirAux(const int);
char* obtenerSalto();
char* obtenerInstruccionComparacion(const char *);
char* obtenerInstruccionDisplay(nodo*);
char* obtenerInstruccionGet(nodo*);
#endif