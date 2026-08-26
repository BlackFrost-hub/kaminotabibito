/** @noSelfInFile */

const jass = require("jass.common") as any;
const jassGlobals = require("jass.globals") as { udg_WYDW?: any; [key: string]: any };

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, 施法单位: any, 技能ID: number) => void) => void;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};

import { 鱼竿配置, type 鱼竿单位结果配置 } from "./00．鱼竿配置";

const GetHeroLevel = jass.GetHeroLevel as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const IsTerrainPathable = jass.IsTerrainPathable as (this: void, x: number, y: number, pathingType: any) => boolean;
const UnitAddItemById = jass.UnitAddItemById as (this: void, unit: any, itemId: number) => any;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => boolean;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  this: void,
  player: any,
  x: number,
  y: number,
  duration: number,
  message: string,
) => void;
const Player = jass.Player as (this: void, playerId: number) => any;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as any;
const PATHING_TYPE_FLOATABILITY = jass.PATHING_TYPE_FLOATABILITY as any;
const 鱼竿技能类型ID = 解析配置内部ID(鱼竿配置.技能ID);

const 本地重复刷新标记: Record<number, boolean | undefined> = {};
let 已初始化鱼竿 = false;

function 区间命中(this: void, 随机值: number, 最小值: number, 最大值: number): boolean {
  return 随机值 >= 最小值 && 随机值 <= 最大值;
}

function 是鱼竿目标水域(this: void, x: number, y: number): boolean {
  const 行走不可通行 = IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY);
  const 漂浮可通行 = !IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY);
  return 行走不可通行 === 鱼竿配置.行走不可通行 && 漂浮可通行 === 鱼竿配置.漂浮可通行;
}

function 读取重复刷新标记(this: void, 索引: number): boolean {
  const 外部标记表 = jassGlobals.udg_WYDW;
  if (外部标记表 != null) {
    const 外部标记 = 外部标记表[索引];
    if (外部标记 != null) return 外部标记 > 0;
  }
  return 本地重复刷新标记[索引] === true;
}

function 写入重复刷新标记(this: void, 索引: number): void {
  本地重复刷新标记[索引] = true;
  const 外部标记表 = jassGlobals.udg_WYDW;
  if (外部标记表 != null) 外部标记表[索引] = 1;
}

function 读取单位结果所有者(this: void, 所有者: 鱼竿单位结果配置["所有者"]): any {
  if (所有者 === "中立敌对") return Player(PLAYER_NEUTRAL_AGGRESSIVE);
  if (所有者 === "中立被动") return Player(PLAYER_NEUTRAL_PASSIVE);
  return Player(6);
}

function 英雄等级满足(this: void, 配置: 鱼竿单位结果配置, 英雄等级: number): boolean {
  if (配置.最高英雄等级 != null && 英雄等级 > 配置.最高英雄等级) return false;
  if (配置.最低英雄等级 != null && 英雄等级 <= 配置.最低英雄等级) return false;
  return true;
}

function 创建鱼竿单位结果(this: void, 施法单位: any, 目标X: number, 目标Y: number, 配置: 鱼竿单位结果配置): any {
  if (配置.重复刷新标记索引 != null && 读取重复刷新标记(配置.重复刷新标记索引)) return null;

  const 使用目标点 = 配置.使用目标点 === true;
  const 创建X = 使用目标点 ? 目标X : 配置.创建X;
  const 创建Y = 使用目标点 ? 目标Y : 配置.创建Y;
  const 面向角度 = 使用目标点
    ? 两点角度(目标X, 目标Y, GetUnitX(施法单位), GetUnitY(施法单位))
    : 配置.创建面向角度;
  const 单位类型ID = 解析配置内部ID(配置.单位ID);
  if (单位类型ID === 0) return null;

  const 单位 = 创建单位并登记排泄安全(
    读取单位结果所有者(配置.所有者),
    单位类型ID,
    创建X,
    创建Y,
    面向角度,
  );
  if (单位 == null || 单位 === 0) return null;

  if (配置.魔抗 != null) {
    YDUserDataSetSafe("unit", 单位, "魔抗", "real", 配置.魔抗);
  }
  if (配置.重复刷新标记索引 != null) {
    写入重复刷新标记(配置.重复刷新标记索引);
  }
  if (配置.是否把施法者移动到创建点 === true && 配置.施法者移动X != null && 配置.施法者移动Y != null) {
    SetUnitPosition(施法单位, 配置.施法者移动X, 配置.施法者移动Y);
  }
  return 单位;
}

function 显示鱼竿失败(this: void, 施法单位: any): void {
  const 玩家 = GetOwningPlayer(施法单位);
  if (玩家 == null || 玩家 === 0) return;
  DisplayTimedTextToPlayer(玩家, 0, 0, 5, "|cFFFFFF00『系统提示』：|r" + 鱼竿配置.失败提示);
}

function 处理鱼竿生效(this: void, 施法单位: any, 技能ID: number): void {
  if (施法单位 == null || 施法单位 === 0 || 技能ID !== 鱼竿技能类型ID) return;

  // 目标坐标必须在 SPELL_EFFECT 回调中立即读取，不能延迟后再取 GetSpellTargetX/Y。
  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  if (!是鱼竿目标水域(目标X, 目标Y)) return;

  const 随机值 = GetRandomInt(鱼竿配置.随机最小值, 鱼竿配置.随机最大值);
  if (随机值 <= 5) {
    显示鱼竿失败(施法单位);
    return;
  }

  createTimedEffect(鱼竿配置.成功特效路径, 目标X, 目标Y, 0, 鱼竿配置.成功特效持续秒);

  for (let i = 0; i < 鱼竿配置.物品结果列表.length; i++) {
    const 结果 = 鱼竿配置.物品结果列表[i];
    if (!区间命中(随机值, 结果.随机最小值, 结果.随机最大值)) continue;
    const 物品类型ID = 解析配置内部ID(结果.物品ID);
    if (物品类型ID !== 0) UnitAddItemById(施法单位, 物品类型ID);
    break;
  }

  const 英雄等级 = GetHeroLevel(施法单位);
  for (let i = 0; i < 鱼竿配置.单位结果列表.length; i++) {
    const 结果 = 鱼竿配置.单位结果列表[i];
    if (!区间命中(随机值, 结果.随机最小值, 结果.随机最大值)) continue;
    if (!英雄等级满足(结果, 英雄等级)) continue;
    创建鱼竿单位结果(施法单位, 目标X, 目标Y, 结果);
  }
}

export function init鱼竿(this: void): void {
  if (已初始化鱼竿) return;
  已初始化鱼竿 = true;
  registerSpellEffectListener(处理鱼竿生效);
}

export {};
