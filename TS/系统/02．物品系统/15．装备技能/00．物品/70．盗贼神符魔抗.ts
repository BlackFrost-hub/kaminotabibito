/** @noSelfInFile */

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 调整玩家属性 } from "../05．物品使用/00．公共/02．物品使用工具";

const 回退队列: any[] = [];
const 调试模块名 = "盗贼神符魔抗";

function 回退盗贼神符魔抗(this: void): void {
  const unit = 回退队列.shift();
  if (unit == null || unit === 0) return;
  debugLogForce(调试模块名, "回退魔抗", "unitId=" + GetHandleId(unit), "delta=" + -物品使用数值配置.盗贼神符魔抗.魔抗提升);
  调整玩家属性(unit, "魔抗", -物品使用数值配置.盗贼神符魔抗.魔抗提升);
}

export function 处理盗贼神符魔抗使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.盗贼神符魔抗)) return;
  const unit = ctx.施法单位;
  debugLogForce(
    调试模块名,
    "使用命中",
    "unitId=" + GetHandleId(unit),
    "delta=" + 物品使用数值配置.盗贼神符魔抗.魔抗提升,
    "durationMs=" + 物品使用数值配置.盗贼神符魔抗.持续毫秒,
  );
  调整玩家属性(unit, "魔抗", 物品使用数值配置.盗贼神符魔抗.魔抗提升);
  回退队列.push(unit);
  addDelayedCallback(物品使用数值配置.盗贼神符魔抗.持续毫秒, 回退盗贼神符魔抗);
}

export {};
