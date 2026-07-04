/** @noSelfInFile */

import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 获取或创建瑟兰迪尔上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";
import { 瑟兰迪尔单位技能配置 } from "./00．配置";
import { 播放瑟兰迪尔台词 } from "./15．台词播放";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { stringToFourCC } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 注册站桩弹幕射击单位 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.25．站桩弹幕射击单位.01．站桩弹幕射击单位") as {
  注册站桩弹幕射击单位: (this: void, 参数: any) => number;
};
const { 获取Boss技能最近敌对英雄Ex } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能最近敌对英雄Ex: (this: void, boss: any, centerUnit?: any, radius?: number, excludeList?: any[], filter?: any, weight?: any) => any;
};
const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffRuntime: (this: void, unit: any, buffID: string) => any;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (i: number) => any;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const 基础攻击力状态 = ConvertUnitState(0x12);
const 瑟兰迪尔单位类型ID = stringToFourCC(瑟兰迪尔单位技能配置.单位ID);
const 精灵箭阵技能ID = stringToFourCC(瑟兰迪尔数值与表现配置.精灵箭阵.技能槽位);
let 精灵箭阵已注册 = false;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 播放出生特效(this: void, x: number, y: number): void {
  const effect = AddSpecialEffect("Abilities\\Spells\\Human\\MassTeleport\\MassTeleportCaster.mdl", x, y);
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(1, effect);
}

function 取精灵箭阵目标权重(this: void, target: any): number {
  const config = 瑟兰迪尔数值与表现配置.精灵箭阵;
  const markConfig = 瑟兰迪尔数值与表现配置.执法印记;
  let weight = config.普通目标权重;
  if (getBuffRuntime(target, markConfig.BuffID) != null) {
    weight += config.标记目标额外权重;
  }
  return weight;
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 读取精灵箭阵Boss攻击力(this: void, boss: any): number {
  const config = 瑟兰迪尔数值与表现配置.精灵箭阵;
  const attack = 读取单位攻击力(boss);
  if (attack > 0) return attack;
  const baseAttack = Number(GetUnitStateJapi(boss, 基础攻击力状态)) || 0;
  if (baseAttack > 0) return baseAttack;
  return config.Boss攻击力兜底;
}

function 选择精灵箭阵射击目标(this: void, shooter: any, _boss: any): any {
  const config = 瑟兰迪尔数值与表现配置.精灵箭阵;
  if (!单位存活(shooter)) return null;
  const searchRadius = config.索敌半径 > 0 ? config.索敌半径 : config.弹幕最大飞行距离;
  return 获取Boss技能最近敌对英雄Ex(_boss, shooter, searchRadius, undefined, undefined, 取精灵箭阵目标权重);
}

function 创建瑟兰迪尔精灵箭阵召唤物(this: void, boss: any): void {
  const config = 瑟兰迪尔数值与表现配置.精灵箭阵;
  if (boss == null || boss === 0) return;

  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const hp = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * config.生命倍率;
  const damage = 读取精灵箭阵Boss攻击力(boss) * config.伤害倍率;
  const spawnDistance = config.出生距离 > 360 ? 360 : config.出生距离;
  const offsets = [
    [spawnDistance, 0],
    [-spawnDistance, 0],
    [0, spawnDistance],
    [0, -spawnDistance],
  ];

  for (let i = 0; i < config.数量; i++) {
    const offset = offsets[i % offsets.length];
    const summonX = x + offset[0];
    const summonY = y + offset[1];
    播放出生特效(summonX, summonY);
    const summon = 创建召唤物({
      主人单位: boss,
      单位类型: config.单位类型,
      单位名称: config.单位名称,
      模型文件: config.模型文件,
      X: summonX,
      Y: summonY,
      持续时间: config.持续秒,
      生命值: hp,
      生命值受小怪倍率: false,
      飞行高度: 10,
    });
    if (summon != null && summon !== 0) {
      注册站桩弹幕射击单位({
        射手单位: summon,
        来源单位: boss,
        持续秒: config.持续秒,
        攻击间隔秒: config.攻击间隔秒,
        出手延迟秒: config.出手延迟秒,
        伤害值: damage,
        弹道模型: config.弹道模型,
        弹道速度: config.弹道速度,
        命中半径: config.弹幕命中半径,
        最大飞行距离: config.弹幕最大飞行距离,
        飞行高度: config.弹幕飞行高度,
        起射偏移: config.弹幕起射偏移,
        弹道缩放: config.弹道缩放,
        攻击动画名: "attack",
        攻击动画速度: config.攻击动画速度,
        选择目标: 选择精灵箭阵射击目标,
      });
    }
  }
}

export function 释放瑟兰迪尔精灵箭阵(this: void, context: 瑟兰迪尔运行时上下文): void {
  const config = 瑟兰迪尔数值与表现配置.精灵箭阵;
  const boss = context.Boss单位;
  if (boss == null || boss === 0) return;

  启动基础施法时间线({
    施法者: boss,
    硬直秒: config.施法硬直秒,
    动画编号: config.动画编号,
    动画速度: config.施法动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: config.施法硬直秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 播放精灵箭阵台词(this: void): void {
      播放瑟兰迪尔台词(boss, "精灵箭阵");
    },
    on生效: function 瑟兰迪尔精灵箭阵召唤生效(this: void): void {
      创建瑟兰迪尔精灵箭阵召唤物(boss);
    },
  });
}

export function 注册瑟兰迪尔精灵箭阵(this: void): void {
  if (精灵箭阵已注册) return;
  精灵箭阵已注册 = true;
  注册单位技能壳监听({
    名称: "瑟兰迪尔精灵箭阵",
    单位类型ID: 瑟兰迪尔单位类型ID,
    技能ID: 精灵箭阵技能ID,
    获取或创建上下文: 获取或创建瑟兰迪尔上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 瑟兰迪尔运行时上下文, boss: any): void {
      on瑟兰迪尔精灵箭阵生效(boss, 精灵箭阵技能ID);
    },
  });
}

function on瑟兰迪尔精灵箭阵生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 精灵箭阵技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 瑟兰迪尔单位类型ID) return;
  const context = 获取或创建瑟兰迪尔上下文(castingUnit);
  if (context == null) return;
  释放瑟兰迪尔精灵箭阵(context);
}
