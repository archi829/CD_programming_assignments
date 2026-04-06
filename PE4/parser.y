%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Type constants */
#define TYPE_INT   0
#define TYPE_FLOAT 1

struct symbol {
    char name[10];
    int  ivalue;
    float fvalue;
    int  type;   /* TYPE_INT or TYPE_FLOAT */
} symtab[100];

int symcount = 0;

int lookup(char *name) {
    for(int i = 0; i < symcount; i++)
        if(strcmp(symtab[i].name, name) == 0)
            return i;
    return -1;
}

void insert_int(char *name, int value) {
    int idx = lookup(name);
    if(idx == -1) {
        strcpy(symtab[symcount].name, name);
        symtab[symcount].ivalue = value;
        symtab[symcount].fvalue = (float)value;
        symtab[symcount].type   = TYPE_INT;
        symcount++;
    } else {
        /* type mismatch: existing is float, assigning int — promote to float */
        if(symtab[idx].type == TYPE_FLOAT) {
            printf("Warning: Assigning int to float variable '%s', promoting.\n", name);
            symtab[idx].fvalue = (float)value;
        } else {
            symtab[idx].ivalue = value;
            symtab[idx].fvalue = (float)value;
            symtab[idx].type   = TYPE_INT;
        }
    }
}

void insert_float(char *name, float value) {
    int idx = lookup(name);
    if(idx == -1) {
        strcpy(symtab[symcount].name, name);
        symtab[symcount].fvalue = value;
        symtab[symcount].ivalue = (int)value;
        symtab[symcount].type   = TYPE_FLOAT;
        symcount++;
    } else {
        /* type mismatch: existing is int, assigning float */
        if(symtab[idx].type == TYPE_INT) {
            printf("Warning: Type mismatch — assigning float to int variable '%s', truncating.\n", name);
            symtab[idx].ivalue = (int)value;
            symtab[idx].fvalue = value;
            /* keep type as INT to reflect original declaration */
        } else {
            symtab[idx].fvalue = value;
            symtab[idx].ivalue = (int)value;
        }
    }
}

/* Returns float value of any variable (works for both types) */
float getval(char *name) {
    int idx = lookup(name);
    if(idx == -1) {
        printf("Error: Variable '%s' not declared\n", name);
        return 0;
    }
    return (symtab[idx].type == TYPE_FLOAT) ? symtab[idx].fvalue : (float)symtab[idx].ivalue;
}

int gettype(char *name) {
    int idx = lookup(name);
    if(idx == -1) return TYPE_INT; /* default */
    return symtab[idx].type;
}

void yyerror(const char *s);
int yylex();
%}

%union {
    int   num;
    float fnum;
    char *str;
    struct {
        float val;
        int   type;  /* TYPE_INT or TYPE_FLOAT */
    } expr;
}

%token <num>  NUM
%token <fnum> FNUM
%token <str>  ID
%token INC DEC

%type <expr> expr

%left '+' '-'
%left '*' '/'

%%

stmt_list : stmt
          | stmt_list ',' stmt
          ;

stmt : ID '=' expr {
            if($3.type == TYPE_FLOAT)
                insert_float($1, $3.val);
            else
                insert_int($1, (int)$3.val);
       }
     | ID INC {
            int idx = lookup($1);
            if(idx == -1) {
                printf("Error: Variable '%s' not declared\n", $1);
            } else {
                if(symtab[idx].type == TYPE_FLOAT)
                    symtab[idx].fvalue += 1.0;
                else {
                    symtab[idx].ivalue += 1;
                    symtab[idx].fvalue = (float)symtab[idx].ivalue;
                }
                printf("Post-increment: %s is now %g\n", $1,
                    (symtab[idx].type == TYPE_FLOAT) ? symtab[idx].fvalue : (float)symtab[idx].ivalue);
            }
       }
     | ID DEC {
            int idx = lookup($1);
            if(idx == -1) {
                printf("Error: Variable '%s' not declared\n", $1);
            } else {
                if(symtab[idx].type == TYPE_FLOAT)
                    symtab[idx].fvalue -= 1.0;
                else {
                    symtab[idx].ivalue -= 1;
                    symtab[idx].fvalue = (float)symtab[idx].ivalue;
                }
                printf("Post-decrement: %s is now %g\n", $1,
                    (symtab[idx].type == TYPE_FLOAT) ? symtab[idx].fvalue : (float)symtab[idx].ivalue);
            }
       }
     ;

expr : expr '+' expr {
            $$.type = ($1.type == TYPE_FLOAT || $3.type == TYPE_FLOAT) ? TYPE_FLOAT : TYPE_INT;
            $$.val  = $1.val + $3.val;
       }
     | expr '-' expr {
            $$.type = ($1.type == TYPE_FLOAT || $3.type == TYPE_FLOAT) ? TYPE_FLOAT : TYPE_INT;
            $$.val  = $1.val - $3.val;
       }
     | expr '*' expr {
            $$.type = ($1.type == TYPE_FLOAT || $3.type == TYPE_FLOAT) ? TYPE_FLOAT : TYPE_INT;
            $$.val  = $1.val * $3.val;
       }
     | expr '/' expr {
            if($3.val == 0) {
                printf("Error: Division by zero\n");
                $$.val  = 0;
                $$.type = TYPE_INT;
            } else {
                $$.type = TYPE_FLOAT; /* division always yields float */
                $$.val  = $1.val / $3.val;
            }
       }
     | NUM  { $$.val = (float)$1; $$.type = TYPE_INT; }
     | FNUM { $$.val = $1;        $$.type = TYPE_FLOAT; }
     | ID   { $$.val = getval($1); $$.type = gettype($1); }
     ;

%%

void yyerror(const char *s) {
    printf("Parse Error: %s\n", s);
}

int main() {
    printf("Enter input:\n");
    yyparse();

    printf("\n--- Symbol Table ---\n");
    printf("%-10s %-8s %s\n", "Name", "Type", "Value");
    printf("----------------------------\n");
    for(int i = 0; i < symcount; i++) {
        if(symtab[i].type == TYPE_FLOAT)
            printf("%-10s %-8s %g\n", symtab[i].name, "float", symtab[i].fvalue);
        else
            printf("%-10s %-8s %d\n", symtab[i].name, "int", symtab[i].ivalue);
    }
    return 0;
}
