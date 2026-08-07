/** @noSelfInFile */
/**
 * Star扩展库 - 快速Buff系统接口层
 *
 * 放这里的内容：
 * - 对外 API
 * - Buff 类型分发
 * - 技能侧建议直接引用这一层或 `04．快速Buff系统.ts`
 */

import {
  ABILITY,
  EXSetUnitFacing,
  IssueTargetOrder,
  IssueTargetOrderById,
  ORDER,
  SFB_Init,
  SFB_施加原生目标技能,
  SFB_Unit,
  SFB_增益BUFF,
  SFB_施加原生目标Buff,
  SFB_施加暂停类Buff,
  SFB_负面BUFF,
  SUC_IsUnitStructure,
  SUC_IsValidUnit,
  YDWESetUnitAbilityDataReal,
  calcReducedControlDuration,
  getAngleBetweenUnits,
  jass,
  jglobals,
  registerSfbManualBuff,
  shouldApplyControlReduction,
} from "./04A．快速Buff共享";
import { SFB_施加自定义诅咒Buff } from "./04C．快速Buff诅咒";
import { initItemIllusionSummonBridge, SFB_清空幻象物品上下文, SFB_记录幻象物品上下文 } from "./04D．快速Buff幻象物品";

const { 施加睡眠 } = require("系统.05．Buff系统.07．睡眠系统") as {
  施加睡眠: (this: void, 参数: { 来源单位?: any; 目标单位: any; 持续时间: number; 伤害阈值?: number; 保底时间?: number }) => boolean;
};

export { SFB_增益BUFF, SFB_负面BUFF, SFB_Unit, SFB_Init };

initItemIllusionSummonBridge();

export function SFB_setPositiveBuff(
  sourceUnit: any,
  u: any,
  id: number,
  time: number,
  effectSourceName?: string,
  effectSourceType?: "装备" | "技能"
): void {
  if (id === SFB_增益BUFF.心灵之火) {
    SFB_施加原生目标Buff(sourceUnit, u, id, time, ABILITY.INNER_FIRE, ORDER.INNER_FIRE, effectSourceName, effectSourceType);
  } else if (id === SFB_增益BUFF.嗜血术) {
    SFB_施加原生目标Buff(sourceUnit, u, id, time, ABILITY.BLOODLUST, ORDER.BLOODLUST, effectSourceName, effectSourceType);
  }
}

export function SFB_setNegativeBuff(
  sourceUnit: any,
  u: any,
  id: number,
  time: number,
  effectSourceName?: string,
  effectSourceType?: "装备" | "技能"
): void {
  if (shouldApplyControlReduction(id)) {
    time = calcReducedControlDuration(u, time);
    if (time <= 0) return;
  }

  if (id === SFB_负面BUFF.残废) {
    SFB_施加原生目标Buff(sourceUnit, u, id, time, ABILITY.CRIPPLE, ORDER.CRIPPLE, effectSourceName, effectSourceType);
  } else if (id === SFB_负面BUFF.精灵之火) {
    SFB_施加原生目标Buff(sourceUnit, u, id, time, ABILITY.FAERIE_FIRE, ORDER.FAERIE_FIRE, effectSourceName, effectSourceType);
  } else if (id === SFB_负面BUFF.诅咒) {
    SFB_施加自定义诅咒Buff(sourceUnit, u, time, effectSourceName, effectSourceType);
  } else if (id === SFB_负面BUFF.睡眠) {
    施加睡眠({ 来源单位: sourceUnit, 目标单位: u, 持续时间: time });
  } else if (id === SFB_负面BUFF.纠缠根须) {
    SFB_施加原生目标Buff(sourceUnit, u, id, time, ABILITY.ENTANGLING_ROOTS, ORDER.ENTANGLING_ROOTS, effectSourceName, effectSourceType);
  } else if (id === SFB_负面BUFF.飓风) {
    SFB_施加原生目标Buff(sourceUnit, u, id, time, ABILITY.CYCLONE, ORDER.CYCLONE, effectSourceName, effectSourceType);
  } else if (id === SFB_负面BUFF.寄生) {
    SFB_施加原生目标Buff(sourceUnit, u, id, time, ABILITY.PARASITE, ORDER.PARASITE, effectSourceName, effectSourceType);
  }
}

export function SFB_setInnerFire(sourceUnit: any, u: any, time: number): void {
  SFB_setPositiveBuff(sourceUnit, u, SFB_增益BUFF.心灵之火, time);
}

export function SFB_setBloodlust(sourceUnit: any, u: any, time: number): void {
  SFB_setPositiveBuff(sourceUnit, u, SFB_增益BUFF.嗜血术, time);
}

export function SFB_setCripple(sourceUnit: any, u: any, time: number): void {
  SFB_setNegativeBuff(sourceUnit, u, SFB_负面BUFF.残废, time);
}

export function SFB_setFaerieFire(sourceUnit: any, u: any, time: number): void {
  SFB_setNegativeBuff(sourceUnit, u, SFB_负面BUFF.精灵之火, time);
}

export function SFB_setCurse(
  sourceUnit: any,
  u: any,
  time: number,
  effectSourceName?: string,
  effectSourceType?: "装备" | "技能"
): void {
  SFB_setNegativeBuff(sourceUnit, u, SFB_负面BUFF.诅咒, time, effectSourceName, effectSourceType);
}

export function SFB_setSleep(sourceUnit: any, u: any, time: number): void {
  SFB_setNegativeBuff(sourceUnit, u, SFB_负面BUFF.睡眠, time);
}

export function SFB_setEntanglingRoots(sourceUnit: any, u: any, time: number): void {
  SFB_setNegativeBuff(sourceUnit, u, SFB_负面BUFF.纠缠根须, time);
}

export function SFB_setCyclone(sourceUnit: any, u: any, time: number): void {
  SFB_setNegativeBuff(sourceUnit, u, SFB_负面BUFF.飓风, time);
}

export function SFB_setParasite(sourceUnit: any, u: any, time: number): void {
  SFB_setNegativeBuff(sourceUnit, u, SFB_负面BUFF.寄生, time);
}

/**
 * 对目标施放“幻象物品”技能。
 *
 * 这不是 Buff，不进入 BuffUI，也不占用现有快速 Buff 类型编号。
 * 默认持续时间 15 秒；如果母技能字段可被正常读取，会同步写入普通/英雄持续时间。
 */
export function SFB_setItemIllusion(sourceUnit: any, u: any, time: number = 15): boolean {
  SFB_记录幻象物品上下文(sourceUnit, u, time);
  const ok = SFB_施加原生目标技能(u, ABILITY.ITEM_ILLUSION, ORDER.ITEM_ILLUSION, time);
  if (!ok) SFB_清空幻象物品上下文();
  return ok;
}

/**
 * 快速 Buff 通用入口。
 *
 * 参数顺序固定为：来源单位 -> 目标单位 -> Buff类型 -> 持续时间。
 * 后续技能优先用这个函数，避免直接调用 `SFB_setBuff(null, ...)` 导致 BuffUI 来源显示为“未知”。
 */
export function SFB_施加通用Buff(来源单位: any, 目标单位: any, Buff类型: number, 持续时间: number): void {
  SFB_setBuff(来源单位, 目标单位, Buff类型, 持续时间);
}

export function SFB_setBuff(
  sourceUnit: any,
  u: any,
  id: number,
  time: number,
  effectSourceName?: string,
  effectSourceType?: "装备" | "技能"
): void {
  if (!SUC_IsValidUnit(u) || !(time > 0)) return;
  if (SUC_IsUnitStructure(u)) return;
  if (u === SFB_Unit) return;

  if (id === SFB_增益BUFF.心灵之火 || id === SFB_增益BUFF.嗜血术) {
    SFB_setPositiveBuff(sourceUnit, u, id, time, effectSourceName, effectSourceType);
    return;
  }
  if (
    id === SFB_负面BUFF.残废
    || id === SFB_负面BUFF.精灵之火
    || id === SFB_负面BUFF.诅咒
    || id === SFB_负面BUFF.睡眠
    || id === SFB_负面BUFF.纠缠根须
    || id === SFB_负面BUFF.飓风
    || id === SFB_负面BUFF.寄生
  ) {
    SFB_setNegativeBuff(sourceUnit, u, id, time, effectSourceName, effectSourceType);
    return;
  }

  if (shouldApplyControlReduction(id)) {
    time = calcReducedControlDuration(u, time);
    if (!(time > 0)) return;
  }

  if (id >= 21) {
    SFB_施加暂停类Buff(sourceUnit, u, id, time, effectSourceName, effectSourceType);
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
  registerSfbManualBuff(sourceUnit, u, id, time, 0, effectSourceName, effectSourceType);

  if (typeof orderStr === "string") {
    IssueTargetOrder(caster, orderStr, u);
  } else {
    IssueTargetOrderById(caster, orderStr, u);
  }
}

export function SFB_setSlow(
  sourceUnit: any,
  u: any,
  as: number,
  ms: number,
  time: number,
  effectSourceName?: string,
  effectSourceType?: "装备" | "技能",
  displayBuffID?: string,
): void {
  if (!SUC_IsValidUnit(u) || !(time > 0)) return;
  if (SUC_IsUnitStructure(u)) return;
  if (u === SFB_Unit) return;
  if (!(time > 0)) return;

  const caster = SFB_Unit;
  if (caster == null || caster === 0) return;

  const fac = getAngleBetweenUnits(caster, u);
  EXSetUnitFacing(caster, fac);
  jass.SetUnitFacing(caster, jglobals.bj_RADTODEG * fac);

  YDWESetUnitAbilityDataReal(caster, ABILITY.SLOW, 1, 108, ms);
  YDWESetUnitAbilityDataReal(caster, ABILITY.SLOW, 1, 109, as);
  YDWESetUnitAbilityDataReal(caster, ABILITY.SLOW, 1, 102, time);
  YDWESetUnitAbilityDataReal(caster, ABILITY.SLOW, 1, 103, time);

  registerSfbManualBuff(sourceUnit, u, 7, time, ms, effectSourceName, effectSourceType, displayBuffID);
  IssueTargetOrderById(caster, ORDER.SLOW, u);
}
