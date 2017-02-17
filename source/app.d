import std.stdio;

import view;

void main()
{
	ViewContext c = new ViewContext();
	c.name = "viile dev";
	c.title = 123;
	c.data = [
		[
			"id" : "1",
			"name" : "viile",
			"time" : "1827341",
			"status" : "1"
		],
		[
			"id" : "2",
			"name" : "fox",
			"time" : "182739841",
			"status" : "2"
		]
	];

	auto ct = compile_temple_file!"test.html"();
	writeln(ct.toString(c));
}
