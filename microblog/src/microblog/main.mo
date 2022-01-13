import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";




actor{

    public type Message = {
        message: Text;
        time: Time.Time;
    };
    stable var followed :List.List<Principal> =  List.nil<Principal>();
    stable var messages : List.List<Message> = List.nil<Message>(); 

    public type Microblog = actor {
        follow: shared(Principal) -> async ();// 添加关注对象
        follows: shared query () -> async [Principal];//返回关注列表
        post: shared (Text) -> async (); //发布新消息
        posts: shared query (Time.Time) -> async [Message]; //返回所有已发布的消息
        timeline: shared (Time.Time) -> async [Message]; //返回关注对象发布的消息
    };

    public shared func follow(id: Principal): async () {
        followed := List.push<Principal>(id, followed);

    };

    public shared query func follows(): async [Principal]{
        List.toArray(followed);
    };

    public shared (msg) func post(text: Text): async () {
        assert(Principal.toText(msg.caller) == "sdlj5-ueeya-lahix-hjmt6-liabp-4si6b-ey4la-i6hv6-ybi2v-4jk3x-wae");
        let blog = {
            message = text;
            time = Time.now();
        };
        messages := List.push(blog, messages);
    };

    public shared query func posts(since: Time.Time):async [Message]{
        func f(message: Message): Bool{
            message.time >= since;
        };
        var result: List.List<Message> = List.filter(messages: List.List<Message>,f);
        List.toArray(result);
    };

    public shared  func timeline(since: Time.Time):async [Message]{
        var all = List.nil<Message>();
        for (i in Iter.fromList(followed)){
            let canister:Microblog = actor(Principal.toText(i));
            let msgs = await canister.posts(since);
            for(msg in Iter.fromArray(msgs)){
                all := List.push(msg,all);
            }
        };
        List.toArray(all);
    };

}