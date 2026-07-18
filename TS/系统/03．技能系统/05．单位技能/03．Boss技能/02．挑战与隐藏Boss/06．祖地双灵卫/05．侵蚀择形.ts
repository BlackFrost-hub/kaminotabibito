/** @noSelfInFile */

import type { 祖地双灵卫名称 } from './00．配置';
import type { 祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 祖地双灵卫单位技能配置 } from './00．配置';
import { 祖地双灵卫数值与表现配置 } from './02．数值与表现配置';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 播放赤誓灵卫台词, 播放苍影灵卫台词 } from './12．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 祖地双灵卫BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/02．挑战与隐藏Boss/05．祖地双灵卫';
import { 创建伤害生命下限保护 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/09．伤害生命下限保护';
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as { getServerTime: (this: void) => number };
const { registerManualBuff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, unit: any, buffId: string, duration: number, value: number, extras?: any) => void;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitScale = jass.SetUnitScale as (unit: any, x: number, y: number, z: number) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const DzSetUnitModel = japi.DzSetUnitModel as ((unit: any, model: string) => void) | undefined;
function 生命比例(this: void, unit: any): number {
  const maxLife = unit != null && unit !== 0 ? GetUnitState(unit, UNIT_STATE_MAX_LIFE) : 0;
  return maxLife > 0 ? GetUnitState(unit, UNIT_STATE_LIFE) / maxLife : 0;
}

function 变异守卫(this: void, context: 祖地双灵卫运行时上下文, name: 祖地双灵卫名称): void {
  const isRed = name === '赤誓灵卫';
  const unit = isRed ? context.赤誓灵卫单位 : context.苍影灵卫单位;
  播放Boss坐标音效(祖地双灵卫数值与表现配置.音效.侵蚀择形, GetUnitX(unit), GetUnitY(unit), 祖地双灵卫数值与表现配置.音效默认裁断距离);
  const unitCfg = isRed ? 祖地双灵卫单位技能配置.单位.赤誓灵卫 : 祖地双灵卫单位技能配置.单位.苍影灵卫;
  const effectPath = isRed ? 祖地双灵卫数值与表现配置.表现资源.公共.赤誓变异转化特效路径 : 祖地双灵卫数值与表现配置.表现资源.公共.苍影变异转化特效路径;
  const effect = AddSpecialEffect(effectPath, GetUnitX(unit), GetUnitY(unit));
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(1.8, effect);
  if (DzSetUnitModel != null) DzSetUnitModel(unit, unitCfg.变异模型路径);
  SetUnitScale(unit, unitCfg.变异模型缩放, unitCfg.变异模型缩放, unitCfg.变异模型缩放);
  if (isRed) context.赤誓灵卫形态 = '裂誓战躯';
  else context.苍影灵卫形态 = '无面祷影';
  const animation = isRed ? 祖地双灵卫数值与表现配置.动作.裂誓举剑 : 祖地双灵卫数值与表现配置.动作.无面施法;
  const stand = isRed ? 祖地双灵卫数值与表现配置.动作.裂誓待机 : 祖地双灵卫数值与表现配置.动作.无面待机;
  播放限时单位动画({ 单位: unit, 动画编号: animation, 持续秒: 1.5, 恢复动画编号: stand });
}

function 进入P2(this: void, context: 祖地双灵卫运行时上下文, first: 祖地双灵卫名称, now: number): void {
  context.首次变异守卫 = first;
  context.阶段 = 'P2侵蚀失衡';
  context.P2开始时间Ms = now;
  context.大型机制忙碌到Ms = now + 1800;
  context.大型技能占用者 = first;
  变异守卫(context, first);
  if (first === '赤誓灵卫') 播放赤誓灵卫台词(context.赤誓灵卫单位, '首次变异');
  else 播放苍影灵卫台词(context.苍影灵卫单位, '首次变异');
}

function 进入P3(this: void, context: 祖地双灵卫运行时上下文, now: number): void {
  const second: 祖地双灵卫名称 = context.首次变异守卫 === '赤誓灵卫' ? '苍影灵卫' : '赤誓灵卫';
  变异守卫(context, second);
  if (second === '赤誓灵卫') 播放赤誓灵卫台词(context.赤誓灵卫单位, 'P3双蚀共鸣');
  else 播放苍影灵卫台词(context.苍影灵卫单位, 'P3双蚀共鸣');
  context.阶段 = 'P3双蚀共鸣';
  context.大型技能占用者 = '联合机制';
  context.大型机制忙碌到Ms = now + 2200;
  context.P3共鸣层数 = 祖地双灵卫数值与表现配置.P3.净化节点数量;
  registerManualBuff(context.赤誓灵卫单位, 祖地双灵卫BuffID.双蚀共鸣, 3600, 祖地双灵卫数值与表现配置.公共.P3每层共鸣减伤比例 * 100, { stack: context.P3共鸣层数, sourceName: '祖地双灵卫-双蚀共鸣' });
  registerManualBuff(context.苍影灵卫单位, 祖地双灵卫BuffID.双蚀共鸣, 3600, 祖地双灵卫数值与表现配置.公共.P3每层共鸣减伤比例 * 100, { stack: context.P3共鸣层数, sourceName: '祖地双灵卫-双蚀共鸣' });
  context.当前净化节点序号 = 1;
  if (context.净化节点列表.length > 0) context.净化节点列表[0].阶段 = '破壳';
}

export function 更新祖地双灵卫侵蚀阶段(this: void, context: 祖地双灵卫运行时上下文, now: number = getServerTime()): void {
  if (context.战斗已结束) return;
  if (context.大型技能占用者 != null && now >= context.大型机制忙碌到Ms) context.大型技能占用者 = undefined;
  const redRatio = 生命比例(context.赤誓灵卫单位);
  const azureRatio = 生命比例(context.苍影灵卫单位);
  if (context.阶段 === 'P1双灵守门') {
    const threshold = 祖地双灵卫单位技能配置.阶段阈值.首次变异生命比例;
    if (redRatio <= threshold || azureRatio <= threshold) 进入P2(context, redRatio <= azureRatio ? '赤誓灵卫' : '苍影灵卫', now);
    return;
  }
  if (context.阶段 !== 'P2侵蚀失衡' || context.首次变异守卫 == null) return;
  const firstRatio = context.首次变异守卫 === '赤誓灵卫' ? redRatio : azureRatio;
  if (now >= context.P2开始时间Ms + 祖地双灵卫数值与表现配置.公共.P2最短持续秒 * 1000 || firstRatio <= 祖地双灵卫数值与表现配置.公共.P2首名变异者推进P3生命比例) {
    进入P3(context, now);
  }
}

function 取侵蚀阶段生命下限比例(this: void, context: 祖地双灵卫运行时上下文, unit: any): number {
  if (context.阶段 === 'P1双灵守门') return 祖地双灵卫单位技能配置.阶段阈值.首次变异生命比例;
  if (context.阶段 !== 'P2侵蚀失衡' || context.首次变异守卫 == null) return 0;
  const first = context.首次变异守卫 === '赤誓灵卫' ? context.赤誓灵卫单位 : context.苍影灵卫单位;
  return unit === first
    ? 祖地双灵卫数值与表现配置.公共.P2首名变异者推进P3生命比例
    : 祖地双灵卫单位技能配置.阶段阈值.混合阶段第二守卫最低生命比例;
}

export function 绑定祖地双灵卫侵蚀生命下限(this: void, context: 祖地双灵卫运行时上下文): void {
  if (context.侵蚀生命下限保护列表.length > 0) return;
  const units = [context.赤誓灵卫单位, context.苍影灵卫单位];
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    const controller = 创建伤害生命下限保护({
      名称: `祖地双灵卫-侵蚀阶段锁血-${i + 1}`,
      单位: unit,
      修正优先级: -90,
      清理: context.清理,
      离开下限后重置触底: true,
      过滤伤害: function 双灵卫侵蚀锁血过滤(this: void): boolean {
        return !context.战斗已结束 && (context.阶段 === 'P1双灵守门' || context.阶段 === 'P2侵蚀失衡');
      },
      取生命下限: function 取双灵卫侵蚀生命下限(this: void, target: any): number {
        return GetUnitState(target, UNIT_STATE_MAX_LIFE) * 取侵蚀阶段生命下限比例(context, target);
      },
      on首次触底: function 双灵卫侵蚀首次触底(this: void): void {
        const now = getServerTime();
        const name: 祖地双灵卫名称 = unit === context.赤誓灵卫单位 ? '赤誓灵卫' : '苍影灵卫';
        if (context.阶段 === 'P1双灵守门') {
          进入P2(context, name, now);
          return;
        }
        if (context.阶段 !== 'P2侵蚀失衡' || context.首次变异守卫 == null) return;
        const first = context.首次变异守卫 === '赤誓灵卫' ? context.赤誓灵卫单位 : context.苍影灵卫单位;
        if (unit === first) 进入P3(context, now);
      },
    });
    context.侵蚀生命下限保护列表.push(controller);
  }
}

export const 侵蚀择形机制状态 = {
  类型: '血量阶段机制',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '第一名到达阶段阈值的守卫率先变异，并决定混合形态阶段的解法。',
  实现要求: '形态变化需要迁移生命比例、仇恨和共享阶段状态；另一名守卫在混合阶段不得瞬间跳过机制。',
} as const;
