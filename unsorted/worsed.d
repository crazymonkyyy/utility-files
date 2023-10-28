public import core.stdc.stdio;

extern(C) void main(){//magic run unittests
	static foreach(u; __traits(getUnitTests, __traits(parent, main)))
		u();
}
unittest{
	printf("hello world");
}
