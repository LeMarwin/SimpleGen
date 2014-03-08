module Gen.Indi;

import std.stdio;
import Gen.ExprTree;
import Gen.Main;


class Indi
{
	Expr f;
	double[] variables;
	int depth;

	double eval(double[] vars)
	{
		return f.eval(vars);
	}
	int offsprings()
	{
		return f.offsprings;
	}
	double[] getVariables()
	{
		return variables;
	}
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
		f.recalcInnerParams();
	}
	this(int _d)
	{
		f = getRandExpr(_d);
		f.recalcInnerParams();
	}
	void mutate()
	{
		ED temp = f.pickRand(0);
		temp.node.generate(MAX_DEPTH-temp.depth);
		f.recalcInnerParams();
	}
	ED pickRand()
	{
		return f.pickRand(0);
	}
	string print()
	{
		return f.print;	
	}
	int height()
	{
		return f.height;
	}
}