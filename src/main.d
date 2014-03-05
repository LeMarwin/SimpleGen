module Gen.Main;

import std.stdio;
import std.string;
import std.functional;
import std.math;
import std.typecons;

import Gen.CsvParse;
import Gen.Indi;
import Gen.ExprTree;

int VAR_NUM;
int MAX_DEPTH=5;

int main()
{
	double[][] data = getData("testdata.csv");
	VAR_NUM = data[0].length - 1;
	Expr a = new Plus(MAX_DEPTH);
	Indi jones = new Indi(a);

	writeln("========================================================");
	writeln(a.print);
	writeln("offsprings = ", a.offsprings);
	writeln("--------------------------------------------------------");
	writeln("mutation:");
	jones.mutate();
	writeln(jones.print);
	writeln(jones.offsprings);
	writeln("========================================================");
	writeln("\nfittness = ", jones.fittness(data));

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