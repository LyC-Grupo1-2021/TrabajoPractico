
#include "assembler.h"

int toAssembler(nodo * root){
    if(printHeader() == -1){
        printf("Error al generar el assembler");
        return -1;
    }

    if(printData() == -1){
        printf("Error al generar la tabla de datos en assembler");
        return -1;
    }

    if(printInstructions() == -1){
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
    // fprintf(fp, "\tMAXTEXTSIZE equ %d\n", 200);

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

    // fprintf(fp, "\n.CODE\n");
    // if (addProcToAssignString == 1) {
    //     // Agrego los procesimiento para asginar string
    //     fprintf(fp, "strlen proc\n");
    //     fprintf(fp, "\tmov bx, 0\n");
    //     fprintf(fp, "\tstrLoop:\n");
    //     fprintf(fp, "\t\tcmp BYTE PTR [si+bx],'$'\n");
    //     fprintf(fp, "\t\tje strend\n");
    //     fprintf(fp, "\t\tinc bx\n");
    //     fprintf(fp, "\t\tjmp strLoop\n");
    //     fprintf(fp, "\tstrend:\n");
    //     fprintf(fp, "\t\tret\n");
    //     fprintf(fp, "strlen endp\n");

    //     fprintf(fp, "assignString proc\n");
    //     fprintf(fp, "\tcall strlen\n");
    //     fprintf(fp, "\tcmp bx , MAXTEXTSIZE\n");
    //     fprintf(fp, "\tjle assignStringSizeOk\n");
    //     fprintf(fp, "\tmov bx , MAXTEXTSIZE\n");
    //     fprintf(fp, "\tassignStringSizeOk:\n");
    //     fprintf(fp, "\t\tmov cx , bx\n");
    //     fprintf(fp, "\t\tcld\n");
    //     fprintf(fp, "\t\trep movsb\n");
    //     fprintf(fp, "\t\tmov al , '$'\n");
    //     fprintf(fp, "\t\tmov byte ptr[di],al\n");
    //     fprintf(fp, "\t\tret\n");
    //     fprintf(fp, "assignString endp\n");
    // }

    fclose(fp);
    return 0;

}


int printInstructions(){
    return 1;
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
