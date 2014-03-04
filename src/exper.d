module Gen.Exper;

import std.string;
import std.random;
import std.mathspecial;
import std.math;
import std.stdio;
import std.conv;

static Exper getRandExpr(int depth)
{
	int a;
	if(depth == 0)
		a = 0;
	else
		a = uniform!"[]"(0,1);

	final switch(a)
	{
		case 0:
			return new Leaf();
			break;
		case 1:
			return new Plus(depth-1);
			break;
	}
}

interface Expr_Int
{
	double eval(double[] vars);
	void generate(int depth);
	string print();
	string name();
	int offsprings();
	Exper pickRand();
}

abstract class Exper:Expr_Int
{
	int p_num;
	Exper[] params=[];
	int offs;
	void generate(int depth)
	{
		for(int i=0;i<p_num;i++)
		{
			params~=getRandExpr(depth);
			offs+=params[$-1].offsprings;
		}
		offs++;
	}

	this(int depth)
	{
		this.generate(depth);
	}

	string print()
	{
		string res;
		if(p_num==0)
		{
			res = this.name;
		}
		else
		{
			res = "("~this.name;
			foreach(p;params)
			{
				res~=" "~p.print;
			}
			res~=")";
		}
		return res;
	}

	int offsprings()
	{
		return offs;
	}

	Exper pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		double buff = 1/offs;
		if(t<buff)
			return this;
		foreach(p;params)
		{
			buff+=p.offsprings;
			if(t<buff)
				return p;
		}
		writeln(buff);
		return this;
	}
}

class Plus:Exper
{
	string name()
		{return "+";}
	double eval(double[] vars)
	{
		return params[0].eval(vars)+params[1].eval(vars);
	}
	this(int a)
	{
		this.p_num = 2;
		super(a);
	}
}

class Leaf:Exper
{
	int offs = 1;
	string name()
		{return "1";}
	double eval(double[] vars)
	{
		return 1;
	}
	this()
	{
		p_num = 0;
	}
}