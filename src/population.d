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

Indi[] crossover(Indi[] couple,int tries = 0)
{
	Expr[] cou = [couple[0].f, couple[1].f];
	Expr pick0 = cou[0].pickRand(0).node;
	Expr[] prepick = cou[1].getNiceNodes(pick0.depth, pick0.height);
	/*if((prepick.length==0)&&(tries<3))
		return crossover(couple,tries+1);
	else if ((prepick.length==0)&&(tries>=3))
		return couple;*/


	int n = uniform!"[]"(0,prepick.length-1);
	Expr pick1 = prepick[n];
	Expr buff = pick0;

	writeln("c1 = ", cou[0].print);
	writeln("p1 = ",pick0.print,"\n");
	writeln("c2 = ",cou[1].print);
	writeln("p2 = ",pick1.print);
	if(pick0!=cou[0])
		foreach(p;pick0.parent.params)
		{
			writeln(p.print);
			if(p==pick0)
				{
					p=pick1;
					writeln("A");
				}
		}
	else
		pick0=pick1;

	if(pick1!=cou[1])
		foreach(p;pick1.parent.params)
		{	
			//writeln(p.print);
			if(p==pick1)
			{
				p=buff;
				writeln("B");
			}
		}
	else
		pick1=buff;

	writeln("\np1 = ",pick0.print);
	writeln("p2 = ",pick1.print);
	writeln("c1 = ",cou[0].print);
	writeln("c2 = ",cou[1].print);
	return [new Indi(cou[0]), new Indi(cou[1])];
}

class Population
{
	Indi[] pops;
	void sort(){};
	void reproduce(){};
	void mutate(){};
	void generate(){};
}