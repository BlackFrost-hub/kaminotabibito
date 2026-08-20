/** @noSelfInFile */

import { 蕾米莉亚单位技能配置 } from "./00．配置";
import { 蕾米莉亚BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/03．蕾米莉亚";
import { 读取单位攻击力, 单位存活, 取单位ID } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const { GS_UnitPry } = require("lib.扩展函数.Star扩展函数.02．GS单位属性") as {
  GS_UnitPry: (this: void, unit: any, change: number, propertyType: number, value: number) => void;
};
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, unit: any, attributeName: string, delta: number) => void;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 造成批量AOE技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const {
  创建点特效,
  创建单位坐标跟随特效,
  销毁单位坐标跟随特效,
  设置特效颜色,
} = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
  设置特效颜色: (this: void, effect: any, red: number, green: number, blue: number, alpha?: number) => void;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetHeroStr = jass.GetHeroStr as (this: void, hero: any, includeBonuses: boolean) => number;
const SetHeroStr = jass.SetHeroStr as (this: void, hero: any, value: number, permanent: boolean) => void;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const R2I = jass.R2I as (this: void, value: number) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;

interface 蕾米莉亚W上下文 {
  施法者: any;
  技能实例ID?: number;
  延迟回调ID: number;
  周期回调ID: number;
  伤害攻击力快照: number;
  增加力量: number;
  周期次数: number;
  已启动: boolean;
  目标属性记录: Record<number, boolean>;
}

const W配置 = 蕾米莉亚单位技能配置.W;
const W技能类型ID = W配置.技能类型ID;
const 上下文表: Record<number, 蕾米莉亚W上下文 | undefined> = {};
let 死亡监听已注册 = false;

function 获取W上下文(this: void, unit: any): 蕾米莉亚W上下文 | undefined {
  const unitId = 取单位ID(unit);
  if (unitId === 0) return undefined;
  return 上下文表[unitId];
}

function 获取或创建W上下文(this: void, unit: any): 蕾米莉亚W上下文 | undefined {
  const unitId = 取单位ID(unit);
  if (unitId === 0) return undefined;
  const current = 上下文表[unitId];
  if (current != null) return current;
  const created: 蕾米莉亚W上下文 = {
    施法者: unit,
    延迟回调ID: 0,
    周期回调ID: 0,
    伤害攻击力快照: 0,
    增加力量: 0,
    周期次数: 0,
    已启动: false,
    目标属性记录: {},
  };
  上下文表[unitId] = created;
  return created;
}

function 调整英雄基础力量(this: void, hero: any, delta: number): void {
  if (hero == null || hero === 0 || delta === 0) return;
  const baseStrength = GetHeroStr(hero, false) || 0;
  SetHeroStr(hero, baseStrength + delta, true);
}

function 创建跟随表现(this: void, context: 蕾米莉亚W上下文): void {
  const caster = context.施法者;
  const color = W配置.表现.顶点颜色;
  const judgment = W配置.表现.审判;
  const holyFire = W配置.表现.圣火;
  const judgmentEffect = 创建单位坐标跟随特效(
    caster,
    judgment.模型路径,
    judgment.特效键,
    judgment.缩放,
    W配置.表现.跟随高度,
  );
  设置特效颜色(judgmentEffect, color.红, color.绿, color.蓝, color.透明度);
  const holyFireEffect = 创建单位坐标跟随特效(
    caster,
    holyFire.模型路径,
    holyFire.特效键,
    holyFire.缩放,
    W配置.表现.跟随高度,
  );
  设置特效颜色(holyFireEffect, color.红, color.绿, color.蓝, color.透明度);
}

function 清理W上下文(this: void, context: 蕾米莉亚W上下文): void {
  if (context.延迟回调ID !== 0) {
    removeDelayedCallback(context.延迟回调ID);
    context.延迟回调ID = 0;
  }
  if (context.周期回调ID !== 0) {
    removePeriodicCallback(context.周期回调ID);
    context.周期回调ID = 0;
  }
  结束独立技能伤害实例(context.技能实例ID);
  context.技能实例ID = undefined;
  if (context.已启动) {
    GS_UnitPry(context.施法者, 1, 13, W配置.基础生命值百分比增量);
    调整英雄基础力量(context.施法者, -context.增加力量);
    调整玩家属性(context.施法者, "百分比生命回复", -W配置.百分比生命回复增量);
    销毁单位坐标跟随特效(context.施法者, W配置.表现.审判.特效键);
    销毁单位坐标跟随特效(context.施法者, W配置.表现.圣火.特效键);
    移除单位指定Buff(context.施法者, 蕾米莉亚BuffID.红符法阵);
    context.已启动 = false;
  }
  context.目标属性记录 = {};
  const unitId = 取单位ID(context.施法者);
  if (unitId !== 0 && 上下文表[unitId] === context) delete 上下文表[unitId];
}

function 目标允许W伤害(this: void, target: any): boolean {
  if (!单位存活(target)) return false;
  if (IsUnitType(target, UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(target, UNIT_TYPE_MECHANICAL)) return false;
  if (IsUnitType(target, UNIT_TYPE_STRUCTURE)) return false;
  return true;
}

function 创建W周期特效(this: void, caster: any): void {
  const effect = W配置.表现.周期特效;
  创建点特效({
    模型路径: effect.模型路径,
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    Z轴角度: effect.Z轴角度,
    缩放: effect.缩放,
    动画速度: effect.动画速度,
    持续秒: effect.持续秒,
  });
}

function 准备W批量目标伤害(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 蕾米莉亚W上下文 | undefined;
  if (context == null || !目标允许W伤害(target)) return undefined;

  const useFire = GetRandomInt(1, 2) === 1;
  const targetId = GetHandleId(target) || 0;
  if (targetId !== 0) context.目标属性记录[targetId] = useFire;
  const effectConfig = useFire ? W配置.表现.火属性 : W配置.表现.暗属性;
  const damageType = useFire ? DAMAGE_TYPE_FIRE : DAMAGE_TYPE_SHADOW_STRIKE;
  if (useFire) 创建点特效({ 模型路径: effectConfig.特效模型路径, X: GetUnitX(target), Y: GetUnitY(target), 持续秒: effectConfig.特效持续秒 });
  const damage = context.伤害攻击力快照 * W配置.单次伤害攻击力倍率
    + (GetHeroStr(context.施法者, true) || 0) * W配置.单次伤害力量倍率;
  return {
    伤害: damage,
    伤害类型: damageType,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
  };
}

function 处理W目标结算后(this: void, target: any, _index: number, _成功: boolean, variable?: any): void {
  const context = variable as 蕾米莉亚W上下文 | undefined;
  if (context == null) return;
  const targetId = GetHandleId(target) || 0;
  if (context.目标属性记录[targetId] === false) {
    const effect = W配置.表现.暗属性;
    创建点特效({ 模型路径: effect.特效模型路径, X: GetUnitX(target), Y: GetUnitY(target), 持续秒: effect.特效持续秒 });
  }
  if (targetId !== 0) delete context.目标属性记录[targetId];
}

function 蕾米莉亚W周期Tick(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚W上下文 | undefined;
  if (context == null || !context.已启动) return;
  if (!单位存活(context.施法者)) {
    清理W上下文(context);
    return;
  }
  if (context.周期次数 >= W配置.持续次数) {
    清理W上下文(context);
    return;
  }

  创建W周期特效(context.施法者);
  if (W配置.周期语音?.路径 != null) {
    Sound3DII_UnitPlayReuse(W配置.周期语音.路径, context.施法者, W配置.周期语音.裁断距离);
  }
  context.周期次数 += 1;
  const targets = 获取范围敌军(
    context.施法者,
    GetUnitX(context.施法者),
    GetUnitY(context.施法者),
    W配置.伤害范围,
  );
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: targets,
    来源类型: "单位技能",
    技能ID: W技能类型ID,
    技能实例ID: context.技能实例ID,
    伤害形态: "AOE",
    每目标处理器: 准备W批量目标伤害,
    每目标结算后处理器: 处理W目标结算后,
    变量: context,
  });
}

function 播放W启动表现(this: void, caster: any): void {
  if (W配置.动作编号 >= 0) {
    开始硬直(caster, W配置.动作硬直秒 ?? 0.1);
    SetUnitAnimationByIndex(caster, W配置.动作编号);
    SetUnitTimeScale(caster, W配置.动作速度);
  }
  Sound3DII_UnitPlayReuse(W配置.语音.路径, caster, W配置.语音.裁断距离);
}

function 蕾米莉亚W延迟启动(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚W上下文 | undefined;
  if (context == null) return;
  context.延迟回调ID = 0;
  if (context.已启动 || !单位存活(context.施法者)) {
    清理W上下文(context);
    return;
  }

  const caster = context.施法者;
  const level = GetUnitAbilityLevel(caster, W技能类型ID);
  const attack = 读取单位攻击力(caster);
  context.伤害攻击力快照 = attack * (W配置.伤害攻击力快照倍率 + W配置.伤害攻击力每级倍率 * level);
  context.增加力量 = R2I((GetHeroStr(caster, true) || 0) * W配置.力量增加比例);
  context.已启动 = true;

  播放W启动表现(caster);
  GS_UnitPry(caster, 0, 13, W配置.基础生命值百分比增量);
  调整英雄基础力量(caster, context.增加力量);
  调整玩家属性(caster, "百分比生命回复", W配置.百分比生命回复增量);
  registerManualBuff(caster, 蕾米莉亚BuffID.红符法阵, W配置.持续次数 * W配置.周期间隔毫秒 / 1000 + 0.3, 1, {
    sourceName: "蕾米莉亚-红符法阵",
  });
  创建跟随表现(context);
  context.周期回调ID = addPeriodicCallback(W配置.周期间隔毫秒, 蕾米莉亚W周期Tick, context);
}

function 蕾米莉亚W可释放(this: void, context: 蕾米莉亚W上下文, _caster: any): boolean {
  return !context.已启动 && context.延迟回调ID === 0;
}

function 释放蕾米莉亚W(this: void, context: 蕾米莉亚W上下文, caster: any, 技能实例ID?: number): void {
  if (context.已启动 || context.延迟回调ID !== 0) return;
  context.技能实例ID = 技能实例ID;
  context.延迟回调ID = addDelayedCallback(W配置.延迟启动毫秒, 蕾米莉亚W延迟启动, context);
}

function 蕾米莉亚W单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 获取W上下文(dyingUnit);
  if (context != null) 清理W上下文(context);
}

export function 注册蕾米莉亚W(this: void): void {
  注册单位技能壳监听({
    名称: "蕾米莉亚-红符“Bloody Magic Square”（W）",
    单位类型ID: 蕾米莉亚单位技能配置.单位类型ID,
    技能ID: W配置.技能ID,
    获取或创建上下文: 获取或创建W上下文,
    可释放: 蕾米莉亚W可释放,
    释放技能: 释放蕾米莉亚W,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: W配置.技能实例持续时间秒,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(蕾米莉亚W单位死亡);
  }
}

注册蕾米莉亚W();

export const 蕾米莉亚W技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "随机火/暗属性AOE技能伤害",
  伤害: "开启时攻击力快照×(1+20%×技能等级)，每次取10%并加当前力量×30%",
  持续: "每秒1次，共10次",
} as const;
