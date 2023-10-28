import std;
//https://leetcode.com/problems/find-greatest-common-divisor-of-array/
enum test1=[2,5,6,9,10];
enum test2=[7,5,6,8,3];
enum test3=[3,3];

auto gcdarray_verbose(R)(R r){
    auto mi=r.minElement;
    auto mx=r.maxElement;
    return gcd(mi,mx);
}
unittest{
	test1.gcdarray_verbose.writeln;
    test2.gcdarray_verbose.writeln;
    test3.gcdarray_verbose.writeln;
}

template expandthencontract(alias F,A...){
    auto expandthencontract(T)(T t){
        string expand(){
            string o;
            static foreach(i,a;A){
                static if(is(typeof(a)==string)){
					o~="t.";
                    o~=a;
                    o~=",";
                } else {
           			static if(is(typeof(a)==typeof(null))){
                    	o~="t,";
                    }
                    o~="A["~i.to!string~"](t),";
                }
            }
            return o;
        }
        mixin("return F("~expand~");");
}}
auto gcdarray_short(R)(R r){
	return r.expandthencontract!(gcd,"minElement","maxElement");
}
unittest{
	test1.gcdarray_short.writeln;
    test2.gcdarray_short.writeln;
    test3.gcdarray_short.writeln;
}
auto gcdarray_shorta(R)(R r){
	return r.expandthencontract!(gcd,minElement,"maxElement");
}
auto gcdarray_shortb(R)(R r){
	return r.expandthencontract!(gcd,"minElement",maxElement);
}
auto gcdarray_shortc(R)(R r){
	return r.expandthencontract!(gcd,minElement,maxElement);
}
unittest{
	test1.gcdarray_shorta.writeln;
    test2.gcdarray_shortb.writeln;
    test3.gcdarray_shortc.writeln;
}
//https://www.geeksforgeeks.org/how-to-strip-out-html-tags-from-a-string-using-javascript/
enum test4="<html>Welcome to GeeksforGeeks.</html>";
enum test5="<p>A Computer Science ";
bool special(dchar c)=>c=='<'||c=='>';
bool notspecial(dchar c)=>c!='<'&&c!='>';
auto stripthtml_verbose(string s){
    auto mask=s.map!special.cumulativeFold!((a,b)=>a!=b);
    //mask.writeln;
    return zip(s,mask).filter!"!a[1]".map!"a[0]".filter!notspecial;
}
unittest{
    test4.stripthtml_verbose.writeln;
    test5.stripthtml_verbose.writeln;
}
auto stripthtml_short(string s)=> s
    .expandthencontract!(zip,null,
    	a=>a.map!special.cumulativeFold!((a,b)=>a!=b))
    .filter!"!a[1]".map!"a[0]".filter!notspecial;
unittest{
    test4.stripthtml_short.writeln;
    test5.stripthtml_short.writeln;
}