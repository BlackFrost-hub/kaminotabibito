/** @noSelfInFile */

import type { 受击反应技能配置 } from "./00．配置类型";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { ObjectType } = require("lib.扩展函数.YDWE函数.index") as {
  ObjectType: { ABILITY: number };
};
const { getObjectPropertySafe, YDWEDistanceBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  getObjectPropertySafe: (this: void, objectType: number, objectId: number | string, property: string) => string;
  YDWEDistanceBetweenUnitsSafe: (this: void, a: any, b: any) => number;
};
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string) => number;
};
const { GetUnitLifePercentBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  GetUnitLifePercentBJ: (this: void, whichUnit: any) => number;
};
const { 单位是否正在原生施法 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.施法状态") as {
  单位是否正在原生施法: (this: void, unit: any) => boolean;
};

const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (whichUnit: any, abilityId: number) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (whichUnit: any, order: string) => boolean;
const IssueNeutralImmediateOrder = jass.IssueNeutralImmediateOrder as (forWhichPlayer: any, whichUnit: any, unitOrder: string) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (whichUnit: any, order: string, x: number, y: number) => boolean;
const IssueNeutralPointOrder = jass.IssueNeutralPointOrder as (forWhichPlayer: any, whichUnit: any, unitOrder: string, x: number, y: number) => boolean;
const IssueTargetOrder = jass.IssueTargetOrder as (whichUnit: any, order: string, targetWidget: any) => boolean;
const IssueNeutralTargetOrder = jass.IssueNeutralTargetOrder as (forWhichPlayer: any, whichUnit: any, unitOrder: string, targetWidget: any) => boolean;
const Player = jass.Player as (playerId: number) => any;

const 中立敌对玩家 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE);
const 技能命令缓存: Record<string, string> = {};
const 技能数值缓存: Record<string, number> = {};
const Buff数值缓存: Record<string, number> = {};

function 获取技能数值ID(this: void, rawcode: string | undefined): number {
  if (rawcode == null || rawcode === "") return 0;
  const cached = 技能数值缓存[rawcode];
  if (cached != null) return cached;
  const value = stringToFourCC(rawcode);
  技能数值缓存[rawcode] = value;
  return value;
}

function 获取Buff数值ID(this: void, rawcode: string | undefined): number {
  if (rawcode == null || rawcode === "") return 0;
  const cached = Buff数值缓存[rawcode];
  if (cached != null) return cached;
  const value = stringToFourCC(rawcode);
  Buff数值缓存[rawcode] = value;
  return value;
}

function 获取当前玩家人数(this: void): number {
  const 玩家人数 = jglobals.udg_T != null ? jglobals.udg_T : jglobals.T;
  return Number(玩家人数) || 0;
}

export function 获取技能命令字串(this: void, skill: 受击反应技能配置): string {
  if (typeof skill.命令字串 === "string" && skill.命令字串 !== "") {
    return skill.命令字串;
  }
  if (typeof skill.技能ID !== "string" || skill.技能ID === "") {
    return "";
  }

  const 命令字段 = skill.命令字段 ?? "Order";
  const 缓存键 = `${skill.技能ID}:${命令字段}`;
  const cached = 技能命令缓存[缓存键];
  if (cached != null) return cached;

  const value = getObjectPropertySafe(ObjectType.ABILITY, skill.技能ID, 命令字段) || "";
  技能命令缓存[缓存键] = value;
  return value;
}

export function 受击技能是否满足条件(this: void, skill: 受击反应技能配置, unit: any, source: any): boolean {
  if (skill.技能ID != null && skill.技能ID !== "") {
    const abilityId = 获取技能数值ID(skill.技能ID);
    if (abilityId === 0 || GetUnitAbilityLevel(unit, abilityId) <= 0) return false;
  }

  if (skill.触发概率分子 != null && skill.触发概率分母 != null) {
    if (skill.触发概率分母 <= 0) return false;
    if (GetRandomInt(1, skill.触发概率分母) > skill.触发概率分子) return false;
  }

  if (skill.最低玩家人数 != null) {
    const 当前玩家人数 = 获取当前玩家人数();
    if (当前玩家人数 < skill.最低玩家人数) return false;
  }

  if (source != null && source !== 0) {
    const distance = YDWEDistanceBetweenUnitsSafe(unit, source);
    if (skill.与伤害来源距离不大于 != null && distance > skill.与伤害来源距离不大于) return false;
    if (skill.与伤害来源距离不小于 != null && distance < skill.与伤害来源距离不小于) return false;
  }

  if (skill.自身生命值不高于 != null && GetUnitLifePercentBJ(unit) > skill.自身生命值不高于) return false;
  if (skill.自身生命值不低于 != null && GetUnitLifePercentBJ(unit) < skill.自身生命值不低于) return false;

  if (skill.需要无BuffID != null && skill.需要无BuffID !== "") {
    const buffId = 获取Buff数值ID(skill.需要无BuffID);
    if (buffId !== 0 && GetUnitAbilityLevel(unit, buffId) > 0) return false;
  }

  return true;
}

function 取下单玩家(this: void, unit: any, skill: 受击反应技能配置): any {
  if (skill.下单归属 === "中立敌对") return 中立敌对玩家;
  return GetOwningPlayer(unit);
}

function 取目标单位(this: void, skill: 受击反应技能配置, unit: any, source: any): any {
  if (skill.目标来源 === "自己") return unit;
  return source;
}

function 取目标坐标(this: void, skill: 受击反应技能配置, unit: any, source: any): [number, number] {
  if (skill.目标来源 === "自己") {
    return [GetUnitX(unit), GetUnitY(unit)];
  }
  return [GetUnitX(source), GetUnitY(source)];
}

export function 尝试执行受击技能(this: void, skill: 受击反应技能配置, unit: any, source: any): boolean {
  if (单位是否正在原生施法(unit)) return false;
  if (!受击技能是否满足条件(skill, unit, source)) return false;

  const order = 获取技能命令字串(skill);
  if (order === "") return false;

  const 下单玩家 = 取下单玩家(unit, skill);
  if (skill.施法方式 === "立即") {
    if (skill.下单归属 === "中立敌对") return IssueNeutralImmediateOrder(下单玩家, unit, order) === true;
    return IssueImmediateOrder(unit, order) === true;
  }

  if (skill.施法方式 === "对单位") {
    const target = 取目标单位(skill, unit, source);
    if (target == null || target === 0) return false;
    if (skill.下单归属 === "中立敌对") return IssueNeutralTargetOrder(下单玩家, unit, order, target) === true;
    return IssueTargetOrder(unit, order, target) === true;
  }

  if (skill.施法方式 === "对点") {
    const target = 取目标坐标(skill, unit, source);
    if (skill.下单归属 === "中立敌对") return IssueNeutralPointOrder(下单玩家, unit, order, target[0], target[1]) === true;
    return IssuePointOrder(unit, order, target[0], target[1]) === true;
  }

  return false;
}

export function 取随机坐标偏移(this: void, source: any, range: number): [number, number] {
  return [
    GetUnitX(source) + GetRandomReal(-range, range),
    GetUnitY(source) + GetRandomReal(-range, range),
  ];
}
