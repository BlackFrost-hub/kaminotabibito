/** @noSelfInFile */

import { 藤原妹红单位技能配置 } from "./00．配置";
import { 读取单位攻击力, 单位未标记死亡 as 单位有效 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import {
  主动引爆护盾仍有效,
  创建主动引爆护盾,
  引爆主动引爆护盾,
  护盾类型,
  清理主动引爆护盾,
  type 主动引爆护盾控制器,
} from "../../../00．技能模板+函数/01．技能函数/07．护盾";

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { createUnitEffect, destroyUnitEffect, createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  destroyUnitEffect: (this: void, unit: any, effectKey?: string) => void;
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, 参数: any) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;

interface 藤原妹红W运行时上下文 {
  施法者: any;
  护盾目标: any;
  护盾ID: number;
  周期回调ID: number;
  周期伤害: number;
  护盾控制器?: 主动引爆护盾控制器;
}

const 藤原妹红单位类型ID = stringToFourCCSafe(藤原妹红单位技能配置.单位类型ID);
const 主技能ID = stringToFourCCSafe(藤原妹红单位技能配置.主技能ID);
const 引爆技能ID = stringToFourCCSafe(藤原妹红单位技能配置.引爆技能ID);
const 藤原妹红W上下文表: Record<number, 藤原妹红W运行时上下文 | undefined> = {};
let 藤原妹红W死亡监听已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 获取或创建藤原妹红W上下文(this: void, unit: any): 藤原妹红W运行时上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  if (unitId === 0) return undefined;
  const current = 藤原妹红W上下文表[unitId];
  if (current != null) return current;
  const created: 藤原妹红W运行时上下文 = {
    施法者: unit,
    护盾目标: undefined,
    护盾ID: 0,
    周期回调ID: 0,
    周期伤害: 0,
    护盾控制器: undefined,
  };
  藤原妹红W上下文表[unitId] = created;
  return created;
}

function 获取藤原妹红W上下文(this: void, unit: any): 藤原妹红W运行时上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  return unitId === 0 ? undefined : 藤原妹红W上下文表[unitId];
}

function 清理藤原妹红W状态(this: void, unit: any, shieldId?: number): void {
  const context = 获取藤原妹红W上下文(unit);
  if (context == null) return;
  if (shieldId != null && context.护盾ID !== 0 && context.护盾ID !== shieldId) return;

  const 控制器 = context.护盾控制器;
  context.护盾控制器 = undefined;
  清理主动引爆护盾(控制器, "技能状态清理");
}

function 藤原妹红W护盾清理(this: void, _controller: 主动引爆护盾控制器, _reason: string): void {
  const context = 获取藤原妹红W上下文(_controller.施法者);
  destroyUnitEffect(_controller.护盾目标, 藤原妹红单位技能配置.表现资源.护盾特效键);
  if (context == null) return;
  if (context.护盾控制器 != null && context.护盾控制器 !== _controller) return;

  if (context.周期回调ID !== 0) {
    removePeriodicCallback(context.周期回调ID);
    context.周期回调ID = 0;
  }
  context.护盾目标 = undefined;
  context.护盾ID = 0;
  context.周期伤害 = 0;
  context.护盾控制器 = undefined;
}

function 周期目标允许藤原妹红W伤害(this: void, target: any): boolean {
  if (!单位有效(target)) return false;
  if (IsUnitType(target, UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(target, UNIT_TYPE_MECHANICAL)) return false;
  if (IsUnitType(target, UNIT_TYPE_STRUCTURE)) return false;
  return true;
}

function 引爆目标允许藤原妹红W伤害(this: void, target: any): boolean {
  if (!单位有效(target)) return false;
  if (IsUnitType(target, UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(target, UNIT_TYPE_STRUCTURE)) return false;
  return true;
}

function 准备藤原妹红W周期目标伤害(this: void, target: any, _index: number): any {
  return 周期目标允许藤原妹红W伤害(target) ? {} : undefined;
}

function 准备藤原妹红W引爆目标伤害(this: void, target: any, _index: number): any {
  return 引爆目标允许藤原妹红W伤害(target) ? {} : undefined;
}

function 造成藤原妹红W周期伤害(this: void, context: 藤原妹红W运行时上下文): void {
  const caster = context.施法者;
  const target = context.护盾目标;
  if (!单位有效(caster) || !单位有效(target)) return;
  const targets = 获取范围敌军(caster, GetUnitX(target), GetUnitY(target), 藤原妹红单位技能配置.周期伤害半径);
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: targets,
    伤害: context.周期伤害,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 主技能ID,
    每目标处理器: 准备藤原妹红W周期目标伤害,
  });
}

function 藤原妹红W周期Tick(this: void, variable?: any): void {
  const context = variable as 藤原妹红W运行时上下文 | undefined;
  if (context == null || context.护盾ID === 0) return;
  if (!单位有效(context.施法者) || !单位有效(context.护盾目标)) {
    清理藤原妹红W状态(context.施法者, context.护盾ID);
    return;
  }
  if (!主动引爆护盾仍有效(context.护盾控制器)) {
    清理藤原妹红W状态(context.施法者, context.护盾ID);
    return;
  }
  造成藤原妹红W周期伤害(context);
}

function 创建藤原妹红W护盾(this: void, context: 藤原妹红W运行时上下文, caster: any): boolean {
  if (!单位有效(caster) || GetUnitTypeId(caster) !== 藤原妹红单位类型ID) return false;
  if (context.护盾ID !== 0) return false;

  const target = GetSpellTargetUnit();
  if (!单位有效(target)) return false;

  const attack = 读取单位攻击力(caster);
  const shieldValue = attack * 藤原妹红单位技能配置.护盾值攻击力倍率;
  const periodicDamage = attack * 藤原妹红单位技能配置.周期伤害攻击力倍率;
  if (!(shieldValue > 0) || !(periodicDamage > 0)) return false;

  context.施法者 = caster;
  context.护盾目标 = target;
  context.周期伤害 = periodicDamage;
  const 控制器 = 创建主动引爆护盾({
    名称: "藤原妹红-火焰护盾",
    施法者: caster,
    护盾目标: target,
    主技能ID,
    引爆技能ID,
    护盾标签: 藤原妹红单位技能配置.护盾标签,
    护盾参数: {
      类型: 护盾类型.通用,
      数值: shieldValue,
      持续时间: 藤原妹红单位技能配置.护盾持续秒,
      来源单位: caster,
      显示护盾条: true,
      可驱散: false,
    },
    on创建前: 藤原妹红W护盾创建前,
    on清理: 藤原妹红W护盾清理,
    on引爆前: 藤原妹红W护盾引爆前,
  });
  if (控制器 == null) {
    context.护盾目标 = undefined;
    context.周期伤害 = 0;
    return false;
  }
  context.护盾控制器 = 控制器;
  context.护盾ID = 控制器.护盾ID;
  context.周期回调ID = addPeriodicCallback(
    藤原妹红单位技能配置.周期伤害间隔毫秒,
    藤原妹红W周期Tick,
    context,
  );
  return true;
}

function 藤原妹红W护盾创建前(this: void, controller: 主动引爆护盾控制器): void {
  createUnitEffect(
    controller.护盾目标,
    藤原妹红单位技能配置.表现资源.护盾特效挂点,
    藤原妹红单位技能配置.表现资源.护盾特效路径,
    undefined,
    藤原妹红单位技能配置.表现资源.护盾特效键,
  );
}

function 藤原妹红W护盾引爆前(this: void, controller: 主动引爆护盾控制器, damage: number): void {
  const caster = controller.施法者;
  const target = controller.护盾目标;
  createTimedEffect(
    藤原妹红单位技能配置.表现资源.引爆特效路径,
    GetUnitX(caster),
    GetUnitY(caster),
    0,
    藤原妹红单位技能配置.表现资源.引爆特效持续秒,
  );
  const targets = 获取范围敌军(caster, GetUnitX(target), GetUnitY(target), 藤原妹红单位技能配置.引爆范围);
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: targets,
    伤害: damage,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: true,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 引爆技能ID,
    每目标处理器: 准备藤原妹红W引爆目标伤害,
  });
}

function 引爆藤原妹红W护盾(this: void, context: 藤原妹红W运行时上下文, caster: any): void {
  if (!单位有效(caster)) return;
  引爆主动引爆护盾(context.护盾控制器);
}

function 藤原妹红W主技能监听(this: void, _context: 藤原妹红W运行时上下文, caster: any): void {
  const context = 获取藤原妹红W上下文(caster);
  if (context != null) 创建藤原妹红W护盾(context, caster);
}

function 藤原妹红W引爆监听(this: void, _context: 藤原妹红W运行时上下文, caster: any): void {
  const context = 获取藤原妹红W上下文(caster);
  if (context != null) 引爆藤原妹红W护盾(context, caster);
}

function 藤原妹红W单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  for (const key in 藤原妹红W上下文表) {
    const context = 藤原妹红W上下文表[Number(key)];
    if (context == null) continue;
    if (context.施法者 !== dyingUnit && context.护盾目标 !== dyingUnit) continue;
    const caster = context.施法者;
    清理藤原妹红W状态(caster, context.护盾ID);
    if (caster === dyingUnit) delete 藤原妹红W上下文表[Number(key)];
  }
}

export function 注册藤原妹红W技能(this: void): void {
  注册单位技能壳监听({
    名称: "藤原妹红-火焰护盾",
    单位类型ID: 藤原妹红单位类型ID,
    技能ID: 主技能ID,
    获取或创建上下文: 获取或创建藤原妹红W上下文,
    创建独立技能实例: false,
    释放技能: 藤原妹红W主技能监听,
  });
  注册单位技能壳监听({
    名称: "藤原妹红-火焰护盾引爆",
    单位类型ID: 藤原妹红单位类型ID,
    技能ID: 引爆技能ID,
    获取或创建上下文: 获取或创建藤原妹红W上下文,
    创建独立技能实例: false,
    释放技能: 藤原妹红W引爆监听,
  });
  if (!藤原妹红W死亡监听已注册) {
    藤原妹红W死亡监听已注册 = true;
    registerDeathListener(藤原妹红W单位死亡);
  }
}

注册藤原妹红W技能();

export const 藤原妹红W技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "火属性AOE技能伤害",
  护盾值: "施法者攻击力×4",
  周期伤害: "每0.5秒，施法者攻击力×0.4，半径350码",
  引爆伤害: "剩余护盾值100%，半径600码",
} as const;
