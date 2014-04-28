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
import Gen.Population;
import Gen.Parameters;

int VAR_NUM;
int MAX_DEPTH;


int main(string[] args)
{
	const Parameters p = parseArgs(args);
	if(p.filename == "halp!")
		return 0;
	MAX_DEPTH = p.depth;

	double[][] data = getData(p.filename);
	VAR_NUM = cast(int)data[0].length - 1;

	Population pops = new Population(p.size);
	writeln("Press any key to continue");
	auto w = readln();
	double bestfit=0;
	Indi bestie;

	for(long i=0;i<p.gens;i++)
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
	return 0;
}