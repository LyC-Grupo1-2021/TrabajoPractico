flex Lexico.l

bison -dyv ./Sintactico.y

gcc lex.yy.c y.tab.c arbol_sintactico/arbol_sintactico.c assembler/assembler.c tabla_simbolos.c -o Segunda.exe

Segunda.exe prueba.txt

dot -Tpng gragh.dot -o intermedia.png

del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del gragh.dot
del Segunda.exe
pause