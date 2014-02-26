module Gen.CsvParse;

import std.csv;
import std.stdio;
import std.file;
import std.string;
import std.conv;

double[][] getData(string fname)
{
	double[][] res;
	int i=0;
	foreach(line; csvReader!double(readText(fname)))
	{
		res~=[[]];
		foreach(val; line)
			res[i]~=val;
		i++;
	}
	return res;
}

unittest
{
    string str = "1,2,3,4\n5,6\n7,8,9,0";
    double[][] tst = [[1,2,3,4],[5,6],[7,8,9,0]];
    auto records = csvReader!double(str);
    int i,j;
    bool flag=true;
    foreach(record;records)
    {	
    	foreach(val;record)
    	{
    		flag = flag&&(val==tst[i][j]);
    		j++;
    	}
    	i++;
    }
    assert(!flag);
}