/** @noSelfInFile */

import type { 机制清理篮子 } from '../06．机制清理/01．机制清理篮子';
import { 播放限时单位动画 } from '../../02．通用函数/00．单位动画等待';

const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require('lib.扩展函数.自定义扩展函数.06．单位状态安全包装') as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, source: string) => boolean;
};

export type 非死亡Boss收束回调 = (this: void, variable?: any) => void;

export interface 非死亡Boss收束成员 {
  单位: any;
  暂停来源: string;
  离场动画编号?: number;
  恢复动画编号?: number;
}

export interface 非死亡Boss收束时间线参数 {
  名称: string;
  清理: 机制清理篮子;
  成员: 非死亡Boss收束成员[];
  离场延迟秒: number;
  开始回调?: 非死亡Boss收束回调;
  结算回调: 非死亡Boss收束回调;
  变量?: any;
  延迟登记名?: string;
}

interface 非死亡Boss收束时间线状态 {
  参数: 非死亡Boss收束时间线参数;
  已结算: boolean;
  已释放: boolean;
}

function 释放非死亡Boss收束成员(this: void, 状态: 非死亡Boss收束时间线状态): void {
  if (状态.已释放) return;
  状态.已释放 = true;
  const 成员 = 状态.参数.成员;
  for (let i = 0; i < 成员.length; i++) {
    const 当前成员 = 成员[i];
    if (当前成员.单位 != null && 当前成员.单位 !== 0) 解除暂停并取消无敌安全(当前成员.单位, 当前成员.暂停来源);
  }
}

function on非死亡Boss收束清理(this: void, variable?: any): void {
  const 状态 = variable as 非死亡Boss收束时间线状态 | undefined;
  if (状态 != null) 释放非死亡Boss收束成员(状态);
}

function on非死亡Boss收束结算(this: void, variable?: any): void {
  const 状态 = variable as 非死亡Boss收束时间线状态 | undefined;
  if (状态 == null || 状态.已结算) return;
  状态.已结算 = true;
  状态.参数.结算回调(状态.参数.变量);
  释放非死亡Boss收束成员(状态);
}

/**
 * 统一非死亡 Boss 的冻结、离场动画、延迟结算与来源安全释放。
 * 奖励、隐藏单位和结束 Boss 战等业务顺序由结算回调保留在各 Boss 文件。
 */
export function 启动非死亡Boss收束时间线(this: void, 参数: 非死亡Boss收束时间线参数): boolean {
  if (!(参数.离场延迟秒 >= 0) || 参数.成员.length <= 0 || 参数.清理.已清理()) return false;
  const 状态: 非死亡Boss收束时间线状态 = { 参数, 已结算: false, 已释放: false };
  const 成员 = 参数.成员;
  for (let i = 0; i < 成员.length; i++) {
    const 当前成员 = 成员[i];
    if (当前成员.单位 == null || 当前成员.单位 === 0) continue;
    暂停并设置无敌安全(当前成员.单位, 当前成员.暂停来源);
    if (当前成员.离场动画编号 != null) {
      播放限时单位动画({
        单位: 当前成员.单位,
        动画编号: 当前成员.离场动画编号,
        持续秒: 参数.离场延迟秒,
        恢复动画编号: 当前成员.恢复动画编号 ?? 0,
      });
    }
  }
  参数.清理.登记清理(参数.名称 + '-释放冻结', on非死亡Boss收束清理, 状态);
  if (参数.开始回调 != null) 参数.开始回调(参数.变量);
  const 回调ID = addDelayedCallback(参数.离场延迟秒 * 1000, on非死亡Boss收束结算, 状态);
  参数.清理.登记延迟回调(参数.延迟登记名 ?? 参数.名称 + '-延迟结算', 回调ID);
  return true;
}
