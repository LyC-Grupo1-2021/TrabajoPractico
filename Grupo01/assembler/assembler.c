

int toAssembler(nodo * root){
    if(printHeader() === -1){
        printf("Error al generar el assembler");
        return
    }


    
}


int printHeader(){
    FILE * fp = fopen("./assembler/header.txt", "w");
	if (fp == NULL) {
		printf("Error abierndo el archivo del header");
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