/** @noSelfInFile */

import { 蕾米莉亚单位技能配置 } from "./00．配置";
import { 蕾米莉亚BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/03．蕾米莉亚";

const jass = require("jass.common") as any;
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, params: any) => void;
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
const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, source: string) => boolean;
};
const { 获取范围敌军, 单位存活, 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
  单位存活: (this: void, unit: any) => boolean;
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 读取单位最大生命 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位最大生命: (this: void, unit: any) => number;
};
const { 造成批量AOE技能伤害, 创建独立技能伤害实例, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
  创建独立技能伤害实例: (this: void, params?: any) => number;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, source: any, target: any, as: number, ms: number, time: number, sourceName?: string, sourceType?: "装备" | "技能", displayBuffID?: string) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};
const { 创建点特效, 创建单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

const E配置 = (蕾米莉亚单位技能配置 as any).E as any;
const E技能ID = stringToFourCCSafe(E配置.技能ID ?? "0002");
const 单位类型ID = (蕾米莉亚单位技能配置 as any).单位类型ID as number;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const ShowUnit = jass.ShowUnit as (this: void, unit: any, show: boolean) => void;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;

interface 蕾米莉亚E上下文 {
  施法者: any;
  技能实例ID?: number;
  延迟回调ID: number;
  周期回调ID: number;
  伤害攻击力快照: number;
  周期次数: number;
  已启动: boolean;
  已暂停: boolean;
  目标属性记录: Record<number, boolean>;
}

const 上下文表: Record<number, 蕾米莉亚E上下文 | undefined> = {};
let 死亡监听已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : GetHandleId(unit) || 0;
}

function 获取或创建E上下文(this: void, unit: any): 蕾米莉亚E上下文 | undefined {
  const id = 取单位句柄ID(unit);
  if (id === 0) return undefined;
  const old = 上下文表[id];
  if (old != null) return old;
  const created: 蕾米莉亚E上下文 = {
    施法者: unit,
    延迟回调ID: 0,
    周期回调ID: 0,
    伤害攻击力快照: 0,
    周期次数: 0,
    已启动: false,
    已暂停: false,
    目标属性记录: {},
  };
  上下文表[id] = created;
  return created;
}

function 目标允许E伤害(this: void, target: any): boolean {
  return 单位存活(target)
    && !IsUnitType(target, UNIT_TYPE_ANCIENT)
    && !IsUnitType(target, UNIT_TYPE_MECHANICAL)
    && !IsUnitType(target, UNIT_TYPE_STRUCTURE);
}

function 准备E批量目标伤害(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 蕾米莉亚E上下文 | undefined;
  if (context == null || !目标允许E伤害(target)) return undefined;
  const fire = GetRandomInt(1, 2) === 1;
  const targetId = GetHandleId(target) || 0;
  if (targetId !== 0) context.目标属性记录[targetId] = fire;
  const effect = fire ? E配置.表现.火属性 : E配置.表现.暗属性;
  if (fire) 创建点特效({ 模型路径: effect.特效模型路径, X: GetUnitX(target), Y: GetUnitY(target), 持续秒: effect.特效持续秒 });
  施加快速减速Buff(context.施法者, target, 0, 0.30, 0.60, "蕾米莉亚-E-血雾", "技能");
  return {
    伤害: context.伤害攻击力快照 * (E配置.单次伤害攻击力倍率 ?? 0.10),
    伤害类型: fire ? DAMAGE_TYPE_FIRE : DAMAGE_TYPE_SHADOW_STRIKE,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
  };
}

function 处理E目标结算后(this: void, target: any, _index: number, _成功: boolean, variable?: any): void {
  const context = variable as 蕾米莉亚E上下文 | undefined;
  if (context == null) return;
  const targetId = GetHandleId(target) || 0;
  const fire = context.目标属性记录[targetId];
  if (fire === false) {
    const effect = E配置.表现.暗属性;
    创建点特效({ 模型路径: effect.特效模型路径, X: GetUnitX(target), Y: GetUnitY(target), 持续秒: effect.特效持续秒 });
  }
  if (targetId !== 0) delete context.目标属性记录[targetId];
}

function 清理E上下文(this: void, context: 蕾米莉亚E上下文): void {
  if (context.延迟回调ID !== 0) {
    removeDelayedCallback(context.延迟回调ID);
    context.延迟回调ID = 0;
  }
  if (context.周期回调ID !== 0) {
    removePeriodicCallback(context.周期回调ID);
    context.周期回调ID = 0;
  }
  if (context.已启动) {
    销毁单位坐标跟随特效(context.施法者, E配置.表现.血雾.特效键);
    移除单位指定Buff(context.施法者, 蕾米莉亚BuffID.血雾形态);
    ShowUnit(context.施法者, true);
    const maxLife = 读取单位最大生命(context.施法者);
    const life = jass.GetUnitState(context.施法者, jass.UNIT_STATE_LIFE) || 0;
    const endVoice = E配置.结束语音;
    if (maxLife > 0 && life >= maxLife * (E配置.结束生命比例阈值 ?? 0.85)
      && endVoice?.路径 != null && endVoice.路径 !== "") {
      Sound3DII_UnitPlayReuse(endVoice.路径, context.施法者, endVoice.裁断距离);
    }
    context.已启动 = false;
  }
  if (context.已暂停) {
    解除暂停并取消无敌安全(context.施法者, E配置.暂停来源 ?? "蕾米莉亚-E-血雾形态");
    context.已暂停 = false;
  }
  SetUnitTimeScale(context.施法者, 1);
  结束独立技能伤害实例(context.技能实例ID);
  context.技能实例ID = undefined;
  context.目标属性记录 = {};
  const id = 取单位句柄ID(context.施法者);
  if (id !== 0 && 上下文表[id] === context) delete 上下文表[id];
}

function 蕾米莉亚E周期Tick(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚E上下文 | undefined;
  if (context == null || !context.已启动) return;
  if (!单位存活(context.施法者) || context.周期次数 >= (E配置.持续次数 ?? 10)) {
    清理E上下文(context);
    return;
  }
  if (E配置.周期语音?.路径 != null && E配置.周期语音.路径 !== "") {
    Sound3DII_UnitPlayReuse(E配置.周期语音.路径, context.施法者, E配置.周期语音.裁断距离);
  }
  创建点特效({ 模型路径: E配置.表现.周期爆炸.模型路径, X: GetUnitX(context.施法者), Y: GetUnitY(context.施法者), 缩放: E配置.表现.周期爆炸.缩放, 持续秒: E配置.表现.周期爆炸.持续秒 });
  创建点特效({ 模型路径: E配置.表现.周期血雾.模型路径, X: GetUnitX(context.施法者), Y: GetUnitY(context.施法者), 缩放: E配置.表现.周期血雾.缩放, 持续秒: E配置.表现.周期血雾.持续秒 });
  context.周期次数 += 1;
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: 获取范围敌军(context.施法者, GetUnitX(context.施法者), GetUnitY(context.施法者), E配置.伤害范围 ?? 600),
    来源类型: "单位技能",
    技能ID: E技能ID,
    技能实例ID: context.技能实例ID,
    伤害形态: "AOE",
    每目标处理器: 准备E批量目标伤害,
    每目标结算后处理器: 处理E目标结算后,
    变量: context,
  });
}

function 蕾米莉亚E延迟启动(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚E上下文 | undefined;
  if (context == null) return;
  context.延迟回调ID = 0;
  if (!单位存活(context.施法者)) {
    清理E上下文(context);
    return;
  }
  context.已启动 = true;
  ShowUnit(context.施法者, false);
  if (E配置.启动语音?.路径 != null && E配置.启动语音.路径 !== "") {
    Sound3DII_UnitPlayReuse(E配置.启动语音.路径, context.施法者, E配置.启动语音.裁断距离);
  }
  创建单位坐标跟随特效(context.施法者, E配置.表现.血雾.模型路径, E配置.表现.血雾.特效键, E配置.表现.血雾.缩放, E配置.表现.跟随高度);
  registerManualBuff(context.施法者, 蕾米莉亚BuffID.血雾形态, (E配置.持续次数 ?? 10) * (E配置.周期间隔毫秒 ?? 300) / 1000 + 0.3, 1, { sourceName: "蕾米莉亚-E-血雾形态" });
  context.周期回调ID = addPeriodicCallback(E配置.周期间隔毫秒 ?? 300, 蕾米莉亚E周期Tick, context);
}

function 释放蕾米莉亚E(this: void, context: 蕾米莉亚E上下文, caster: any, 技能实例ID?: number): void {
  if (context.延迟回调ID !== 0 || context.已启动) return;
  context.技能实例ID = 技能实例ID ?? 创建独立技能伤害实例({ 技能ID: E技能ID, 来源类型: "单位技能", 持续时间秒: 4.8 });
  const level = GetUnitAbilityLevel(caster, E技能ID) || 1;
  context.伤害攻击力快照 = 读取单位攻击力(caster) * ((E配置.攻击力基础倍率 ?? 1.5) + (E配置.攻击力每级倍率 ?? 0.2) * level);
  context.已暂停 = 暂停并设置无敌安全(caster, E配置.暂停来源 ?? "蕾米莉亚-E-血雾形态");
  SetUnitTimeScale(caster, E配置.动作速度 ?? 2);
  if (context.已暂停 && E配置.动作 != null && E配置.动作 !== "") SetUnitAnimation(caster, E配置.动作);
  context.延迟回调ID = addDelayedCallback(E配置.延迟启动毫秒 ?? 1000, 蕾米莉亚E延迟启动, context);
}

function 蕾米莉亚E单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 上下文表[取单位句柄ID(dyingUnit)];
  if (context != null) 清理E上下文(context);
}

function 获取E上下文(this: void, unit: any): 蕾米莉亚E上下文 | undefined {
  return 获取或创建E上下文(unit);
}

注册单位技能壳监听({
  名称: "蕾米莉亚-命运Miserable Fate（E）",
  单位类型ID,
  技能ID: E技能ID,
  获取或创建上下文: 获取E上下文,
  释放技能: 释放蕾米莉亚E,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 4.8,
});

if (!死亡监听已注册) {
  死亡监听已注册 = true;
  registerDeathListener(蕾米莉亚E单位死亡);
}

export {};
