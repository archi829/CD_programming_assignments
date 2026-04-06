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
        ID
      | declarator_list ',' ID
      ;

if_statement:
        IF '(' expression ')' statement %prec LOWER_THAN_ELSE
      | IF '(' expression ')' statement ELSE statement
      ;

do_while_statement:
        DO statement WHILE '(' expression ')' ';'
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