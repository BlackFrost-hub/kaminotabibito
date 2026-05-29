/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 按结算键获取Boss死亡结算配置, 执行Boss死亡结算 } = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.05．Boss死亡结算.03．核心逻辑") as {
  按结算键获取Boss死亡结算配置: (this: void, 结算键: string) => any;
  执行Boss死亡结算: (this: void, 配置: any, Boss单位?: any, 击杀者?: any) => boolean;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 树魔首领死亡承接剧情片段 } from "../02．第二章/27．树魔首领死亡承接";

const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;

let pendingTreantDeathUnit: any = undefined;

export function 执行树魔首领死亡前置(this: void, 参数: 剧情动作参数表): void {
  const dyingUnit = GetDyingUnit();
  if (dyingUnit == null || dyingUnit === 0) return;

  写入剧情进度(Number(参数.设置剧情进度) || Number(参数.目标进度) || 28);
  pendingTreantDeathUnit = dyingUnit;
}

export function 执行树魔首领死亡奖励(this: void): void {
  if (pendingTreantDeathUnit != null && pendingTreantDeathUnit !== 0) {
    const 结算配置 = 按结算键获取Boss死亡结算配置("主线_树魔首领");
    if (结算配置 != null) {
      执行Boss死亡结算(结算配置, pendingTreantDeathUnit);
    }
  }

  pendingTreantDeathUnit = undefined;
}

function 执行树魔首领死亡后返城(this: void): void {}

export const 树魔首领死亡承接剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_树魔首领死亡前置": 执行树魔首领死亡前置,
  "SW01死亡事件_树魔首领死亡奖励": 执行树魔首领死亡奖励,
  "JLC精灵城_树魔首领死亡后返城": 执行树魔首领死亡后返城,
};
