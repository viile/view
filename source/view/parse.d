module view.parse;

import std.stdio;
import std.conv;
import std.algorithm;
import std.variant;
import std.array;
import std.string;
import std.typetuple;

import view;

abstract class Expression
{
	public string Evaluate(ViewContext ctx);
}
class Constant : Expression
{
	public string value;
	public this(string value)
	{
		this.value = value;
	}
	override public string Evaluate(ViewContext ctx)
	{
		return " str ~= `" ~ value ~ "`;";
	}
}

class VariableReference : Expression
{
	public string value;
	public this(string value)
	{
		this.value = value;
	}
	override public string Evaluate(ViewContext ctx)
	{
		return " str ~= " ~ value ~ ";";
	}
}
class ExecuteBlock : Expression
{
	public string value;
	public this(string value)
	{
		this.value = value;
	}
	override public string Evaluate(ViewContext ctx)
	{
		return value;
	}
}
class Operation : Expression
{
	public Expression left;
	public Expression value;
	public Expression right;
	public this(Expression left,Expression value,Expression right)
	{
		this.left = left;
		this.value = value;
		this.right = right;
	}
	override public string Evaluate(ViewContext ctx)
	{  
		auto x = left.Evaluate(ctx);  
		auto y = right.Evaluate(ctx);  
		return x ~ value.Evaluate(ctx) ~ y;  
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
	if(str[ves .. ves+2] == "{%")
	return new Operation(strToTree(str,s,ves),new ExecuteBlock(str[ves+2 .. vet-2]),strToTree(str,vet,t));
	else 
	return new Operation(strToTree(str,s,ves),new VariableReference(str[ves+2 .. vet-2]),strToTree(str,vet,t));
}

string strToFunstr(string str)
{
	auto s = strToTree(str,0,str.length.to!int - 1);
	ViewContext ctx;
	string ret = `
		static string TempleFunc(ViewContext var)
		{
			string str;
			with(var){

	`;
	ret ~= s.Evaluate(ctx);
	ret ~= `}
			return str;
		}`;
	return ret;
}
