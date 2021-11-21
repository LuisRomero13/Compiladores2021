%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>
    #include <malloc.h>
    #include "y.tab.h"
    #define TAM 100
    
    // variables para analizador lexico
    FILE * input=NULL;  
    FILE * lista_tokens=NULL; 
    FILE * tabla_simbolos=NULL;
    FILE * tabla_simbolos_orig=NULL;  
    FILE * tokens_unicos=NULL;
    FILE * final_asm=NULL;
    FILE * concat=NULL;
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
        char index[40];
        char cell [40];
        char tag [40];
    }tira;
    typedef struct {
        char nombre[40];
        char tipo [40];
        char valor [40];
        char longitud [40];
    }TablaSimbolos;

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
    TablaSimbolos * dinamic_TS;

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
    char * getIdTP(); char *invertir(char cadena[]);
    void llenarTS(); void actualizarTS(char type[], int num_tipo); char * removeSubString(char * str,int num_tipo);  char * insertSpaWhite(char * line);
    void addTypeTS(); void printTS(); void printTiraPolaca();
    void verificar_tipos();

    char habilitar_tira=' ';
    char habilitar_multiple = ' '; 
    char listaIDS[1000] = {0};  
    int position_TS = 0;  // todo lo que dice TS es Tabla de Simbolos
    char ** memory_TS;

    //estructuras para la pila
    struct elemento {
	int dato;
    int posicion;
	struct elemento *next;
    };

    struct pila {
        struct elemento *frente;
        int tamano;
    };

    typedef struct {
        struct elemento registro;
    }tiraIW;

    //funciones utilizadas por la pila
    void aplicar_algoritmo_pilas();
    int crear(struct pila *);
    int apilar(struct pila *, struct elemento);
    int desapilar(struct pila *, struct elemento *);
    int estaVacia(struct pila);
    int tamano(struct pila p);
    int mostrar(struct pila *p, struct elemento *);
    int retornar_tope(struct pila *p, struct elemento *elemento);

    //funciones para generar ASSEMBLER
    void generarAssembler(); char * skipPointsC(char celda_tira []); char * skipComillasC(char string []); char * changeRealC(char stringR []);
    void contar_if_wh(); 
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
programa: DECLARE declaracion ENDDECLARE bloque {printf("Regla 1\n"); llenarTS(); aplicar_polaca(); aplicar_algoritmo_pilas();mostrar_polaca();verificar_tipos();;generarAssembler();} | 
          bloque {printf("Regla 2\n"); aplicar_polaca(); aplicar_algoritmo_pilas(); mostrar_polaca();verificar_tipos();};   

bloque: sentencia {printf("Regla 3\n");} | 
        sentencia  bloque {printf("Regla 4\n");};

declaracion: type variables PUNTOYC {printf("Regla 5\n"); habilitar_multiple = 'y';} | 
             type variables PUNTOYC declaracion {printf("Regla 6\n"); habilitar_multiple = 'y';};

type: INT {printf("Regla 7\n"); } | 
      REAL {printf("Regla 8\n"); } | 
      STRING {printf("Regla 9\n"); };

variables: ID {printf("Regla 10\n");   } | 
           ID COMA variables {printf("Regla 11\n");};

sentencia: asignacion PUNTOYC {printf("Regla 12\n"); } | 
           iteracion {printf("Regla 13\n");} | 
           seleccion {printf("Regla 14\n");} | 
           entrada PUNTOYC {printf("Regla 16\n");} | 
           salida PUNTOYC {printf("Regla 17\n");};

asignacion: ID ASIGN multiple {printf("Regla 18\n"); apilar_polaca(getIdTP(), TYPE_aux); 
                               apilar_polaca("A=", "#operator"); };|

multiple: ID ASIGN asignacion {printf("Regla 19\n"); apilar_polaca(getIdTP(),TYPE_aux);
                               apilar_polaca("A=","#operator");}| 
          ID ASIGN expresion_num {printf("Regla 20\n"); apilar_polaca(getIdTP(),TYPE_aux);
                               apilar_polaca("A=","#operator");} | 
          ID ASIGN expresion_string {printf("Regla 21\n");} | 
          expresion_num {printf("Regla 22\n");} | 
          expresion_string {printf("Regla 23\n");} |
          CSTRING {printf("regla =CTESTRING\n"); apilar_polaca(STR_aux_N1,TYPE_aux); 
                          } ;

expresion_num: termino {printf("Regla 24\n");} | 
               expresion_num SUMA termino {printf("Regla 25\n"); apilar_polaca("S+","#operator");} | 
               expresion_num RESTA termino {printf("Regla 26\n"); apilar_polaca("R-","#operator");} ;

expresion_string: CSTRING CONCAT CSTRING {printf("Regla 27\n"); apilar_polaca(STR_aux_N1,TYPE_aux); 
                                          apilar_polaca(STR_aux_N2, TYPE_aux); 
                                          apilar_polaca("++","#operator"); } | 
                  ID CONCAT CSTRING {printf("Regla 28\n"); apilar_polaca(getIdTP(), TYPE_aux); 
                                          imprimir_cadena_NUM++; apilar_polaca(STR_aux_N1,TYPE_aux); 
                                          apilar_polaca("++","#operator");} | 
                  ID CONCAT ID {printf("Regla 29\n"); apilar_polaca(getIdTP(), TYPE_aux); 
                                          apilar_polaca(getIdTP(), TYPE_aux);
                                          apilar_polaca("++","#operator");} | 
                  CSTRING CONCAT ID {printf("Regla 30\n");imprimir_cadena_NUM++; apilar_polaca(STR_aux_N1,TYPE_aux); 
                                          apilar_polaca(getIdTP(), TYPE_aux); 
                                          apilar_polaca("++","#operator");};


termino: factor {printf("Regla 31\n");} | 
         termino MULT factor {printf("Regla 32\n"); apilar_polaca("M*","#operator");} | 
         termino DIV factor {printf("Regla 33\n"); apilar_polaca("D/","#operator");} ;

factor: ID {printf("Regla 34\n"); apilar_polaca(getIdTP(),TYPE_aux); } | 
        CENT {printf("Regla 35\n"); apilar_polaca(yylval.valor, TYPE_aux);} | 
        CREAL {printf("Regla 36\n"); apilar_polaca(yylval.valor,TYPE_aux);} | 
        PARENTA expresion_num PARENTC {printf("Regla 37\n");};

comparador: MAYOR {printf("Regla 38\n"); strcpy(comparador_RR, "BLE"); } | 
            MENOR  {printf("Regla 39\n"); strcpy(comparador_RR, "BGE"); } | 
            MENORIGUAL {printf("Regla 40\n"); strcpy(comparador_RR, "BGT"); } | 
            MAYORIGUAL {printf("Regla 41\n"); strcpy(comparador_RR, "BLT"); } | 
            IGUAL {printf("Regla 42\n"); strcpy(comparador_RR, "BEQ"); } | 
            DISTINTO {printf("Regla 43\n"); strcpy(comparador_RR, "BNE");} ;

comparacion:  expresion_num  comparador  expresion_num  {printf("Regla 44\n"); if(habilitar_tira=='s'){apilar_polaca("CMP","#comparator_if");}else if(habilitar_tira=='w'){apilar_polaca("CMP","#comparator_while");}; } | 
              expresion_string  comparador expresion_string  {printf("Regla 45\n"); if(habilitar_tira=='s'){apilar_polaca("CMP","#comparator_if");}else if(habilitar_tira=='w'){apilar_polaca("CMP","#comparator_while");}} ;

comp_logico: PARENTA comparacion PARENTC AND PARENTA comparacion PARENTC {printf("Regla 46\n");apilar_polaca("AND","#logico"); apilar_polaca(comparador_RR,"#asm-comparator"); apilar_polaca(" ","#space");} | 
             PARENTA comparacion PARENTC OR PARENTA comparacion PARENTC {printf("Regla 47\n");apilar_polaca("OR","#logico"); apilar_polaca(comparador_RR,"#asm-comparator"); apilar_polaca(" ","#space");} ;

condicion: NOT PARENTA condicion PARENTC {printf("Regla 48\n"); apilar_polaca("NOT","#logico");} | 
           comparacion {printf("Regla 49\n"); 
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
    final_asm = fopen("final.asm", "w+");
    concat=fopen("concat.txt", "r");

    rewind(lista_tokens);
    rewind(tabla_simbolos);
    rewind(tabla_simbolos_orig);
    rewind(tokens_unicos);
    rewind(repre_intermedia);
    rewind(final_asm);
    
    if((repre_intermedia != NULL)||(input != NULL)||(lista_tokens != NULL)||(tabla_simbolos != NULL)||(tokens_unicos != NULL)||(tabla_simbolos_orig != NULL)||(final_asm != NULL)){
        fprintf (lista_tokens, "%s\t\t%s\n\n", "ID", "NOMBRE");
        fflush(lista_tokens);
        fprintf (tabla_simbolos, "%s\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s\n\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
        fflush(tabla_simbolos);
        fprintf (tabla_simbolos_orig, "%s\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s\n\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
        fflush(tabla_simbolos_orig);

        int recibo;
        recibo = yyparse();
        if (recibo == 0){
           printf(" * * * ¡Parser Ok! * * * \n"); 
        }else   
            printf(" * * * ¡Parser Error! * * * \n");
        fclose(input); 
        fclose(lista_tokens);
        fclose(tokens_unicos);
        fclose(tabla_simbolos_orig); 
        fclose(tabla_simbolos);
        fclose(repre_intermedia);
        fclose(final_asm);
        fclose(concat);
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
    fflush(final_asm);
    fflush(concat);
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

        // si es cte INT o cte REAl
        if((token_confirmado.number == 260) || (token_confirmado.number == 259)) { 
            strcpy(yylval.valor, token_confirmado.valor);  // guardo el valor asociado al token
            strcpy(TYPE_aux, "#");
            strcat(TYPE_aux, token_confirmado.tipo);
            printf("-----------------------------------------------------------YYLVAL TYPE ES : %s\n",TYPE_aux);
            printf("YYLVAL VALOR ES : %s\n",yylval.valor);
        }   
        // si es ID
        else if (yylval.number == 271) {
            if(habilitar_multiple == 'y'){
                strcat(listaIDS, token_confirmado.lexema);
                strcpy(TYPE_aux, "#");
                strcat(TYPE_aux, token_confirmado.tipo);
                printf("-----------------------------------------------------------YYLVAL TYPE ES : %s\n",TYPE_aux);
                
            }else{
                strcpy(listaIDS, " ");
            }
            printf("-----------------------------------------------------------YYLVAL LEXEMA ES : %s\n",listaIDS);
        }
        // si es cte STRING
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
        }
        // si es de tipo INT, REAL o STRING
        else if((yylval.number == 266)||(yylval.number == 267)||(yylval.number == 268)){
            strcpy(TYPE_aux, "#");
            strcat(TYPE_aux, token_confirmado.tipo);
            printf("-----------------------------------------------------------YYLVAL TYPE ES : %s\n",TYPE_aux);
        }
        // si no cumple alguna de las condiciones anteriores, guardo un espacio en blanco
        else{
            strcpy(yylval.valor, " ");  // guardo el valor asociado al token
        }

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
            strcpy ( token.tipo, "-");
            strcpy ( token.valor, "-");
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
/*estado8*/ 	28,	    28,	    28,   	28,	    28,	    28,	    28,	    28,	    28,	    9,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,	    28,     28,     29,     
/*estado9*/	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    10,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,   	9,	    9,	     9,     9,      9,      
/*estado10*/	9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    0,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,	    9,      9,	    9,	     9,     9,      9,      
/*estado11*/	28,	    28,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    12,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     29,     
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
/*F8*/	F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F9,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,	    F,      F,  ERROR,
/*F9*/	F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F10,	F9,	    F9,	    F9,	    F9,   	F9,	    F9,	    F9,	    F9,	    F9,	    F9,   	F9,	    F9,	    F9,  	F9,     F9,     F9,     
/*F10*/	F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F0,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,	    F9,     F9,     F9,
/*F11*/	F,   	F,	    F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	F12,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,  ERROR,
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
            fprintf (tabla_simbolos, "%s\t\t\t\t%s\t\t\t\t%s\t\t\t\t%d\n", token_confirmado.lexema, token_confirmado.tipo, token_confirmado.valor, token_confirmado.longitud);
            fflush(tabla_simbolos);
            fprintf (tabla_simbolos_orig, "%s\t\t\t\t%s\t\t\t\t%s\t\t\t\t%d\n", token_confirmado.lexema, token_confirmado.tipo, token_confirmado.valor, token_confirmado.longitud);
            fflush(tabla_simbolos_orig);
            position_TS++;
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
    //printf("****longitud de yval es: %d****\n",longitud_cad);
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
    char linea[400] = {0};
    char delimitador[] = "\t";
    int numeroToken = 0;

    //printf("INDICE DE TIRA es %d \n", indice_tira);
    rewind(repre_intermedia);

    tira_polaca = (tira*)malloc(asignar*sizeof(tira));
    if(tira_polaca==NULL){
        printf("No se asignó memoria correctamente para tira_polaca\n");
    }
    else{
        if (repre_intermedia == NULL) {
            printf("El fichero no se ha podido abrir para lectura.\n");
            exit(1);
        }   
        else {
            for(int i=0; i<asignar; i++){
                fgets(linea, 400, repre_intermedia);
                //printf("Linea es: %s", linea);
                char * token = strtok(linea, delimitador);

                if(token != NULL){
                    while(token != NULL){
                        numeroToken++;
                    
                        if (numeroToken == 1){
                            strcpy(auxIndice, token);
                            strcpy(tira_polaca[i].index, auxIndice);
                            //printf("Token es: %s\n", tira_polaca[i].index);
                        }else if (numeroToken == 2){
                            strcpy(auxCelda, token);
                            strcpy(tira_polaca[i].cell, auxCelda);
                            //printf("Token es: %s\n", tira_polaca[i].cell);
                        }else if (numeroToken == 3){
                            strcpy(auxEtiqueta, token);
                            strcpy(tira_polaca[i].tag, auxEtiqueta);
                            //printf("Token es: %s\n", tira_polaca[i].tag);
                            numeroToken = 0;
                        }
                        token = strtok(NULL, delimitador);
                    }
                    //printf("\n\n");
                }

                // para salir del bucle y evitar duplicados de linea
                if(i == asignar) printf("SALE\n");
            }
        }
    }

    printf("\n * * SE GENERO LA ESTRUCTURA DE TIRA POLACA! * * \n\n");
}
///////////////////////////////////////////////////////////////////////////////////////////////
void aplicar_algoritmo_pilas(){
    printf("\n - - Estoy aplicando algoritmo de pilas. . .  - - \n\n");

    // defino las pilas para if y while
    struct pila pila_while;
    struct pila pila_if;

    // defino los elementos para if y while
    struct elemento elem_while;
    struct elemento elem_if;
    struct elemento elemento_tope_while;
    struct elemento elemento_tope_if;

    // defino los indices de los arreglos: tira if y tira if while
    int position_wh = -1;
    int position_if = -1;

    //string para itoa
    char string_espWhite[40]={0};

    // asignamos espacio para los arreglos: tira if y tira if while. 
    // Vamos a guardar los indices de la tira polaca (ya llena anteriormente)
    tiraIW *tira_wh, *tira_if;
	tira_wh = (tiraIW *)malloc(TAM*sizeof(tiraIW));
    tira_if = (tiraIW *)malloc(TAM*sizeof(tiraIW));

    //auxiliar para pilas
    int aux_z_wh=0;
    int aux_z_if=0;

    // preguntamos si se reservo espacio para las tiras
    if((tira_wh == NULL)||(tira_if == NULL)){
		printf("No se asigno espacio para tira while o tira if\n");
        exit(1);
	}

    // creamos las pilas while e if
    crear(&pila_while);
    crear(&pila_if);
    
    // ************* logica del algoritmo de pilas **********************

    ///////////////////   logica pila while   ///////////////////
    for(int j=0; j<indice_tira; j++) {
        //printf("tag is:%s\n", tira_polaca[j].tag);
        if(strcmp(tira_polaca[j].cell,";WH_I;")==0){
            position_wh++; // primer incremento --> es 0
            //printf("lei el inicio de un while en celda %s +1\n",tira_polaca[j].index);
            int indice_tira_aux = 1 + atoi(tira_polaca[j].index);
            //printf("Indice tiene el valor = %d\n",indice_tira_aux);
            elem_while = tira_wh[position_wh].registro;  // guardamos el elemento registro
            elem_while.dato = indice_tira_aux;
            elem_while.posicion = j;  // guarda la posicion actual
            apilar(&pila_while, elem_while);
        }
        //condicion simple
        else if((strcmp(tira_polaca[j].tag,"#comparator_while\n")==0) && (strcmp(tira_polaca[j+3].tag,"#comparator_while\n")!=0) && (strcmp(tira_polaca[j+1].cell,";NOT;")!=0)){
            //printf("COMPARATOR WHILE\n");
            position_wh++; // primer incremento --> es 0
            int indice_tira_aux = 2 + atoi(tira_polaca[j].index);
            elem_while = tira_wh[position_wh].registro;  // guardamos el elemento registro
            elem_while.dato = indice_tira_aux;
            elem_while.posicion = j;  // guarda la posicion actual
            apilar(&pila_while, elem_while);
        }
        //and/or
        else if((strcmp(tira_polaca[j].tag,"#comparator_while\n")==0) && (strcmp(tira_polaca[j+3].tag,"#comparator_while\n")==0)&& (strcmp(tira_polaca[j+4].cell,";AND;")==0) || (strcmp(tira_polaca[j+4].cell,";OR;")==0)){
            position_wh++; // primer incremento --> es 0
            int indice_tira_aux = 6 + atoi(tira_polaca[j].index);
            elem_while = tira_wh[position_wh].registro;  // guardamos el elemento registro
            elem_while.dato = indice_tira_aux;
            elem_while.posicion = j;  // guarda la posicion actual
            apilar(&pila_while, elem_while);
        }
        //not
        else if((strcmp(tira_polaca[j].tag,"#comparator_while\n")==0) && (strcmp(tira_polaca[j+1].cell,";NOT;")==0)){
            position_wh++; // primer incremento --> es 0
            int indice_tira_aux = 3 + atoi(tira_polaca[j].index);
            elem_while = tira_wh[position_wh].registro;  // guardamos el elemento registro
            elem_while.dato = indice_tira_aux;
            elem_while.posicion = j;  // guarda la posicion actual
            apilar(&pila_while, elem_while);
        }else if(strcmp(tira_polaca[j].cell,";WH_F;")==0){
            //printf("FIN WHILE\n");
            int indice_tira_aux = 1 + atoi(tira_polaca[j].index);
            aux_z_wh= retornar_tope(&pila_while , &elemento_tope_while);
            //printf("aux_z_whi es %d:\n",aux_z_wh);
            desapilar(&pila_while , &elemento_tope_while);
            //EN celda Z, PONGO CELDA ACTUAL+1
            sprintf(string_espWhite,"%d",indice_tira_aux);
            strcpy(tira_polaca[aux_z_wh].cell , ";");
            strcat(tira_polaca[aux_z_wh].cell , string_espWhite);//copiamos en celda aux_z_wh la celda actual+1 
            strcat(tira_polaca[aux_z_wh].cell , ";");
            //printf("celda espacio en blanco, es: %s\n",tira_polaca[aux_z_wh].cell);

            indice_tira_aux =atoi(tira_polaca[j].index)-2;
            //printf("indice_tira_aux, osea celda actual -2 es: %d",indice_tira_aux);
            aux_z_wh= retornar_tope(&pila_while , &elemento_tope_while);
            //printf("aux_z_whi es %d:\n",aux_z_wh);
            desapilar(&pila_while, &elemento_tope_while);
            //PONGO CELDA ACTUAL-2 , PONGO Z
            sprintf(string_espWhite,"%d",aux_z_wh);
            strcpy(tira_polaca[indice_tira_aux].cell , ";");
            strcat(tira_polaca[indice_tira_aux].cell , string_espWhite);
            strcat(tira_polaca[indice_tira_aux].cell , ";");
            //printf("celda espacio en blanco, es: %s\n" , tira_polaca[indice_tira_aux].cell);
        }

    }
    
    int tam = tamano(pila_while);
    printf(" -  Tamanio pila while despues de aplicar el algortimo es: %d  -  \n",tam);
    //mostrar(&pila_while, &elemento_tope_while);

    ///////////////////   logica pila if    ///////////////////
    for(int j=0; j<indice_tira; j++) {
        tam = tamano(pila_if);
        if(strcmp(tira_polaca[j].cell,";IF_I;")==0){
            position_if++; // primer incremento --> es 0
            //printf("lei el inicio de un if en celda %s +1\n",tira_polaca[j].index);
            int indice_tira_aux = 1 + atoi(tira_polaca[j].index);
            //printf("Indice tiene el valor = %d\n",indice_tira_aux);
            elem_if = tira_if[position_if].registro;  // guardamos el elemento registro
            elem_if.dato = indice_tira_aux;
            elem_if.posicion = j;  // guarda la posicion actual
            apilar(&pila_if, elem_if);
        }
        //condicion simple
        else if((strcmp(tira_polaca[j].tag,"#comparator_if\n")==0) && (strcmp(tira_polaca[j+3].tag,"#comparator_if\n")!=0) && (strcmp(tira_polaca[j+3].tag,"#space\n")!=0)){ 
            //printf("COMPARATOR IF\n");
            position_if++; // primer incremento --> es 0
            int indice_tira_aux = 2 + atoi(tira_polaca[j].index);
            elem_if = tira_if[position_if].registro;  // guardamos el elemento registro
            elem_if.dato = indice_tira_aux;
            elem_if.posicion = j;  // guarda la posicion actual
            apilar(&pila_if, elem_if);
        }
        //AND/OR
        else if((strcmp(tira_polaca[j].tag,"#comparator_if\n")==0) && (strcmp(tira_polaca[j+3].tag,"#comparator_if\n")==0) && (strcmp(tira_polaca[j+4].cell,";AND;")==0) || (strcmp(tira_polaca[j+4].cell,";OR;")==0)){
            position_if++; // primer incremento --> es 0
            int indice_tira_aux = 6 + atoi(tira_polaca[j].index);
            elem_if = tira_if[position_if].registro;  // guardamos el elemento registro
            elem_if.dato = indice_tira_aux;
            elem_if.posicion = j;  // guarda la posicion actual
            apilar(&pila_if, elem_if);
            printf("QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ indice tira aux= %d", indice_tira_aux);
        }
        //not
        else if((strcmp(tira_polaca[j].tag,"#comparator_if\n")==0) && (strcmp(tira_polaca[j+1].cell,";NOT;")==0)){
            position_if++; // primer incremento --> es 0
            int indice_tira_aux = 3 + atoi(tira_polaca[j].index);
            elem_if = tira_if[position_if].registro;  // guardamos el elemento registro
            elem_if.dato = indice_tira_aux;
            elem_if.posicion = j;  // guarda la posicion actual
            apilar(&pila_if, elem_if);
        }
        else if(strcmp(tira_polaca[j].cell,";IF_F;")==0){
            //printf("FIN IF\n");
            int indice_tira_aux = 1 + atoi(tira_polaca[j].index);
            aux_z_if= retornar_tope(&pila_if , &elemento_tope_if);
            printf("aux_z_if es %d:\n",aux_z_if);
            desapilar(&pila_if , &elemento_tope_if);
            //EN celda Z, PONGO CELDA ACTUAL+1
            sprintf(string_espWhite,"%d",indice_tira_aux);
            strcpy(tira_polaca[aux_z_if].cell , ";");
            strcat(tira_polaca[aux_z_if].cell , string_espWhite);//copiamos en celda aux_z_if la celda actual+1 
            strcat(tira_polaca[aux_z_if].cell , ";");
            //printf("celda aux_z_if %d que estaba en blanco ahora es: %s\n",aux_z_if,tira_polaca[aux_z_if].cell);
        
            indice_tira_aux =  atoi(tira_polaca[j].index) -2;
            //printf("apilo celda indice_tira_aux , es decir:%d\n", indice_tira_aux);
            position_if++;
            elem_if = tira_if[position_if].registro;  // guardamos el elemento registro
            elem_if.dato = indice_tira_aux;
            elem_if.posicion = j;  // guarda la posicion actual
            apilar(&pila_if, elem_if);
        }else if (strcmp(tira_polaca[j].cell,";ELSE_F;")==0){
            //printf("FIN ELSE\n");
            int indice_tira_aux = 1 + atoi(tira_polaca[j].index);
            aux_z_if= retornar_tope(&pila_if , &elemento_tope_if);
            //printf("aux_z_if es %d:\n",aux_z_if);
            desapilar(&pila_if , &elemento_tope_if);
            //EN celda Z, PONGO CELDA ACTUAL+1
            sprintf(string_espWhite,"%d",indice_tira_aux);
            strcpy(tira_polaca[aux_z_if].cell , ";");
            strcat(tira_polaca[aux_z_if].cell , string_espWhite);//copiamos en celda aux_z_if la celda actual+1 
            strcat(tira_polaca[aux_z_if].cell , ";");
            //printf("celda aux_z_if %d que estaba en blanco ahora es: %s\n",aux_z_if,tira_polaca[aux_z_if].cell);
            aux_z_if= retornar_tope(&pila_if , &elemento_tope_if);
            //printf("aux_z_if desapilo inicio de condicion inservible y es %d:\n",aux_z_if);
            desapilar(&pila_if , &elemento_tope_if);
        }
        
    }
    tam = tamano(pila_if);
    printf(" -  Tamanio pila if despues de aplicar el algortimo es: %d   -  \n",tam);
    //mostrar(&pila_if, &elemento_tope_if);
    
    printf("\n - - SE APLICO CORRECTAMENTE EL ALGORITMO DE PILAS! - - \n\n");
    printTiraPolaca();
}
///////////////////////////////////////////////////////////////////////////////////////////////
void mostrar_polaca(){
    for(int j=0; j<indice_tira; j++) {
        printf ("%s %s %s\n", tira_polaca[j].index, tira_polaca[j].cell, tira_polaca[j].tag);
    }
     printf("\n * * SE IMPRIMIO LA ESTRUCTURA DE TIRA POLACA CON EL ALGORITMO DE PILAS APLICADO! * * \n\n");
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//    FUNCIONES PARA LAS PILAS   //

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int crear(struct pila *p) {
	p->frente = NULL;
	p->tamano = 0;
	return 1;
}

int apilar(struct pila *p, struct elemento elemento){
	struct elemento *nuevo = (struct elemento *) malloc(sizeof(struct elemento));
	
    if (nuevo == NULL) { 
        return -1; 
    }
	nuevo->dato = elemento.dato;
	nuevo->next = NULL;
	
	nuevo->next = p->frente;
	p->frente = nuevo;
	p->tamano++;
	return 1;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
int desapilar(struct pila *p, struct elemento *elemento){
	// si la pila esta vacia retornamos -1
	if (estaVacia(*p) ) { return -1; }

	elemento->dato = p->frente->dato;
	p->frente = p->frente->next;
	p->tamano--;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
int estaVacia(struct pila p){
	if (p.tamano == 0) { return 1; }
	return 0;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
int tamano(struct pila p){
	return p.tamano;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
int retornar_tope(struct pila *p, struct elemento *elemento){
    elemento->dato = p->frente->dato;
    //printf("Elemento dato es: %d\n",elemento->dato);
    return elemento->dato;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////7
int mostrar(struct pila *p, struct elemento *elemento){
	struct pila *p_aux;
	p_aux = p;

	int tamanio = p_aux->tamano;
	// si la pila esta vacia retornamos -1
	if (estaVacia(*p_aux) ) { 
        return -1;
    } 
	// sino, mostramos el contenido
    for(int i=0; i<tamanio; i++){
		elemento->dato = p_aux->frente->dato;
        //printf("Elemento dato es: %d\n",elemento->dato);
		if(i!=tamanio-1)
			p_aux->frente = p_aux->frente->next;
    }
    return 1;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
char * getIdTP(){
    int indice=-1; char * cad_aux;
    char letter; int i,j;
    
    for(j=0; j<40;j++){
        ID_aux_TP[j] = '\0';
    }
    
    int length = strlen(listaIDS);
    //printf("Tengo %d caracteres\n", length);
    
    for(i=length-1; i>=0; i--){
        letter = listaIDS[i];
        //printf("letter is: %c\n", letter);
        indice++;
        ID_aux_TP[indice] = letter;
        listaIDS[i] = '\0';
        if(letter == '$') break;
    }
    //printf("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYyVALLLLLLLLLLLLLLLLLLLLLLLLLLLLLL es: %ld\n",strlen(ID_aux_TP));
    cad_aux = invertir(ID_aux_TP);
    return cad_aux;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
char *invertir(char cadena[]) {
  int longitud = strlen(cadena);
  char temporal;
  for (int izquierda = 0, derecha = longitud - 1; izquierda < (longitud / 2);
       izquierda++, derecha--) {
    temporal = cadena[izquierda];
    cadena[izquierda] = cadena[derecha];
    cadena[derecha] = temporal;
  }
  return cadena;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void mostrar_TSD(){
    
    for(int j=0; j<position_TS; j++) {
        printf ("%s %s %s %s\n", dinamic_TS[j].nombre, dinamic_TS[j].tipo, dinamic_TS[j].valor,dinamic_TS[j].longitud);
    }
    
     printf("\n * * SE IMPRIMIO LA ESTRUCTURA DE LA TABLA DE SIMBOLOS DINAMICA! * * \n\n");
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
void llenarTS(){
    //printf("Posicion max TS es: %d\n", position_TS);
    rewind(tabla_simbolos);
      
    char auxNombre[40]={0};

    char auxTipo[40]={0};
    char auxValor[40]={0};
    char auxLongitud[40]={0};

    char linea[400] = {0};
    char delimitador[] = "\t";
    int numeroToken = 0;
    dinamic_TS = (TablaSimbolos*)malloc(position_TS*sizeof(TablaSimbolos));

     if(dinamic_TS==NULL){
        printf("No se asignó memoria correctamente para dinamic TS\n");
    }else{
        if (tabla_simbolos == NULL) {
            printf("El fichero no se ha podido abrir para lectura.\n");
            exit(1);
        }else{
            for(int i=0; i<position_TS+2; i++){
                fgets(linea, 400, tabla_simbolos);
            
                if(i>=2){
                    //printf("Linea es: %s\n", linea);
                    char * token = strtok(linea, delimitador);

                    if(token != NULL){
                        while(token != NULL){
                            numeroToken++;
                        
                            if (numeroToken == 1){
                                strcpy(auxNombre, token);
                                strcpy(dinamic_TS [i-2].nombre, auxNombre);
                                //printf("Token es: %s\n", dinamic_TS[i-2].nombre);
                            }else if (numeroToken == 2){
                                strcpy(auxTipo, token); 
                                strcpy(dinamic_TS [i-2].tipo, auxTipo);
                                //printf("Token es: %s\n", dinamic_TS[i-2].tipo);
                            }else if (numeroToken == 3){
                                strcpy(auxValor, token);
                                strcpy(dinamic_TS[i-2].valor, auxValor);
                                //printf("Token es: %s\n", dinamic_TS[i].valor);
                            }else if (numeroToken == 4){
                                strcpy(auxLongitud, token);
                                strcpy(dinamic_TS[i-2].longitud, auxLongitud);
                                //printf("Token es: %s\n", dinamic_TS[i].longitud);
                                numeroToken = 0;
                            }
                            token = strtok(NULL, delimitador);
                        }
                        //printf("\n\n");
                    }
                    // para salir del bucle y evitar duplicados de linea
                    if(i == position_TS+1) printf("SALE\n");
                }
                
            }
        }
    }

    printf("\n * * SE GENERO LA ESTRUCTURA DE LA TABLA DE SIMBOLOS DINAMICA! * * \n");
    mostrar_TSD();
    addTypeTS();
    printTS();
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
char * removeSubString(char str [],int num_tipo){ // quita los tipos de datos (int, real, string) despues de haber aplicado strstr()
    char tmpCad [300];
    int indice=-1;
    for (int i = 0; i < strlen(str)+1; i++) {
        if(i >= num_tipo){
            indice++;
            tmpCad[indice] = str[i];
        }
    }
    strcpy(str, tmpCad);
    return str;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
char * insertSpaWhite(char line []){
    char tmpCad [300];
    printf("La vieja fila es: %s\n", line);
    for(int i=0; i<strlen(line)+1; i++){
        if(i==0){
            tmpCad[i] = ' ';
        }
        if(i>0){
            tmpCad[i] = line[i-1];
        }
    }
    strcpy(line, tmpCad);
    printf("La nueva fila es: %s\n", line);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void actualizarTS(char type[],int num_tipo){
    char linea[300] = {0}; char cadena_aux[300]={0}; char cadena_aux_2[300]={0}; char nuevo_arreglo[300]={0};
    int indice_arreglo=-1;
    char * arreglo_int_aux; char * arreglo_enddec_aux;  char * arreglo_int;
    int i=0, num_linea=0;
    cadena_aux_2[0]='%';
    int foraux=0;
    rewind(input);  // rebobino el fichero al principio
    
    while(1)
    { // se ejecuta hasta encontrar un enddeclare
        fgets(linea, 300, input);  // leemos cada fila del fichero input.txt
        arreglo_int = insertSpaWhite(linea);

        printf("Linea de fichero input es: %s\n",linea);
        num_linea++;  // Es un contador de linea. En la primera pasada, vale 1
    
        arreglo_enddec_aux = strstr(linea, "enddeclare");
        arreglo_int_aux = strstr(linea, type);
        printf("Arreglo_enddec_aux : %s\n", arreglo_enddec_aux);

       if(arreglo_int_aux != NULL) {
           while(1)
           {
                printf("el arreglo_int_aux es: %s\n", arreglo_int_aux); // imprime toda la fila, desde int.

                for (i=0 ; i<300 ; i++){  // recorro toda la fila, desde int
                    if( (i>=num_tipo) && (arreglo_int_aux[i] != ';') && (arreglo_int_aux[i] != ' ') && (arreglo_int_aux[i] != '\0') ){  // pregunto por lo que sigue despues de int
                        indice_arreglo++; // primera pasada --> 0
                        printf("\n\n I es: %d\n\n",indice_arreglo);
                        //printf("\narreglo_int_aux[%d]es: %s\n\n\n", i,arreglo_int_aux[i]);
                        cadena_aux[indice_arreglo] = arreglo_int_aux[i]; // desde la posicion que sigue al string int, empiezo a guardar datos
                        printf("letra de cadena_aux es: %c\n", cadena_aux[indice_arreglo]);
                        strcpy(nuevo_arreglo, cadena_aux );
                        printf("\nnuevo_Arreglo es: %s\n\n\n", nuevo_arreglo);
                    }
                    else if( (i>=num_tipo) && (arreglo_int_aux[i] == ';') && (arreglo_int_aux[i] != ' ') && (arreglo_int_aux[i] != '\0') ) {
                        indice_arreglo++;
                        printf("\n\n I es: %d\n\n",indice_arreglo);
                        //printf("\narreglo_int_aux[%d]es: %s\n\n\n", i,arreglo_int_aux);
                        strcat(cadena_aux, ",");
                        printf("letra de cadena_aux es: %c\n\n", cadena_aux[indice_arreglo]);
                        printf("\ncadena_aux es x else: %s\n\n\n", cadena_aux);
                        break;  // sale del bucle for (i=0 ; i<400 ; i++)
                    }
                }
                // para evitar que se omitan otras cadenas
                for(i =0; i<300;i++){
                    if(foraux<300){
                        if (cadena_aux[i]!=','){
                        cadena_aux_2[foraux+1]=cadena_aux[i];
                        foraux++;
                        }
                        if((cadena_aux[i]==',')&&(cadena_aux[i+1]!='\0')){
                            cadena_aux_2[foraux+1]=',';
                            cadena_aux_2[foraux+2]='%';
                            foraux= foraux +2;
                        }         
                    }
                }
                strcat(cadena_aux_2,",");
                printf("--------------------- cadena_aux_2 es: %s\n\n\n", cadena_aux_2);
                foraux=0;

                //printf("arreglo antes es: %s\n", arreglo_int_aux);
                arreglo_int = removeSubString(arreglo_int_aux,num_tipo); // string x,y;        string x;
                strcpy(arreglo_int_aux, arreglo_int);

                //printf("ANTES arreglo_int_aux es: %s\n", arreglo_int_aux);
                arreglo_int_aux = strstr(arreglo_int_aux, type);
                //printf("DESPUES arreglo_int_aux es: %s\n", arreglo_int_aux);
                
                if(arreglo_int_aux == NULL) {
                    break; // sale del primer bucle xq ya detecto el enddeclare, y no necesito leer mas nada
                }
            }
        }
        if(arreglo_enddec_aux != NULL) {
            break; // sale del primer bucle xq ya detecto el enddeclare, y no necesito leer mas nada
        }

    }
     for(i=0;i<position_TS;i++){	       //recorro dinamicTS
        char cadenita [40]= {0};
        cadenita[0]='%';
        
        for(int j=1; j<40; j++){
            cadenita[j] = dinamic_TS[i].nombre[j];
        }
        
        strcat(cadenita,",");
        printf("\n\ncadenita es %s:\n\n",cadenita);
        printf("\n\ny la comparo con cadena_aux que es %s\n\n:",cadena_aux_2);
        if (strstr(cadena_aux_2,cadenita) != NULL){
                strcpy(dinamic_TS[i].tipo, type);
        }
        printf("\n\ndinamic_ts tipo ahora es %s:\n\n",dinamic_TS[i].tipo);
    }

    mostrar_TSD(); 
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void addTypeTS(){ 
    for(int i=1; i<=3;i++){
        switch (i){
            case 1: actualizarTS(" int ",4);
                  break;
            case 2: actualizarTS(" real ",5);
                  break;
            case 3: actualizarTS(" string ",7);
                  break;
        }
    }   
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void printTS(){
    fclose(tabla_simbolos);

    tabla_simbolos = fopen("tabla_simbolos.txt", "w+");
    rewind(tabla_simbolos);

    if(tabla_simbolos != NULL){
        fprintf (tabla_simbolos, "%s\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s\n\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
        fflush(tabla_simbolos); 

        for(int j=0;j<position_TS;j++){
            if(strcmp(dinamic_TS[j].tipo,"real")==0||strcmp(dinamic_TS[j].tipo,"real ")==0||strcmp(dinamic_TS[j].tipo,"real\0")==0){
                printf("estoy en if de real\n\n");
                for(int k=0;k<strlen(dinamic_TS[j].nombre);k++){
                    printf("estoy en for de nombre\n\n");
                     printf("nombre[k] es:%c;\n\n",dinamic_TS[j].nombre[k] );
                    if(dinamic_TS[j].nombre[k]=='.'){
                        printf("estoy en punto.\n\n");
                        dinamic_TS[j].nombre[k]='_';
                    }
                }
            }
        }

        for(int i=0;i<position_TS;i++){
            fprintf (tabla_simbolos, "%s\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s", dinamic_TS[i].nombre, dinamic_TS[i].tipo, dinamic_TS[i].valor, dinamic_TS[i].longitud);
            fflush(tabla_simbolos);
        }
    }  // NO HACE FALTA CERRAR EL ARCHIVO --> se hace en el MAIN()
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void printTiraPolaca(){  // <--- ACA HAY QUE COMPROBAR TIPOS. SE llama en la f() donde se aplica el algoritmo
    fclose(repre_intermedia);     // de pilas
    char id_name_TS[40];
    //char type_TS[40];
    
    repre_intermedia = fopen("intermedia.txt", "w+");
    //rewind(repre_intermedia);

    if(repre_intermedia != NULL){
        for(int i=0;i<position_TS;i++){
            strcpy(id_name_TS, ";");  // para hacer la comparacion de TS con la tira polaca
            strcat(id_name_TS, dinamic_TS[i].nombre);
            strcat(id_name_TS, ";");  // para hacer la comparacion de TS con la tira polaca

            for(int j=0; j<indice_tira; j++) {
                if(strcmp(id_name_TS, tira_polaca[j].cell) == 0){

                    
                    strcpy(tira_polaca[j].tag, "#");
                    for(int z=1;z<=strlen(dinamic_TS[z].tipo)+1;z++){
                        if(z==1){
                        tira_polaca[j].tag[z]=dinamic_TS[i].tipo[z];
                        }else{
                            tira_polaca[j].tag[z]=dinamic_TS[i].tipo[z];
                        }
                    }
                    //strcat(tira_polaca[j].tag, dinamic_TS[i].tipo);
                }
                
            }
        }
        for(int v=0;v<indice_tira;v++){
            if(strcmp(tira_polaca[v].tag,"#stringg\n") == 0){
                    strcpy(tira_polaca[v].tag,"#string");
            }
        }
        // printeo en el archivo
        for(int itp=0; itp<indice_tira; itp++) {
                //tira_polaca[itp].tag[strlen(tira_polaca[itp].tag)-1] = ' ';
                //printf("¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿¿%s po\n", tira_polaca[itp].tag);

                if((tira_polaca[itp].cell[1] == '$')&&(tira_polaca[itp].tag[1] != 's')) {
                    fprintf(repre_intermedia, "%s\t%s\t%s\n", tira_polaca[itp].index, tira_polaca[itp].cell, tira_polaca[itp].tag);
                    fflush(repre_intermedia);
                }else{
                    fprintf(repre_intermedia, "%s\t%s\t%s", tira_polaca[itp].index, tira_polaca[itp].cell, tira_polaca[itp].tag);
                    fflush(repre_intermedia);
                }
          
        }
    }// NO HACE FALTA CERRAR EL ARCHIVO --> se hace en el MAIN()
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void verificar_tipos(){
    int jaux=0,zaux=0,ultimo_asign=0, primer_asign=0, fin_de_asign=0, inicio_ultimo_asign=0;
    char tipos_aux[30]={0};
    char caux=' ';

    
    for(int j=0; j<indice_tira; j++) {  //para las comparaciones #cstring #string
       
        if(j>=2){
            
            if((tira_polaca[j-1].tag[1]=='c')&&(tira_polaca[j-1].tag[2]=='s')){
                strcpy(tira_polaca[j-1].tag,"#string");
            }
            if((tira_polaca[j-2].tag[1]=='c')&&(tira_polaca[j-2].tag[2]=='s')){
                strcpy(tira_polaca[j-2].tag,"#string");
            } 
       
                
            if(strcmp(tira_polaca[j].cell,";CMP;")==0){
                if((tira_polaca[j-1].tag[1])!=(tira_polaca[j-2].tag[1])){ 
                    printf("error de tipos en %s:\n",tira_polaca[j].index);
                    //system("pause");
                    exit(1);  
                }
            }
            if(strcmp(tira_polaca[j].cell,";++;")==0){  
                if(tira_polaca[j-1].tag[1]!=tira_polaca[j-2].tag[1]){
                    printf("error de tipos en %s:\n",tira_polaca[j].index);
                    //system("pause");
                    exit(1);   
                    }
            }
            if(strcmp(tira_polaca[j].cell,";=;")==0){
                printf("\n\nestoy por entrar a la tira de las ASIGN\n\n");
                if(primer_asign==0){
                    primer_asign=1;
                }
                
                jaux=j;
                while(strcmp(tira_polaca[jaux+2].cell,";=;")==0){
                    jaux = jaux +2;
                    j=jaux;
                    printf("\n\nencontre otro ASIGN en :%d\n\n", jaux);
                }

                // desde jaxu (oomitiendo ;=;) hasta que aparezca 
                //||#space||fin_wh||fin_if||#asm-jump(bi eslef)
                if(primer_asign==1){          //guardo inicio y fin de primera asignacion que aparece
                    int a=jaux;
                    inicio_ultimo_asign=a;
                    for(a;a>=0;a--){     
                        if((strcmp(tira_polaca[a].tag,"#space")==0)||(strcmp(tira_polaca[a].tag,"#space\n")==0)||
                        (strcmp(tira_polaca[a].tag,"#fin_wh")==0)||(strcmp(tira_polaca[a].tag,"#fin_wh\n")==0)||
                        (strcmp(tira_polaca[a].tag,"#fin_if")==0)||(strcmp(tira_polaca[a].tag,"#fin_if\n")==0)||
                        (strcmp(tira_polaca[a].tag,"#asm-jump")==0)|| (strcmp(tira_polaca[a].tag,"#asm-jump\n")==0)||
                        (a==0)){
                            printf("\nprimera asignacion termina en :%d\n", a);
                            fin_de_asign=a;
                            primer_asign=2;
                            break;
                        }                     
                    }       
                }
                else if(primer_asign==2){   //guardo inicio y fin de la siguiente asignacion que aparece
                    int a=jaux;
                    for(a;a>=inicio_ultimo_asign;a--){     
                        if((strcmp(tira_polaca[a].tag,"#space")==0)||(strcmp(tira_polaca[a].tag,"#space\n")==0)||
                        (strcmp(tira_polaca[a].tag,"#fin_wh")==0)||(strcmp(tira_polaca[a].tag,"#fin_wh\n")==0)||
                        (strcmp(tira_polaca[a].tag,"#fin_if")==0)||(strcmp(tira_polaca[a].tag,"#fin_if\n")==0)||
                        (strcmp(tira_polaca[a].tag,"#asm-jump")==0)|| (strcmp(tira_polaca[a].tag,"#asm-jump\n")==0)||
                        (a==inicio_ultimo_asign)){
                            printf("\nsiguiente asignacion termina en :%d\n", a);
                            fin_de_asign=a;
                            break;
                        }                     
                    }
                    inicio_ultimo_asign=jaux;    //seteo el inicio de esta asignacion por si viene otra asignacion
                }
                
                
                printf("\n\n Al entrar al FOR, JAUX=%d, inicio_ultimo_asign=%d y findeasign=%d\n\n",jaux,inicio_ultimo_asign, fin_de_asign);                             
                for(jaux;jaux>=fin_de_asign;jaux--){ 
                    printf("\n\nEstoy en celda %d para comparar tipos en asignacion\n\n", jaux);
                    
                    
                    if((strcmp(tira_polaca[jaux].tag,"#int")==0)||(strcmp(tira_polaca[jaux].tag,"#int ")==0)||(strcmp(tira_polaca[jaux].tag,"#int\0")==0)||(strcmp(tira_polaca[jaux].tag,"#int\n")==0)){
                        printf("tira_polaca[%d].cell: %s, tira_polaca[%d].tag %s\n", jaux,tira_polaca[jaux].cell,jaux,tira_polaca[jaux].tag);
                        tipos_aux[zaux]='r'; //lleno vector auxiliar con i para tipo int
                        zaux++;
                    }
                    if((strcmp(tira_polaca[jaux].tag,"#real")==0)||(strcmp(tira_polaca[jaux].tag,"#real ")==0)||(strcmp(tira_polaca[jaux].tag,"#real\0")==0)||(strcmp(tira_polaca[jaux].tag,"#real\n")==0)){
                        printf("tira_polaca[%d].cell: %s, tira_polaca[%d].tag %s\n", jaux,tira_polaca[jaux].cell,jaux,tira_polaca[jaux].tag);
                        tipos_aux[zaux]='r'; //lleno vector auxiliar con r para tipo real
                        zaux++;
                    }
                    if((strcmp(tira_polaca[jaux].tag,"#string")==0)||(strcmp(tira_polaca[jaux].tag,"#cstring")==0)||(strcmp(tira_polaca[jaux].tag,"#stringg\n")==0)||(strcmp(tira_polaca[jaux].tag,"#string\n")==0)||(strcmp(tira_polaca[jaux].tag,"#cstring\0")==0)||(strcmp(tira_polaca[jaux].tag,"#cstring\n")==0)){
                        printf("tira_polaca[%d].cell: %s, tira_polaca[%d].tag %s\n", jaux,tira_polaca[jaux].cell,jaux,tira_polaca[jaux].tag);
                        printf("es string\n"); 
                        tipos_aux[zaux]='s'; //lleno vector auxiliar con s para tipo string
                        zaux++;
                    } 
                    if((strcmp(tira_polaca[jaux].tag,"#")==0)||strcmp(tira_polaca[jaux].tag,"#")==0){
                        printf("es NO declarada\n"); 
                        tipos_aux[zaux]='x'; //lleno vector auxiliar con x para tipo no declarada
                        zaux++;
                    }
                    if((strcmp(tira_polaca[jaux].tag,"#space")==0)||(strcmp(tira_polaca[jaux].tag,"#space\n")==0)||
                        (strcmp(tira_polaca[jaux].tag,"#fin_wh")==0)||(strcmp(tira_polaca[jaux].tag,"#fin_wh\n")==0)||
                        (strcmp(tira_polaca[jaux].tag,"#fin_if")==0)||(strcmp(tira_polaca[jaux].tag,"#fin_if\n")==0)||
                        (strcmp(tira_polaca[jaux].tag,"#asm-jump")==0)||(strcmp(tira_polaca[jaux].tag,"#asm-jump\n")==0)){
                            printf("\nentre en el break en :%d\n", jaux); //si encuentro algo de esto, finalize el guardado de tipos de asignacion que inicio en jaux
                            break;
                    }
                    
                }  
                printf("\n\n TIPOS AUX, ES: %s\n\n",tipos_aux); 
                caux=tipos_aux[0];
                for(jaux=1;jaux<strlen(tipos_aux);jaux++){
                    printf("\nestoy comparando VECTOR TIPOS_AUX\n");
                    if(caux!=tipos_aux[jaux]){
                    printf("error de tipos en %s:\n",tira_polaca[j].index);  //si el vector no contiene letras de un solo tipo, hay error de tipos
                    //system("pause");
                    exit(1);
                    }   
                }
                for(int k=0;k<30;k++){
                    tipos_aux[k]='\0';
                }
                zaux=0;     
            }
        }
    }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void generarAssembler(){
    char auxiliarN[30]={0};  // auxiliar que guarda el nombre de TS
    char auxiliarT[3]={0};   // auxiliar que guarda el tipo de TS
    char auxiliarV[30]={0};  // auxiliar que guarda el valor de TS
    char auxiliarCV[30]={0};  // auxiliar que representa los valores de la celda de Tira Polaca
    char auxiliarCI[30]={0};  // auxiliar que representa los ids de la celda de Tira Polaca
    int  auxiliarPosAMult = 0; // auxiliar posicion de donde se encuentra el ultimo id la asignacion multiple
    int flagmult = 0; // bandera para obtener la posicion del ultimo id de asignacion multiple ya que lee desde el ultimo al primer id de la asignacion multiple
    int data1=0;
    int auxI=0;

    fprintf (final_asm, "include macros2.asm\n");
    fflush(final_asm);
    fprintf (final_asm, "include number.asm\n\n");
    fflush(final_asm);

    fprintf (final_asm, ".MODEL LARGE\n");
    fflush(final_asm);
    fprintf (final_asm, ".386\n");
    fflush(final_asm);
    fprintf (final_asm, ".STACK 200h\n");
    fflush(final_asm); 
    fprintf (final_asm, ".DATA\n");
    fflush(final_asm); 
    fprintf (final_asm, "MAXTEXTSIZE equ 50\n\n");
    fflush(final_asm); 

    for(int i=0;i<position_TS;i++){
        //para sacar comillas de nombre de var cstring
        if(dinamic_TS[i].nombre[1]=='"'){  
            auxiliarN[0]='$';
            for(int j=2;j<strlen(dinamic_TS[i].nombre)-1;j++){
                auxiliarN[j-1]=dinamic_TS[i].nombre[j];                
            }
        }else{
            strcpy(auxiliarN,dinamic_TS[i].nombre);
        }

        //para int y real
        if((strstr(dinamic_TS[i].tipo,"int") != NULL) || (strstr(dinamic_TS[i].tipo,"real")!= NULL)){
            strcpy(auxiliarT,"dd");
            if (strcmp(dinamic_TS[i].valor,"-")==0){
                strcpy(auxiliarV,"?");
            }else if(strcmp(dinamic_TS[i].valor,"-")!=0){
                strcpy(auxiliarV,dinamic_TS[i].valor);
                if(strstr(dinamic_TS[i].tipo,"int")!=NULL){
                    strcat(auxiliarV,".00");
                }
            }
        }
        //para string y cstring
        else if(strstr(dinamic_TS[i].tipo,"string") != NULL ){
            strcpy(auxiliarT,"db");
            if (strcmp(dinamic_TS[i].valor,"-")==0){
                strcpy(auxiliarV,"MAXTEXTSIZE dup (?),'$'");
            }else if(strcmp(dinamic_TS[i].valor,"-")!=0){
                strcpy(auxiliarV,dinamic_TS[i].valor);
                auxiliarV[strlen(dinamic_TS[i].valor)-1]='$'; 
                auxiliarV[strlen(dinamic_TS[i].valor)]='"';            
            }
        }
        
        fprintf(final_asm,"%s %s %s\n",auxiliarN,auxiliarT,auxiliarV);
        fflush(final_asm);
        
        //limpio vectores
        for(int k=0;k<30;k++){
            auxiliarV[k]='\0'; // se usa en TS
            auxiliarN[k]='\0'; // se usa en Ts
            auxiliarCV[k]='\0'; // se usa en TP
            auxiliarCI[k]='\0'; // se usa en TP
        }
    }

    //ZONA CODIGO PRINCIPAL DE ASM
    fprintf (final_asm, "\n");
    fflush(final_asm);
    fprintf (final_asm, ".CODE\n");
    fflush(final_asm);
   
    //agregado de concat.txt
    while ( (data1 = fgetc (concat)) != EOF ) {
        fputc ( data1, final_asm );
        fflush(final_asm);
    }
    
    fprintf (final_asm, "\n\n");
    fflush(final_asm);
    
    //codigo principal
    fprintf (final_asm, "mov AX,@DATA\n");
    fflush(final_asm);
    fprintf (final_asm, "mov DS,AX\n");
    fflush(final_asm); 
    fprintf (final_asm, "mov es,ax\n\n");
    fflush(final_asm); 

    // zona recorrido de la tira polaca para completar la seccion .CODE
    for(int j=0; j<indice_tira; j++) {
        
        // ***** NOTA: ***** las operaciones +,-,* y / deben ir dentro en las expresiones de las asignaciones programadas a acontinuacion
        
        // Asignaciones fuera del IF y WHILE
        if(strcmp(tira_polaca[j].cell, ";=;") == 0)
        {  // primero, hay que preguntar si es asignacion simple
            if(strcmp(tira_polaca[j+2].cell, ";=;") != 0)
            {  // si en la posicion actual + 2 posiciones NO encuentra un operador =
                // pregunta si se trata de la asignacion mas simple, es decir, donde a una variable se le asigna una cte o un id
                if(strcmp(tira_polaca[j-2].tag, "#operator\n") != 0)
                { // pregunta si no hay un 'operator' en 2 posiciones mas abajo de la actual
                    //entonces al tratarse de la asignacion mas simple de todas, averiguo que tipo de dato es
                    if(tira_polaca[j-2].tag[1] == 'i'){  //si es entero
                        strcpy(auxiliarCV, tira_polaca[j-2].cell); // guarda el valor de la celda ;value;
                        fprintf (final_asm, "fld\t$%s\n",skipPointsC(auxiliarCV));
                        fflush(final_asm);
                        strcpy(auxiliarCI, tira_polaca[j-1].cell); // guarda el id de la celda ;$id;
                        fprintf (final_asm, "fstp\t%s\n", skipPointsC(auxiliarCI)); // en posicion actual -1 siempre encuentra el id que almacena lo del lado derecha
                        fflush(final_asm);
                    }else if(tira_polaca[j-2].tag[1] == 'r'){ // si es real
                        strcpy(auxiliarCV, tira_polaca[j-2].cell); // guarda el valor de la celda ;value;
                        fprintf (final_asm, "fld\t$%s\n", changeRealC(skipPointsC(auxiliarCV)));
                        fflush(final_asm);
                        strcpy(auxiliarCI, tira_polaca[j-1].cell); // guarda el id de la celda ;$id;
                        fprintf (final_asm, "fstp\t%s\n", skipPointsC(auxiliarCI)); // en posicion actual -1 siempre encuentra el id que almacena lo del lado derecha
                        fflush(final_asm);
                    }else if(tira_polaca[j-2].tag[1] == 's'){ // si es string
                        strcpy(auxiliarCV, tira_polaca[j-2].cell);
                        fprintf (final_asm, "mov si,OFFSET $%s\n", skipComillasC(skipPointsC(auxiliarCV)));
                        fflush(final_asm);
                        strcpy(auxiliarCI, tira_polaca[j-1].cell);
                        fprintf (final_asm, "mov di,OFFSET %s\n", skipPointsC(auxiliarCI));
                        fflush(final_asm);
                        fprintf (final_asm, "call COPIAR\n");
                        fflush(final_asm);
                    
                    }else if(tira_polaca[j-2].tag[1] == 'c'){  // si es cstring
                        strcpy(auxiliarCV, tira_polaca[j-2].cell);
                        fprintf (final_asm, "mov si,OFFSET %s\n", skipPointsC(auxiliarCV));
                        fflush(final_asm);
                        strcpy(auxiliarCI, tira_polaca[j-1].cell);
                        fprintf (final_asm, "mov di,OFFSET %s\n", skipPointsC(auxiliarCI));
                        fflush(final_asm);
                        fprintf (final_asm, "call COPIAR\n");
                        fflush(final_asm);
                        
                    }
                }else if(strcmp(tira_polaca[j-2].cell, ";=;") != 0) // para que NO se filtre el ultimo = de asignacion multiple
                { // es una asignacion simple, pero con expresion del lado derecho
                    printf("\n");
                    for(int paes=j-1; paes>=0; paes--){  // pams = posicion asignacion expresion simple. se recorre solo dos posiciones
                        if((strcmp(tira_polaca[paes].cell,";IF_I;")!=0)&&
                        (strcmp(tira_polaca[paes].cell,";IF_F;")!=0)&&
                        (strcmp(tira_polaca[paes].cell,";WH_I;")!=0)&&
                        (strcmp(tira_polaca[paes].cell,";WH_F;")!=0)&&
                        (strcmp(tira_polaca[paes].cell,";ELSE_F;")!=0)&&
                        (strcmp(tira_polaca[paes].cell,";=;")!=0)&&
                        (strcmp(tira_polaca[paes].tag,"#space\n")!=0))     
                        {
                            printf("Estoy en asignacion simple con expresion, pasa por el indice: %s\n", tira_polaca[paes].index);
                            
                        }else{
                            printf("paes es: %d\n", paes);
                            auxI = paes + 1 ;
                            //printf("\n\n\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<auxI :%i\n\n\n",auxI);
                            //printf("\n\n\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<j-2 :%i\n\n\n",(j-2));
                            for(auxI;auxI<=j-2;auxI++){
                                printf("\n\n\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<estoy en for de expresion\n\n");
                                printf("tira_polaca[auxI].tag %s\n\n",tira_polaca[auxI].tag);
                                
                                if(strcmp(tira_polaca[auxI].tag,"#operator\n")!=0){
                                    //apilo
                                    if(tira_polaca[auxI].tag[1] == 'r'){ // si es real
                                        strcpy(auxiliarCV, tira_polaca[auxI].cell); // guarda el valor de la celda ;value;
                                        fprintf (final_asm, "fld\t$%s\n", changeRealC(skipPointsC(auxiliarCV)));
                                        fflush(final_asm);
                                    }else if(tira_polaca[auxI].tag[1] == 'i'){
                                        strcpy(auxiliarCV, tira_polaca[auxI].cell);
                                        fprintf (final_asm, "fld\t$%s\n",skipPointsC(auxiliarCV));
                                        fflush(final_asm);
                                    }                        
                                }
                                
                                if((strcmp(tira_polaca[auxI].cell, ";+;") == 0)||(strcmp(tira_polaca[auxI].cell, ";/;") == 0)||(strcmp(tira_polaca[auxI].cell, ";-;") == 0)||(strcmp(tira_polaca[auxI].cell, ";*;") == 0)){
                                    
                                    printf("!!!!!!!!!!!!!!!!!!!! entre a if de operadores \n\n");
                                    
                                    // Suma
                                    if(strcmp(tira_polaca[auxI].cell, ";+;") == 0){
                                        //printf("encontre suma\n\n");  
                                        fprintf (final_asm, "fadd\n");
                                        fflush(final_asm);
                                        //printf("operador suma en el indice: %s\n", tira_polaca[j].index);
                                    }  //  * Fin Suma *
                                    
                                    // Resta
                                    if(strcmp(tira_polaca[auxI].cell, ";-;") == 0){
                                        //printf("encontre resta\n\n");  
                                        fprintf (final_asm, "fsub\n");
                                        fflush(final_asm);
                                        //printf("operador resta en el indice: %s\n", tira_polaca[j].index);
                                    }  //  * Fin Resta *
                                    
                                    // Multiplicacion
                                    if(strcmp(tira_polaca[auxI].cell, ";*;") == 0){
                                        //printf("encontre multiplicacion\n\n");  
                                        fprintf (final_asm, "fmul\n");
                                        fflush(final_asm);//printf("operador mult en el indice: %s\n", tira_polaca[j].index);
                                    }  //  * Fin Multiplicacion *
                                    
                                    // Division
                                    if(strcmp(tira_polaca[auxI].cell, ";/;") == 0){
                                        //printf("encontre division\n\n");          
                                        fprintf (final_asm, "fdiv\n");
                                        fflush(final_asm);
                                        //printf("operador div en el indice: %s\n", tira_polaca[j].index);
                                    }  //  * Fin Division *
                                    //desapilo con ultimos 2 valores
                                    fprintf (final_asm, "ffree 1\n");
                                    fflush(final_asm);
                                }
                            }
                            break; //salgo del bucle for ya que forme la expresion simple
                        }
                    }
                    printf("\n\n");
                }
                // Termina de encontrar la Asignacion Multiple
                else if(strcmp(tira_polaca[j-2].cell, ";=;") == 0){ // cuerpo inicio asignacion multiple
                    printf("Asignacion multiple empieza desde el indice: %s %d\n", tira_polaca[j].index, j);
                    int paem=auxiliarPosAMult;
                    for(paem; paem>=0; paem--){  // pams = posicion asignacion expresion multiple. se recorre solo dos posiciones
                        if((strcmp(tira_polaca[paem].cell,";IF_I;")!=0)&&
                        (strcmp(tira_polaca[paem].cell,";IF_F;")!=0)&&
                        (strcmp(tira_polaca[paem].cell,";WH_I;")!=0)&&
                        (strcmp(tira_polaca[paem].cell,";WH_F;")!=0)&&
                        (strcmp(tira_polaca[paem].cell,";ELSE_F;")!=0)&&
                        (strcmp(tira_polaca[paem].cell,";=;")!=0)&&
                        (strcmp(tira_polaca[paem].tag,"#space\n")!=0))
                        {
                            printf("Estoy en asignacion multiple con expresion, pasa por el indice: %s\n", tira_polaca[paem].index);
                        }else
                        {
                            int auxiliarMt = paem+1; // guarda la posicion donde termina la expresion
                            printf("La expresion termina en: %d\n", auxiliarMt);
                            
                            // bucle for que resuelve la expresion de la asignacion multiple
                            for(auxiliarMt; auxiliarMt<= auxiliarPosAMult-1; auxiliarMt++){
                                if(strcmp(tira_polaca[auxiliarMt].tag,"#operator\n")!=0){ // si es distinto a operator, es decir a: +, -,*,/,=,etc
                                    //apilo
                                    if(tira_polaca[auxiliarMt].tag[1] == 'r'){ // si es real
                                        strcpy(auxiliarCV, tira_polaca[auxiliarMt].cell); // guarda el valor de la celda ;value;
                                        fprintf (final_asm, "fld\t$%s\n", changeRealC(skipPointsC(auxiliarCV)));
                                        fflush(final_asm);
                                    }else if(tira_polaca[auxiliarMt].tag[1] == 'i'){ // si es entero
                                        strcpy(auxiliarCV, tira_polaca[auxiliarMt].cell);
                                        fprintf (final_asm, "fld\t$%s\n",skipPointsC(auxiliarCV));
                                        fflush(final_asm);
                                    }                        
                                }
                                // Si es operador de +,-,*,/
                                if((strcmp(tira_polaca[auxiliarMt].cell, ";+;") == 0)||(strcmp(tira_polaca[auxiliarMt].cell, ";/;") == 0)||(strcmp(tira_polaca[auxiliarMt].cell, ";-;") == 0)||(strcmp(tira_polaca[auxiliarMt].cell, ";*;") == 0))
                                { // operadores
                                    printf("Estoy en el if de operadores en asignacion multiple \n\n");
                                    
                                    // Suma
                                    if(strcmp(tira_polaca[auxiliarMt].cell, ";+;") == 0){
                                        //printf("encontre suma\n\n");  
                                        fprintf (final_asm, "fadd\n");
                                        fflush(final_asm);
                                        //printf("operador suma en el indice: %s\n", tira_polaca[j].index);
                                    }  //  * Fin Suma *
                                    
                                    // Resta
                                    if(strcmp(tira_polaca[auxiliarMt].cell, ";-;") == 0){
                                        //printf("encontre resta\n\n");  
                                        fprintf (final_asm, "fsub\n");
                                        fflush(final_asm);
                                        //printf("operador resta en el indice: %s\n", tira_polaca[j].index);
                                    }  //  * Fin Resta *
                                    
                                    // Multiplicacion
                                    if(strcmp(tira_polaca[auxiliarMt].cell, ";*;") == 0){
                                        //printf("encontre multiplicacion\n\n");  
                                        fprintf (final_asm, "fmul\n");
                                        fflush(final_asm);//printf("operador mult en el indice: %s\n", tira_polaca[j].index);
                                    }  //  * Fin Multiplicacion *
                                    
                                    // Division
                                    if(strcmp(tira_polaca[auxiliarMt].cell, ";/;") == 0){
                                        //printf("encontre division\n\n");          
                                        fprintf (final_asm, "fdiv\n");
                                        fflush(final_asm);
                                        //printf("operador div en el indice: %s\n", tira_polaca[j].index);
                                    }  //  * Fin Division *
                                    //desapilo con ultimos 2 valores
                                    fprintf (final_asm, "ffree 1\n");
                                    fflush(final_asm);
                                }
                            } // * * FIN del bucle for que resuelve la expresion de la asignacion multiple

                             // bucle for que resuelve los ids de la asignacion multiple
                            for(auxiliarPosAMult; auxiliarPosAMult<= j; auxiliarPosAMult++){
                                //printf("Estoy resolviendo los ids en el indice: %d\n",auxiliarPosAMult );
 
                                if(strcmp(tira_polaca[auxiliarPosAMult].tag, "#operator\n") == 0){
                                    strcpy(auxiliarCI, tira_polaca[auxiliarPosAMult-1].cell); // guarda el id de la celda ;$id;
                                    fprintf (final_asm, "fstp\t%s\n", skipPointsC(auxiliarCI)); // en posicion actual -1 siempre encuentra el id que almacena lo del lado derecho
                                    fflush(final_asm);
                                    fprintf (final_asm, "fld\t\t%s\n", skipPointsC(auxiliarCI)); // en posicion actual -1 siempre encuentra el id que almacena lo del lado derecho
                                    fflush(final_asm);
                                }
                            }
                            fprintf (final_asm, "ffree 1\nffree 0\n");
                            fflush(final_asm);
                            break; //salgo del bucle for ya que forme la asignacion multiple
                        }
                    }
                    printf("\n\n");
                    flagmult=0;
                }
            }else if(flagmult == 0){ // es una asignacion multiple. prendo el flag
                flagmult = 1;
                auxiliarPosAMult = j-1;
                printf("se activo el flag, posicion ultimo id asignacion multiple: %d\n",auxiliarPosAMult);
            }
        }
         //  * Fin Asignaciones *


        /// IFS
        if(strcmp(tira_polaca[j].cell, ";IF_I;") == 0)
        {
            if(strcmp(tira_polaca[j+6].cell, ";CMP;") != 0){
             //////////////////////////////////////////////////////////copio operandos 
                if(tira_polaca[j+1].tag[1] == 'r'){ // si es real
                    strcpy(auxiliarCV, tira_polaca[j+1].cell); // guarda el valor de la celda ;value;
                    fprintf (final_asm, "fld\t$%s\n", changeRealC(skipPointsC(auxiliarCV)));
                    fflush(final_asm);
                }else if(tira_polaca[j+1].tag[1] == 'i'){
                    strcpy(auxiliarCV, tira_polaca[j+1].cell);
                    fprintf (final_asm, "fld\t$%s\n",skipPointsC(auxiliarCV));
                    fflush(final_asm);
                }

                if(tira_polaca[j+2].tag[1] == 'r'){ // si es real
                    strcpy(auxiliarCV, tira_polaca[j+2].cell); // guarda el valor de la celda ;value;
                    fprintf (final_asm, "fld\t$%s\n", changeRealC(skipPointsC(auxiliarCV)));
                    fflush(final_asm);
                }else if(tira_polaca[j+2].tag[1] == 'i'){
                    strcpy(auxiliarCV, tira_polaca[j+2].cell);
                    fprintf (final_asm, "fld\t$%s\n",skipPointsC(auxiliarCV));
                    fflush(final_asm);
                }

                fprintf (final_asm, "fxch\nfcom\nfstsw ax\nsahf\n");
                fflush(final_asm); 
            //////////////////////////////////////////////////////////

            ////////////////////////////////////////////////////////// pregunto por comparador
                if(strcmp(tira_polaca[j+4].cell, ";BLE;") != 0){  //mayor
                    fprintf (final_asm, "jnbe else_part\nthen_part:  ;codigo del then\n");
                    fflush(final_asm);
                }
                else if(strcmp(tira_polaca[j+4].cell, ";BGE;") != 0){ //menor
                    fprintf (final_asm, "jnae else_part\nthen_part:  ;codigo del then\n");
                    fflush(final_asm);

                }
                else if(strcmp(tira_polaca[j+4].cell, ";BGT;") != 0){  // menor igual
                    fprintf (final_asm, "jna else_part\nthen_part:  ;codigo del then\n");
                    fflush(final_asm);
                }
                else if(strcmp(tira_polaca[j+4].cell, ";BLT;") != 0){ //mayor igual
                    fprintf (final_asm, "jnb else_part\nthen_part:  ;codigo del then\n");
                    fflush(final_asm);
                }
                else if(strcmp(tira_polaca[j+4].cell, ";BEQ;") != 0){ //igual
                    fprintf (final_asm, "je  else_part\nthen_part:  ;codigo del then\n");
                    fflush(final_asm);
                }
                else if(strcmp(tira_polaca[j+4].cell, ";BNE;") != 0){ //distinto
                    fprintf (final_asm, "jne else_part\nthen_part:  ;codigo del then\n");
                    fflush(final_asm);
                }
                ////////////////////////////////////////////////////////////
            }

            j=j+4;
            
        } //  * Fin If_I *

        if(strcmp(tira_polaca[j].cell, ";IF_F;") == 0){
            fprintf (final_asm, "jmp end_if\nelse_part: ;codigo del else\n");
            fflush(final_asm); 
        }

        if(strcmp(tira_polaca[j].cell, ";ELSE_F;") == 0){
            fprintf (final_asm, "end_if:\n");
            fflush(final_asm); 
        }

        //while
        if(strcmp(tira_polaca[j].cell, ";WH_I;") == 0){
            if(strcmp(tira_polaca[j+6].cell, ";CMP;") != 0){
                fprintf (final_asm, "_EtiquetaW:\n");
                fflush(final_asm);
                //////////////////////////////////////////////////////////copio operandos 
                if(tira_polaca[j+1].tag[1] == 'r'){ // si es real
                    strcpy(auxiliarCV, tira_polaca[j+1].cell); // guarda el valor de la celda ;value;
                    fprintf (final_asm, "fld\t$%s\n", changeRealC(skipPointsC(auxiliarCV)));
                    fflush(final_asm);
                }else if(tira_polaca[j+1].tag[1] == 'i'){
                    strcpy(auxiliarCV, tira_polaca[j+1].cell);
                    fprintf (final_asm, "fld\t$%s\n",skipPointsC(auxiliarCV));
                    fflush(final_asm);
                }

                if(tira_polaca[j+2].tag[1] == 'r'){ // si es real
                    strcpy(auxiliarCV, tira_polaca[j+2].cell); // guarda el valor de la celda ;value;
                    fprintf (final_asm, "fld\t$%s\n", changeRealC(skipPointsC(auxiliarCV)));
                    fflush(final_asm);
                }else if(tira_polaca[j+2].tag[1] == 'i'){
                    strcpy(auxiliarCV, tira_polaca[j+2].cell);
                    fprintf (final_asm, "fld\t$%s\n",skipPointsC(auxiliarCV));
                    fflush(final_asm);
                }

                fprintf (final_asm, "fxch\nfcom\nfstsw ax\nsahf\nffree\n");
                fflush(final_asm); 
            //////////////////////////////////////////////////////////

             if(strcmp(tira_polaca[j+4].cell, ";BLE;") != 0){  //mayor
                    fprintf (final_asm, "jnbe _EtiquetaF\n");
                    fflush(final_asm);
                }
                else if(strcmp(tira_polaca[j+4].cell, ";BGE;") != 0){ //menor
                    fprintf (final_asm, "jnae _EtiquetaF\n");
                    fflush(final_asm);

                }
                else if(strcmp(tira_polaca[j+4].cell, ";BGT;") != 0){  // menor igual
                    fprintf (final_asm, "jna _EtiquetaF\n");
                    fflush(final_asm);
                }
                else if(strcmp(tira_polaca[j+4].cell, ";BLT;") != 0){ //mayor igual
                    fprintf (final_asm, "jnb _EtiquetaF\n");
                    fflush(final_asm);
                }
                else if(strcmp(tira_polaca[j+4].cell, ";BEQ;") != 0){ //igual
                    fprintf (final_asm, "je  _EtiquetaF\n");
                    fflush(final_asm);
                }
                else if(strcmp(tira_polaca[j+4].cell, ";BNE;") != 0){ //distinto
                    fprintf (final_asm, "jne _EtiquetaF\n");
                    fflush(final_asm);
                }
            }

            j=j+4;
                ////////////////////////////////////////////////////////////
        }

        if(strcmp(tira_polaca[j].cell, ";WH_F;") == 0){
            fprintf (final_asm, "jmp _EtiquetaW\n_EtiquetaF:\n");
            fflush(final_asm); 
        }

    }
    
     // FIN FOR

    //INSTRUCCIONES DE FIN DE ASM
    fprintf (final_asm, "\nmov ax,4c00h\n");
    fflush(final_asm);
    fprintf (final_asm, "int 21h\n");
    fflush(final_asm); 
    fprintf (final_asm, "End\n");
    fflush(final_asm);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
char * skipPointsC(char celda_tira []){
    char aux_celda_tira[30] = {0}; // omito los ;
    int index_aux=-1;
    int lt=0;

    // limpio vector
    for(lt=0; lt<30; lt++){
        aux_celda_tira[lt] = '\0';
    }

    for(lt=0; lt<strlen(celda_tira); lt++){
        if(celda_tira[lt] != ';'){
            index_aux++;
            aux_celda_tira[index_aux] = celda_tira[lt];
        }
    }
    strcpy(celda_tira, aux_celda_tira);
    return celda_tira;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
char * skipComillasC(char string []){
    char aux_string[30] = {0}; // omito los ;
    int index_aux=-1;
    int lt=0;

    // limpio vector
    for(lt=0; lt<30; lt++){
        aux_string[lt] = '\0';
    }

    for(lt=0; lt<strlen(string); lt++){
        if(string[lt] != '"'){
            index_aux++;
            aux_string[index_aux] = string[lt];
        }
    }
    strcpy(string,aux_string);
    return string;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
char * changeRealC(char stringR []){
    char aux_string[30] = {0}; // omito los ;
    int index_aux=-1;
    int lt=0;

    // limpio vector
    for(lt=0; lt<30; lt++){
        aux_string[lt] = '\0';
    }

    for(lt=0; lt<strlen(stringR); lt++){
        if(stringR[lt] != '.'){
            index_aux++;
            aux_string[index_aux] = stringR[lt];
        }else if(stringR[lt] == '.'){
            index_aux++;
            aux_string[index_aux] = '_';
        }
    }
    // limpio vector
    for(lt=0; lt<30; lt++){
        stringR[lt] = '\0';
    }
    strcpy(stringR,aux_string);
    return stringR;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
void contar_if_wh(){
    char aux[40]={0};
    int if_pila[40]={0};
    int wh_pila[40]={0};
    int cont_if=0;
    int cont_wh=0;
    int indice_if=0;
    int indice_wh=0;


    for(int i=0; i<indice_tira;i++){
        if(strcmp(tira_polaca[i].cell,";IF_I;")==0){
            cont_if++;
            indice_if++;
            sprintf(aux,"%d",cont_if);
            strcpy(tira_polaca[i].cell,";IF_I");
            strcat(tira_polaca[i].cell,aux);
            strcat(tira_polaca[i].cell,";");
            if_pila[indice_if-1]=cont_if;           
        }
        if(strcmp(tira_polaca[i].cell,";WH_I;")==0){
            cont_wh++;
            indice_wh++;
            sprintf(aux,"%d",cont_wh);
            strcpy(tira_polaca[i].cell,";WH_I");
            strcat(tira_polaca[i].cell,aux);
            strcat(tira_polaca[i].cell,";");
            wh_pila[indice_wh-1]=cont_wh;
        }
        if(strcmp(tira_polaca[i].cell,";ELSE_F;")==0){
            sprintf(aux,"%d",if_pila[indice_if-1]);
            strcpy(tira_polaca[i].cell,";ELSE_F");
            strcat(tira_polaca[i].cell,aux);
            strcat(tira_polaca[i].cell,";");
            if_pila[indice_if-1]='\0';
            indice_if--;      
        }
        if(strcmp(tira_polaca[i].cell,";WH_F;")==0){
            sprintf(aux,"%d",wh_pila[indice_wh-1]);
            strcpy(tira_polaca[i].cell,";WH_F");
            strcat(tira_polaca[i].cell,aux);
            strcat(tira_polaca[i].cell,";");
            wh_pila[indice_wh-1]='\0';
            indice_wh--;           
        }

    }
    cant_selecciones=cont_if;
    cant_bucles=cont_wh;

    printf("\n Cantidad de ifs: %d\n",cont_if) ;   
    printf("\n Cantidad de wh: %d\n",cont_wh) ;
    mostrar_polaca();    
    printTiraPolaca();          
}