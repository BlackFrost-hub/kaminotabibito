/** @noSelfInFile */

import type { 瑟兰迪尔运行时上下文 } from "./03．运行时上下文";
import { 获取或创建瑟兰迪尔上下文 } from "./03．运行时上下文";
import { 瑟兰迪尔数值与表现配置 } from "./02．数值与表现配置";
import { 瑟兰迪尔单位技能配置 } from "./00．配置";
import { 播放瑟兰迪尔台词 } from "./15．台词播放";

const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 启动独占单位连接 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.独占单位连接") as {
  启动独占单位连接: (this: void, 参数: any) => boolean;
};
const { 取当前有效玩家人数 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数") as {
  取当前有效玩家人数: (this: void) => number;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const 瑟兰迪尔单位类型ID = stringToFourCC(瑟兰迪尔单位技能配置.单位ID);
const 律法召唤技能ID = stringToFourCC(瑟兰迪尔数值与表现配置.律法召唤.技能槽位);
let 律法召唤已注册 = false;

function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}
const bj_DEGTORAD = jass.bj_DEGTORAD as number;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 启动律法链路(this: void, boss: any, summon: any, 已连接目标: any[]): void {
  const config = 瑟兰迪尔数值与表现配置.律法召唤;
  const damage = 读取单位攻击力(boss) * config.链接伤害Boss攻击力比例;
  启动独占单位连接({
    来源单位: boss,
    连接单位: summon,
    候选目标列表: function 取律法召唤候选目标(this: void): any[] {
      return 获取Boss技能敌对英雄列表(boss);
    },
    已占用目标: 已连接目标,
    持续秒: config.持续秒,
    重试间隔秒: config.链接重试间隔秒,
    连接半径: config.链接半径,
    闪电类型: config.闪电类型,
    闪电起点高度偏移: config.闪电起点高度偏移,
    闪电终点高度偏移: config.闪电终点高度偏移,
    闪电颜色: config.闪电颜色,
    Tick间隔秒: config.链接伤害间隔秒,
    on距离超出: function 瑟兰迪尔律法链路距离惩罚(this: void, source: any, _connector: any, target: any): void {
      if (!单位有效(source) || !单位有效(target)) return;
      UnitDamageTarget(boss, target, damage, false, false, jass.ATTACK_TYPE_NORMAL, jass.DAMAGE_TYPE_MIND, jass.WEAPON_TYPE_WHOKNOWS);
    },
  });
}

function 执行瑟兰迪尔律法召唤(this: void, boss: any): void {
  const config = 瑟兰迪尔数值与表现配置.律法召唤;
  if (!单位有效(boss)) return;

  const playerCount = 取当前有效玩家人数();
  const count = playerCount <= 1 ? config.数量单人 : config.数量多人;
  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  const hp = GetUnitState(boss, UNIT_STATE_MAX_LIFE) * config.生命倍率;
  const 已连接目标: any[] = [];
  for (let i = 0; i < count; i++) {
    const angle = (360 / count) * i * bj_DEGTORAD;
    const summon = 创建召唤物({
      主人单位: boss,
      单位类型: config.单位类型,
      单位名称: config.单位名称,
      模型文件: config.模型文件,
      X: bossX + Cos(angle) * 360,
      Y: bossY + Sin(angle) * 360,
      持续时间: config.持续秒,
      生命值: hp,
      护甲: config.护甲,
      攻击范围: config.攻击范围,
      普攻弹道模型: config.普攻弹道模型,
      普攻弹道弧度: config.普攻弹道弧度,
      普攻弹道速度: config.普攻弹道速度,
      索敌范围: 900,
      飞行高度: 10,
    });
    if (单位有效(summon)) 启动律法链路(boss, summon, 已连接目标);
  }
}

export function 释放瑟兰迪尔律法召唤(this: void, context: 瑟兰迪尔运行时上下文): void {
  const config = 瑟兰迪尔数值与表现配置.律法召唤;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;

  启动基础施法时间线({
    施法者: boss,
    硬直秒: config.施法硬直秒,
    动画编号: config.动画编号,
    动画速度: config.施法动画速度,
    重播动作延迟毫秒: 30,
    吟唱条: {
      通道: "常规技能",
      总时长: config.施法硬直秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 播放律法召唤台词(this: void): void {
      播放瑟兰迪尔台词(boss, "律法召唤");
    },
    on生效: function 瑟兰迪尔律法召唤生效(this: void): void {
      执行瑟兰迪尔律法召唤(boss);
    },
  });
}

export function 注册瑟兰迪尔律法召唤(this: void): void {
  if (律法召唤已注册) return;
  律法召唤已注册 = true;
  registerSpellEffectListener(on瑟兰迪尔律法召唤生效);
}

function on瑟兰迪尔律法召唤生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 律法召唤技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 瑟兰迪尔单位类型ID) return;
  const context = 获取或创建瑟兰迪尔上下文(castingUnit);
  if (context == null) return;
  释放瑟兰迪尔律法召唤(context);
}
