/** @noSelfInFile */

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文, 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 进入主线节点 } from "../../00．剧情系统核心工具/10．标准剧情动作";
import { 启动剧情Boss战 } from "../../00．剧情系统核心工具/11．剧情Boss战启动桥接";
import { 获取菲尼克斯尔Boss, 菲尼克斯尔待战暂停来源 } from "./43．菲尼克斯尔现身";

const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitAliveBJ(unit);
}

export function 执行启动菲尼克斯尔Boss战(this: void, _参数: 剧情动作参数表): void {
  const 当前进度 = 读取剧情进度();
  if (当前进度 !== 43 && 当前进度 !== 44) return;

  const bossUnit = 获取菲尼克斯尔Boss();
  const 玩家单位 = 读取剧情运行时单位("剧情运行时.菲尼克斯尔玩家") ?? 读取当前剧情动作上下文().触发单位;
  if (!单位存活(bossUnit) || !单位存活(玩家单位)) return;

  const 已启动 = 启动剧情Boss战(bossUnit, {
    触发单位: 玩家单位,
    暂停来源: 菲尼克斯尔待战暂停来源,
  });
  if (已启动 && 当前进度 === 43) 进入主线节点(44);
}

export const 菲尼克斯尔Boss战剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_启动菲尼克斯尔Boss战": 执行启动菲尼克斯尔Boss战,
};
