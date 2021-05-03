flex Lexico.l
pause
bison -dyv ./Sintactico.y
pause
gcc lex.yy.c y.tab.c tabla_simbolos.c -o Primera.exe
pause
pause
Primera.exe prueba.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h
pause