import IC "./ic";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Nat "mo:base/Nat";
import HashMap "mo:base/HashMap";
import Hash "mo:base/Hash";
import List "mo:base/List";
import Nat32 "mo:base/Nat32";
import Iter "mo:base/Iter";
import Cycles "mo:base/ExperimentalCycles";




actor class(m : Nat) = self {
    type Result<T,E> = Result.Result<T,E>;
    type Proposal = {
        proposal_id : Nat;
        proposaler : Principal;
        vote_yes : Nat;
        vote_no : Nat;
        voter : List.List<Principal>;
        payload : ProposalPayload;
        state : Text;
    };
    type ProposalPayload = {
        method: Text;
        canister_id: Principal;
        message : Blob;
    };
    type Vote = {#no; #yes};
    type VoteArgs = {
        vote : Vote; proposal_id : Nat
    };
    type ProposalList = List.List<Proposal>;
    private stable var _proposal_list_state : [(Nat, Proposal)] = [];
    private func equal(x : Nat, y : Nat) : Bool{
        return Nat.equal(x,y);
    };
        private func hash(x : Nat) : Hash.Hash{
        return Nat32.fromNat(x);
    };
    var proposal_list : HashMap.HashMap<Nat, Proposal> = HashMap.fromIter(_proposal_list_state.vals(), 0, equal, hash);

    system func preupgrade(){
        _proposal_list_state := Iter.toArray(proposal_list.entries());
    };

    system func postupgrade(){
        _proposal_list_state := [];
    };
    let members_list : [Text] = [
        "sdlj5-ueeya-lahix-hjmt6-liabp-4si6b-ey4la-i6hv6-ybi2v-4jk3x-wae",
        "sdlj5-ueeya-lahix-hjmt6-liabp-4si6b-ey4la-i6hv6-ybi2v-4jk3x-wae",
        "sdlj5-ueeya-lahix-hjmt6-liabp-4si6b-ey4la-i6hv6-ybi2v-4jk3x-wae",
        "sdlj5-ueeya-lahix-hjmt6-liabp-4si6b-ey4la-i6hv6-ybi2v-4jk3x-wae"
    ];
    let ic : IC.Self = actor("aaaaa-aa");
    public func create_canister() : async  IC.canister_id{
        let settings = {
            freezing_threshold = null;
            controllers = ?[Principal.fromActor(self)];
            memory_allocation = null;
            compute_allocation = null;
        };
        Cycles.add(500000000000);
        let result = await ic.create_canister({settings = ?settings});
        result.canister_id;
    };

    public func install_code( arg : [Nat8], wasm_module : [Nat8],canister_id : IC.canister_id) : async (){
        await ic.install_code({
            arg = arg;
            wasm_module = wasm_module;
            mode = #install;
            canister_id = canister_id;
        })
    };

    public func start_canister(canister_id : IC.canister_id) : async (){
        await ic.start_canister({canister_id = canister_id});
    };

    public func stop_canister(canister_id : IC.canister_id) : async (){
        await ic.stop_canister({canister_id = canister_id})
    };

    public func delete_canister(canister_id : IC.canister_id) : async (){
        await ic.delete_canister({canister_id = canister_id})
    };

    public func canister_status(canister_id : IC.canister_id) : async {
        status : { #stopped; #stopping; #running };
        memory_size : Nat;
        cycles : Nat;
        settings : IC.definite_canister_settings;
        module_hash : ?[Nat8];
      }{
        await ic.canister_status({canister_id = canister_id});
    };
    //validate caller whether in the team member list
    private func get_member(p: Principal) : Bool{
        var flag = false;
        for (m in members_list.vals()){
            if (Principal.toText(p) == m){
                flag := true;
                return flag;
            }
        };
        return flag;


    };
    //validate proposal whether in the proposal list
    // private func get_proposal(p: Nat) : ?Proposal{
    //     var result = null;
    //     for (m in List.toArray(proposal_list).vals()){
    //         if (p == m.proposal_id){
    //             return ?m;
    //         }
    //     };
    //     return result;


    // };
    public shared({caller}) func submit_proposal(payload: ProposalPayload) : async Result<Nat, Text>  {
        //validate caller whether in the team member list
        assert(get_member(caller) == true);
        let proposal : Proposal = {
            proposal_id = proposal_list.size() + 1;
            vote_yes = 0;
            vote_no = 0;
            voter = List.nil<Principal>();
            payload = payload;
            proposaler = caller;
            state = "open";
        };
        proposal_list.put(proposal.proposal_id, proposal);


        return #ok(proposal.proposal_id);
    };

    public shared({caller}) func vote(args : VoteArgs) : async Result<Nat, Text>{
        assert(get_member(caller) == true);
        switch(proposal_list.get(args.proposal_id)){
            case null {return #err("No proposal with ID" # debug_show(args.proposal_id) # "exists")};
            case (?proposal){
                var vote_yes = proposal.vote_yes;
                var vote_no = proposal.vote_no;
                switch(args.vote){
                    case (#yes){ vote_yes := proposal.vote_yes + 1};
                    case (#no){ vote_no := proposal.vote_no + 1 };
                };
                var state = "open";
                if (vote_yes >= m){
                    state := "accept";
                };
                let update_proposal = {
                    proposal_id = proposal.proposal_id;
                    vote_yes = vote_yes;
                    vote_no = vote_no;
                    proposaler = proposal.proposaler;
                    voter = List.push(caller, proposal.voter);
                    payload = proposal.payload;
                    state = state;

                };
                proposal_list.put(proposal.proposal_id, update_proposal);

            }

        };
        return #ok(1);


    };
    public query func list_proposal(): async [(Nat, Proposal)] {
        Iter.toArray(proposal_list.entries());
    };

};


