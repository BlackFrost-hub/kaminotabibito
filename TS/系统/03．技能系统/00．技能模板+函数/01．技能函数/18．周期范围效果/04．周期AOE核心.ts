/** @noSelfInFile */

import type { 周期范围效果参数, 周期范围效果实例 } from "./01．类型";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const IsUnitInGroup = jass.IsUnitInGroup as (whichUnit: any, whichGroup: any) => boolean;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (whichUnit: any, abilityId: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT;

const { 创建区域效果 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.04．区域效果.区域效果") as {
  创建区域效果: (this: void, 参数: any) => any;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 应用腐败层数 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.02．腐败层数") as {
  应用腐败层数: (this: void, 参数: any) => void;
};

const EFFECT_ID_腐败层数 = 3;
const 默认持续时间 = 999;
const 默认检测间隔 = 1;
const 默认半径 = 300;
const AVUL = 0x4176756C;
const BVUL = 0x4276756C;

const 周期范围效果实例表: Record<number, 周期范围效果实例 | undefined> = {};
let 下一个周期范围效果ID = 0;

function 转数字(this: void, value: any): number {
  if (value == null || value === false || value === "") return 0;
  const n = typeof value === "number" ? value : Number(value);
  return n !== n ? 0 : n;
}

function 读取单位X(this: void, 来源单位: any, 参数: 周期范围效果参数): number {
  const value = 转数字(参数.X ?? 参数.x);
  if (value !== 0) return value;
  return 来源单位 != null && 来源单位 !== 0 ? GetUnitX(来源单位) : 0;
}

function 读取单位Y(this: void, 来源单位: any, 参数: 周期范围效果参数): number {
  const value = 转数字(参数.Y ?? 参数.y);
  if (value !== 0) return value;
  return 来源单位 != null && 来源单位 !== 0 ? GetUnitY(来源单位) : 0;
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD);
}

function 单位无敌(this: void, unit: any): boolean {
  return GetUnitAbilityLevel(unit, AVUL) > 0 || GetUnitAbilityLevel(unit, BVUL) > 0;
}

function 是旧腐败目标(this: void, unit: any): boolean {
  if (!单位存活(unit)) return false;
  if (IsUnitType(unit, UNIT_TYPE_ANCIENT)) return false;
  if (单位无敌(unit)) return false;

  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 == null || 玩家英雄组 === 0) return false;
  return IsUnitInGroup(unit, 玩家英雄组) === true;
}

function 销毁周期范围效果上下文(this: void, id: number): void {
  delete 周期范围效果实例表[id];
}

function on周期范围效果周期(this: void, 区域内单位: any[], 回调上下文ID?: number): void {
  const id = 回调上下文ID ?? 0;
  const 实例 = 周期范围效果实例表[id];
  if (实例 == null) return;

  if (!单位存活(实例.来源单位)) {
    实例.区域实例.销毁();
    return;
  }

  const x = GetUnitX(实例.来源单位);
  const y = GetUnitY(实例.来源单位);
  实例.区域实例.移动到(x, y);

  if (实例.特效模型 !== "") {
    EC_CreateEffect(实例.特效模型, x, y, 0, 270, 1.5, 1, 实例.特效持续时间);
  }

  if (实例.效果ID === EFFECT_ID_腐败层数) {
    for (let i = 0; i < 区域内单位.length; i++) {
      const unit = 区域内单位[i];
      if (是旧腐败目标(unit)) {
        应用腐败层数({ 目标单位: unit, 层数: 7, 腐败值: true });
      }
    }
  }
}

function on周期范围效果销毁(this: void, 回调上下文ID?: number): void {
  销毁周期范围效果上下文(回调上下文ID ?? 0);
}

export function 启动周期范围效果(this: void, 参数: 周期范围效果参数): number {
  const 来源单位 = 参数.来源单位 ?? 参数.EffectSourceUnit;
  const 持续时间 = 转数字(参数.持续时间 ?? 参数.EffectTime);
  const 间隔 = 转数字(参数.间隔 ?? 参数.EffectInterval);
  const 半径 = 转数字(参数.半径 ?? 参数.r);
  const id = ++下一个周期范围效果ID;

  const 区域实例 = 创建区域效果({
    X: 读取单位X(来源单位, 参数),
    Y: 读取单位Y(来源单位, 参数),
    半径: 半径 > 0 ? 半径 : 默认半径,
    持续时间: 持续时间 > 0 ? 持续时间 : 默认持续时间,
    检测间隔: 间隔 > 0 ? 间隔 : 默认检测间隔,
    防抖间隔: 0,
    影响目标: "全部",
    所有者: 来源单位,
    显示提示圈: false,
    回调上下文ID: id,
    on周期: on周期范围效果周期,
    on销毁: on周期范围效果销毁,
  });

  周期范围效果实例表[id] = {
    ID: id,
    来源单位,
    特效模型: 参数.特效模型 ?? 参数.AoeEffectFileID ?? "",
    特效持续时间: 间隔 > 0 ? 间隔 : 默认检测间隔,
    效果ID: 转数字(参数.效果ID ?? 参数.EffectID),
    区域实例,
  };
  return id;
}

export {};
