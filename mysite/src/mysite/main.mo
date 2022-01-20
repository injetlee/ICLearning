
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Array "mo:base/Array";
actor{

    func quicksort(arr:[var Int]){

        wrappedQuickSort(arr,0,arr.size()-1);
    };

    func wrappedQuickSort(arr:[var Int],left:Nat,right:Nat){
        var i = left;
        var j = right;
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
    public func qsort(arr:[Int]):async [Int]{
        if(arr.size() <=1 ){
            return arr;
        };
        var imuteArr : [var Int] = [var];
        imuteArr := Array.thaw(arr);
        quicksort(imuteArr);
        return Array.freeze(imuteArr);
    };

}


