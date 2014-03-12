module Gen.Population;

import std.random;
import std.stdio;

import Gen.Main;
import Gen.Indi;
import Gen.ExprTree;

int getPos(Expr[] p, Expr t)
{
	for(int i=0;i<p.length;i++)
		if(p[i]==t)
			return i;
	return -1;
}

Indi[] crossover(ref Indi[] couple,int tries = 0)
{
	Expr buff;
	Expr q = couple[0].pickRand().node;
	Expr[] niceNodes = couple[1].f.getNiceNodes(q.depth, q.height);
	int n = uniform!"[)"(0,niceNodes.length);
	Expr w = niceNodes[n];
	buff = q;
	writeln("q = ",q.print);
	writeln("w = ",w.print);
	if(q==couple[0].f)
		couple[0].f=w;
	if(w==couple[1].f)
		couple[1].f=buff;
	Expr[] tempPar = [];
	foreach(p;q.parent.params)
		if(q==p)
			tempPar~=w;
		else
			tempPar~=p;
	q.parent.params = tempPar;

	tempPar = [];
	foreach(p;w.parent.params)
		if(w==p)
			tempPar~=buff;
		else
			tempPar~=p;
	w.parent.params = tempPar;
	return [new Indi(couple[0].f), new Indi(couple[1].f)];
}

class Population
{
	Indi[] pops;
	void sort(){};
	void reproduce(){};
	void mutate(){};
	void generate(){};
}