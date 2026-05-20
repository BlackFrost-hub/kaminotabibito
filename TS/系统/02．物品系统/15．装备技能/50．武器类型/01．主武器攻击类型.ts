/** @noSelfInFile */

const jass = require("jass.common") as any;

const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  onItemDrop: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
};
const { 物品是否主武器, 同步单位主武器攻击类型 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.07．武器类型") as {
  物品是否主武器: (this: void, item: any) => boolean;
  同步单位主武器攻击类型: (this: void, unit: any) => boolean;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const IsUnitInGroup = jass.IsUnitInGroup as (unit: any, group: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

const 待刷新单位表: Record<number, any | undefined> = {};
let 已注册主武器攻击类型监听 = false;
let 主武器攻击类型刷新已排队 = false;

function 获取玩家英雄单位组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

function 获取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 单位属于玩家英雄单位组(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (!IsUnitType(unit, UNIT_TYPE_HERO)) return false;
  const 玩家英雄单位组 = 获取玩家英雄单位组();
  if (玩家英雄单位组 == null || 玩家英雄单位组 === 0) return false;
  return IsUnitInGroup(unit, 玩家英雄单位组) === true;
}

function 清空待刷新单位表(this: void): void {
  for (const key in 待刷新单位表) {
    delete 待刷新单位表[key as any];
  }
}

function on批量刷新主武器攻击类型(this: void): void {
  主武器攻击类型刷新已排队 = false;
  for (const key in 待刷新单位表) {
    const unit = 待刷新单位表[key as any];
    if (unit == null || unit === 0) continue;
    if (!单位属于玩家英雄单位组(unit)) continue;
    同步单位主武器攻击类型(unit);
  }
  清空待刷新单位表();
}

function 排队刷新单位主武器攻击类型(this: void, unit: any): void {
  const unitId = 获取单位ID(unit);
  if (unitId === 0) return;
  待刷新单位表[unitId] = unit;
  if (主武器攻击类型刷新已排队) return;
  主武器攻击类型刷新已排队 = true;
  addDelayedCallback(50, on批量刷新主武器攻击类型);
}

function on主武器拾取(this: void, unit: any, item: any): void {
  if (!单位属于玩家英雄单位组(unit)) return;
  if (!物品是否主武器(item)) return;
  排队刷新单位主武器攻击类型(unit);
}

function on主武器丢弃(this: void, unit: any, item: any): void {
  if (!单位属于玩家英雄单位组(unit)) return;
  if (!物品是否主武器(item)) return;
  排队刷新单位主武器攻击类型(unit);
}

export function 初始化主武器攻击类型联动(this: void): void {
  if (已注册主武器攻击类型监听) return;
  已注册主武器攻击类型监听 = true;
  onItemPickup(on主武器拾取);
  onItemDrop(on主武器丢弃);
}

初始化主武器攻击类型联动();

export {};
