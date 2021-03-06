#include "arbol_sintactico.h"
#include "../constantes_propias.h"

nodo* crearNodo(const char *d, nodo* hI, nodo* hD) {
	nodo* nodoPadre = (nodo*)malloc(sizeof(nodo));
    if(nodoPadre == NULL) {
        printf("No hay memoria disponible");
        exit(1);
    }
    strcpy(nodoPadre->dato, d);
    nodoPadre->hijoDer = hD;
    nodoPadre->hijoIzq = hI;
    return nodoPadre;
}

nodo* crearHoja(const char *d, int tipo) {
	nodo* nuevoNodo = (nodo*)malloc(sizeof(nodo));
    if(nuevoNodo == NULL) {
        printf("No hay memoria disponible");
        exit(1);
    }
    strcpy(nuevoNodo->dato, d);
    nuevoNodo->tipo = tipo;
    nuevoNodo->hijoDer = NULL;
    nuevoNodo->hijoIzq = NULL;
    if(strncmp(nuevoNodo->dato, "@", 1) == 0) {
        grabarToken(VARIABLE_AUXILIAR, "INTEGER", nuevoNodo->dato, "", strlen(nuevoNodo->dato));
    }
    return nuevoNodo;
}

void liberarMemoria(nodo* padre) {
    if(padre == NULL) {
        return;
    }
    liberarMemoria(padre->hijoDer);
    liberarMemoria(padre->hijoIzq);
    free(padre);
    return;
}

void llenarGragh(nodo* padre, FILE *arch, int numNodo) {
    if(padre == NULL) {
        return;
    }
    int numHI = numNodo*2+1;
    int numHD = numNodo*2+2;
    
    if(padre->hijoIzq) {
        fprintf(arch, "\t\"nodo_%d \\n%s\" -> \"nodo_%d \\n%s\"\n", numNodo, padre->dato, numHI, padre->hijoIzq->dato);
    }
    if(padre->hijoDer) {
        fprintf(arch, "\t\"nodo_%d \\n%s\" -> \"nodo_%d \\n%s\"\n", numNodo, padre->dato ,numHD ,padre->hijoDer->dato);
    }
    llenarGragh(padre->hijoIzq, arch, numHI);
    llenarGragh(padre->hijoDer, arch, numHD);
    return;
}

void escribirGragh(nodo* padre) {
    FILE *archivo;

	archivo = fopen("gragh.dot", "w");
	if (archivo == NULL) {
		return;
	}
    //Escribir plantilla para poder dibujar el grafo
    fprintf(archivo, "%s\n", "digraph G {");
    llenarGragh(padre, archivo, 0);
    fprintf(archivo, "%s", "}");
    
    fclose(archivo);
    return;
}

int esHoja(nodo *hoja) {
    if (hoja == NULL) {
        return 0;
    }
    return hoja->hijoIzq == NULL && hoja->hijoDer == NULL;
}

int apilarDinamica(t_pila *PP, const t_dato *pd)
 {
    t_nodo *pnue= (t_nodo *)malloc(sizeof(t_nodo));
    if(!pnue)
        return 0;
    pnue->dato = *pd;
    pnue->psig = *PP;
    *PP=pnue;
    return 1;
}

int desapilarDinamica(t_pila *pp, t_dato *pd)
{
    t_nodo *aux;
    if(*pp==NULL)
        return 0;

    aux = *pp;
    *pd = aux->dato; //== (*pp)->dato
    *pp = aux->psig;
    free(aux);
    return 1;
}