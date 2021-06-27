#include "assembler.h"

int hasElse = 0;
int ORcondition = 0;
int isWhile = 0;

int numLabelWhile = 0;
int numLabelIf = 0;

int stackNumLabelWhile [25];
int stackNumLabelIf [25];

int topStackIf = 0;
int topStackWhile = 0;

int addCodeToProcesString = 0;

int toAssembler(nodo * root){
    if(printHeader() == -1){
        printf("Error al generar el assembler");
        return -1;
    }

    if(printData() == -1){
        printf("Error al generar la tabla de datos en assembler");
        return -1;
    }

    if(printInstructions(root) == -1){
        printf("Error al generar las instrucciones de assembler");
        return -1;
    }

    if(printFooter() == -1){
        printf("Error al generar el footer");
        return -1;
    }
}


int printHeader(){
    FILE * fp = fopen("assembler/header.txt", "w");
	if (fp == NULL) {
		printf("Error abierndo el archivo del header\n");
		return -1;
	}

	fprintf(fp, "INCLUDE macros2.asm\n");
    fprintf(fp, "INCLUDE number.asm\n");
    fprintf(fp, ".MODEL LARGE\n");
    fprintf(fp, ".386\n");
    fprintf(fp, ".STACK 200h\n"); 
    fclose(fp);
    return 0;
}

int printData(){
    FILE * fp = fopen("assembler/data.txt", "wt+");
	if (fp == NULL) {
		printf("Error escribiendo el archivo data");
		return 1;
	}

	fprintf(fp, "\t.DATA\n");    
    // fprintf(fp, "\tTRUE equ 1\n");
    // fprintf(fp, "\tFALSE equ 0\n");
    fprintf(fp, "\tMAXTEXTSIZE equ %d\n", 200);

    //Aca va la tabla de simbolo con todos los auxiliares
    int i;
    int posTablaSimb = getPosicionTS();
    for (i = 0; i < posTablaSimb; i++) {
        if (tablaSimb[i].tipo_token == TOKEN_CTE_STRING)
            fprintf(fp, "%-32s\tdb\t%s,'$', %s dup (?)\n", tablaSimb[i].nombre, tablaSimb[i].valor,
                    tablaSimb[i].longitud);
        else
            fprintf(fp, "%-32s\tdd\t%s\n", tablaSimb[i].nombre, checkEmptyValue(tablaSimb[i].valor));
    }

    fprintf(fp, "\n.CODE\n");
    if (addCodeToProcesString == 1) {
        // Agrego los procesimiento para asginar string
        fprintf(fp, "strlen proc\n");
        fprintf(fp, "\tmov bx, 0\n");
        fprintf(fp, "\tstrLoop:\n");
        fprintf(fp, "\t\tcmp BYTE PTR [si+bx],'$'\n");
        fprintf(fp, "\t\tje strend\n");
        fprintf(fp, "\t\tinc bx\n");
        fprintf(fp, "\t\tjmp strLoop\n");
        fprintf(fp, "\tstrend:\n");
        fprintf(fp, "\t\tret\n");
        fprintf(fp, "strlen endp\n");

        fprintf(fp, "assignString proc\n");
        fprintf(fp, "\tcall strlen\n");
        fprintf(fp, "\tcmp bx , MAXTEXTSIZE\n");
        fprintf(fp, "\tjle assignStringSizeOk\n");
        fprintf(fp, "\tmov bx , MAXTEXTSIZE\n");
        fprintf(fp, "\tassignStringSizeOk:\n");
        fprintf(fp, "\t\tmov cx , bx\n");
        fprintf(fp, "\t\tcld\n");
        fprintf(fp, "\t\trep movsb\n");
        fprintf(fp, "\t\tmov al , '$'\n");
        fprintf(fp, "\t\tmov byte ptr[di],al\n");
        fprintf(fp, "\t\tret\n");
        fprintf(fp, "assignString endp\n");
    }

    fclose(fp);
    return 0;

}


int printInstructions(nodo * root){
    FILE * fp = fopen("./assembler/instructions.txt", "wt+");
	if (fp == NULL) {
		printf("Error al escribir el archivo de instrucciones");
		return -1;
	}

    fprintf(fp, "\nSTART:\nMOV AX,@DATA\nMOV DS,AX\nMOV es,ax\nFINIT\nFFREE\n\n");
	recorrerArbolParaAssembler(fp, root);
	fclose(fp);
	return 0;
}

int printFooter(){
    FILE * fp = fopen("./assembler/footer.txt", "w");
	if (fp == NULL) {
		printf("Error intentando escribir el footer\n");
		return -1;
	}
    
    fprintf(fp, "\nliberar:\n");
    fprintf(fp, "\tffree\n");
	fprintf(fp, "\tmov ax, 4c00h\n");
    fprintf(fp, "\tint 21h\n");
    fprintf(fp, "\tjmp fin\n");

    fprintf(fp, "fin:\n");
    fprintf(fp, "\tEnd START\n"); 

    fclose(fp);
    return 0;
}

char * checkEmptyValue(char *value) {
    if (strcmp(value, "") == 0) {
        return "?";
    }
    return value;
}


/* Funcion que recorre el arbol*/
void recorrerArbolParaAssembler(FILE * fp, nodo* root) {
    if (root != NULL) {
        int currentIfNode = 0;
        int currentWhileNode = 0;

        //Nodo IF
        if(strcmp(root->dato, "IF") == 0) {
            hasElse = 0;
            currentIfNode = 1;
            pushLabel(LABEL_IF);
            
            if (strcmp(root->hijoDer->dato, "BODY") == 0) {
                hasElse = 1;
            }
            if (strcmp(root->hijoIzq->dato, "OR") == 0) {
                ORcondition = 1;
            }
        }

        //WHILE
        if(strcmp(root->dato, "WHILE") == 0) {
            currentWhileNode = 1;
            isWhile = 1;
            pushLabel(LABEL_WHILE);
            fprintf(fp, "condicionWhile%d:\n", getTopLabelStack(LABEL_WHILE));
            if (strcmp(root->hijoIzq->dato, "OR") == 0) {
                ORcondition = 1;
            }
        }

        // Buscamos nodo a la izquierda
        recorrerArbolParaAssembler(fp, root->hijoIzq);
        // Fin de recorrido a la izquierda

        if(currentIfNode) {
            fprintf(fp, "startIf%d:\n", getTopLabelStack(LABEL_IF));
        }

        if(strcmp(root->dato, "BODY") == 0) {
            fprintf(fp, "JMP endif%d\n", getTopLabelStack(LABEL_IF));
            fprintf(fp, "else%d:\n", getTopLabelStack(LABEL_IF));
        }

        if(currentWhileNode) {
            fprintf(fp, "startWhile%d:\n", getTopLabelStack(LABEL_WHILE));
            isWhile = 0; 
        }
        
        // Buscamos nodo a la derecha
        recorrerArbolParaAssembler(fp, root->hijoDer);
        // Fin de recorrido a la derecha

        if (currentIfNode) {
            fprintf(fp, "endif%d:\n", popLabel(LABEL_IF));
        }

        //while 
        if(currentWhileNode) {
            fprintf(fp, "JMP condicionWhile%d\n", getTopLabelStack(LABEL_WHILE));
            fprintf(fp, "endwhile%d:\n", popLabel(LABEL_WHILE));
        }
        
        if (esHoja(root->hijoIzq) && esHoja(root->hijoDer)) {
            // soy nodo mas a la izquierda con dos hijos hojas
            setOperation(fp, root);
            
            // reduzco arbol
            root->hijoIzq = NULL;
            root->hijoDer = NULL;
        }
    }
}


void pushLabel(const int labelType) {
    if (labelType == LABEL_IF) {
        numLabelIf++;
        stackNumLabelIf[topStackIf] = numLabelIf;
        topStackIf++;
    }

    if (labelType == LABEL_WHILE) {
        numLabelWhile++;
        stackNumLabelWhile[topStackWhile] = numLabelWhile;
        topStackWhile++;
    }
}

int getTopLabelStack(const int labelType) {
    if (labelType == LABEL_IF) {
        return stackNumLabelIf[topStackIf - 1];
    }
    if (labelType == LABEL_WHILE) {
        return stackNumLabelWhile[topStackWhile - 1];
    }
}

int popLabel(const int labelType) {
    if (labelType == LABEL_IF) {
        topStackIf--;
        return stackNumLabelIf[topStackIf];
    }
    if (labelType == LABEL_WHILE) {
        topStackWhile--;
        return stackNumLabelWhile[topStackWhile];
    }
}


void setOperation(FILE * fp, nodo * root){
      if(isArithmetic(root->dato)) {
        if(strcmp(root->dato, ":") == 0) {
            if (root->tipo == TOKEN_CTE_STRING) {
                addCodeToProcesString = 1; 
                fprintf(fp, "MOV si, OFFSET   %s\n", root->hijoDer);
                fprintf(fp, "MOV di, OFFSET  %s\n", root->hijoIzq);
                fprintf(fp, "CALL assignString\n");
            } else {
                //ASIGNACION DE ALGO QUE NO ES UN STRING (FLOAT O INT)
                fprintf(fp, "f%sld %s\n", determinarCargaPila(root, root->hijoDer), root->hijoDer->dato);
                fprintf(fp, "f%sstp %s\n", determinarCargaPila(root, root->hijoIzq), root->hijoIzq->dato);
            }
        } else {
            fprintf(fp, "f%sld %s\n", determinarCargaPila(root, root->hijoIzq), root->hijoIzq->dato); //st0 = izq
            fprintf(fp, "f%sld %s\n", determinarCargaPila(root, root->hijoDer), root->hijoDer->dato); //st0 = der st1 = izq
            fprintf(fp, "%s\n", getArithmeticInstruction(root->dato));
            fprintf(fp, "f%sstp @aux%d\n", determinarDescargaPila(root), pedirAux(root->tipo));

            // Guardo en el arbol el dato del resultado, si uso un aux
            sprintf(root->dato, "@aux%d", cantAux);
        }
    }

    if(isComparation(root->dato)) {
        // esto funciona para comparaciones simples
        fprintf(fp, "f%sld %s\n", determinarCargaPila(root, root->hijoDer), root->hijoDer->dato); //st0 = der
        fprintf(fp, "f%sld %s\n", determinarCargaPila(root, root->hijoIzq), root->hijoIzq->dato); //st0 = izq  st1 = der
        fprintf(fp, "fcom\n"); // compara ST0 con ST1"
        fprintf(fp, "fstsw ax\n");
        fprintf(fp, "sahf\n");
        if (esWhile)
            fprintf(fp, "%s %s%d\n", obtenerInstruccionComparacion(root->dato), obtenerSalto(), getTopLabelStack(LABEL_WHILE));
        else
            fprintf(fp, "%s %s%d\n", obtenerInstruccionComparacion(root->dato), obtenerSalto(), getTopLabelStack(LABEL_IF));
    }

    if(strcmp(root->dato, "READ") == 0) {
        fprintf(fp, "%s %s\n", obtenerInstruccionGet(root->hijoIzq), root->hijoIzq->dato);
    }

    if(strcmp(root->dato, "WRITE") == 0) {
        fprintf(fp, "%s\n", obtenerInstruccionDisplay(root->hijoDer));
        fprintf(fp, "newLine 1\n");
    }
}


int isArithmetic(const char *operator) {
    return strcmp(operator, "+") == 0 ||
        strcmp(operator, "/") == 0 ||
        strcmp(operator, "*") == 0 ||
        strcmp(operator, ":") == 0 || 
        strcmp(operator, "-") == 0;
}

char *determinarCargaPila(const nodo * raiz, const nodo * hijo) {
    if (typeDecorator(hijo->tipo) == TOKEN_CTE_INTEGER) {
        return "i";
    }
    return "";
}

char *determinarDescargaPila(const nodo * raiz) {
    if (typeDecorator(raiz->tipo) == TOKEN_CTE_INTEGER) {
        return "i";
    }
    return "";
}

char* getArithmeticInstruction(const char *operator) {
    if (strcmp(operator, "+") == 0)
        return "fadd";
    if (strcmp(operator, "-") == 0)
        return "fsub";
    if (strcmp(operator, "*") == 0)
        return "fmul";
    if (strcmp(operator, "/") == 0)
        return "fdiv";
}


int isComparation(const char *comp) {
    return strcmp(comp, ">") == 0 ||
    strcmp(comp, ">=") == 0 ||
    strcmp(comp, "<") == 0 ||
    strcmp(comp, "<=") == 0 ||
    strcmp(comp, "==") == 0 ||
    strcmp(comp, "!=") == 0;
}