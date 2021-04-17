flex ./Lexico.l
gcc lex.yy.c -o programa
./programa prueba.txt
rm lex.yy.c
rm programa