/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 按结算键执行Boss死亡结算 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑") as {
  按结算键执行Boss死亡结算: (this: void, 结算键: string, Boss单位?: any, 击杀者?: any) => boolean;
};
const { 消费保留剧情Boss死亡击杀者 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.04．死亡事件桥接") as {
  消费保留剧情Boss死亡击杀者: (this: void, bossUnit: any) => any;
};
const { YDUserDataGetSafe, YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { 注册剧情片段清理 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表") as {
  注册剧情片段清理: (this: void, 片段ID: string, 清理函数: (this: void) => void) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文, 写入当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 杀戮食人魔死亡剧情片段 } from "../01．第一章/12．杀戮食人魔二阶段死亡";

const GetDyingUnit = jass.GetDyingUnit as (this: void) => any;
const ForGroup = jass.ForGroup as (this: void, whichGroup: any, callback: (this: void) => void) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;

let 待处理杀戮食人魔尸体: any = null;
let 待处理杀戮食人魔击杀者: any = null;

const 杀戮食人魔死亡需清理英雄实数键 = ["沙漠食人魔", "沙漠食人魔蓄力", "沙漠食人魔蓄力2"];

function on清理英雄食人魔蓄力数据(this: void): void {
  const hero = GetEnumUnit();
  if (hero == null || hero === 0) return;
  for (let i = 0; i < 杀戮食人魔死亡需清理英雄实数键.length; i++) {
    YDUserDataClearSafe("unit", hero, 杀戮食人魔死亡需清理英雄实数键[i], "real");
  }
}

function 清理全体英雄食人魔蓄力数据(this: void): void {
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 != null && 玩家英雄组 !== 0) ForGroup(玩家英雄组, on清理英雄食人魔蓄力数据);
}

function 清理杀戮食人魔死亡片段状态(this: void): void {
  待处理杀戮食人魔尸体 = null;
  待处理杀戮食人魔击杀者 = null;
}

export function 执行杀戮食人魔死亡前置(this: void): void {
  const 上下文 = 读取当前剧情动作上下文();
  const 事件死亡单位 = GetDyingUnit();
  const dyingUnit = 事件死亡单位 != null && 事件死亡单位 !== 0 ? 事件死亡单位 : 上下文.触发单位;
  if (dyingUnit == null || dyingUnit === 0) return;
  const killingUnit = 消费保留剧情Boss死亡击杀者(dyingUnit);
  待处理杀戮食人魔尸体 = dyingUnit;
  待处理杀戮食人魔击杀者 = killingUnit != null && killingUnit !== 0 ? killingUnit : null;
  if (待处理杀戮食人魔击杀者 != null) {
    写入当前剧情动作上下文({ ...上下文, 触发单位: 待处理杀戮食人魔击杀者 });
  }
}

export function 执行杀戮食人魔死亡奖励(this: void): void {
  const dyingUnit = 待处理杀戮食人魔尸体;
  if (dyingUnit == null || dyingUnit === 0) return;
  按结算键执行Boss死亡结算("主线_杀戮食人魔", dyingUnit, 待处理杀戮食人魔击杀者);
  清理全体英雄食人魔蓄力数据();
  清理杀戮食人魔死亡片段状态();
}

export const 杀戮食人魔二阶段死亡剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_杀戮食人魔死亡前置": 执行杀戮食人魔死亡前置,
  "SW01死亡事件_杀戮食人魔死亡奖励": 执行杀戮食人魔死亡奖励,
};

注册剧情片段清理("jlc_slaughter_ogre_death", 清理杀戮食人魔死亡片段状态);
