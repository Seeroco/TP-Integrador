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
	int pointer;
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
									strcpy(funciones[funcioneslen].type[funciones[funcioneslen].length],$<s.tipo>1);
									funcioneslen++;}
			;
cuerpo:			';'
			|sentencia
			;
parametros:		/*vacio*/
			|TYPENAME variable 		{if($<s.pointer>2){strcpy($<s.tipo>1,strcat($<s.tipo>1,"*"));}
							$<s.lvalue>$ = 1;
							strcpy($<s.tipo>$,$<s.tipo>1);
							strcpy(identificadores.value[identificadores.length],$<s.cadena>2);
							strcpy(identificadores.type[identificadores.length],$<s.tipo>1);
							identificadores.length++;
							strcpy(funciones[funcioneslen].type[funciones[funcioneslen].length],$<s.tipo>1);
							funciones[funcioneslen].length++}
			|parametros',' TYPENAME variable {if($<s.pointer>2){strcpy($<s.tipo>1,strcat($<s.tipo>1,"*"));}
							$<s.lvalue>$ = 3;
							strcpy($<s.tipo>$,$<s.tipo>3);
							strcpy(identificadores.value[identificadores.length],$<s.cadena>4);
							strcpy(identificadores.type[identificadores.length],$<s.tipo>3);
							identificadores.length++;
							strcpy(funciones[funcioneslen].type[funciones[funcioneslen].length],$<s.tipo>3);
							funciones[funcioneslen].length++;}
			;
declaracionVariable: 	TYPENAME unaVarSimple {		if(yaDeclarado($<s.cadena>2,identificadores)){printf("Doble declaracion de variables\n");}
							else{	if($<s.pointer>2){
									strcpy($<s.tipo>1,strcat($<s.tipo>1,"*"));
								}
								if(chequearTipos($<s.tipo>1,$<s.tipo>2)){
									$<s.lvalue>$ = 1;
									strcpy($<s.tipo>$,$<s.tipo>1);
									strcpy(identificadores.value[identificadores.length],$<s.cadena>2);
									strcpy(identificadores.type[identificadores.length],$<s.tipo>1);
									identificadores.length++;
								}
								else{
									printf("Tipos de datos no compatibles en la asignación\n");
								}
							}}
			;

unaVarSimple:		variable			
			|variable inicial		{strcpy($<s.cadena>$,$<s.cadena>1);
							 strcpy($<s.tipo>$,$<s.tipo>2);} 
			;
variable:		IDENTIFICADOR opArray {strcpy($<s.tipo>$,$<s.tipo>1);
						$<s.pointer>$ = $<s.pointer>2;}
opArray:		/*vacio*/	{$<s.pointer>$ = 0;}
			|'['expresion']'{$<s.pointer>$ = 1;}
			;
inicial: 		'=' expresion	{strcpy($<s.cadena>$,$<s.cadena>2);
						strcpy($<s.tipo>$,$<s.tipo>2);
						$<s.numero>$ = $<s.numero>2;}
			;




//EXPRESIONES
expresion:          expAsignacion
                    ;
expAsignacion:      expCondicional
                    |expUnaria operAsignacion expAsignacion {if(!$<s.lvalue>1){printf("Error en la asignacion: %f no es un lvalue modificable",$<s.numero>1);}
								getMap($<s.cadena>1,identificadores,$<s.tipo>1);
								if(existsMap($<s.cadena>3,identificadores)){getMap($<s.cadena>3,identificadores,$<s.tipo>3);}
								removePointer($<s.tipo>1,$<s.pointer>1);
								removePointer($<s.tipo>3,$<s.pointer>3);
							 	if(!chequearTipos($<s.tipo>1,$<s.tipo>3)){printf("%s y %s tienen tipos incompatibles para la asignacion\n",$<s.cadena>1,$<s.cadena>3);}}
                    ;
operAsignacion:     '='|OPASIGNACION 
;
expCondicional:     expOr
                    |expOr '?' expresion ':' expCondicional
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
                    |expRelacional OPRELACIONAL expAditiva
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
                    |SIZEOF'('nombreTipo')'
                    ;
operUnario:         '&'|'*'|'-'|'!'|OPPPMM
;
expPostfijo:        expPrimaria
                    |expPostfijo'['expresion']'{$<s.pointer>$ = 1}
                    |expPostfijo'('listaArgumentos')'
                    ;
listaArgumentos:    expAsignacion
                    |listaArgumentos ',' expAsignacion
                    ;
expPrimaria:        IDENTIFICADOR {$<s.lvalue>$ = 1; if(!existsMap($<s.cadena>1,identificadores)){printf("Identificador %s no ha sido declarado\n",$<s.cadena>1);}}
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