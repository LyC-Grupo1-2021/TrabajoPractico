flex ./Lexico.l
bison -dyv ./Sintactico.y
gcc lex.yy.c y.tab.c tabla_simbolos.c -o primera
./primera.exe ./prueba.txt
rm lex.yy.c
rm y.tab.c
rm y.output
rm y.tab.h
rm primera.exe