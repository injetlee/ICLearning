import D "mo:base/Debug";
import Bool "mo:base/Bool";
import Result "mo:base/Result";
actor {
    let person = {
        name = "Liyingjie";
        age = 67;
        gender = #male;
    };
    type Person = {
        name: Text;
        age : Nat;
        gender : Gender;
    };

    type Gender = {
        #male;
        #female;
        #unspecified;
    };
    type Result<Ok, Err> = {
        #ok: Ok;
        #err: Err;
    };
    public func retired(person: Person): async Result<Bool, Text>{
        switch (person.gender){
            case(#male) #ok(person.age >= 60);
            case(#female) #ok(person.age >= 55);
            case(#unspecified) #err("unknown");
        }
    };

    object counter{
        var count = 0;
        public func inc(){count += 1};
        public func read() :Nat {count};
        public func bump(): Nat {
            inc();
            read();
        }
    }
    // var a = retired(person);
    // D.print(Bool.toText(a))

}
