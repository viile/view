module view.parse;

import std.stdio;
import std.conv;
import std.algorithm;
import std.variant;
import std.array;
import std.string;
import std.typetuple;

abstract class Expression
{
	public Variant[string] vars;
	public string Evaluate(Variant[string] vars);
}
class Constant : Expression
{
	public string value;
	public this(string value)
	{
		this.value = value;
	}
	override public string Evaluate(Variant[string] vars)
	{
		return value;
	}
}
class VariableReference : Expression
{
	public string name;
	public this(string name)
	{
		this.name = name;
	}
	override public string Evaluate(Variant[string] vars)
	{
		//return vars[name].to!string;
		return this.name;
	}
}
class ExecuteBlock : Expression
{
	public string name;
	public this(string name)
	{
		this.name = name;
	}
	override public string Evaluate(Variant[string] vars)
	{
		//return vars[name].to!string;
		return name;
	}
}
class Operation : Expression
{
	public Expression left;
	public string label;
	public Expression right;
	public this(Expression left,string label,Expression right)
	{
		this.left = left;
		this.label = label;
		this.right = right;
	}
	override public string Evaluate(Variant[string] vars)  
	{  
		auto x = left.Evaluate(vars);  
		auto y = right.Evaluate(vars);  
		return x ~ this.label ~ y;  
	}  
}
Expression strToTree(string str,int s,int t)
{
	//writeln("s : ",s," t : ",t);
	if(s > t)return new Constant(null);
	
	bool findVar = false;
	bool findExe = false;
	int ves,vet;
	for(int i = s;i<t;i++)
	{
		if(canFind(["{{","{%"],str[i..i+2]))
		{
			ves = i;
			if(str[i+1] == '{') findVar = true;
			else findExe = true;
			for(int k = i;k<t;k++)
			{
				if(canFind(["}}","%}"],str[k..k+2]))
				{
					vet = k+2;
					break;
				}
			}
			break;
		}
	}
	//writeln("ves: ",ves," vet:",vet," findExe: ",findExe," findVar:",findVar);
	//writeln(ves?str[ves .. vet]:str[s..t]);
	if(ves==0 && !findVar && !findExe)return new Constant(str[s..t]);
	if(findVar && ves==s)return new VariableReference(str[ves+2 .. vet-2]);
	if(findExe && ves==s)return new ExecuteBlock(str[ves+2 .. vet-2]);
	return new Operation(strToTree(str,s,ves),str[ves+2 .. vet-2],strToTree(str,vet,t));
}

package string strToFunstr(string str)
{
	auto s = strToTree(str,0,str.length.to!int - 1);
	Variant[string] vars;
	string ret = `void TempleFunc(){`;
	ret ~= "string _s = `" ~ s.Evaluate(vars) ~ "`;";
	ret ~= `}`;
	return ret;
}
