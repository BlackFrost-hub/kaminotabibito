/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const jglobals = require("jass.globals") as any;
const {
  SetUnitLifePercentBJ,
  SetUnitManaPercentBJ,
  GetUnitLifePercent,
  GetUnitManaPercent,
  ModifyHeroStat
} = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitLifePercentBJ: (whichUnit: any, percent: number) => void;
  SetUnitManaPercentBJ: (whichUnit: any, percent: number) => void;
  GetUnitLifePercent: (whichUnit: any) => number;
  GetUnitManaPercent: (whichUnit: any) => number;
  ModifyHeroStat: (this: void, whichStat: number, whichHero: any, modifyMethod: number, value: number) => void;
};

const HS = jass.InitHashtable();
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const LoadReal = jass.LoadReal as (table: any, parent: number, child: number) => number;
const SaveReal = jass.SaveReal as (table: any, parent: number, child: number, value: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (value: number) => any;
const SetUnitState = japi.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitMoveSpeed = jass.SetUnitMoveSpeed as (unit: any, speed: number) => void;
const GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed as (unit: any) => number;
const R2I = jass.R2I as (value: number) => number;

function hid(h: any): number {
  return GetHandleId(h) || 0;
}

function loadReal(handle: any, parent: number, child: number): number {
  if (!handle) return 0;
  return LoadReal(handle, parent, child) || 0;
}

function saveReal(handle: any, parent: number, child: number, value: number): void {
  if (!handle) return;
  SaveReal(handle, parent, child, value);
}

export function GS_LoadUintProperty(this: void, u: any, i: number): number {
  if (!u) return 0;
  if (i === 0) return GetUnitState(u, jass.UNIT_STATE_LIFE) || 0;
  if (i === 1) return GetUnitStateJapi(u, jass.UNIT_STATE_MAX_MANA) || 0;
  if (i === 2) return GetUnitStateJapi(u, ConvertUnitState(0x12)) || 0;
  if (i === 3) return GetUnitStateJapi(u, ConvertUnitState(0x20)) || 0;
  if (i === 4) return GetUnitStateJapi(u, ConvertUnitState(0x51)) || 0;
  if (i === 5) return (jass.GetUnitMoveSpeed(u) as number) || 0;
  return loadReal(HS, hid(u), i);
}

export function GS_LoadUintProperty_B(this: void, u: any, i: number): number {
  return GS_LoadUintProperty(u, i);
}

export function GS_Unit_Pry_change(this: void, u: any, i: any, r: any): void {
  if (i == null || i === false || i === "") i = 0;
  if (r == null || r === false || r === "") r = 0;
  if (!u || r === 0) return;
  const uid = hid(u);
  let hp = 0;

  if (i === 0) {
    hp = GetUnitLifePercent(u) || 0;
    SetUnitState(u, jass.UNIT_STATE_MAX_LIFE, GetUnitStateJapi(u, jass.UNIT_STATE_MAX_LIFE) + (r * (1 + loadReal(HS, uid, 15))));
    SetUnitLifePercentBJ(u, hp);
    return;
  }
  if (i === 1) {
    hp = GetUnitManaPercent(u) || 0;
    SetUnitState(u, jass.UNIT_STATE_MAX_MANA, GetUnitStateJapi(u, jass.UNIT_STATE_MAX_MANA) + r);
    SetUnitManaPercentBJ(u, hp);
    return;
  }
  if (i === 2) {
    SetUnitState(u, ConvertUnitState(0x12), GetUnitStateJapi(u, ConvertUnitState(0x12)) + (r * (1 + loadReal(HS, uid, 16))));
    return;
  }
  if (i === 3) {
    SetUnitState(u, ConvertUnitState(0x20), GetUnitStateJapi(u, ConvertUnitState(0x20)) + (r * (1 + loadReal(HS, uid, 17))));
    return;
  }
  if (i === 4) {
    SetUnitState(u, ConvertUnitState(0x51), GetUnitStateJapi(u, ConvertUnitState(0x51)) + r);
    return;
  }
  if (i === 5) {
    const ms = loadReal(HS, uid, i) + r;
    saveReal(HS, uid, i, ms);
    SetUnitMoveSpeed(u, GetUnitDefaultMoveSpeed(u) * (1 + ms));
    return;
  }
  if (i === 13) {
    hp = GetUnitLifePercent(u) || 0;
    SetUnitState(u, jass.UNIT_STATE_MAX_LIFE,
      (GetUnitStateJapi(u, jass.UNIT_STATE_MAX_LIFE) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r)
    );
    SetUnitLifePercentBJ(u, hp);
    saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
    return;
  }
  if (i === 14) {
    if (r < 0) {
      SetUnitState(u, ConvertUnitState(0x12),
        (GetUnitStateJapi(u, ConvertUnitState(0x12)) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r)
      );
    } else {
      SetUnitState(u, ConvertUnitState(0x12),
        (GetUnitStateJapi(u, ConvertUnitState(0x12)) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r) + 1
      );
    }
    saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
    return;
  }
  if (i === 15) {
    SetUnitState(u, ConvertUnitState(0x20),
      (GetUnitStateJapi(u, ConvertUnitState(0x20)) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r)
    );
    saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
    return;
  }
  if (i === 16) {
    ModifyHeroStat(jglobals.bj_HEROSTAT_STR, u, jglobals.bj_MODIFYMETHOD_ADD, R2I(r));
    GS_Unit_Pry_change(u, 0, r * 5);
    return;
  }
  if (i === 17) {
    ModifyHeroStat(jglobals.bj_HEROSTAT_AGI, u, jglobals.bj_MODIFYMETHOD_ADD, R2I(r));
    GS_Unit_Pry_change(u, 2, r * 0.3);
    GS_Unit_Pry_change(u, 3, r);
    return;
  }
  if (i === 18) {
    ModifyHeroStat(jglobals.bj_HEROSTAT_INT, u, jglobals.bj_MODIFYMETHOD_ADD, R2I(r));
    GS_Unit_Pry_change(u, 5, r * 0.5);
    return;
  }
  saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
}

export function GS_UnitPry(this: void, u: any, change: number, ptytype: number, r: number): void {
  if (change === 1) r = 0 - r;
  GS_Unit_Pry_change(u, ptytype, r);
}

export function GS_UnitPryB(this: void, u: any, change: number, ptytype: number, r: number): void {
  GS_UnitPry(u, change, ptytype, r);
}

export {};
