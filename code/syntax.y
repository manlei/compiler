%{
	#include <stdio.h>
	#include "tree.h"
	#include "lex.yy.c"
	int yyerror(const char *s);
%}

%union {
	int type_int;
	float type_float;
	double type_double;
	treeNode* node;
};

%locations
%token <node> INT
%token <node> FLOAT SEMI COMMA ASSIGNOP RELOP PLUS MINUS STAR DIV AND OR DOT
%token <node> NOT TYPE LP RP LB RB LC RC STRUCT RETURN IF ELSE WHILE ID

%type <node> Program ExtDefList ExtDef Specifier ExtDecList FunDec CompSt VarDec StructSpecifier OptTag DefList Tag VarList ParamDec StmtList Stmt Exp Def Dec DecList Args

%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left LP RP LB RB DOT

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
Program:ExtDefList { createNode(&($$),1,$1->line,"Program",""); addChildren($$,1,$1); root = $$; }
	;

ExtDefList:ExtDef ExtDefList { createNode(&($$),1,$1->line,"ExtDefList",""); addChildren($$,2,$1,$2); }
	| /* empty */ { $$ = NULL; }
	;

ExtDef:Specifier ExtDecList SEMI { createNode(&($$),1,$1->line,"ExtDef",""); addChildren($$,3,$1,$2,$3); }
	| Specifier SEMI { createNode(&($$),1,$1->line,"ExtDef",""); addChildren($$,2,$1,$2); }
	| Specifier FunDec CompSt { createNode(&($$),1,$1->line,"ExtDef",""); addChildren($$,3,$1,$2,$3); }
	| error SEMI { myerror = 1; }
	;

ExtDecList:VarDec { createNode(&($$),1,$1->line,"ExtDecList",""); addChildren($$,1,$1); }
	| VarDec COMMA ExtDecList { createNode(&($$),1,$1->line,"ExtDecList",""); addChildren($$,3,$1,$2,$3); }
	| error COMMA ExtDecList { myerror = 1; }
	;

Specifier:TYPE { createNode(&($$),1,$1->line,"Specifier",""); addChildren($$,1,$1); }
	| StructSpecifier { createNode(&($$),1,$1->line,"Specifier",""); addChildren($$,1,$1); }
	;

StructSpecifier:STRUCT OptTag LC DefList RC { createNode(&($$),1,$1->line,"StructSpecifier",""); addChildren($$,5,$1,$2,$3,$4,$5); }
	| STRUCT Tag { createNode(&($$),1,$1->line,"StructSpecifier",""); addChildren($$,2,$1,$2); }
	| STRUCT OptTag LC error DefList RC { myerror = 1; }
	;

OptTag:ID { createNode(&($$),1,$1->line,"OptTag",""); addChildren($$,1,$1);  }
	| /* empty */ { $$ = NULL; }
	;

Tag:ID { createNode(&($$),1,$1->line,"Tag",""); addChildren($$,1,$1); }
	;

VarDec:ID { createNode(&($$),1,$1->line,"VarDec",""); addChildren($$,1,$1); }
	| VarDec LB INT RB { createNode(&($$),1,$1->line,"VarDec",""); addChildren($$,4,$1,$2,$3,$4); }
	| error RB { myerror = 1; }
	;

FunDec:ID LP VarList RP { createNode(&($$),1,$1->line,"FunDec",""); addChildren($$,4,$1,$2,$3,$4); }
	| ID LP RP { createNode(&($$),1,$1->line,"FunDec",""); addChildren($$,3,$1,$2,$3); }
	| error RP { myerror = 1; }
	;

VarList:ParamDec COMMA VarList { createNode(&($$),1,$1->line,"VarList",""); addChildren($$,3,$1,$2,$3); }
	| ParamDec { createNode(&($$),1,$1->line,"VarList",""); addChildren($$,1,$1); }
	| error COMMA VarList { myerror = 1; }
	;

ParamDec:Specifier VarDec { createNode(&($$),1,$1->line,"ParamDec",""); addChildren($$,2,$1,$2); }
	;

CompSt:LC DefList StmtList RC { createNode(&($$),1,$1->line,"CompSt",""); addChildren($$,4,$1,$2,$3,$4); }
	| error RC { myerror = 1; }
	;

StmtList:Stmt StmtList { createNode(&($$),1,$1->line,"StmtList",""); addChildren($$,2,$1,$2); }
	| /* empty */ { $$ = NULL; }
	;

Stmt:Exp SEMI { createNode(&($$),1,$1->line,"Stmt",""); addChildren($$,2,$1,$2); }
	| CompSt { createNode(&($$),1,$1->line,"Stmt",""); addChildren($$,1,$1); }
	| RETURN Exp SEMI { createNode(&($$),1,$1->line,"Stmt",""); addChildren($$,3,$1,$2,$3); }
	| IF LP Exp RP Stmt ELSE Stmt { createNode(&($$),1,$1->line,"Stmt",""); addChildren($$,7,$1,$2,$3,$4,$5,$6,$7); }
	| IF LP Exp RP Stmt %prec LOWER_THAN_ELSE { createNode(&($$),1,$1->line,"Stmt",""); addChildren($$,5,$1,$2,$3,$4,$5); }
	| WHILE LP Exp RP Stmt { createNode(&($$),1,$1->line,"Stmt",""); addChildren($$,5,$1,$2,$3,$4,$5); }
	| error SEMI { myerror = 1; }
	;

DefList:Def DefList { createNode(&($$),1,$1->line,"DefList",""); addChildren($$,2,$1,$2); }
	| /* empty */ { $$ = NULL; }
	;

Def:Specifier DecList SEMI { createNode(&($$),1,$1->line,"Def",""); addChildren($$,3,$1,$2,$3); }
	| Specifier DecList error SEMI { myerror = 1; }	
	;

DecList:Dec { createNode(&($$),1,$1->line,"DecList",""); addChildren($$,1,$1); }
	| Dec COMMA DecList { createNode(&($$),1,$1->line,"DecList",""); addChildren($$,3,$1,$2,$3); }
	;

Dec:VarDec { createNode(&($$),1,$1->line,"Dec",""); addChildren($$,1,$1); }
	| VarDec ASSIGNOP Exp { createNode(&($$),1,$1->line,"Dec",""); addChildren($$,3,$1,$2,$3); }
	;

Exp:Exp ASSIGNOP Exp { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| Exp AND Exp { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| Exp OR Exp { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| Exp RELOP Exp { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| Exp PLUS Exp { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| Exp MINUS Exp { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| Exp STAR Exp { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| Exp DIV Exp { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| LP Exp RP { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| MINUS Exp { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,2,$1,$2); }
	| NOT Exp { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,2,$1,$2); }
	| ID LP Args RP { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,4,$1,$2,$3,$4); }
	| ID LP RP { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| Exp LB Exp RB { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,4,$1,$2,$3,$4); }
	| Exp DOT ID { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,3,$1,$2,$3); }
	| ID { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,1,$1); }
	| INT { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,1,$1); }
	| FLOAT { createNode(&($$),1,$1->line,"Exp",""); addChildren($$,1,$1); }
	| error RP { myerror = 1; }
	| error RB { myerror = 1; }
	;

Args:Exp COMMA Args { createNode(&($$),1,$1->line,"Args",""); addChildren($$,3,$1,$2,$3); }
	| Exp { createNode(&($$),1,$1->line,"Args",""); addChildren($$,1,$1); }
	| error COMMA Args { myerror = 1; }
	;
%%
