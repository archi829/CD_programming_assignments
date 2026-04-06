#include <stdio.h>
#include <string.h>
#include "symtab.h"

Symbol table[MAX_SYMBOLS];
int count = 0;

void insert(char *name, char *kind, char *type, char *storage, int size, int scope, int line){
   for(int i = 0; i < count; i++) {
        if(strcmp(table[i].name, name) == 0 && table[i].scope == scope)
            return; // avoid duplicate
    }

    strcpy(table[count].name, name);
    strcpy(table[count].kind, kind);
    strcpy(table[count].type, type);
    strcpy(table[count].storage, storage);
    table[count].size = size;
    table[count].scope = scope;
    table[count].line = line;

    count++;
}

void display() {
    printf("\nSymbol Table:\n");
    printf("Name\tKind\tType\tStorage\tSize\tScope\tLine\n");

    for(int i = 0; i < count; i++) {
        printf("%s\t%s\t%s\t%s\t%d\t%d\t%d\n",
            table[i].name,
            table[i].kind,
            table[i].type,
            table[i].storage,
            table[i].size,
            table[i].scope,
            table[i].line);
    }
}