/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

import { 处理尸体召唤 } from "./02．尸体召唤";
import { 处理击杀叠层 } from "./03．击杀叠层";
import type { 死亡事件上下文 } from "./00．类型定义";

const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const 特定敌方玩家ID = 7;
const 远古单位类型 = jass.UNIT_TYPE_ANCIENT as number;
const 机械单位类型 = jass.UNIT_TYPE_MECHANICAL as number;
const 召唤单位类型 = jass.UNIT_TYPE_SUMMONED as number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

function 是否属于监听死亡单位(this: void, 单位: any): boolean {
  const 所有者 = GetOwningPlayer(单位);
  const 玩家ID = GetPlayerId(所有者) as number;
  return 玩家ID === 中立敌对玩家ID || 玩家ID === 特定敌方玩家ID;
}

function 是否通过死亡过滤(this: void, 单位: any): boolean {
  if (!是否属于监听死亡单位(单位)) return false;
  if (IsUnitType(单位, 远古单位类型)) return false;
  if (IsUnitType(单位, 机械单位类型)) return false;
  if (IsUnitType(单位, 召唤单位类型)) return false;
  return true;
}

function 构建死亡事件上下文(this: void, 死亡单位: any, 击杀单位: any): 死亡事件上下文 {
  return {
    死亡单位,
    击杀单位,
    死亡单位所有者: GetOwningPlayer(死亡单位),
    死亡坐标X: GetUnitX(死亡单位) as number,
    死亡坐标Y: GetUnitY(死亡单位) as number,
  };
}

function on装备死亡事件(this: void, 死亡单位: any, 击杀单位: any): void {
  if (死亡单位 == null || 死亡单位 === 0) return;
  if (!是否通过死亡过滤(死亡单位)) return;

  const 上下文 = 构建死亡事件上下文(死亡单位, 击杀单位);
  处理尸体召唤(上下文);
  处理击杀叠层(上下文);
}

registerDeathListener(on装备死亡事件);

export {};
