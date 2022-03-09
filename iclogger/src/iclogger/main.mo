import TextLogger "TextLogger";
import Array "mo:base/Array";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";

actor {
    
  type TextLogger = TextLogger.TextLogger;
  let cycleShare = 10000000000;
  stable var totalMessages = 0;
  stable var canisterList = List.nil<TextLogger>();

  // public shared func getTotal(): async Nat{
  //   totalMessages;
  // };



  // public shared func getCanli(): async [TextLogger]{
  //   List.toArray(canisterList);
  // };


  public shared (msg) func append(msgs: [Text]) :async (){
    if(totalMessages % 100 == 0){
      // Cycles.add(cycleShare);
      let sub = await TextLogger.TextLogger();
      canisterList := List.push(sub, canisterList);

    };
    let canister = List.get(canisterList, 0);

    switch(canister){
        case(?canister){
            canister.append(msgs);
            totalMessages := totalMessages + 1;
        };
        case _ ();
    };
  };
         

  public type View<A> = {
    start_index: Nat;
    messages: [A];
  };

    // Return the messages between from and to indice (inclusive).
  public shared (msg) func view(from: Nat, to: Nat) : async View<Text> {
    var to_index = to;
    let startCaniIndex: Nat = from / 100;
    var endCaniIndex = to / 100;
    let canisterArray = List.toArray(List.reverse(canisterList));
    let curCanisterNumbers = List.size(canisterList);
    if(endCaniIndex > curCanisterNumbers - 1){
      endCaniIndex := curCanisterNumbers - 1
    };
    var temp: [Text] = [];
    var start_index = from;
    for (i in Iter.range(startCaniIndex, endCaniIndex)){
      if(i == startCaniIndex and startCaniIndex == endCaniIndex and i < 1){
        start_index := from;
        to_index := to;
      }else if(i == startCaniIndex and startCaniIndex == endCaniIndex and i >= 1){
        to_index := to - 100 * i;
        start_index := from - 100 * i;
      }else if(i > startCaniIndex and i < endCaniIndex and endCaniIndex > startCaniIndex){
        to_index := 99;
        start_index := 0;
      }else if(i == endCaniIndex){
        start_index := 0;
        to_index := to - 100 * i;
      };
      switch(?canisterArray[i]){
        case(?can){
          var b = await can.view(start_index, to_index);
          temp := Array.append(temp, b.messages);

    
        };
        case _ ();
      };

    };

    {
      start_index = from;
      messages = temp;
    };
    
  };

};
