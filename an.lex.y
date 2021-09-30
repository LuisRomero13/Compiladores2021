%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>
    #include "y.tab.h"
    
    FILE * input;  
    FILE * lista_tokens; 
    FILE * tabla_simbolos; 
    FILE * tokens_unicos;
    char constanteEntera [40]; 
    char constanteReal [40];
    char constanteString [40]; 
    char IdPalabraReservada [40];
    char operador [40]; 
    char comparador [40]; 
    char otro[40];
    int estado_actual; 
    int estado_segundo;
    int estado_final; 
    int estado_error;
    int hay_error; 
    int position_row;
    char caracter; 
    struct Token {
    int number;
    char name[40];      
    char lexema[40];    
    char tipo[40];      
    char valor[40];     
    int longitud;       
    };
    struct Token token_confirmado;    
%}

%union {
    int number;
    char name[40];      
    char lexema[40];    
    char tipo[40];      
    char valor[40];     
    int longitud;       
}

%start programa
%token CSTRING 
%token WHILE
%token IF
%token ELSE
%token DECLARE
%token ENDDECLARE
%token REAL
%token INT
%token STRING
%token GET
%token PUT
%token ID
%token SUMA
%token RESTA
%token MULT
%token DIV
%token ASIGN
%token CONCAT
%token AND
%token OR
%token NOT
%token MAYOR
%token MENOR
%token MENORIGUAL
%token MAYORIGUAL
%token IGUAL
%token DISTINTO
%token PUNTOYC
%token LLAVEA
%token LLAVEC
%token PARENTA
%token PARENTC
%token COMA

%%
programa: DECLARE declaración ENDDCLARE bloque | bloque
bloque: sentencia | sentencia  bloque 
declaración: type variables PUNTOYC | type variables PUNTOYC declaración 
type: INT|REAL|STRING
variables: ID| ID COMA variables
sentencia: asignación PUNTOYC | iteración | selección | entrada  PUNTOYC | salida PUNTOYC
asignación: ID ASIGN expresión| ID asign_múltiple ASIGN expresión
asign_múltiple: ASIGN ID |ASIGN ID asign_múltiple
expresión: expresión_num | expresión_string
expresión_num: término | término SUMA expresión_num | término RESTA expresión_num
expresión_string: CSTRING CONCAT CSTRING | ID CONCAT CSTRING | ID CONCAT ID | CSTRING CONCAT ID
término: factor | término MULTI factor | término DIV factor
factor: ID | CENT | CREAL | PARENTA expresión_num PARENTC
comparador: MAYOR | MENOR | MENORIGUAL | MAYORIGUAL | IGUAL | DISTINTO
comparación: PARENTA expresión PARENTC comparador PARENTA expresión PARENTC
comp_lógico: PARENTA comparación PARENTC AND PARENTA comparación PARENTC | PARENTA comparación PARENTC OR PARENTA comparación PARENTC
condición: NOT PARENTA condición PARENTC| comparación | comp_lógico
iteración: WHILE PARENTA condición PARENTC LLAVEA bloque LLAVEC 
selección: IF PARENTA condición PARENTC LLAVEA bloque LLAVEC ELSE LLAVEA bloque LLAVEC 
entrada: PUT CSTRING | PUT CENT | PUT CREAL
salida: GET ID
%%

int yylex(){

}
int yyerror(char *s){
    rintf("Error de sintaxis\n");
    fprintf(stderr,"%s\n",s);
}
int main(){
    input = fopen("input.txt", "rb");
    if((input != NULL){
        while (feof(input) == 0) {
            yyparse();
            printf("\nCompilacion Ok\n");
        }
    }
    else {
         perror("Ocurrio un error al intentar abrir el archivo\n");
         return 1;
    }
    fclose(input);
    return (0);
}