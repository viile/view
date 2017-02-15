import std.stdio;

import view.context;
import view.render;
import view.parse;

void main()
{
	Context c = new Context();
	c.name = "viile dev";
	c.title = "index";
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
	ct.display(c);
}
