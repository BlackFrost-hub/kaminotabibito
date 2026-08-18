/** @noSelfInFile */

import { 教派剑士单位技能配置 } from './00．配置';
import { 获取或创建教派剑士上下文, 教派剑士单位存活 } from './01．运行时上下文';
import { 教派剑士技能配置 } from './02．数值与表现配置';
import { 执行Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 教派剑士BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/11．教派剑士';

const { registerAppliedFinalDamageListener } = require('系统.04．伤害系统.00．伤害计算.04．主计算流程') as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 执行暴击判定 } = require('系统.04．伤害系统.06．暴击系统.01．暴击核心') as {
  执行暴击判定: (this: void, context: any) => { 伤害: number; 暴击概率: number; 暴击倍率: number; 是否暴击: boolean };
};
const { removeDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  removeDelayedCallback: (this: void, callbackId: number) => void;
};
const { 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { doHeal } = require('系统.04．伤害系统.02．治疗系统.01．核心功能') as {
  doHeal: (this: void, params: any) => number;
};
const 英雄主属性普通版 = require('lib.扩展函数.Star扩展函数.Star扩展库.10．英雄属性与攻击力函数') as {
  SU_GetHeroParmary: (this: void, unit: any) => number;
  PRIMARY_STR: number;
};
const 读取英雄主属性普通版 = 英雄主属性普通版.SU_GetHeroParmary;
const 力量主属性类型 = 英雄主属性普通版.PRIMARY_STR;
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require('jass.common') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 教派剑士单位类型ID = stringToFourCCSafe(教派剑士单位技能配置.单位ID);
const 黑魔法侵蚀附加伤害标签 = 教派剑士技能配置.黑魔法侵蚀.附加伤害标签;
const 黑洞强化普攻伤害标签 = 教派剑士技能配置.黑洞跨越.强化普攻标签;
let 黑魔法侵蚀已注册 = false;

function 读取英雄主属性(this: void, unit: any): number {
  return 读取英雄主属性普通版(unit);
}

function on教派剑士普通攻击最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !教派剑士单位存活(attacker) || GetUnitTypeId(attacker) !== 教派剑士单位类型ID) return;
  if (snapshot?.skillDamageTag === 黑洞强化普攻伤害标签) {
    const 治疗量 = applied * 教派剑士技能配置.黑洞跨越.强化普攻治疗比例;
    const 实际治疗 = doHeal({ HealSource: attacker, HealTarget: attacker, HealAmount: 治疗量, ItemHeal: false, HealEffect: true });
    debugLogForce('教派剑士-黑洞跨越', '强化普攻按最终伤害治疗', 'bossHid=', GetHandleId(attacker), 'targetHid=', target != null && target !== 0 ? GetHandleId(target) : 0, 'applied=', applied, 'heal=', 实际治疗);
    return;
  }
  if (!教派剑士单位存活(target) || snapshot?.isNormalAttack !== true) return;
  const 上下文 = 获取或创建教派剑士上下文(attacker);
  if (上下文 == null || 上下文.黑魔法侵蚀递归锁) return;
  const 应消费强化普攻 = 上下文.黑洞强化普攻就绪;
  if (应消费强化普攻) {
    if (上下文.黑洞强化普攻清除回调ID !== 0) removeDelayedCallback(上下文.黑洞强化普攻清除回调ID);
    上下文.黑洞强化普攻清除回调ID = 0;
    上下文.黑洞强化普攻就绪 = false;
    移除单位指定Buff(attacker, 教派剑士BuffID.黑洞强化普攻);
    debugLogForce('教派剑士-黑洞跨越', '首次成功普通攻击消费强化状态', 'bossHid=', GetHandleId(attacker), 'targetHid=', GetHandleId(target), 'originalApplied=', applied);
  }
  const 主属性类型 = 读取英雄主属性(target);
  const 伤害比例 = 主属性类型 === 力量主属性类型
    ? 教派剑士技能配置.黑魔法侵蚀.力量英雄目标最大生命比例
    : 教派剑士技能配置.黑魔法侵蚀.其他目标最大生命比例;
  上下文.黑魔法侵蚀递归锁 = true;
  if (应消费强化普攻) {
    const 强化结果 = 执行Boss单体技能伤害({
      来源: attacker,
      目标: target,
      伤害公式: { 来源攻击力比例: 教派剑士技能配置.黑洞跨越.强化普攻Boss攻击力比例 },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: 黑洞强化普攻伤害标签,
    });
    debugLogForce('教派剑士-黑洞跨越', '强化普攻附加暗伤提交', 'bossHid=', GetHandleId(attacker), 'targetHid=', GetHandleId(target), 'damage=', 强化结果.伤害, 'submitted=', 强化结果.是否造成伤害);
  }
  const 结果 = 执行Boss单体技能伤害({
    来源: attacker,
    目标: target,
    伤害公式: { 目标最大生命比例: 伤害比例 },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: 黑魔法侵蚀附加伤害标签,
    参与技能伤害加成: false,
  });
  上下文.黑魔法侵蚀递归锁 = false;
  debugLogForce('教派剑士-黑魔法侵蚀', '普通攻击附加暗魔法伤害结算', 'bossHid=', GetHandleId(attacker), 'targetHid=', GetHandleId(target), 'originalApplied=', applied, 'primaryType=', 主属性类型, 'ratio=', 伤害比例, 'damage=', 结果.伤害, 'submitted=', 结果.是否造成伤害);
}

function 教派剑士黑魔法暴击修正(this: void, context: any): number {
  if (context == null) return 0;
  const currentDamage = context.currentDamage;
  const attacker = context.attacker;
  if (attacker == null || attacker === 0 || GetUnitTypeId(attacker) !== 教派剑士单位类型ID) return currentDamage;
  if (context.isMagicDamage !== true || context.isNormalAttack === true || context.isSkillAttack === true) return currentDamage;
  if (context.skillDamageTag === 黑魔法侵蚀附加伤害标签) {
    debugLogForce('教派剑士-黑魔法侵蚀', '附加暗伤明确跳过黑魔法法术暴击', 'bossHid=', GetHandleId(attacker), 'damage=', currentDamage);
    return currentDamage;
  }
  const 暴击结果 = 执行暴击判定({
    attacker,
    target: context.target,
    currentDamage,
    isPhysicalDamage: context.isPhysicalDamage === true,
    isEnhancedDamage: context.isEnhancedDamage === true,
    isNormalAttack: false,
    isRangedAttack: context.isRangedAttack === true,
    isSkillAttack: true,
  });
  if (暴击结果.是否暴击) {
    debugLogForce('教派剑士-黑魔法侵蚀', '黑魔法伤害法术暴击成功', 'bossHid=', GetHandleId(attacker), 'targetHid=', context.target != null && context.target !== 0 ? GetHandleId(context.target) : 0, 'before=', currentDamage, 'after=', 暴击结果.伤害, 'multiplier=', 暴击结果.暴击倍率);
  }
  return 暴击结果.伤害;
}

export function 注册教派剑士黑魔法侵蚀(this: void): void {
  if (黑魔法侵蚀已注册) return;
  黑魔法侵蚀已注册 = true;
  registerAppliedFinalDamageListener(on教派剑士普通攻击最终伤害);
  registerDamageModifier(教派剑士黑魔法暴击修正, 教派剑士技能配置.黑魔法侵蚀.黑魔法暴击修正器优先级);
}
