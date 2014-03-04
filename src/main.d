module Gen.Main;

import std.stdio;
import std.string;
import std.functional;
import std.math;

//import Gen.ExpTree;
import Gen.CsvParse;
import Gen.Indi;
import Gen.Exper;

double[] globalVars;

static double[] getVariables()
{
	return globalVars;
}

int main()
{
	Exper a = new Plus(1);
	writeln(a.print);
	writeln(a.eval(globalVars));
	/*
	double[][] data = getData("testdata.csv");
	globalVars = data[0][0..$-1];
	Expr c = getRandExpr(2);
	writeln(c.print);
	writeln(c.offsprings);
	Indi jones = new Indi(c);
	writeln(jones.fittness(data));
	writeln(jones.pickRand().print);
	*/

	return 0;
}