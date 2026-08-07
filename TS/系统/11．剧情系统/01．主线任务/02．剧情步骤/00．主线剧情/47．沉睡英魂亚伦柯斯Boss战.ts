/** @noSelfInFile */

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文, 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 进入主线节点 } from "../../00．剧情系统核心工具/10．标准剧情动作";
import { 启动剧情Boss战 } from "../../00．剧情系统核心工具/11．剧情Boss战启动桥接";
import { 剧情Boss预置暂停来源 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";
import { 亚伦柯斯Boss键, 亚伦柯斯待战暂停来源 } from "./46．沉睡英魂亚伦柯斯前导";

const { 清理第三章亚伦柯斯战前区域背景音乐 } = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐") as {
  清理第三章亚伦柯斯战前区域背景音乐: (this: void) => boolean;
};

const { 解除暂停并取消无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  解除暂停并取消无敌安全: (this: void, unit: any, 来源: string) => boolean;
};

const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitAliveBJ(unit);
}

export function 执行启动亚伦柯斯Boss战(this: void, _参数: 剧情动作参数表): void {
  const 当前进度 = 读取剧情进度();
  if (当前进度 !== 46 && 当前进度 !== 47) return;

  const bossUnit = 读取剧情运行时单位("剧情运行时.亚伦柯斯") ?? 读取语义单位引用(亚伦柯斯Boss键);
  const 玩家单位 = 读取剧情运行时单位("剧情运行时.亚伦柯斯玩家") ?? 读取当前剧情动作上下文().触发单位;
  if (!单位存活(bossUnit) || !单位存活(玩家单位)) return;

  解除暂停并取消无敌安全(bossUnit, 亚伦柯斯待战暂停来源);
  const 已启动 = 启动剧情Boss战(bossUnit, {
    触发单位: 玩家单位,
    暂停来源: 剧情Boss预置暂停来源,
  });
  if (已启动) {
    清理第三章亚伦柯斯战前区域背景音乐();
    if (当前进度 === 46) 进入主线节点(47);
  }
}

export const 沉睡英魂亚伦柯斯Boss战剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_启动亚伦柯斯Boss战": 执行启动亚伦柯斯Boss战,
};
