%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct symbol {
    char name[10];
    int value;
} symtab[100];

int symcount = 0;

int lookup(char *name) {
    for(int i=0; i<symcount; i++) {
        if(strcmp(symtab[i].name, name) == 0)
            return i;
    }
    return -1;
}

void insert(char *name, int value) {
    int idx = lookup(name);
    if(idx == -1) {
        strcpy(symtab[symcount].name, name);
        symtab[symcount].value = value;
        symcount++;
    } else {
        symtab[idx].value = value;
    }
}

int getval(char *name) {
    int idx = lookup(name);
    if(idx == -1) {
        printf("Error: Variable %s not declared\n", name);
        return 0;
    }
    return symtab[idx].value;
}

void yyerror(const char *s);
int yylex();
%}

%union {
    int num;
    char *str;
}

%token <num> NUM
%token <str> ID

%type <num> expr

%%

stmt_list : stmt
          | stmt_list ',' stmt
          ;

stmt : ID '=' expr {
            insert($1, $3);
       }
     ;

expr : expr '+' expr { $$ = $1 + $3; }
     | expr '-' expr { $$ = $1 - $3; }
     | expr '*' expr { $$ = $1 * $3; }
     | expr '/' expr { $$ = $1 / $3; }
     | NUM           { $$ = $1; }
     | ID            { $$ = getval($1); }
     ;

%%

void yyerror(const char *s) {
    printf("Error: %s\n", s);
}

int main() {
    printf("Enter input:\n");
    yyparse();

    printf("\nSymbol Table:\n");
    for(int i=0; i<symcount; i++) {
        printf("%s = %d\n", symtab[i].name, symtab[i].value);
    }
    return 0;
}