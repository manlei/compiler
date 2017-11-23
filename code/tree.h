#ifndef TREENODE_H
#define TREENODE_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <malloc.h>
#include <stdarg.h>

typedef struct treeNode{
	int type;
	int line;
	char name[10];
	char lexical[30];
	struct treeNode* children[7];
	int childNum;
}treeNode;

struct treeNode* root;
int myerror;
void createNode(treeNode** curr,int type,int line,char* name,char* lexical);
void printTree(treeNode* root);
void printNode(treeNode* node,int space);
void addChildren(treeNode *parent,int num,...);
#endif
