%{
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include "rutinas semanticas.h"

char identificadores[100];
int lenidentificadores = 0;

%}

%union {
  struct {
	char cadena[50];
	float numero;
	int tipo;
	int lvalue;
  } s;
}
%token <s> NUM
%token <s> CADENA
%token <s> IDENTIFICADOR
%token <s> OPIGUALDAD
%token <s> OPRELACIONAL
%token <s> OPOR
%token <s> OPAND
%token <s> OPASIGNACION
%token <s> TYPENAME
%token <s> OPPPMM
%token <s> SIZEOF
%token <s> CONSTANTE

%right OPPPMM
%%

input:    /* vacío */
        | input line
;

line:     '\n'
        | expresion '\n' {printf("\t%f\n",$<s.numero>1);}
;
//DECLARACIONES
declaracion: 		TYPENAME listaVarSimples ;

listaVarSimples: 	unaVarSimple
 			|listaVarSimples , unaVarSimple

unaVarSimple: 		variable 
			|variable inicial

variable: 		IDENTIFICADOR

inicial: 		'=' constante

constante:		CONSTANTE //((falta crear la ER en flex))  





//SENTENCIAS
sentencia: 		sentCompuesta 
			|sentExpresión 
			|sentSelección 
			|sentIteración 
			|sentSalto

sentCompuesta: 	    	'{' listaDeclaraciones listaSentencias '}' //(verificar
			|'{' '}'

listaDeclaraciones: 	declaración
 			|listaDeclaraciones declaración

listaSentencias: 	sentencia
 			|listaSentencias sentencia

sentExpresión: 		;
			|expresion

sentSelección: 		if '(' expresión ')' sentencia
 			|if '(' expresión ')' sentencia else sentencia
 			|switch '(' expresión ')' sentencia

sentIteración:		while '(' expresión ')' sentencia
 			|do sentencia while '(' expresión ')' ;
   			|for '(' expresión ';' expresión ';' expresión ')' sentencia //verrificar si estan todas las opciones
			|for '(' ';' ';' ')'
			|for '('  ';' expresión ';'  ')'

sentSalto: 		return expresión ;
			|return

//EXPRESIONES
 
expresion:          expAsignacion
                    ;
expAsignacion:      expCondicional
                    |expUnaria operAsignacion expAsignacion {if(!$<s.lvalue>1){printf("Error en la asignacion: No es un lvalue modificable");}}
                    ;
operAsignacion:     '='|OPASIGNACION
;
expCondicional:     expOr
                    |expOr '?' expresion ':' expCondicional{$<s.numero>$ = $<s.numero>1?$<s.numero>3:$<s.numero>5;}
                    ;
expOr:              expAnd
                    |expOr OPOR expAnd
                    ;
expAnd:             expIgualdad
                    |expAnd OPAND expIgualdad
                    ;
expIgualdad:        expRelacional
                    |expIgualdad OPIGUALDAD expRelacional
                    ;
expRelacional:      expAditiva
                    |expRelacional OPRELACIONAL expAditiva {$<s.numero>$ = opRelacional($<s.numero>1,$<s.cadena>2,$<s.numero>3)}
                    ;
expAditiva:         expMultiplicativa
                    |expMultiplicativa '+' expAditiva {$<s.numero>$ = $<s.numero>1 + $<s.numero>3;} 
                    |expMultiplicativa '-' expAditiva {$<s.numero>$ = $<s.numero>1 - $<s.numero>3;} 
                    ;
expMultiplicativa:  expUnaria
                    |expMultiplicativa '*' expUnaria {$<s.numero>$ = $<s.numero>1 * $<s.numero>3;} 
		    |expMultiplicativa '/' expUnaria {$<s.numero>$ = $<s.numero>1 / $<s.numero>3;} 
                    ;
expUnaria:          expPostfijo
                    |operUnario expUnaria 
                    |SIZEOF'('nombreTipo')' {$<s.numero>$ = sizeof(int);}
                    ;
operUnario:         '&'|'*'|'-'|'!'|OPPPMM
;
expPostfijo:        expPrimaria
                    |expPostfijo'['expresion']'
                    |expPostfijo'('listaArgumentos')'
                    ;
listaArgumentos:    expAsignacion
                    |listaArgumentos ',' expAsignacion
                    ;
expPrimaria:        IDENTIFICADOR {$<s.lvalue>$ = 1;}
                    |NUM
                    |CADENA
                    |'(' expresion ')'{$<s.numero>$ = $<s.numero>2;}
                    ;
nombreTipo:         TYPENAME 
;

%%
yyerror (s)  /* Llamada por yyparse ante un error */
     char *s;
{
  printf ("%s\n", s);
}

main (){
    yyparse();
}
