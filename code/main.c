#include  <stdio.h>
#include  "tree.h"
#include  "syntax.tab.h"
extern int yyerror(char *msg);
extern int yyparse();
extern void yyrestart(FILE* f);
extern int yylineno;

int main(int argc,char** argv)
{
	if(argc < 2)
		return 1;
	for(int i = 1;i < argc;i++){
		printf("test file: %s\n",argv[i]);
		yylineno = 1;
		myerror = 0;
		FILE* f = fopen(argv[i],"r");
		if(!f){
			perror(argv[1]);
			return 1;
		}
		yyrestart(f);
    	yyparse();
		if(myerror == 0)
			printNode(root,2);
		fclose(f);
		printf("*******************\n");
	}
	return 0;
}

//printf syntax error
int yyerror(char *msg){
	fprintf(stderr,"Error type B at Line %d: unkonwn \"%s\"",yylineno,yylval.node->lexical);
	fprintf(stderr,"\n");
}
