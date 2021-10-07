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
%token CENT
%token CREAL
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
%left SUMA
%left RESTA
%token MULT
%token DIV
%right ASIGN
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
programa: DECLARE declaracion ENDDECLARE bloque | bloque
bloque: sentencia | sentencia  bloque 
declaracion: type variables PUNTOYC | type variables PUNTOYC declaracion 
type: INT|REAL|STRING
variables: ID| ID COMA variables
sentencia: asignacion PUNTOYC | asign_multiple PUNTOYC | iteracion | seleccion | entrada  PUNTOYC | salida PUNTOYC
asignacion: ID ASIGN expresion
asign_multiple:  ID ASIGN ID ASIGN multiple 
multiple: ID ASIGN asign_multiple expresion | ID ASIGN expresion | expresion
expresion: expresion_num | expresion_string
expresion_num: termino | expresion_num SUMA termino | expresion_num RESTA  termino
expresion_string: CSTRING CONCAT CSTRING | ID CONCAT CSTRING | ID CONCAT ID | CSTRING CONCAT ID
termino: factor | termino MULT factor | termino DIV factor
factor: ID | CENT | CREAL | PARENTA expresion PARENTC
comparador: MAYOR | MENOR | MENORIGUAL | MAYORIGUAL | IGUAL | DISTINTO
comparacion: PARENTA expresion PARENTC comparador PARENTA expresion PARENTC
comp_logico: PARENTA comparacion PARENTC AND PARENTA comparacion PARENTC | PARENTA comparacion PARENTC OR PARENTA comparacion PARENTC
condicion: NOT PARENTA condicion PARENTC| comparacion | comp_logico
iteracion: WHILE PARENTA condicion PARENTC LLAVEA bloque LLAVEC 
seleccion: IF PARENTA condicion PARENTC LLAVEA bloque LLAVEC ELSE LLAVEA bloque LLAVEC 
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
    if(input != NULL){
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