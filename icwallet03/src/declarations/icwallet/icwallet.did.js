export const idlFactory = ({ IDL }) => {
  const canister_id = IDL.Principal;
  const definite_canister_settings = IDL.Record({
    'freezing_threshold' : IDL.Nat,
    'controllers' : IDL.Vec(IDL.Principal),
    'memory_allocation' : IDL.Nat,
    'compute_allocation' : IDL.Nat,
  });
  const anon_class_4_1 = IDL.Service({
    'canister_status' : IDL.Func(
        [canister_id],
        [
          IDL.Record({
            'status' : IDL.Variant({
              'stopped' : IDL.Null,
              'stopping' : IDL.Null,
              'running' : IDL.Null,
            }),
            'memory_size' : IDL.Nat,
            'cycles' : IDL.Nat,
            'settings' : definite_canister_settings,
            'module_hash' : IDL.Opt(IDL.Vec(IDL.Nat8)),
          }),
        ],
        [],
      ),
    'create_canister' : IDL.Func([], [canister_id], []),
    'delete_canister' : IDL.Func([canister_id], [], []),
    'install_code' : IDL.Func(
        [IDL.Vec(IDL.Nat8), IDL.Vec(IDL.Nat8), canister_id],
        [],
        [],
      ),
    'start_canister' : IDL.Func([canister_id], [], []),
    'stop_canister' : IDL.Func([canister_id], [], []),
  });
  return anon_class_4_1;
};
export const init = ({ IDL }) => { return []; };
