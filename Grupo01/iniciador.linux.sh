flex ./Lexico.l
bison -dyv ./Sintactico.y
gcc lex.yy.c y.tab.c tabla_simbolos.c arbol_sintactico/arbol_sintactico.c assembler/assembler.c -o primera.o
./primera.o ./prueba.txt
dot -Tpng gragh.dot -o intermedia.png
rm lex.yy.c
rm y.tab.c
rm y.output
rm y.tab.h
rm primera.o
rm gragh.dot