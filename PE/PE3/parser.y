%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

extern int yylineno;

int yylex();
void yyerror(char *s);

int scope = 0;
char current_type[20];
%}


%union {
    char *str;
}

%token <str> ID
%token INT FLOAT CHAR STATIC EXTERN
%token NUMBER
%token SEMI COMMA LP RP LB RB

%%

program:
    program declaration
    | 
    ;

declaration:
    type var_list SEMI
    ;

type:
    INT    { strcpy(current_type, "int"); }
    | FLOAT { strcpy(current_type, "float"); }
    | CHAR  { strcpy(current_type, "char"); }
    ;

var_list:
    var_list COMMA ID {
        insert($3, "variable", current_type, "auto", 4, scope, yylineno);
    }
    | ID {
        insert($1, "variable", current_type, "auto", 4, scope, yylineno);
    }
    ;

%%

void yyerror(char *s) {
    printf("Error: %s\n", s);
}

int main() {
    yyparse();
    display();
    return 0;
}