/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 获取或创建米亚上下文 } from "./03．运行时上下文";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置, 米亚音效配置 } from "./02．数值与表现配置";
import { 播放米亚台词 } from "./15．台词播放";
import { 开始米亚常规施法 } from "./19．施法提示";
import { 延迟播放Boss坐标音效, 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 取米亚污染标记伤害倍率 } from "./08．污染标记";
import { 取米亚平台超载伤害倍率 } from "./12．平台超载惩罚";
import { stringToFourCC, 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 执行Boss技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const { 获取Boss技能敌对英雄列表Ex, 获取Boss技能应攻击目标 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表Ex: (this: void, boss: any, centerUnit?: any, radius?: number) => any[];
  获取Boss技能应攻击目标: (this: void, boss: any) => { targetRef: any } | null;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const CosBJ = jass.CosBJ as (degrees: number) => number;
const SinBJ = jass.SinBJ as (degrees: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;

const BJ_RADTODEG = 57.29577951308232;
const 米亚单位类型ID = stringToFourCC(米亚单位技能配置.Boss单位ID);
const 污水喷吐技能ID = stringToFourCC(米亚单位技能配置.污水喷吐技能);
let 米亚污水喷吐已注册 = false;

interface 米亚污水喷吐结算变量 {
  context: 米亚运行时上下文;
  target: any;
  朝向: number;
}

function 点在前方扇形内(this: void, boss: any, target: any, range: number, halfAngle: number, facing: number): boolean {
  const dx = GetUnitX(target) - GetUnitX(boss);
  const dy = GetUnitY(target) - GetUnitY(boss);
  const distance2 = dx * dx + dy * dy;
  if (distance2 > range * range) return false;
  const forwardX = CosBJ(facing);
  const forwardY = SinBJ(facing);
  const dot = dx * forwardX + dy * forwardY;
  if (dot <= 0) return false;
  const cosLimit = CosBJ(halfAngle);
  return dot * dot >= distance2 * cosLimit * cosLimit;
}

function 让单位面向目标(this: void, caster: any, target: any): void {
  if (!单位有效(caster) || !单位有效(target)) return;
  const angle = Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster)) * BJ_RADTODEG;
  SetUnitFacing(caster, angle);
}

function 播放喷吐表现(this: void, boss: any, facing: number): void {
  const config = 米亚技能数值配置.污水喷吐;
  const x = GetUnitX(boss) + CosBJ(facing) * 120;
  const y = GetUnitY(boss) + SinBJ(facing) * 120;
  创建点特效({
    模型路径: config.喷吐特效路径,
    X: x,
    Y: y,
    Z轴角度: facing,
    缩放: config.喷吐特效缩放,
    持续秒: config.喷吐特效持续秒,
  });
}

function 创建污水喷吐残留区(this: void, context: 米亚运行时上下文, facing: number): void {
  const boss = context.Boss单位;
  const config = 米亚技能数值配置.污水喷吐;
  const x = GetUnitX(boss) + CosBJ(facing) * (config.喷吐距离 * 0.55);
  const y = GetUnitY(boss) + SinBJ(facing) * (config.喷吐距离 * 0.55);
  创建持续危险区域({
    X: x,
    Y: y,
    半径: config.残留半径,
    持续时间: config.残留持续秒,
    检测间隔: 1,
    影响目标: "敌方",
    所有者: boss,
    模型路径: 米亚单位技能配置.特效.腐化残留云,
    特效高度: 0,
    提示圈: { 类型: "敌方圆形" },
    on周期: function 米亚污水喷吐残留区周期(this: void, 区域内单位: any[]): void {
      for (let i = 0; i < 区域内单位.length; i++) {
        添加米亚腐化感染(context, 区域内单位[i], config.残留每秒腐化层数, "污水喷吐残留");
      }
    },
  });
}

function 结算米亚污水喷吐(this: void, variable?: any): void {
  const data = variable as 米亚污水喷吐结算变量 | undefined;
  if (data == null) return;
  const context = data.context;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;

  const config = 米亚技能数值配置.污水喷吐;
  SetUnitFacing(boss, data.朝向);
  播放喷吐表现(boss, data.朝向);
  创建污水喷吐残留区(context, data.朝向);

  const targets = 获取Boss技能敌对英雄列表Ex(boss, boss, config.喷吐距离);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位有效(target) || !点在前方扇形内(boss, target, config.喷吐距离, config.喷吐半角, data.朝向)) continue;
    执行Boss技能伤害({
      技能ID: 污水喷吐技能ID,
      来源: boss,
      目标: target,
      伤害公式: {
        来源攻击力比例: config.直接伤害Boss攻击力比例,
        目标最大生命比例: config.直接伤害目标最大生命比例,
        总倍率: config.直接伤害总倍率 * 取米亚污染标记伤害倍率(context, target) * 取米亚平台超载伤害倍率(target),
      },
      attackType: jass.ATTACK_TYPE_NORMAL,
      伤害类型: jass.DAMAGE_TYPE_POISON,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      伤害形态: "AOE",
    });
    添加米亚腐化感染(context, target, config.直接腐化层数, "污水喷吐");
  }
}

export function 释放米亚污水喷吐(this: void, context: 米亚运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const config = 米亚技能数值配置.污水喷吐;
  const threatTarget = 获取Boss技能应攻击目标(boss)?.targetRef;
  if (单位有效(threatTarget)) 让单位面向目标(boss, threatTarget);
  const facing = GetUnitFacing(boss);
  播放米亚台词(boss, "污水喷吐");
  播放Boss坐标音效(米亚音效配置.污水喷吐.前摇蓄力, GetUnitX(boss), GetUnitY(boss), 米亚音效配置.默认裁断距离);
  延迟播放Boss坐标音效(米亚音效配置.污水喷吐.持续喷射, GetUnitX(boss), GetUnitY(boss), 米亚音效配置.污水喷吐.持续喷射延迟Ms, 米亚音效配置.默认裁断距离);
  开始米亚常规施法(boss, config.前摇秒, "污水喷吐", "离开米亚正面的喷吐扇形", config.总硬直秒);
  SetUnitTimeScale(boss, config.动画速度);
  SetUnitAnimationByIndex(boss, config.动画编号);
  创建技能提示圈({
    类型: "红色扇形",
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    半径: config.喷吐距离,
    扇形角度: config.喷吐半角 * 2,
    朝向: facing,
    持续时间: config.前摇秒,
    来源单位: boss,
  });
  const delayedId = addDelayedCallback(config.前摇秒 * 1000, 结算米亚污水喷吐, { context, target: threatTarget, 朝向: facing } as 米亚污水喷吐结算变量);
  context.清理.登记延迟回调("米亚-污水喷吐结算", delayedId);
}

export function 注册米亚污水喷吐(this: void): void {
  if (米亚污水喷吐已注册) return;
  米亚污水喷吐已注册 = true;
  注册单位技能壳监听({
    名称: "米亚-污水喷吐",
    单位类型ID: 米亚单位类型ID,
    技能ID: 污水喷吐技能ID,
    获取或创建上下文: 获取或创建米亚上下文,
    释放技能: function 米亚污水喷吐监听释放(this: void, _context: 米亚运行时上下文, boss: any): void {
      on米亚污水喷吐生效(boss, 污水喷吐技能ID);
    },
  });
}

function on米亚污水喷吐生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 污水喷吐技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 米亚单位类型ID) return;
  const context = 获取或创建米亚上下文(castingUnit);
  if (context == null) return;
  释放米亚污水喷吐(context);
}
