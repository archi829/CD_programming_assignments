%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
[a-zA-Z]+      { yylval.str = strdup(yytext); return ID; }
[0-9]+         { yylval.num = atoi(yytext); return NUM; }

"="            { return '='; }
","            { return ','; }
"+"            { return '+'; }
"-"            { return '-'; }
"*"            { return '*'; }
"/"            { return '/'; }

[ \t\n]        ;  // ignore spaces

.              { printf("Invalid character: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
