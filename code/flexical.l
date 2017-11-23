%{
	#include <stdio.h>
	#include "tree.h"
	#include "syntax.tab.h"
    #define YY_USER_ACTION \
        yylloc.first_line = yylloc.last_line = yylineno; \
        yylloc.first_column = yycolumn; \
        yylloc.last_column = yycolumn + yyleng - 1; \
        yycolumn += yyleng; 
    int yycolumn = 1;
%}

%option yylineno

digit [0-9]
dec 0|[1-9][0-9]*
oct 0(0|[1-7][0-7]*)
hexa 0[xX](0|[1-9a-fA-F][0-9a-fA-F]*)
FLOAT (0|[1-9][0-9]*"."[0-9]+)|([0-9]*"."[0-9]*[eE][+-]?[0-9]+)
SEMI ";"
COMMA ","
ASSIGNOP "="
RELOP ">"|"<"|">="|"<="|"=="|"!="
PLUS "+"
MINUS "-"
STAR "*"
DIV "/"
AND "&&"
OR "||"
DOT "."
NOT "!"
TYPE "int"|"float"
LP "("
RP ")"
LB "["
RB "]"
LC "{"
RC "}"
STRUCT "struct"
RETURN "return"
IF "if"
ELSE "else"
WHILE "while"
ID [a-zA-Z_][a-zA-Z0-9_]{0,51}

%%
{dec}|{oct}|{hexa} { createNode(&(yylval.node),0,yylineno,"INT",yytext); return INT; }
{FLOAT} { createNode(&(yylval.node),0,yylineno,"FLOAT",yytext); return FLOAT; }
{SEMI} { createNode(&(yylval.node),0,yylineno,"SEMI",yytext); return SEMI; }
{COMMA} { createNode(&(yylval.node),0,yylineno,"COMMA",yytext); return COMMA; }
{ASSIGNOP} { createNode(&(yylval.node),0,yylineno,"ASSIGNOP",yytext); return ASSIGNOP; }
{RELOP} { createNode(&(yylval.node),0,yylineno,"RELOP",yytext); return RELOP; }
{PLUS} { createNode(&(yylval.node),0,yylineno,"PLUS",yytext); return PLUS; }
{MINUS} { createNode(&(yylval.node),0,yylineno,"MINUS",yytext); return MINUS; }
{STAR} { createNode(&(yylval.node),0,yylineno,"STAR",yytext); return STAR; }
{DIV} { createNode(&(yylval.node),0,yylineno,"DIV",yytext); return DIV; }
{AND} { createNode(&(yylval.node),0,yylineno,"AND",yytext); return AND; }
{OR} { createNode(&(yylval.node),0,yylineno,"OR",yytext); return OR; }
{DOT} { createNode(&(yylval.node),0,yylineno,"DOT",yytext); return DOT; }
{NOT} { createNode(&(yylval.node),0,yylineno,"NOT",yytext); return NOT; }
{TYPE} { createNode(&(yylval.node),0,yylineno,"TYPE",yytext); return TYPE; }
{LP} { createNode(&(yylval.node),0,yylineno,"LP",yytext); return LP; }
{RP} { createNode(&(yylval.node),0,yylineno,"RP",yytext); return RP; }
{LB} { createNode(&(yylval.node),0,yylineno,"LB",yytext); return LB; }
{RB} { createNode(&(yylval.node),0,yylineno,"RB",yytext); return RB; }
{LC} { createNode(&(yylval.node),0,yylineno,"LC",yytext); return LC; }
{RC} { createNode(&(yylval.node),0,yylineno,"RC",yytext); return RC; }
{STRUCT} { createNode(&(yylval.node),0,yylineno,"STRUCT",yytext); return STRUCT; }
{RETURN} { createNode(&(yylval.node),0,yylineno,"RETURN",yytext); return RETURN; }
{IF} { createNode(&(yylval.node),0,yylineno,"IF",yytext); return IF; }
{ELSE} { createNode(&(yylval.node),0,yylineno,"ELSE",yytext); return ELSE; }
{WHILE} { createNode(&(yylval.node),0,yylineno,"WHILE",yytext); return WHILE; }
{ID} { createNode(&(yylval.node),0,yylineno,"ID",yytext); return ID; }
" " { ; }
"	" { ; }
"\n" { yycolumn = 1; }
"//" {
	char c = input();
	while(c != '\n') c = input();
}

"/*" {
	char c1 = input();
	char c2 = input();
	while(c1 != '*' || c2 != '/'){
		c1 = c2;
		c2 = input();
	}
}

. { myerror = 1; printf("Error type A at Line %d: Mysterious characters \'%s\'\n",yylineno,yytext); }
%%
