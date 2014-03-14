module Gen.ExprTree;

import std.string;
import std.random;
import std.mathspecial;
import std.math;
import std.stdio;
import std.conv;
import std.typecons;

import Gen.Main;

struct ED
{
	Expr node;
	int depth;
}


static Expr getRandExpr(int depth)
{
	int a;
	if(depth == 0)
		a = uniform!"[]"(0,1);
	else
	{
		if(uniform!"[]"(0.0,1.0)>0.3)
		{
			a = uniform!"[]"(0,10);
		}
	}

 	// ^ done so there will be more final nodes, than non-final nodes

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

interface Expr_Int
{
	double eval(double[] vars);
	void generate(int depth);
	string print();
	string name();
	int offsprings();
	int calcHeight();
	ED pickRand(int d);
}

abstract class Expr:Expr_Int
{	
	Expr[] params=[];
	Expr parent;
	int p_num;
	int offs;
	int mynum;
	int depth;
	int height;
	void generate(int depth)
	{
		params = [];
		offs = 0;
		for(int i=0;i<p_num;i++)
		{
			params~=getRandExpr(depth);
			offs+=params[i].offsprings;
		}
		offs++;
	}
	int recalcInnerParams(Expr par = null, int n = 0, int d = 0)
	{

		if(par is null)
			parent = this;
		else
			parent = par;

		//parent = par; //!!!

		mynum = n;
		depth = d;
		offs = 0;
		for(int i=0;i<p_num;i++)
		{
			offs+=params[i].recalcInnerParams(this, i, d+1);
		}
		offs++;
		height = calcHeight;
		return offs;
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

	ED pickRand(int d)
	{
		double t = uniform!"[]"(0.0,1.0);
		double buff = 1.0/offs;
		if(t<buff)
		{
			return ED(this,d);
		}
		foreach(p;params)
		{
			buff+=cast(double)p.offsprings/offs;
			if(t<buff)
				return p.pickRand(d+1);
		}
		return ED(this,d);
	}
	int calcHeight()
	{
		if(p_num==0)
			return 0;
		int res = params[0].height;
		foreach(p;params[1..$])
		{
			int temp = p.height;
			if(res<temp)
				res = temp;
		}
		return res+1;
	}

	Expr[] getNiceNodes(int d, int h)
	{
		Expr[] acc = [];
		if((depth<MAX_DEPTH-h)&&(height<MAX_DEPTH-d))
		{
			acc~=this;
		}
		foreach(p;params)
			acc~=p.getNiceNodes(d,h);
		if(acc.length==0)
		{
			acc~=this;
		}
		writeln("acc= ",acc.length);
		return acc;
	}
	this()
	{
		
	}
}

class Plus:Expr
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

class Leaf:Expr
{
	double value;
	string name()
	{
		return to!string(value);
	}
	double eval(double[] vars)
	{
		return value;
	}
	override void generate(int depth)
	{
		value = uniform!"[]"(0.0,10.0);
	}
	this()
	{
		p_num = 0;
		offs = 1;
		this.generate(0);
	}
	override Expr[] getNiceNodes(int d, int h)
	{
		if((depth<MAX_DEPTH-h)&&(height<MAX_DEPTH-d))
			return [this];
		else
			if(depth==0)
				return [this];
			else
				return [];
	}
}

class Var:Expr
{
	int num;
	override void generate(int depth)
	{
		num = uniform!"[)"(0,VAR_NUM);
	}
	string name()
	{
		return "X"~to!string(num);
	}
	double eval(double[] variables)
	{
		return variables[num];
	}
	override Expr[] getNiceNodes(int d, int h)
	{
		if((depth<MAX_DEPTH-h)&&(height<MAX_DEPTH-d))
			return [this];
		else
			if(depth==0)
				return [this];
			else
				return [];
	}
	this()
	{
		p_num = 0;
		offs = 1;
		this.generate(0);
	}
}

class Minus:Expr
{
	string name()
	{
		return "-";
	}
	double eval(double[] variables)
	{
		return params[0].eval(variables) - params[1].eval(variables);
	}
	this(int a)
	{
		p_num = 2;
		super(a);
	}
}

class Multiply:Expr
{
	string name()
	{
		return "*";
	}
	double eval(double[] variables)
	{
		return params[0].eval(variables)*params[1].eval(variables);
	}
	this(int a)
	{
		p_num = 2;
		super(a);
	}
}

class Divide:Expr 
{
	double eval(double[] variables)
	{
		double t = params[1].eval(variables);
		if(t==0)
			return 0;
		else
			return params[0].eval(variables)/t;
	}
	string name()
	{
		return "/";
	}
	this(int a)
	{
		p_num = 2;
		super(a);
	}
}

class Sin:Expr
{
	string name()
	{
		return "sin";
	}
	double eval(double[] variables)
	{
		return sin(params[0].eval(variables));
	}
	this(int a)
	{
		p_num = 1;
		super(a);
	}
}

class Cos:Expr
{
	string name()
	{
		return "cos";
	}
	double eval(double[] variables)
	{
		return cos(params[0].eval(variables));
	}
	this(int a)
	{
		p_num = 1;
		super(a);
	}
}

class Sqr:Expr
{
	string name()
	{
		return "sqr";
	}
	double eval(double[] variables)
	{
		double t = params[0].eval(variables);
		return t*t;
	}
	this(int a)
	{
		p_num = 1;
		super(a);
	}
}

class Sqrt:Expr
{
	string name()
	{
		return "sqrt";
	}
	double eval(double[] variables)
	{
		return sqrt(params[0].eval(variables));
	}
	this(int a)
	{
		p_num = 1;
		super(a);
	}
}

class Pow:Expr
{
	string name()
	{
		return "^";
	}
	double eval(double[] variables)
	{
		return params[0].eval(variables)^^params[1].eval(variables);
	}
	this(int a)
	{
		p_num = 2;
		super(a);
	}
}