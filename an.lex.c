////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

// librerias
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// prototipo de funciones
int getFirstState(char letra);
int getByEvent(char letra);
struct Token getTokenId();
struct Token getTokenInt();
struct Token getTokenReal();
struct Token getTokenString();
struct Token getTokenWords();
struct Token getTokenOp();
struct Token getTokenComp();
struct Token getTokenOther();
void cleanTokens();

// estructuras
struct Token
{
    int number;
    char name[25];  // Maximo == 25 caracteres (Guarda el )
};

// declaracion de los arreglos que se encargan de almacenar los tokens
// ver archivo TOKENS.doc del Tp
    char identificador [30];
    char constanteEntera [30];
    char constanteReal [30];
    char constanteString [30];
    char palabrasReservada [30];
    char operador [30];
    char comparador [30];
    char otro[30];

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////

int main(){ // INICIO MAIN
    int numeroEvento = 0;
    int terminarArmadoToken = 0;
    int numeroLetra = 0;   

    // Apertura del archivo
    FILE * input = fopen("input.txt", "rb");

    if(input != NULL){

        int avanza = 1;  // 1 es true, 0 es false

        while (feof(input) == 0)
        {
            char caracter;
            caracter = fgetc(input);

            // Omite espacios, salto de linea y numeral (comentarios)
            if((avanza == 1) && (caracter != ' ') && (caracter != '\n') && (caracter !='#')){ 
                int numeroEstado = 0;
                numeroEstado = getFirstState(caracter);
                printf("%d ", numeroEstado);
            }
            else if(caracter == '/'){
                avanza = 0; // si es comentario, le digo al programa que no siga leyendo caracteres
            }
            else if((caracter == '\n') || (caracter == '\t')){
                avanza = 1; // si llega al final de una linea, le digo al programa que no siga leyendo caracteres
            }
        }
        printf("\nFin de la lectura del archivo\n");
        fclose(input);
    }
    else{
        perror("Ocurrio un error al intentar abrir el archivo\n");
        return 1;
    }
}    // FIN MAIN

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//      FUNCIONES       //
////////////////////////////////////////////////////////////////////////////////////////////////////////////

int getFirstState(char letra) {
    // Si letra ......

    // Si es un caracter, devuelve valor 1
    if( isalpha(letra) ) return 1;  

    // Si es un digito, devuelve valor 2
	if( isdigit(letra) ) return 2; 

    // Si es comilla, devuelve valor 4
	if(letra == '"') return 4; 

    // Si es operador mayor que, devuelve 5
	if(letra == '>') return 5;

    // Si es operador menor que, devuelve 6
	if(letra == '<') return 6;

    // Si es operador igual, devuelve 7
	if(letra == '=') return 7;

    // Si es barra invertida, devuelve 8
	if(letra == '/') return 8;

    // Si es operador de suma, devuelve 10
	if(letra == '+') return 10;

    // Si es ampersand, devuelve 13
	if(letra == '&') return 13;

    // Si es barra vertical, devuelve 15
	if(letra == '|') return 15;

    // Si es exclamacion, devuelve 15
	if(letra == '!') return 17;

    // Si es parentesis que abre, devuelve 18
	if(letra == '(' ) return 18;

    // Si es parentesis que cierra, devuelve 19
	if(letra == ')' ) return 19;

    // Si es corchete que abre, devuelve 20
	if(letra == '[' ) return 20;

    // Si es corchete que cierra, devuelve 21
	if(letra == ']' ) return 21;

    // Si es llave que abre, devuelve 22
	if(letra == '{' ) return 22;

    // Si es llave que cierra, devuelve 23
	if(letra == '}' ) return 23;

    // Si es operador resta, devuelve 24
	if(letra == '-' ) return 24;

    // Si es operador multiplicacion, devuelve 25
	if(letra == '*' ) return 25;

    // Si es una coma, devuelve 26
	if(letra == ',' ) return 26;

    // Si es punto y coma, devuelve 27
	if(letra == ';' ) return 27;
	
    // Si no cumple ninguna condicion, por defecto, retorna un -1 (error)
    return -1;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int getByEvent(char letra){
    // Si letra ......
    // Los eventos corresponden a la fila de la matriz de procesos de funciones (que sera ubicada abajo de todo)
    // Los valores retornados representan al numero de evento, NO al numero de estado en si

    // Si es un caracter, devuelve valor 1
    if( isalpha(letra) ) return 1;  

    // Si es un digito, devuelve valor 2
	if( isdigit(letra) ) return 2; 

    // Si es punto flotante (real), devuelve valor 3
	if(letra == '.') return 3; 

    // Si es comilla, devuelve valor 4
	if(letra == '"') return 4; 

    // Si es operador mayor que, devuelve 5
	if(letra == '>') return 5;

    // Si es operador menor que, devuelve 6
	if(letra == '<') return 6;

    // Si es operador igual, devuelve 7
	if(letra == '=') return 7;

    // Si es barra invertida, devuelve 8
	if(letra == '/') return 8;

    // Si es numeral, devuelve 9
	if(letra == '#') return 9;

    // Si es operador de suma, devuelve 10
	if(letra == '+') return 10;

    // Si es ampersand, devuelve 11
	if(letra == '&') return 11;

    // Si es barra vertical, devuelve 12
	if(letra == '|') return 12;

    // Si es exclamacion, devuelve 13
	if(letra == '!') return 13;

    // Si es parentesis que abre, devuelve 14
	if(letra == '(' ) return 14;

    // Si es parentesis que cierra, devuelve 15
	if(letra == ')' ) return 15;

    // Si es corchete que abre, devuelve 16
	if(letra == '[' ) return 16;

    // Si es corchete que cierra, devuelve 17
	if(letra == ']' ) return 17;

    // Si es llave que abre, devuelve 18
	if(letra == '{' ) return 18;

    // Si es llave que cierra, devuelve 19
	if(letra == '}' ) return 19;

    // Si es operador resta, devuelve 20
	if(letra == '-' ) return 20;

    // Si es operador multiplicacion, devuelve 21
	if(letra == '*' ) return 21;

    // Si es una coma, devuelve 22
	if(letra == ',' ) return 22;

    // Si es punto y coma, devuelve 23
	if(letra == ';' ) return 23;
	
    // Si no cumple ninguna condicion, por defecto, retorna 24, es decir, caracter no especificado
    return 24;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct Token getTokenWords() {
    struct Token token;

    // Si no esta vacio
    if( strlen( palabrasReservada ) > 0 ) {
        // Si palabrasReservada es WHILE
        if( strcmp( palabrasReservada , "while" ) == 0) {
            token.number = 260; // guardo numero de token
            strcpy( token.name, "<WHILE>" ); // guardo nombre del token
            return token;
        }

        // Si palabrasReservada es IF
        if( strcmp( palabrasReservada , "if" ) == 0) {
            token.number = 261; // guardo numero de token
            strcpy( token.name , "<IF>" ); // guardo nombre del token
            return token;
        }

        // Si palabrasReservada es ELSE
        if( strcmp( palabrasReservada , "else" ) == 0) {
            token.number = 262; // guardo numero de token
            strcpy( token.name , "<ELSE>" ); // guardo nombre del token
            return token;
        }

        // Si palabrasReservada es DECLARE
        if( strcmp( palabrasReservada , "declare" ) == 0) {
            token.number = 263; // guardo numero de token
            strcpy( token.name , "<DECLARE>" ); // guardo nombre del token
            return token;
        }

        // Si palabrasReservada es ENDDECLARE
        if( strcmp( palabrasReservada , "enddeclare" ) == 0) {
            token.number = 264; // guardo numero de token
            strcpy( token.name , "<ENDDECLARE>" ); // guardo nombre del token
            return token;
        }

        // Si palabrasReservada es FOR
        if( strcmp( palabrasReservada , "for" ) == 0) {
            token.number = 265; // guardo numero de token
            strcpy( token.name , "<FOR>" ); // guardo nombre del token
            return token;
        }    

        // Si palabrasReservada es REAL
        if( strcmp( palabrasReservada , "real" ) == 0) {
            token.number = 266; // guardo numero de token
            strcpy( token.name , "<REAL>" ); // guardo nombre del token
            return token;
        }      

        // Si palabrasReservada es INT
        if( strcmp( palabrasReservada , "int" ) == 0) {
            token.number = 267; // guardo numero de token
            strcpy( token.name , "<INT>" ); // guardo nombre del token
            return token;
        } 

        // Si palabrasReservada es STRING
        if( strcmp( palabrasReservada , "string" ) == 0) {
            token.number = 268; // guardo numero de token
            strcpy( token.name , "<STRING>" ); // guardo nombre del token
            return token;
        } 
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct Token getTokenOp() {
    struct Token token;
    
    // Si no esta vacio
    if( strlen(operador) > 0) {
        
        // Si operador es +
        if( strcmp( operador , "+" ) == 0) {
            token.number = 269; // guardo numero de token
            strcpy( token.name , "<SUMA>" ); // guardo nombre del token
            return token;
        } 

        // Si operador es -
        if( strcmp( operador , "-" ) == 0) {
            token.number = 270; // guardo numero de token
            strcpy( token.name , "<RESTA>" ); // guardo nombre del token
            return token;
        } 

        // Si operador es *
        if( strcmp( operador , "*" ) == 0) {
            token.number = 271; // guardo numero de token
            strcpy( token.name , "<MULT>" ); // guardo nombre del token
            return token;
        } 

        // Si operador es /
        if( strcmp( operador , "/" ) == 0) {
            token.number = 272; // guardo numero de token
            strcpy( token.name , "<DIV>" ); // guardo nombre del token
            return token;
        } 

        // Si operador es =
        if( strcmp( operador , "=" ) == 0) {
            token.number = 273; // guardo numero de token
            strcpy( token.name , "<ASIGN>" ); // guardo nombre del token
            return token;
        }

        // Si operador es ++
        if( strcmp( operador , "++" ) == 0) {
            token.number = 274; // guardo numero de token
            strcpy( token.name , "<CONCAT>" ); // guardo nombre del token
            return token;
        }

        // Si operador es &&
        if( strcmp( operador , "&&" ) == 0) {
            token.number = 275; // guardo numero de token
            strcpy( token.name , "<AND>" ); // guardo nombre del token
            return token;
        }

        // Si operador es ||
        if( strcmp( operador , "||" ) == 0) {
            token.number = 276; // guardo numero de token
            strcpy( token.name , "<OR>" ); // guardo nombre del token
            return token;
        }

        // Si operador es !
        if( strcmp( operador , "!" ) == 0) {
            token.number = 277; // guardo numero de token
            strcpy( token.name , "<NOT>" ); // guardo nombre del token
            return token;
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct Token getTokenComp(){
    struct Token token;
    
    // Si no esta vacio
    if( strlen(comparador) > 0) {
        
        // Si comparador es >
        if( strcmp( operador , ">" ) == 0) {
            token.number = 278; // guardo numero de token
            strcpy( token.name , "<MAYOR>" ); // guardo nombre del token
            return token;
        }

        // Si comparador es <
        if( strcmp( operador , "<" ) == 0) {
            token.number = 279; // guardo numero de token
            strcpy( token.name , "<MENOR>" ); // guardo nombre del token
            return token;
        }

        // Si comparador es <
        if( strcmp( operador , "<=" ) == 0) {
            token.number = 280; // guardo numero de token
            strcpy( token.name , "<MENORIGUAL>" ); // guardo nombre del token
            return token;
        }

        // Si comparador es >
        if( strcmp( operador , ">=" ) == 0) {
            token.number = 281; // guardo numero de token
            strcpy( token.name , "<MAYORIGUAL>" ); // guardo nombre del token
            return token;
        }

        // Si comparador es ==
        if( strcmp( operador , "==" ) == 0) {
            token.number = 282; // guardo numero de token
            strcpy( token.name , "<IGUAL>" ); // guardo nombre del token
            return token;
        }

        // Si comparador es !=
        if( strcmp( operador , "!=" ) == 0) {
            token.number = 283; // guardo numero de token
            strcpy( token.name , "<DISTINTO>" ); // guardo nombre del token
            return token;
        }
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct Token getTokenOther(){
    struct Token token;

    // Si no esta vacio
    if( strlen(otro) > 0) {
        
        // Si otro es ; 
        if( strcmp( otro, ";" ) == 0 ) {
            token.number = 284;      // guardo numero de token
            strcpy( token.name , "<PUNTOYC>" );  // guardo nombre del token
            return token;
        }

        // Si otro es {
        if( strcmp( otro , "{" ) == 0) {
            token.number = 285;      // guardo numero de token
            strcpy( token.name , "<LLAVEA>" );  // guardo nombre del token
            return token;
        }

        // Si otro es }
        if( strcmp( otro , "}" ) == 0 ) {
            token.number = 286;      // guardo numero de token
            strcpy( token.name , "<LLAVEC>" );  // guardo nombre del token
            return token;
        }

        // Si otro es (
        if( strcmp( otro , "(" ) == 0 ) {
            token.number = 287;      // guardo numero de token
            strcpy( token.name , "<PARENTA>" );  // guardo nombre del token
            return token;
        }

        // Si otro es )
        if( strcmp( otro , ")" ) == 0 ) {
            token.number = 288;      // guardo numero de token
            strcpy( token.name , "<PARENTC>" );  // guardo nombre del token
            return token;
        }

        // Si otro es ,
        if( strcmp( otro , "," ) == 0 ) {
            token.number = 289;      // guardo numero de token
            strcpy( token.name , "<COMA>" );  // guardo nombre del token
            return token;
        }

        // Si otro es /#
        if( strcmp( otro , "/#" ) == 0 ) {
            token.number = 290;      // guardo numero de token
            strcpy( token.name , "<COMENTA>" );  // guardo nombre del token
            return token;
        }

        // Si otro es #/
        if( strcmp( otro , "#/" ) == 0 ) {
            token.number = 291;      // guardo numero de token
            strcpy( token.name , "<COMENTC>" );  // guardo nombre del token
            return token;
        }
    }       
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
