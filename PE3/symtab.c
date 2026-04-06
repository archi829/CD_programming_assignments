#include <stdio.h>
#include <string.h>
#include "symtab.h"

Symbol table[MAX_SYMBOLS];
int count = 0;

/* Returns size in bytes for a given base type */
int type_size(char *type) {
    if (strcmp(type, "int")   == 0) return 4;
    if (strcmp(type, "float") == 0) return 4;
    if (strcmp(type, "char")  == 0) return 1;
    if (strcmp(type, "void")  == 0) return 0;
    return 4; /* default */
}

void insert(char *name, char *kind, char *type, char *storage, int size, int scope, int line) {
    /* Avoid duplicate: same name in same scope */
    for (int i = 0; i < count; i++) {
        if (strcmp(table[i].name, name) == 0 && table[i].scope == scope)
            return;
    }

    strcpy(table[count].name,    name);
    strcpy(table[count].kind,    kind);
    strcpy(table[count].type,    type);
    strcpy(table[count].storage, storage);
    table[count].size  = size;
    table[count].scope = scope;
    table[count].line  = line;

    count++;
}

void display() {
    printf("\nSymbol Table:\n");

    /* Header */
    printf("%-15s %-12s %-10s %-10s %-6s %-7s %-5s\n",
           "Name", "Kind", "Type", "Storage", "Size", "Scope", "Line");
    printf("%-15s %-12s %-10s %-10s %-6s %-7s %-5s\n",
           "---------------", "------------", "----------",
           "----------", "------", "-------", "-----");

    for (int i = 0; i < count; i++) {
        printf("%-15s %-12s %-10s %-10s %-6d %-7d %-5d\n",
            table[i].name,
            table[i].kind,
            table[i].type,
            table[i].storage,
            table[i].size,
            table[i].scope,
            table[i].line);
    }
}
