module Gen.Main;

import std.stdio;
import std.string;
import std.functional;
import std.math;

import Gen.ExpTree;
import Gen.CsvParse;

double[] globalVars;

static double[] getVariables()
{
	return globalVars;
}

double fittness(double[][] data, Expr func)
{
	int m = data.length;
	int n = data[0].length;
	double mse=0;
	double ans=0;
	for(int i=0;i<m;i++)
	{
		globalVars = data[i][0..$-1];
		ans = data[i][$-1];
		double delta = func.eval-ans;
		mse+=delta*delta;
		writeln(getVariables(),"\t",func.eval);
	}
	mse=mse/m;
	return mse;
}

int main()
{
	double[][] data = getData("testdata.csv");
	globalVars = data[0][0..$-1];
	Expr c = getRandExpr(4);
	writeln(c.print);
	writeln(c.offsprings);
	writeln(fittness(data, c));
	return 0;
}