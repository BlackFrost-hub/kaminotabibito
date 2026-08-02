/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效, 取单位ID } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 执行Boss单体技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const { 播放限时单位动画 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待") as {
  播放限时单位动画: (this: void, 参数: any) => any;
};

import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 巴尔扎罗斯技能数值配置, 巴尔扎罗斯音效配置 } from "./02．数值与表现配置";
import { 播放巴尔扎罗斯台词 } from "./14．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import {
  创建锁定单位二阶贝塞尔XYZ轨迹,
  创建原生弹幕,
} from "../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕";

const { 创建血量节点触发器 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.index") as {
  创建血量节点触发器: (this: void, 参数: any) => any;
};
const { 开始护盾, 护盾类型, 查询单位标签护盾值 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾") as {
  开始护盾: (this: void, unit: any, params: any) => number;
  护盾类型: any;
  查询单位标签护盾值: (this: void, unit: any, 标签: string) => number;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any | null;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelPath: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const EXSetEffectZ = japi.EXSetEffectZ as (effect: any, z: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, scale: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, timeScale: number) => void;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

let 熔岩护盾伤害修正已注册 = false;
const 近战反弹冷却表: Record<number, number> = {};
const 冰霜命中护盾时间表: Record<number, number> = {};

interface 熔岩护盾反弹弹幕状态 {
  Boss单位: any;
  攻击单位: any;
}

const 熔岩护盾反弹弹幕状态表: Record<number, 熔岩护盾反弹弹幕状态 | undefined> = {};

function 播放护盾短动作(this: void, boss: any): void {
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  播放限时单位动画({
    单位: boss,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    持续秒: 0.7,
    恢复动画: false,
    恢复动画速度: 1,
  });
}

function 移除一层熔岩暴走(this: void, boss: any): void {
  const buffID = 巴尔扎罗斯单位技能配置.BuffID.熔岩暴走;
  const runtime = getBuffRuntime(boss, buffID);
  if (runtime == null) return;
  const stack = runtime.stack ?? 1;
  if (stack <= 1) {
    移除单位指定Buff(boss, buffID);
    return;
  }
  registerManualBuff(boss, buffID, runtime.remaining ?? 10, runtime.effect ?? 0, {
    stack: stack - 1,
    sourceName: "巴尔扎罗斯",
  });
}

export function 释放巴尔扎罗斯熔岩护盾(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  const shieldValue = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * config.护盾Boss最大生命比例;
  const bossId = 取单位ID(boss);

  播放护盾短动作(boss);
  播放Boss坐标音效(巴尔扎罗斯音效配置.熔岩护盾.护盾生成, GetUnitX(boss), GetUnitY(boss), 巴尔扎罗斯音效配置.默认裁断距离);
  播放巴尔扎罗斯台词(boss, "熔岩护盾");
  const 护盾坐标X = GetUnitX(boss);
  const 护盾坐标Y = GetUnitY(boss);
  const 护盾特效 = AddSpecialEffect(config.特效路径, 护盾坐标X, 护盾坐标Y);
  if (护盾特效 != null && 护盾特效 !== 0) {
    EXSetEffectZ(护盾特效, config.特效高度);
    EXSetEffectSize(护盾特效, config.特效缩放);
  }
  registerManualBuff(boss, 巴尔扎罗斯单位技能配置.BuffID.熔岩护盾, config.持续秒, shieldValue, {
    sourceName: "巴尔扎罗斯",
  });

  开始护盾(boss, {
    类型: 护盾类型.通用,
    数值: shieldValue,
    持续时间: config.持续秒,
    来源单位: boss,
    标签: config.护盾标签,
    结束回调: function 巴尔扎罗斯熔岩护盾结束(this: void): void {
      if (护盾特效 != null && 护盾特效 !== 0) DestroyEffect(护盾特效);
      移除单位指定Buff(boss, 巴尔扎罗斯单位技能配置.BuffID.熔岩护盾);
    },
    破碎回调: function 巴尔扎罗斯熔岩护盾破碎(this: void): void {
      const lastIce = 冰霜命中护盾时间表[bossId] ?? 0;
      if (lastIce > 0 && getServerTime() - lastIce <= 250) {
        移除一层熔岩暴走(boss);
      }
    },
  });
}

function on熔岩护盾反弹弹幕结束(this: void, 原因: string, 弹幕ID: number): void {
  if (原因 === "完成" || 原因 === "距离结束") return;
  delete 熔岩护盾反弹弹幕状态表[弹幕ID];
}

function on熔岩护盾反弹弹幕到达(this: void, 弹幕ID: number): void {
  const state = 熔岩护盾反弹弹幕状态表[弹幕ID];
  delete 熔岩护盾反弹弹幕状态表[弹幕ID];
  if (state == null || !单位有效(state.Boss单位) || !单位有效(state.攻击单位)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  执行Boss单体技能伤害({
    来源: state.Boss单位,
    目标: state.攻击单位,
    伤害公式: {
      来源攻击力比例: config.近战反弹Boss攻击力比例,
      目标最大生命比例: config.近战反弹来源最大生命比例,
    },
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_FIRE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
  });
}

function 发射熔岩护盾反弹弹幕(this: void, boss: any, attacker: any): void {
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  const startX = GetUnitX(boss);
  const startY = GetUnitY(boss);
  const targetX = GetUnitX(attacker);
  const targetY = GetUnitY(attacker);
  const dx = targetX - startX;
  const dy = targetY - startY;
  const distance = SquareRoot(dx * dx + dy * dy);
  let controlX = (startX + targetX) * 0.5 + config.近战反弹控制点侧偏;
  let controlY = (startY + targetY) * 0.5;
  if (distance > 0.01) {
    controlX = (startX + targetX) * 0.5 - dy / distance * config.近战反弹控制点侧偏;
    controlY = (startY + targetY) * 0.5 + dx / distance * config.近战反弹控制点侧偏;
  }
  const barrage = 创建原生弹幕({
    所有者: boss,
    载体模式: "单位",
    模型: config.近战反弹弹道路径,
    缩放: config.近战反弹弹道缩放,
    X: startX,
    Y: startY,
    方向角: 0,
    指定目标: attacker,
    速度: 1,
    生命周期: config.近战反弹弹道飞行秒,
    命中半径: 0,
    禁用碰撞: true,
    不可阻挡: false,
    被阻挡时销毁: true,
    轨迹采样器: 创建锁定单位二阶贝塞尔XYZ轨迹(
      startX,
      startY,
      config.近战反弹起点高度,
      controlX,
      controlY,
      config.近战反弹控制点高度,
      attacker,
      config.近战反弹目标高度,
    ),
    on结束: on熔岩护盾反弹弹幕结束,
    on到达目标点: on熔岩护盾反弹弹幕到达,
  });
  熔岩护盾反弹弹幕状态表[barrage.弹幕ID] = { Boss单位: boss, 攻击单位: attacker };
}

function 尝试安排近战反弹(this: void, boss: any, attacker: any): void {
  if (!单位有效(boss) || !单位有效(attacker)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  const attackerId = 取单位ID(attacker);
  if (attackerId === 0) return;
  const now = getServerTime();
  const nextAllowed = 近战反弹冷却表[attackerId] ?? 0;
  if (now < nextAllowed) return;
  近战反弹冷却表[attackerId] = now + config.近战反弹冷却秒 * 1000;
  发射熔岩护盾反弹弹幕(boss, attacker);
}

function 巴尔扎罗斯熔岩护盾伤害修正(this: void, context: any): number {
  const boss = context.target;
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  if (!单位有效(boss) || 查询单位标签护盾值(boss, config.护盾标签) <= 0) return context.currentDamage;
  if (context.isNormalAttack === true && context.isRangedAttack !== true && 单位有效(context.attacker)) {
    尝试安排近战反弹(boss, context.attacker);
  }
  if (context.isWaterDamage === true) {
    const bossId = 取单位ID(boss);
    if (bossId !== 0) 冰霜命中护盾时间表[bossId] = getServerTime();
    return context.currentDamage * config.冰霜护盾消耗倍率;
  }
  return context.currentDamage;
}

function 确保熔岩护盾伤害修正(this: void): void {
  if (熔岩护盾伤害修正已注册) return;
  熔岩护盾伤害修正已注册 = true;
  registerDamageModifier(巴尔扎罗斯熔岩护盾伤害修正, 110);
}

export function 初始化巴尔扎罗斯熔岩护盾节点(this: void, context: 巴尔扎罗斯运行时上下文): void {
  if (context.熔岩护盾节点已初始化) return;
  context.熔岩护盾节点已初始化 = true;
  确保熔岩护盾伤害修正();
  const config = 巴尔扎罗斯技能数值配置.熔岩护盾;
  创建血量节点触发器({
    清理: context.清理,
    名称: "巴尔扎罗斯-熔岩护盾血量节点",
    单位: context.Boss单位,
    节点列表: [
      { ID: "熔岩护盾-85", 百分比: config.触发生命比例[0], on触发: function 巴尔扎罗斯熔岩护盾85(this: void): void { 释放巴尔扎罗斯熔岩护盾(context); } },
      { ID: "熔岩护盾-55", 百分比: config.触发生命比例[1], on触发: function 巴尔扎罗斯熔岩护盾55(this: void): void { 释放巴尔扎罗斯熔岩护盾(context); } },
      { ID: "熔岩护盾-25", 百分比: config.触发生命比例[2], on触发: function 巴尔扎罗斯熔岩护盾25(this: void): void { 释放巴尔扎罗斯熔岩护盾(context); } },
    ],
  });
}

export function 注册巴尔扎罗斯熔岩护盾(this: void): void {
  确保熔岩护盾伤害修正();
}

export {};
