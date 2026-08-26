/** @noSelfInFile */

const jass = require("jass.common") as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, 施法单位: any, 技能ID: number) => void) => void;
};
const { 解析配置内部ID, 解析配置内部ID列表 } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
  解析配置内部ID列表: (this: void, 配置列表: readonly (string | undefined | null)[]) => number[];
};
const { getItemDataEntry } = require("lib.扩展函数.物品相关函数.装备数据查询") as {
  getItemDataEntry: (this: void, item: any) => any | null;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 显示单位数值漂浮文字 } = require("lib.扩展函数.封装函数.03．漂浮文字.05．数值漂浮文字") as {
  显示单位数值漂浮文字: (this: void, unit: any, value: number, options?: Record<string, any>) => any;
};

import { 点金术配置 } from "./00．点金术配置";

const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;
const GetSpellTargetItem = jass.GetSpellTargetItem as (this: void) => any;
const GetItemType = jass.GetItemType as (this: void, item: any) => any;
const GetItemCharges = jass.GetItemCharges as (this: void, item: any) => number;
const GetItemName = jass.GetItemName as (this: void, item: any) => string;
const GetItemX = jass.GetItemX as (this: void, item: any) => number;
const GetItemY = jass.GetItemY as (this: void, item: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerState = jass.GetPlayerState as (this: void, player: any, playerState: any) => number;
const SetPlayerState = jass.SetPlayerState as (this: void, player: any, playerState: any, value: number) => void;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  this: void,
  player: any,
  x: number,
  y: number,
  duration: number,
  message: string,
) => void;
const RemoveItem = jass.RemoveItem as (this: void, item: any) => void;
const R2I = jass.R2I as (this: void, value: number) => number;
const PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD as any;
const ITEM_TYPE_PURCHASABLE = jass.ITEM_TYPE_PURCHASABLE as any;
const ITEM_TYPE_CHARGED = jass.ITEM_TYPE_CHARGED as any;
const 点金术技能类型ID = 解析配置内部ID(点金术配置.技能ID);
const 特殊价格物品类型ID列表 = 解析配置内部ID列表(点金术配置.特殊价格物品ID列表);
const 禁止物品类型ID列表 = 解析配置内部ID列表(点金术配置.禁止物品ID列表);

let 已初始化点金术 = false;

function 列表包含(this: void, 列表: readonly number[], 物品类型ID: number): boolean {
  for (let i = 0; i < 列表.length; i++) {
    if (列表[i] === 物品类型ID) return true;
  }
  return false;
}

function 读取点金基础价格(this: void, 物品: any): number | null {
  const 数据 = getItemDataEntry(物品);
  if (数据 == null || typeof 数据.goldPrice !== "number") return null;

  const 物品类型 = GetItemType(物品);
  const 充能数 = GetItemCharges(物品);
  const 按充能计价 = 物品类型 === ITEM_TYPE_PURCHASABLE || 物品类型 === ITEM_TYPE_CHARGED;
  if (按充能计价 && 充能数 > 0) {
    // 当前装备数据没有旧物编 uses 字段；goldPrice 按单个充能价格处理，后续补齐物编 uses 时再细化。
    return R2I(数据.goldPrice * 充能数);
  }
  return R2I(数据.goldPrice);
}

function 显示点金失败(this: void, 玩家: any, 物品: any): void {
  if (玩家 == null || 玩家 === 0) return;
  const 物品名 = 物品 != null && 物品 !== 0 ? GetItemName(物品) : "该物品";
  DisplayTimedTextToPlayer(
    玩家,
    0,
    0,
    15,
    "|cFFFFFF00『系统提示』：|r" + 点金术配置.失败提示前缀 + 物品名 + "』无法点金",
  );
}

function 增加玩家金币(this: void, 玩家: any, 金币: number): void {
  if (玩家 == null || 玩家 === 0) return;
  const 当前金币 = GetPlayerState(玩家, PLAYER_STATE_RESOURCE_GOLD);
  SetPlayerState(玩家, PLAYER_STATE_RESOURCE_GOLD, 当前金币 + 金币);
}

function 处理点金术生效(this: void, 施法单位: any, 技能ID: number): void {
  if (施法单位 == null || 施法单位 === 0 || 技能ID !== 点金术技能类型ID) return;

  const 玩家 = GetOwningPlayer(施法单位);
  const 目标物品 = GetSpellTargetItem();
  if (目标物品 == null || 目标物品 === 0) {
    显示点金失败(玩家, null);
    return;
  }

  const 物品类型ID = GetItemTypeId(目标物品);
  if (列表包含(禁止物品类型ID列表, 物品类型ID)) {
    显示点金失败(玩家, 目标物品);
    return;
  }

  const 初始价格 = 读取点金基础价格(目标物品);
  if (初始价格 == null) {
    显示点金失败(玩家, 目标物品);
    return;
  }

  const 价格分母 = 列表包含(特殊价格物品类型ID列表, 物品类型ID)
    ? 点金术配置.特殊价格分母
    : 点金术配置.默认价格分母;
  const 获得金币 = R2I(初始价格 / 价格分母);
  const 物品X = GetItemX(目标物品);
  const 物品Y = GetItemY(目标物品);

  增加玩家金币(玩家, 获得金币);
  显示单位数值漂浮文字(施法单位, 获得金币, {
    大小: 12,
    红: 255,
    绿: 255,
    蓝: 0,
    持续时间: 1,
    上飘速度: 0.07,
  });
  createTimedEffect(点金术配置.成功特效路径, 物品X, 物品Y, 0, 点金术配置.成功特效持续秒);
  RemoveItem(目标物品);
}

export function init点金术(this: void): void {
  if (已初始化点金术) return;
  已初始化点金术 = true;
  registerSpellEffectListener(处理点金术生效);
}

export {};
