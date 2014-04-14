module Gen.Indi;

import std.stdio;
import Gen.ExprTree;
import Gen.Main;


class Indi
{
	Expr f;
	double[] variables;
	int depth;
	double fit;
	double mse;
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
	double meanSquareError(double[][] data)
	{
		double[][] buff = data.dup;
		double ans = 0;
		mse = 0;
		for(int i=0;i<data.length;i++)
		{
			variables = buff[i][0..$-1];
			ans = buff[i][$-1];
			double delta = f.eval(variables)-ans;
			mse+=delta*delta;
		}
		mse = mse/data.length;
		return mse;
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
		Expr temp = f.pickRand();
		temp.generate(MAX_DEPTH-temp.depth);
		f.recalcInnerParams();
	}
	Expr pickRand()
	{
		return f.pickRand();
	}
	string print()
	{
		return f.print;	
	}
	int height()
	{
		return f.height;
	}
	Indi dup()
	{
		Indi res = new Indi(f.dup);
		res.fit = fit;
		res.mse = mse;
		res.depth = depth;

		return(res);
	}
}