/** @noSelfInFile */

import { 提米诺斯单位技能配置 } from "./00．配置";
import { 播放提米诺斯单位音效 } from "./00A．表现工具";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, unit: any, abilityId: number) => void) => void;
};
const {
  计算最终魔法消耗,
  getAbilityManaCost,
  getAbilityPercentCost,
  getManaCostReduction,
} = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还") as {
  计算最终魔法消耗: (this: void, unit: any, abilityId: number, level: number) => number;
  getAbilityManaCost: (this: void, unit: any, abilityId: number, level: number) => number;
  getAbilityPercentCost: (this: void, unit: any, abilityId: number, level: number) => number;
  getManaCostReduction: (this: void, unit: any) => number;
};
const { spellHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  spellHeal: (this: void, source: any, target: any, amount: number, showEffect?: boolean) => number;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    缩放?: number;
    持续秒?: number;
  }) => any;
};

const Q技能ID = stringToFourCCSafe(提米诺斯单位技能配置.Q技能ID);
const 提米诺斯单位类型ID = stringToFourCCSafe(提米诺斯单位技能配置.单位类型ID);

function 取有效魔耗(this: void, caster: any, level: number): number {
  const fixedCost = getAbilityManaCost(caster, Q技能ID, level);
  const percentCost = getAbilityPercentCost(caster, Q技能ID, level);
  const maxMana = japi.GetUnitState(caster, jass.UNIT_STATE_MAX_MANA) as number;
  const reduction = getManaCostReduction(caster);
  const reductionRatio = reduction < 0 ? -reduction : reduction;
  const calculatedCost = 计算最终魔法消耗(caster, Q技能ID, level);
  let cost = calculatedCost;

  // 公共计算无法识别物编字段时，按源 JASS 的同一公式回退，避免整个技能静默失效。
  if (!(cost >= 0) && fixedCost >= 0 && percentCost >= 0 && percentCost < 0.9) {
    const rawCost = fixedCost + maxMana * percentCost;
    cost = reductionRatio < 1 ? rawCost * (1 - reductionRatio) : 0;
  }

  return cost;
}

function on提米诺斯Q(this: void, caster: any, abilityId: number): void {
  if (abilityId !== Q技能ID) return;
  const casterTypeId = jass.GetUnitTypeId(caster) as number;
  if (casterTypeId !== 提米诺斯单位类型ID) return;

  const cfg = 提米诺斯单位技能配置.Q;
  const level = jass.GetUnitAbilityLevel(caster, Q技能ID) as number;
  播放提米诺斯单位音效(caster, cfg.全局音效键);
  const casterX = jass.GetUnitX(caster) as number;
  const casterY = jass.GetUnitY(caster) as number;
  创建点特效({
    模型路径: cfg.主体特效模型,
    X: casterX,
    Y: casterY,
    Z: cfg.主体特效Z,
    缩放: cfg.主体特效缩放,
    持续秒: cfg.主体特效持续秒,
  });
  const cost = 取有效魔耗(caster, level);
  if (!(cost > 0)) return;

  const owner = jass.GetOwningPlayer(caster);
  const units = getUnitsInRange(casterX, casterY, cfg.范围);
  for (let i = 0; i < units.length; i++) {
    const target = units[i];
    const currentLife = jass.GetUnitState(target, jass.UNIT_STATE_LIFE) as number;
    const maxLife = japi.GetUnitState(target, jass.UNIT_STATE_MAX_LIFE) as number;
    if (target !== caster && jass.IsUnitAlly(target, owner) !== true) continue;
    if (!(currentLife > 0.405)) continue;
    if (jass.IsUnitType(target, jass.UNIT_TYPE_ANCIENT) === true) continue;
    if (jass.IsUnitType(target, jass.UNIT_TYPE_MECHANICAL) === true) continue;
    if (jass.IsUnitType(target, jass.UNIT_TYPE_STRUCTURE) === true) continue;
    if (currentLife >= maxLife) continue;

    spellHeal(caster, target, cost * cfg.实际魔耗治疗倍率, false);
    for (let j = 0; j < cfg.特效.length; j++) {
      const effectCfg = cfg.特效[j];
      const effect = jass.AddSpecialEffectTarget(effectCfg.模型, target, effectCfg.挂点);
      if (effect != null) {
        YDWETimerDestroyEffectSafe(cfg.特效持续秒, effect);
      }
    }
  }
}

registerSpellEffectListener(on提米诺斯Q);

export {};
