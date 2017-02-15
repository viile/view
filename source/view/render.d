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
	const __tsf = strToFunstr(__TempleString); 
	pragma(msg, "__tsf ",__tsf);
	mixin(__tsf);
	return CompiledTemple();
}

struct CompiledTemple
{
	private string ts;

	public:
	string display()
	{
		return ts;
	}
}
