/** @noSelfInFile */

import { 教派剑士单位技能配置 } from './00．配置';
import { 获取或创建教派剑士上下文, 教派剑士单位存活, type 教派剑士运行时上下文 } from './01．运行时上下文';
import { 教派剑士技能配置, 教派剑士音效配置 } from './02．数值与表现配置';
import { 播放教派剑士台词 } from './11．台词播放';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 读取单位最大生命 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 执行非伤害生命移除 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/09．非伤害生命移除';
import { 教派剑士BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/11．教派剑士';

const { registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerAppliedFinalDamageListener } = require('系统.04．伤害系统.00．伤害计算.04．主计算流程') as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback, getGameDifficulty } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  getGameDifficulty: (this: void) => number;
};
const { 取当前有效玩家人数 } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数') as {
  取当前有效玩家人数: (this: void) => number;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 开始硬直, 单位是否处于硬控制效果合集, 施加快速控制Buff } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
  单位是否处于硬控制效果合集: (this: void, unit: any) => boolean;
  施加快速控制Buff: (this: void, source: any, target: any, controlId: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { doHeal } = require('系统.04．伤害系统.02．治疗系统.01．核心功能') as {
  doHeal: (this: void, params: any) => number;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { Sound3DII_CooPlayReuse } = require('lib.扩展函数.封装函数.02．音效系统.03．3D音效播放') as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 魔祭吸魂状态 {
  已结束: boolean;
  已反噬: boolean;
  上下文: 教派剑士运行时上下文;
  阶段: '施法' | '生效' | '结束';
  累计最终伤害: number;
}

const 教派剑士单位类型ID = stringToFourCCSafe(教派剑士单位技能配置.单位ID);
const 魔祭吸魂技能ID = stringToFourCCSafe(教派剑士单位技能配置.技能ID.魔祭吸魂);
let 魔祭吸魂已注册 = false;

function 结束魔祭吸魂(this: void, 状态: 魔祭吸魂状态, 原因: string): void {
  if (状态.已结束) return;
  状态.已结束 = true;
  状态.阶段 = '结束';
  const boss = 状态.上下文.Boss单位;
  移除单位指定Buff(boss, 教派剑士BuffID.魔祭吸魂);
  关闭吟唱条(教派剑士技能配置.魔祭吸魂.读条通道);
  if (状态.上下文.魔祭状态 === 状态) 状态.上下文.魔祭状态 = undefined;
  debugLogForce('教派剑士-魔祭吸魂', '状态结束', 'bossHid=', boss != null && boss !== 0 ? GetHandleId(boss) : 0, 'reason=', 原因, 'accumulatedApplied=', 状态.累计最终伤害);
}

function on魔祭吸魂清理(this: void, variable?: any): void {
  const 状态 = variable as 魔祭吸魂状态 | undefined;
  if (状态 != null) 结束魔祭吸魂(状态, '上下文清理');
}

function 施加无视韧性眩晕(this: void, boss: any, duration: number): void {
  const 原韧性 = Number(YDUserDataGetSafe('unit', boss, '眩晕抗性', 'real')) || 0;
  YDUserDataSetSafe('unit', boss, '眩晕抗性', 'real', 0);
  施加快速控制Buff(boss, boss, 0, duration, '教派剑士-魔祭吸魂反噬', '技能');
  YDUserDataSetSafe('unit', boss, '眩晕抗性', 'real', 原韧性);
}

function 触发魔祭反噬(this: void, 状态: 魔祭吸魂状态, attacker: any): void {
  if (状态.已结束 || 状态.已反噬) return;
  状态.已反噬 = true;
  const boss = 状态.上下文.Boss单位;
  const 配置 = 教派剑士技能配置.魔祭吸魂;
  const difficulty = getGameDifficulty() > 0 ? getGameDifficulty() : 1;
  const ratio = 配置.反噬最大生命基础比例 - 配置.每难度降低反噬比例 * difficulty;
  Sound3DII_CooPlayReuse(教派剑士音效配置.魔祭吸魂.反噬, GetUnitX(boss), GetUnitY(boss), 0, 教派剑士音效配置.音效裁断距离);
  结束魔祭吸魂(状态, '受到火/光伤害反噬');
  执行非伤害生命移除({
    目标: boss,
    数值: 读取单位最大生命(boss) * ratio,
    不致死: false,
    显示文字: false,
    显示特效: false,
  });
  if (教派剑士单位存活(boss)) 施加无视韧性眩晕(boss, 配置.反噬眩晕秒);
  debugLogForce('教派剑士-魔祭吸魂', '火/光反噬触发一次', 'bossHid=', GetHandleId(boss), 'attackerHid=', attacker != null && attacker !== 0 ? GetHandleId(attacker) : 0, 'ratio=', ratio, 'stun=', 配置.反噬眩晕秒);
}

function on魔祭吸魂最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0)) return;
  if (attacker != null && attacker !== 0 && GetUnitTypeId(attacker) === 教派剑士单位类型ID && snapshot?.skillDamageTag === 教派剑士技能配置.魔祭吸魂.伤害标签) {
    const 上下文 = 获取或创建教派剑士上下文(attacker);
    const 状态 = 上下文?.魔祭状态 as 魔祭吸魂状态 | undefined;
    if (状态 != null && !状态.已结束 && 状态.阶段 === '生效') {
      状态.累计最终伤害 += applied;
      debugLogForce('教派剑士-魔祭吸魂', '累计全体伤害最终applied', 'targetHid=', GetHandleId(target), 'applied=', applied, 'total=', 状态.累计最终伤害);
    }
  }
  if (target == null || target === 0 || GetUnitTypeId(target) !== 教派剑士单位类型ID || (snapshot?.isFireDamage !== true && snapshot?.isLightDamage !== true)) return;
  const 上下文 = 获取或创建教派剑士上下文(target);
  const 状态 = 上下文?.魔祭状态 as 魔祭吸魂状态 | undefined;
  if (状态 != null && !状态.已结束 && 状态.阶段 === '生效') 触发魔祭反噬(状态, attacker);
}

function 魔祭吸魂增伤修正(this: void, context: any): number {
  if (context == null || context.attacker == null || context.attacker === 0 || GetUnitTypeId(context.attacker) !== 教派剑士单位类型ID) return context?.currentDamage ?? 0;
  const 上下文 = 获取或创建教派剑士上下文(context.attacker);
  const 状态 = 上下文?.魔祭状态 as 魔祭吸魂状态 | undefined;
  if (状态 == null || 状态.已结束 || 状态.阶段 !== '生效') return context.currentDamage;
  return context.currentDamage * (1 + 教派剑士技能配置.魔祭吸魂.伤害提高比例);
}

function on魔祭吸魂全体结算(this: void, variable?: any): void {
  const 状态 = variable as 魔祭吸魂状态 | undefined;
  if (状态 == null || 状态.已结束 || 状态.阶段 !== '生效' || !教派剑士单位存活(状态.上下文.Boss单位)) return;
  const boss = 状态.上下文.Boss单位;
  const 配置 = 教派剑士技能配置.魔祭吸魂;
  const 目标列表 = 获取Boss技能敌对英雄列表(boss);
  状态.累计最终伤害 = 0;
  Sound3DII_CooPlayReuse(教派剑士音效配置.魔祭吸魂.结算吸魂, GetUnitX(boss), GetUnitY(boss), 0, 教派剑士音效配置.音效裁断距离);
  for (let i = 0; i < 目标列表.length; i++) {
    const target = 目标列表[i];
    if (!教派剑士单位存活(target)) continue;
    执行BossAOE技能伤害({
      来源: boss,
      目标: target,
      技能ID: 魔祭吸魂技能ID,
      伤害公式: { 来源攻击力比例: 配置.全体伤害Boss攻击力比例 },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: 配置.伤害标签,
    });
    EC_CreateEffect(配置.命中特效路径1, GetUnitX(target), GetUnitY(target), 0, 270, 1, 1, 配置.命中特效持续秒);
    EC_CreateEffect(配置.命中特效路径2, GetUnitX(target), GetUnitY(target), 0, 270, 2, 1, 配置.命中特效持续秒);
  }
  const 治疗比例 = 配置.治疗基础比例 - 配置.每玩家降低治疗比例 * 取当前有效玩家人数();
  const 治疗量 = 状态.累计最终伤害 * (治疗比例 > 0 ? 治疗比例 : 0);
  const 实际治疗 = 治疗量 > 0 ? doHeal({ HealSource: boss, HealTarget: boss, HealAmount: 治疗量, ItemHeal: false, HealEffect: true }) : 0;
  debugLogForce('教派剑士-魔祭吸魂', '全体结算与最终applied吸收完成', 'bossHid=', GetHandleId(boss), 'targetCount=', 目标列表.length, 'appliedTotal=', 状态.累计最终伤害, 'healRatio=', 治疗比例, 'healed=', 实际治疗);
}

function on魔祭吸魂状态到期(this: void, variable?: any): void {
  const 状态 = variable as 魔祭吸魂状态 | undefined;
  if (状态 != null) 结束魔祭吸魂(状态, '两秒状态自然结束');
}

function on魔祭吸魂施法完成(this: void, variable?: any): void {
  const 状态 = variable as 魔祭吸魂状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  const boss = 状态.上下文.Boss单位;
  const 配置 = 教派剑士技能配置.魔祭吸魂;
  关闭吟唱条(配置.读条通道);
  if (!教派剑士单位存活(boss) || 单位是否处于硬控制效果合集(boss)) {
    结束魔祭吸魂(状态, '施法阶段被打断');
    return;
  }
  执行非伤害生命移除({
    目标: boss,
    数值: 读取单位最大生命(boss) * 配置.自损最大生命比例,
    不致死: false,
    显示文字: false,
    显示特效: false,
  });
  if (!教派剑士单位存活(boss)) {
    结束魔祭吸魂(状态, '自损后死亡');
    return;
  }
  状态.阶段 = '生效';
  Sound3DII_CooPlayReuse(教派剑士音效配置.魔祭吸魂.魔祭生效, GetUnitX(boss), GetUnitY(boss), 0, 教派剑士音效配置.音效裁断距离);
  registerManualBuff(boss, 教派剑士BuffID.魔祭吸魂, 配置.状态持续秒, 配置.伤害提高比例, { sourceUnit: boss, effectSourceName: '魔祭吸魂', effectSourceType: '技能' });
  const 结算ID = addDelayedCallback(配置.全体结算延迟秒 * 1000, on魔祭吸魂全体结算, 状态);
  const 到期ID = addDelayedCallback(配置.状态持续秒 * 1000, on魔祭吸魂状态到期, 状态);
  状态.上下文.清理.登记延迟回调('教派剑士-魔祭吸魂全体结算', 结算ID);
  状态.上下文.清理.登记延迟回调('教派剑士-魔祭吸魂状态到期', 到期ID);
  debugLogForce('教派剑士-魔祭吸魂', '施法成功并进入两秒状态', 'bossHid=', GetHandleId(boss), 'damageBonus=', 配置.伤害提高比例, 'settleDelay=', 配置.全体结算延迟秒);
}

export function 释放教派剑士魔祭吸魂(this: void, 上下文: 教派剑士运行时上下文): boolean {
  const boss = 上下文?.Boss单位;
  if (!教派剑士单位存活(boss) || 上下文.魔祭状态 != null) return false;
  const 配置 = 教派剑士技能配置.魔祭吸魂;
  const 状态: 魔祭吸魂状态 = { 已结束: false, 已反噬: false, 上下文, 阶段: '施法', 累计最终伤害: 0 };
  上下文.魔祭状态 = 状态;
  上下文.清理.登记清理('教派剑士-魔祭吸魂清理', on魔祭吸魂清理, 状态);
  开始硬直(boss, 配置.施法秒);
  SetUnitAnimationByIndex(boss, 配置.动作编号);
  播放教派剑士台词(boss, '魔祭吸魂');
  Sound3DII_CooPlayReuse(教派剑士音效配置.魔祭吸魂.起手施法, GetUnitX(boss), GetUnitY(boss), 0, 教派剑士音效配置.音效裁断距离);
  EC_CreateEffect(配置.起始特效路径, GetUnitX(boss), GetUnitY(boss), 0, 270, 配置.起始特效缩放, 1, 配置.起始特效持续秒);
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 配置.施法秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  const 完成ID = addDelayedCallback(配置.施法秒 * 1000, on魔祭吸魂施法完成, 状态);
  上下文.清理.登记延迟回调('教派剑士-魔祭吸魂施法完成', 完成ID);
  debugLogForce('教派剑士-魔祭吸魂', '1.2秒施法开始', 'bossHid=', GetHandleId(boss), 'cast=', 配置.施法秒);
  return true;
}

function on教派剑士魔祭吸魂生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 魔祭吸魂技能ID || GetUnitTypeId(castingUnit) !== 教派剑士单位类型ID) return;
  const 上下文 = 获取或创建教派剑士上下文(castingUnit);
  const 已开始 = 上下文 != null && 释放教派剑士魔祭吸魂(上下文);
  debugLogForce('教派剑士-魔祭吸魂', '正式SPELL_EFFECT入口', 'bossHid=', GetHandleId(castingUnit), 'started=', 已开始);
}

export function 注册教派剑士魔祭吸魂(this: void): void {
  if (魔祭吸魂已注册) return;
  魔祭吸魂已注册 = true;
  registerSpellEffectListener(on教派剑士魔祭吸魂生效);
  registerAppliedFinalDamageListener(on魔祭吸魂最终伤害);
  registerDamageModifier(魔祭吸魂增伤修正, 教派剑士技能配置.魔祭吸魂.伤害提高修正优先级);
}
