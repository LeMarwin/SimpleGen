module Gen.Main;

import std.stdio;
import std.string;
import std.functional;
import std.math;
import std.typecons;
import std.array;
import std.algorithm;
import std.conv;

import Gen.CsvParse;
import Gen.Indi;
import Gen.ExprTree;
import Gen.Population;
import Gen.Parameters;

int VAR_NUM;
int MAX_DEPTH=3;


int main(string[] args)
{
	const Parameters p = parseArgs(args);
	if(p.filename == "halp!")
		return 0;
	MAX_DEPTH = p.depth;



	double[][] data = getData(p.filename);
	VAR_NUM = cast(int)data[0].length - 1;
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

	Population pops = new Population(p.size);
	auto w = readln();
	double bestfit=0;
	Indi bestie;
	for(long i=0;i<1000000;i++)
	{
		pops.calculate(data);
		if(pops.avrF>bestfit)
		{
			bestfit = pops.avrF;
			bestie = pops.getBest().dup;
		}
		if(i%1000==0)
		{
			writeln(i,"-th generation");
			pops.print;
			if(pops.getBest().fit>p.targetFit)
				break;
		}
		pops.reproduce(p.elitesRate,p.mutationRate);
	}
	pops.calculate(data);
	pops.print;
	
	writeln(bestie.fit);
	writeln(bestie.print);
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