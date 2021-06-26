#ifndef ASSEMBLER_H
#define ASSEMBLER_H

#include "../arbol_sintactico/arbol_sintactico.h"

int toAssembler(nodo *);
int printHeader();
int printData();
int printInstructions();
int printFooter();
char * checkEmptyValue(char *);

#endif