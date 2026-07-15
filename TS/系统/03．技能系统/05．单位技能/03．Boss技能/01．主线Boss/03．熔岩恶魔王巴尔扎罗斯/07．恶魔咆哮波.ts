/** @noSelfInFile */

const { 计算组合技能伤害 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害") as {
  计算组合技能伤害: (this: void, 来源: any, 目标: any, 参数: any) => number;
};

import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 获取或创建巴尔扎罗斯上下文 } from "./03．运行时上下文";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 巴尔扎罗斯技能数值配置, 巴尔扎罗斯音效配置 } from "./02．数值与表现配置";
import { 播放巴尔扎罗斯台词 } from "./14．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { stringToFourCC, 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建线段危险区 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.02．线段危险区") as {
  创建线段危险区: (this: void, 参数: any) => any;
};
const { 获取Boss技能最高仇恨目标, 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能最高仇恨目标: (this: void, boss: any) => any;
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, 来源单位: any, 目标单位: any, 控制ID: number, 持续时间: number) => void;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const BJ_RADTODEG = 57.29577951308232;
const 巴尔扎罗斯单位类型ID = stringToFourCC(巴尔扎罗斯单位技能配置.单位ID);
const 恶魔咆哮波技能ID = stringToFourCC(巴尔扎罗斯技能数值配置.恶魔咆哮波.技能槽位);
const 快速控制_击晕 = 0;
let 恶魔咆哮波已注册 = false;

function 取目标单位(this: void, boss: any): any {
  const entry = 获取Boss技能最高仇恨目标(boss);
  if (entry != null && 单位有效(entry.targetRef)) return entry.targetRef;
  return 获取Boss技能随机敌对英雄(boss);
}

function 取方向角(this: void, boss: any, target: any): number {
  if (!单位有效(boss) || !单位有效(target)) return 0;
  return Atan2(GetUnitY(target) - GetUnitY(boss), GetUnitX(target) - GetUnitX(boss)) * BJ_RADTODEG;
}

function 是巴尔扎罗斯护卫(this: void, context: 巴尔扎罗斯运行时上下文, unit: any): boolean {
  return unit != null && unit !== 0 && (unit === context.格鲁姆 || unit === context.塞拉);
}

function 收集咆哮波候选单位(this: void, context: 巴尔扎罗斯运行时上下文): any[] {
  const result = 获取Boss技能敌对英雄列表(context.Boss单位);
  if (单位有效(context.格鲁姆)) result.push(context.格鲁姆);
  if (单位有效(context.塞拉)) result.push(context.塞拉);
  return result;
}

function 限制生命值(this: void, value: number, maxLife: number): number {
  if (value < 1) return 1;
  if (value > maxLife) return maxLife;
  return value;
}

function 治疗单位(this: void, unit: any, amount: number): void {
  if (!单位有效(unit) || amount <= 0) return;
  const maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE);
  const life = GetUnitState(unit, UNIT_STATE_LIFE);
  SetUnitState(unit, UNIT_STATE_LIFE, 限制生命值(life + amount, maxLife));
}

function 计算咆哮波伤害(this: void, boss: any, target: any): number {
  const config = 巴尔扎罗斯技能数值配置.恶魔咆哮波;
  return 计算组合技能伤害(boss, target, {
    来源攻击力比例: config.伤害Boss攻击力比例,
    目标最大生命比例: config.伤害目标最大生命比例,
    总倍率: config.伤害总倍率,
  });
}

function 记录咆哮波玩家命中(this: void, context: 巴尔扎罗斯运行时上下文, target: any): void {
  const config = 巴尔扎罗斯技能数值配置.恶魔咆哮波;
  const hid = GetHandleId(target) || 0;
  if (hid === 0) return;
  const now = getServerTime();
  const last = context.恶魔咆哮波命中记录[hid] ?? 0;
  context.恶魔咆哮波命中记录[hid] = now;
  if (last > 0 && now - last <= config.连续命中窗口秒 * 1000) {
    施加快速控制Buff(context.Boss单位, target, 快速控制_击晕, config.连续命中眩晕秒);
  }
}

function 播放恶魔咆哮波蓄力特效(this: void, boss: any, angle: number): void {
  const config = 巴尔扎罗斯技能数值配置.恶魔咆哮波;
  const x = GetUnitX(boss) + CosBJ(angle) * config.冲击特效前移;
  const y = GetUnitY(boss) + SinBJ(angle) * config.冲击特效前移;
  创建点特效({
    模型路径: config.聚火特效路径,
    X: x,
    Y: y,
    Z: config.聚火特效高度,
    缩放: config.聚火特效缩放,
    Z轴角度: angle,
    持续秒: config.聚火特效持续秒,
  });
}

function 播放恶魔咆哮波冲击特效(this: void, boss: any, angle: number): void {
  const config = 巴尔扎罗斯技能数值配置.恶魔咆哮波;
  const x = GetUnitX(boss) + CosBJ(angle) * config.冲击特效前移;
  const y = GetUnitY(boss) + SinBJ(angle) * config.冲击特效前移;
  创建点特效({
    模型路径: config.冲击特效路径,
    X: x,
    Y: y,
    Z: config.冲击特效高度,
    缩放: config.冲击特效缩放,
    X轴角度: config.冲击特效X轴旋转角度,
    Y轴角度: config.冲击特效Y轴旋转角度,
    Z轴角度: angle + config.冲击特效朝向修正角度,
    持续秒: config.冲击特效持续秒,
  });
}

function 创建咆哮波预警(this: void, boss: any, angle: number): void {
  const config = 巴尔扎罗斯技能数值配置.恶魔咆哮波;
  const centerX = GetUnitX(boss) + CosBJ(angle) * (config.路径长度 * 0.5);
  const centerY = GetUnitY(boss) + SinBJ(angle) * (config.路径长度 * 0.5);
  创建技能提示圈({
    类型: "矩形",
    X: centerX,
    Y: centerY,
    宽度: config.路径宽度,
    长度: config.路径长度,
    朝向: angle,
    持续时间: config.施法硬直秒,
  });
}

function 执行咆哮波命中(this: void, context: 巴尔扎罗斯运行时上下文, unit: any): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(unit)) return;
  if (是巴尔扎罗斯护卫(context, unit)) {
    治疗单位(unit, GetUnitState(unit, UNIT_STATE_MAX_LIFE) * 巴尔扎罗斯技能数值配置.恶魔咆哮波.护卫命中治疗最大生命比例);
    return;
  }
  造成AOE技能伤害({
    技能ID: 恶魔咆哮波技能ID,
    来源: boss,
    目标: unit,
    伤害: 计算咆哮波伤害(boss, unit),
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_CHAOS,
    伤害类型: DAMAGE_TYPE_FIRE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "Boss技能",
  });
  记录咆哮波玩家命中(context, unit);
}

function 创建咆哮波判定(this: void, context: 巴尔扎罗斯运行时上下文, angle: number): void {
  const config = 巴尔扎罗斯技能数值配置.恶魔咆哮波;
  const boss = context.Boss单位;
  播放恶魔咆哮波冲击特效(boss, angle);
  播放Boss坐标音效(巴尔扎罗斯音效配置.恶魔咆哮波.发射, GetUnitX(boss), GetUnitY(boss), 巴尔扎罗斯音效配置.默认裁断距离);
  创建线段危险区({
    清理: context.清理,
    名称: "巴尔扎罗斯-恶魔咆哮波",
    起点X: GetUnitX(boss),
    起点Y: GetUnitY(boss),
    方向角: angle,
    长度: config.路径长度,
    宽度: config.路径宽度,
    持续秒: config.路径持续秒,
    Tick间隔毫秒: config.路径Tick毫秒,
    单位列表: function 取恶魔咆哮波候选单位(this: void): any[] {
      return 收集咆哮波候选单位(context);
    },
    提示圈: { 类型: "方向直线", 来源单位: boss },
    on进入: function 巴尔扎罗斯恶魔咆哮波进入(this: void, unit: any): void {
      执行咆哮波命中(context, unit);
    },
  });
}

export function 释放巴尔扎罗斯恶魔咆哮波(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 取目标单位(boss);
  if (!单位有效(target)) return;

  const config = 巴尔扎罗斯技能数值配置.恶魔咆哮波;
  const angle = 取方向角(boss, target);
  创建咆哮波预警(boss, angle);
  播放恶魔咆哮波蓄力特效(boss, angle);
  启动基础施法时间线({
    施法者: boss,
    目标X: GetUnitX(boss) + CosBJ(angle) * config.路径长度,
    目标Y: GetUnitY(boss) + SinBJ(angle) * config.路径长度,
    硬直秒: config.施法硬直秒,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    重播动作延迟毫秒: 30,
    生效前重新面向: false,
    吟唱条: {
      通道: "常规技能",
      总时长: config.施法硬直秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 播放恶魔咆哮波台词(this: void): void {
      播放巴尔扎罗斯台词(boss, "恶魔咆哮波");
    },
    on生效: function 巴尔扎罗斯恶魔咆哮波生效(this: void): void {
      创建咆哮波判定(context, angle);
    },
  });
}

export function 注册巴尔扎罗斯恶魔咆哮波(this: void): void {
  if (恶魔咆哮波已注册) return;
  恶魔咆哮波已注册 = true;
  注册单位技能壳监听({
    名称: "巴尔扎罗斯恶魔咆哮波",
    单位类型ID: 巴尔扎罗斯单位类型ID,
    技能ID: 恶魔咆哮波技能ID,
    获取或创建上下文: 获取或创建巴尔扎罗斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 巴尔扎罗斯运行时上下文, boss: any): void {
      on巴尔扎罗斯恶魔咆哮波生效(boss, 恶魔咆哮波技能ID);
    },
  });
}

function on巴尔扎罗斯恶魔咆哮波生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 恶魔咆哮波技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 巴尔扎罗斯单位类型ID) return;
  const context = 获取或创建巴尔扎罗斯上下文(castingUnit);
  if (context == null) return;
  释放巴尔扎罗斯恶魔咆哮波(context);
}
