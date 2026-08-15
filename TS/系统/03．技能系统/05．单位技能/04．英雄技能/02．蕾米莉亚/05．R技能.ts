/** @noSelfInFile */

import { 蕾米莉亚单位技能配置 } from "./00．配置";
import { 蕾米莉亚BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/03．蕾米莉亚";

const jass = require("jass.common") as any;
const { 注册单位技能壳监听 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器") as {
  注册单位技能壳监听: (this: void, params: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 单位存活, 读取单位攻击力, 读取单位最大生命 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
  读取单位攻击力: (this: void, unit: any) => number;
  读取单位最大生命: (this: void, unit: any) => number;
};
const { 开始原地击飞 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.02．原地击飞系统") as {
  开始原地击飞: (this: void, unit: any, params: any) => number;
};
const { 创建点特效, createTimedUnitEffect, 创建单位坐标跟随特效, 销毁单位坐标跟随特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
  创建单位坐标跟随特效: (this: void, unit: any, modelPath: string, effectKey?: string, scale?: number, height?: number) => any;
  销毁单位坐标跟随特效: (this: void, unit: any, effectKey?: string) => void;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 调整玩家属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, unit: any, attributeName: string, delta: number) => void;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};
const { 技能_获取技能当前冷却时间, 技能_获取技能最大冷却时间 } = require("平台扩展API取值") as {
  技能_获取技能当前冷却时间: (this: void, unit: any, abilityId: number) => number;
  技能_获取技能最大冷却时间: (this: void, unit: any, abilityId: number) => number;
};
const { 单位扩展_设移动类型 } = require("平台扩展API动作") as {
  单位扩展_设移动类型: (this: void, unit: any, moveType: number) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { 是否黑天 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.05．昼夜状态") as {
  是否黑天: (this: void) => boolean;
};

const R配置 = 蕾米莉亚单位技能配置.R;
const R技能ID = stringToFourCCSafe(R配置.技能ID);
const 单位类型ID = 蕾米莉亚单位技能配置.单位类型ID;
const R暂停来源 = "蕾米莉亚-R-红色不夜城";
const R吸血BuffID = 蕾米莉亚BuffID.不夜城伤害吸血;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, unit: any, scale: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

interface 蕾米莉亚R上下文 {
  施法者: any;
  技能实例ID?: number;
  延迟回调ID: number;
  硬直结束回调ID: number;
  周期回调ID: number;
  周期次数: number;
  伤害攻击力快照: number;
  原始飞行高度: number;
  已暂停: boolean;
  已启动: boolean;
}

interface R目标处理变量 {
  上下文: 蕾米莉亚R上下文;
  伤害: number;
}

const 上下文表: Record<number, 蕾米莉亚R上下文 | undefined> = {};

function 取单位句柄ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : GetHandleId(unit) || 0;
}

function 获取或创建R上下文(this: void, unit: any): 蕾米莉亚R上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  if (unitId === 0) return undefined;
  const old = 上下文表[unitId];
  if (old != null) return old;
  const created: 蕾米莉亚R上下文 = {
    施法者: unit,
    延迟回调ID: 0,
    硬直结束回调ID: 0,
    周期回调ID: 0,
    周期次数: 0,
    伤害攻击力快照: 0,
    原始飞行高度: 0,
    已暂停: false,
    已启动: false,
  };
  上下文表[unitId] = created;
  return created;
}

function R目标允许(this: void, caster: any, target: any): boolean {
  return 单位存活(target)
    && !IsUnitType(target, UNIT_TYPE_ANCIENT)
    && !IsUnitType(target, UNIT_TYPE_MECHANICAL)
    && !IsUnitType(target, UNIT_TYPE_STRUCTURE)
    && jass.IsUnitEnemy(target, jass.GetOwningPlayer(caster)) === true;
}

function R播放周期表现(this: void, caster: any): void {
  const voice = R配置.语音.周期;
  if (voice?.路径 != null) Sound3DII_UnitPlayReuse(voice.路径, caster, voice.裁断距离);
  if (R配置.周期动作 != null) SetUnitAnimation(caster, R配置.周期动作);
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  const field = R配置.周期法阵;
  const blink = R配置.周期闪烁;
  创建点特效({ 模型路径: field.模型路径, X: x, Y: y, 缩放: field.缩放, 持续秒: field.持续秒, 红: field.红, 绿: field.绿, 蓝: field.蓝, 透明度: field.透明度 });
  创建点特效({ 模型路径: blink.模型路径, X: x, Y: y, 缩放: blink.缩放, 持续秒: blink.持续秒, 红: blink.红, 绿: blink.绿, 蓝: blink.蓝, 透明度: blink.透明度 });
}

function 处理R目标(this: void, target: any, _index: number, variable?: any): any {
  const data = variable as R目标处理变量 | undefined;
  if (data == null || !R目标允许(data.上下文.施法者, target)) return undefined;
  开始硬直(target, R配置.敌人暂停秒);
  开始原地击飞(target, {
    持续时间: R配置.击飞持续秒,
    最小高度: R配置.击飞高度最小,
    最大高度: R配置.击飞高度最大,
    暂停单位: false,
    主单位: data.上下文.施法者,
    主单位死亡时中断: true,
    中断已有跳跃: true,
  });
  const hit = R配置.命中特效;
  createTimedUnitEffect(target, hit.挂点, hit.模型路径, hit.持续秒);
  return {
    伤害: data.伤害,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_METAL_HEAVY_BASH,
  };
}

function 调整R冷却(this: void, caster: any, abilityId: number, multiplier: number): void {
  const current = 技能_获取技能当前冷却时间(caster, abilityId);
  const maximum = 技能_获取技能最大冷却时间(caster, abilityId);
  if (!(current > 0) || !(maximum > 0)) return;
  技能_设置技能冷却时间(caster, abilityId, current * multiplier, maximum);
}

function R结束时缩短技能冷却(this: void, caster: any): void {
  if (!R配置.冷却缩短倍率) return;
  调整R冷却(caster, stringToFourCCSafe(蕾米莉亚单位技能配置.Q.技能ID), R配置.冷却缩短倍率.Q);
  调整R冷却(caster, stringToFourCCSafe(蕾米莉亚单位技能配置.W.技能ID), R配置.冷却缩短倍率.W);
  调整R冷却(caster, stringToFourCCSafe(蕾米莉亚单位技能配置.E.技能ID), R配置.冷却缩短倍率.E);
  调整R冷却(caster, stringToFourCCSafe(蕾米莉亚单位技能配置.额外D.技能ID), R配置.冷却缩短倍率.额外D);
}

function R吸血Buff移除(this: void, unit: any, _buffID: string, row: any): void {
  if (unit == null || unit === 0) return;
  const value = typeof row?.effect === "number" ? row.effect : R配置.伤害吸血;
  调整玩家属性(unit, "伤害吸血", -value);
}

function 清理R上下文(this: void, context: 蕾米莉亚R上下文, 缩短冷却: boolean): void {
  if (context.延迟回调ID !== 0) {
    removeDelayedCallback(context.延迟回调ID);
    context.延迟回调ID = 0;
  }
  if (context.硬直结束回调ID !== 0) {
    removeDelayedCallback(context.硬直结束回调ID);
    context.硬直结束回调ID = 0;
  }
  if (context.周期回调ID !== 0) {
    removePeriodicCallback(context.周期回调ID);
    context.周期回调ID = 0;
  }
  if (context.已启动) {
    if (context.已暂停) {
      移除单位暂停(context.施法者, R暂停来源);
      context.已暂停 = false;
    }
    单位扩展_设移动类型(context.施法者, 0x02);
    SetUnitFlyHeight(context.施法者, context.原始飞行高度, 0.01);
    SetUnitTimeScale(context.施法者, 1);
    SetUnitAnimation(context.施法者, R配置.恢复动作);
    销毁单位坐标跟随特效(context.施法者, R配置.持续表现[0].特效键);
    销毁单位坐标跟随特效(context.施法者, R配置.持续表现[1].特效键);
    if (缩短冷却) {
      const maxLife = 读取单位最大生命(context.施法者);
      const life = GetUnitState(context.施法者, UNIT_STATE_LIFE) || 0;
      if (maxLife > 0 && life >= maxLife * R配置.结束生命比例阈值) R结束时缩短技能冷却(context.施法者);
    }
    context.已启动 = false;
  }
  const unitId = 取单位句柄ID(context.施法者);
  if (unitId !== 0 && 上下文表[unitId] === context) delete 上下文表[unitId];
}

function 蕾米莉亚R周期Tick(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚R上下文 | undefined;
  if (context == null || !context.已启动) return;
  if (!单位存活(context.施法者) || context.周期次数 >= R配置.持续次数) {
    清理R上下文(context, true);
    return;
  }
  R播放周期表现(context.施法者);
  context.周期次数 += 1;
  const damage = context.伤害攻击力快照 * (是否黑天() ? R配置.夜间单次伤害倍率 : R配置.白天单次伤害倍率);
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: 获取范围敌军(context.施法者, GetUnitX(context.施法者), GetUnitY(context.施法者), R配置.伤害范围),
    来源类型: "单位技能",
    技能ID: R技能ID,
    技能实例ID: context.技能实例ID,
    伤害形态: "AOE",
    每目标处理器: 处理R目标,
    变量: { 上下文: context, 伤害: damage },
  });
}

function 蕾米莉亚R硬直结束(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚R上下文 | undefined;
  if (context == null) return;
  context.硬直结束回调ID = 0;
  if (context.已启动 && context.已暂停) {
    移除单位暂停(context.施法者, R暂停来源);
    context.已暂停 = false;
  }
}

function 蕾米莉亚R单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = 上下文表[取单位句柄ID(dyingUnit)];
  if (context != null) 清理R上下文(context, false);
}

function 蕾米莉亚R延迟启动(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚R上下文 | undefined;
  if (context == null) return;
  context.延迟回调ID = 0;
  if (!单位存活(context.施法者)) {
    清理R上下文(context, false);
    return;
  }
  const caster = context.施法者;
  const startVoice = R配置.语音.启动;
  context.已启动 = true;
  const level = GetUnitAbilityLevel(caster, R技能ID) || 1;
  context.伤害攻击力快照 = 读取单位攻击力(caster)
    * (R配置.攻击力基础倍率 + R配置.攻击力每级倍率 * level);
  context.原始飞行高度 = GetUnitFlyHeight(caster);
  context.已暂停 = 添加单位暂停(caster, R暂停来源);
  context.硬直结束回调ID = addDelayedCallback(R配置.硬直秒 * 1000, 蕾米莉亚R硬直结束, context);
  SetUnitTimeScale(caster, R配置.动作速度);
  SetUnitAnimation(caster, R配置.动作);
  单位扩展_设移动类型(caster, 0x04);
  SetUnitFlyHeight(caster, R配置.飞行高度, 0.01);
  if (startVoice?.路径 != null) Sound3DII_UnitPlayReuse(startVoice.路径, caster, startVoice.裁断距离);
  for (let i = 0; i < R配置.持续表现.length; i++) {
    const effect = R配置.持续表现[i];
    创建单位坐标跟随特效(caster, effect.模型路径, effect.特效键, effect.缩放, effect.Z);
  }
  调整玩家属性(caster, "伤害吸血", R配置.伤害吸血);
  registerManualBuff(caster, R吸血BuffID, R配置.伤害吸血持续秒, R配置.伤害吸血, {
    sourceName: "蕾米莉亚-红色不夜城",
    onRemove: R吸血Buff移除,
  });
  context.周期回调ID = addPeriodicCallback(R配置.周期间隔毫秒, 蕾米莉亚R周期Tick, context);
}

function 释放蕾米莉亚R(this: void, context: 蕾米莉亚R上下文, caster: any, skillInstanceId?: number): void {
  if (context.已启动 || context.延迟回调ID !== 0) return;
  context.技能实例ID = skillInstanceId;
  context.周期次数 = 0;
  context.延迟回调ID = addDelayedCallback(R配置.施法延迟毫秒, 蕾米莉亚R延迟启动, context);
}

function 获取R上下文(this: void, unit: any): 蕾米莉亚R上下文 | undefined {
  return 获取或创建R上下文(unit);
}

export function 注册蕾米莉亚R(this: void): void {
  注册单位技能壳监听({
    名称: "蕾米莉亚-红色不夜城（R）",
    单位类型ID,
    技能ID: R技能ID,
    获取或创建上下文: 获取R上下文,
    释放技能: 释放蕾米莉亚R,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 4.5,
  });
}

注册蕾米莉亚R();
registerDeathListener(蕾米莉亚R单位死亡);

export {};
