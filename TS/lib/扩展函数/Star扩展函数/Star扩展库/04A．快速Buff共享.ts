/** @noSelfInFile */
/**
 * Star扩展库 - 快速Buff系统共享层
 *
 * 放这里的内容：
 * - 共享状态
 * - 常量与 Buff 映射
 * - 来源显示解析
 * - 马甲初始化与底层施加逻辑
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jglobals = require("jass.globals") as any;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};
import { YDWESetUnitAbilityDataReal, EXSetUnitFacing } from "../../YDWE函数/00．YDWE函数";
import { GS_Suspend, 申请单位暂停占用定时 } from "./03．硬直暂停系统";
import { SUC_IsUnitStructure, SUC_IsValidUnit } from "./08．单位判定与筛选函数";

const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const ydweObject = require("lib.扩展函数.YDWE函数.index") as {
  getObjectProperty: (this: void, objectType: number, objectId: number | string, property: string) => string;
  ObjectType: { ABILITY: number };
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const miscBj = require("lib.扩展函数.BJ函数.07．杂项") as {
  String2OrderIdBJ: (this: void, orderIdString: string) => number;
};
const fourCcUtil = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  fourCCToString: (this: void, fourcc: number) => string;
};
const { calcReducedControlDuration } = require("系统.05．Buff系统.01．控制抗性.02．控制时间计算") as {
  calcReducedControlDuration: (this: void, target: any, originalDuration: number) => number;
};
const unitRelated = require("lib.扩展函数.自定义扩展函数.00．单位相关") as {
  getPlayerFirstHero: (this: void, player: any) => any;
};
const 获取对象属性 = ydweObject.getObjectProperty;
const 物体类型 = ydweObject.ObjectType;
const 字符串转命令ID = miscBj.String2OrderIdBJ;
const 四色码转字符串 = fourCcUtil.fourCCToString;
const 获取玩家首个英雄 = unitRelated.getPlayerFirstHero;
const YDUserDataGet = YDUserDataGetSafe;
const YDUserDataSet = YDUserDataSetSafe;

function sym(name: string): any {
  return (globalThis as any)[name]
    ?? (jglobals ? (jglobals as any)[name] : null)
    ?? (jass ? (jass as any)[name] : null);
}

function getYDHT(): any {
  return sym("StarBaseHT")
    ?? sym("YDHASH_HANDLE")
    ?? sym("YDHT")
    ?? sym("udg_YDHASH_HANDLE")
    ?? sym("udg_YDHT");
}

export const YDHT = getYDHT();

export let SFB_Unit: any = null;

const SFB_UNIT_ID = 0x6248756E;
const UnitAddAbility = jass["UnitAddAbility"] as (whichUnit: any, abilityId: number) => boolean;
const GetHandleId = jass["GetHandleId"] as (whichHandle: any) => number;
export const IssueTargetOrder = jass["IssueTargetOrder"] as (whichUnit: any, order: string, targetWidget: any) => boolean;
export const IssueTargetOrderById = jass["IssueTargetOrderById"] as (whichUnit: any, order: number, targetWidget: any) => boolean;
const GetUnitX = jass["GetUnitX"] as (whichUnit: any) => number;
const GetUnitY = jass["GetUnitY"] as (whichUnit: any) => number;
const SetUnitX = jass["SetUnitX"] as (whichUnit: any, newX: number) => void;
const SetUnitY = jass["SetUnitY"] as (whichUnit: any, newY: number) => void;
const GetUnitName = jass["GetUnitName"] as (whichUnit: any) => string;
const GetOwningPlayer = jass["GetOwningPlayer"] as (whichUnit: any) => any;
const GetPlayerId = jass["GetPlayerId"] as (whichPlayer: any) => number;
const SFB_已添加技能: Record<number, boolean> = {};

export const ABILITY = {
  STUN: 0x41534230,
  FREEZE: 0x41534234,
  SILENCE: 0x41534238,
  POLYMORPH: 0x41534279,
  INVIS: 0x41534258,
  SLOW: 0x41534239,
  ITEM_ILLUSION: 0x4153494C,
  INNER_FIRE: 0x41534249,
  BLOODLUST: 0x4153424C,
  CRIPPLE: 0x41534243,
  FAERIE_FIRE: 0x41534246,
  CURSE: 0x41534252,
  SLEEP: 0x41534253,
  ENTANGLING_ROOTS: 0x41534254,
  CYCLONE: 0x41534248,
  PARASITE: 0x41534250,
};

export const ORDER = {
  STUN: "thunderbolt",
  FREEZE: "creepthunderbolt",
  SILENCE: "silence",
  POLYMORPH: "polymorph",
  INVIS: "invisibility",
  ITEM_ILLUSION: 852274,
  SLOW: 852075,
  INNER_FIRE: "innerfire",
  BLOODLUST: "bloodlust",
  CRIPPLE: "cripple",
  FAERIE_FIRE: "faeriefire",
  CURSE: "curse",
  SLEEP: "sleep",
  ENTANGLING_ROOTS: "entanglingroots",
  CYCLONE: "cyclone",
  PARASITE: "parasite",
};

export const SFB_增益BUFF = {
  心灵之火: 31,
  嗜血术: 32,
} as const;

export const SFB_负面BUFF = {
  残废: 41,
  精灵之火: 42,
  诅咒: 43,
  睡眠: 44,
  纠缠根须: 45,
  飓风: 46,
  寄生: 47,
} as const;

const SFB_BUFF_ID: Record<number, string> = {
  0: "C001",
  1: "C002",
  2: "C003",
  3: "C004",
  4: "C005",
  5: "C006",
  7: "C007",
  21: "C008",
  22: "C009",
  23: "C010",
  31: "C011",
  32: "C012",
  41: "C013",
  42: "C014",
  43: "C015",
  44: "C016",
  45: "C017",
  46: "C018",
  47: "C024",
};

const NATIVE_BUFF = {
  STUN: 1112560453,
  FREEZE: 1114010234,
  SILENCE: 1112437609,
  POLYMORPH: 1114664057,
  INVIS: 1114205814,
  SLOW: 1114860655,
  INNER_FIRE: 1114205798,
  BLOODLUST: 1113746543,
  CRIPPLE: 1113813609,
  FAERIE_FIRE: 1114005861,
  CURSE: 1113813619,
  SLEEP_MAIN: 1112896364,
  SLEEP_PAUSE: 1112896368,
  SLEEP_STUN: 1114993524,
  ENTANGLING_ROOTS: 1111844210,
  CYCLONE_MAIN: 1113815395,
  CYCLONE_EXTRA: 1113815346,
  PARASITE: 0x424E7061,
  ITEM_ILLUSION: 0x4249696c,
};

const abilityOrderIdCache: Record<number, number> = {};

const SFB_NATIVE_BUFF_IDS: Record<number, number[]> = {
  0: [NATIVE_BUFF.STUN],
  1: [NATIVE_BUFF.FREEZE],
  2: [NATIVE_BUFF.SILENCE],
  3: [NATIVE_BUFF.POLYMORPH],
  4: [NATIVE_BUFF.INVIS],
  5: [NATIVE_BUFF.SILENCE],
  7: [NATIVE_BUFF.SLOW],
  31: [NATIVE_BUFF.INNER_FIRE],
  32: [NATIVE_BUFF.BLOODLUST],
  41: [NATIVE_BUFF.CRIPPLE],
  42: [NATIVE_BUFF.FAERIE_FIRE],
  43: [NATIVE_BUFF.CURSE],
  44: [NATIVE_BUFF.SLEEP_MAIN, NATIVE_BUFF.SLEEP_PAUSE, NATIVE_BUFF.SLEEP_STUN],
  45: [NATIVE_BUFF.ENTANGLING_ROOTS],
  46: [NATIVE_BUFF.CYCLONE_MAIN, NATIVE_BUFF.CYCLONE_EXTRA],
  47: [NATIVE_BUFF.PARASITE],
};

function getBuffDisplaySourceUnit(sourceUnit: any): any {
  if (sourceUnit == null || sourceUnit === 0) return "";
  const owner = GetOwningPlayer(sourceUnit);
  if (owner != null && owner !== 0) {
    const playerId = GetPlayerId(owner);
    if (playerId >= 0 && playerId <= 5) {
      const hero = 获取玩家首个英雄(owner);
      if (hero != null && hero !== 0) return hero;
    }
  }
  return sourceUnit;
}

export function getUnitSourceName(sourceUnit: any, fallbackUnit: any): string {
  let displayUnit = getBuffDisplaySourceUnit(sourceUnit);
  if (displayUnit == null || displayUnit === 0 || displayUnit === "") {
    displayUnit = getBuffDisplaySourceUnit(fallbackUnit);
  }
  if (displayUnit == null || displayUnit === 0) return "";
  const n = GetUnitName(displayUnit);
  return typeof n === "string" && n !== "" ? n : "";
}

export function normalizeRealValue(value: any): number {
  if (value == null || value === false || value === "") return 0;
  const n = typeof value === "number" ? value : Number(value);
  return n !== n ? 0 : n;
}

export function shouldApplyControlReduction(id: number): boolean {
  return id === 0 || id === 1 || id === 2 || id === 5
    || id === SFB_负面BUFF.睡眠
    || id === SFB_负面BUFF.纠缠根须
    || id === SFB_负面BUFF.飓风;
}

export function registerSfbManualBuff(this: void, sourceUnit: any, u: any, id: number, time: number, effectValue: number): void {
  const buffID = SFB_BUFF_ID[id];
  if (buffID == null || buffID === "") return;
  registerManualBuff(u, buffID, time, effectValue, {
    sourceName: getUnitSourceName(sourceUnit, u),
    nativeBuffAbilityIds: SFB_NATIVE_BUFF_IDS[id],
  });
}

export function getSfbBuffId(id: number): string | undefined {
  return SFB_BUFF_ID[id];
}

export function getAngleBetweenUnits(u: any, tu: any): number {
  return jass.Atan2(
    jass.GetUnitY(tu) - jass.GetUnitY(u),
    jass.GetUnitX(tu) - jass.GetUnitX(u)
  );
}

function getAbilityOrderId(abilityId: number, fallbackOrderStr: string | number): number {
  const cached = abilityOrderIdCache[abilityId];
  if (cached != null && cached !== 0) return cached;

  if (typeof fallbackOrderStr === "number" && fallbackOrderStr !== 0) {
    abilityOrderIdCache[abilityId] = fallbackOrderStr;
    return fallbackOrderStr;
  }

  const abilityIdStr = 四色码转字符串(abilityId);
  let orderStr: string | number = abilityIdStr !== "" ? 获取对象属性(物体类型.ABILITY, abilityIdStr, "Order") : "";
  if (orderStr == null || orderStr === "") orderStr = fallbackOrderStr;
  if (orderStr == null || orderStr === "") return 0;
  if (typeof orderStr !== "string") return 0;

  const orderId = 字符串转命令ID(orderStr);
  if (orderId !== 0) abilityOrderIdCache[abilityId] = orderId;
  return orderId;
}

export function SFB_Init(): void {
  if (SFB_Unit != null && SFB_Unit !== 0) return;

  SFB_Unit = jass.CreateUnit(jass.Player(15), SFB_UNIT_ID, 0, 0, 0);

  UnitAddAbility(SFB_Unit, ABILITY.POLYMORPH);
  UnitAddAbility(SFB_Unit, ABILITY.STUN);
  UnitAddAbility(SFB_Unit, ABILITY.SLOW);
  UnitAddAbility(SFB_Unit, ABILITY.SILENCE);
  UnitAddAbility(SFB_Unit, ABILITY.INVIS);
  UnitAddAbility(SFB_Unit, ABILITY.FREEZE);
  UnitAddAbility(SFB_Unit, ABILITY.ITEM_ILLUSION);
  UnitAddAbility(SFB_Unit, ABILITY.PARASITE);
  SFB_已添加技能[ABILITY.POLYMORPH] = true;
  SFB_已添加技能[ABILITY.STUN] = true;
  SFB_已添加技能[ABILITY.SLOW] = true;
  SFB_已添加技能[ABILITY.SILENCE] = true;
  SFB_已添加技能[ABILITY.INVIS] = true;
  SFB_已添加技能[ABILITY.FREEZE] = true;
  SFB_已添加技能[ABILITY.ITEM_ILLUSION] = true;
  SFB_已添加技能[ABILITY.PARASITE] = true;

  (globalThis as any).SFB_Unit = SFB_Unit;
}

function SFB_确保马甲技能(this: void, abilityId: number): boolean {
  if (SFB_已添加技能[abilityId]) return true;
  const caster = SFB_Unit;
  if (caster == null || caster === 0) return false;
  if (!UnitAddAbility(caster, abilityId)) return false;
  SFB_已添加技能[abilityId] = true;
  return true;
}

export function SFB_施加原生目标Buff(this: void, sourceUnit: any, u: any, id: number, time: number, abilityId: number, orderStr: string): void {
  if (!SUC_IsValidUnit(u) || time <= 0) return;
  if (SUC_IsUnitStructure(u)) return;
  if (u === SFB_Unit) return;

  const caster = SFB_Unit;
  if (caster == null || caster === 0) return;
  if (!SFB_确保马甲技能(abilityId)) return;

  const fac = getAngleBetweenUnits(caster, u);
  EXSetUnitFacing(caster, fac);
  jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac);
  SetUnitX(caster, GetUnitX(u));
  SetUnitY(caster, GetUnitY(u));

  YDWESetUnitAbilityDataReal(caster, abilityId, 1, 102, time);
  YDWESetUnitAbilityDataReal(caster, abilityId, 1, 103, time);
  if (abilityId === ABILITY.PARASITE) {
    YDWESetUnitAbilityDataReal(caster, abilityId, 1, 105, 0);
    YDWESetUnitAbilityDataReal(caster, abilityId, 1, 107, 999999);
  }

  registerSfbManualBuff(sourceUnit, u, id, time, 0);

  IssueTargetOrder(caster, orderStr, u);
}

export function SFB_施加原生目标技能(this: void, u: any, abilityId: number, orderStr: string | number, 持续时间: number = 0): boolean {
  if (!SUC_IsValidUnit(u)) return false;
  if (SUC_IsUnitStructure(u)) return false;
  if (u === SFB_Unit) return false;

  const caster = SFB_Unit;
  if (caster == null || caster === 0) return false;
  if (!SFB_确保马甲技能(abilityId)) return false;

  const fac = getAngleBetweenUnits(caster, u);
  EXSetUnitFacing(caster, fac);
  jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac);

  if (持续时间 > 0) {
    YDWESetUnitAbilityDataReal(caster, abilityId, 1, 102, 持续时间);
    YDWESetUnitAbilityDataReal(caster, abilityId, 1, 103, 持续时间);
  }

  const orderId = getAbilityOrderId(abilityId, orderStr);
  if (orderId !== 0) return IssueTargetOrderById(caster, orderId, u) === true;
  return typeof orderStr === "string" ? IssueTargetOrder(caster, orderStr, u) === true : false;
}

export function SFB_施加暂停类Buff(this: void, sourceUnit: any, u: any, id: number, time: number): void {
  registerSfbManualBuff(sourceUnit, u, id, time, 0);
  if (id === 21) {
    GS_Suspend(u, time);
  } else if (id === 22) {
    申请单位暂停占用定时(u, "SFB_Pause", time, "刷新");
  } else if (id === 23) {
    申请单位暂停占用定时(u, "SFB_EXPause", time, "刷新");
  }
}

SFB_Init();

export {
  EXSetUnitFacing,
  GetPlayerId,
  GetOwningPlayer,
  GS_Suspend,
  SUC_IsUnitStructure,
  SUC_IsValidUnit,
  YDWESetUnitAbilityDataReal,
  calcReducedControlDuration,
  japi,
  jass,
  jglobals,
  registerManualBuff,
  safeDestroyTimer,
  safeTimerStart,
};
