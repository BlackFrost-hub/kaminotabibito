/** @noSelfInFile */

import type { 祖地双灵卫名称 } from './00．配置';
import type { 祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 清理祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 祖地双灵卫单位技能配置 } from './00．配置';
import { 祖地双灵卫数值与表现配置 } from './02．数值与表现配置';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 祖地双灵卫BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/02．挑战与隐藏Boss/05．祖地双灵卫';
import { 创建伤害生命下限保护 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/09．伤害生命下限保护';
import { 播放赤誓灵卫台词, 播放苍影灵卫台词 } from './12．台词播放';
const { 主动结束Boss战运行 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动') as {
  主动结束Boss战运行: (this: void, boss: any, options?: any) => boolean;
};
const { 打开Boss死亡首领奖励UI } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑') as {
  打开Boss死亡首领奖励UI: (this: void, rewardPoolId: string) => void;
};
const { getServerTime, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, unit: any, buffId: string, duration: number, value: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffId: string) => boolean;
};
const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const PauseUnit = jass.PauseUnit as (unit: any, flag: boolean) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (unit: any, red: number, green: number, blue: number, alpha: number) => void;
const SetUnitScale = jass.SetUnitScale as (unit: any, x: number, y: number, z: number) => void;
const ShowUnit = jass.ShowUnit as (unit: any, flag: boolean) => void;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const DzSetUnitModel = japi.DzSetUnitModel as ((unit: any, model: string) => void) | undefined;
const 双灵卫奖励池ID = 'chapter2.hidden.ancestral_twin_guards';

function 取名称(this: void, context: 祖地双灵卫运行时上下文, unit: any): 祖地双灵卫名称 | undefined {
  if (unit === context.赤誓灵卫单位) return '赤誓灵卫';
  if (unit === context.苍影灵卫单位) return '苍影灵卫';
  return undefined;
}

function 取单位(this: void, context: 祖地双灵卫运行时上下文, name: 祖地双灵卫名称): any {
  return name === '赤誓灵卫' ? context.赤誓灵卫单位 : context.苍影灵卫单位;
}

function 进入灵魂崩解(this: void, context: 祖地双灵卫运行时上下文, name: 祖地双灵卫名称): void {
  const unit = 取单位(context, name);
  const member = context.联合生命周期.取成员(name);
  if (member == null || member.状态 === '崩解') return;
  context.联合生命周期.设置状态(name, '崩解', '生命达到同步崩解阈值');
  PauseUnit(unit, true);
  SetUnitInvulnerable(unit, true);
  registerManualBuff(unit, 祖地双灵卫BuffID.灵魂崩解, 3600, 1, { sourceName: '祖地双灵卫-灵魂崩解', tickWhilePaused: true });
  const animation = name === '赤誓灵卫' ? 祖地双灵卫数值与表现配置.动作.裂誓消散 : 祖地双灵卫数值与表现配置.动作.无面施法;
  播放限时单位动画({ 单位: unit, 动画编号: animation, 持续秒: 2, 恢复动画编号: animation });
  if (name === '赤誓灵卫') 播放赤誓灵卫台词(unit, '灵魂崩解');
  else 播放苍影灵卫台词(unit, '灵魂崩解');
  if (context.崩解中的守卫 == null) {
    context.崩解中的守卫 = name;
    const allPurified = context.已净化节点数量 >= 祖地双灵卫数值与表现配置.P3.净化节点数量;
    const seconds = allPurified ? 祖地双灵卫单位技能配置.阶段阈值.完成净化后同步崩解窗口秒 : 祖地双灵卫单位技能配置.阶段阈值.默认同步崩解窗口秒;
    context.崩解截止时间Ms = getServerTime() + seconds * 1000;
  }
}

export function 绑定祖地双灵卫同息生命下限(this: void, context: 祖地双灵卫运行时上下文): void {
  if (context.同息生命下限保护列表.length > 0) return;
  const units = [context.赤誓灵卫单位, context.苍影灵卫单位];
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    const name: 祖地双灵卫名称 = unit === context.赤誓灵卫单位 ? '赤誓灵卫' : '苍影灵卫';
    const controller = 创建伤害生命下限保护({
      名称: `祖地双灵卫-同息归寂锁血-${i + 1}`,
      单位: unit,
      最大生命比例下限: 祖地双灵卫单位技能配置.阶段阈值.灵魂崩解生命比例,
      修正优先级: -100,
      清理: context.清理,
      离开下限后重置触底: true,
      过滤伤害: function 双灵卫同息锁血过滤(this: void): boolean {
        return !context.战斗已结束 && context.阶段 === 'P3双蚀共鸣';
      },
      伤害预处理: function 双灵卫崩解期免伤(this: void, _damage: any, current: number): number {
        const member = context.联合生命周期.取成员(name);
        return member != null && member.状态 === '崩解' ? 0 : current;
      },
      on首次触底: function 双灵卫进入崩解(this: void): void {
        进入灵魂崩解(context, name);
      },
    });
    context.同息生命下限保护列表.push(controller);
  }
}

function 恢复崩解守卫(this: void, context: 祖地双灵卫运行时上下文, name: 祖地双灵卫名称): void {
  const unit = 取单位(context, name);
  SetUnitState(unit, UNIT_STATE_LIFE, GetUnitState(unit, UNIT_STATE_MAX_LIFE) * 祖地双灵卫数值与表现配置.公共.同息回灌恢复比例);
  SetUnitInvulnerable(unit, false);
  PauseUnit(unit, false);
  context.联合生命周期.设置状态(name, '活跃', '同步崩解超时回灌');
  移除单位指定Buff(unit, 祖地双灵卫BuffID.灵魂崩解);
  const reflux = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.公共.魂力回灌特效路径, GetUnitX(unit), GetUnitY(unit));
  if (reflux != null && reflux !== 0) YDWETimerDestroyEffectSafe(1.2, reflux);
  if (name === '赤誓灵卫') 播放苍影灵卫台词(context.苍影灵卫单位, '同息回灌');
  else 播放赤誓灵卫台词(context.赤誓灵卫单位, '同息回灌');
  context.崩解中的守卫 = undefined;
  context.崩解截止时间Ms = 0;
}

export function 执行祖地双灵卫净化收束(this: void, context: 祖地双灵卫运行时上下文): boolean {
  if (context.战斗已结束 || context.阶段 === '净化收束') return false;
  context.最终结算待处理 = false;
  context.阶段 = '净化收束';
  context.大型技能占用者 = '联合机制';
  const red = context.赤誓灵卫单位;
  const azure = context.苍影灵卫单位;
  if (context.首次变异守卫 === '赤誓灵卫') 播放赤誓灵卫台词(red, '净化收束');
  else 播放苍影灵卫台词(azure, '净化收束');
  PauseUnit(red, true);
  PauseUnit(azure, true);
  SetUnitInvulnerable(red, true);
  SetUnitInvulnerable(azure, true);
  const cleanupBuffs = [祖地双灵卫BuffID.双灵同誓, 祖地双灵卫BuffID.双蚀共鸣, 祖地双灵卫BuffID.灵魂崩解, 祖地双灵卫BuffID.净化反冲];
  for (let i = 0; i < cleanupBuffs.length; i++) {
    移除单位指定Buff(red, cleanupBuffs[i]);
    移除单位指定Buff(azure, cleanupBuffs[i]);
  }
  if (DzSetUnitModel != null) {
    DzSetUnitModel(red, 祖地双灵卫单位技能配置.单位.赤誓灵卫.正常模型路径);
    DzSetUnitModel(azure, 祖地双灵卫单位技能配置.单位.苍影灵卫.正常模型路径);
  }
  SetUnitScale(red, 祖地双灵卫单位技能配置.单位.赤誓灵卫.正常模型缩放, 祖地双灵卫单位技能配置.单位.赤誓灵卫.正常模型缩放, 祖地双灵卫单位技能配置.单位.赤誓灵卫.正常模型缩放);
  SetUnitScale(azure, 祖地双灵卫单位技能配置.单位.苍影灵卫.正常模型缩放, 祖地双灵卫单位技能配置.单位.苍影灵卫.正常模型缩放, 祖地双灵卫单位技能配置.单位.苍影灵卫.正常模型缩放);
  SetUnitVertexColor(red, 255, 255, 255, 210);
  SetUnitVertexColor(azure, 255, 255, 255, 210);
  const effectA = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.公共.最终净化归静特效路径, GetUnitX(red), GetUnitY(red));
  const effectB = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.公共.最终净化归静特效路径, GetUnitX(azure), GetUnitY(azure));
  if (effectA != null && effectA !== 0) YDWETimerDestroyEffectSafe(祖地双灵卫数值与表现配置.P3.最终净化特效持续秒, effectA);
  if (effectB != null && effectB !== 0) YDWETimerDestroyEffectSafe(祖地双灵卫数值与表现配置.P3.最终净化特效持续秒, effectB);
  const delayedId = addDelayedCallback(祖地双灵卫数值与表现配置.P3.最终净化结算延迟毫秒, function 双灵卫净化结算(this: void): void {
    主动结束Boss战运行(red, { 跳过死亡音效: true, 跳过死亡剧情: true });
    主动结束Boss战运行(azure, { 跳过死亡音效: true, 跳过死亡剧情: true });
    打开Boss死亡首领奖励UI(双灵卫奖励池ID);
    SetUnitVertexColor(red, 255, 255, 255, 0);
    SetUnitVertexColor(azure, 255, 255, 255, 0);
    ShowUnit(red, false);
    ShowUnit(azure, false);
    清理祖地双灵卫运行时上下文(context);
  });
  context.清理.登记延迟回调('祖地双灵卫-净化结算', delayedId);
  return true;
}

export function 更新祖地双灵卫同息归寂(this: void, context: 祖地双灵卫运行时上下文, now: number = getServerTime()): void {
  if (context.最终结算待处理) {
    执行祖地双灵卫净化收束(context);
    return;
  }
  if (context.阶段 !== 'P3双蚀共鸣' || context.崩解中的守卫 == null || context.崩解截止时间Ms <= 0 || now < context.崩解截止时间Ms) return;
  const name = context.崩解中的守卫;
  const member = context.联合生命周期.取成员(name);
  if (member != null && member.状态 === '崩解') 恢复崩解守卫(context, name);
}

export const 同息归寂机制状态 = {
  类型: '同步战败机制',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '第一名守卫进入灵魂崩解后暂不死亡，玩家需在时间窗内令另一名同步崩解。',
  实现要求: '第一名崩解时不得提前触发Boss死亡奖励、剧情结算或全场清理。',
} as const;
