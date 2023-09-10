auto pointerzip(R,T...)(R r,ref T t){
	import std;
	auto mapArgs(alias F,T...)(ref T t){
		auto mapArg(alias a)()=>F(a);
		return tuple(staticMap!(mapArg,t));
	}
	static valuetopointerrange(T)(ref T t)=> repeat(&t);
	return zip(r,mapArgs!(valuetopointerrange)(t).expand);
}
unittest{
	import std;
	int mn_=int.max;
	int mx_=int.min;
	auto foo=[1,2,56,999,-100,3,4,5];
	foreach(i,mn,mx;foo.map!(a=>a).pointerzip(mn_,mx_)){
		*mn=min(i,*mn);
		*mx=max(i,*mx);
		i.writeln;
	}
	mn_.writeln;
	mx_.writeln;
}