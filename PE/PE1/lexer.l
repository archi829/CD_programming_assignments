%{
#include <stdio.h>
#include <string.h>

int line_no = 1;
%}

digit       [0-9]
letter      [a-zA-Z_]
id          {letter}({letter}|{digit})*

int_const   {digit}+
float_const {digit}+"."{digit}+
char_const  \'([^\\\n]|(\\.))\'
string_lit  \"([^\\\n]|(\\.))*\"

keyword     auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while

%%

{keyword}       { printf("KEYWORD: %s\n", yytext); }
{id}            { printf("IDENTIFIER: %s\n", yytext); }

{float_const}   { printf("FLOAT CONSTANT: %s\n", yytext); }
{int_const}     { printf("INTEGER CONSTANT: %s\n", yytext); }
{char_const}    { printf("CHAR CONSTANT: %s\n", yytext); }
{string_lit}    { printf("STRING LITERAL: %s\n", yytext); }

"++"|"--"                           { printf("OPERATOR: %s\n", yytext); }
"=="|"!="|"<="|">="|"<"|">"         { printf("RELATIONAL OPERATOR: %s\n", yytext); }
"&&"|"||"|"!"                       { printf("LOGICAL OPERATOR: %s\n", yytext); }
"+"|"-"|"*"|"/"|"%"                 { printf("ARITHMETIC OPERATOR: %s\n", yytext); }
"="|"+="|"-="|"*="|"/="|"%="        { printf("ASSIGNMENT OPERATOR: %s\n", yytext); }
"&"|"|"|"^"|"~"|"<<"|">>"           { printf("BITWISE OPERATOR: %s\n", yytext); }

";"|","|"("|")"|"{"|"}"|"["|"]"     { printf("PUNCTUATOR: %s\n", yytext); }

"//".*                                   ;
"/*"([^*]|"*"+[^*/])*"*"+"/"             ;

"\n"                                 { line_no++; }

[ \t]+                                  ;
.                                    { printf("UNKNOWN: %s\n", yytext); }

%%

int main(int argc, char *argv[]) {
    if (argc > 1)
        yyin = fopen(argv[1], "r");

    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
