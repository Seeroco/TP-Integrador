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
TIPODATO		(char|double|float|int|long|short|void)"*"?
OPASIGNACION		(=|\+=|\-=|\*=|\/=)
CARACTER		'.'
IDENTIFICADOR 		[a-zA-Z_][a-zA-Z0-9_]*
OPOR			\|\|
OPAND			&&
OPIGUALDAD		==|!=
OPRELACIONAL		<=|>=|>|<
OPPPMM			\+\+|\-\-
%%
{CARACTER}	{yylval.s.numero = yytext[1];  strcpy(yylval.s.tipo,"char"); return CARACTER;}
{ENTERO}  	{yylval.s.numero = atoi(yytext); strcpy(yylval.s.tipo,"int"); return NUM;}
{REAL}		{yylval.s.numero = atof(yytext);strcpy(yylval.s.tipo,"float");return NUM;}
{CADENA}	{strcpy(yylval.s.cadena,yytext);strcpy(yylval.s.tipo,"char*");return CADENA;}
while		{return WHILE;}
if		{return IF;}
for		{return FOR;}
else		{return ELSE;}
return		{return RETURN;}
do		{return DO;}
"+"		{return '+';}
"-"		{return '-';}
"*"		{return '*';}
"/"		{return '/';}
"("		{return '(';}
")"		{return ')';}
{OPIGUALDAD}	{strcpy(yylval.s.cadena,yytext);return OPIGUALDAD;}
"="		{return '=';}
"\n"    	{return '\n';}
"?"		{return '?';}
":"		{return ':';}
"&"		{return '&';}
"!"		{return '!';}
","		{return ',';}
"["		{return '[';}
"]"		{return ']';}
";"		{return ';';}
"{"		{return '{';}
"}"		{return '}';}
sizeof		{return SIZEOF;}
{TIPODATO}	{strcpy(yylval.s.cadena,yytext);return TYPENAME;}
{IDENTIFICADOR} {strcpy(yylval.s.cadena,yytext);return IDENTIFICADOR;}
{OPASIGNACION}	{strcpy(yylval.s.cadena,yytext);return OPASIGNACION;}
{OPOR}		{strcpy(yylval.s.cadena,yytext);return OPOR;}
{OPAND}		{strcpy(yylval.s.cadena,yytext);return OPAND;}

{OPRELACIONAL}	{strcpy(yylval.s.cadena,yytext);return OPRELACIONAL;}
{OPPPMM}	{strcpy(yylval.s.cadena,yytext);return OPPPMM;}
" "	
"\t"			
%%
