module Gen.ExprTree;

import std.string;
import std.random;
import std.mathspecial;
import std.math;
import std.stdio;
import std.conv;
import std.typecons;

import Gen.Main;

static Expr getRandExpr(int depth, int _pl=0)
{
	int a;
	if(depth == 1)
		a = uniform!"[]"(0,1);
	else
	{
		if(uniform!"[]"(0.0,1.0)>0.05)
		{
			a = uniform!"[]"(1,9);
		}
	}

	final switch(a)
	{
		case 0:
			return new Leaf(_pl);
		case 1:
			return new Var(_pl);
		case 2:
			return new Plus(depth-1,_pl);
		case 3:
			return new Minus(depth-1,_pl);
		case 4:
			return new Multiply(depth-1,_pl);
		case 5:
			return new Divide(depth-1,_pl);
		case 6:
			return new Sin(depth-1,_pl);
		case 7:
			return new Cos(depth-1,_pl);
		case 8:
			return new Pow(depth-1,_pl);
		case 9:
			return new Sqrt(depth-1,_pl);
	}
}

interface Expr_Int
{
	double eval(double[] vars);
	void generate(int depth, int _pl=0);
	string print();
	string name();
	int offsprings();
	int calcHeight();
	Expr pickRand();
	Expr dup();
}

abstract class Expr:Expr_Int
{	
	Expr[] params=[];
	Expr parent;
	int p_num;
	int offs;
	int depth;
	int height;
	int place;
	void generate(int depth, int _pl=0)
	{
		place = _pl;
		params = [];
		offs = 0;
		for(int i=0;i<p_num;i++)
		{
			params~=getRandExpr(depth,i);
			offs+=params[i].offsprings;
		}
		offs++;
	}
	int recalcInnerParams(Expr par = null, int n = 0, int d = 1)
	{
		if(par is null)
			parent = this;
		else
			parent = par;
		depth = d;
		offs = 0;
		place = n;
		for(int i=0;i<p_num;i++)
		{
			offs+=params[i].recalcInnerParams(this, i, d+1);
		}
		offs++;
		height = calcHeight;
		return offs;
	}
	this(int depth, int _pl)
	{
		this.generate(depth, _pl);
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

	Expr pickRand()
	{
		double t = uniform!"[]"(0.0,1.0);
		double buff = 1.0/offs;
		if(t<buff)
		{
			return this;
		}
		foreach(p;params)
		{
			buff+=cast(double)p.offsprings/offs;
			if(t<buff)
				return p.pickRand();
		}
		return this;
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
		if((depth<=MAX_DEPTH-h)&&(height<=MAX_DEPTH-d))
		{
			acc~=this;
		}
		foreach(p;params)
			acc~=p.getNiceNodes(d,h);
		return acc;
	}
	this()
	{
		
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
	override void generate(int depth, int _pl)
	{
		place = _pl;
		value = uniform!"[]"(0.0,10.0);
	}
	Expr dup()
	{
		Leaf res = new Leaf(place);
		res.value = value; 
		return res;
	}
	this(int _pl)
	{
		p_num = 0;
		offs = 1;
		this.generate(0, _pl);
	}
	override Expr[] getNiceNodes(int d, int h)
	{
		if((depth<=MAX_DEPTH-h)&&(height<=MAX_DEPTH-d))
			return [this];
		return [];
	}
}

class Var:Expr
{
	int num;
	override void generate(int depth, int _pl)
	{
		place = _pl;
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
	Expr dup()
	{
		Var res = new Var(place);
		res.num = num;
		return res;
	}
	override Expr[] getNiceNodes(int d, int h)
	{
		if((depth<=MAX_DEPTH-h)&&(height<=MAX_DEPTH-d))
			return [this];
		return [];
	}
	this(int _pl)
	{
		p_num = 0;
		offs = 1;
		this.generate(0,_pl);
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
	Expr dup()
	{
		Plus res = new Plus();
		res.params = [];
		res.p_num = 2;
		foreach(p;this.params)
			res.params~=p.dup;
		return res;
	}
	this(int a, int _pl)
	{
		this.p_num = 2;
		super(a,_pl);
	}
	this(){}
}

class Minus:Expr
{
	string name()
	{
		return "-";
	}
	Expr dup()
	{
		Minus res = new Minus();
		res.p_num = 2;
		res.params = [params[0].dup,params[1].dup];
		return res;
	}
	double eval(double[] variables)
	{
		return params[0].eval(variables) - params[1].eval(variables);
	}
	this(int a, int _pl)
	{
		p_num = 2;
		super(a,_pl);
	}
	this(){}
}

class Multiply:Expr
{
	string name()
	{
		return "*";
	}
	Expr dup()
	{
		Multiply res = new Multiply();
		res.p_num = 2;
		res.params = [params[0].dup,params[1].dup];
		return res;
	}
	double eval(double[] variables)
	{
		return params[0].eval(variables)*params[1].eval(variables);
	}
	this(int a, int _pl)
	{
		p_num = 2;
		super(a,_pl);
	}
	this(){}
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
	Expr dup()
	{
		Divide res = new Divide();
		res.p_num = 2;
		res.params = [params[0].dup,params[1].dup];
		return res;
	}
	string name()
	{
		return "/";
	}
	this(int a,int _pl)
	{
		p_num = 2;
		super(a,_pl);
	}
	this(){}
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
	Expr dup()
	{
		Sin res = new Sin();
		res.p_num = 1;
		res.params = [params[0].dup];
		return res;
	}
	this(int a,int _pl)
	{
		p_num = 1;
		super(a,_pl);
	}
	this(){}
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
	Expr dup()
	{
		Cos res = new Cos();
		res.p_num = 1;
		res.params = [params[0].dup];
		return res;
	}
	this(int a, int _pl)
	{
		p_num = 1;
		super(a,_pl);
	}
	this(){}
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
	Expr dup()
	{
		Sqr res = new Sqr();
		res.p_num = 1;
		res.params = [params[0].dup];
		return res;
	}
	this(int a, int _pl)
	{
		p_num = 1;
		super(a,_pl);
	}
	this(){}
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
	Expr dup()
	{
		Sqrt res = new Sqrt();
		res.p_num = 1;
		res.params = [params[0].dup];
		return res;
	}
	this(int a, int _pl)
	{
		p_num = 1;
		super(a, _pl);
	}
	this(){}
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
	Expr dup()
	{
		Pow res = new Pow();
		res.p_num = 2;
		res.params = [params[0].dup, params[1].dup];
		return res;
	}
	this(int a, int _pl)
	{
		p_num = 2;
		super(a, _pl);
	}
	this(){}
}