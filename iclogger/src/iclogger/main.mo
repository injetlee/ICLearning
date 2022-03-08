import Logger  "Logger";
import TextLogger "TextLogger";
import Array "mo:base/Array";
import List "mo:base/List";
import Cycles "mo:base/ExperimentalCycles";
import Iter "mo:base/Iter";

actor {
    
  type TextLogger = TextLogger.TextLogger;
  let cyclesShare = 10000000000;
  stable var totalMessages = 0;
  var totalMessagesPerCani = 0;
  stable var canisterList = List.nil<TextLogger>();

  // public shared func getTotal(): async Nat{
  //   totalMessages;
  // };



  // public shared func getCanli(): async [TextLogger]{
  //   List.toArray(canisterList);
  // };


  // public shared func gettotalper(): async Nat{
  //   totalMessagesPerCani;
  // };

  public shared (msg) func append(msgs: [Text]){
    if(totalMessagesPerCani % 100 == 0){
      let sub = await TextLogger.TextLogger();
      canisterList := List.push(sub, canisterList);
      totalMessagesPerCani := 0;

    };
    let canister = List.get(canisterList, 0);

    switch(canister){
        case(?canister){
            canister.append(msgs);
            totalMessages := totalMessages + 1;
            totalMessagesPerCani := totalMessagesPerCani + 1;
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
    var to_index = 0;
    let start: Nat = from / 100;
    let end = to / 100;
    let canisterArray = List.toArray(List.reverse(canisterList));
     
    var resultArray : [var ?TextLogger] = Array.init(0,null);
    var temp: [Text] = [];
    for (i in Iter.range(start, end + 1)){
      if(i < end and end > start){
        to_index := 99;
      }else{
        to_index := to;
      };
      switch(?canisterArray[i]){
        case(?can){
          var b = await can.view(from, to_index);
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
