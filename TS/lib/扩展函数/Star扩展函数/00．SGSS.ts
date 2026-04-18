const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jglobals = require("jass.globals") as any;
const slk = require("jass.slk") as any;

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
  return typeof jass.GetHandleId === "function" ? ((jass.GetHandleId(u) as number) || 0) : 0;
}

function sh(name: string): number {
  return typeof jass.StringHash === "function" ? ((jass.StringHash(name) as number) || 0) : 0;
}

function loadReal(u: any, key: number): number {
  const hh = hashHandle();
  if (!hh || typeof jass.LoadReal !== "function") return 0;
  return (jass.LoadReal(hh, h2i(u), key) as number) || 0;
}

function saveReal(u: any, key: number, value: number): void {
  const hh = hashHandle();
  if (!hh || typeof jass.SaveReal !== "function") return;
  jass.SaveReal(hh, h2i(u), key, value);
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
  if (typeof jass.GetUnitAbilityLevel === "function" && typeof jass.UnitAddAbility === "function" && jass.GetUnitAbilityLevel(u, code) === 0) {
    jass.UnitAddAbility(u, code);
  }
  if (typeof japi.EXGetUnitAbility === "function" && typeof japi.EXSetAbilityDataReal === "function") {
    const abil = japi.EXGetUnitAbility(u, code);
    if (abil) japi.EXSetAbilityDataReal(abil, 1, 108, value);
  }
  if (typeof jass.IncUnitAbilityLevel === "function") jass.IncUnitAbilityLevel(u, code);
  if (typeof jass.DecUnitAbilityLevel === "function") jass.DecUnitAbilityLevel(u, code);
}

function setAbilityDataABC(u: any, raw: string, a: number, b: number, c: number): void {
  const code = resolveAbilityCode(raw);
  if (!u || code === 0) return;
  if (typeof jass.GetUnitAbilityLevel === "function" && typeof jass.UnitAddAbility === "function" && jass.GetUnitAbilityLevel(u, code) === 0) {
    jass.UnitAddAbility(u, code);
  }
  if (typeof japi.EXGetUnitAbility === "function" && typeof japi.EXSetAbilityDataReal === "function") {
    const abil = japi.EXGetUnitAbility(u, code);
    if (abil) {
      japi.EXSetAbilityDataReal(abil, 1, 110, a);
      japi.EXSetAbilityDataReal(abil, 1, 108, b);
      japi.EXSetAbilityDataReal(abil, 1, 109, c);
    }
  }
  if (typeof jass.IncUnitAbilityLevel === "function") jass.IncUnitAbilityLevel(u, code);
  if (typeof jass.DecUnitAbilityLevel === "function") jass.DecUnitAbilityLevel(u, code);
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
  // 英雄优先直接改主属性，避免依赖 ASG3 可用性。
  if (typeof jass.IsUnitType === "function" && typeof jass.UNIT_TYPE_HERO !== "undefined" && jass.IsUnitType(u, jass.UNIT_TYPE_HERO)) {
    if (typeof jass.GetHeroStr === "function" && typeof jass.SetHeroStr === "function") {
      const cur = (jass.GetHeroStr(u, true) as number) || 0;
      jass.SetHeroStr(u, cur + s, true);
    }
    if (typeof jass.GetHeroAgi === "function" && typeof jass.SetHeroAgi === "function") {
      const cur = (jass.GetHeroAgi(u, true) as number) || 0;
      jass.SetHeroAgi(u, cur + a, true);
    }
    if (typeof jass.GetHeroInt === "function" && typeof jass.SetHeroInt === "function") {
      const cur = (jass.GetHeroInt(u, true) as number) || 0;
      jass.SetHeroInt(u, cur + i, true);
    }
  } else {
    setAbilityDataABC(u, "ASG3", ns, na, ni);
  }
  saveReal(u, ks, ns);
  saveReal(u, ka, na);
  saveReal(u, ki, ni);
}

function setHp(u: any, v: number): void {
  if (typeof jass.GetUnitState !== "function" || typeof jass.SetUnitState !== "function") return;
  const key = sh("生命");
  const oldAdd = loadReal(u, key);
  const oldMax = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE);
  const oldLife = jass.GetUnitState(u, jass.UNIT_STATE_LIFE);
  const ratio = oldMax > 0.405 ? oldLife / oldMax : 1.0;
  const newAdd = oldAdd + v;
  const newMax = oldMax - oldAdd + newAdd;
  jass.SetUnitState(u, jass.UNIT_STATE_MAX_LIFE, newMax);
  if (oldLife > 0.405) jass.SetUnitState(u, jass.UNIT_STATE_LIFE, newMax * ratio);
  saveReal(u, key, newAdd);
}

function setMp(u: any, v: number): void {
  if (typeof jass.GetUnitState !== "function" || typeof jass.SetUnitState !== "function") return;
  const key = sh("法力");
  const oldAdd = loadReal(u, key);
  const oldMax = jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA);
  const oldMana = jass.GetUnitState(u, jass.UNIT_STATE_MANA);
  const ratio = oldMax > 0 ? oldMana / oldMax : 1.0;
  const newAdd = oldAdd + v;
  const newMax = oldMax - oldAdd + newAdd;
  jass.SetUnitState(u, jass.UNIT_STATE_MAX_MANA, newMax);
  jass.SetUnitState(u, jass.UNIT_STATE_MANA, newMax * ratio);
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
}

export function SGSS_SetStatePercentumEX2(u: any, id: number, v: number): void {
  const hpPct = sh("生命值百分比加成");
  const hpAdd = sh("生命值百分比加成增值");
  const mpPct = sh("法力值百分比加成");
  const mpAdd = sh("法力值百分比加成增值");

  if (id === 7 && typeof jass.GetUnitState === "function") {
    const pv = loadReal(u, hpPct);
    const av = loadReal(u, hpAdd);
    const base = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) - av;
    const npv = pv + v;
    const nav = base * npv;
    if (av !== nav) {
      setHp(u, -av);
      saveReal(u, hpPct, npv);
      saveReal(u, hpAdd, nav);
      setHp(u, nav);
    }
  } else if (id === 8 && typeof jass.GetUnitState === "function") {
    const pv = loadReal(u, mpPct);
    const av = loadReal(u, mpAdd);
    const base = jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA) - av;
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
