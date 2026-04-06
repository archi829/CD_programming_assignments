%{
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
extern char *yytext;

void yyerror(const char *s);
int yylex();
%}

%token INT FLOAT CHAR DOUBLE
%token IF ELSE DO WHILE
%token FOR SWITCH CASE DEFAULT BREAK
%token ID NUM
%token RELOP ARITHOP

%left ARITHOP
%left RELOP

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program:
        program statement
      | /* empty */
      ;

statement:
        declaration
      | assignment
      | if_statement
      | do_while_statement
      | while_statement
      | for_statement
      | switch_statement
      | block
      ;

assignment:
        ID '=' expression ';'
      ;

declaration:
        type declarator_list ';'
      ;

type:
        INT
      | FLOAT
      | CHAR
      | DOUBLE
      ;

declarator_list:
        declarator
      | declarator_list ',' declarator
      ;

declarator:
        ID
      | ID '=' expression
      | ID array_dims
      | ID array_dims '=' expression
      ;

array_dims:
        '[' NUM ']'
      | array_dims '[' NUM ']'
      ;

if_statement:
        IF '(' expression ')' statement %prec LOWER_THAN_ELSE
      | IF '(' expression ')' statement ELSE statement
      ;

do_while_statement:
        DO statement WHILE '(' expression ')' ';'
      ;

while_statement:
  WHILE '(' expression ')' statement

for_statement:
        FOR '(' assignment_list ';' expression ';' assignment_list ')' statement
      ;

assignment_list:
        assignment_expr
      | assignment_list ',' assignment_expr
      ;

assignment_expr:
        ID '=' expression
      ;


switch_statement:
        SWITCH '(' ID ')' '{' case_list default_case '}'
      ;

case_list:
        case_list case
      | case
      ;

case:
        CASE NUM ':' program BREAK ';'
      ;

default_case:
        DEFAULT ':' program
      | /* empty */
      ;

    
block:
        '{' program '}'
      ;

expression:
        expression ARITHOP expression
      | expression RELOP expression
      | '(' expression ')'
      | ID
      | NUM
      ;

%%

void yyerror(const char *s) {
    printf("Syntax error at line %d, token '%s': %s\n", yylineno, yytext, s);
}

int main(int argc, char *argv[]) {
    extern FILE *yyin;

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("Could not open file %s\n", argv[1]);
            return 1;
        }
    }

    if (yyparse() == 0)
        printf("Syntax valid.\n");

    return 0;
}