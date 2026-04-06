%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
[a-zA-Z]+      { yylval.str = strdup(yytext); return ID; }
[0-9]+\.[0-9]+ { yylval.fnum = atof(yytext); return FNUM; }
[0-9]+         { yylval.num = atoi(yytext); return NUM; }

"++"           { return INC; }
"--"           { return DEC; }
"="            { return '='; }
","            { return ','; }
"+"            { return '+'; }
"-"            { return '-'; }
"*"            { return '*'; }
"/"            { return '/'; }

[ \t\n]        ;

.              { printf("Invalid character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
