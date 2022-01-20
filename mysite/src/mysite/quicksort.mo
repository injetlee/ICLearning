
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Array "mo:base/Array";

var myArray :[var Int]= [var 5,0,1,8,6,2,3,4,9,7];
func debugPrint(arr:[var Int]){
    for(m in arr.vals()){
        Debug.print(Int.toText(m))
    }

};
func quicksort(arr:[var Int]){
    wrappedQuickSort(arr,0,arr.size()-1);
};

func wrappedQuickSort(arr:[var Int],left:Nat,right:Nat){
    var i = left;
    var j = right;
    //define first element as base element
    var base = arr[i];
    if(i > j){
        return;
    }else{
        while(i != j){
            while(arr[j] > base and j > i){
                j := j-1;
            };
            while(arr[i] <= base and j > i){
                i := i+1;
            };
            if(j > i){
                let temp = arr[j];
                arr[j] := arr[i];
                arr[i] := temp;
            }

        };
        arr[left] := arr[i];
        arr[i] := base;
        if(i >= 1){
            wrappedQuickSort(arr:[var Int],left,i-1);
        };
        
        if(j+1 <= right){
            wrappedQuickSort(arr:[var Int],j+1, right);
        }
    }


};
//sort
quicksort(myArray);
//print result
debugPrint(myArray);

