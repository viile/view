import std.stdio;

import view.context;
import view.render;
void main()
{
	Context c = new Context();
	c.test = "asdf";
	c.a = 123;
	writeln(c.a,c.test);

	auto ct = compile_temple_file!"test.html"();
	writeln(ct);

	writeln("Edit source/app.d to start your project.");
}
