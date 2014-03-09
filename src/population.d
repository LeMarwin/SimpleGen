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
	Expr w = couple[1].pickRand().node;
	buff = q;
	q.parent.params~=w;
	w.parent.params~=buff;
	return [];
}

class Population
{
	Indi[] pops;
	void sort(){};
	void reproduce(){};
	void mutate(){};
	void generate(){};
}