module Gen.Indi;

import std.stdio;
import Gen.ExpTree;


class Indi
{
	Expr f;
	int depth;

	double eval(double[] vars)
	{return f.eval(vars);}
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
			double delta = f.eval(variables)-ans;
			mse+=delta*delta;
		}
		return mse/data.length;
	}
	this(Expr _f)
	{
		f = _f;
	}
	this(int _d)
	{
		depth = _d;
		f = getRandExpr(depth);
	}
	void mutate(){
	};
	Expr pickRand(){return f.pickRand();}
}