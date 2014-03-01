module Gen.Indi;

class Indi
{
	Expr f;
	double eval()
	{return f.eval;}
	int offsprings()
	{return f.offsprings;}
	double fittnes(double[][] data)
	{
		
	}
	void mutate();
	Expr pickRand();
}