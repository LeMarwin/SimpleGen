module Gen.Indi;

import std.stdio;
import Gen.ExpTree;

class Indi
{
	Expr f;
	double eval()
	{return f.eval;}
	int offsprings()
	{return f.offsprings;}
	double[] variables;
	double[] getVariables()
	{return variables;}
	double fittness(double[][] data)
	{
		double[][] buff = data.dup;
		double ans = 0;
		double mse = 0;
		for(int i=0;i<data.length;i++)
		{
			variables = buff[i][0..$-1];
			ans = buff[i][$-1];
			double delta = f.eval-ans;
			mse+=delta*delta;
			writeln(variables,"\t",f.eval);
		}
		return mse/data.length;
	}
	this(Expr _f)
	{
		f = _f;
	}
	void mutate(){};
	Expr pickRand(){return getRandExpr(0);}
}