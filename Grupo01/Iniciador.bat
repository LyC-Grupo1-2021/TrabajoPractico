flex Lexico.l
pause
bison -dyv ./Sintactico.y
pause
gcc lex.yy.c y.tab.c tabla_simbolos.c arbol_sintactico/arbol_sintactico.c -o Primera.exe
pause
pause
Primera.exe prueba.txt
pause
dot -Tpng gragh.dot -o gragh.png
pause
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
del gragh.dot
pause