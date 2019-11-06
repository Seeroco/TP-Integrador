%{
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include "rutinas semanticas.h"
extern FILE *yyin;

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
%token <s> FOR
%token <s> DO
%token <s> SWITCH
%token <s> IF
%token <s> ELSE
%token <s> WHILE
%token <s> RETURN
%token <s> CARACTER
%%
input:    /* vac�o */
        | input line
;

line:     '\n'
        | listaSentencias'\n'
;

listaSentencias:	sentencia
			|listaSentencias sentencia

sentencia: 		sentSeleccion ';'
			|sentIteracion ';'
			|sentSalto';'
			|sentExpresion';'
			|declaracion ';'
			;

sentExpresion:		expresion
			;

sentSeleccion: 		IF '(' expresion ')' sentencia
 			|IF '(' expresion ')' sentencia ELSE sentencia
 			|SWITCH '(' expresion ')' sentencia
			;

sentIteracion:		WHILE '(' expresion ')' sentencia 
			|DO sentencia WHILE '(' expresion ')'
			|FOR '(' expresion ';' expresion ';' expresion ')' sentencia //verificar si estan todas las opciones
			|FOR '(' ';' ';' ')' 
			|FOR '('  ';' expresion ';'  ')'
sentSalto: 		RETURN expresion 


//DECLARACIONES
declaracion:		declaracionVariable
			|declaracionFuncion
			;

declaracionFuncion:	TYPENAME IDENTIFICADOR'('parametros')''{'listaSentencias'}'
			;

parametros:		/*vacio*/
			|TYPENAME IDENTIFICADOR opArray
			|parametros',' TYPENAME IDENTIFICADOR opArray
			;
declaracionVariable: 	TYPENAME listaVarSimples
			;

listaVarSimples: 	unaVarSimple
 			|listaVarSimples ',' unaVarSimple
			;

unaVarSimple: 		IDENTIFICADOR opArray
			|IDENTIFICADOR opArray inicial
			;
opArray:		/*vacio*/
			|'['expresion']'
			;
inicial: 		'=' expresion
			;




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
nombreTipo:         TYPENAME {printf("He leido");}
;

%%
yyerror (s)  /* Llamada por yyparse ante un error */
     char *s;
{
  printf ("%s\n", s);
}

main (){
    //yyin = fopen("entrada.txt","r+");
    yyparse();
}