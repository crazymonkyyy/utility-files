auto mixinmap(string front_,string body_="",R,Args...)(R r,Args args){
	struct range{
		R r;
		size_t i;
		mixin(body_);
		bool dirty=true;
		auto calcfront(){
			auto a=r.front;
			mixin(front_);
		}
		typeof(calcfront()) store;
		auto front(){
			if(dirty){
				store=calcfront;
				dirty=false;
			}
			return store;
		}
		void popFront(){
			r.popFront;
			dirty=true;
			i++;
		}
		bool empty(){
			return r.empty;
		}
	}
	return range(r,0,args);
}
import std;
unittest{
	iota(0,6).mixinmap!"return a*i;".writeln;// 0,1,4,9,16,25
}
unittest{
	auto foo=[1,2,3,4,5];
	foo.mixinmap!"a*=i; r.front=a; return a;".writeln;
	foo.writeln;
}
//unittest{
//	float[] foo=[4.20,69.1337,float.nan,float.nan,0,1,2,3,4];
//	auto myclamp(float a, float b, float c){
//		if(a!=a){return b;}
//		if(a<b){return b;}
//		if(a>c){return c;}
//		return a;
//	}
//	foo.mixinmap!("return a.myclamp(min_,max_);","float min_; float max_;")(0,5).writeln;
//}
// todo figure out scope passing

//unittest{
//	char[] seperators=",|";
//	string foo="foo,bar|foobar,DEL,,,,,|";
//	foreach(s;foo.mixinmap!){
//		if(s=="DEL"){
//			seperators="|";
//		}
//		s.writeln;
//	}
//}
//todo figure out how meta iterators work here

unittest{
	int min_=int.max;
	auto foo=[3,5,6,7,8,2,45,6,7,78,5];
	foo.mixinmap!("if(a<*min_){*min_=a;} return a-*min_;","int* min_;")(&min_).writeln;
	"min is:".writeln(min_);
}