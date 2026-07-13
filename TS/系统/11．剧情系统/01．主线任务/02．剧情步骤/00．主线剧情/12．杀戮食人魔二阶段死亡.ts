/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 按结算键获取Boss死亡结算配置, 执行Boss死亡结算 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑") as {
  按结算键获取Boss死亡结算配置: (this: void, 结算键: string) => any;
  执行Boss死亡结算: (this: void, 配置: any, Boss单位?: any, 击杀者?: any) => boolean;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
export { 杀戮食人魔死亡剧情片段 } from "../01．第一章/12．杀戮食人魔二阶段死亡";

const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;

let 待处理杀戮食人魔尸体: any = null;

export function 执行杀戮食人魔死亡前置(this: void): void {
  const dyingUnit = GetDyingUnit();
  if (dyingUnit == null || dyingUnit === 0) return;
  待处理杀戮食人魔尸体 = dyingUnit;
}

export function 执行杀戮食人魔死亡奖励(this: void): void {
  const dyingUnit = 待处理杀戮食人魔尸体;
  if (dyingUnit == null || dyingUnit === 0) return;
  const 结算配置 = 按结算键获取Boss死亡结算配置("主线_杀戮食人魔");
  if (结算配置 != null) {
    执行Boss死亡结算(结算配置, dyingUnit);
  }
  待处理杀戮食人魔尸体 = null;
}

export const 杀戮食人魔二阶段死亡剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_杀戮食人魔死亡前置": 执行杀戮食人魔死亡前置,
  "SW01死亡事件_杀戮食人魔死亡奖励": 执行杀戮食人魔死亡奖励,
};
