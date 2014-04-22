module Gen.Parameters;

import std.stdio;
import std.conv;
import std.algorithm;

struct Parameters
{
	string filename;
	int depth;
	int size;
	int gens;
	double targetFit;
	double mutationRate;
	double elitesRate;
}

// Returns "halp!" in filename if -h was passed;
static Parameters parseArgs(string[] args)
{
	Parameters res;

//	HELP
	if(canFind(args,"-h"))
	{
		string text =
		"USAGE:\n"~
		"Linux:  \t simplegen [<options>]\n"~
		"Windows:\t simplegen.exe [<options>]\n"~
		"Runs symbolic regression, provided with data from .csv file.\n"~
		"Returns expression tree in Reverse Polish Notation with brackets.\n"~
		"Avaliable options:\n"~
		"===================\n"~
		"-f <name> \t csv file with data. Default = 'data.csv'\n\n"~
		"-d <depth>\t Maximum depth of expression tree.\n"~
		"          \t Must be valid int. Default = 3\n\n"~
		"-e <value>\t Target mean square error value.\n"~
		"          \t Must be valid double. Default = 0.05\n"~
		"          \t Examples: '0.05', '5e-02'\n\n"~
		"-s <value>\t Size of the population.\n"~
		"          \t Must be valid integer. Default = 10\n\n"~
		"-g <value>\t Maximum number of generations.\n"~
		"          \t Must be valid integer. Default = 1000000\n\n"~
		"-m <value>\t Mutation rate.\n"~
		"          \t Must be valid double. Default = 0.3\n\n"~
		"-l <value>\t Elites rate.\n"~
		"          \t Elites are best individs, passed without changes\n"~
		"          \t Must be valid double. Default = 0.2\n\n"~
		"Author:\n"~
		"=======\n"~
		"Oganyan Levon\n"~
		"lemarwin42@gmail.com\n\n"~
		"MIT License\n"~
		"2014";
		writeln(text);
		res.filename = "halp!";
		return res;
	}
//
	
	string[] buff = find(args, "-h");

//	MAX_DEPTH
	buff = find(args, "-d");
	if(buff.length>=2)
	{	
		res.depth = to!int(buff[1]);
	}
	else
	{
		writeln("No value for depth. Add '-d value'.\n Default d = 3");
		res.depth = 3;
	}

//	GENERATONS
	buff = find(args, "-g");
	if(buff.length>=2)
	{	
	res.gens = to!int(buff[1]);
	}	
	else
	{
		writeln("No generation number provided. Add '-g value'.\n Default value = 1000000");
		res.gens = 1000000;
	}
//	FILENAME
	buff = find(args, "-f");
	if(buff.length>=2)
	{	
		res.filename = buff[1];
	}
	else
	{
		writeln("No file name provided. Add '-f name'.\n Default file name = 'data.csv'");
		res.filename = "data.csv";
	}

//	TARGET FITTNES
	buff = find(args, "-e");
	if(buff.length>=2)
	{	
	res.targetFit = 1.0/to!double(buff[1]);
	}	
	else
	{
		writeln("No error value provided. Add '-e value'.\n Default value = 5e-02");
		res.targetFit = 1/0.05;
	}

//	POPULATION SIZE
	buff = find(args, "-s");
	if(buff.length>=2)
	{	
	res.size = to!int(buff[1]);
	}	
	else
	{
		writeln("No population size provided. Add '-s value'.\n Default value = 10");
		res.size = 10;
	}

//	MUTATION RATE
	buff = find(args, "-m");
	if(buff.length>=2)
	{	
	res.mutationRate = to!double(buff[1]);
	}	
	else
	{
		writeln("No mutation rate provided. Add '-m value'.\n Default value = 0.3");
		res.mutationRate = 0.3;
	}

//	ELITE RATE
	buff = find(args, "-l");
	if(buff.length>=2)
	{	
	res.elitesRate = to!double(buff[1]);
	}	
	else
	{
		writeln("No elites rate provided. Add '-l value'.\n Default value = 0.2");
		res.elitesRate = 0.2;
	}
//
	return res;
}
