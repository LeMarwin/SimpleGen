module Gen.ExpTree;

import std.string;
import std.random;
import std.mathspecial;
import std.math;
import std.stdio;
import std.conv;
import Gen.Main;

interface Expr
{
	double eval();
	void generate(int depth);
	string print();
}

static Expr getRandType(int depth)
{
	writeln(depth);
	int a;
	if(depth>=1)
		a = uniform!"[]"(0,5);
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
	}
}

class Plus:Expr
{
	static string name = "+";
	Expr[] params;
	double eval()
	{
		double s = 0;
		foreach(p;params)
		{
			s+=p.eval;
		}
		return s;
	}
	void generate(int depth)
	{
		params = [getRandType(depth), getRandType(depth)];
	}
	this(int depth)
	{
		this.generate(depth);
	}
	string print()
	{
		return "(" ~ name ~ " " ~ params[0].print ~ " " ~ params[1].print ~ ")";
	}
}

class Minus:Expr
{
	static string name = "-";
	Expr[] params;
	double eval()
	{
		return params[0].eval - params[1].eval;
	}
	void generate(int depth)
	{
		params = [getRandType(depth), getRandType(depth)];
	}
	this(int depth)
	{
		this.generate(depth);
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ params[0].print ~ " " ~ params[1].print ~ ")";
	}
}

class Multiply:Expr
{
	static string name = "*";
	Expr[] params;
	double eval()
	{
		double s = 1;
		foreach(p;params)
		{
			s*=p.eval;
		}
		return s;
	}
	void generate(int depth)
	{
		params = [getRandType(depth), getRandType(depth)];
	}
	this(int depth)
	{
		this.generate(depth);
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ params[0].print ~ " " ~ params[1].print ~ ")";
	}
}

class Divide:Expr
{
	static string name = "/";
	Expr[] params;
	double eval()
	{
		if(params[1].eval==0)
			return 0;
		else return params[0].eval/params[1].eval;
	}
	void generate(int depth)
	{
		params = [getRandType(depth), getRandType(depth)];
	}
	this(int depth)
	{
		this.generate(depth);
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ params[0].print ~ " " ~ params[1].print ~ ")";
	}
}

class Leaf:Expr
{
	double value;
	string name;
	double eval()
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
}

class Var : Expr
{
	int num;
	double[] variables;
	string name;
	void generate(int depth)
	{
		variables = getVariables();
		num = uniform!"[)"(0,variables.length);
		name = "X"~to!string(num);
	}
	double eval()
	{
		return variables[num];
	}
	this()
	{
		this.generate(0);
	}
	string print()
	{
		return name;
	}
}

class Sin:Expr
{
	static string name = "sin";
	Expr param;
	void generate(int depth)
	{
		param = getRandType(depth);
	}
	this(int depth)
	{
		this.generate(depth);
	}
	double eval()
	{
		return sin(param.eval);
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ param.print ~ ")";
	}
}

class Cos:Expr
{
	static string name = "cos";
	Expr param;
	void generate(int depth)
	{
		param = getRandType(depth);
	}
	this(int depth)
	{
		this.generate(depth);
	}
	double eval()
	{
		return cos(param.eval);
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ param.print ~ ")";
	}
}

class Sqr:Expr
{
	static string name = "sqr";
	Expr param;
	void generate(int depth)
	{
		param = getRandType(depth);
	}
	this(int depth)
	{
		this.generate(depth);
	}
	double eval()
	{
		double t = param.eval;
		return t*t;
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ param.print ~ ")";
	}
}

class Sqrt:Expr
{
	static string name = "sqrt";
	Expr param;
	void generate(int depth)
	{
		param = getRandType(depth);
	}
	this(int depth)
	{
		this.generate(depth);
	}
	double eval()
	{
		return sqrt(param.eval);
	}
	string print()
	{
		return "(" ~ name ~ " "  ~ param.print ~ ")";
	}
}