// actor {
//     public func greet(name : Text) : async Text {
//         return "Hello, " # name # "!";
//     };
// };
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";

// func swap(arr:[var Int], low:Nat,high:Nat): Int{

//     var tmp = arr[low];
//     arr[low] := arr[high];
//     1+2;

// };
actor  {
    func fib(n: Nat): Nat {
        if( n<= 1 ){
            return 1;
        }else {
            n*fib(n-1)
        }
    };
    public func fibonacci(n: Nat) : async Nat { 
     let x = fib(n);
     return x;
    };
    public func greet(name : Text) : async Text {
        return "Hello, " # name # "!";
    };

    var input:[var Int] = [var 10,5,3,4,19,20];
    let bufferA = Buffer.Buffer<Int>(1);
    bufferA.add(2);
    // for ( m in bufferA.vals()){

    //     Debug.print(Int.toText(m));
    // };
    func quicksort(arr:[var Int]){
        // arr[0] := 100;
        if(arr.size()>=2){
            var baseNumber = arr[0];
            let leftBuffer = Buffer.Buffer<Int>(1);
            let rightBuffer = Buffer.Buffer<Int>(1);
            for(j in Iter.range(1,arr.size()-1)){
                // Debug.print(Int.toText(arr[j]));
                if(arr[j]<=baseNumber){
                    leftBuffer.add(arr[j]);
                }else{
                    rightBuffer.add(arr[j]);
                }
            };
            var leftArray = leftBuffer.toArray();
            var rightArray = rightBuffer.toArray();
            for(i in leftArray.vals()){
                Debug.print("------------------");
                Debug.print(Int.toText(i));

            };
        }


        
    };
    quicksort(input);
    // for(i in input.vals()){
    //     Debug.print("------------------");
    //     Debug.print(Int.toText(i));

    // };
};

    // func fib(n: Nat): Nat {
    //     if( n<= 1 ){
    //         return 1;
    //     }else {
    //         n*fib(n-1)
    //     }
    // };
    // Debug.print(Nat.toText(5));