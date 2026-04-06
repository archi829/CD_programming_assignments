%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>

extern int yylineno; //defined elsewhere, i'm jz using here
%}

%%

"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }
"double"    { return DOUBLE; }

"if"        { return IF; }
"else"      { return ELSE; }
"do"        { return DO; }
"while"     { return WHILE; }
"for"       { return FOR; }
"switch"    { return SWITCH; }
"case"      { return CASE; }
"default"   { return DEFAULT; }
"break"     { return BREAK; }

"=="|"!="|"<="|">="|"<"|">"   { return RELOP; }
"+"|"-"|"*"|"/"               { return ARITHOP; }
"="         { return '='; }

[0-9]+      { return NUM; }
[a-zA-Z_][a-zA-Z0-9_]*  { return ID; }

"{"         { return '{'; }
"}"         { return '}'; }
"("         { return '('; }
")"         { return ')'; }
"["         { return '['; }
"]"         { return ']'; }
":"         { return ':'; }
";"         { return ';'; }
","         { return ','; }

[ \t\r]+    ;
\n          { yylineno++; }


.           { return yytext[0]; }

%%

int yywrap() {
    return 1;
}