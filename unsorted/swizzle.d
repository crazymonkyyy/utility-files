import std;

auto swizzle(T,I,size_t N)(ref T array,I[N] indexs...){
    enum args=iota(N).map!(a=>"array[indexs["~a.to!string~"]],").join;
    mixin("return tuple("~args~");");
}

unittest{
    int[] i=[1,2,3,4,5];
	i.swizzle(0,4,2).writeln;    
}

void main()
{
    string[string] aa;
    aa["name"] = "Arthur";
    aa["quest"] = "seek the Holy Grail";
    aa["favoriteColor"] = "blue";

    //with (aa.keysAsVars)
    //.writefln("My name is %s, I %s, and my favorite color is %s.",
    //	name, quest, favoriteColor);
    writefln("My name is %s, I %s, and my favorite color is %s.",aa.swizzle("name", "quest", "favoriteColor").expand);
}