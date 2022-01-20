import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";
import Debug "mo:base/Debug";




actor{

    public type Message = {
        content: Text;
        time: Time.Time;
        author: Text;
    };

    public type Person = Principal;
    stable var author: Text = "";
    stable var followed: List.List<Person> =  List.nil<Person>();
    stable var messages: List.List<Message> = List.nil<Message>(); 


    public type Microblog = actor {
        follow: shared(Principal) -> async ();// 添加关注对象
        follows: shared query () -> async [Principal];//返回关注列表
        post: shared (Text, Text) -> async (); //发布新消息
        posts: shared query () -> async [Message]; //返回所有已发布的消息
        timeline: shared () -> async [Message]; //返回关注对象发布的消息
        get_name: shared  () -> async ?Text;
        set_name: shared (Text) -> async ();
    };

    public func set_name(name: Text) : async () {
        author := name;
    };

    public shared  func get_name() : async ?Text{
        ?author;
    };
    
    public shared func follow(id: Principal) : async () {
        // assert(opt == "evan123456");

        followed := List.push<Person>(id, followed);

    };


    public shared query func follows() : async [Person] {
        List.toArray(followed);
    };

    public shared func resetFollows() : async () {
        // reset the followed
        let size = List.size(followed);
        followed := List.drop(followed,size)
    };
    public shared (msg) func post(opt: Text, text: Text) : async () {
        assert(opt == "evan123456");
        // assert(Principal.toText(msg.caller) == "sdlj5-ueeya-lahix-hjmt6-liabp-4si6b-ey4la-i6hv6-ybi2v-4jk3x-wae");
        let blog = {
            content = text;
            time = Time.now();
            author = Principal.toText(msg.caller);
        };
        messages := List.push(blog, messages);
    };

    public shared query func posts() : async [Message] {

        List.toArray(messages);
    };

    public shared  func timeline() : async [Message] {
        var all = List.nil<Message>();
        for (i in Iter.fromList(followed)) {
            let canister: Microblog = actor(Principal.toText(i));
            let msgs = await canister.posts();
            let name: ?Text = await canister.get_name();

            for(msg in Iter.fromArray(msgs)) {
                var newAuthor: Text = switch name {
                case null msg.author;
                case (?name) name;
                };
                if(newAuthor == "" ) {
                    newAuthor := msg.author;
                };
                let timeline = {
                    content = msg.content;
                    time = msg.time;
                    author = newAuthor;
                };
                all := List.push(timeline,all);
            }
        };
        List.toArray(all);
    };
   
}