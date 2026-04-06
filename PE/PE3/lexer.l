%{
#include "parser.tab.h"
#include <string.h>
%}
%option yylineno


%%
"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }

"static"    { return STATIC; }
"extern"    { return EXTERN; }

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+      { return NUMBER; }

";"         { return SEMI; }
","         { return COMMA; }
"("         { return LP; }
")"         { return RP; }
"{"         { return LB; }
"}"         { return RB; }

[ \t]       ;
.           ;
\n          ;

%%

int yywrap() {
    return 1;
}