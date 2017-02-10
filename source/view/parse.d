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
		return vars[name].to!string;
	}
}
class Operation : Expression
{
	public Expression left;
	public string op;
	public Expression right;
	public this(Expression left,string op,Expression right)
	{
		this.left = left;
		this.op = op;
		this.right = right;
	}
	override public float Evaluate(Variant[string] vars)  
	{  
		auto x = left.Evaluate(vars);  
		auto y = right.Evaluate(vars);  
		return x ~ y;  
	}  
}
Expression strToTree(string str,int s,int t)
{
	while (s <= t && str[s] == '(' && str[t] == ')')
	{
		s++; 
		t--;
	}
	if(s > t) return new Constant(0);
	bool findLetter = false;
	bool findChar = false;  
	int brackets = 0;  
	int lastPS = -1;
	int lastMD = -1; 
	for (int i = s;i<=t;i++)
	{
		if (str[i] != '.' && (str[i]<'0' || str[i]>'9'))  
		{  
			if ((str[i] >= 'a' &&str[i] <= 'z') || (str[i] >= 'A'&&str[i] <= 'Z'))  
				findLetter = true;  
			else  
			{  
				findChar = true;  
				final switch (str[i])  
				{  
					case '(':brackets++; break;  
					case ')':brackets--; break;  
					case '+':  
					case '-':if (!brackets)lastPS = i; break;  
					case '*':  
					case '/':if (!brackets)lastMD = i; break;  
				}  
			}  
		} 
	}
	auto ops = ["+","-","*","/"];
	int ts = s;
	while(ts <= t)
	{
		if(canFind(ops,str[ts].to!string))break;
		ts++;
	}
	if (findLetter == false && findChar == false)  
		return new Constant(str[s .. ts ].to!float);  
	if (findChar == false)
		return new VariableReference(str[s.. ts]);  
	if (lastPS == -1)  
		lastPS = lastMD;  
	return new Operation(strToTree(str, s, lastPS - 1 ), str[lastPS], strToTree(str, lastPS + 1,t));
}
