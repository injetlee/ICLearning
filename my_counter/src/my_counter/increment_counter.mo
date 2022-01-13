import Cycle "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
actor Counter{
    let limit = 10000000;
    stable var currentValue : Nat = 0;
    public query func get() : async Nat {
        return currentValue;
    };
    public func increment() : async (){
        currentValue += 1;
    };

    public func set(n: Nat) : (){
        currentValue := n;

    };
    public type ChunkId = Nat;
    public type HeaderField = (Text, Text);
    public type StreamingCallbackHttpResponse = {
        token : ?StreamingCallbackToken;
        body : [Nat8];
    };
    public type StreamingCallbackToken = {
        key : Text;
        sha256 : ?[Nat8];
        index : Nat;
        content_encoding : Text;
    };
    public type StreamingStrategy = {
        #Callback : {
        token : StreamingCallbackToken;
        callback : shared query StreamingCallbackToken -> async StreamingCallbackHttpResponse;
        };
    };
    public type HttpRequest = {
        url : Text;
        method : Text;
        body : Blob;
        headers : [HeaderField];
    };
    public type HttpResponse = {
        body : Blob;
        headers : [HeaderField];
        streaming_strategy : ?StreamingStrategy;
        status_code : Nat16;
    };

    public  query func http_request(request: HttpRequest): async HttpResponse  {

        // var temp: Text = getHeaders(request)
        { 
            body = Text.encodeUtf8("<html><body><h1>Hello " # request.url # " Current Counter is:</h1><span style='font-size:100px;color:red';'>" # Nat.toText(currentValue) # "</span></body></html>"  );
            headers = [];
            streaming_strategy = null;
            status_code = 200;
        }
    };
    public query func get_balance(): async Nat{
        return Cycle.balance();
    };

    public func wallet_receive(): async {accepted: Nat64} {
        let available = Cycle.available();
        let accepted = Cycle.accept(Nat.min(available,limit));
        {accepted = Nat64.fromNat(accepted)};
    };

    // func getHeaders(request: HttpRequest) : Text{
    //     var text: Text = "";
    //     for((i,j) in request.headers.vals()){
    //         text := text # "i" # i # "j" # j # "---</br>";
    //     };
    //     return text;
    // }

}