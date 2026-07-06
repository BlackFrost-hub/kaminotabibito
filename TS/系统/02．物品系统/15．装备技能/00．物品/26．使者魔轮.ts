/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { Atan2BJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  Atan2BJ: (this: void, y: number, x: number) => number;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (
    this: void,
    target: any,
    amount: number,
    showText?: boolean,
    showEffect?: boolean,
    effectPath?: string,
  ) => number;
};
const { 播放魔法吸收护盾特效 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.24．魔法吸收护盾.01．魔法吸收护盾") as {
  播放魔法吸收护盾特效: (this: void, 参数: {
    单位: any;
    是否有特效?: boolean;
    特效路径?: string;
    特效挂点?: string;
    特效绑定单位?: boolean;
    特效持续时间?: number;
    特效朝向角度?: number;
  }) => void;
};

const GetItemTypeId = jass.GetItemTypeId as (whichItem: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 使者魔轮物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 使者魔轮配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
import { 创建伤害修正阈值触发 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/13．伤害修正阈值触发";
import { 创建区域承伤吸收场 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/21．区域承伤吸收场";
import { 创建世界坐标护盾条, 更新世界坐标护盾条, 销毁世界坐标护盾条, 护盾类型 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/07．护盾";

let 已注册使者魔轮被动修正 = false;

function 是否为使者魔轮(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  if (使者魔轮物品ID <= 0) return false;
  return GetItemTypeId(物品) === 使者魔轮物品ID;
}

function 取最小值(this: void, a: number, b: number): number {
  return a < b ? a : b;
}

function 计算使者魔轮受击特效角度(this: void, 受伤单位: any, 伤害来源: any): number {
  if (受伤单位 == null || 受伤单位 === 0) return 0;
  if (伤害来源 == null || 伤害来源 === 0) return 0;
  return Atan2BJ(GetUnitY(伤害来源) - GetUnitY(受伤单位), GetUnitX(伤害来源) - GetUnitX(受伤单位));
}

function on使者魔轮被动伤害修正(
  this: void,
  context: {
    target: any;
    attacker: any;
    baseDamage: number;
    currentDamage: number;
    isPhysicalDamage: boolean;
    isMagicDamage: boolean;
    isEnhancedDamage: boolean;
    isTrueDamage: boolean;
    isMetalDamage?: boolean;
    isWoodDamage?: boolean;
    isWaterDamage?: boolean;
    isFireDamage?: boolean;
    isThunderDamage?: boolean;
    isLightDamage?: boolean;
    isDarkDamage?: boolean;
    isNormalAttack: boolean;
    isSkillAttack: boolean;
    isSkillDamage: boolean;
  }
): number {
  const 受伤单位 = context.target;
  if (受伤单位 == null || 受伤单位 === 0) return context.currentDamage;
  if (!(context.currentDamage > 0)) return context.currentDamage;
  if (context.isPhysicalDamage) return context.currentDamage;

  const 当前魔法 = GetUnitState(受伤单位, UNIT_STATE_MANA);
  if (!(当前魔法 > 0)) return context.currentDamage;
  const 最大魔法 = GetUnitStateJapi(受伤单位, UNIT_STATE_MAX_MANA);
  if (!(最大魔法 > 0)) return context.currentDamage;

  const 触发门槛 = 最大魔法 * 使者魔轮配置.被动最低魔法百分比 + 使者魔轮配置.被动最低魔法固定值;
  if (!(当前魔法 > 触发门槛)) return context.currentDamage;

  const 比例吸收上限 = context.currentDamage * 使者魔轮配置.被动魔法吸收比例;
  const 魔法吸收上限 = 当前魔法 * 使者魔轮配置.被动每点魔法吸收伤害;
  const 吸收量 = 取最小值(比例吸收上限, 魔法吸收上限);
  if (!(吸收量 > 0)) return context.currentDamage;

  const 消耗魔法 = 吸收量 / 使者魔轮配置.被动每点魔法吸收伤害;
  减少魔法值(受伤单位, 消耗魔法, true, false);
  播放魔法吸收护盾特效({
    单位: 受伤单位,
    是否有特效: 使者魔轮配置.被动是否有特效,
    特效路径: 使者魔轮配置.被动特效路径,
    特效挂点: 使者魔轮配置.被动特效挂点,
    特效绑定单位: 使者魔轮配置.被动特效绑定单位,
    特效持续时间: 使者魔轮配置.被动特效持续时间,
    特效朝向角度: 计算使者魔轮受击特效角度(受伤单位, context.attacker),
  });
  return context.currentDamage - 吸收量;
}

function 计算使者魔轮被动伤害修正(this: void, event: any): number {
  return on使者魔轮被动伤害修正(event.上下文);
}

function 初始化使者魔轮被动(this: void): void {
  if (已注册使者魔轮被动修正) return;
  已注册使者魔轮被动修正 = true;
  创建伤害修正阈值触发({
    名称: "使者魔轮被动魔法吸收",
    装备名: 使者魔轮配置.装备名称,
    持有者: "受击者",
    优先级: 35,
    计算伤害: 计算使者魔轮被动伤害修正,
  });
}

function 注册使者魔轮魔盾(this: void, 施法单位: any, x: number, y: number, 护盾值: number): void {
  const 护盾条 = 创建世界坐标护盾条({
    X: x,
    Y: y,
    Z: 180,
    最大值: 护盾值,
    当前值: 护盾值,
    类型: 护盾类型.通用,
    持续时间: 使者魔轮配置.持续时间,
    名称: "使者魔轮魔盾",
  });
  const 吸收场 = 创建区域承伤吸收场({
    名称: "使者魔轮魔盾",
    施法单位,
    X: x,
    Y: y,
    持续秒数: 使者魔轮配置.持续时间,
    作用半径: 使者魔轮配置.作用半径,
    吸收值: 护盾值,
    特效路径: 使者魔轮配置.特效路径,
    特效尺寸: 使者魔轮配置.特效尺寸,
    只影响友军: true,
    包含同玩家单位: true,
    吸收量限制为剩余值: false,
    on吸收: function on使者魔轮魔盾吸收(this: void, event: { 剩余吸收值: number }): void {
      更新世界坐标护盾条(护盾条, event.剩余吸收值);
    },
    on结束: function on使者魔轮魔盾结束(this: void): void {
      销毁世界坐标护盾条(护盾条);
    },
  });
  if (吸收场 == null) 销毁世界坐标护盾条(护盾条);
}

export function 处理使者魔轮使用(this: void, 上下文: 物品技能事件上下文): void {
  if (!是否为使者魔轮(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  if (施法单位 == null || 施法单位 === 0) return;

  const 最大魔法 = GetUnitStateJapi(施法单位, UNIT_STATE_MAX_MANA);
  const 消耗魔法 = 最大魔法 * 使者魔轮配置.消耗魔法比例;
  if (!(消耗魔法 > 0)) return;

  const 实际消耗魔法 = -减少魔法值(施法单位, 消耗魔法, true, false);
  if (!(实际消耗魔法 > 0)) return;
  注册使者魔轮魔盾(施法单位, 上下文.目标X, 上下文.目标Y, 实际消耗魔法);
}
初始化使者魔轮被动();

export {};
