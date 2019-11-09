%{
#include <math.h>
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include "rutinas semanticas.h"
extern FILE *yyin;

map identificadores;
fInfo funciones[100];
int funcioneslen = 0;

int lineas = 1;

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
%token <s> FOR
%token <s> DO
%token <s> SWITCH
%token <s> IF
%token <s> ELSE
%token <s> WHILE
%token <s> RETURN
%token <s> CARACTER
%expect 2
%%

//main:			TYPENAME IDENTIFICADOR '('')''{'lineList'}'{printf("Main?");}
			
input:			/*vacio*/		
			|input line
line:			'\n'{lineas++;}
			|sentencia '\n'{lineas++;}
			|sentencia

sentencia: 		sentSeleccion 
			|sentenciaCompuesta
			|sentIteracion 
			|sentSalto';'
			|sentExpresion';'
			|declaracion 
			;
sentenciaCompuesta:	'{'listaDeSentencias'}'
			;

listaDeSentencias:      /*vacio*/
			|listaDeSentencias'\n'	{lineas++;}
			|listaDeSentencias sentencia '\n'{lineas++;}
			;
sentExpresion:		expresion
			;

sentSeleccion: 		IF '(' expresion ')' sentencia 
			|IF '(' expresion ')' sentencia ELSE sentencia 
 			|SWITCH '(' expresion ')' sentencia 
			;


sentIteracion:		WHILE '(' expresion ')' sentencia 
			|DO sentencia WHILE '(' expresion ')' ';'
			|FOR '(' paramFor1 ';' paramFor2 ';' paramFor2 ')' sentencia 

paramFor1:		/*vacio*/
			|declaracionVariable
			;
paramFor2:		/*vacio*/
			|expresion
			;

sentSalto: 		RETURN expresion 


//DECLARACIONES
declaracion:		declaracionVariable ';'
			|declaracionFuncion
			;
declaracionFuncion:	TYPENAME IDENTIFICADOR'('parametros')' cuerpo	{strcpy(funciones[funcioneslen].name,$<s.cadena>2);
									strcpy(funciones[funcioneslen].type[funciones[funcioneslen].length],$<s.cadena>1);
									funcioneslen++;}
			;
cuerpo:			';'
			|sentencia
			;
parametros:		/*vacio*/
			|TYPENAME variable 		{$<s.lvalue>$ = 1;
							strcpy($<s.tipo>$,$<s.tipo>1);
							strcpy(identificadores.value[identificadores.length],$<s.cadena>2);
							strcpy(identificadores.type[identificadores.length],strcat($<s.cadena>1,$<s.tipo>2));
							identificadores.length++;
							strcpy(funciones[funcioneslen].type[funciones[funcioneslen].length],strcat($<s.cadena>1,$<s.tipo>2));
							funciones[funcioneslen].length++}
			|parametros',' TYPENAME variable {$<s.lvalue>$ = 3;
							strcpy($<s.tipo>$,$<s.tipo>3);
							strcpy(identificadores.value[identificadores.length],$<s.cadena>4);
							strcpy(identificadores.type[identificadores.length],strcat($<s.cadena>3,$<s.tipo>4));
							identificadores.length++;
							strcpy(funciones[funcioneslen].type[funciones[funcioneslen].length],strcat($<s.cadena>3,$<s.tipo>4));
							funciones[funcioneslen].length++}
			;
declaracionVariable: 	TYPENAME listaVarSimples {if(yaDeclarado($<s.cadena>2,identificadores)){printf("Doble declaracion de variables\n");}else{
							$<s.lvalue>$ = 1;
							strcpy($<s.tipo>$,$<s.tipo>1);
							strcpy(identificadores.value[identificadores.length],$<s.cadena>2);
							strcpy(identificadores.type[identificadores.length],strcat($<s.cadena>1,$<s.tipo>2));
							identificadores.length++;}}
			;

listaVarSimples: 	unaVarSimple
 			|listaVarSimples ',' unaVarSimple
			;

unaVarSimple: 		variable	 
			|variable inicial 
			;
variable:		IDENTIFICADOR opArray {strcpy($<s.tipo>$,$<s.tipo>2);}
opArray:		/*vacio*/	{strcpy($<s.tipo>$," ");}
			|'['expresion']'{strcpy($<s.tipo>$,"*");}
			;
inicial: 		'=' expresion	{strcpy($<s.cadena>$,$<s.cadena>2);
						strcpy($<s.tipo>$,$<s.tipo>2);
						$<s.numero>$ = $<s.numero>2;}
			;




//EXPRESIONES
expresion:          expAsignacion
                    ;
expAsignacion:      expCondicional
                    |expUnaria operAsignacion expAsignacion {if(!$<s.lvalue>1){printf("Error en la asignacion: %s no es un lvalue modificable",$<s.numero>1);}}
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
expPrimaria:        IDENTIFICADOR {$<s.lvalue>$ = 1;}
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
  printf ("Error de sintaxis en la linea: %d. Terminando el programa. \n",lineas);
}

main (){
    yyin = fopen("entrada.txt","r+");
    int error = yyparse();
    if(!error){
	reportMap(identificadores,"Identificador: ");
	reportFunction(funciones,funcioneslen);
    }
}