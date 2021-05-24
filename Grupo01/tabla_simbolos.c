#include "tabla_simbolos.h"

int pos = 0;

void grabarToken(int token, char *nombre, char *valor, int longitud) {
    int i;

    for(i = 0; i < pos; i++){
        //Evitar duplicados
        if(strcmp(tablaSimb[i].nombre, nombre) == 0) return;
    }

    tablaSimb[pos].tipo_token = token;
    strcpy(tablaSimb[pos].nombre, nombre);
    strcpy(tablaSimb[pos].valor, valor);

    char parseLong[10];
    sprintf(parseLong, "%d", longitud);
    //Guardamos longitud de las constantes string y de los id
    if(tablaSimb[i].tipo_token == TOKEN_CTE_STRING || tablaSimb[i].tipo_token == TOKEN_ID) { 
        strcpy(tablaSimb[pos].longitud, parseLong);
    }

    pos++;
}


int crearArchivo() {
    int i;
    FILE *txt;

    txt = fopen("ts.txt", "w");

    if(!txt) return ERROR;

    //Imprimimos encabezados
    fprintf(txt, "%-40s%-40s%-25s%-40s%-25s\n", "Token", "Valor", "Longitud", "Nombre", "Tipo");

    for (i = 0; i < pos; i++) {
        if ((tablaSimb[i].tipo_token == TOKEN_CTE_INTEGER) 
            || (tablaSimb[i].tipo_token == TOKEN_CTE_FLOAT)) {
                fprintf(txt, "%-40s%-40s%-25s%-40s\n", mapNombreTipoToken(tablaSimb[i].tipo_token), tablaSimb[i].valor, "", tablaSimb[i].nombre);
        }else if(tablaSimb[i].tipo_token == TOKEN_CTE_STRING){
            fprintf(txt, "%-40s%-40s%-25s%-40s\n", mapNombreTipoToken(tablaSimb[i].tipo_token), tablaSimb[i].valor, tablaSimb[i].longitud, tablaSimb[i].nombre);
        }else{
            //id
            fprintf(txt, "%-40s%-40s%-25s%-40s\n", mapNombreTipoToken(tablaSimb[i].tipo_token), "", tablaSimb[i].longitud, tablaSimb[i].nombre);
        }
    }

    fclose(txt);

    return ARCHIVO_OK;

}


char * mapNombreTipoToken(const int tipo) {
	switch(tipo) {
		case TOKEN_CTE_FLOAT:
			return "CTE_FLOAT";
		case TOKEN_CTE_INTEGER:
			return "CTE_INTEGER";
		case TOKEN_CTE_STRING:
			return "CTE_STRING";
		case TOKEN_ID:
			return "IDENTIFICADOR";
	}
}