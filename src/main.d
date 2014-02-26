module Gen.Main;

import std.stdio;
import std.string;
import std.functional;

import Gen.ExpTree;
import Gen.CsvParse;

double[] globalVars;

static double[] getVariables()
{
	return globalVars;
}

int main()
{
	globalVars = [2,3];
	Expr c = getRandExpr(3);
	writeln(c.eval());
	writeln(c.print);
	foreach(line;getData("testdata.csv"))
		writeln(line);
	return 0;
}