#include "tree.h"

//create treenode
void createNode(treeNode **curr,int type,int line,char *name,char *lexical){
	*curr = (treeNode *)malloc(sizeof(struct treeNode));
	(*curr)->type = type;
	(*curr)->line = line;
	int i = 0;
	while(name[i] != '\0'){
		(*curr)->name[i] = name[i];
		i++;
	}
	(*curr)->name[i] = name[i];
	i = 0;	
	while(lexical[i] != '\0'){
		(*curr)->lexical[i] = lexical[i];
		i++;
	}
	(*curr)->lexical[i] = lexical[i];
	for(i = 0;i < 7;i++)
		((*curr)->children)[i] = NULL;
	(*curr)->childNum = 0;
}

//add uncertain number children
void addChildren(treeNode *parent,int num,...){
	if(num <= 0)
		return ;
	va_list ap;
	va_start(ap,num);
	parent->childNum = num;
	for(int i = 0;i < num;i++){
		parent->children[i] = (treeNode *)va_arg(ap,treeNode *);
	}
	va_end(ap);
}

//dfs print syntax tree
void printNode(treeNode* node,int space){
	if(node == NULL)
		return;
	for(int i =0;i < space;i++)
		printf(" ");
	printf("%s",node->name);
	//ternimal
	if(node->type == 0){
		if(strcmp(node->name,"TYPE") == 0 || strcmp(node->name,"ID") == 0)
			printf(": %s\n",node->lexical);
		else if(strcmp(node->name,"INT") == 0){
			int val;
			if(node->lexical[0] == 'x' || node->lexical[0] == 'X' || node->lexical[1] == 'x' || node->lexical[1] == 'X')
				val = strtol(node->lexical,NULL,16);
			else if(node->lexical[0] == '0' && node->lexical[1] != '\0' || ((node->lexical[0] == '+' || node->lexical[0] == '-') && node->lexical[1] == '0' && node->lexical[1] != '\0'))
				val = strtol(node->lexical,NULL,8);
			else
				val = atoi(node->lexical);
			printf(": %d\n",val);	
	}
		else if(strcmp(node->name,"FLOAT") == 0)
			printf(": %f\n",atof(node->lexical));
		else
			printf("\n");
	}
	//non-ternimal
	else if(node->type == 1){
		printf(" \(%d)\n",node->line);
	}
	//dfs
	for(int i = 0;i < node->childNum;i++)
		printNode(node->children[i],space+2);
}
