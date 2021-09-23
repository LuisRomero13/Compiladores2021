////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// librerias
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// prototipo de funciones
int yylex(); int getColumnByEvent(char letra); void cleanTokens();
void(*tabla_funciones[28][26])(); int tabla_estados [28][26];

struct Token getTokenIdWords();struct Token getTokenInt();
struct Token getTokenReal();struct Token getTokenString();
struct Token getTokenOp();struct Token getTokenComp(); 
struct Token getTokenOther(); void buildToken();

void F1();void F2();void F3();void F4();void F5();void F6();void F7();
void F8();void F9();void F10();void F11();void F12();void F13();void F15();
void F17();void F18();void F19();void F20();void F21();void F22();void F23();
void F24();void F25();void F26();void F27();void ERROR();void F(); 
void showTokens(); void showSymbolTable();

// estructuras
struct Token {
    int number;         // se usar para imprimir los tokens 
    char name[25];      // se usar para imprimir los tokens 
    char lexema[25];    // se usar para imprimir la tabla de simbolos
    char tipo[25];      // se usar para imprimir la tabla de simbolos
    char valor[25];     // se usar para imprimir la tabla de simbolos
    int longitud;       // se usar para imprimir la tabla de simbolos
};

// declaracion de los arreglos que se encargan de almacenar los tokens (ver archivo TOKENS.doc del Tp)
    char constanteEntera [30] = {0};
    char constanteReal [30] = {0};
    char constanteString [30] = {0};
    char IdPalabraReservada [30] = {0};
    char operador [30] = {0};
    char comparador [30] = {0};
    char otro[30] = {0};

// variables globales a todo el programa
    char caracter = ' ';
    int estado_actual = 0;
    int estado_segundo = 0;  // para ver que token formara
    int estado_final = 28;
    int estado_error = 29;
    struct Token token_confirmado;

// archivos
    FILE *      input       = NULL;   
    FILE * lista_tokens     = NULL;
    FILE * tabla_simbolos   = NULL;
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
int main(){ // INICIO MAIN

    input = fopen("input.txt", "rb");
    lista_tokens = fopen("lista_tokens.txt", "w");
    tabla_simbolos = fopen("tabla_simbolos.txt", "w");

    if((input != NULL)||(lista_tokens != NULL)||(tabla_simbolos != NULL)){
        fprintf (lista_tokens, "%s\t\t%s\n\n", "ID", "NOMBRE");
        fprintf (tabla_simbolos, "%s\t\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s\n\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
        while (feof(input) == 0) {
            if((caracter = fgetc(input)) != EOF)
                yylex();
        }
        printf("\nFin de la lectura del archivo\n");
        fclose(input);
        fclose(lista_tokens);
        fclose(tabla_simbolos);
        return 0;
    }
    else{
        perror("Ocurrio un error al intentar abrir el archivo\n");
        return 1;
    }
}    // FIN MAIN
////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//      FUNCIONES       //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
int yylex() {
    int num_col = getColumnByEvent(caracter);
    //printf("caracter encontrado: %c\n", caracter);
    //printf("numero estado actual: %d\n", estado_actual);
    //printf("numero columna: %d\n", num_col);
    int num_row = estado_actual; // al principio, estado actual = 0
    (*tabla_funciones[num_row][num_col])();  // ejecuta la funcion correspondiente
    estado_actual = tabla_estados[num_row][num_col]; // actualizamos estado actual
    //printf("numero estado despues: %d\n\n", estado_actual);

    if((estado_segundo == 0)||(estado_actual == 3)||(estado_actual == 9)||(estado_actual == 10)||(estado_actual == 12)){
        estado_segundo = estado_actual;
    }
        
    if(estado_actual == estado_final){
        //printf("Llegue al estado final, entonces reseteo el automata\n");
        buildToken();
        estado_actual = 0; estado_segundo = 0; // reseteamos el automata
        
        if((caracter != ' ')&&(caracter != '\t')&&(caracter != '\n')&&(constanteString[0] == '\0')&&(comparador[1] == '\0')) // si comparador[1] no tiene contenido 
            ungetc(caracter, input);
        cleanTokens();
    }
    if(estado_actual == estado_error) {
        printf("¡Error de compilacion!\n");
        exit(1);
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int getColumnByEvent(char letra){
    // Si letra ......
    // Los eventos corresponden a la columna de la matriz de procesos de funciones (que sera ubicada abajo de todo)
    // Los valores retornados representan al numero de evento, NO al numero de estado en si
    if( isalpha(letra) ) return 0;      // Si es un caracter, devuelve valor 0  
	if( isdigit(letra) ) return 1;      // Si es un digito, devuelve valor 1
	if(letra == '_')    return 2;       // Si es un guion bajo, devuelve valor 2 
	if(letra == '.')    return 3;       // Si es un operador punto, devuelve valor 3  
	if(letra == '"')    return 4;       // Si es un comilla doble, devuelve valor 4 
	if(letra == '>')    return 5;       // Si es operador mayor que, devuelve valor 5 
	if(letra == '<')    return 6;       // Si es operador menor que, devuelve 6
	if(letra == '=')    return 7;       // Si es operador igual, devuelve 7
	if(letra == '/')    return 8;       // Si es barra invertida, devuelve 8
	if(letra == '#')    return 9;       // Si es numeral, devuelve 9
	if(letra == '+')    return 10;      // Si es operador de suma, devuelve 10
	if(letra == '&')    return 11;      // Si es ampersand, devuelve 11
	if(letra == '|')    return 12;      // Si es barra vertical, devuelve 12
	if(letra == '!')    return 13;      // Si es exclamacion, devuelve 13 
	if(letra == '(' )   return 14;      // Si es parentesis que abre, devuelve 14
	if(letra == ')' )   return 15;      // Si es parentesis que cierra, devuelve 15    
	if(letra == '[' )   return 16;      // Si es corchete que abre, devuelve 16
	if(letra == ']' )   return 17;      // Si es corchete que cierra, devuelve 17          
	if(letra == '{' )   return 18;      // Si es llave que abre, devuelve 18
	if(letra == '}' )   return 19;      // Si es llave que cierra, devuelve 19
	if(letra == '-' )   return 20;      // Si es operador resta, devuelve 20
	if(letra == '*' )   return 21;      // Si es operador multiplicacion, devuelve 21
	if(letra == ',' )   return 22;      // Si es una coma, devuelve 22
	if(letra == ';' )   return 23;      // Si es punto y coma, devuelve 23
    //if((letra == '\t') || (letra == ' '))  return 24;
    //if(letra == '\n')   return 25;
    return 24;                          // Si no cumple ninguna condicion, por defecto, retorna 24, es decir, caracter no especificado                                  
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void buildToken(){
    if(estado_segundo == 1){
        token_confirmado = getTokenIdWords();
        showTokens();
        showSymbolTable();
    }
    if(estado_segundo == 2) {
        token_confirmado = getTokenInt();
        showTokens();
        showSymbolTable();
    }
    if(estado_segundo == 3) {
        token_confirmado = getTokenReal();
        showTokens();
        showSymbolTable();
    }
    if(estado_segundo == 4) {
        token_confirmado = getTokenString();
        showTokens();
        showSymbolTable();
    }
    if(((estado_segundo == 7)&&(comparador[0] != '='))||(estado_segundo == 8)||((estado_segundo >= 11)&&(estado_segundo <= 17))||((estado_segundo >= 24)&&(estado_segundo <= 25))){
        token_confirmado = getTokenOp();  // Token OPERADORES
        showTokens();
        showSymbolTable();
    }
    if((estado_segundo == 7)&&(comparador[0] == '=')) {  // si comparador tiene un igual significado que se trata de un comparador
        token_confirmado = getTokenComp();  // Token OPERADORES
        showTokens();
        showSymbolTable();
    }
    if(((estado_segundo >= 18)&&(estado_segundo <= 23))||((estado_segundo >= 26)&&(estado_segundo<=27))){
        token_confirmado = getTokenOther();  // Token Otros
        showTokens();
        showSymbolTable();
    }
    if((estado_segundo >= 9)&&(estado_segundo <= 10)){
        printf("¡Es un comentario!\n");
    }
    if((estado_segundo >= 5)&&(estado_segundo <= 6)){
        token_confirmado = getTokenComp();  // Token COMPARADORES
        showTokens();
        showSymbolTable();
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void cleanTokens() {
    for(int i=0; i<30;  i++) {
        constanteEntera[i] = '\0';
        constanteReal[i] = '\0';
        constanteString[i] = '\0';
        IdPalabraReservada[i] = '\0';
        operador[i] = '\0';
        comparador[i] = '\0';
        otro[i] = '\0';
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenInt() {
    struct Token token;
    if( strlen( constanteEntera ) > 0 ) {
        token.number = 257; // guardo numero de token
        strcpy( token.name, "<CENT>" ); // guardo nombre del token
        strcpy ( token.lexema, "_");
        strcat( token.lexema, constanteEntera);
        strcpy( token.valor, constanteEntera);
        return token;
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenReal() {
    struct Token token;
    if( strlen( constanteReal ) > 0 ) {
        token.number = 258; // guardo numero de token
        strcpy( token.name, "<CREAL>" ); // guardo nombre del token
        strcpy ( token.lexema, "_");
        strcat( token.lexema, constanteReal);
        strcpy( token.valor, constanteReal);
        return token;
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenString() {
    struct Token token;
    if( strlen( constanteString ) > 0 ) {
        token.number = 259; // guardo numero de token
        strcpy( token.name, "<CSTRING>" ); // guardo nombre del token
        strcpy ( token.lexema, "_");
        strcat( token.lexema, constanteString); 
        strcpy ( token.tipo, "String");
        strcat( token.valor, constanteString);
        strcat ( token.valor, "\"");
        token.longitud = strlen(constanteString);
        return token;
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenIdWords() {
    struct Token token;
    if( strlen( IdPalabraReservada ) > 0 ) {             // Si no esta vacio 
        if( strcmp( IdPalabraReservada , "while" ) == 0) {           // Si palabrasReservada es WHILE
            token.number = 260; // guardo numero de token
            strcpy( token.name, "<WHILE>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( IdPalabraReservada , "if" ) == 0) {              // Si palabrasReservada es IF
            token.number = 261; // guardo numero de token   
            strcpy( token.name , "<IF>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( IdPalabraReservada , "else" ) == 0) {            // Si palabrasReservada es ELSE
            token.number = 262; // guardo numero de token   
            strcpy( token.name , "<ELSE>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( IdPalabraReservada , "declare" ) == 0) {         // Si palabrasReservada es DECLARE
            token.number = 263; // guardo numero de token
            strcpy( token.name , "<DECLARE>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( IdPalabraReservada , "enddeclare" ) == 0) {      // Si palabrasReservada es ENDDECLARE
            token.number = 264; // guardo numero de token
            strcpy( token.name , "<ENDDECLARE>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( IdPalabraReservada , "for" ) == 0) {         // Si palabrasReservada es FOR
            token.number = 265; // guardo numero de token
            strcpy( token.name , "<FOR>" ); // guardo nombre del token
            return token;
        }    
        if( strcmp( IdPalabraReservada , "real" ) == 0) {        // Si palabrasReservada es REAL
            token.number = 266; // guardo numero de token
            strcpy( token.name , "<REAL>" ); // guardo nombre del token
            return token;
        }      
        if( strcmp( IdPalabraReservada , "int" ) == 0) {         // Si palabrasReservada es INT
            token.number = 267; // guardo numero de token
            strcpy( token.name , "<INT>" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( IdPalabraReservada , "string" ) == 0) {      // Si palabrasReservada es STRING
            token.number = 268; // guardo numero de token
            strcpy( token.name , "<STRING>" ); // guardo nombre del token
            return token;
        } 
        if( strlen( IdPalabraReservada ) > 0 ) {             // Si no esta vacio 
            token.number = 256; // guardo numero de token
            strcpy( token.name, "<ID>" ); // guardo nombre del token
            strcpy ( token.lexema, "_");
            strcat( token.lexema, IdPalabraReservada); 
            strcpy ( token.tipo, " ");
            strcpy ( token.valor, " ");
            token.longitud = strlen(IdPalabraReservada);
            return token;
        }
    } 
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenOp() {
    struct Token token;
    if( strlen(operador) > 0) {         // Si no esta vacio
        if( strcmp( operador , "+" ) == 0) {        // Si operador es +
            token.number = 269; // guardo numero de token
            strcpy( token.name , "<SUMA>" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( operador , "-" ) == 0) {        // Si operador es -
            token.number = 270; // guardo numero de token
            strcpy( token.name , "<RESTA>" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( operador , "*" ) == 0) {        // Si operador es *
            token.number = 271; // guardo numero de token
            strcpy( token.name , "<MULT>" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( operador , "/" ) == 0) {        // Si operador es /
            token.number = 272; // guardo numero de token
            strcpy( token.name , "<DIV>" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( operador , "=" ) == 0) {        // Si operador es =
            token.number = 273; // guardo numero de token
            strcpy( token.name , "<ASIGN>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( operador , "++" ) == 0) {       // Si operador es ++
            token.number = 274; // guardo numero de token
            strcpy( token.name , "<CONCAT>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( operador , "&&" ) == 0) {       // Si operador es &&
            token.number = 275; // guardo numero de token
            strcpy( token.name , "<AND>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( operador , "||" ) == 0) {       // Si operador es ||
            token.number = 276; // guardo numero de token
            strcpy( token.name , "<OR>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( operador , "!" ) == 0) {        // Si operador es !
            token.number = 277; // guardo numero de token
            strcpy( token.name , "<NOT>" ); // guardo nombre del token
            return token;
        }
    } 
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenComp(){
    struct Token token;
    if( strlen(comparador) > 0) {           // Si no esta vacio
        if( strcmp( comparador , ">" ) == 0) {         // Si comparador es >
            token.number = 278; // guardo numero de token
            strcpy( token.name , "<MAYOR>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( comparador , "<" ) == 0) {        // Si comparador es <
            token.number = 279; // guardo numero de token
            strcpy( token.name , "<MENOR>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( comparador , "<=" ) == 0) {       // Si comparador es <
            token.number = 280; // guardo numero de token
            strcpy( token.name , "<MENORIGUAL>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( comparador , ">=" ) == 0) {       // Si comparador es >
            token.number = 281; // guardo numero de token
            strcpy( token.name , "<MAYORIGUAL>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( comparador , "==" ) == 0) {       // Si comparador es ==
            token.number = 282; // guardo numero de token
            strcpy( token.name , "<IGUAL>" ); // guardo nombre del token
            return token;
        }
        if( strcmp( comparador , "<>" ) == 0) {           // Si comparador es !=
            token.number = 283; // guardo numero de token
            strcpy( token.name , "<DISTINTO>" ); // guardo nombre del token
            return token;
        }
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenOther(){
    struct Token token;
    if( strlen(otro) > 0) {         // Si no esta vacio
        if( strcmp( otro, ";" ) == 0 ) {        // Si otro es ; 
            token.number = 284;      // guardo numero de token
            strcpy( token.name , "<PUNTOYC>" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "{" ) == 0) {        // Si otro es {
            token.number = 285;      // guardo numero de token
            strcpy( token.name , "<LLAVEA>" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "}" ) == 0 ) {       // Si otro es }
            token.number = 286;      // guardo numero de token
            strcpy( token.name , "<LLAVEC>" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "(" ) == 0 ) {       // Si otro es (
            token.number = 287;      // guardo numero de token
            strcpy( token.name , "<PARENTA>" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , ")" ) == 0 ) {       // Si otro es )
            token.number = 288;      // guardo numero de token
            strcpy( token.name , "<PARENTC>" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "," ) == 0 ) {       // Si otro es ,
            token.number = 289;      // guardo numero de token
            strcpy( token.name , "<COMA>" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "/#" ) == 0 ) {      // Si otro es /#
            token.number = 290;      // guardo numero de token
            strcpy( token.name , "<COMENTA>" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "#/" ) == 0 ) {      // Si otro es #/
            token.number = 291;      // guardo numero de token
            strcpy( token.name , "<COMENTC>" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "[" ) == 0 ) {      // Si otro es [
            token.number = 292;      // guardo numero de token
            strcpy( token.name , "<CORCHEA>" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "]" ) == 0 ) {      // Si otro es ]
            token.number = 293;      // guardo numero de token
            strcpy( token.name , "<CORCHEC>" );  // guardo nombre del token
            return token;
        }
    }       
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
int tabla_estados [28][26] = {
//estado  	letra	digit	    _	    .	    "	    >	    <	    =	    /	    #	    +	    &	    |	    !	    (	    )	    [	    ]	    {	    }	    -	    *	    ,	    ;       /t      /n
/*estado0*/ 	1,      2,	    29,	    29,	    4,	    5,	    6,	    7,	    8,	    29,	    11,	    13,	    15,	    17,	    18,	    19,	    20,	    21,	    22,	    23,	    24,	    25,	    26,	    27,     28,     28,
/*estado1*/ 	1,	    1,	    1,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,
/*estado2*/	    29,	    2,	    28,	    3,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,
/*estado3*/	    29,	    3,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,
/*estado4*/	    4,	    4,	    4,	    4,	    28,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,      4,      4,      
/*estado5*/ 	28,	    28,	    28,	    29,	    29,	    29,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     28,     
/*estado6*/ 	28,	    28,	    28,	    29,	    29,	    28,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     28,     
/*estado7*/ 	28,	    28,	    28,	    29,	    29,	    29,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     28,     
/*estado8*/ 	28,	    28,	    28,   	28,	    28,	    28,	    28,	    28,	    28,	    9,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     29,     29,     
/*estado9*/	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    10,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,   	9,	    9,	     9,     9,      9,      
/*estado10*/	9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    0,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,      9,	    9,	     9,     9,      9,      
/*estado11*/	28,	    28,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    12,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     29,     29,     
/*estado12*/	28,	    29,	    28,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     29,     29,     
/*estado13*/	29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    14,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     29,     29,     
/*estado14*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    29,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,    	28,	    28,	    28,	    28,     28,     28,     
/*estado15*/    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    16,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     28,       
/*estado16*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    29,	    28,	    28,   	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,       
/*estado17*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,            
/*estado18*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,     
/*estado19*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,     
/*estado20*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,   	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,     
/*estado21*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,     
/*estado22*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,     
/*estado23*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,     
/*estado24*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,     
/*estado25*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,     
/*estado26*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,        
/*estado27*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     28,               
            };
////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Se omite F14 y F16
void(*tabla_funciones[28][26])() = {
//	    letra	digito	_	    .	    "	    >	    <	    =	    /	    #	    +	    &	    |	    !	    (	    )	    [	    ]	    {	    }	    -	    *	    ,	    ;       /t      /n
/*F0*/	F1,	    F2,	    ERROR,	ERROR,	F4,	    F5,	    F6,	    F7,	    F8,	    ERROR,	F11,	F13,	F15,	F17,	F18,	F19,	F20,	F21,	F22,	F23,	F24,	F25,	F26,	F27,    F,      F,
/*F1*/	F1,	    F1,	    F1,	    F,	    F,   	F,	    F,	    F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,   	F,	    F,      F,      F,
/*F2*/	ERROR,	F2,	    F,	    F3,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F3*/	ERROR,	F3,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F4*/	F4,	    F4,	    F4,	    F4,	    F,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,     F4,     F4,
/*F5*/	F,	    F,	    F,	    ERROR,	ERROR,	ERROR,	ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      F,
/*F6*/	F,	    F,	    F,	    ERROR,	ERROR,	F,	    ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      F,
/*F7*/	F,	    F,	    F,	    ERROR,	ERROR,	ERROR,	ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      F,
/*F8*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F9,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      ERROR,  ERROR,
/*F9*/	F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F10,	F9,	    F9,	    F9,	    F9,   	F9,	    F9,	    F9,	    F9,	    F9,	    F9,   	F9,	    F9,	    F9,  	F9,     F9,     F9,     
/*F10*/	F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,     F9,     F9,
/*F11*/	F,   	F,	    F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	F12,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  ERROR,  ERROR,
/*F12*/	F,	    ERROR,	F,	    ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  ERROR,  ERROR,
/*F13*/	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  ERROR,  ERROR,
/*F14*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    ERROR,	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,    	F,	    F,	    F,	    F,      F,      F,     
/*F15*/	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      F,
/*F16*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    ERROR,	F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,       
/*F17*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F18*/	F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,  	F,	    F,	    F,	    F,      F,      F,
/*F19*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F20*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F21*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F22*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F23*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F24*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F25*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F26*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
/*F27*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      F,
        };
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F1(){  // IDENTIFICADOR, PALABRA RESERVADA
    IdPalabraReservada[strlen(IdPalabraReservada)] = caracter;   // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter en la posicion 0 para formar una palabra RESERVADA
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F2(){  //  DIGITO
    constanteEntera[strlen(constanteEntera)] = caracter;    // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer digito en la posicion 0
    //ok
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F3(){  // REALES
    if(caracter == '.') {
        strcpy(constanteReal, constanteEntera);  // hago una copia de los digitos enteros en los reales
    }
    constanteReal[strlen(constanteReal)] = caracter;    // voy formando el digito de tipo real
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F4(){    // STRING "  "
    constanteString[strlen(constanteString)] = caracter;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F5(){ // COMPARADOR mayor que >
    comparador[strlen(comparador)] = caracter;  // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OPERADOR en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F6(){ // COMPARADOR menor que <
    comparador[strlen(comparador)] = caracter;  // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OPERADOR en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F7(){  // OPERADOR Asignacion =
    operador[strlen(operador)] = caracter;   // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter COMPARADOR en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F8(){  // OPERADOR division u OTRO comentario
    operador[strlen(operador)] = caracter;      // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OPERADOR (division) en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F9(){  // OTRO Comentario que
     if(caracter == '#') {
        strcpy(otro, operador);  // hago una copia del operador / en otro
    }
    otro[strlen(otro)] = caracter;    // voy formando el token comentario que abre /#  
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F10(){
    otro[strlen(otro)] = caracter;    // # forma parte del contenido de los comentarios
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F11(){     // OPERADOR SUMA +
    operador[strlen(operador)] = caracter; // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OPERADOR en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F12(){     // OPERADOR CONCATENADOR ++
    // Formo los comentarios, de lo contrario se considera operador division /
    if ((operador[0] == '+') && (caracter == '+')) {     // comparador tiene un solo caracter
         operador[1] = caracter;  // Formo el operador concatenador ++
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F13(){     // OPERADOR AND &
    operador[strlen(operador)] = caracter; // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OPERADOR en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F15(){     // OPERADOR OR &
    operador[strlen(operador)] = caracter; // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OPERADOR en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F17(){     // OPERADOR NOT !
    operador[strlen(operador)] = caracter; // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OPERADOR en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F18(){     // OTRO Parentesis que abre (
    otro[strlen(otro)] = caracter;      // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OTRO en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F19(){     // OTRO Parentesis que cierra )
    otro[strlen(otro)] = caracter;      // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OTRO en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F20(){     // OTRO Corchete que abre [
    otro[strlen(otro)] = caracter;      // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OTRO en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F21(){     // OTRO Corchete que cierra ]
    otro[strlen(otro)] = caracter;      // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OTRO en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F22(){     // OTRO Llave que abre {
    otro[strlen(otro)] = caracter;      // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OTRO en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F23(){     //OTRO Llave que cierra )
    otro[strlen(otro)] = caracter;      // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OTRO en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F24(){     // OPERADOR RESTA -
    operador[strlen(operador)] = caracter;   // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OPERADOR en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F25(){     // OPERADOR MULTIPLICACION *
    operador[strlen(operador)] = caracter;   // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OPERADOR en la posicion 0
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F26(){     // OTRO coma ,
    otro[strlen(otro)] = caracter;      // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OTRO en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F27(){     // OTRO punto y coma ;
    otro[strlen(otro)] = caracter;      // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter OTRO en la posicion 0
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void ERROR(){
    printf("Error de compilación\n");
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F(){
    // Formo los comparadores >= (mayor igual), <= (menor igual)
    if (((comparador[0] == '>')||(comparador[0] == '<')) && (caracter == '=')) {     // comparador tiene un solo caracter
        comparador[strlen(comparador)] = caracter;      // guarda en la posicion 1 el caracer = para formar: >= ó <= 
    }
    // Formo el comparador ==
    if ((operador[0] == '=') && (caracter == '=')) {     // operador tiene un solo caracter
        strcpy(comparador, operador);
        comparador[1] = caracter;
    }else if((operador[0] == '=')&&(caracter != '=')){
        operador[0] = '=';  // Formo el operador asignacion =
    }
    // Formo el comparador <> (distinto)
    if ((comparador[0] == '<') && (caracter == '>')) {     // comparador tiene un solo caracter
        comparador[strlen(comparador)] = caracter;      // formo el operador distinto <>
    }
    // Formo los operadores AND, OR
    if ((strlen(operador) == 1) && ((caracter == '&') || (caracter == '|'))) {     // operador tiene un solo caracter
        operador[strlen(operador)] = caracter;      // guarda en la posicion 1 el caracer = para formar: >= ó <= ó == ó !=
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void showTokens() {
    fprintf (lista_tokens, "%d\t\t%s\n", token_confirmado.number, token_confirmado.name);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void showSymbolTable() {
    if(token_confirmado.number == 257){  // Si es entero
        fprintf (tabla_simbolos, "%s\t %s\t\t\t %s\t\t\t %d\n", token_confirmado.lexema, token_confirmado.tipo, token_confirmado.valor, token_confirmado.longitud);
    }
    if(token_confirmado.number == 258){  // Si es real
        fprintf (tabla_simbolos, "%s\t %s\t\t\t\t\t %s\t\t\t %d\n", token_confirmado.lexema, token_confirmado.tipo, token_confirmado.valor, token_confirmado.longitud);
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////