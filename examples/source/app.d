import std.stdio;

import view;

void main()
{
	ViewContext c = new ViewContext();
	c.name = "viile dev";
	c.title = 123;
	c.num = "123";
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

	auto layout = display!"test.html"();
	auto s = display!"user.html"();
	auto ct = layout.layout(&s);
	writeln(ct.toString(c));

}
