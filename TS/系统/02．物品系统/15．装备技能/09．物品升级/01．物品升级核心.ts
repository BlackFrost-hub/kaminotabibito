/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerHeroLevelListener } = require("系统.00．核心系统.01．事件中心.06．英雄升级事件中心") as {
  registerHeroLevelListener: (this: void, callback: (this: void, heroUnit: any) => void) => void;
};
const { onItemPickup } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { 处理单位升级属性加成 } = require("系统.02．物品系统.15．装备技能.09．物品升级.00．升级属性加成") as {
  处理单位升级属性加成: (this: void, unit: any) => void;
};
const { 物品升级规则表 } = require("系统.02．物品系统.15．装备技能.09．物品升级.02．物品升级配置表") as {
  物品升级规则表: readonly import("./00．类型定义").物品升级规则[];
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

let 已初始化物品升级 = false;

function 是英雄单位(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  return IsUnitType(单位, UNIT_TYPE_HERO) === true;
}

function on物品升级英雄升级(this: void, 英雄单位: any): void {
  if (!是英雄单位(英雄单位)) return;
  处理单位升级属性加成(英雄单位);
  for (let i = 0; i < 物品升级规则表.length; i++) {
    const 规则 = 物品升级规则表[i];
    规则.处理升级?.(英雄单位);
  }
}

function on物品升级拾取(this: void, 单位: any, 物品: any): void {
  if (!是英雄单位(单位)) return;
  if (物品 == null || 物品 === 0) return;
  const 物品类型ID = GetItemTypeId(物品);
  for (let i = 0; i < 物品升级规则表.length; i++) {
    const 规则 = 物品升级规则表[i];
    if (规则.物品类型ID !== 物品类型ID) continue;
    规则.处理拾取?.(单位);
  }
}

export function 初始化物品升级(this: void): void {
  if (已初始化物品升级) return;
  已初始化物品升级 = true;
  registerHeroLevelListener(on物品升级英雄升级);
  onItemPickup(on物品升级拾取);
}

初始化物品升级();

export {};
