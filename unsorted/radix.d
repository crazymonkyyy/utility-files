import std;
// cumutive reduce but overwriting, in-place, eager, etc.
//auto reduceoverwrite(alias F,R,E=typeof(R.init.front))(R r,E seed){
//	R r_=r;
//	while(!r.empty){
//		seed=F(r.front,seed);
//		r.front=seed;
//		r.popFront;
//	}
//	return r_;
//}
//unittest{
//	int[5] foo=[1,2,3,4,5];
//	foo[].map!(ref (ref a){return a;}).reduceoverwrite!((a,b)=>0)(0);
//	foo.writeln;
//}
//auto reduceoverwrite_(alias F,E,ulong n)(ref E[n] array,E seed){
//	return array[].map!(ref (ref a){return a;}).reduceoverwrite!F(seed);
//}
//unittest{
//	int[5] foo=[1,2,3,4,5];
//	foo.reduceoverwrite_!((a,b)=>a+b)(0).writeln;
//}
void offsetprefixsum(T,ulong n)(ref T[n] array){//need a fancy overload for cumreduce
	T store=0;
	foreach(ref e;array){
		swap(e,store);
		store+=e;
	}
}
unittest{
	int[5] foo=[1,2,3,4,5];
	foo.offsetprefixsum;
	foo.writeln;
}

template overloadsetcount(alias F,ulong n=0){
	static if(is(typeof(F!n))){
		alias overloadsetcount=overloadsetcount!(F,n+1);
	} else {
		enum overloadsetcount=n;
	}
}

template foo(int i:0){}//cant be in unittest ... cause reasons
template foo(int i:1){}
template foo(int i:2){}
unittest{
	alias bar(int n)=foo!n;
	static assert(overloadsetcount!bar==3);
}
unittest{
	void recurse(alias F,int n=overloadsetcount!F)(){
		n.writeln("down");
		static if(n!=0){
			recurse!(F,n-1);
		}
	}
	recurse!foo;
}
unittest{
	void recurse(alias F,int n=0)(){
		n.writeln("up");
		static if(n!=overloadsetcount!F-1){
			recurse!(F,n+1);
		}
	}
	recurse!foo;
}
auto radixsort(alias opradix_,int radixn=0,T,ulong n)(ref T[n] a_array,ref T[n] b_array){
	ulong[256] prefixsum;
	alias opradix=opradix_!radixn;
	foreach(e;a_array){
		prefixsum[opradix(e)]++;
	}
	//prefixsum.writeln;
	//prefixsum.reduceoverwrite_!((a,b)=>a+b)(cast(ulong)0).writeln;
	prefixsum.offsetprefixsum;
	//prefixsum.writeln;
	foreach(e;a_array){
		auto rad=opradix(e);
		b_array[prefixsum[rad]]=e;
		prefixsum[rad]++;
	}
	//b_array.writeln;
	static if(radixn!=overloadsetcount!opradix_-1){
		return radixsort!(opradix_,radixn+1)(b_array,a_array);
	} else {
		return b_array;
	}
}

byte threedigitradix(int zzz:0)(int i){
	return i%10;}
byte threedigitradix(int zzz:1)(int i){
	return (i/10)%10;}
byte threedigitradix(int zzz:2)(int i){
	return (i/100)%10;}
unittest{
	42.threedigitradix!0.writeln;
}
unittest{
	int[30] foo;
	int[30] bar;
	foreach(ref e;foo){
		e=uniform(0,999);
	}
	foo.writeln;
	foo.radixsort!threedigitradix(bar).writeln;
	assert(bar[].isSorted);
}
ubyte intradix(int zzz:0)(int i){
	return cast(ubyte)(i%256);}
ubyte intradix(int zzz:1)(int i){
	return cast(ubyte)((i/256)%256);}
ubyte intradix(int zzz:2)(int i){
	return cast(ubyte)((i/(256*256))%256);}
ubyte intradix(int zzz:3)(int i){
	return cast(ubyte)((i/(256*256*256)+128)%256);}
unittest{
	int[300] foo;
	int[300] bar;
	foreach(ref e;foo){
		e=uniform!int;
	}
	foo.writeln;
	foo.radixsort!intradix(bar).writeln;
	assert(foo[].isSorted);
}