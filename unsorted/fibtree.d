struct trifibtree{
	int[4] nums;
	trifibtree[3] children(){
		trifibtree[3] o;
		o[0]=trifibtree(nums[3],nums[1]);
		o[1]=trifibtree(nums[3],nums[2]);
		o[2]=trifibtree(nums[0],nums[2]);
		return o;
	}
	this(int a,int b){
		nums[0]=a;
		nums[1]=b;
		nums[2]=a+b;
		nums[3]=nums[2]+b;
	}
}
import std;
void treemapdepth(alias F)(trifibtree t,int depth,int i=0){
	if(i>=depth){return;}
	//if(t.nums[0]*t.nums[1]>85*85){return;}
	F(t,i);
	foreach(a;t.children){
		a.treemapdepth!(F)(depth,i+1);
	}
}
void treewrite(trifibtree t,int i){
	"       "[0..i].write;
	t.writeln;
}
void triplewrite(trifibtree t,int i){
	//"       "[0..i].write;
	(t.nums[0]*t.nums[3]).write;
	"^2+".write;
	(t.nums[1]*t.nums[2]*2).write;
	"^2=".write;
	(t.nums[0]*t.nums[2]+t.nums[1]*t.nums[3]).write;
	"^2".writeln;
}
void fractionwrite(trifibtree t,int i){
	"       "[0..i].write;
	t.nums[0].writeln("/",t.nums[3]);
	"       "[0..i].write;
	t.nums[1].writeln("/",t.nums[2]);
}
void main(){
	//trifibtree(1,1).children[0].children.writeln;
	//trifibtree(1,1).treemapdepth!(treewrite)(8);
	//trifibtree(1,1).treemapdepth!(triplewrite)(8);
	trifibtree(1,1).treemapdepth!(fractionwrite)(8);
}