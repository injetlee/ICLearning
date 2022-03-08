import List "mo:base/List";
import D "mo:base/Debug";
import Array "mo:base/Array";

var a = List.nil<Text>();
// var c = a.push("dcc");
a := List.push("ddd", a);
a := List.push("eee", a);
a := List.push("fff", a);

// a.add("a");
// a.add("b");
// a.add("c"):
var b = List.toArray(List.reverse(a));
b := Array.append(b,"xx");
switch(List.get(a,2)){
    case(?a){
        D.print(a);
    };
    case (_){
         D.print("hellod");
    };
};
D.print(debug_show(b));
