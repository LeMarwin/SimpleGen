module Gen.Population;

import std.random;
import std.stdio;
import std.algorithm;
import std.array;
import std.math;
import std.typecons;

import Gen.Main;
import Gen.Indi;
import Gen.ExprTree;

Indi[] crossover(ref Indi p1, ref Indi p2 ,int tries = 0)
{
	Expr buff;
	Expr q = p1.pickRand();
	Expr[] niceNodes = p2.f.getNiceNodes(q.depth, q.height);
	int n = uniform!"[)"(0,niceNodes.length);
	Expr w = niceNodes[n];
	buff = q;
	if(q==p1.f)
		p1.f=w;
	if(w==p2.f)
		p2.f=buff;
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
	return [new Indi(p1.f), new Indi(p2.f)];
}

int getLucker(double[] chances)
{
	double rs = uniform!"[]"(0.0,1.0);
	double buff = 0;
	for(int i = 0;i<chances.length;i++)
	{
		buff+=chances[i];
		if(rs<buff)
			return i;
	}
	return 0;
}

class Population
{
	Indi[] populi;
	double avrF;
	void sortPopuli()
	{
		sort!("a.fit>b.fit")(populi);
	};
	void reproduce(double eliteRate, double mutaRate)
	{
		int n = populi.length;
		int m = cast(int)(eliteRate*populi.length);
		Indi[] matingPool = uninitializedArray!(Indi[])(n-m);
		double[] chances = uninitializedArray!(double[])(n);
		Indi[] nextGen = uninitializedArray!(Indi[])(n);

		foreach(int i,ind;populi)
			chances[i] = ind.fit/(avrF*populi.length);
		for(int i=0;i<m;i++)
		{
			nextGen[i]=populi[i];
		}
		int i = m;
		Indi p1, p2;
		Indi[] buff;
		while(i<n)
		{
			p1 = populi[getLucker(chances)];
			p2 = populi[getLucker(chances)];
			buff = crossover(p1,p2);
			nextGen[i] = buff[0];
			if((i+1)<n)
				nextGen[i+1] = buff[1];
			i+=2;
		}
		destroy(populi);
		populi = nextGen;
	};
	void mutate()
	{
		// Seems like I don't need this
		// Who really checks this out?
	};
	void generate(int num, int depth = MAX_DEPTH)
	{
		destroy(populi);
		populi = [];
		for(int i=0;i<num;i++)
		{
			populi~= new Indi(depth);
		}
	}
	void calculate(double[][] data)
	{
		avrF = 0;
		double mseSum = 0;
		int n = 0;
		foreach(ind;populi)
		{
			ind.meanSquareError(data);
			if(!isNaN(ind.mse))
			{
				mseSum+=ind.mse;
				ind.fit = 1/ind.mse;
				avrF+=ind.fit;
				n++;
			}
			else 
				ind.fit = 0;
		}
		avrF=avrF/n;
		this.sortPopuli;
	}
	Indi getBest()
	{
		return populi[0];
	}
	void print()
	{
		foreach(int i, Indi p;populi)
			writeln(i,"\t",p.fit,"\t",p.print);
		writeln(avrF);
	}
	this()
	{

	}
	this(int n)
	{
		generate(n);
	}
}