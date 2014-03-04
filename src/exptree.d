module Gen.ExpTree;

import std.string;
import std.random;
import std.mathspecial;
import std.math;
import std.stdio;
import std.conv;

import Gen.Indi;
import Gen.Main;

interface Expr
{
	double eval(double[] vars);
	void generate(int depth);
	string print();
	int offsprings();
	Expr pickRand();
}

static Expr getRandExpr(int depth)
{
	int a;
	if(depth>=1)
		a = uniform!"[]"(0,10);
	else
		a = uniform!"[]"(0,1);

	final switch(a)
	{
		case 0:
			return new Leaf();
			break;
		case 1:
			return new Var();
			break;
		case 2:
			return new Plus(depth-1);
			break;
		case 3:
			return new Minus(depth-1);
			break;
		case 4:
			return new Multiply(depth-1);
			break;
		case 5:
			return new Divide(depth-1);
			break;
		case 6:
			return new Sin(depth-1);
			break;
		case 7:
			return new Cos(depth-1);
			break;
		case 8:
			return new Sqr(depth-1);
			break;
		case 9:
			return new Sqrt(depth-1);
			break;
		case 10:
			return new Pow(depth-1);
			break;
	}
}

class Plus:Expr
{
	static string name = "+";
	Expr[] params;
	int offs;
	double eval(double[] vars)
	{
		double s = 0;
		foreach(p;params)
		{
			s+=p.eval(vars);
		}
		return s;
	}
	void generate(int depth)
	{
		params = [getRandExpr(depth), getRandExpr(depth)];
		offs = 1 + params[0].offsprings + params[1].offsprings;
	}
	this(int depth)
	{
		this.generate(depth);
	}
	string print()
	{
		return "(" ~ name ~ " " ~ params[0].print ~ " " ~ params[1].print ~ ")";
	}
	int offsprings()
		{return offs;}
	Expr pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		int a = 0, b = 1;
		if(params[0].offsprings>params[1].offsprings)
		{
			a = 1;
			b = 0;			
		}
		if(t<1.0/offs)
		{
			return this;
		}
		else if(t<cast(double)(params[a].offsprings+1)/offsprings)
		{
			return params[a].pickRand;
		}
		else
		{
			return params[b].pickRand;
		}
	}
}

class Minus:Expr
{
	static string name = "-";
	Expr[] params;
	int offs;
	double eval(double[] vars)
	{
		return params[0].eval(vars) - params[1].eval(vars);
	}
	void generate(int depth)
	{
		params = [getRandExpr(depth), getRandExpr(depth)];
		offs = 1 + params[0].offsprings + params[1].offsprings;
	}
	this(int depth)
	{
		this.generate(depth);
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ params[0].print ~ " " ~ params[1].print ~ ")";
	}
	int offsprings()
		{return offs;}	
	Expr pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		int a = 0, b = 1;
		if(params[0].offsprings>params[1].offsprings)
		{
			a = 1;
			b = 0;			
		}
		if(t<1.0/offs)
		{
			return this;
		}
		else if(t<cast(double)(params[a].offsprings+1)/offsprings)
		{
			return params[a].pickRand;
		}
		else
		{
			return params[b].pickRand;
		}
	}
}

class Multiply:Expr
{
	static string name = "*";
	Expr[] params;
	int offs;
	double eval(double[] vars)
	{
		double s = 1;
		foreach(p;params)
		{
			s*=p.eval(vars);
		}
		return s;
	}
	void generate(int depth)
	{
		params = [getRandExpr(depth), getRandExpr(depth)];
		offs = 1 + params[0].offsprings + params[1].offsprings;
	}
	this(int depth)
	{
		this.generate(depth);
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ params[0].print ~ " " ~ params[1].print ~ ")";
	}
	int offsprings()
		{return offs;}
	Expr pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		int a = 0, b = 1;
		if(params[0].offsprings>params[1].offsprings)
		{
			a = 1;
			b = 0;			
		}
		if(t<1.0/offs)
		{
			return this;
		}
		else if(t<cast(double)(params[a].offsprings+1)/offsprings)
		{
			return params[a].pickRand;
		}
		else
		{
			return params[b].pickRand;
		}
	}
}

class Divide:Expr
{
	static string name = "/";
	Expr[] params;
	int offs;
	double eval(double[] vars)
	{
		double t = params[1].eval(vars);
		if(t==0)
			return 0;
		else return params[0].eval(vars)/t;
	}
	void generate(int depth)
	{
		params = [getRandExpr(depth), getRandExpr(depth)];
		offs = 1 + params[0].offsprings + params[1].offsprings;
	}
	this(int depth)
	{
		this.generate(depth);
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ params[0].print ~ " " ~ params[1].print ~ ")";
	}
	int offsprings()
		{return offs;}
	Expr pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		int a = 0, b = 1;
		if(params[0].offsprings>params[1].offsprings)
		{
			a = 1;
			b = 0;			
		}
		if(t<1.0/offs)
		{
			return this;
		}
		else if(t<cast(double)(params[a].offsprings+1)/offsprings)
		{
			return params[a].pickRand;
		}
		else
		{
			return params[b].pickRand;
		}
	}
}

class Leaf:Expr
{
	double value;
	string name;
	double eval(double[] vars)
	{
		return value;
	}
	void generate(int depth)
	{
		value = uniform!"[]"(0.0,10.0);
		name = to!string(value);
	}
	this()
	{
		this.generate(0);
	}
	this(double v)
	{
		value = v;
	}
	string print()
	{
		return name;
	}
	int offsprings()
	{return 1;}
	Expr pickRand()
	{return this;}
}

class Var:Expr
{
	int num;
	string name;
	void generate(int depth)
	{
		num = uniform!"[)"(0,getVariables().length);
		name = "X"~to!string(num);
	}
	double eval(double[] vars)
	{
		return vars[num];
	}
	this()
	{
		this.generate(0);
	}
	string print()
	{
		return name;
	}
	int offsprings()
		{return 1;}
	Expr pickRand()
	{
		return this;
	}
}

class Sin:Expr
{
	static string name = "sin";
	Expr param;
	int offs;
	void generate(int depth)
	{
		param = getRandExpr(depth);
		offs = 1 + param.offsprings;
	}
	this(int depth)
	{
		this.generate(depth);
	}
	double eval(double[] vars)
	{
		return sin(param.eval(vars));
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ param.print ~ ")";
	}
	int offsprings()
		{return offs;}
	Expr pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		int a = 0, b = 1;
		if(t<1.0/offs)
			return this;
		else
			return param.pickRand;
	}
}

class Cos:Expr
{
	static string name = "cos";
	Expr param;
	int offs;
	void generate(int depth)
	{
		param = getRandExpr(depth);
		offs = 1 + param.offsprings;
	}
	this(int depth)
	{
		this.generate(depth);
	}
	double eval(double[] vars)
	{
		return cos(param.eval(vars));
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ param.print ~ ")";
	}
	int offsprings()
		{return offs;}
	Expr pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		int a = 0, b = 1;
		if(t<1.0/offs)
			return this;
		else
			return param.pickRand;
	}
}

class Sqr:Expr
{
	static string name = "sqr";
	Expr param;
	int offs;
	void generate(int depth)
	{
		param = getRandExpr(depth);
		offs = 1 + param.offsprings;
	}
	this(int depth)
	{
		this.generate(depth);
	}
	double eval(double[] vars)
	{
		double t = param.eval(vars);
		return t*t;
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ param.print ~ ")";
	}
	int offsprings()
		{return offs;}
	Expr pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		int a = 0, b = 1;
		if(t<1.0/offs)
			return this;
		else
			return param.pickRand;
	}
}

class Sqrt:Expr
{
	static string name = "sqrt";
	Expr param;
	int offs;
	void generate(int depth)
	{
		param = getRandExpr(depth);
		offs = 1 + param.offsprings;
	}
	this(int depth)
	{
		this.generate(depth);
	}
	double eval(double[] vars)
	{
		return sqrt(param.eval(vars));
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ param.print ~ ")";
	}
	int offsprings()
		{return offs;}
	Expr pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		int a = 0, b = 1;
		if(t<1.0/offs)
			return this;
		else
			return param.pickRand;
	}
}

class Pow:Expr
{
	static string name = "^";
	Expr[] params;
	int offs;
	double eval(double[] vars)
	{
		return params[0].eval(vars)^^params[1].eval(vars);
	}
	void generate(int depth)
	{
		params = [getRandExpr(depth), getRandExpr(depth)];
		offs = 1 + params[0].offsprings + params[1].offsprings;
	}
	this(int depth)
	{
		this.generate(depth);
	}
	string print()
	{
		return "(" ~ name ~ " " ~ params[0].print ~ " " ~ params[1].print ~ ")";
	}
	int offsprings()
		{return offs;}
	Expr pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		int a = 0, b = 1;
		if(params[0].offsprings>params[1].offsprings)
		{
			a = 1;
			b = 0;			
		}
		if(t<1.0/offs)
		{
			return this;
		}
		else if(t<cast(double)(params[a].offsprings+1)/offsprings)
		{
			return params[a].pickRand;
		}
		else
		{
			return params[b].pickRand;
		}
	}
}