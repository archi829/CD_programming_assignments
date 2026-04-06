#ifndef SYMTAB_H
#define SYMTAB_H

#define MAX_SYMBOLS 1000

typedef struct Symbol {
    char name[50];
    char kind[20];       // variable, function, parameter
    char type[50];       // int, float, char, void
    char storage[20];    // auto, static, extern, register
    int  size;           // size in bytes
    int  scope;          // 0 = global, 1 = function, 2+ = nested block
    int  line;           // line number of declaration
} Symbol;

void insert(char *name, char *kind, char *type, char *storage, int size, int scope, int line);
int  type_size(char *type);
void display();

#endif
