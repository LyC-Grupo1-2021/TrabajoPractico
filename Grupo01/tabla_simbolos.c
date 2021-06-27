#include "tabla_simbolos.h"

int pos = 0;

void grabarToken(int token, char* tipo, char *nombre, char *valor, int longitud) {
    int i;

    for(i = 0; i < pos; i++){
        //Evitar duplicados
        if(strcmp(tablaSimb[i].nombre, nombre) == 0) return;
    }

    tablaSimb[pos].tipo_token = token;
    strcpy(tablaSimb[pos].nombre, nombre);
    strcpy(tablaSimb[pos].valor, valor);
    strcpy(tablaSimb[pos].tipo, tipo);

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
    //fprintf(txt, "%-40s%-40s%-25s%-40s%-25s\n", "Token", "Valor", "Longitud", "Nombre", "Tipo");
    fprintf(txt, "%-40s%-25s%-25s%-25s%-25s\n", "Nombre", "TipoDato", "Valor", "Longitud", "Token");

    for (i = 0; i < pos; i++) {
        if ((tablaSimb[i].tipo_token == TOKEN_CTE_INTEGER) 
            || (tablaSimb[i].tipo_token == TOKEN_CTE_FLOAT)) {
                fprintf(txt, "%-40s%-25s%-25s%-25s%-25s\n", tablaSimb[i].nombre, tablaSimb[i].tipo, 
                    tablaSimb[i].valor, "", mapNombreTipoToken(tablaSimb[i].tipo_token));
        }else if(tablaSimb[i].tipo_token == TOKEN_CTE_STRING){
            fprintf(txt, "%-40s%-25s%-25s%-25s%-25s\n", tablaSimb[i].nombre, tablaSimb[i].tipo, 
                tablaSimb[i].valor, tablaSimb[i].longitud, mapNombreTipoToken(tablaSimb[i].tipo_token));
        }else{
            //id
            fprintf(txt, "%-40s%-25s%-25s%-25s%-25s\n", tablaSimb[i].nombre, tablaSimb[i].tipo, "", 
                tablaSimb[i].longitud, mapNombreTipoToken(tablaSimb[i].tipo_token));
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
        case VARIABLE_AUXILIAR:
            return "VARIABLE_AUXILIAR";
	}
}

char * castConst(const char * value){
    char name[32] = "_";
    strcat(name, value);
    return strdup(name);
}


/**
 * Actualiza el tipo de dato del ID en TS
 */
void actualizarTipoDatoAID(char * id, char * tipo) {
	int i;
	for (i = 0; i < pos; i++) {
		if (strcmp(tablaSimb[i].nombre, id) == 0) {
            strcpy(tablaSimb[i].tipo, tipo);
		}
	}		
}

int getTipo(char * id) {
	int i;
	for (i = 0; i < pos; i++) {
		if (strcmp(tablaSimb[i].nombre, id) == 0) {
			return tablaSimb[i].tipo_token;
		}
	}
	return -1;
}



int getPosicionTS(){
    return pos;
}


int resolveType(int type1, int type2) {
	type1 = typeDecorator(type1);
	type2 = typeDecorator(type2);
	const int retType = typeCompatibility[type1][type2];
	if (retType == TIPO_ERROR) {
		yyerror("EXISTE UN ERROR DE COMPATIBILIDAD DE TIPOS");
	}

    return retType;
}


int typeDecorator(const int tipo_token) {
	switch(tipo_token) {
		case TOKEN_CTE_INTEGER:
			return TIPO_INTEGER;
		case TOKEN_CTE_FLOAT:
			return TIPO_FLOAT;
		case TOKEN_CTE_STRING:
			return TIPO_STRING;
		case TOKEN_ID:
			return TIPO_ERROR;
	}
	return tipo_token;
}