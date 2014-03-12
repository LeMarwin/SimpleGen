module Gen.Population;

import std.random;
import std.stdio;
import std.algorithm;

import Gen.Main;
import Gen.Indi;
import Gen.ExprTree;

Indi[] crossover(ref Indi[] couple,int tries = 0)
{
	writeln("m1");
	Expr buff;
	Expr q = couple[0].pickRand().node;
	writeln("m2");
	Expr[] niceNodes = couple[1].f.getNiceNodes(q.depth, q.height);
	writeln("m3");
	foreach(t;niceNodes)
		writeln(t.print);
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
	Indi[] populi;
	double avrF;
	void sortPopuli()
	{
		sort!("a.fit>b.fit")(populi);
	};
	void reproduce()
	{

	};
	void mutate()
	{

	};
	void generate(int num, int depth = MAX_DEPTH)
	{
		populi = [];
		for(int i=0;i<num;i++)
		{
			populi~= new Indi(depth);
		}
	}
	void calculate(double[][] data)
	{
		avrF = 0;
		foreach(ind;populi)
		{
			avrF+=ind.fittness(data);
		}
		avrF=avrF/populi.length;
		this.sortPopuli;
	}
	Indi getBest()
	{
		return populi[0];
	}
}