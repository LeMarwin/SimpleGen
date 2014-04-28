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

Indi[] crossingover(ref Indi p1, ref Indi p2)
{
	Expr f1 = p1.f.dup;
	Expr f2 = p2.f.dup;
	Expr r1,r2;
	f1.recalcInnerParams();
	f2.recalcInnerParams();
	Expr q = f1.pickRand();
	Expr[] niceNodes = f2.getNiceNodes(q.depth, q.height);
	if(niceNodes.length==0)
	{
		assert(false, "niceNodes==0");
	}
	int n = uniform!"[)"(0,cast(int)niceNodes.length);
	Expr w = niceNodes[n];
	if(f1==q&&f2==w)
	{
		return [new Indi(f2), new Indi(f1)];
	}
	if(f1==q)
	{
		f1 = w;
		w.parent.params[w.place] = q;
		return [new Indi(f1), new Indi(f2)];
	}
	if(f2==w)
	{
		f2 = q;
		q.parent.params[q.place] = w;
		return [new Indi(f1), new Indi(f2)];
	}
	Expr buff = q;
	q.parent.params[q.place]=w;
	w.parent.params[w.place]=buff;
	return [new Indi(f1), new Indi(f2)];
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
		int n = cast(int)populi.length;
		int m = cast(int)(eliteRate*n);
		int mut = cast(int)(mutaRate*n);
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
			buff = crossingover(p1,p2);
			nextGen[i] = buff[0];
			if((i+1)<n)
				nextGen[i+1] = buff[1];
			i+=2;
		}
		destroy(populi);
		populi = nextGen;
		n = cast(int)populi.length;
		assert(n!=0);
		for(int j=0;j<mut;j++)
			populi[uniform!"[)"(m,n)].mutate();
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