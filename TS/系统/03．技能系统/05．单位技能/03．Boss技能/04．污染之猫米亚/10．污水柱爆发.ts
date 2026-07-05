/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 取米亚平台中心X, 取米亚平台中心Y } from "./01．场地配置";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置 } from "./02．数值与表现配置";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 播放米亚台词 } from "./15．台词播放";
import { 取米亚平台超载伤害倍率 } from "./12．平台超载惩罚";
import { 开始原地击飞 } from "../../../00．技能模板+函数/01．技能函数/03．跳跃·击飞/index";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 取当前有效玩家人数 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数") as {
  取当前有效玩家人数: (this: void) => number;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 创建薄圆形提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效") as {
  创建薄圆形提示圈: (this: void, x: number, y: number, r: number, time: number, speed?: number) => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 造成AOE技能伤害, 创建独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
  创建独立技能伤害实例: (this: void, 参数?: any) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const GetUnitStateJapi = japi.GetUnitState as ((unit: any, state: any) => number) | undefined;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

interface 污水柱落点 {
  x: number;
  y: number;
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取单位攻击力(this: void, unit: any): number {
  if (!单位有效(unit) || typeof GetUnitStateJapi !== "function") return 1000;
  const value = GetUnitStateJapi(unit, ConvertUnitState(0x15));
  return value > 0 ? value : 1000;
}

function 计算污水柱爆发伤害(this: void, boss: any, target: any): number {
  const config = 米亚技能数值配置.污水柱爆发;
  return (取单位攻击力(boss) * config.爆发伤害Boss攻击力比例
    + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config.爆发伤害目标最大生命比例) * config.爆发伤害总倍率;
}

function 计算污水柱水坑伤害(this: void, boss: any, target: any): number {
  const config = 米亚技能数值配置.污水柱爆发;
  return (取单位攻击力(boss) * config.水坑每秒伤害Boss攻击力比例
    + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config.水坑每秒伤害目标最大生命比例) * config.水坑每秒伤害总倍率;
}

function 距离平方(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return dx * dx + dy * dy;
}

function 取污水柱数量(this: void): number {
  const playerCount = 取当前有效玩家人数();
  const config = 米亚技能数值配置.污水柱爆发;
  return playerCount <= 2 ? config.单双人数量 : config.三四人数量;
}

function 选择污水柱落点(this: void, boss: any): 污水柱落点[] {
  const count = 取污水柱数量();
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const candidates: any[] = [];
  for (let i = 0; i < heroes.length; i++) {
    if (单位有效(heroes[i])) candidates.push(heroes[i]);
  }

  const result: 污水柱落点[] = [];
  while (result.length < count && candidates.length > 0) {
    const index = GetRandomInt(0, candidates.length - 1);
    const hero = candidates[index];
    candidates.splice(index, 1);
    result.push({ x: GetUnitX(hero), y: GetUnitY(hero) });
  }
  while (result.length < count) {
    result.push({ x: 取米亚平台中心X(), y: 取米亚平台中心Y() });
  }
  return result;
}

function 播放污水柱预警(this: void, point: 污水柱落点): void {
  const config = 米亚技能数值配置.污水柱爆发;
  创建薄圆形提示圈(point.x, point.y, config.爆发半径, config.预警秒, 1 / config.预警秒);
  创建点特效({
    模型路径: 米亚单位技能配置.特效.平台预警底圈,
    X: point.x,
    Y: point.y,
    Z: 20,
    缩放: 0.9,
    红: 80,
    绿: 255,
    蓝: 80,
    透明度: 210,
    持续秒: config.预警秒,
  });
}

function 播放污水柱爆发表现(this: void, point: 污水柱落点): void {
  const effects = 米亚技能数值配置.污水柱爆发.爆发特效;
  for (let i = 0; i < effects.length; i++) {
    const effect = AddSpecialEffect(effects[i], point.x, point.y);
    if (effect == null || effect === 0) continue;
    if (typeof EXSetEffectSize === "function") EXSetEffectSize(effect, 1.0);
    YDWETimerDestroyEffectSafe(2.0, effect);
  }
}

function 创建污水柱残留水坑(this: void, context: 米亚运行时上下文, point: 污水柱落点, 技能实例ID?: number): void {
  const config = 米亚技能数值配置.污水柱爆发;
  创建持续危险区域({
    X: point.x,
    Y: point.y,
    半径: config.水坑半径,
    持续时间: config.水坑持续秒,
    检测间隔: 1,
    影响目标: "敌方",
    所有者: context.Boss单位,
    模型路径: 米亚单位技能配置.特效.腐化残留云,
    特效高度: 0,
    显示提示圈: false,
    on周期: function 米亚污水柱残留水坑周期(this: void, 区域内单位: any[]): void {
      for (let i = 0; i < 区域内单位.length; i++) {
        const target = 区域内单位[i];
        if (!单位有效(target)) continue;
        造成AOE技能伤害({
          来源: context.Boss单位,
          目标: target,
          伤害: 计算污水柱水坑伤害(context.Boss单位, target) * 取米亚平台超载伤害倍率(target),
          attackType: jass.ATTACK_TYPE_CHAOS,
          伤害类型: jass.DAMAGE_TYPE_POISON,
          weaponType: jass.WEAPON_TYPE_WHOKNOWS,
          来源类型: "Boss技能",
          技能实例ID,
          标签: "米亚污水柱爆发",
        });
        添加米亚腐化感染(context, target, config.水坑每秒腐化层数, "污水柱残留水坑");
      }
    },
  });
}

function 结算污水柱爆发(this: void, context: 米亚运行时上下文, point: 污水柱落点, 技能实例ID?: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.阶段 !== 2) return;

  const config = 米亚技能数值配置.污水柱爆发;
  const radius2 = config.爆发半径 * config.爆发半径;
  播放污水柱爆发表现(point);
  播放米亚台词(boss, "污水柱爆发", 2);

  const targets = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位有效(target)) continue;
    if (距离平方(point.x, point.y, GetUnitX(target), GetUnitY(target)) > radius2) continue;
    造成AOE技能伤害({
      来源: boss,
      目标: target,
      伤害: 计算污水柱爆发伤害(boss, target) * 取米亚平台超载伤害倍率(target),
      attackType: jass.ATTACK_TYPE_CHAOS,
      伤害类型: jass.DAMAGE_TYPE_POISON,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "Boss技能",
      技能实例ID,
      标签: "米亚污水柱爆发",
    });
    添加米亚腐化感染(context, target, config.命中腐化层数, "污水柱爆发");
    开始原地击飞(target, {
      持续时间: config.原地击飞持续秒,
      最小高度: config.原地击飞最小高度,
      最大高度: config.原地击飞最大高度,
      冲击波模型: "",
      持续特效模型: "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl",
      持续特效间隔: 0.12,
      主单位: boss,
    });
  }

  创建污水柱残留水坑(context, point, 技能实例ID);
  播放米亚台词(boss, "污水柱爆发", 3);
}

export function 注册米亚污水柱爆发(this: void): void {
}

export function 尝试触发米亚污水柱爆发(this: void, context: 米亚运行时上下文, nowMs: number): void {
  if (context.阶段 !== 2) return;
  const config = 米亚技能数值配置.污水柱爆发;
  if (context.上次污水柱爆发Ms > 0 && nowMs - context.上次污水柱爆发Ms < config.冷却Ms) return;

  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  context.上次污水柱爆发Ms = nowMs;
  const 技能实例ID = 创建独立技能伤害实例({
    来源类型: "Boss技能",
    标签: "米亚污水柱爆发",
    持续时间秒: config.预警秒 + config.水坑持续秒 + 2,
  });

  const points = 选择污水柱落点(boss);
  播放米亚台词(boss, "污水柱爆发", 0);
  for (let i = 0; i < points.length; i++) {
    播放污水柱预警(points[i]);
  }
  addDelayedCallback(1500, function 米亚污水柱爆发前提醒(this: void): void {
    if (!单位有效(context.Boss单位) || context.阶段 !== 2) return;
    播放米亚台词(context.Boss单位, "污水柱爆发", 1);
  });
  addDelayedCallback(config.预警秒 * 1000, function 米亚污水柱爆发延迟结算(this: void): void {
    for (let i = 0; i < points.length; i++) {
      结算污水柱爆发(context, points[i], 技能实例ID);
    }
  });
}
