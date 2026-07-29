/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const jglobals = require("jass.globals") as any;
const slk = require("jass.slk") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const StringHash = jass.StringHash as (value: string) => number;
const LoadReal = jass.LoadReal as (table: any, parent: number, child: number) => number;
const SaveReal = jass.SaveReal as (table: any, parent: number, child: number, value: number) => void;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const UnitAddAbility = jass.UnitAddAbility as (unit: any, abilityId: number) => void;
const UnitRemoveAbility = jass.UnitRemoveAbility as (unit: any, abilityId: number) => boolean;
const IncUnitAbilityLevel = jass.IncUnitAbilityLevel as (unit: any, abilityId: number) => void;
const DecUnitAbilityLevel = jass.DecUnitAbilityLevel as (unit: any, abilityId: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitStateJass = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitStateJapi = japi.SetUnitState as (unit: any, state: any, value: number) => void;
const EXGetUnitAbility = japi.EXGetUnitAbility as (unit: any, abilityId: number) => any;
const EXSetAbilityDataReal = japi.EXSetAbilityDataReal as (ability: any, level: number, field: number, value: number) => void;
const R2I = jass.R2I as (value: number) => number;

const 视野技能每级数值 = 50;
// 视野分档：从 50 起步，36 档，每档 +50，最终覆盖 50 ~ 1800。
const 视野技能RawIds = [
  "ASV1", "ASV2", "ASV3", "ASV4", "ASV5", "ASV6", "ASV7", "ASV8", "ASV9",
  "ASV0",
  "ASVA", "ASVB", "ASVC", "ASVD", "ASVE", "ASVF", "ASVG", "ASVH", "ASVI", "ASVJ",
  "ASVK", "ASVL", "ASVM", "ASVN", "ASVO", "ASVP", "ASVQ", "ASVR", "ASVS", "ASVT",
  "ASVU", "ASVV", "ASVW", "ASVX", "ASVY", "ASVZ",
];

function hashHandle(): any {
  const g = globalThis as any;
  const pick = (name: string): any => {
    if (g[name] != null) return g[name];
    if (jglobals && jglobals[name] != null) return jglobals[name];
    if (jass && jass[name] != null) return jass[name];
    return null;
  };
  // StarGSS 原实现优先使用 StarBaseHT
  return pick("StarBaseHT")
    ?? pick("YDHASH_HANDLE")
    ?? pick("YDHT")
    ?? pick("udg_YDHASH_HANDLE")
    ?? pick("udg_YDHT");
}

function h2i(u: any): number {
  return GetHandleId(u) || 0;
}

function sh(name: string): number {
  return StringHash(name) || 0;
}

function loadReal(u: any, key: number): number {
  const hh = hashHandle();
  if (!hh) return 0;
  return LoadReal(hh, h2i(u), key) || 0;
}

function saveReal(u: any, key: number, value: number): void {
  const hh = hashHandle();
  if (!hh) return;
  SaveReal(hh, h2i(u), key, value);
}

function resolveAbilityCode(raw: string): number {
  const abilityTable = slk && slk.ability ? slk.ability[raw] : null;
  if (abilityTable) {
    const fromId = Number((abilityTable as any).id);
    if (!isNaN(fromId) && fromId > 0) return fromId;
    const fromObj = Number((abilityTable as any)._id);
    if (!isNaN(fromObj) && fromObj > 0) return fromObj;
  }
  if (raw.length === 4) {
    return (
      raw.charCodeAt(0) * 0x1000000 +
      raw.charCodeAt(1) * 0x10000 +
      raw.charCodeAt(2) * 0x100 +
      raw.charCodeAt(3)
    );
  }
  return 0;
}

function setAbilityDataA(u: any, raw: string, value: number): void {
  const code = resolveAbilityCode(raw);
  if (!u || code === 0) return;
  if (GetUnitAbilityLevel(u, code) === 0) {
    UnitAddAbility(u, code);
  }
  const abil = EXGetUnitAbility(u, code);
  if (abil) EXSetAbilityDataReal(abil, 1, 108, value);
  IncUnitAbilityLevel(u, code);
  DecUnitAbilityLevel(u, code);
}

function setAbilityDataABC(u: any, raw: string, a: number, b: number, c: number): void {
  const code = resolveAbilityCode(raw);
  if (!u || code === 0) return;
  if (GetUnitAbilityLevel(u, code) === 0) {
    UnitAddAbility(u, code);
  }
  const abil = EXGetUnitAbility(u, code);
  if (abil) {
    EXSetAbilityDataReal(abil, 1, 110, a);
    EXSetAbilityDataReal(abil, 1, 108, b);
    EXSetAbilityDataReal(abil, 1, 109, c);
  }
  IncUnitAbilityLevel(u, code);
  DecUnitAbilityLevel(u, code);
}

function setAtk(u: any, v: number): void {
  const key = sh("攻击");
  const next = loadReal(u, key) + v;
  setAbilityDataA(u, "ASG1", next);
  saveReal(u, key, next);
}

function setArmor(u: any, v: number): void {
  const key = sh("护甲");
  const next = loadReal(u, key) + v;
  setAbilityDataA(u, "ASG2", next);
  saveReal(u, key, next);
}

function setState3(u: any, s: number, a: number, i: number): void {
  const ks = sh("力量");
  const ka = sh("敏捷");
  const ki = sh("智力");
  const ns = loadReal(u, ks) + s;
  const na = loadReal(u, ka) + a;
  const ni = loadReal(u, ki) + i;
  // 使用技能系统添加绿字属性
  setAbilityDataABC(u, "ASG3", ns, na, ni);
  saveReal(u, ks, ns);
  saveReal(u, ka, na);
  saveReal(u, ki, ni);
}

function setHp(u: any, v: number): void {
  const key = sh("生命");
  const oldAdd = loadReal(u, key);
  const oldMax = GetUnitStateJapi(u, jass.UNIT_STATE_MAX_LIFE);
  const oldLife = GetUnitState(u, jass.UNIT_STATE_LIFE);
  const ratio = oldMax > 0.405 ? oldLife / oldMax : 1.0;
  const newAdd = oldAdd + v;
  const newMax = oldMax - oldAdd + newAdd;
  SetUnitStateJapi(u, jass.UNIT_STATE_MAX_LIFE, newMax);
  if (oldLife > 0.405) SetUnitStateJass(u, jass.UNIT_STATE_LIFE, newMax * ratio);
  saveReal(u, key, newAdd);
}

function setMp(u: any, v: number): void {
  const key = sh("法力");
  const oldAdd = loadReal(u, key);
  const oldMax = GetUnitStateJapi(u, jass.UNIT_STATE_MAX_MANA);
  const oldMana = GetUnitState(u, jass.UNIT_STATE_MANA);
  const ratio = oldMax > 0 ? oldMana / oldMax : 1.0;
  const newAdd = oldAdd + v;
  const newMax = oldMax - oldAdd + newAdd;
  SetUnitStateJapi(u, jass.UNIT_STATE_MAX_MANA, newMax);
  SetUnitStateJass(u, jass.UNIT_STATE_MANA, newMax * ratio);
  saveReal(u, key, newAdd);
}

function setMove(u: any, v: number): void {
  const key = sh("移速");
  const next = loadReal(u, key) + v;
  setAbilityDataA(u, "ASG6", next);
  saveReal(u, key, next);
}

function setAtkSpeed(u: any, v: number): void {
  const key = sh("攻速");
  const next = loadReal(u, key) + v;
  setAbilityDataA(u, "ASG7", next);
  saveReal(u, key, next);
}

function 移除全部视野技能(u: any): void {
  if (!u) return;
  for (let i = 0; i < 视野技能RawIds.length; i++) {
    const code = resolveAbilityCode(视野技能RawIds[i]);
    if (code !== 0 && GetUnitAbilityLevel(u, code) > 0) {
      UnitRemoveAbility(u, code);
    }
  }
}

function 同步单位视野技能(u: any, value: number): void {
  if (!u) return;
  移除全部视野技能(u);
  if (!(value > 0)) return;

  let level = R2I(value / 视野技能每级数值 + 0.5);
  if (level < 1) level = 1;
  if (level > 视野技能RawIds.length) level = 视野技能RawIds.length;
  const code = resolveAbilityCode(视野技能RawIds[level - 1]);
  if (code !== 0) UnitAddAbility(u, code);
}

function setSight(u: any, v: number): void {
  const key = sh("视野");
  const next = loadReal(u, key) + v;
  同步单位视野技能(u, next);
  saveReal(u, key, next);
}

export function SGSS_SetState(u: any, id: number, v: number): void {
  if (id === 1) setAtk(u, v);
  else if (id === 2) setArmor(u, v);
  else if (id === 3) setState3(u, v, 0, 0);
  else if (id === 4) setState3(u, 0, v, 0);
  else if (id === 5) setState3(u, 0, 0, v);
  else if (id === 6) setState3(u, v, v, v);
  else if (id === 7) setHp(u, v);
  else if (id === 8) setMp(u, v);
  else if (id === 9) setMove(u, v);
  else if (id === 10) setAtkSpeed(u, v);
  else if (id === 11) setSight(u, v);
}

export function SGSS_SetStatePercentumEX2(u: any, id: number, v: number): void {
  const hpPct = sh("生命值百分比加成");
  const hpAdd = sh("生命值百分比加成增值");
  const mpPct = sh("法力值百分比加成");
  const mpAdd = sh("法力值百分比加成增值");

  if (id === 7) {
    const pv = loadReal(u, hpPct);
    const av = loadReal(u, hpAdd);
    const base = GetUnitStateJapi(u, jass.UNIT_STATE_MAX_LIFE) - av;
    const npv = pv + v;
    const nav = base * npv;
    if (av !== nav) {
      setHp(u, -av);
      saveReal(u, hpPct, npv);
      saveReal(u, hpAdd, nav);
      setHp(u, nav);
    }
  } else if (id === 8) {
    const pv = loadReal(u, mpPct);
    const av = loadReal(u, mpAdd);
    const base = GetUnitStateJapi(u, jass.UNIT_STATE_MAX_MANA) - av;
    const npv = pv + v;
    const nav = base * npv;
    if (av !== nav) {
      setMp(u, -av);
      saveReal(u, mpPct, npv);
      saveReal(u, mpAdd, nav);
      setMp(u, nav);
    }
  }
}

export {};
