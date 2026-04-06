#ifndef SYMTAB_H
#define SYMTAB_H

#define MAX_SYMBOLS 1000

typedef struct Symbol {
    char name[50];
    char kind[20];       // variable, function, parameter
    char type[50];       // int, float, etc.
    char storage[20];    // auto, static, extern
    int size;
    int scope;
    int line;
} Symbol;

void insert(char *name, char *kind, char *type, char *storage, int size, int scope, int line);
void display();

#endif