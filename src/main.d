module Gen.Main;

import std.stdio;
import std.string;
import std.functional;
import std.math;
import std.typecons;

import Gen.CsvParse;
import Gen.Indi;
import Gen.ExprTree;
import Gen.Population;

int VAR_NUM;
int MAX_DEPTH=5;

int main()
{
	double[][] data = getData("testdata.csv");
	VAR_NUM = data[0].length - 1;
	writeln("VAR_NUM= ", VAR_NUM);
	Indi indiana = new Indi(MAX_DEPTH);
	Indi jones = new Indi(MAX_DEPTH);

/*
	writeln("========================================================");
	writeln(jones.f.print);
	writeln("offsprings = ", jones.f.offsprings);
	writeln("--------------------------------------------------------");
	writeln("mutation:");
	jones.mutate();
	writeln(jones.print);
	writeln("offsprings = ", jones.offsprings);
	writeln("========================================================");
	writeln("fittness = ", jones.fittness(data));
	writeln("========================================================");
*/ 
	
	Population pops = new Population(10);
	pops.generate(10);//

	pops.calculate(data);
	pops.sortPopuli;
	pops.print;
	writeln("+++++++++++++++++++++++++++++++++++++++=============");
	for(long i=0;i<100;i++)
	{
		if(i%1000==0)
			writeln(i,"\t", pops.avrF);
		pops.reproduce(0.2,1);
		pops.calculate(data);
	}
	pops.print;
/*	NiceNodes test
	Expr w = jones.pickRand.node;
	writeln(jones.print);
	writeln(w.print);
	writeln(w.depth, "\t", w.height);

	int d = 1, h = 2;
	Expr[] nicenode = jones.f.getNiceNodes(d,h);
	writeln("Depth = ",jones.depth,"\tMax depth = ", MAX_DEPTH);
	writeln("(d0,h0) = (",d,",",h,")");
	writeln("(m-h0,m-d0) = ","(",MAX_DEPTH-h,",",MAX_DEPTH-d,")" );
	foreach(nn;nicenode)
	{
		writeln("(",nn.depth,",",nn.height,")");
	}
*/

/*	Uniform over graph testing
	int[Expr] test;
	int[Expr] expDepth;
	for(int i=0;i<1000000;i++)
	{
		ED td = jones.pickRand;
		Expr t = td.node;
		if(t in test)
		{
			test[t]+=1;
		}
		else
		{
			test[t]=1;
			expDepth[t] =  td.depth;
		}
	}
	for(int i=0;i<1000;i++)
	{
		Expr t = jones.pickRand.node;
		if(test[t]!=-1)
		{
			writeln(test[t],"\t", expDepth[t], "\t", t.print);
			test[t]=-1;
		}
	}
*/
	return 0;
}