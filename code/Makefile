parsor : main.c syntax.tab.c lex.yy.c tree.c
	gcc main.c syntax.tab.c tree.c -lfl -ly -o parsor

syntax.tab.c : syntax.y
	bison -d -v syntax.y

lex.yy.c : flexical.l
	flex flexical.l

clean:
	rm -rf lex.yy.c
	rm syntax.tab.c
	rm syntax.tab.h
	rm syntax.output
	rm -f parsor
