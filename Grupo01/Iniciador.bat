flex Lexico.l
pause
bison -dyv ./Sintactico.y
pause
gcc lex.yy.c y.tab.c tabla_simbolos.c arbol_sintactico/arbol_sintactico.c -o Segunda.exe
pause
Segunda.exe prueba.txt
pause
dot -Tpng gragh.dot -o intermedia.png
pause
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del gragh.dot
pause