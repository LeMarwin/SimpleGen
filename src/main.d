module Gen.Main;

import std.stdio;
import std.string;
import std.functional;

import Gen.ExpTree;

double[] globalVars;

static double[] getVariables()
{
	return globalVars;
}

int main()
{
	globalVars = [2,3];
	typeof(new Leaf()) w = new Leaf();
	Leaf a = new Leaf(3);
	Leaf b = new Leaf();
	Leaf q = new Leaf();
	Plus c = new Plus(2);
	//c.params = [q,b];
	writeln(c.eval());
	writeln(c.print);
	return 0;
}