%{
#include "parser.tab.h"
#include <stdlib.h>
%}

%%

[0-9]+      { yylval.num = atoi(yytext); return NUMBER; }
[ \t\n]     ;   // ignore whitespace
"+"         return PLUS;
"-"         return MINUS;
"*"         return MUL;
"/"         return DIV;
"("         return LPAREN;
")"         return RPAREN;

.           { printf("Invalid character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}