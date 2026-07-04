/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const 调试模块名 = "盗贼神符魔抗";

function 记录盗贼神符魔抗回退(this: void, unit: any): void {
  debugLogForce(调试模块名, "回退魔抗", "unitId=" + GetHandleId(unit), "delta=" + -物品使用数值配置.盗贼神符魔抗.魔抗提升);
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
  const cfg = 物品使用数值配置.盗贼神符魔抗;
  施加临时属性效果(unit, cfg.持续毫秒, [{ 类型: "玩家属性", 属性名: "魔抗", 数值: cfg.魔抗提升 }], {
    on清除: 记录盗贼神符魔抗回退,
  });
}

export {};
