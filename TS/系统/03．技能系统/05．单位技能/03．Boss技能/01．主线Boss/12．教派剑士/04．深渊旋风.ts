/** @noSelfInFile */

import { 教派剑士单位技能配置 } from './00．配置';
import { 获取或创建教派剑士上下文, 教派剑士单位存活, type 教派剑士运行时上下文 } from './01．运行时上下文';
import { 教派剑士技能配置, 教派剑士音效配置 } from './02．数值与表现配置';
import { 播放教派剑士台词 } from './11．台词播放';
import { 创建原生弹幕, 销毁原生弹幕 } from '../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 创建技能提示圈 } from '../../../../00．技能模板+函数/02．通用函数/16．技能提示圈工厂';
import { 教派剑士BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/11．教派剑士';

const { registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
};
const { 开始硬直, 获取单位硬直剩余时间, 调整单位硬直时间, 单位是否处于硬控制效果合集, 施加快速减速Buff } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
  获取单位硬直剩余时间: (this: void, unit: any) => number;
  调整单位硬直时间: (this: void, unit: any, operation: number, duration: number) => void;
  单位是否处于硬控制效果合集: (this: void, unit: any) => boolean;
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { getEnemyUnitsInRange } = require('lib.扩展函数.自定义扩展函数.01．选取中心范围') as {
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
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
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animation: string) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 深渊旋风状态 {
  已结束: boolean;
  上下文: 教派剑士运行时上下文;
  已执行轮数: number;
  周期回调ID: number;
  弹幕ID列表: number[];
}

interface 深渊旋风预警快照 {
  状态: 深渊旋风状态;
  角度: number;
}

interface 深渊旋风弹幕状态 {
  父状态: 深渊旋风状态;
  上下文: 教派剑士运行时上下文;
  X: number;
  Y: number;
  禁止结算: boolean;
}

const 教派剑士单位类型ID = stringToFourCCSafe(教派剑士单位技能配置.单位ID);
const 深渊旋风技能ID = stringToFourCCSafe(教派剑士单位技能配置.技能ID.深渊旋风);
const 深渊旋风弹幕状态表: Record<number, 深渊旋风弹幕状态 | undefined> = {};
let 深渊旋风已注册 = false;

function 结束深渊旋风(this: void, 状态: 深渊旋风状态, 原因: string): void {
  if (状态.已结束) return;
  状态.已结束 = true;
  if (状态.周期回调ID !== 0) {
    removePeriodicCallback(状态.周期回调ID);
    状态.周期回调ID = 0;
  }
  const boss = 状态.上下文.Boss单位;
  const 施法硬直剩余秒 = 教派剑士单位存活(boss) ? 获取单位硬直剩余时间(boss) : 0;
  if (教派剑士单位存活(boss)) 调整单位硬直时间(boss, 1, 施法硬直剩余秒);
  const 清理后硬直剩余秒 = 教派剑士单位存活(boss) ? 获取单位硬直剩余时间(boss) : 0;
  移除单位指定Buff(boss, 教派剑士BuffID.深渊旋风);
  关闭吟唱条(教派剑士技能配置.深渊旋风.读条通道);
  if (状态.上下文.旋风状态 === 状态) 状态.上下文.旋风状态 = undefined;
  debugLogForce('教派剑士-深渊旋风', '技能结束', 'bossHid=', boss != null && boss !== 0 ? GetHandleId(boss) : 0, 'reason=', 原因, 'rounds=', 状态.已执行轮数, 'hardStunBefore=', 施法硬直剩余秒, 'hardStunAfter=', 清理后硬直剩余秒, 'hardStunCleared=', 清理后硬直剩余秒 <= 0.001);
}

function 清理深渊旋风已发射弹幕(this: void, 状态: 深渊旋风状态): void {
  const 弹幕ID列表 = 状态.弹幕ID列表.slice();
  状态.弹幕ID列表.length = 0;
  for (let i = 0; i < 弹幕ID列表.length; i++) {
    const 弹幕ID = 弹幕ID列表[i];
    const 弹幕状态 = 深渊旋风弹幕状态表[弹幕ID];
    if (弹幕状态 != null) 弹幕状态.禁止结算 = true;
    销毁原生弹幕(弹幕ID, '手动销毁');
    debugLogForce('教派剑士-深渊旋风', '上下文清理已发射弹幕', 'barrageId=', 弹幕ID, 'skipExplosion=', true);
  }
}

function on深渊旋风清理(this: void, variable?: any): void {
  const 状态 = variable as 深渊旋风状态 | undefined;
  if (状态 == null) return;
  if (!状态.已结束) 结束深渊旋风(状态, '上下文清理');
  清理深渊旋风已发射弹幕(状态);
}

function on深渊旋风弹幕Tick(this: void, instance: any): void {
  if (instance == null || instance.id == null) return;
  const 状态 = 深渊旋风弹幕状态表[instance.id];
  if (状态 == null) return;
  状态.X = instance.当前X;
  状态.Y = instance.当前Y;
}

function on深渊旋风弹幕结束(this: void, reason: any, barrageId: number): void {
  const 状态 = 深渊旋风弹幕状态表[barrageId];
  delete 深渊旋风弹幕状态表[barrageId];
  if (状态 != null) {
    const 弹幕ID列表 = 状态.父状态.弹幕ID列表;
    for (let i = 弹幕ID列表.length - 1; i >= 0; i--) {
      if (弹幕ID列表[i] === barrageId) {
        弹幕ID列表.splice(i, 1);
        break;
      }
    }
  }
  if (状态 == null || 状态.禁止结算 || !教派剑士单位存活(状态.上下文.Boss单位)) return;
  const boss = 状态.上下文.Boss单位;
  const 配置 = 教派剑士技能配置.深渊旋风;
  const 目标列表 = getEnemyUnitsInRange(boss, 状态.X, 状态.Y, 配置.爆炸半径);
  let 命中数 = 0;
  for (let i = 0; i < 目标列表.length; i++) {
    施加快速减速Buff(boss, 目标列表[i], 0, 配置.命中移速减幅, 配置.命中减速秒, '教派剑士-深渊旋风', '技能');
    debugLogForce('教派剑士-深渊旋风', '命中目标施加减速', 'barrageId=', barrageId, 'targetHid=', GetHandleId(目标列表[i]), 'moveSlow=', 配置.命中移速减幅, 'duration=', 配置.命中减速秒);
    const 结果 = 执行BossAOE技能伤害({
      来源: boss,
      目标: 目标列表[i],
      技能ID: 深渊旋风技能ID,
      伤害公式: { 来源攻击力比例: 配置.Boss攻击力比例 },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: 配置.伤害标签,
    });
    if (结果.是否造成伤害) 命中数++;
  }
  debugLogForce('教派剑士-深渊旋风', '弹幕终点AOE结算', 'barrageId=', barrageId, 'reason=', reason, 'x=', 状态.X, 'y=', 状态.Y, 'hitCount=', 命中数);
}

function on深渊旋风发射(this: void, variable?: any): void {
  const 快照 = variable as 深渊旋风预警快照 | undefined;
  if (快照 == null || 快照.状态.已结束 || !教派剑士单位存活(快照.状态.上下文.Boss单位)) return;
  const boss = 快照.状态.上下文.Boss单位;
  const 配置 = 教派剑士技能配置.深渊旋风;
  const X = GetUnitX(boss);
  const Y = GetUnitY(boss);
  const 弹幕 = 创建原生弹幕({
    所有者: boss,
    载体模式: '特效',
    X,
    Y,
    方向角: 快照.角度,
    速度: 配置.弹幕速度,
    生命周期: 配置.弹幕生命周期秒,
    最大距离: 配置.弹幕速度 * 配置.弹幕生命周期秒,
    命中半径: 配置.弹幕命中半径,
    影响目标: '敌方',
    碰撞消失: true,
    每单位最大命中次数: 1,
    最大总命中次数: 1,
    附加特效1: { 模型: 配置.弹幕特效路径, 缩放: 配置.弹幕特效缩放, 跟随主弹幕参数: true },
    onTick: on深渊旋风弹幕Tick,
    on结束: on深渊旋风弹幕结束,
  });
  深渊旋风弹幕状态表[弹幕.弹幕ID] = { 父状态: 快照.状态, 上下文: 快照.状态.上下文, X, Y, 禁止结算: false };
  快照.状态.弹幕ID列表.push(弹幕.弹幕ID);
  debugLogForce('教派剑士-深渊旋风', '旋风弹幕发射', 'bossHid=', GetHandleId(boss), 'barrageId=', 弹幕.弹幕ID, 'angle=', 快照.角度);
}

function on深渊旋风末轮收束(this: void, variable?: any): void {
  const 状态 = variable as 深渊旋风状态 | undefined;
  if (状态 != null) 结束深渊旋风(状态, '全部轮次完成');
}

function on深渊旋风轮次(this: void, variable?: any): void {
  const 状态 = variable as 深渊旋风状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  const boss = 状态.上下文.Boss单位;
  if (!教派剑士单位存活(boss)) {
    结束深渊旋风(状态, 'Boss失效');
    return;
  }
  if (单位是否处于硬控制效果合集(boss)) {
    结束深渊旋风(状态, '受到硬控制打断');
    return;
  }
  const 配置 = 教派剑士技能配置.深渊旋风;
  状态.已执行轮数++;
  const 角度 = GetRandomReal(0, 360);
  创建技能提示圈({
    类型: '方向直线',
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    宽度: 配置.弹幕命中半径 * 2,
    长度: 配置.弹幕速度 * 配置.弹幕生命周期秒,
    朝向: 角度,
    持续时间: 配置.预警秒,
    来源单位: boss,
  });
  const 快照: 深渊旋风预警快照 = { 状态, 角度 };
  const 发射回调ID = addDelayedCallback(配置.预警秒 * 1000, on深渊旋风发射, 快照);
  状态.上下文.清理.登记延迟回调('教派剑士-深渊旋风发射', 发射回调ID);
  debugLogForce('教派剑士-深渊旋风', '轮次预警', 'bossHid=', GetHandleId(boss), 'round=', 状态.已执行轮数, 'angle=', 角度, 'warning=', 配置.预警秒);
  if (状态.已执行轮数 >= 配置.轮数) {
    if (状态.周期回调ID !== 0) {
      removePeriodicCallback(状态.周期回调ID);
      状态.周期回调ID = 0;
    }
    const 收束回调ID = addDelayedCallback((配置.预警秒 + 配置.末轮收束冗余秒) * 1000, on深渊旋风末轮收束, 状态);
    状态.上下文.清理.登记延迟回调('教派剑士-深渊旋风末轮收束', 收束回调ID);
  }
}

function 教派剑士旋风魔法免疫修正(this: void, context: any): number {
  if (context == null || context.target == null || context.target === 0 || context.isMagicDamage !== true) return context?.currentDamage ?? 0;
  if (GetUnitTypeId(context.target) !== 教派剑士单位类型ID) return context.currentDamage;
  const 上下文 = 获取或创建教派剑士上下文(context.target);
  const 状态 = 上下文?.旋风状态 as 深渊旋风状态 | undefined;
  if (状态 == null || 状态.已结束) return context.currentDamage;
  debugLogForce('教派剑士-深渊旋风', '施法期间免疫魔法伤害', 'bossHid=', GetHandleId(context.target), 'prevented=', context.currentDamage);
  return 0;
}

export function 释放教派剑士深渊旋风(this: void, 上下文: 教派剑士运行时上下文): boolean {
  const boss = 上下文?.Boss单位;
  if (!教派剑士单位存活(boss) || 上下文.旋风状态 != null) return false;
  const 配置 = 教派剑士技能配置.深渊旋风;
  const 状态: 深渊旋风状态 = { 已结束: false, 上下文, 已执行轮数: 0, 周期回调ID: 0, 弹幕ID列表: [] };
  上下文.旋风状态 = 状态;
  上下文.清理.登记清理('教派剑士-深渊旋风清理', on深渊旋风清理, 状态);
  开始硬直(boss, 配置.施法硬直秒);
  SetUnitAnimation(boss, 配置.动作名);
  播放教派剑士台词(boss, '深渊旋风');
  Sound3DII_CooPlayReuse(教派剑士音效配置.深渊旋风.旋风起手, GetUnitX(boss), GetUnitY(boss), 0, 教派剑士音效配置.音效裁断距离);
  registerManualBuff(boss, 教派剑士BuffID.深渊旋风, 配置.施法硬直秒, 0, { sourceUnit: boss, effectSourceName: '深渊旋风', effectSourceType: '技能' });
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 配置.施法硬直秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  状态.周期回调ID = addPeriodicCallback(配置.轮次间隔秒 * 1000, on深渊旋风轮次, 状态);
  上下文.清理.登记周期回调('教派剑士-深渊旋风轮次', 状态.周期回调ID);
  debugLogForce('教派剑士-深渊旋风', '施法开始', 'bossHid=', GetHandleId(boss), 'roundCount=', 配置.轮数, 'interval=', 配置.轮次间隔秒);
  return true;
}

function on教派剑士深渊旋风生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 深渊旋风技能ID || GetUnitTypeId(castingUnit) !== 教派剑士单位类型ID) return;
  const 上下文 = 获取或创建教派剑士上下文(castingUnit);
  const 已开始 = 上下文 != null && 释放教派剑士深渊旋风(上下文);
  debugLogForce('教派剑士-深渊旋风', '正式SPELL_EFFECT入口', 'bossHid=', GetHandleId(castingUnit), 'started=', 已开始);
}

export function 注册教派剑士深渊旋风(this: void): void {
  if (深渊旋风已注册) return;
  深渊旋风已注册 = true;
  registerSpellEffectListener(on教派剑士深渊旋风生效);
  registerDamageModifier(教派剑士旋风魔法免疫修正, 教派剑士技能配置.深渊旋风.魔法免疫修正优先级);
  debugLogForce('教派剑士-深渊旋风', '技能壳与魔法免疫监听注册完成', 'skillId=', 深渊旋风技能ID);
}
