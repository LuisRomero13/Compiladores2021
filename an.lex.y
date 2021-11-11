%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>
    #include <malloc.h>
    #include "y.tab.h"
    
    // variables para analizador lexico
    FILE * input=NULL;  
    FILE * lista_tokens=NULL; 
    FILE * tabla_simbolos=NULL;
    FILE * tabla_simbolos_orig=NULL;  
    FILE * tokens_unicos=NULL;
    char constanteEntera [40] = {0}; 
    char constanteReal [40]= {0};
    char constanteString [40]= {0}; 
    char IdPalabraReservada [40]= {0};
    char operador [40]= {0}; 
    char comparador [40]= {0}; 
    char otro[40]= {0};
    int estado_actual=0; 
    int estado_segundo=0;
    int estado_final=28; 
    int estado_error=29;
    int hay_error=0; 
    int position_row=1;
    int position_col=0;
    char caracter=' '; 
    struct Token {
        int number;
        char name[40];      
        char lexema[40];    
        char tipo[40];      
        char valor[40];     
        int longitud;
    };
    typedef struct {
        int index;
        char cell [40];
        char tag [40];
    }tira;
    struct Token token_confirmado;    
    
    // funciones para analizador lexico
    int yylex(void); int getColumnByEvent(char letra); void cleanTokens();
    void(*tabla_funciones[28][26])(); int tabla_estados [28][26];
    struct Token getTokenIdWords();struct Token getTokenInt();
    struct Token getTokenReal();struct Token getTokenString();
    struct Token getTokenOp();struct Token getTokenComp(); 
    struct Token getTokenOther(); void buildToken();
    void F0();void F1();void F2();void F3();void F4();void F5();void F6();void F7();
    void F8();void F9();void F10();void F11();void F12();void F13();void F15();
    void F17();void F18();void F19();void F20();void F21();void F22();void F23();
    void F24();void F25();void F26();void F27();void ERROR();void F(); 
    void showTokens(); void show_TS();
    
    // funciones para analizador sintactico
    int yyerror(char *s);

    // variables para codigo intermedio
    tira *tira_polaca;
    int cantidad_elementos_tira = 0; // indica la fila
    char comparador_RR [4] = {0}; // para imprimir los comparadores
    FILE * repre_intermedia=NULL;
    char ID_aux_TP[40] = {0}; // variable aux que almacena el id una vez que se van reduciendo las reglas
    char STR_aux_N1[40] = {0}; // variable aux que almacena el string una vez que se van reduciendo las reglas
    char STR_aux_N2[40] = {0}; // variable aux que almacena el string una vez que se van reduciendo las reglas
    char TYPE_aux[40] = {0}; // para los tipos de datos
    char num_tag_else[40] = "asm-jump";
    int imprimir_cadena_NUM = 0; int indice_tira = -1; int cant_selecciones = 0; int cant_bucles = 0;
    // funciones para codigo intermedio
    void apilar_polaca(char * yval, char * type_yval);  void aplicar_polaca();  void mostrar_polaca(); 
    char habilitar_tira=' '; 
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
%left MULT
%left DIV
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
programa: DECLARE declaracion ENDDECLARE bloque {printf("Regla 1\n"); aplicar_polaca(); mostrar_polaca(); } | 
          bloque {printf("Regla 2\n"); };

bloque: sentencia {printf("Regla 3\n");} | 
        sentencia  bloque {printf("Regla 4\n");};

declaracion: type variables PUNTOYC {printf("Regla 5\n");} | 
             type variables PUNTOYC declaracion {printf("Regla 6\n");};

type: INT {printf("Regla 7\n");} | 
      REAL {printf("Regla 8\n");} | 
      STRING {printf("Regla 9\n");};

variables: ID {printf("Regla 10\n");} | 
           ID COMA variables {printf("Regla 11\n");};

sentencia: asignacion PUNTOYC {printf("Regla 12\n"); } | 
           iteracion {printf("Regla 13\n");} | 
           seleccion {printf("Regla 14\n");} | 
           entrada {printf("Regla 15\n");} PUNTOYC {printf("Regla 16\n");} | 
           salida PUNTOYC {printf("Regla 17\n");};

asignacion: ID ASIGN multiple {printf("Regla 18\n"); apilar_polaca(ID_aux_TP, TYPE_aux); 
                               apilar_polaca("A=", "#operator"); };

multiple: ID ASIGN asignacion {printf("Regla 19\n"); apilar_polaca(ID_aux_TP,TYPE_aux);
                               apilar_polaca("A=","#operator");} | 
          ID ASIGN expresion_num {printf("Regla 20\n");} | 
          ID ASIGN expresion_string {printf("Regla 21\n");} | 
          expresion_num {printf("Regla 22\n");} | 
          expresion_string {printf("Regla 23\n");} ;

expresion_num: termino {printf("Regla 24\n");} | 
               expresion_num SUMA termino {printf("Regla 25\n"); apilar_polaca("S+","#operator");} | 
               expresion_num RESTA termino {printf("Regla 26\n"); apilar_polaca("R-","#operator");} ;

expresion_string: CSTRING CONCAT CSTRING {printf("Regla 27\n"); apilar_polaca(STR_aux_N1,TYPE_aux); 
                                          apilar_polaca(STR_aux_N2, TYPE_aux); 
                                          apilar_polaca("++","#operator"); } | 
                  ID CONCAT CSTRING {printf("Regla 28\n");} | 
                  ID CONCAT ID {printf("Regla 29\n");} | 
                  CSTRING CONCAT ID {printf("Regla 30\n");} ;

termino: factor {printf("Regla 31\n");} | 
         termino MULT factor {printf("Regla 32\n"); apilar_polaca("M*","#operator");} | 
         termino DIV factor {printf("Regla 33\n"); apilar_polaca("D/","#operator");} ;

factor: ID {printf("Regla 34\n"); apilar_polaca(yylval.lexema, TYPE_aux); } | 
        CENT {printf("Regla 35\n"); apilar_polaca(yylval.valor, TYPE_aux);} | 
        CREAL {printf("Regla 36\n"); apilar_polaca(yylval.valor,TYPE_aux);} | 
        PARENTA expresion_num PARENTC {printf("Regla 37\n");};

comparador: MAYOR {printf("Regla 38\n"); strcpy(comparador_RR, "BLE"); } | 
            MENOR  {printf("Regla 39\n"); strcpy(comparador_RR, "BGE"); } | 
            MENORIGUAL {printf("Regla 40\n"); strcpy(comparador_RR, "BGT"); } | 
            MAYORIGUAL {printf("Regla 41\n"); strcpy(comparador_RR, "BLT"); } | 
            IGUAL {printf("Regla 42\n"); strcpy(comparador_RR, "BEQ"); } | 
            DISTINTO {printf("Regla 43\n"); strcpy(comparador_RR, "BNE");} ;

comparacion: PARENTA expresion_num PARENTC comparador PARENTA expresion_num PARENTC {printf("Regla 44\n"); } | 
             PARENTA expresion_string PARENTC comparador PARENTA expresion_string PARENTC {printf("Regla 45\n");} ;

comp_logico: PARENTA comparacion PARENTC AND PARENTA comparacion PARENTC {printf("Regla 46\n");} | 
             PARENTA comparacion PARENTC OR PARENTA comparacion PARENTC {printf("Regla 47\n");} ;

condicion: NOT PARENTA condicion PARENTC {printf("Regla 48\n");} | 
           comparacion {printf("Regla 49\n"); if(habilitar_tira=='s'){apilar_polaca("CMP","#comparator_if");}else if(habilitar_tira=='w'){apilar_polaca("CMP","#comparator_while");}; 
                        apilar_polaca(comparador_RR,"#asm-comparator"); apilar_polaca(" ","#space");} | 
           comp_logico {printf("Regla 50\n");};

iteracion: {apilar_polaca("WH_I","#inicio_wh");} WHILE PARENTA {habilitar_tira='w';} condicion PARENTC LLAVEA bloque LLAVEC {printf("Regla 51\n"); apilar_polaca(" ","#space"); 
                                                                                                                            apilar_polaca("BI","#asm-jump"); apilar_polaca("WH_F","#fin_wh");};

seleccion: {apilar_polaca("IF_I","#inicio_if");}IF PARENTA {habilitar_tira='s';}condicion PARENTC LLAVEA bloque LLAVEC { printf("Regla 52\n"); cant_selecciones++; printf("CANT SELECCIONES ES: %d\n",cant_selecciones);
                                                                                                                        apilar_polaca(" ","#space"); apilar_polaca("BI","#asm-jump"); apilar_polaca("IF_F","#fin_if");  } 
           ELSE LLAVEA bloque LLAVEC { printf("Regla 53\n"); apilar_polaca("ELSE_F","#asm-jump");};

entrada: PUT CSTRING {printf("Regla 54\n");} | 
         PUT CENT {printf("Regla 55\n");} | 
         PUT CREAL {printf("Regla 56\n");} ;

salida: GET ID {printf("Regla 56\n");};
%%

int main(){ // INICIO MAIN
    input = fopen("input.txt", "rb"); 
    lista_tokens = fopen("lista_tokens.txt", "w");
    tabla_simbolos = fopen("tabla_simbolos.txt", "w+"); 
    tabla_simbolos_orig = fopen("tabla_simbolos-orig.txt", "w+");
    tokens_unicos = fopen("tokens_unicos.txt", "w+");
    repre_intermedia = fopen("intermedia.txt", "w+");

    rewind(lista_tokens);
    rewind(tabla_simbolos);
    rewind(tabla_simbolos_orig);
    rewind(tokens_unicos);
    rewind(repre_intermedia);
    //system("pause");
    
    if((repre_intermedia != NULL)||(input != NULL)||(lista_tokens != NULL)||(tabla_simbolos != NULL)||(tokens_unicos != NULL)||(tabla_simbolos_orig != NULL)){
        fprintf (lista_tokens, "%s\t\t%s\n\n", "ID", "NOMBRE");
        fflush(lista_tokens);
        fprintf (tabla_simbolos, "%s\t\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s\n\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
        fflush(tabla_simbolos);
        fprintf (tabla_simbolos_orig, "%s\t\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s\n\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
        fflush(tabla_simbolos_orig);

        int recibo;
        recibo = yyparse();
        if (recibo == 0){
           printf("¡Parser Ok!\n"); 
        }else   
            printf("¡Parser Error!\n");
        fclose(input); 
        fclose(lista_tokens);
        fclose(tokens_unicos); 
        fclose(tabla_simbolos_orig); 
        fclose(tabla_simbolos);
        fclose(repre_intermedia);
        remove("tokens_unicos.txt"); // Destruimos el archivo una vez utilizado
    }
    else{
        perror("Ocurrio un error al intentar abrir el archivo\n");
        return 1;
    }

    fflush(lista_tokens);
    fflush(tabla_simbolos);
    fflush(tabla_simbolos_orig);
    fflush(tokens_unicos);
    fflush(repre_intermedia);
    free(tira_polaca); // liberamos la memoria dinamica
    return 0;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//      FUNCIONES       //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
int yylex(void) {
    while(estado_actual != estado_final){
        if((caracter = fgetc(input)) != EOF){
            position_col++;
            int num_col = getColumnByEvent(caracter);
            int num_row = estado_actual; // al principio, estado actual = 0
            (*tabla_funciones[num_row][num_col])();  // ejecuta la funcion correspondiente
            estado_actual = tabla_estados[num_row][num_col]; // actualizamos estado actual

            if((estado_actual == estado_error)||(hay_error == 1)){
                exit(1);
            }
            if((estado_segundo == 0)||(estado_actual == 3)||(estado_actual == 9)||(estado_actual == 10)||(estado_actual == 12)){
                estado_segundo = estado_actual;
            }
        } 
        else if(caracter == EOF){
            break;
        }
    }

    if(estado_actual == estado_final){
        buildToken();
        int num_token = token_confirmado.number;  // guardo numero de token
        yylval.number = token_confirmado.number;  // guardo numero de token
        
        printf("YYLVAL NUMBER: %d\n", yylval.number);
        // YYLVAL almacena, por defecto, un valor de tipo ENTERO (un solo tipo)
        if((token_confirmado.number == 260) || (token_confirmado.number == 259)) {
            strcpy(yylval.valor, token_confirmado.valor);  // guardo el valor asociado al token
            strcpy(TYPE_aux, "#");
            strcat(TYPE_aux, token_confirmado.tipo);
            printf("-----------------------------------------------------------YYLVAL TYPE ES : %s\n",TYPE_aux);
            printf("YYLVAL VALOR ES : %s\n",yylval.valor);
        }
        else if (yylval.number == 271) {
            //strcpy(yylval.lexema, token_confirmado.lexema);  // guardo el valor asociado al token
            strcpy(ID_aux_TP, token_confirmado.lexema);
            strcpy(TYPE_aux, "#");
            strcat(TYPE_aux, token_confirmado.tipo);
            printf("-----------------------------------------------------------YYLVAL TYPE ES : %s\n",TYPE_aux);
            printf("-----------------------------------------------------------YYLVAL LEXEMA ES : %s\n",ID_aux_TP);
        }
        else if(yylval.number == 258) {
            //strcpy(yylval.valor, token_confirmado.valor);  // guardo el valor asociado al token
            imprimir_cadena_NUM++;
            if(imprimir_cadena_NUM == 1) {
                strcpy(STR_aux_N1, token_confirmado.valor);
                strcpy(TYPE_aux, "#");
                strcat(TYPE_aux, token_confirmado.tipo);
                printf("-----------------------------------------------------------YYLVAL TYPE ES : %s\n",TYPE_aux);    
                printf("-----------------------------------------------------------YYLVAL VALOR STRING ES : %s\n",STR_aux_N1);
            }
            else if(imprimir_cadena_NUM == 2){
                strcpy(STR_aux_N2, token_confirmado.valor);
                printf("-----------------------------------------------------------YYLVAL VALOR STRING ES : %s\n",STR_aux_N2);
                strcpy(TYPE_aux, "#");
                strcat(TYPE_aux, token_confirmado.tipo);
                printf("-----------------------------------------------------------YYLVAL TYPE ES : %s\n",TYPE_aux);    
                imprimir_cadena_NUM = 0;
            }
        }else if((yylval.number == 266)||(yylval.number == 267)||(yylval.number == 268)){
            strcpy(TYPE_aux, "#");
            strcat(TYPE_aux, token_confirmado.tipo);
            printf("-----------------------------------------------------------YYLVAL TYPE ES : %s\n",TYPE_aux);
        }
        else 
            strcpy(yylval.valor, " ");  // guardo el valor asociado al token

        estado_actual = 0; estado_segundo = 0; // reseteamos el automata
                
        if((caracter != ' ')&&(caracter != '\t')&&(caracter != '\n')&&(constanteString[0] == '\0')&&(comparador[1] == '\0')) // si comparador[1] no tiene contenido 
            ungetc(caracter, input);
        cleanTokens();
        //printf("Num token es: %d\n", num_token);
                
        // NUMERO DE TOKEN esta entre 256 (primer token) y 292 (ultimo token)
        return num_token;
    }else{
        return -1;  // llego al fin del programa (detecta EOF), no hay mas token para devolver
    }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int getColumnByEvent(char letra){
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
    if((letra == '%')||(letra == ':')||(letra == '?')||(letra == '$')||(letra == '~')||(letra == '^')||(letra == 64))    return 25;     
    return 24;                          // Si no cumple ninguna condicion, por defecto, retorna 24, es decir, caracter no especificado                                  
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void buildToken(){
    if(estado_segundo == 1){
        token_confirmado = getTokenIdWords();
        showTokens(); show_TS();   // imprimimos los resultados
    }
    if(estado_segundo == 2) {
        token_confirmado = getTokenInt();
        showTokens(); show_TS();   // imprimimos los resultados
    }
    if(estado_segundo == 3) {
        token_confirmado = getTokenReal();
        showTokens(); show_TS();   // imprimimos los resultados
    }
    if(estado_segundo == 4) {
        token_confirmado = getTokenString();
        showTokens();   show_TS();  // imprimimos los resultados
    }
    if(((estado_segundo == 7)&&(comparador[0] != '='))||(estado_segundo == 8)||((estado_segundo >= 11)&&(estado_segundo <= 17))||((estado_segundo >= 24)&&(estado_segundo <= 25))){
        token_confirmado = getTokenOp();  // Token OPERADORES
        showTokens();   show_TS(); // imprimimos los resultados
    }
    if((estado_segundo == 7)&&(comparador[0] == '=')) {  // si comparador tiene un igual significado que se trata de un comparador
        token_confirmado = getTokenComp();  // Token COMPARADORES
        showTokens();   show_TS(); // imprimimos los resultados
    }
    if(((estado_segundo >= 18)&&(estado_segundo <= 23))||((estado_segundo >= 26)&&(estado_segundo<=27))){
        token_confirmado = getTokenOther();  // Token Otros
        showTokens();   show_TS(); // imprimimos los resultados
    }
    if((estado_segundo >= 5)&&(estado_segundo <= 6)){
        token_confirmado = getTokenComp();  // Token COMPARADORES
        showTokens();   show_TS();  // imprimimos los resultados
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void cleanTokens() {
    for(int i=0; i<39;  i++) {
        constanteEntera[i] = '\0'; constanteReal[i] = '\0';
        constanteString[i] = '\0'; IdPalabraReservada[i] = '\0';
        operador[i] = '\0'; comparador[i] = '\0'; otro[i] = '\0';
        token_confirmado.lexema[i] = '\0'; token_confirmado.tipo[i] = '\0'; token_confirmado.valor[i] = '\0';
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenInt() {
    struct Token token;
    if( strlen( constanteEntera ) > 0 ) {
        token.number = 259; // guardo numero de token
        strcpy( token.name, "CENT" ); // guardo nombre del token
        strcpy ( token.lexema, "$");
        strcat( token.lexema, constanteEntera);
        strcpy ( token.tipo, "int");
        strcpy( token.valor, constanteEntera);
        token.longitud = 0;
        return token;
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenReal() {
    struct Token token;
    if( strlen( constanteReal ) > 0 ) {
        token.number = 260; // guardo numero de token
        strcpy( token.name, "CREAL" ); // guardo nombre del token
        strcpy ( token.lexema, "$");
        strcat( token.lexema, constanteReal);
        strcpy ( token.tipo, "real");
        strcpy( token.valor, constanteReal);
        token.longitud = 0;
        return token;
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenString() {
    struct Token token;
    if( strlen( constanteString ) > 0 ) {
        token.number = 258; // guardo numero de token
        strcpy( token.name, "CSTRING" ); // guardo nombre del token
        strcpy ( token.lexema, "$");
        strcat( token.lexema, constanteString); 
        strcat ( token.lexema, "\"");
        strcpy ( token.tipo, "cstring");
        strcpy( token.valor, constanteString);
        strcat ( token.valor, "\"");
        token.longitud = strlen(constanteString);
        return token;
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenIdWords() {
    struct Token token;
    strcpy ( token.valor, " ");
    if( strlen( IdPalabraReservada ) > 0 ) {             // Si no esta vacio 
        if( strcmp( IdPalabraReservada , "while" ) == 0) {           // Si palabrasReservada es WHILE
            token.number = 261; // guardo numero de token
            strcpy( token.name, "WHILE" ); // guardo nombre del token
            strcpy ( token.lexema, " ");
            return token;
        }
        if( strcmp( IdPalabraReservada , "if" ) == 0) {              // Si palabrasReservada es IF
            token.number = 262; // guardo numero de token   
            strcpy( token.name , "IF" ); // guardo nombre del token
            strcpy ( token.lexema, " ");
            return token;
        }
        if( strcmp( IdPalabraReservada , "else" ) == 0) {            // Si palabrasReservada es ELSE
            token.number = 263; // guardo numero de token   
            strcpy( token.name , "ELSE" ); // guardo nombre del token
            strcpy ( token.lexema, " ");
            return token;
        }
        if( strcmp( IdPalabraReservada , "declare" ) == 0) {         // Si palabrasReservada es DECLARE
            token.number = 264; // guardo numero de token
            strcpy( token.name , "DECLARE" ); // guardo nombre del token
            strcpy ( token.lexema, " ");
            return token;
        }
        if( strcmp( IdPalabraReservada , "enddeclare" ) == 0) {      // Si palabrasReservada es ENDDECLARE
            token.number = 265; // guardo numero de token
            strcpy( token.name , "ENDDECLARE" ); // guardo nombre del token
            strcpy ( token.lexema, " ");
            return token;
        }    
        if( strcmp( IdPalabraReservada , "real" ) == 0) {        // Si palabrasReservada es REAL
            token.number = 266; // guardo numero de token
            strcpy( token.name , "REAL" ); // guardo nombre del token
            strcpy ( token.lexema, " ");
            strcpy ( token.tipo, "real");
            return token;
        }      
        if( strcmp( IdPalabraReservada , "int" ) == 0) {         // Si palabrasReservada es INT
            token.number = 267; // guardo numero de token
            strcpy( token.name , "INT" ); // guardo nombre del token
            strcpy ( token.lexema, " ");
            strcpy ( token.tipo, "int");
            return token;
        } 
        if( strcmp( IdPalabraReservada , "string" ) == 0) {      // Si palabrasReservada es STRING
            token.number = 268; // guardo numero de token
            strcpy( token.name , "STRING" ); // guardo nombre del token
            strcpy ( token.lexema, " ");
            strcpy ( token.tipo, "string");
            return token;
        } 
        if( strcmp( IdPalabraReservada , "get" ) == 0) {         // Si palabrasReservada es GET
            token.number = 269; // guardo numero de token
            strcpy( token.name , "GET" ); // guardo nombre del token
            strcpy ( token.lexema, " ");
            return token;
        } 
        if( strcmp( IdPalabraReservada , "put" ) == 0) {      // Si palabrasReservada es PUT
            token.number = 270; // guardo numero de token
            strcpy( token.name , "PUT" ); // guardo nombre del token
            strcpy ( token.lexema, " ");
            return token;
        }
        if( strlen( IdPalabraReservada ) > 0 ) {             // Si no esta vacio 
            token.number = 271; // guardo numero de token
            strcpy( token.name, "ID" ); // guardo nombre del token
            strcpy ( token.lexema, "$");
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
    strcpy ( token.valor, " ");
    strcpy ( token.lexema, " ");
    if( strlen(operador) > 0) {         // Si no esta vacio
        if( strcmp( operador , "+" ) == 0) {        // Si operador es +
            token.number = 272; // guardo numero de token
            strcpy( token.name , "SUMA" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( operador , "-" ) == 0) {        // Si operador es -
            token.number = 273; // guardo numero de token
            strcpy( token.name , "RESTA" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( operador , "*" ) == 0) {        // Si operador es *
            token.number = 274; // guardo numero de token
            strcpy( token.name , "MULT" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( operador , "/" ) == 0) {        // Si operador es /
            token.number = 275; // guardo numero de token
            strcpy( token.name , "DIV" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( operador , "=" ) == 0) {        // Si operador es =
            token.number = 276; // guardo numero de token
            strcpy( token.name , "ASIGN" ); // guardo nombre del token
            return token;
        }
        if( strcmp( operador , "++" ) == 0) {       // Si operador es ++
            token.number = 277; // guardo numero de token
            strcpy( token.name , "CONCAT" ); // guardo nombre del token
            return token;
        }
        if( strcmp( operador , "&&" ) == 0) {       // Si operador es &&
            token.number = 278; // guardo numero de token
            strcpy( token.name , "AND" ); // guardo nombre del token
            return token;
        }
        if( strcmp( operador , "||" ) == 0) {       // Si operador es ||
            token.number = 279; // guardo numero de token
            strcpy( token.name , "OR" ); // guardo nombre del token
            return token;
        }
        if( strcmp( operador , "!" ) == 0) {        // Si operador es !
            token.number = 280; // guardo numero de token
            strcpy( token.name , "NOT" ); // guardo nombre del token
            return token;
        }
    } 
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenComp(){
    struct Token token;
    strcpy ( token.valor, " ");
    strcpy ( token.lexema, " ");
    if( strlen(comparador) > 0) {           // Si no esta vacio
        if( strcmp( comparador , ">" ) == 0) {         // Si comparador es >
            token.number = 281; // guardo numero de token
            strcpy( token.name , "MAYOR" ); // guardo nombre del token
            return token;
        }
        if( strcmp( comparador , "<" ) == 0) {        // Si comparador es <
            token.number = 282; // guardo numero de token
            strcpy( token.name , "MENOR" ); // guardo nombre del token
            return token;
        }
        if( strcmp( comparador , "<=" ) == 0) {       // Si comparador es <
            token.number = 283; // guardo numero de token
            strcpy( token.name , "MENORIGUAL" ); // guardo nombre del token
            return token;
        }
        if( strcmp( comparador , ">=" ) == 0) {       // Si comparador es >
            token.number = 284; // guardo numero de token
            strcpy( token.name , "MAYORIGUAL" ); // guardo nombre del token
            return token;
        }
        if( strcmp( comparador , "==" ) == 0) {       // Si comparador es ==
            token.number = 285; // guardo numero de token
            strcpy( token.name , "IGUAL" ); // guardo nombre del token
            return token;
        }
        if( strcmp( comparador , "<>" ) == 0) {           // Si comparador es !=
            token.number = 286; // guardo numero de token
            strcpy( token.name , "DISTINTO" ); // guardo nombre del token
            return token;
        }
    }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct Token getTokenOther(){
    struct Token token;
    strcpy ( token.valor, " ");
    strcpy ( token.lexema, " ");
    if( strlen(otro) > 0) {         // Si no esta vacio
        if( strcmp( otro, ";" ) == 0 ) {        // Si otro es ; 
            token.number = 287;      // guardo numero de token
            strcpy( token.name , "PUNTOYC" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "{" ) == 0) {        // Si otro es {
            token.number = 288;      // guardo numero de token
            strcpy( token.name , "LLAVEA" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "}" ) == 0 ) {       // Si otro es }
            token.number = 289;      // guardo numero de token
            strcpy( token.name , "LLAVEC" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "(" ) == 0 ) {       // Si otro es (
            token.number = 290;      // guardo numero de token
            strcpy( token.name , "PARENTA" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , ")" ) == 0 ) {       // Si otro es )
            token.number = 291;      // guardo numero de token
            strcpy( token.name , "PARENTC" );  // guardo nombre del token
            return token;
        }
        if( strcmp( otro , "," ) == 0 ) {       // Si otro es ,
            token.number = 292;      // guardo numero de token
            strcpy( token.name , "COMA" );  // guardo nombre del token
            return token;
        }
    }       
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
int tabla_estados [28][26] = {
//estado  	letra	digit	    _	    .	    "	    >	    <	    =	    /	    #	    +	    &	    |	    !	    (	    )	    [	    ]	    {	    }	    -	    *	    ,	    ;       /t /     other
/*estado0*/ 	1,      2,	    29,	    29,	    4,	    5,	    6,	    7,	    8,	    29,	    11,	    13,	    15,	    17,	    18,	    19,	    20,	    21,	    22,	    23,	    24,	    25,	    26,	    27,     0,     29,
/*estado1*/ 	1,	    1,	    1,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,
/*estado2*/	    29,	    2,	    28,	    3,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,
/*estado3*/	    29,	    3,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,
/*estado4*/	    4,	    4,	    4,	    4,	    28,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,	    4,      4,      29,      
/*estado5*/ 	28,	    28,	    28,	    29,	    29,	    29,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     29,     
/*estado6*/ 	28,	    28,	    28,	    29,	    29,	    28,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     29,     
/*estado7*/ 	28,	    28,	    28,	    29,	    28,	    29,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     29,     
/*estado8*/ 	28,	    28,	    28,   	28,	    28,	    28,	    28,	    28,	    28,	    9,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     29,     29,     
/*estado9*/	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    10,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,   	9,	    9,	     9,     9,      9,      
/*estado10*/	9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    0,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,      9,	    9,	     9,     9,      9,      
/*estado11*/	28,	    28,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    12,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     29,     29,     
/*estado12*/	28,	    29,	    28,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     29,     29,     
/*estado13*/	29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    14,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     29,     29,     
/*estado14*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    29,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,    	28,	    28,	    28,	    28,     28,     29,     
/*estado15*/    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    16,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     29,       
/*estado16*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    29,	    28,	    28,   	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,       
/*estado17*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,            
/*estado18*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,     
/*estado19*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,     
/*estado20*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,   	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,     
/*estado21*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,     
/*estado22*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,     
/*estado23*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,     
/*estado24*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,     
/*estado25*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,     
/*estado26*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,        
/*estado27*/	28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,               
            }; 
////////////////////////////////////////////////////////////////////////////////////////////////////////////
void(*tabla_funciones[28][26])() = {        // Se omite F14 y F16
//	    letra	digito	_	    .	    "	    >	    <	    =	    /	    #	    +	    &	    |	    !	    (	    )	    [	    ]	    {	    }	    -	    *	    ,	    ;       /t      /n
/*F0*/	F1,	    F2,	    ERROR,	ERROR,	F4,	    F5,	    F6,	    F7,	    F8,	    ERROR,	F11,	F13,	F15,	F17,	F18,	F19,	F20,	F21,	F22,	F23,	F24,	F25,	F26,	F27,    F0,      ERROR,
/*F1*/	F1,	    F1,	    F1,	    F,	    F,   	F,	    F,	    F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,   	F,	    F,      F,      ERROR,
/*F2*/	ERROR,	F2,	    F,	    F3,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F3*/	ERROR,	F3,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F4*/	F4,	    F4,	    F4,	    F4,	    F,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,	    F4,     F4,     ERROR,
/*F5*/	F,	    F,	    F,	    ERROR,	ERROR,	ERROR,	ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	F,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      ERROR,
/*F6*/	F,	    F,	    F,	    ERROR,	ERROR,	F,	    ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	F,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      ERROR,
/*F7*/	F,	    F,	    F,	    ERROR,	F,	    ERROR,	ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	F,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      ERROR,
/*F8*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F9,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      ERROR,  ERROR,
/*F9*/	F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F10,	F9,	    F9,	    F9,	    F9,   	F9,	    F9,	    F9,	    F9,	    F9,	    F9,   	F9,	    F9,	    F9,  	F9,     F9,     F9,     
/*F10*/	F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F0,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,     F9,     F9,
/*F11*/	F,   	F,	    F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	F12,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  ERROR,  ERROR,
/*F12*/	F,	    ERROR,	F,	    ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  ERROR,  ERROR,
/*F13*/	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  ERROR,  ERROR,
/*F14*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    ERROR,	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,    	F,	    F,	    F,	    F,      F,      ERROR,     
/*F15*/	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      ERROR,
/*F16*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    ERROR,	F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,       
/*F17*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F18*/	F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,  	F,	    F,	    F,	    F,      F,      ERROR,
/*F19*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F20*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F21*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F22*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F23*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F24*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F25*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F26*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,   	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
/*F27*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,      ERROR,
        };
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F0() {
    estado_actual = 0; estado_segundo = 0; // reseteamos el automata
    //printf("Espacio, barra ene o barra te\n");
    if(caracter == '\n') {
        position_row++;
        position_col=0;
    }
    cleanTokens();
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F1(){  // IDENTIFICADOR, PALABRA RESERVADA
    if(strlen(IdPalabraReservada) < 30){
        IdPalabraReservada[strlen(IdPalabraReservada)] = caracter;   // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer caracter en la posicion 0 para formar una palabra RESERVADA
    } else {
        printf("¡Error! Limite de identificador alcanzado en: fila %d, columna %d\n", position_row, position_col);
        hay_error = 1;
    } 
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F2(){  //  DIGITO
    if(strlen(constanteEntera) < 30){
        constanteEntera[strlen(constanteEntera)] = caracter;    // si esta vacio, strlen devuelve 0. es decir, que en la primera pasada guardaria el primer digito en la posicion 0
    } else {
        printf("¡Error! Limite de int alcanzado en: fila %d, columna %d\n", position_row, position_col);
        hay_error = 1;
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F3(){  // REALES
    if(caracter == '.') {
        strcpy(constanteReal, constanteEntera);  // hago una copia de los digitos enteros en los reales
    }
    if(strlen(constanteReal) < 30){
        constanteReal[strlen(constanteReal)] = caracter;    // voy formando el digito de tipo real
    } else {
        printf("¡Error! Limite de real alcanzado en: fila %d, columna %d\n", position_row, position_col);
        hay_error = 1;
    } 
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void F4(){    // STRING "  "
    if(strlen(constanteString) < 30){
        constanteString[strlen(constanteString)] = caracter;  // voy formando el string 
    } else {
        printf("¡Error! Limite de string alcanzado en: fila %d, columna %d\n", position_row, position_col);
        hay_error = 1;
    } 
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
    printf("¡Error! caracter invalido en: fila %d, columna %d\n", position_row, position_col);
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
    fflush(lista_tokens);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void show_TS() {   
    if((token_confirmado.number == 258)||(token_confirmado.number == 259)||(token_confirmado.number == 260)||(token_confirmado.number == 271)) {  // Si es entero, real, string o id    
        char lexema[40] = {0}; char lexema_temp[40] = {0};
        int imprimir = 1;       // uso esta variable para imprimir en los archivos

        strcpy(lexema_temp, token_confirmado.lexema);
        strcat(lexema_temp, "\n"); // agrego el caracter de fin de linea para poder hacer las comparaciones
        fseek(tokens_unicos, 0, SEEK_SET); // rebobino el cursor de lectura

        while (feof(tokens_unicos) == 0) {
            fgets(lexema , sizeof(token_confirmado.lexema) , tokens_unicos); //por cada cadena leida, obtengo al final un caracter de fin de linea                 
            if(strcmp(lexema, lexema_temp) == 0) {
                imprimir = 0; // para que no imprimo ningun resultado repetido en el archivo
            }
        }
        if(imprimir == 1) {  // si vale 1 ya podemos imprimir los resultados en sus respectivos archivos
            fprintf(tokens_unicos, "%s\n",token_confirmado.lexema);
            fflush(tokens_unicos);
            fprintf (tabla_simbolos, "%s\t %s\t\t\t %s\t\t\t %d\n", token_confirmado.lexema, token_confirmado.tipo, token_confirmado.valor, token_confirmado.longitud);
            fflush(tabla_simbolos);
            fprintf (tabla_simbolos_orig, "%s\t %s\t\t\t %s\t\t\t %d\n", token_confirmado.lexema, token_confirmado.tipo, token_confirmado.valor, token_confirmado.longitud);
            fflush(tabla_simbolos_orig);
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int yyerror(char *s){
    printf("Error de sintaxis en: fila %d, columna %d\n", position_row, position_col);
    fprintf(stderr,"%s\n",s);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void apilar_polaca(char * yval, char * type_yval) {
    int longitud_cad = 0;
    char dato [40] = {0};
    
    strcpy(dato, yval);
    // Pregunto si yval guarda un operador, sino se considera como digito
    if( strcmp( yval , "S+" ) == 0)       strcpy(dato, "+");
    else if( strcmp( yval , "R-" ) == 0)  strcpy(dato, "-");
    else if( strcmp( yval , "M*" ) == 0)  strcpy(dato, "*");
    else if( strcmp( yval , "D/" ) == 0)  strcpy(dato, "/");
    else if( strcmp( yval , "A=" ) == 0)  strcpy(dato, "=");
   
    longitud_cad = strlen(dato);
    
    printf("****estoy en funcion APILAR POLACA Y yval es: %s****\n",dato);
    printf("****longitud de yval es: %d****\n",longitud_cad);
    //printf("cantidad_elementos_tira  es: %d\n",cantidad_elementos_tira);

    //borramos todos los caracteres que tengamos en dato e id (ver variable global)
   
    if(repre_intermedia != NULL) {
        indice_tira++;
        fprintf(repre_intermedia, "%d", indice_tira);
        fflush(repre_intermedia);
        fprintf(repre_intermedia, "\t;%s;", dato);
        fflush(repre_intermedia);
        fprintf(repre_intermedia, "\t%s\n", type_yval);
        fflush(repre_intermedia);

        for (int i=0; i<40; i++) {
            dato[i] = '\0';
        }    
    }
    fflush(repre_intermedia);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void aplicar_polaca() {
    int asignar=0;
    indice_tira++;
    asignar = indice_tira;
    char crtt;

    char auxIndice[40]={0};
    char auxCelda[40]={0};
    char auxEtiqueta[40]={0};

    printf("INDICE DE TIRA es %d \n", indice_tira);
    rewind(repre_intermedia);

    tira_polaca = (tira*)malloc(asignar+1*sizeof(tira));
    if(tira_polaca==NULL){
        printf("No se asignó memoria correctamente para tira_polaca\n");
    }
    else{
        if (repre_intermedia == NULL) {
            printf("El fichero no se ha podido abrir para lectura.\n");
            exit(1);
        }else {
            while(1){
                /*if((crtt = fgetc(repre_intermedia)) != EOF){
                    printf("%c", crtt);
                    if(isdigit(crtt)){
                        strcat(auxIndice,crtt);
                    }else if(crtt==";"){

                    }
                 */
                fgets(repre_intermedia)   
                }else{
                    //fclose(repre_intermedia);
                    break;
                    }
                }
            }

    }
    
}
///////////////////////////////////////////////////////////////////////////////////////////////
void mostrar_polaca(){
    int cant_cmp = -1;                //     0         1       2        3
    int select[cant_selecciones][4];  // [BFINDEX, BFVALUE, BIINDEX, BIVALUE ]      columnas de select
    /*
    for(int j=0; j<indice_tira; j++) {
        printf ("%d %s %s\n", tira_polaca[j].index, tira_polaca[j].cell, tira_polaca[j].tag);
        if( strcmp( tira_polaca[j].cell , "|CMP|" ) == 0){
            cant_cmp++;                                     //referencia a la fila de tira polaca
            select[cant_cmp][0] = j+2;
            printf("CMP es: %d\n",select[cant_cmp][0]);
        }
    }
    */
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////