
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
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
/* Tokens.  */
#define CSTRING 258
#define CENT 259
#define CREAL 260
#define WHILE 261
#define IF 262
#define ELSE 263
#define DECLARE 264
#define ENDDECLARE 265
#define REAL 266
#define INT 267
#define STRING 268
#define GET 269
#define PUT 270
#define ID 271
#define SUMA 272
#define RESTA 273
#define MULT 274
#define DIV 275
#define ASIGN 276
#define CONCAT 277
#define AND 278
#define OR 279
#define NOT 280
#define MAYOR 281
#define MENOR 282
#define MENORIGUAL 283
#define MAYORIGUAL 284
#define IGUAL 285
#define DISTINTO 286
#define PUNTOYC 287
#define LLAVEA 288
#define LLAVEC 289
#define PARENTA 290
#define PARENTC 291
#define COMA 292




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 131 "an.lex.y"

    int number;
    char name[40];      
    char lexema[40];    
    char tipo[40];      
    char valor[40];     
    int longitud;



/* Line 1676 of yacc.c  */
#line 137 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


