%{
#include "expresiones.tab.h"
#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>
#include <string.h>
%}

ENTERO			[1-9][0-9]*
REAL            	[0-9]+("."[0-9]+)?
CADENA			\"([^\"]|(\\\"))*\"
TIPODATO		(char|double|float|int|long|short|void)
OPASIGNACION		(=|\+=|\-=|\*=|\/=)
IDENTIFICADOR 		[a-z_][a-zA-Z0-9]*
OPOR			\|\|
OPAND			&&
OPIGUALDAD		==|!=
OPRELACIONAL		<=|>=|>|<
OPPPMM			\+\+|\-\-
%%

{ENTERO}  	{yylval.s.numero = atoi(yytext); return NUM;}
{REAL}		{yylval.s.numero = atof(yytext); return NUM;}
{CADENA}	{strcpy(yylval.s.cadena,yytext); return CADENA;}
"+"		{return '+';}
"-"		{return '-';}
"*"		{return '*';}
"/"		{return '/';}
"("		{return '(';}
")"		{return ')';}
"="		{return '=';}
"\n"    	{return '\n';}
"?"		{return '?';}
":"		{return ':';}
"&"		{return '&';}
"!"		{return '!';}
","		{return ',';}
sizeof		{return SIZEOF;}
{TIPODATO}	{strcpy(yylval.s.cadena,yytext);return TYPENAME;}
{IDENTIFICADOR} {strcpy(yylval.s.cadena,yytext);yylval.s.tipo = 1;return IDENTIFICADOR;}
{OPASIGNACION}	{strcpy(yylval.s.cadena,yytext);return OPASIGNACION;}
{OPOR}		{strcpy(yylval.s.cadena,yytext);return OPOR;}
{OPAND}		{strcpy(yylval.s.cadena,yytext);return OPAND;}
{OPIGUALDAD}	{strcpy(yylval.s.cadena,yytext);return OPIGUALDAD;}
{OPRELACIONAL}	{strcpy(yylval.s.cadena,yytext);return OPRELACIONAL;}
{OPPPMM}	{strcpy(yylval.s.cadena,yytext);return OPPPMM;}
%%
