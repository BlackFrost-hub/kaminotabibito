/** @noSelfInFile */

import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 创建可攻击机制单位, type 可攻击机制单位实例 } from '../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位';
import { 创建单位停留触发器, type 单位停留触发控制器 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/06．单位停留触发器';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';

const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as { 获取Boss技能敌对英雄列表: (this: void, boss: any) => any[] };
const { addDelayedCallback, removeDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as { YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void };
const jass = require('jass.common') as any;
const Player = jass.Player as (id: number) => any;
const UnitAddAbility = jass.UnitAddAbility as (unit: any, abilityId: number) => boolean;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const PauseUnit = jass.PauseUnit as (unit: any, flag: boolean) => void;
const SetUnitPathing = jass.SetUnitPathing as (unit: any, flag: boolean) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, animationIndex: number) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const 蝗虫技能ID = 0x416c6f63;

export interface 夏提雅鲜血印记实例 {
  X: number;
  Y: number;
  单位实例: 可攻击机制单位实例;
  停留控制器: 单位停留触发控制器;
  到期ID: number;
  已清理: boolean;
}

function 从列表移除(this: void, context: 夏提雅运行时上下文, mark: 夏提雅鲜血印记实例): void {
  for (let i = context.血印句柄列表.length - 1; i >= 0; i--) if (context.血印句柄列表[i] === mark) context.血印句柄列表.splice(i, 1);
}

function 复制鲜血印记列表(this: void, context: 夏提雅运行时上下文): 夏提雅鲜血印记实例[] {
  const list: 夏提雅鲜血印记实例[] = [];
  for (let i = 0; i < context.血印句柄列表.length; i++) list.push(context.血印句柄列表[i] as 夏提雅鲜血印记实例);
  return list;
}

export function 清理夏提雅鲜血印记(this: void, context: 夏提雅运行时上下文, mark: 夏提雅鲜血印记实例, purified: boolean = false): void {
  if (mark.已清理) return;
  mark.已清理 = true;
  mark.停留控制器.停止();
  if (mark.到期ID !== 0) removeDelayedCallback(mark.到期ID);
  if (purified) {
    const effect = AddSpecialEffect(夏提雅数值与表现配置.表现资源.血印净化特效路径, mark.X, mark.Y);
    if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(1.2, effect);
  }
  mark.单位实例.销毁();
  从列表移除(context, mark);
}

export function 创建夏提雅鲜血印记(this: void, context: 夏提雅运行时上下文, x: number, y: number): 夏提雅鲜血印记实例 | undefined {
  if (context.阶段 === 'P3真祖血宴' || context.挑战已结束) return undefined;
  const cfg = 夏提雅数值与表现配置.鲜血印记;
  if (context.血印句柄列表.length >= cfg.同时存在上限) return undefined;
  const unitInstance = 创建可攻击机制单位({ 清理: context.清理, 名称: '夏提雅-鲜血印记', 主人单位: context.Boss单位, 所属玩家: Player(15), 单位类型: cfg.机制单位ID, 模型路径: 夏提雅数值与表现配置.表现资源.血印地面特效路径, X: x, Y: y, 最大生命: 1, 生命值受小怪倍率: false, 缩放: cfg.机制单位缩放 });
  if (unitInstance == null) return undefined;
  播放Boss坐标音效(夏提雅数值与表现配置.音效.鲜血印记落地, x, y, 夏提雅数值与表现配置.音效默认裁断距离);
  UnitAddAbility(unitInstance.单位, 蝗虫技能ID);
  SetUnitInvulnerable(unitInstance.单位, true);
  PauseUnit(unitInstance.单位, true);
  SetUnitPathing(unitInstance.单位, false);
  SetUnitAnimationByIndex(unitInstance.单位, cfg.机制单位动画编号);
  const mark = { X: x, Y: y, 单位实例: unitInstance, 停留控制器: undefined as any, 到期ID: 0, 已清理: false } as 夏提雅鲜血印记实例;
  mark.停留控制器 = 创建单位停留触发器({
    名称: '夏提雅-鲜血印记主动净化', 中心单位: unitInstance.单位, 半径: cfg.净化半径, 需求持续毫秒: cfg.主动净化秒 * 1000, 检查间隔毫秒: 100, 离开后重置: true, 只触发一次: true, 清理篮子: context.清理,
    读取单位列表: function 读取净化玩家(this: void): any[] { return 获取Boss技能敌对英雄列表(context.Boss单位); },
    on触发: function 鲜血印记主动净化(this: void): void { 清理夏提雅鲜血印记(context, mark, true); },
  });
  mark.到期ID = addDelayedCallback(cfg.持续最大秒 * 1000, function 鲜血印记自然到期(this: void): void { 清理夏提雅鲜血印记(context, mark, false); });
  context.清理.登记延迟回调('夏提雅-鲜血印记到期', mark.到期ID);
  context.血印句柄列表.push(mark);
  return mark;
}

export function 净化落点内夏提雅鲜血印记(this: void, context: 夏提雅运行时上下文, x: number, y: number, radius: number): number {
  let count = 0;
  const list = 复制鲜血印记列表(context);
  for (let i = 0; i < list.length; i++) {
    const mark = list[i] as 夏提雅鲜血印记实例;
    const dx = mark.X - x;
    const dy = mark.Y - y;
    if (!mark.已清理 && dx * dx + dy * dy <= radius * radius) { 清理夏提雅鲜血印记(context, mark, true); count++; }
  }
  return count;
}

export function 吸收夏提雅鲜血印记(this: void, context: 夏提雅运行时上下文, mark: 夏提雅鲜血印记实例): boolean {
  if (mark == null || mark.已清理) return false;
  const effect = AddSpecialEffect(夏提雅数值与表现配置.表现资源.血印净化特效路径, mark.X, mark.Y);
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(1.2, effect);
  清理夏提雅鲜血印记(context, mark, false);
  return true;
}

export const 鲜血印记机制状态 = { 已完成设计: true, 已完成实现: true, 已注册: true, 类型: '有限场地资源', 语义: '符合条件的强化穿刺留下血印，玩家可站入净化或诱导净化投枪摧毁。', 实现要求: '场上最多三个；技能伤害、DOT、反伤和英灵复刻不得误生成血印。' } as const;
