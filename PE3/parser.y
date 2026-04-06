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
char current_storage[20];
char current_func[50];
%}

%union {
    char *str;
}

%token <str> ID NUMBER
%token INT FLOAT CHAR VOID
%token STATIC EXTERN REGISTER AUTO
%token RETURN ASSIGN
%token SEMI COMMA LP RP LB RB

%%

program:
    program declaration
    | program function_def
    |
    ;

/* ─── Storage class ─── */
storage_class:
    STATIC   { strcpy(current_storage, "static"); }
    | EXTERN  { strcpy(current_storage, "extern"); }
    | REGISTER{ strcpy(current_storage, "register"); }
    | AUTO    { strcpy(current_storage, "auto"); }
    ;

/* ─── Types ─── */
type:
    INT    { strcpy(current_type, "int"); }
    | FLOAT { strcpy(current_type, "float"); }
    | CHAR  { strcpy(current_type, "char"); }
    | VOID  { strcpy(current_type, "void"); }
    ;

/* ─── Variable declarations (with optional storage class) ─── */
declaration:
    storage_class type var_list SEMI
    | type var_list SEMI
    ;

var_list:
    var_list COMMA ID {
        insert($3, "variable", current_type, current_storage, type_size(current_type), scope, yylineno);
        free($3);
    }
    | ID {
        insert($1, "variable", current_type, current_storage, type_size(current_type), scope, yylineno);
        free($1);
    }
    ;

/* ─── Function definition ─── */
function_def:
    type ID {
        strcpy(current_func, $2);
        insert($2, "function", current_type, current_storage, 0, scope, yylineno);
        free($2);
    }
    LP { scope++; strcpy(current_storage, "auto"); }
    param_list RP
    block
    { scope--; }
    ;

/* ─── Parameters ─── */
param_list:
    param_list COMMA param
    | param
    |   /* empty — void or no params */
    ;

param:
    type ID {
        insert($2, "parameter", current_type, "auto", type_size(current_type), scope, yylineno);
        free($2);
    }
    ;

/* ─── Block: { declarations and statements } ─── */
block:
    LB { scope++; strcpy(current_storage, "auto"); }
    block_body
    RB { scope--; }
    ;

block_body:
    block_body declaration
    | block_body statement
    |
    ;

/* ─── Statements (basic — enough to parse body without errors) ─── */
statement:
    RETURN expr SEMI
    | RETURN SEMI
    | expr SEMI
    | block
    ;

/* Simple expressions: IDs, numbers, calls, assignments */
expr:
    ID              { free($1); }
    | NUMBER        { free($1); }
    | ID LP args RP { free($1); }
    | expr ASSIGN expr
    ;

args:
    args COMMA expr
    | expr
    |
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Parse error at line %d: %s\n", yylineno, s);
}

int main() {
    strcpy(current_storage, "auto");
    yyparse();
    display();
    return 0;
}
