/** @noSelfInFile */

import { 阿伦劳特单位技能配置 } from "./00．配置";
import { 单位有效 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 开始击退 } from "../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, sourceName?: string, sourceType?: "装备" | "技能") => void;
};
const { 开始无敌帧 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧") as {
  开始无敌帧: (this: void, unit: any, duration: number) => number;
};
const { 开始护盾, 护盾类型, 查询单位标签护盾值, 移除单位标签护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾") as {
  开始护盾: (this: void, unit: any, params: any) => number;
  护盾类型: { 通用: number };
  查询单位标签护盾值: (this: void, unit: any, tag: string) => number;
  移除单位标签护盾: (this: void, unit: any, tag: string) => void;
};
const {
  创建单位坐标跟随特效,
  销毁单位坐标跟随特效,
  createTimedUnitEffect,
} = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;

const 光形态单位ID = stringToFourCCSafe(阿伦劳特单位技能配置.光形态单位ID);
const 暗形态单位ID = stringToFourCCSafe(阿伦劳特单位技能配置.暗形态单位ID);
const 主技能ID = stringToFourCCSafe(阿伦劳特单位技能配置.主技能ID);
const 引爆技能ID = stringToFourCCSafe(阿伦劳特单位技能配置.引爆技能ID);
const 天堂呼唤强化BuffID = stringToFourCCSafe(阿伦劳特单位技能配置.天堂呼唤强化BuffID);
const 裁决审判强化BuffID = stringToFourCCSafe(阿伦劳特单位技能配置.裁决审判强化BuffID);

export interface 阿伦劳特运行时上下文 {
  单位: any;
  裁决护盾ID: number;
}

const 阿伦劳特上下文表: Record<number, 阿伦劳特运行时上下文 | undefined> = {};
let 已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 获取或创建阿伦劳特上下文(this: void, unit: any): 阿伦劳特运行时上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  if (unitId === 0) return undefined;
  const current = 阿伦劳特上下文表[unitId];
  if (current != null) return current;
  const created: 阿伦劳特运行时上下文 = {
    单位: unit,
    裁决护盾ID: 0,
  };
  阿伦劳特上下文表[unitId] = created;
  return created;
}

function 取阿伦劳特上下文(this: void, unit: any): 阿伦劳特运行时上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  return unitId === 0 ? undefined : 阿伦劳特上下文表[unitId];
}

function 单位拥有原生Buff(this: void, unit: any, buffId: number): boolean {
  if (unit == null || unit === 0 || buffId === 0) return false;
  return GetUnitAbilityLevel(unit, buffId) > 0;
}

function 清理裁决护盾技能状态(this: void, unit: any, shieldId?: number): void {
  const context = 取阿伦劳特上下文(unit);
  if (context == null) return;
  if (shieldId != null && context.裁决护盾ID !== 0 && context.裁决护盾ID !== shieldId) return;

  context.裁决护盾ID = 0;
  销毁单位坐标跟随特效(unit, 阿伦劳特单位技能配置.表现资源.裁决护盾特效键);
  UnitRemoveAbility(unit, 引爆技能ID);
  const owner = GetOwningPlayer(unit);
  if (owner != null && owner !== 0) SetPlayerAbilityAvailable(owner, 主技能ID, true);
}

function 阿伦劳特护盾破碎(this: void, unit: any, shieldId: number, _absorbed: number): void {
  清理裁决护盾技能状态(unit, shieldId);
}

function 阿伦劳特护盾结束(this: void, unit: any, shieldId: number, _reason: string): void {
  清理裁决护盾技能状态(unit, shieldId);
}

function 创建裁决护盾(this: void, unit: any): boolean {
  if (!单位有效(unit) || GetUnitTypeId(unit) !== 暗形态单位ID) return false;
  const context = 获取或创建阿伦劳特上下文(unit);
  if (context == null) return false;
  if (查询单位标签护盾值(unit, 阿伦劳特单位技能配置.裁决护盾标签) > 0) return false;

  const config = 阿伦劳特单位技能配置;
  const 强化 = 单位拥有原生Buff(unit, 裁决审判强化BuffID);
  const 护盾值 = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)
    * (强化 ? config.裁决护盾强化最大生命比例 : config.裁决护盾默认最大生命比例);
  if (!(护盾值 > 0)) return false;

  const owner = GetOwningPlayer(unit);
  if (owner != null && owner !== 0) SetPlayerAbilityAvailable(owner, 主技能ID, false);
  UnitAddAbility(unit, 引爆技能ID);
  创建单位坐标跟随特效(
    unit,
    config.表现资源.裁决护盾特效路径,
    config.表现资源.裁决护盾特效键,
    config.表现资源.裁决护盾特效缩放,
    config.表现资源.裁决护盾特效高度,
  );

  const shieldId = 开始护盾(unit, {
    类型: 护盾类型.通用,
    数值: 护盾值,
    持续时间: config.裁决护盾持续秒,
    来源单位: unit,
    显示护盾条: true,
    可驱散: false,
    标签: config.裁决护盾标签,
    破碎回调: 阿伦劳特护盾破碎,
    结束回调: 阿伦劳特护盾结束,
  });
  if (shieldId === 0) {
    清理裁决护盾技能状态(unit);
    return false;
  }
  context.裁决护盾ID = shieldId;
  return true;
}

function 播放裁决护盾引爆表现(this: void, unit: any): void {
  const config = 阿伦劳特单位技能配置;
  createTimedUnitEffect(
    unit,
    "origin",
    config.表现资源.裁决护盾引爆特效路径A,
    config.表现资源.引爆特效持续秒,
  );
  createTimedUnitEffect(
    unit,
    "origin",
    config.表现资源.裁决护盾引爆特效路径B,
    config.表现资源.引爆特效持续秒,
  );
}

function 结算裁决护盾引爆(this: void, unit: any): void {
  if (!单位有效(unit)) return;
  const config = 阿伦劳特单位技能配置;
  const x = GetUnitX(unit);
  const y = GetUnitY(unit);
  const targets = 获取范围敌军(unit, x, y, config.引爆范围);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位有效(target)) continue;
    if (IsUnitType(target, UNIT_TYPE_ANCIENT) || IsUnitType(target, UNIT_TYPE_MECHANICAL)) continue;
    施加眩晕(unit, target, config.引爆眩晕秒, "阿伦劳特-裁决护盾", "技能");
    开始击退(target, {
      来源单位: unit,
      距离: config.引爆击退距离,
      持续时间: config.引爆击退持续秒,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      主单位死亡时中断: false,
    });
  }
}

function 引爆裁决护盾(this: void, unit: any): void {
  if (!单位有效(unit) || GetUnitTypeId(unit) !== 暗形态单位ID) return;
  if (查询单位标签护盾值(unit, 阿伦劳特单位技能配置.裁决护盾标签) <= 0) {
    清理裁决护盾技能状态(unit);
    return;
  }
  播放裁决护盾引爆表现(unit);
  移除单位标签护盾(unit, 阿伦劳特单位技能配置.裁决护盾标签);
  结算裁决护盾引爆(unit);
}

export function 释放神圣护甲(this: void, unit: any): boolean {
  if (!单位有效(unit) || GetUnitTypeId(unit) !== 光形态单位ID) return false;
  const duration = 单位拥有原生Buff(unit, 天堂呼唤强化BuffID)
    ? 阿伦劳特单位技能配置.神圣护甲强化持续秒
    : 阿伦劳特单位技能配置.神圣护甲默认持续秒;
  return 开始无敌帧(unit, duration) > 0;
}

export function 释放裁决护盾(this: void, unit: any): boolean {
  return 创建裁决护盾(unit);
}

function 阿伦劳特神圣护甲监听(this: void, _context: 阿伦劳特运行时上下文, unit: any): void {
  释放神圣护甲(unit);
}

function 阿伦劳特裁决护盾监听(this: void, _context: 阿伦劳特运行时上下文, unit: any): void {
  释放裁决护盾(unit);
}

function 阿伦劳特护盾引爆监听(this: void, _context: 阿伦劳特运行时上下文, unit: any): void {
  引爆裁决护盾(unit);
}

function 阿伦劳特单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const unitTypeId = GetUnitTypeId(dyingUnit);
  if (unitTypeId !== 光形态单位ID && unitTypeId !== 暗形态单位ID) return;
  清理裁决护盾技能状态(dyingUnit);
  const unitId = 取单位句柄ID(dyingUnit);
  if (unitId !== 0) delete 阿伦劳特上下文表[unitId];
}

export function 注册阿伦劳特神圣护甲与裁决护盾(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "阿伦劳特-神圣护甲",
    单位类型ID: 光形态单位ID,
    技能ID: 主技能ID,
    获取或创建上下文: 获取或创建阿伦劳特上下文,
    创建独立技能实例: false,
    释放技能: 阿伦劳特神圣护甲监听,
  });
  注册单位技能壳监听({
    名称: "阿伦劳特-裁决护盾",
    单位类型ID: 暗形态单位ID,
    技能ID: 主技能ID,
    获取或创建上下文: 获取或创建阿伦劳特上下文,
    创建独立技能实例: false,
    释放技能: 阿伦劳特裁决护盾监听,
  });
  注册单位技能壳监听({
    名称: "阿伦劳特-裁决护盾引爆",
    单位类型ID: 暗形态单位ID,
    技能ID: 引爆技能ID,
    获取或创建上下文: 获取或创建阿伦劳特上下文,
    创建独立技能实例: false,
    释放技能: 阿伦劳特护盾引爆监听,
  });
  registerDeathListener(阿伦劳特单位死亡);
}

注册阿伦劳特神圣护甲与裁决护盾();

export const 阿伦劳特神圣护甲与裁决护盾技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: "无直接伤害",
  神圣护甲: "光形态免疫伤害3秒；拥有B018时免疫5秒",
  裁决护盾: "暗形态获得最大生命值50%的4秒通用护盾；拥有B015时为100%",
  引爆效果: "400范围内敌方非远古、非机械单位眩晕1秒并击退400码",
} as const;
