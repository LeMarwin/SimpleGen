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
int MAX_DEPTH=10;

int main()
{
	double[][] data = getData("testdata.csv");
	VAR_NUM = data[0].length - 1;
	Indi indiana = new Indi(MAX_DEPTH);
	Indi jones = new Indi(MAX_DEPTH);

	Expr a = getRandExpr(MAX_DEPTH);
	a.recalcInnerParams();
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
	//writeln(a.print);
	
	writeln("========================================================");
	writeln(indiana.print);
	writeln("--------------------------------------------------------");
	writeln(jones.print);
	writeln("========================================================");


	Expr q = indiana.pickRand.node;
	Expr w = jones.pickRand.node;
	Indi buff = indiana;
	indiana = jones;
	jones = buff;
	writeln(indiana.print);
	writeln("--------------------------------------------------------");
	writeln(jones.print);
	writeln("========================================================");
/*
	Indi[] nexgen = crossover([indiana,jones]);
	nexgen[0].f.recalcInnerParams();
	nexgen[1].f.recalcInnerParams();
	writeln("--------------------------------------------------------");

	writeln(nexgen[0].print,"\t",nexgen[0].f.height);
	writeln(nexgen[1].print,"\t",nexgen[0].f.height);

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