/** @noSelfInFile */

import type { 机制清理篮子 } from '../06．机制清理/01．机制清理篮子';

const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 开始硬直 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { 显示常规技能吟唱条, 显示大招吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, params: any) => void;
  显示大招吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};

const jass = require('jass.common') as any;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;

export type Boss施法时间线回调 = (this: void, unit: any, variable?: any) => void;

export interface Boss施法吟唱条配置 {
  类型: '常规' | '大招';
  通道?: string;
  颜色ID: number;
  标题文本: string;
  提示文本: string;
}

export interface Boss施法时间线参数 {
  名称: string;
  单位: any;
  清理: 机制清理篮子;
  施法秒: number;
  动作名?: string;
  吟唱条?: Boss施法吟唱条配置;
  开始回调?: Boss施法时间线回调;
  开始变量?: any;
  生效回调?: Boss施法时间线回调;
  生效变量?: any;
  延迟登记名?: string;
}

interface Boss施法时间线状态 {
  参数: Boss施法时间线参数;
}

function 显示Boss施法吟唱条(this: void, 配置: Boss施法吟唱条配置, 施法秒: number): void {
  const 参数 = {
    通道: 配置.通道,
    总时长: 施法秒,
    颜色ID: 配置.颜色ID,
    标题文本: 配置.标题文本,
    提示文本: 配置.提示文本,
  };
  if (配置.类型 === '大招') 显示大招吟唱条(参数);
  else 显示常规技能吟唱条(参数);
}

function onBoss施法时间线到时(this: void, variable?: any): void {
  const 状态 = variable as Boss施法时间线状态 | undefined;
  if (状态 == null) return;
  const 参数 = 状态.参数;
  if (参数.吟唱条 != null) 关闭吟唱条(参数.吟唱条.通道);
  if (参数.生效回调 != null) 参数.生效回调(参数.单位, 参数.生效变量);
}

function onBoss施法时间线清理(this: void, variable?: any): void {
  const 状态 = variable as Boss施法时间线状态 | undefined;
  if (状态 == null || 状态.参数.吟唱条 == null) return;
  关闭吟唱条(状态.参数.吟唱条.通道);
}

/**
 * 统一 Boss 的硬直、动作、吟唱条与延迟生效时间线。
 * 技能自身的目标选择、伤害和机制清理由调用方的具名回调继续持有。
 */
export function 执行Boss施法时间线(this: void, 参数: Boss施法时间线参数): boolean {
  if (参数.单位 == null || 参数.单位 === 0 || !(参数.施法秒 >= 0) || 参数.清理.已清理()) return false;
  const 状态 = { 参数 } as Boss施法时间线状态;
  开始硬直(参数.单位, 参数.施法秒);
  if (参数.动作名 != null && 参数.动作名 !== '') SetUnitAnimation(参数.单位, 参数.动作名);
  if (参数.开始回调 != null) 参数.开始回调(参数.单位, 参数.开始变量);
  if (参数.吟唱条 != null) 显示Boss施法吟唱条(参数.吟唱条, 参数.施法秒);
  参数.清理.登记清理(参数.延迟登记名 ?? 参数.名称 + '-施法时间线', onBoss施法时间线清理, 状态);
  const 回调ID = addDelayedCallback(参数.施法秒 * 1000, onBoss施法时间线到时, 状态);
  参数.清理.登记延迟回调(参数.延迟登记名 ?? 参数.名称 + '-施法时间线', 回调ID);
  return true;
}
