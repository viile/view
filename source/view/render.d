module view.render;

import std.stdio;
import std.conv;

import view;

CompiledTemple compile_temple_file(string template_file, Filter = void)()
{
	pragma(msg, "Compiling ", template_file, "...");
	return compile_temple!(import(template_file), template_file, Filter);
}

CompiledTemple compile_temple(string __TempleString, string __TempleName, __Filter = void)()
{
	pragma(msg, "Compiling ",__TempleString);
	const __tsf = strToFunstr(__TempleString); 
	pragma(msg, "__tsf ",__tsf);
	mixin(__tsf);
	alias temp_func = TempleFunc;
	return CompiledTemple(&temp_func);
}

struct CompiledTemple
{
	alias rend_func = string function(ViewContext) @system;
	public rend_func rf = null;
	this(rend_func rf)
	{
		this.rf = rf;
	}
	string display(ViewContext ctx)
	{
		return this.rf(ctx);
	}
}
