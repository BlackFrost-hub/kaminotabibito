const jass = require("jass.common") as any;
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
  ModifyHeroStat: (whichStat: number, whichHero: any, modifyMethod: number, value: number) => void;
};

const HS = typeof jass.InitHashtable === "function" ? jass.InitHashtable() : null;

function hid(h: any): number {
  return typeof jass.GetHandleId === "function" ? ((jass.GetHandleId(h) as number) || 0) : 0;
}

function loadReal(handle: any, parent: number, child: number): number {
  if (!handle || typeof jass.LoadReal !== "function") return 0;
  return (jass.LoadReal(handle, parent, child) as number) || 0;
}

function saveReal(handle: any, parent: number, child: number, value: number): void {
  if (!handle || typeof jass.SaveReal !== "function") return;
  jass.SaveReal(handle, parent, child, value);
}

export function GS_LoadUintProperty(u: any, i: number): number {
  if (!u) return 0;
  if (i === 0) return (jass.GetUnitState(u, jass.UNIT_STATE_LIFE) as number) || 0;
  if (i === 1) return (jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA) as number) || 0;
  if (i === 2) return (jass.GetUnitState(u, jass.ConvertUnitState(0x12)) as number) || 0;
  if (i === 3) return (jass.GetUnitState(u, jass.ConvertUnitState(0x20)) as number) || 0;
  if (i === 4) return (jass.GetUnitState(u, jass.ConvertUnitState(0x51)) as number) || 0;
  if (i === 5) return (jass.GetUnitMoveSpeed(u) as number) || 0;
  return loadReal(HS, hid(u), i);
}

export function GS_LoadUintProperty_B(u: any, i: number): number {
  return GS_LoadUintProperty(u, i);
}

export function GS_Unit_Pry_change(u: any, i: number, r: number): void {
  if (!u || r === 0) return;
  const uid = hid(u);
  let hp = 0;

  if (i === 0) {
    hp = GetUnitLifePercent(u) || 0;
    jass.SetUnitState(u, jass.UNIT_STATE_MAX_LIFE, (jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) as number) + (r * (1 + loadReal(HS, uid, 15))));
    SetUnitLifePercentBJ(u, hp);
    return;
  }
  if (i === 1) {
    hp = GetUnitManaPercent(u) || 0;
    jass.SetUnitState(u, jass.UNIT_STATE_MAX_MANA, (jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA) as number) + r);
    SetUnitManaPercentBJ(u, hp);
    return;
  }
  if (i === 2) {
    jass.SetUnitState(u, jass.ConvertUnitState(0x12), (jass.GetUnitState(u, jass.ConvertUnitState(0x12)) as number) + (r * (1 + loadReal(HS, uid, 16))));
    return;
  }
  if (i === 3) {
    jass.SetUnitState(u, jass.ConvertUnitState(0x20), (jass.GetUnitState(u, jass.ConvertUnitState(0x20)) as number) + (r * (1 + loadReal(HS, uid, 17))));
    return;
  }
  if (i === 4) {
    jass.SetUnitState(u, jass.ConvertUnitState(0x51), (jass.GetUnitState(u, jass.ConvertUnitState(0x51)) as number) + r);
    return;
  }
  if (i === 5) {
    const ms = loadReal(HS, uid, i) + r;
    saveReal(HS, uid, i, ms);
    jass.SetUnitMoveSpeed(u, (jass.GetUnitDefaultMoveSpeed(u) as number) * (1 + ms));
    return;
  }
  if (i === 13) {
    hp = GetUnitLifePercent(u) || 0;
    jass.SetUnitState(u, jass.UNIT_STATE_MAX_LIFE,
      ((jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) as number) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r)
    );
    SetUnitLifePercentBJ(u, hp);
    saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
    return;
  }
  if (i === 14) {
    if (r < 0) {
      jass.SetUnitState(u, jass.ConvertUnitState(0x12),
        ((jass.GetUnitState(u, jass.ConvertUnitState(0x12)) as number) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r)
      );
    } else {
      jass.SetUnitState(u, jass.ConvertUnitState(0x12),
        ((jass.GetUnitState(u, jass.ConvertUnitState(0x12)) as number) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r) + 1
      );
    }
    saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
    return;
  }
  if (i === 15) {
    jass.SetUnitState(u, jass.ConvertUnitState(0x20),
      ((jass.GetUnitState(u, jass.ConvertUnitState(0x20)) as number) / (1 + loadReal(HS, uid, i))) * (1 + loadReal(HS, uid, i) + r)
    );
    saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
    return;
  }
  if (i === 16) {
    ModifyHeroStat(jglobals.bj_HEROSTAT_STR, u, jglobals.bj_MODIFYMETHOD_ADD, Math.floor(r));
    GS_Unit_Pry_change(u, 0, r * 5);
    return;
  }
  if (i === 17) {
    ModifyHeroStat(jglobals.bj_HEROSTAT_AGI, u, jglobals.bj_MODIFYMETHOD_ADD, Math.floor(r));
    GS_Unit_Pry_change(u, 2, r * 0.3);
    GS_Unit_Pry_change(u, 3, r);
    return;
  }
  if (i === 18) {
    ModifyHeroStat(jglobals.bj_HEROSTAT_INT, u, jglobals.bj_MODIFYMETHOD_ADD, Math.floor(r));
    GS_Unit_Pry_change(u, 5, r * 0.5);
    return;
  }
  saveReal(HS, uid, i, loadReal(HS, uid, i) + r);
}

export function GS_UnitPry(u: any, change: number, ptytype: number, r: number): void {
  if (change === 1) r = 0 - r;
  GS_Unit_Pry_change(u, ptytype, r);
}

export function GS_UnitPryB(u: any, change: number, ptytype: number, r: number): void {
  GS_UnitPry(u, change, ptytype, r);
}

export {};
