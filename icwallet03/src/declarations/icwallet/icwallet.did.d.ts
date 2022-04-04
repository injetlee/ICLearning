import type { Principal } from '@dfinity/principal';
export interface anon_class_4_1 {
  'canister_status' : (arg_0: canister_id) => Promise<
      {
        'status' : { 'stopped' : null } |
          { 'stopping' : null } |
          { 'running' : null },
        'memory_size' : bigint,
        'cycles' : bigint,
        'settings' : definite_canister_settings,
        'module_hash' : [] | [Array<number>],
      }
    >,
  'create_canister' : () => Promise<canister_id>,
  'delete_canister' : (arg_0: canister_id) => Promise<undefined>,
  'install_code' : (
      arg_0: Array<number>,
      arg_1: Array<number>,
      arg_2: canister_id,
    ) => Promise<undefined>,
  'start_canister' : (arg_0: canister_id) => Promise<undefined>,
  'stop_canister' : (arg_0: canister_id) => Promise<undefined>,
}
export type canister_id = Principal;
export interface definite_canister_settings {
  'freezing_threshold' : bigint,
  'controllers' : Array<Principal>,
  'memory_allocation' : bigint,
  'compute_allocation' : bigint,
}
export interface _SERVICE extends anon_class_4_1 {}
