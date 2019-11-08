%{
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include "rutinas semanticas.h"
extern FILE *yyin;

map identificadores;

%}

%union {
  struct {
	char cadena[100];
	float numero;
	char tipo[100];
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

//main:			TYPENAME IDENTIFICADOR '('')''{'lineList'}'{printf("Main?");}
			
lineList:		line
			|lineList line
line:			'\n'
			|sentencia '\n'

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
declaracionFuncion:	TYPENAME IDENTIFICADOR'('parametros')'{printf("Llegaron al main");}
			;
parametros:		/*vacio*/
			|TYPENAME variable 
			|parametros',' TYPENAME variable
			;
declaracionVariable: 	TYPENAME listaVarSimples {if(yaDeclarado($<s.cadena>2,identificadores)){printf("Doble declaración de variables");}else{
							$<s.lvalue>$ = 1;
							strcpy($<s.tipo>$,$<s.tipo>1);
							strcpy(identificadores.value[identificadores.length],$<s.cadena>2);
							strcpy(identificadores.type[identificadores.length],$<s.cadena>1);
							identificadores.length++;}}
			;

listaVarSimples: 	unaVarSimple
 			|listaVarSimples ',' unaVarSimple
			;

unaVarSimple: 		variable	 
			|variable inicial 
			;
variable:		IDENTIFICADOR opArray 
opArray:		/*vacio*/
			|'['expresion']'
			;
inicial: 		'=' expresion	{strcpy($<s.cadena>$,$<s.cadena>2);
						strcpy($<s.tipo>$,$<s.tipo>2);
						$<s.numero>$ = $<s.numero>2;}
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
                    |expMultiplicativa '+' expAditiva {checkType($<s.tipo>1,$<s.tipo>3);}
                    |expMultiplicativa '-' expAditiva {checkType($<s.tipo>1,$<s.tipo>3);} 
                    ;
expMultiplicativa:  expUnaria
                    |expMultiplicativa '*' expUnaria {checkType($<s.tipo>1,$<s.tipo>3);} 
		    |expMultiplicativa '/' expUnaria {checkType($<s.tipo>1,$<s.tipo>3);}
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
expPrimaria:        IDENTIFICADOR 
                    |NUM
                    |CADENA
		    |CARACTER	
                    |'(' expresion ')'{$<s.numero>$ = $<s.numero>2;}
                    ;
nombreTipo:         TYPENAME 
;

%%
yyerror (s)  /* Llamada por yyparse ante un error */
     char *s;
{
  printf ("%s\n",s);
}

main (){
    yyin = fopen("entrada.txt","r+");
    yyparse();
    reportMap(identificadores,"Identificador: ");
}