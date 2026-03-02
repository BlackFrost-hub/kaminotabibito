/** Global declarations for TSTL / Lua environment */
declare function require(mod: string): any;
declare const pcall: <T>(f: () => T) => [boolean, T | string];
declare const tostring: (v: any) => string;
declare const string: { char: (...codes: number[]) => string };

interface JassCommon {
  CreateTimer: () => any;
  TimerStart: (timer: any, timeout: number, periodic: boolean, callback: () => void) => void;
  CreateTrigger: () => any;
  TriggerRegisterPlayerUnitEvent: (trig: any, player: any, event: number, filter: any) => void;
  TriggerAddAction: (trig: any, fn: () => void) => void;
  GetManipulatedItem: () => any;
  GetManipulatingUnit: () => any;
  GetOwningPlayer: (unit: any) => any;
  GetItemTypeId: (item: any) => number;
  GetTriggerEventId: () => number;
  ExecuteFunc: (name: string) => void;
  DisplayTimedTextToPlayer: (player: any, x: number, y: number, duration: number, msg: string) => void;
  Player: (index: number) => any;
  EVENT_PLAYER_UNIT_PICKUP_ITEM: number;
  EVENT_PLAYER_UNIT_DROP_ITEM: number;
}

/** Lua global print - variadic */
declare var print: (...args: any[]) => void;
