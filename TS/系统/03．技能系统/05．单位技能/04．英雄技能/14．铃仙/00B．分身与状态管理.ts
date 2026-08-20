/** @noSelfInFile */

/**
 * 铃仙 - 分身与状态管理
 *
 * 职责：
 * - 玩家 → 铃仙本体注册表（技能触发时由单位定位本体）
 * - 分身判定（IsUnitIllusion + E07R）与分身单位组维护（W 5 分身、Q 分身模仿计数）
 * - 全图玩家英雄免疫伤害（D 技能辅助）
 * - 通用工具：玩家英雄单位组快照、单位过滤
 */

import { 铃仙单位技能配置 } from "./00．配置";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { forEachUnitInGroup } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  forEachUnitInGroup: (this: void, group: any, action: (this: void, unit: any) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 秒转毫秒 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.24．整数与时间换算") as {
  秒转毫秒: (this: void, seconds: number) => number;
};

const 铃仙单位类型ID = stringToFourCCSafe(铃仙单位技能配置.单位类型ID);

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const IsUnitIllusion = jass.IsUnitIllusion as (this: void, unit: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;

//=============================================================================
// 一、玩家 → 铃仙本体注册表
//=============================================================================

const 铃仙英雄表: Record<number, any> = {};

export function 是铃仙本体(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) === 铃仙单位类型ID;
}

export function 注册铃仙英雄(this: void, 英雄: any): void {
  if (!是铃仙本体(英雄)) return;
  铃仙英雄表[GetPlayerId(GetOwningPlayer(英雄))] = 英雄;
}

export function 获取玩家铃仙英雄(this: void, player: any): any {
  if (player == null || player === 0) return null;
  const hero = 铃仙英雄表[GetPlayerId(player)];
  if (hero == null || hero === 0 || jass.IsUnitType(hero, jass.UNIT_TYPE_DEAD as any)) return null;
  return hero;
}

/** 是否为铃仙分身（幻象 + 同类型） */
export function 是铃仙分身(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  if (!IsUnitIllusion(unit)) return false;
  return GetUnitTypeId(unit) === 铃仙单位类型ID;
}

//=============================================================================
// 二、分身单位组维护（W 5 分身、Q 分身模仿共享）
//=============================================================================

/** 每个铃仙英雄关联一个分身单位组 */
const 分身单位组表: Record<number, any[]> = {};

export function 获取铃仙分身组(this: void, 英雄: any): any[] {
  const id = GetHandleId(英雄);
  let list = 分身单位组表[id];
  if (list == null) {
    list = [];
    分身单位组表[id] = list;
  }
  return list;
}

export function 铃仙分身数量(this: void, 英雄: any): number {
  const list = 分身单位组表[GetHandleId(英雄)];
  if (list == null) return 0;
  // 清理已失效分身
  for (let i = list.length - 1; i >= 0; i--) {
    const u = list[i];
    if (u == null || u === 0 || IsUnitType(u, jass.UNIT_TYPE_DEAD as any)) list.splice(i, 1);
  }
  return list.length;
}

export function 加入铃仙分身(this: void, 英雄: any, 分身: any): void {
  if (分身 == null || 分身 === 0) return;
  const list = 获取铃仙分身组(英雄);
  if (list.indexOf(分身) < 0) list.push(分身);
}

export function 移除铃仙分身(this: void, 英雄: any, 分身: any): void {
  const list = 分身单位组表[GetHandleId(英雄)];
  if (list == null) return;
  const index = list.indexOf(分身);
  if (index >= 0) list.splice(index, 1);
}

export function 清空铃仙分身(this: void, 英雄: any): void {
  const id = GetHandleId(英雄);
  const list = 分身单位组表[id];
  if (list != null) list.length = 0;
}

//=============================================================================
// 三、全图玩家英雄免疫伤害（D 技能辅助）
//=============================================================================

function 获取玩家英雄单位组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

/** 对所有玩家英雄设置「免疫伤害」标记，持续时间后清除 */
export function 全图英雄免疫伤害(this: void, 持续秒: number): void {
  const group = 获取玩家英雄单位组();
  if (group == null || group === 0) return;
  const 快照: any[] = [];
  forEachUnitInGroup(group, (u) => {
    if (u != null && u !== 0) 快照.push(u);
  });
  for (let i = 0; i < 快照.length; i++) {
    const hero = 快照[i];
    YDUserDataSetSafe("unit", hero, "免疫伤害", "boolean", true);
  }
  addDelayedCallback(秒转毫秒(持续秒), () => {
    for (let i = 0; i < 快照.length; i++) {
      const hero = 快照[i];
      if (hero == null || hero === 0) continue;
      YDUserDataSetSafe("unit", hero, "免疫伤害", "boolean", false);
    }
  });
}

//=============================================================================
// 四、通用目标过滤（排除古树/机械/建筑 + 敌对 + 存活）
//=============================================================================

export function 是有效敌对目标(this: void, 施法者: any, target: any): boolean {
  if (target == null || target === 0 || target === 施法者) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_DEAD as any)) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_ANCIENT as any)) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_MECHANICAL as any)) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_STRUCTURE as any)) return false;
  return jass.IsUnitEnemy(target, GetOwningPlayer(施法者)) === true;
}

export {};
