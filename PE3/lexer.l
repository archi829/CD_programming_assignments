%{
#include "parser.tab.h"
#include <string.h>
%}
%option yylineno

%%

"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }
"void"      { return VOID; }

"static"    { return STATIC; }
"extern"    { return EXTERN; }
"register"  { return REGISTER; }
"auto"      { return AUTO; }

"return"    { return RETURN; }

[a-zA-Z_][a-zA-Z0-9_]* {
    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+      {
    yylval.str = strdup(yytext);
    return NUMBER;
}

"="         { return ASSIGN; }
";"         { return SEMI; }
","         { return COMMA; }
"("         { return LP; }
")"         { return RP; }
"{"         { return LB; }
"}"         { return RB; }

[ \t\n]     ;
.           ;

%%

int yywrap() {
    return 1;
}
