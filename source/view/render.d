module view.render;

import std.stdio;
import std.conv;

import view;

CompiledTemple compile_temple(string __TempleString, __Filter = void,
		uint line = __LINE__, string file = __FILE__)()
{
	pragma(msg, "Compiling ",__TempleString);
	return compile_temple!(__TempleString, file ~ ":" ~ line.to!string ~ ": InlineTemplate",
			__Filter);
}

CompiledTemple compile_temple_file(string template_file, Filter = void)()
{
	pragma(msg, "Compiling ", template_file, "...");
	return compile_temple!(import(template_file), template_file, Filter);
}

CompiledTemple compile_temple(string __TempleString, string __TempleName, __Filter = void)()
{
	pragma(msg, "Compiling ",__TempleString);
	return CompiledTemple(__TempleString);
}

struct CompiledTemple
{
	private string ts;
	this(string __TempleString)
	{
		this.ts = __TempleString;
	}

	public:
	
	void display(Context ct)
	{
		auto p = strToTree(this.ts,0,this.ts.length.to!int - 1);
		writeln(p.Evaluate(ct.vars));
	}
}
