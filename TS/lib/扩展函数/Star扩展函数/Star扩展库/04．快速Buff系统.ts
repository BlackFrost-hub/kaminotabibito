/**
 * Star扩展库 - 快速Buff系统
 *
 * 提供快速施加控制效果的功能，支持击晕、冰冻、沉默、变形、隐身、缴械等。
 * 需要预先创建马甲单位 SFB_Unit 和相关技能。
 *
 * 所有接口均接受 sourceUnit（来源单位）参数，用于在 BuffUI 中显示来源信息：
 * - sourceName：来源单位名称
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jglobals = require("jass.globals") as any;

import { YDWESetUnitAbilityDataReal, EXSetUnitFacing } from "../../YDWE函数/00．YDWE函数";
import { GS_Suspend } from "./03．硬直暂停系统";

const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};

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

const YDHT = getYDHT();

export let SFB_Unit: any = null;

const SFB_UNIT_ID = 0x6253756E;

const ABILITY = {
  STUN: 0x41534230,
  FREEZE: 0x41534234,
  SILENCE: 0x41534238,
  POLYMORPH: 0x41534279,
  INVIS: 0x41534258,
  SLOW: 0x41534239,
};

const ORDER = {
  STUN: "thunderbolt",
  FREEZE: "creepthunderbolt",
  SILENCE: "silence",
  POLYMORPH: "polymorph",
  INVIS: "invisibility",
  SLOW: 852075,
};

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
};

function getUnitSourceName(sourceUnit: any): string {
  if (sourceUnit == null || sourceUnit === 0) return "";
  if (typeof jass.GetUnitName !== "function") return "";
  const n = jass.GetUnitName(sourceUnit);
  return typeof n === "string" && n !== "" ? n : "";
}

function getAngleBetweenUnits(u: any, tu: any): number {
  return jass.Atan2(
    jass.GetUnitY(tu) - jass.GetUnitY(u),
    jass.GetUnitX(tu) - jass.GetUnitX(u)
  );
}

export function SFB_Init(): void {
  SFB_Unit = jass.CreateUnit(jass.Player(15), SFB_UNIT_ID, 0, 0, 0);

  jass.UnitAddAbility(SFB_Unit, ABILITY.POLYMORPH);
  jass.UnitAddAbility(SFB_Unit, ABILITY.STUN);
  jass.UnitAddAbility(SFB_Unit, ABILITY.SLOW);
  jass.UnitAddAbility(SFB_Unit, ABILITY.SILENCE);
  jass.UnitAddAbility(SFB_Unit, ABILITY.INVIS);
  jass.UnitAddAbility(SFB_Unit, ABILITY.FREEZE);

  (globalThis as any).SFB_Unit = SFB_Unit;
}

/**
 * 设置单位Buff效果
 * @param sourceUnit 来源单位（用于BuffUI显示来源信息和玩家名）
 * @param u 目标单位
 * @param id Buff类型：
 *   0=击晕, 1=冰冻, 2=沉默, 3=变形, 4=隐身, 5=缴械
 *   21=硬直, 22=暂停, 23=EX暂停
 * @param time 持续时间（秒）
 */
export function SFB_setBuff(sourceUnit: any, u: any, id: number, time: number): void {
  if (u == null || u === 0 || time === 0) return;
  if (jass.IsUnitType(u, jass.UNIT_TYPE_STRUCTURE)) return;
  if (u === SFB_Unit) return;

  if (time <= 0) return;

  const sourceName = getUnitSourceName(sourceUnit);

  if (id >= 21) {
    const buffID = SFB_BUFF_ID[id];
    if (buffID != null && buffID !== "") {
      registerManualBuff(u, buffID, time, 0, { sourceName });
    }
    if (id === 21) {
      GS_Suspend(u, time);
    } else if (id === 22) {
      const tempTimer = jass.CreateTimer();
      jass.SaveUnitHandle(YDHT, jass.GetHandleId(tempTimer), jass.StringHash("单位"), u);
      jass.PauseUnit(u, true);
      jass.TimerStart(tempTimer, time, false, () => {
        const t = jass.GetExpiredTimer();
        jass.PauseUnit(jass.LoadUnitHandle(YDHT, jass.GetHandleId(t), jass.StringHash("单位")), false);
        jass.RemoveSavedHandle(YDHT, jass.GetHandleId(t), jass.StringHash("单位"));
        jass.DestroyTimer(t);
      });
    } else if (id === 23) {
      const tempTimer = jass.CreateTimer();
      jass.SaveUnitHandle(YDHT, jass.GetHandleId(tempTimer), jass.StringHash("单位"), u);
      if (typeof japi.EXPauseUnit === "function") {
        japi.EXPauseUnit(u, true);
      }
      jass.TimerStart(tempTimer, time, false, () => {
        const t = jass.GetExpiredTimer();
        if (typeof japi.EXPauseUnit === "function") {
          japi.EXPauseUnit(jass.LoadUnitHandle(YDHT, jass.GetHandleId(t), jass.StringHash("单位")), false);
        }
        jass.RemoveSavedHandle(YDHT, jass.GetHandleId(t), jass.StringHash("单位"));
        jass.DestroyTimer(t);
      });
    }
    return;
  }

  const caster = SFB_Unit;
  if (caster == null || caster === 0) return;

  const fac = getAngleBetweenUnits(caster, u);
  EXSetUnitFacing(caster, fac);
  jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac);

  let abilityId: number;
  let orderStr: string | number;

  switch (id) {
    case 0:
      abilityId = ABILITY.STUN;
      orderStr = ORDER.STUN;
      break;
    case 1:
      abilityId = ABILITY.FREEZE;
      orderStr = ORDER.FREEZE;
      break;
    case 2:
      abilityId = ABILITY.SILENCE;
      orderStr = ORDER.SILENCE;
      YDWESetUnitAbilityDataReal(caster, abilityId, 1, 108, 8);
      break;
    case 3:
      abilityId = ABILITY.POLYMORPH;
      orderStr = ORDER.POLYMORPH;
      break;
    case 4:
      abilityId = ABILITY.INVIS;
      orderStr = ORDER.INVIS;
      break;
    case 5:
      abilityId = ABILITY.SILENCE;
      orderStr = ORDER.SILENCE;
      YDWESetUnitAbilityDataReal(caster, abilityId, 1, 108, 7);
      break;
    default:
      return;
  }

  YDWESetUnitAbilityDataReal(caster, abilityId, 1, 102, time);
  YDWESetUnitAbilityDataReal(caster, abilityId, 1, 103, time);

  const buffID = SFB_BUFF_ID[id];
  if (buffID != null && buffID !== "") {
    registerManualBuff(u, buffID, time, 0, { sourceName });
  }

  if (typeof orderStr === "string") {
    jass.IssueTargetOrder(caster, orderStr, u);
  } else {
    jass.IssueTargetOrderById(caster, orderStr, u);
  }
}

/**
 * 设置单位减速效果
 * @param sourceUnit 来源单位（用于BuffUI显示来源信息和玩家名）
 * @param u 目标单位
 * @param as 降低攻速百分比
 * @param ms 降低移速百分比
 * @param time 持续时间（秒）
 */
export function SFB_setSlow(sourceUnit: any, u: any, as: number, ms: number, time: number): void {
  if (u == null || u === 0 || time === 0) return;
  if (jass.IsUnitType(u, jass.UNIT_TYPE_STRUCTURE)) return;
  if (u === SFB_Unit) return;

  if (time <= 0) return;

  const caster = SFB_Unit;
  if (caster == null || caster === 0) return;

  const fac = getAngleBetweenUnits(caster, u);
  EXSetUnitFacing(caster, fac);
  jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac);

  YDWESetUnitAbilityDataReal(caster, ABILITY.SLOW, 1, 108, ms);
  YDWESetUnitAbilityDataReal(caster, ABILITY.SLOW, 1, 109, as);
  YDWESetUnitAbilityDataReal(caster, ABILITY.SLOW, 1, 102, time);
  YDWESetUnitAbilityDataReal(caster, ABILITY.SLOW, 1, 103, time);

  const sourceName = getUnitSourceName(sourceUnit);
  registerManualBuff(u, "C007", time, ms, { sourceName });

  jass.IssueTargetOrderById(caster, ORDER.SLOW, u);
}

export {};
