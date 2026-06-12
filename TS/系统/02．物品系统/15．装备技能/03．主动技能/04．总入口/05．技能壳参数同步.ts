/** @noSelfInFile */

const jass = require("jass.common") as any;
const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心") as {
  onItemPickup: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
  onItemDrop: (this: void, callback: (this: void, unit: any, item: any) => void) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const platformAbilityAction = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
  技能_设置技能魔法消耗: (this: void, 单位: any, 技能代码: number, 值: number) => boolean;
  技能_设置技能施法距离: (this: void, 单位: any, 技能代码: number, 值: number) => boolean;
  技能_设置技能施法范围: (this: void, 单位: any, 技能代码: number, 值: number) => boolean;
  技能_设置技能命令编号: (this: void, 单位: any, 技能代码: number, 命令ID: number) => boolean;
};

import {
  通用物品技能槽位可用命令ID表,
  通用物品技能槽位配置表,
  type 通用物品技能槽位配置项,
} from "../00．公共/02．通用物品技能槽位配置";

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const OrderId = jass.OrderId as (order: string) => number;
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

let 已初始化主动技能壳参数同步 = false;
const 主动物品运行命令ID表: Record<number, string | undefined> = {};

function 是有效英雄(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true;
}

function 匹配主动技能槽位配置(this: void, itemTypeId: number): 通用物品技能槽位配置项 | undefined {
  for (const 配置 of 通用物品技能槽位配置表) {
    if (stringToFourCCSafe(配置.物编ID) === itemTypeId) return 配置;
  }
  return undefined;
}

function 取物品句柄ID(this: void, item: any): number {
  if (item == null || item === 0) return 0;
  return GetHandleId(item) || 0;
}

function 取物品运行命令ID(this: void, item: any, 配置: 通用物品技能槽位配置项): string {
  const 物品句柄ID = 取物品句柄ID(item);
  return (物品句柄ID > 0 && 主动物品运行命令ID表[物品句柄ID]) || 配置.命令ID;
}

function 收集单位已用主动物品命令ID(this: void, unit: any, 当前物品: any): Record<number, boolean> {
  const 已用: Record<number, boolean> = {};
  for (let 槽位 = 0; 槽位 < 6; 槽位++) {
    const 物品 = UnitItemInSlot(unit, 槽位);
    if (物品 == null || 物品 === 0 || 物品 === 当前物品) continue;

    const 配置 = 匹配主动技能槽位配置(GetItemTypeId(物品));
    if (配置 == null) continue;

    const 命令编号 = OrderId(取物品运行命令ID(物品, 配置));
    if (命令编号 !== 0) 已用[命令编号] = true;
  }
  return 已用;
}

function 选择可用命令ID(this: void, 配置: 通用物品技能槽位配置项, 已用: Record<number, boolean>): string {
  const 默认命令编号 = OrderId(配置.命令ID);
  if (默认命令编号 !== 0 && 已用[默认命令编号] !== true) return 配置.命令ID;

  const 可用命令ID列表 = 通用物品技能槽位可用命令ID表[配置.目标类型];
  for (const 命令ID of 可用命令ID列表) {
    const 命令编号 = OrderId(命令ID);
    if (命令编号 !== 0 && 已用[命令编号] !== true) return 命令ID;
  }
  return 配置.命令ID;
}

function 同步主动物品技能壳命令ID(this: void, unit: any, item: any, 配置: 通用物品技能槽位配置项): void {
  const 技能ID = stringToFourCCSafe(配置.技能ID);
  if (技能ID === 0) return;

  const 物品句柄ID = 取物品句柄ID(item);
  const 可用命令ID = 选择可用命令ID(配置, 收集单位已用主动物品命令ID(unit, item));
  const 命令编号 = OrderId(可用命令ID);
  if (命令编号 === 0) return;

  platformAbilityAction.技能_设置技能命令编号(unit, 技能ID, 命令编号);
  if (物品句柄ID <= 0) return;

  if (可用命令ID === 配置.命令ID) {
    delete 主动物品运行命令ID表[物品句柄ID];
  } else {
    主动物品运行命令ID表[物品句柄ID] = 可用命令ID;
  }
}

function 同步主动物品技能壳参数(this: void, unit: any, 配置: 通用物品技能槽位配置项): void {
  const 技能ID = stringToFourCCSafe(配置.技能ID);
  if (技能ID === 0) return;

  platformAbilityAction.技能_设置技能冷却时间(unit, 技能ID, 0, 配置.冷却时间);
  platformAbilityAction.技能_设置技能魔法消耗(unit, 技能ID, 配置.魔法消耗);
  platformAbilityAction.技能_设置技能施法距离(unit, 技能ID, 配置.施法距离);

  const 施法区域 = 配置.施法区域 ?? 0;
  if (施法区域 > 0) {
    platformAbilityAction.技能_设置技能施法范围(unit, 技能ID, 施法区域);
  }
}

function on主动技能物品拾取(this: void, unit: any, item: any): void {
  if (!是有效英雄(unit)) return;
  if (item == null || item === 0) return;

  const 配置 = 匹配主动技能槽位配置(GetItemTypeId(item));
  if (配置 == null) return;
  同步主动物品技能壳命令ID(unit, item, 配置);
  同步主动物品技能壳参数(unit, 配置);
}

function on主动技能物品丢弃(this: void, unit: any, item: any): void {
  const 物品句柄ID = 取物品句柄ID(item);
  if (物品句柄ID > 0) delete 主动物品运行命令ID表[物品句柄ID];
}

export function 初始化主动技能壳参数同步(this: void): void {
  if (已初始化主动技能壳参数同步) return;
  已初始化主动技能壳参数同步 = true;
  onItemPickup(on主动技能物品拾取);
  onItemDrop(on主动技能物品丢弃);
}

export {};
