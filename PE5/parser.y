%{
#include <stdio.h>
#include <stdlib.h>

// ADD THESE two forward declarations
int yylex();
int yyerror(char *s);

typedef struct node {
    char *op;
    int value;
    struct node *left;
    struct node *right;
} node;

node* createNode(char* op, node* left, node* right);
node* createLeaf(int value);
void postorder(node* root);
%}

%union {
    int num;
    struct node* ptr;
}

%token <num> NUMBER
%token PLUS MINUS MUL DIV LPAREN RPAREN

// ADD THESE — fixes the 16 shift/reduce conflicts
%left PLUS MINUS
%left MUL DIV

%type <ptr> expr

%%


input:
    expr { 
        postorder($1); 
        printf("\n"); 
    }
;

expr:
      expr PLUS expr   { $$ = createNode("+", $1, $3); }
    | expr MINUS expr  { $$ = createNode("-", $1, $3); }
    | expr MUL expr    { $$ = createNode("*", $1, $3); }
    | expr DIV expr    { $$ = createNode("/", $1, $3); }
    | LPAREN expr RPAREN { $$ = $2; }
    | NUMBER           { $$ = createLeaf($1); }
;

%%

// create operator node
node* createNode(char* op, node* left, node* right) {
    node* newnode = (node*)malloc(sizeof(node));
    newnode->op = op;
    newnode->left = left;
    newnode->right = right;
    return newnode;
}

// create leaf node
node* createLeaf(int value) {
    node* newnode = (node*)malloc(sizeof(node));
    newnode->value = value;
    newnode->left = NULL;
    newnode->right = NULL;
    newnode->op = NULL;
    return newnode;
}

// postorder traversal
void postorder(node* root) {
    if (!root) return;

    postorder(root->left);
    postorder(root->right);

    if (root->op)
        printf("%s ", root->op);
    else
        printf("%d ", root->value);
}

int main() {
    printf("Enter expression:\n");
    yyparse();
    return 0;
}

int yyerror(char *s) {
    printf("Error: %s\n", s);
    return 0;
}