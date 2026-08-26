/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, 施法单位: any, 技能ID: number) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { YDUserDataGetSafe, YDUserDataSetSafe, YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 两点角度, 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const { 执行战斗自身位移到坐标 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制") as {
  执行战斗自身位移到坐标: (this: void, unit: any, x: number, y: number) => boolean;
};

import { 召唤师技能配置 } from "./00．召唤师技能配置";

const SetUnitStateJapi = japi.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (this: void, value: number) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetWidgetLife = jass.GetWidgetLife as (this: void, widget: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const IsTerrainPathable = jass.IsTerrainPathable as (this: void, x: number, y: number, pathingType: any) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, modelName: string, targetWidget: any, attachPointName: string) => any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  this: void,
  player: any,
  x: number,
  y: number,
  duration: number,
  message: string,
) => void;
const UNIT_STATE_ARMOR = ConvertUnitState(0x20);
const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as any;
const 嘲讽技能类型ID = 解析配置内部ID(召唤师技能配置.嘲讽技能ID);
const 极限复苏技能类型ID = 解析配置内部ID(召唤师技能配置.极限复苏技能ID);
const 闪烁技能类型ID = 解析配置内部ID(召唤师技能配置.闪烁技能ID);

interface 嘲讽结束状态 {
  单位: any;
  玩家: any;
}

interface 极限复苏结束状态 {
  玩家: any;
}

interface 闪烁运行状态 {
  单位: any;
  起点X: number;
  起点Y: number;
  方向角度: number;
  当前步数: number;
  周期回调ID: number;
}

let 已初始化召唤师技能 = false;

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && GetWidgetLife(单位) > 0.405;
}

function 调整玩家属性(this: void, 玩家: any, 属性名: string, 增量: number): void {
  if (玩家 == null || 玩家 === 0 || 增量 === 0) return;
  const 旧值原始 = YDUserDataGetSafe("player", 玩家, 属性名, "real");
  const 旧值 = typeof 旧值原始 === "number" ? 旧值原始 : 0;
  YDUserDataSetSafe("player", 玩家, 属性名, "real", 旧值 + 增量);
}

function 调整单位护甲(this: void, 单位: any, 增量: number): void {
  if (单位 == null || 单位 === 0 || 增量 === 0) return;
  const 当前护甲 = GetUnitStateJapi(单位, UNIT_STATE_ARMOR) || 0;
  SetUnitStateJapi(单位, UNIT_STATE_ARMOR, 当前护甲 + 增量);
}

function on嘲讽结束(this: void, 状态: 嘲讽结束状态): void {
  if (状态 == null) return;
  调整单位护甲(状态.单位, -召唤师技能配置.嘲讽护甲提升);
  调整玩家属性(状态.玩家, "魔抗", -召唤师技能配置.嘲讽魔抗提升);
}

function on极限复苏结束(this: void, 状态: 极限复苏结束状态): void {
  if (状态 == null) return;
  调整玩家属性(状态.玩家, "生命恢复效率", -召唤师技能配置.极限复苏生命恢复效率提升);
  调整玩家属性(状态.玩家, "受到的治疗率", -召唤师技能配置.极限复苏受到的治疗率提升);
}

function 处理嘲讽(this: void, 施法单位: any): void {
  if (施法单位 == null || 施法单位 === 0) return;
  const 玩家 = GetOwningPlayer(施法单位);
  调整单位护甲(施法单位, 召唤师技能配置.嘲讽护甲提升);
  调整玩家属性(玩家, "魔抗", 召唤师技能配置.嘲讽魔抗提升);
  addDelayedCallback(召唤师技能配置.临时效果持续毫秒, on嘲讽结束, { 单位: 施法单位, 玩家 });
}

function 处理极限复苏(this: void, 施法单位: any): void {
  if (施法单位 == null || 施法单位 === 0) return;
  const 玩家 = GetOwningPlayer(施法单位);
  调整玩家属性(玩家, "生命恢复效率", 召唤师技能配置.极限复苏生命恢复效率提升);
  调整玩家属性(玩家, "受到的治疗率", 召唤师技能配置.极限复苏受到的治疗率提升);

  const 特效 = AddSpecialEffectTarget(
    召唤师技能配置.极限复苏特效路径,
    施法单位,
    召唤师技能配置.极限复苏特效挂点,
  );
  YDWETimerDestroyEffectSafe(召唤师技能配置.极限复苏特效持续秒, 特效);
  addDelayedCallback(召唤师技能配置.临时效果持续毫秒, on极限复苏结束, { 玩家 });
}

function 结束闪烁(this: void, 状态: 闪烁运行状态): void {
  if (状态 == null || !(状态.周期回调ID > 0)) return;
  removePeriodicCallback(状态.周期回调ID);
  状态.周期回调ID = 0;
}

function on闪烁移动(this: void, 状态: 闪烁运行状态): void {
  if (状态 == null || !单位有效(状态.单位)) {
    结束闪烁(状态);
    return;
  }
  if (状态.当前步数 >= 召唤师技能配置.闪烁最大步数) {
    结束闪烁(状态);
    return;
  }

  状态.当前步数++;
  const 移动距离 = 召唤师技能配置.闪烁每步距离 * 状态.当前步数;
  const 移动X = 极坐标X(状态.起点X, 状态.方向角度, 移动距离);
  const 移动Y = 极坐标Y(状态.起点Y, 状态.方向角度, 移动距离);
  if (IsTerrainPathable(移动X, 移动Y, PATHING_TYPE_WALKABILITY)) {
    const 玩家 = GetOwningPlayer(状态.单位);
    DisplayTimedTextToPlayer(玩家, 0, 0, 召唤师技能配置.闪烁阻挡提示持续秒, 召唤师技能配置.闪烁阻挡提示);
    结束闪烁(状态);
    return;
  }

  if (!执行战斗自身位移到坐标(状态.单位, 移动X, 移动Y)) {
    结束闪烁(状态);
    return;
  }
  SetUnitFacing(状态.单位, 状态.方向角度);
  if (状态.当前步数 >= 召唤师技能配置.闪烁最大步数) 结束闪烁(状态);
}

function 处理闪烁(this: void, 施法单位: any): void {
  if (施法单位 == null || 施法单位 === 0) return;
  const 起点X = GetUnitX(施法单位);
  const 起点Y = GetUnitY(施法单位);
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 状态: 闪烁运行状态 = {
    单位: 施法单位,
    起点X,
    起点Y,
    方向角度: 两点角度(起点X, 起点Y, 目标X, 目标Y),
    当前步数: 0,
    周期回调ID: 0,
  };
  状态.周期回调ID = addPeriodicCallback(召唤师技能配置.闪烁移动间隔毫秒, on闪烁移动, 状态);
  if (!(状态.周期回调ID > 0)) return;
}

function on召唤师技能生效(this: void, 施法单位: any, 技能ID: number): void {
  if (技能ID === 嘲讽技能类型ID) 处理嘲讽(施法单位);
  else if (技能ID === 极限复苏技能类型ID) 处理极限复苏(施法单位);
  else if (技能ID === 闪烁技能类型ID) 处理闪烁(施法单位);
}

export function init召唤师技能(this: void): void {
  if (已初始化召唤师技能) return;
  已初始化召唤师技能 = true;
  registerSpellEffectListener(on召唤师技能生效);
}

export {};
