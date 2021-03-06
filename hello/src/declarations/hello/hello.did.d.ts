import type { Principal } from '@dfinity/principal';
export interface Message {
  'content' : string,
  'time' : Time,
  'author' : string,
}
export type Person = Principal;
export type Time = bigint;
export interface _SERVICE {
  'follow' : (arg_0: Principal) => Promise<undefined>,
  'follows' : () => Promise<Array<Person>>,
  'get_name' : () => Promise<[] | [string]>,
  'post' : (arg_0: string, arg_1: string) => Promise<undefined>,
  'posts' : () => Promise<Array<Message>>,
  'resetFollows' : () => Promise<undefined>,
  'set_name' : (arg_0: string) => Promise<undefined>,
  'timeline' : () => Promise<Array<Message>>,
}
