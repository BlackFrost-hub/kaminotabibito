/** @noSelfInFile */

import { 坂井悠二技能配置 } from "./00．配置";
import { 坂井悠二BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/05．坂井悠二";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 单位存活, 读取单位攻击力, 两点角度 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;

const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const CreateUnit = jass.CreateUnit as (this: void, player: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, speed: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const UnitApplyTimedLife = jass.UnitApplyTimedLife as (this: void, unit: any, buffId: number, duration: number) => void;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, modelName: string, unit: any, attachPoint: string) => any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const stringToFourCC = stringToFourCCSafe;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;

const 配置 = 坂井悠二技能配置.Q;
const 英雄单位类型ID = 坂井悠二技能配置.单位类型ID;
const Q技能ID字符串 = 配置.技能ID;

interface Q上下文 {
  施法者: any;
  技能实例ID?: number;
  已启动: boolean;
  周期回调ID: number;
  当前推进秒: number;
  当前X: number;
  当前Y: number;
  方向角度: number;
  伤害攻击力快照: number;
}

const 上下文表: Record<number, Q上下文 | undefined> = {};
let 死亡监听已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 获取Q上下文(this: void, unit: any): Q上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  return 上下文表[id];
}

function 获取或创建Q上下文(this: void, unit: any): Q上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  const current = 上下文表[id];
  if (current != null) return current;
  const created: Q上下文 = {
    施法者: unit,
    已启动: false,
    周期回调ID: 0,
    当前推进秒: 0,
    当前X: 0,
    当前Y: 0,
    方向角度: 0,
    伤害攻击力快照: 0,
  };
  上下文表[id] = created;
  return created;
}

function 清理Q上下文(this: void, context: Q上下文): void {
  if (context.周期回调ID !== 0) {
    removePeriodicCallback(context.周期回调ID);
    context.周期回调ID = 0;
  }
  context.已启动 = false;
  const id = 取单位句柄ID(context.施法者);
  if (id !== 0 && 上下文表[id] === context) delete 上下文表[id];
}

function 过滤Q命中标的(this: void, 敌军列表: any[]): any[] {
  const result: any[] = [];
  for (let i = 0; i < 敌军列表.length; i++) {
    const u = 敌军列表[i];
    if (u == null || u === 0) continue;
    if (IsUnitType(u, UNIT_TYPE_ANCIENT) || IsUnitType(u, UNIT_TYPE_MECHANICAL) || IsUnitType(u, UNIT_TYPE_STRUCTURE)) continue;
    result.push(u);
  }
  return result;
}

function Q命中定身处理(this: void, target: any, _索引: number, _成功: boolean, 变量?: any): void {
  if (target == null || target === 0) return;
  const caster = 变量 as any;
  if (caster == null || caster === 0) return;
  // 命中定身：1秒几乎无法移动
  施加眩晕(caster, target, 配置.主动.命中控制.控制秒, 坂井悠二BuffID.Q命中定身, "技能");
}

function 推进Q伤害(this: void, context: Q上下文): void {
  const caster = context.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    清理Q上下文(context);
    return;
  }

  const intervalMs = 配置.主动.推进间隔秒 * 1000;
  const 推进步长 = 配置.主动.推进距离;
  const 推进角度 = context.方向角度;
  const 弧度 = 推进角度 * (3.14159265358979 / 180);
  const 新X = context.当前X + 推进步长 * Math.cos(弧度);
  const 新Y = context.当前Y + 推进步长 * Math.sin(弧度);
  context.当前X = 新X;
  context.当前Y = 新Y;
  context.当前推进秒 = context.当前推进秒 + 配置.主动.推进间隔秒;

  // 创建吸血鬼壳 e06T（坂井悠二原壳例外：保留马甲）
  const 壳四CC = stringToFourCC(配置.主动.壳.单位ID);
  const 壳单位 = CreateUnit(GetOwningPlayer(caster), 壳四CC, 新X, 新Y, 推进角度 + 配置.主动.壳.朝向偏移角度);
  if (壳单位 != null && 壳单位 !== 0) {
    SetUnitFlyHeight(壳单位, 配置.主动.壳.飞行高度增量, 0);
    SetUnitFacing(壳单位, 推进角度 + 配置.主动.壳.朝向偏移角度);
    SetUnitScale(壳单位, 配置.主动.壳.缩放, 配置.主动.壳.缩放, 配置.主动.壳.缩放);
    // 马甲为限时生命单位（由 e06T 自带），特效随马甲销毁自动释放
    AddSpecialEffectTarget(配置.主动.壳.模型路径, 壳单位, "origin");
  }

  // AOE 伤害：当前半径内全部敌人，单次伤害为总伤害的 20%
  const 单次伤害 = context.伤害攻击力快照 * 配置.主动.总伤害攻击力倍率 * 配置.主动.单段伤害比例;
  if (单次伤害 > 0) {
    const 敌军列表 = 过滤Q命中标的(获取范围敌军(caster, 新X, 新Y, 配置.主动.命中半径));
    造成批量AOE技能伤害({
      来源: caster,
      目标列表: 敌军列表,
      伤害: 单次伤害,
      伤害类型: jass.DAMAGE_TYPE_MAGIC,
      attackType: jass.ATTACK_TYPE_NORMAL,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      标签: "坂井悠二-Q-吸血鬼-分段",
      技能ID: stringToFourCC(Q技能ID字符串),
      技能实例ID: context.技能实例ID,
      变量: caster,
      每目标结算后处理器: Q命中定身处理,
    });
  }

  if (context.当前推进秒 >= 配置.主动.最大推进时间秒) {
    清理Q上下文(context);
  }
}

function 释放Q技能(this: void, context: Q上下文, caster: any, 技能实例ID?: number): void {
  if (context.已启动) return;
  context.已启动 = true;
  context.技能实例ID = 技能实例ID;
  context.伤害攻击力快照 = 读取单位攻击力(caster);
  context.当前X = GetUnitX(caster);
  context.当前Y = GetUnitY(caster);
  context.方向角度 = GetUnitFacing(caster);
  context.当前推进秒 = 0;

  const 目标X = GetSpellTargetX();
  const 目标Y = GetSpellTargetY();
  const 朝向目标 = 两点角度(context.当前X, context.当前Y, 目标X, 目标Y);
  context.方向角度 = 朝向目标;
  SetUnitFacing(caster, 朝向目标);

  context.周期回调ID = addPeriodicCallback(
    配置.主动.推进间隔秒 * 1000,
    推进Q伤害 as unknown as (this: void, variable?: any) => void,
    context,
  );
}

function Q可释放(this: void, context: Q上下文): boolean {
  return !context.已启动 && context.周期回调ID === 0;
}

function Q单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 获取Q上下文(dyingUnit);
  if (context != null) 清理Q上下文(context);
}

export function 注册坂井悠二Q(this: void): void {
  注册单位技能壳监听({
    名称: "坂井悠二-吸血鬼（Q）",
    单位类型ID: 英雄单位类型ID,
    技能ID: Q技能ID字符串,
    获取或创建上下文: 获取或创建Q上下文,
    可释放: Q可释放,
    释放技能: 释放Q技能,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 配置.主动.最大推进时间秒 + 1,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(Q单位死亡);
  }
}

注册坂井悠二Q();

export const 坂井悠二Q技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "AOE 分段直线推进伤害",
  伤害: "300% 攻击力，分 5 段 × 20%，每 0.21 秒推进 40 码，半径 175",
  命中控制: "几乎无法移动 1 秒（眩晕）",
} as const;
