/** @noSelfInFile */


import { 主动物品调试日志 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitRace = jass.IsUnitRace as (unit: any, race: any) => boolean;
const IsHeroUnitId = jass.IsHeroUnitId as (unitId: number) => boolean;
const KillUnit = jass.KillUnit as (unit: any) => void;
const UnitApplyTimedLife = jass.UnitApplyTimedLife as (unit: any, buffId: number, duration: number) => void;
const RACE_DEMON = jass.RACE_DEMON as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 使者精神魔杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 使者精神魔杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
import { 创建单位时限数值 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/16．单位时限数值";

const 限时生命BuffID = stringToFourCCSafe("BHwe");
const 使者精神魔杖存储 = 创建单位时限数值("使者精神魔杖存储");

function 是否为使者精神魔杖(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 使者精神魔杖物品ID;
}

function 目标可存储(this: void, 目标单位: any): boolean {
  if (目标单位 == null || 目标单位 === 0) return false;
  if (IsUnitRace(目标单位, RACE_DEMON)) return false;
  return !IsHeroUnitId(GetUnitTypeId(目标单位));
}

export function 处理使者精神魔杖使用(this: void, 上下文: 物品技能事件上下文): void {
  主动物品调试日志("21．使者精神魔杖", "进入", "处理使者精神魔杖使用");

  if (!是否为使者精神魔杖(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  if (施法单位 == null || 施法单位 === 0) return;

  const 已存储 = 使者精神魔杖存储.存在(施法单位);
  const 目标单位 = 上下文.目标单位;
  if (!已存储) {
    if (!目标可存储(目标单位)) return;
    KillUnit(目标单位);
    使者精神魔杖存储.写入(施法单位, GetUnitTypeId(目标单位), 使者精神魔杖配置.存储持续时间);
    return;
  }

  const 存储单位类型 = 使者精神魔杖存储.消耗(施法单位);
  if (存储单位类型 == null || 存储单位类型 === 0) return;
  const x = 目标单位 == null || 目标单位 === 0 ? 上下文.目标X : GetUnitX(目标单位);
  const y = 目标单位 == null || 目标单位 === 0 ? 上下文.目标Y : GetUnitY(目标单位);
  const 召唤单位 = 创建单位并登记排泄安全(GetOwningPlayer(施法单位), 存储单位类型, x, y, GetUnitFacing(施法单位));
  if (召唤单位 != null && 召唤单位 !== 0) {
    UnitApplyTimedLife(召唤单位, 限时生命BuffID, 使者精神魔杖配置.召唤持续时间);
  }
}

export {};
