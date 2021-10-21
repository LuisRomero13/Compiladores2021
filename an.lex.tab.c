/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "an.lex.y"

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>
    #include <malloc.h>
    #include "y.tab.h"
    
    FILE * input;  
    FILE * lista_tokens; 
    FILE * tabla_simbolos; 
    FILE * tokens_unicos;
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
    struct Token token_confirmado;    

    // prototipo de funciones
    int yylex(void); int yyerror(char *s); int getColumnByEvent(char letra); void cleanTokens();
    void(*tabla_funciones[28][26])(); int tabla_estados [28][26];

    struct Token getTokenIdWords();struct Token getTokenInt();
    struct Token getTokenReal();struct Token getTokenString();
    struct Token getTokenOp();struct Token getTokenComp(); 
    struct Token getTokenOther(); void buildToken();

    void F0();void F1();void F2();void F3();void F4();void F5();void F6();void F7();
    void F8();void F9();void F10();void F11();void F12();void F13();void F15();
    void F17();void F18();void F19();void F20();void F21();void F22();void F23();
    void F24();void F25();void F26();void F27();void ERROR();void F(); 
    void showTokens(); void showSymbolTable();

#line 123 "an.lex.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif


/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    CSTRING = 258,
    CENT = 259,
    CREAL = 260,
    WHILE = 261,
    IF = 262,
    ELSE = 263,
    DECLARE = 264,
    ENDDECLARE = 265,
    REAL = 266,
    INT = 267,
    STRING = 268,
    GET = 269,
    PUT = 270,
    ID = 271,
    SUMA = 272,
    RESTA = 273,
    MULT = 274,
    DIV = 275,
    ASIGN = 276,
    CONCAT = 277,
    AND = 278,
    OR = 279,
    NOT = 280,
    MAYOR = 281,
    MENOR = 282,
    MENORIGUAL = 283,
    MAYORIGUAL = 284,
    IGUAL = 285,
    DISTINTO = 286,
    PUNTOYC = 287,
    LLAVEA = 288,
    LLAVEC = 289,
    PARENTA = 290,
    PARENTC = 291,
    COMA = 292
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 54 "an.lex.y"

    int number;
    char name[40];      
    char lexema[40];    
    char tipo[40];      
    char valor[40];     
    int longitud;       

#line 219 "an.lex.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);





#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_int8 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  27
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   140

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  38
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  22
/* YYNRULES -- Number of rules.  */
#define YYNRULES  57
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  128

#define YYUNDEFTOK  2
#define YYMAXUTOK   292


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int8 yyrline[] =
{
       0,   101,   101,   101,   102,   102,   103,   103,   104,   104,
     104,   105,   105,   106,   106,   106,   106,   106,   106,   107,
     108,   108,   108,   108,   108,   109,   109,   109,   110,   110,
     110,   110,   111,   111,   111,   112,   112,   112,   112,   113,
     113,   113,   113,   113,   113,   114,   114,   115,   115,   116,
     116,   116,   117,   118,   119,   119,   119,   120
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 0
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "CSTRING", "CENT", "CREAL", "WHILE",
  "IF", "ELSE", "DECLARE", "ENDDECLARE", "REAL", "INT", "STRING", "GET",
  "PUT", "ID", "SUMA", "RESTA", "MULT", "DIV", "ASIGN", "CONCAT", "AND",
  "OR", "NOT", "MAYOR", "MENOR", "MENORIGUAL", "MAYORIGUAL", "IGUAL",
  "DISTINTO", "PUNTOYC", "LLAVEA", "LLAVEC", "PARENTA", "PARENTC", "COMA",
  "$accept", "programa", "bloque", "declaracion", "type", "variables",
  "sentencia", "$@1", "asignacion", "multiple", "expresion_num",
  "expresion_string", "termino", "factor", "comparador", "comparacion",
  "comp_logico", "condicion", "iteracion", "seleccion", "entrada",
  "salida", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292
};
# endif

#define YYPACT_NINF (-32)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-1)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int8 yypact[] =
{
      50,   -11,    -8,    63,    14,    83,    15,    52,   -32,    75,
      29,   -32,   -32,   -32,    51,    35,    35,   -32,   -32,   -32,
      48,    82,   -32,   -32,   -32,   -32,     2,   -32,   -32,   -32,
      71,   -32,    72,     7,   -32,   -32,    70,    74,    75,    77,
      79,    90,   -32,   -32,   -13,    12,   -32,    54,   -32,    58,
     -32,   -32,    35,    91,    10,    17,    81,    84,    85,    86,
     -32,    82,    63,    22,    16,    30,   -32,    26,    12,    12,
      12,    12,    87,    31,    66,    66,    76,    75,    75,   -32,
     -32,   -32,   -32,    80,   -32,    54,   -32,   -32,   -32,   -32,
      58,    58,   -32,   -32,   -32,    66,   -32,   -32,   -32,   -32,
     -32,   -32,    89,    92,    93,    94,    88,    96,    12,    47,
      97,    97,   -32,   107,    37,    91,    95,    10,    98,    99,
     100,   -32,   -32,   -32,   -32,    75,   102,   -32
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int8 yydefact[] =
{
       0,     0,     0,     0,     0,     0,     0,     0,     3,     4,
       0,    14,    15,    16,     0,     0,     0,     9,     8,    10,
       0,     0,    57,    54,    55,    56,     0,     1,     5,    13,
       0,    18,     0,     0,    50,    51,     0,     0,     0,    11,
       0,     0,    36,    37,    35,     0,    19,    23,    24,    25,
      32,    17,     0,    35,     0,     0,     0,     0,     0,     0,
       2,     0,     6,     0,     0,     0,    35,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    12,
       7,    28,    31,    35,    20,    21,    22,    29,    30,    38,
      26,    27,    33,    34,    49,    38,    39,    40,    41,    42,
      43,    44,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,    52,     0,     0,     0,     0,     0,     0,     0,
       0,    45,    46,    47,    48,     0,     0,    53
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -32,   -32,    -9,    59,   -32,    64,   -32,   -32,    62,   -32,
     -23,   -25,    36,    38,    65,   -31,   -32,   -12,   -32,   -32,
     -32,   -32
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     7,     8,    20,    21,    40,     9,    30,    10,    46,
      55,    56,    49,    50,   102,    34,    35,    36,    11,    12,
      13,    14
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int8 yytable[] =
{
      28,    48,    57,    47,    37,    41,    42,    43,    64,    65,
      41,    42,    43,    41,    42,    43,    42,    43,    44,    41,
      42,    43,    67,    53,    15,    81,    53,    16,    66,    60,
      22,    73,    83,    87,    68,    69,    26,    45,    82,    86,
      72,    85,    54,    68,    69,    45,    88,    45,    68,    69,
      41,    45,    27,    74,    68,    69,     1,     2,    38,     3,
      32,    29,    89,   115,     4,     5,     6,    95,   106,   107,
      33,    68,    69,   121,    17,    18,    19,    70,    71,   118,
     119,     1,     2,    31,   116,   114,    23,    24,    25,     4,
       5,     6,    96,    97,    98,    99,   100,   101,    39,   104,
     105,    26,    65,    51,    90,    91,    58,    52,    92,    93,
      59,    62,    63,    65,    61,   120,   126,    75,    77,    78,
      76,    80,   112,    94,   108,    79,    84,   109,   110,   111,
     113,   122,   117,   125,   123,   124,   127,     0,     0,     0,
     103
};

static const yytype_int8 yycheck[] =
{
       9,    26,    33,    26,    16,     3,     4,     5,    21,    22,
       3,     4,     5,     3,     4,     5,     4,     5,    16,     3,
       4,     5,    45,    16,    35,     3,    16,    35,    16,    38,
      16,    54,    16,     3,    17,    18,    21,    35,    16,    64,
      52,    64,    35,    17,    18,    35,    16,    35,    17,    18,
       3,    35,     0,    36,    17,    18,     6,     7,    10,     9,
      25,    32,    36,    16,    14,    15,    16,    36,    77,    78,
      35,    17,    18,    36,    11,    12,    13,    19,    20,   110,
     111,     6,     7,    32,   109,   108,     3,     4,     5,    14,
      15,    16,    26,    27,    28,    29,    30,    31,    16,    23,
      24,    21,    22,    32,    68,    69,    36,    35,    70,    71,
      36,    32,    22,    22,    37,     8,   125,    36,    33,    33,
      36,    62,    34,    36,    35,    61,    64,    35,    35,    35,
      34,    36,    35,    33,    36,    36,    34,    -1,    -1,    -1,
      75
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int8 yystos[] =
{
       0,     6,     7,     9,    14,    15,    16,    39,    40,    44,
      46,    56,    57,    58,    59,    35,    35,    11,    12,    13,
      41,    42,    16,     3,     4,     5,    21,     0,    40,    32,
      45,    32,    25,    35,    53,    54,    55,    55,    10,    16,
      43,     3,     4,     5,    16,    35,    47,    48,    49,    50,
      51,    32,    35,    16,    35,    48,    49,    53,    36,    36,
      40,    37,    32,    22,    21,    22,    16,    48,    17,    18,
      19,    20,    55,    48,    36,    36,    36,    33,    33,    43,
      41,     3,    16,    16,    46,    48,    49,     3,    16,    36,
      50,    50,    51,    51,    36,    36,    26,    27,    28,    29,
      30,    31,    52,    52,    23,    24,    40,    40,    35,    35,
      35,    35,    34,    34,    48,    16,    49,    35,    53,    53,
       8,    36,    36,    36,    36,    33,    40,    34
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int8 yyr1[] =
{
       0,    38,    39,    39,    40,    40,    41,    41,    42,    42,
      42,    43,    43,    44,    44,    44,    45,    44,    44,    46,
      47,    47,    47,    47,    47,    48,    48,    48,    49,    49,
      49,    49,    50,    50,    50,    51,    51,    51,    51,    52,
      52,    52,    52,    52,    52,    53,    53,    54,    54,    55,
      55,    55,    56,    57,    58,    58,    58,    59
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     4,     1,     1,     2,     3,     4,     1,     1,
       1,     1,     3,     2,     1,     1,     0,     3,     2,     3,
       3,     3,     3,     1,     1,     1,     3,     3,     3,     3,
       3,     3,     1,     3,     3,     1,     1,     1,     3,     1,
       1,     1,     1,     1,     1,     7,     7,     7,     7,     4,
       1,     1,     7,    11,     2,     2,     2,     2
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 2:
#line 101 "an.lex.y"
                                                {printf("programa\n");}
#line 1479 "an.lex.tab.c"
    break;

  case 3:
#line 101 "an.lex.y"
                                                                                 {printf("programa\n");}
#line 1485 "an.lex.tab.c"
    break;

  case 4:
#line 102 "an.lex.y"
                  {printf("bloque\n");}
#line 1491 "an.lex.tab.c"
    break;

  case 5:
#line 102 "an.lex.y"
                                                            {printf("bloque");}
#line 1497 "an.lex.tab.c"
    break;

  case 6:
#line 103 "an.lex.y"
                                    {printf("declaracion\n");}
#line 1503 "an.lex.tab.c"
    break;

  case 7:
#line 103 "an.lex.y"
                                                                                                    {printf("declaracion\n");}
#line 1509 "an.lex.tab.c"
    break;

  case 8:
#line 104 "an.lex.y"
          {printf("type\n");}
#line 1515 "an.lex.tab.c"
    break;

  case 9:
#line 104 "an.lex.y"
                                     {printf("type\n");}
#line 1521 "an.lex.tab.c"
    break;

  case 10:
#line 104 "an.lex.y"
                                                                  {printf("type\n");}
#line 1527 "an.lex.tab.c"
    break;

  case 11:
#line 105 "an.lex.y"
              {printf("variables\n");}
#line 1533 "an.lex.tab.c"
    break;

  case 12:
#line 105 "an.lex.y"
                                                           {printf("variables\n");}
#line 1539 "an.lex.tab.c"
    break;

  case 13:
#line 106 "an.lex.y"
                              {printf("sentencia\n");}
#line 1545 "an.lex.tab.c"
    break;

  case 14:
#line 106 "an.lex.y"
                                                                   {printf("sentencia\n");}
#line 1551 "an.lex.tab.c"
    break;

  case 15:
#line 106 "an.lex.y"
                                                                                                        {printf("sentencia\n");}
#line 1557 "an.lex.tab.c"
    break;

  case 16:
#line 106 "an.lex.y"
                                                                                                                                           {printf("sentencia\n");}
#line 1563 "an.lex.tab.c"
    break;

  case 17:
#line 106 "an.lex.y"
                                                                                                                                                                            {printf("sentencia\n");}
#line 1569 "an.lex.tab.c"
    break;

  case 18:
#line 106 "an.lex.y"
                                                                                                                                                                                                                      {printf("sentencia\n");}
#line 1575 "an.lex.tab.c"
    break;

  case 19:
#line 107 "an.lex.y"
                              {printf("asignacion\n");}
#line 1581 "an.lex.tab.c"
    break;

  case 20:
#line 108 "an.lex.y"
                              {printf("asignacion multiple\n");}
#line 1587 "an.lex.tab.c"
    break;

  case 21:
#line 108 "an.lex.y"
                                                                                          {printf("asignacion multiple\n");}
#line 1593 "an.lex.tab.c"
    break;

  case 22:
#line 108 "an.lex.y"
                                                                                                                                                         {printf("asignacion multiple\n");}
#line 1599 "an.lex.tab.c"
    break;

  case 23:
#line 108 "an.lex.y"
                                                                                                                                                                                                            {printf("asignacion multiple\n");}
#line 1605 "an.lex.tab.c"
    break;

  case 24:
#line 108 "an.lex.y"
                                                                                                                                                                                                                                                                  {printf("asignacion multiple\n");}
#line 1611 "an.lex.tab.c"
    break;

  case 25:
#line 109 "an.lex.y"
                       {printf("expresion numerica\n");}
#line 1617 "an.lex.tab.c"
    break;

  case 26:
#line 109 "an.lex.y"
                                                                                      {printf("expresion numerica\n");}
#line 1623 "an.lex.tab.c"
    break;

  case 27:
#line 109 "an.lex.y"
                                                                                                                                                      {printf("expresion numerica\n");}
#line 1629 "an.lex.tab.c"
    break;

  case 28:
#line 110 "an.lex.y"
                                         {printf("expresion string\n");}
#line 1635 "an.lex.tab.c"
    break;

  case 29:
#line 110 "an.lex.y"
                                                                                             {printf("expresion string\n");}
#line 1641 "an.lex.tab.c"
    break;

  case 30:
#line 110 "an.lex.y"
                                                                                                                                            {printf("expresion string\n");}
#line 1647 "an.lex.tab.c"
    break;

  case 31:
#line 110 "an.lex.y"
                                                                                                                                                                                                {printf("expresion string\n");}
#line 1653 "an.lex.tab.c"
    break;

  case 32:
#line 111 "an.lex.y"
                {printf("termino\n");}
#line 1659 "an.lex.tab.c"
    break;

  case 33:
#line 111 "an.lex.y"
                                                             {printf("termino\n");}
#line 1665 "an.lex.tab.c"
    break;

  case 34:
#line 111 "an.lex.y"
                                                                                                         {printf("termino\n");}
#line 1671 "an.lex.tab.c"
    break;

  case 35:
#line 112 "an.lex.y"
           {printf("factor\n");}
#line 1677 "an.lex.tab.c"
    break;

  case 36:
#line 112 "an.lex.y"
                                        {printf("factor\n");}
#line 1683 "an.lex.tab.c"
    break;

  case 37:
#line 112 "an.lex.y"
                                                                      {printf("factor\n");}
#line 1689 "an.lex.tab.c"
    break;

  case 38:
#line 112 "an.lex.y"
                                                                                                                            {printf("factor\n");}
#line 1695 "an.lex.tab.c"
    break;

  case 39:
#line 113 "an.lex.y"
                  {printf("comparador\n");}
#line 1701 "an.lex.tab.c"
    break;

  case 40:
#line 113 "an.lex.y"
                                                     {printf("comparador\n");}
#line 1707 "an.lex.tab.c"
    break;

  case 41:
#line 113 "an.lex.y"
                                                                                            {printf("comparador\n");}
#line 1713 "an.lex.tab.c"
    break;

  case 42:
#line 113 "an.lex.y"
                                                                                                                                   {printf("comparador\n");}
#line 1719 "an.lex.tab.c"
    break;

  case 43:
#line 113 "an.lex.y"
                                                                                                                                                                     {printf("comparador\n");}
#line 1725 "an.lex.tab.c"
    break;

  case 44:
#line 113 "an.lex.y"
                                                                                                                                                                                                          {printf("comparador\n");}
#line 1731 "an.lex.tab.c"
    break;

  case 45:
#line 114 "an.lex.y"
                                                                                    {printf("comparacion\n");}
#line 1737 "an.lex.tab.c"
    break;

  case 46:
#line 114 "an.lex.y"
                                                                                                                                                                                              {printf("comparacion\n");}
#line 1743 "an.lex.tab.c"
    break;

  case 47:
#line 115 "an.lex.y"
                                                                         {printf("comparador logico\n");}
#line 1749 "an.lex.tab.c"
    break;

  case 48:
#line 115 "an.lex.y"
                                                                                                                                                                       {printf("comparador logico\n");}
#line 1755 "an.lex.tab.c"
    break;

  case 49:
#line 116 "an.lex.y"
                                         {printf("condicion\n");}
#line 1761 "an.lex.tab.c"
    break;

  case 50:
#line 116 "an.lex.y"
                                                                                {printf("condicion\n");}
#line 1767 "an.lex.tab.c"
    break;

  case 51:
#line 116 "an.lex.y"
                                                                                                                       {printf("condicion\n");}
#line 1773 "an.lex.tab.c"
    break;

  case 52:
#line 117 "an.lex.y"
                                                                {printf("iteracion\n");}
#line 1779 "an.lex.tab.c"
    break;

  case 53:
#line 118 "an.lex.y"
                                                                                       {printf("seleccion\n");}
#line 1785 "an.lex.tab.c"
    break;

  case 54:
#line 119 "an.lex.y"
                     {printf("entrada\n");}
#line 1791 "an.lex.tab.c"
    break;

  case 55:
#line 119 "an.lex.y"
                                                       {printf("entrada\n");}
#line 1797 "an.lex.tab.c"
    break;

  case 56:
#line 119 "an.lex.y"
                                                                                          {printf("entrada\n");}
#line 1803 "an.lex.tab.c"
    break;

  case 57:
#line 120 "an.lex.y"
               {printf("salida\n");}
#line 1809 "an.lex.tab.c"
    break;


#line 1813 "an.lex.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 121 "an.lex.y"


int main(){ // INICIO MAIN
    input = fopen("input.txt", "rb"); 
    lista_tokens = fopen("lista_tokens.txt", "w");
    tabla_simbolos = fopen("tabla_simbolos.txt", "w"); 
    tokens_unicos = fopen("tokens_unicos.txt", "w+");
    if((input != NULL)||(lista_tokens != NULL)||(tabla_simbolos != NULL)||(tokens_unicos != NULL)){
        fprintf (lista_tokens, "%s\t\t%s\n\n", "ID", "NOMBRE");
        fprintf (tabla_simbolos, "%s\t\t\t\t\t%s\t\t\t\t%s\t\t\t\t%s\n\n", "NOMBRE", "TIPO", "VALOR", "LONGITUD");
       
        int recibo;
        recibo = yyparse();
        if (recibo == 0){
           printf("¡Parser Ok!\n"); 
        }else   
            printf("¡Parser Error!\n");
    }
    else{
        perror("Ocurrio un error al intentar abrir el archivo\n");
        return 1;
    }
    fclose(input); fclose(lista_tokens); fclose(tabla_simbolos); fclose(tokens_unicos); remove("tokens_unicos.txt"); // Destruimos el archivo una vez utilizado
    return (0);
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
        strcpy(yylval.valor, token_confirmado.valor);  // guardo el valor asociado al token

        //printf("yylval guarda: %s\n", yylval.valor);
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
        showTokens(); showSymbolTable();    // imprimimos los resultados
    }
    if(estado_segundo == 2) {
        token_confirmado = getTokenInt();
        showTokens(); showSymbolTable();    // imprimimos los resultados
    }
    if(estado_segundo == 3) {
        token_confirmado = getTokenReal();
        showTokens(); showSymbolTable();    // imprimimos los resultados
    }
    if(estado_segundo == 4) {
        token_confirmado = getTokenString();
        showTokens();   showSymbolTable();  // imprimimos los resultados
    }
    if(((estado_segundo == 7)&&(comparador[0] != '='))||(estado_segundo == 8)||((estado_segundo >= 11)&&(estado_segundo <= 17))||((estado_segundo >= 24)&&(estado_segundo <= 25))){
        token_confirmado = getTokenOp();  // Token OPERADORES
        showTokens();   showSymbolTable();  // imprimimos los resultados
    }
    if((estado_segundo == 7)&&(comparador[0] == '=')) {  // si comparador tiene un igual significado que se trata de un comparador
        token_confirmado = getTokenComp();  // Token COMPARADORES
        showTokens();   showSymbolTable();  // imprimimos los resultados
    }
    if(((estado_segundo >= 18)&&(estado_segundo <= 23))||((estado_segundo >= 26)&&(estado_segundo<=27))){
        token_confirmado = getTokenOther();  // Token Otros
        showTokens();   showSymbolTable();  // imprimimos los resultados
    }
    if((estado_segundo >= 5)&&(estado_segundo <= 6)){
        token_confirmado = getTokenComp();  // Token COMPARADORES
        showTokens();   showSymbolTable();  // imprimimos los resultados
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
        strcpy ( token.lexema, "_");
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
        strcpy ( token.lexema, "_");
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
        strcpy ( token.lexema, "_");
        strcat( token.lexema, constanteString); 
        strcpy ( token.tipo, "cstring");
        strcpy ( token.valor, "\"");
        strcat( token.valor, constanteString);
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
            return token;
        }
        if( strcmp( IdPalabraReservada , "if" ) == 0) {              // Si palabrasReservada es IF
            token.number = 262; // guardo numero de token   
            strcpy( token.name , "IF" ); // guardo nombre del token
            return token;
        }
        if( strcmp( IdPalabraReservada , "else" ) == 0) {            // Si palabrasReservada es ELSE
            token.number = 263; // guardo numero de token   
            strcpy( token.name , "ELSE" ); // guardo nombre del token
            return token;
        }
        if( strcmp( IdPalabraReservada , "declare" ) == 0) {         // Si palabrasReservada es DECLARE
            token.number = 264; // guardo numero de token
            strcpy( token.name , "DECLARE" ); // guardo nombre del token
            return token;
        }
        if( strcmp( IdPalabraReservada , "enddeclare" ) == 0) {      // Si palabrasReservada es ENDDECLARE
            token.number = 265; // guardo numero de token
            strcpy( token.name , "ENDDECLARE" ); // guardo nombre del token
            return token;
        }    
        if( strcmp( IdPalabraReservada , "real" ) == 0) {        // Si palabrasReservada es REAL
            token.number = 266; // guardo numero de token
            strcpy( token.name , "REAL" ); // guardo nombre del token
            return token;
        }      
        if( strcmp( IdPalabraReservada , "int" ) == 0) {         // Si palabrasReservada es INT
            token.number = 267; // guardo numero de token
            strcpy( token.name , "INT" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( IdPalabraReservada , "string" ) == 0) {      // Si palabrasReservada es STRING
            token.number = 268; // guardo numero de token
            strcpy( token.name , "STRING" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( IdPalabraReservada , "get" ) == 0) {         // Si palabrasReservada es GET
            token.number = 269; // guardo numero de token
            strcpy( token.name , "GET" ); // guardo nombre del token
            return token;
        } 
        if( strcmp( IdPalabraReservada , "put" ) == 0) {      // Si palabrasReservada es PUT
            token.number = 270; // guardo numero de token
            strcpy( token.name , "PUT" ); // guardo nombre del token
            return token;
        }
        if( strlen( IdPalabraReservada ) > 0 ) {             // Si no esta vacio 
            token.number = 271; // guardo numero de token
            strcpy( token.name, "ID" ); // guardo nombre del token
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
    strcpy ( token.valor, " ");
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
/*estado5*/ 	28,	    28,	    28,	    29,	    29,	    29,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     29,     
/*estado6*/ 	28,	    28,	    28,	    29,	    29,	    28,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     29,     
/*estado7*/ 	28,	    28,	    28,	    29,	    28,	    29,	    29,	    28,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,	    29,     28,     29,     
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
/*F5*/	F,	    F,	    F,	    ERROR,	ERROR,	ERROR,	ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      ERROR,
/*F6*/	F,	    F,	    F,	    ERROR,	ERROR,	F,	    ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      ERROR,
/*F7*/	F,	    F,	    F,	    ERROR,	F,	    ERROR,	ERROR,	F,	    ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,	ERROR,  F,      ERROR,
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
        if(caracter != '\"')
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
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void showSymbolTable() {   
    if((token_confirmado.number == 258)||(token_confirmado.number == 259)||(token_confirmado.number == 260)||(token_confirmado.number == 271)) {  // Si es entero, real, string o id    
        char lexema[40] = {0}; char lexema_temp[40] = {0};
        int imprimir = 1;       // uso esta variable para que el programa sepa cuando imprimir en los archivos

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
            fprintf (tabla_simbolos, "%s\t %s\t\t\t %s\t\t\t %d\n", token_confirmado.lexema, token_confirmado.tipo, token_confirmado.valor, token_confirmado.longitud);
        }
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
int yyerror(char *s){
    printf("Error de sintaxis en: fila %d, columna %d\n", position_row, position_col);
    fprintf(stderr,"%s\n",s);
}
