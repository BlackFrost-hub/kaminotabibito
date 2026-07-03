/** @noSelfInFile */

import { 里科特单位技能配置 } from "./00．配置";
import { 获取或创建里科特上下文, 刷新里科特阶段, type 里科特运行时上下文 } from "./01．运行时上下文";
import { 里科特数值与表现配置 } from "./02．数值与表现配置";
import { 播放里科特台词 } from "./10．台词播放";
import { 单位有效, stringToFourCC, 取单位间角度 } from "./13．公共工具";

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number) => void;
};
const { 创建原生弹幕, 获取原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => { 弹幕ID: number };
  获取原生弹幕: (this: void, 弹幕ID: number) => { 弹幕单位: any } | undefined;
};
const { 设置原生弹幕指定角度飞行 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.06．改向与反弹.00．弹幕改向") as {
  设置原生弹幕指定角度飞行: (this: void, 弹幕ID: number, 朝向角度: number, 新速度?: number) => boolean;
};
const { 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);
const 四重风刃技能ID = stringToFourCC(里科特数值与表现配置.四重风刃.技能槽位);
let 已注册 = false;

function 取四重风刃目标(this: void, boss: any): any {
  const target = GetSpellTargetUnit();
  return 单位有效(target) ? target : 获取Boss技能随机敌对英雄(boss, boss, 里科特数值与表现配置.四重风刃.施法距离 + 300);
}

function 结算跳劈(this: void, boss: any, target: any): void {
  const cfg = 里科特数值与表现配置.四重风刃;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const cx = GetUnitX(target);
  const cy = GetUnitY(target);
  const radius2 = cfg.跳劈半径 * cfg.跳劈半径;
  const damage = 读取单位攻击力(boss) * cfg.跳劈Boss攻击力比例;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const dx = GetUnitX(hero) - cx;
    const dy = GetUnitY(hero) - cy;
    if (dx * dx + dy * dy > radius2) continue;
    UnitDamageTarget(boss, hero, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
    施加快速减速Buff(boss, hero, cfg.跳劈减速比例, cfg.跳劈减速比例, cfg.跳劈减速秒);
  }
}

function 调度龙卷风阶段改向(this: void, context: 里科特运行时上下文, 弹幕ID: number): void {
  const cfg = 里科特数值与表现配置.四重风刃;
  const stage = 刷新里科特阶段(context);
  if (stage === 1) return;
  const id = addDelayedCallback((stage >= 3 ? cfg.P3追踪延迟秒 : cfg.P2回转延迟秒) * 1000, function 里科特龙卷风延迟改向(this: void): void {
    const boss = context.Boss单位;
    if (!单位有效(boss)) return;
    const bullet = 获取原生弹幕(弹幕ID);
    if (bullet == null || !单位有效(bullet.弹幕单位)) return;
    if (刷新里科特阶段(context) >= 3) {
      const target = 获取Boss技能随机敌对英雄(boss, boss, 2000);
      if (单位有效(target)) 设置原生弹幕指定角度飞行(弹幕ID, 取单位间角度(bullet.弹幕单位, target), cfg.龙卷风速度);
      return;
    }
    设置原生弹幕指定角度飞行(弹幕ID, 取单位间角度(bullet.弹幕单位, boss), cfg.龙卷风速度);
  });
  context.清理.登记延迟回调("里科特-龙卷风改向", id);
}

function 发射单个龙卷风(this: void, context: 里科特运行时上下文, angle: number): void {
  const boss = context.Boss单位;
  const cfg = 里科特数值与表现配置.四重风刃;
  const damage = 读取单位攻击力(boss) * cfg.龙卷风Boss攻击力比例;
  const bullet = 创建原生弹幕({
    所有者: boss,
    所属玩家: GetOwningPlayer(boss),
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    方向角: angle,
    速度: cfg.龙卷风速度,
    最大距离: cfg.龙卷风射程,
    命中半径: cfg.龙卷风命中半径,
    影响目标: "敌方",
    碰撞消失: false,
    每单位最大命中次数: 1,
    模型: cfg.龙卷风模型路径,
    缩放: cfg.龙卷风缩放,
    飞行高度: cfg.龙卷风飞行高度,
    on命中: function 里科特龙卷风命中(this: void, target: any): void {
      if (!单位有效(target)) return;
      UnitDamageTarget(boss, target, damage, false, false, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
    },
  });
  调度龙卷风阶段改向(context, bullet.弹幕ID);
}

function 发射四重龙卷风(this: void, context: 里科特运行时上下文): void {
  for (let i = 0; i < 4; i++) {
    发射单个龙卷风(context, i * 90 + 45);
  }
}

export function 释放里科特四重风刃(this: void, context: 里科特运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 取四重风刃目标(boss);
  if (!单位有效(target)) return;
  const cfg = 里科特数值与表现配置.四重风刃;
  创建技能提示圈({
    类型: "圆形",
    X: GetUnitX(target),
    Y: GetUnitY(target),
    半径: cfg.跳劈半径,
    持续时间: cfg.前摇秒,
    来源单位: boss,
  });
  启动基础施法时间线({
    施法者: boss,
    目标单位: target,
    硬直秒: cfg.前摇秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.前摇秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    播放台词: function 里科特四重风刃台词(this: void): void {
      播放里科特台词(boss, "四重风刃");
    },
    on生效: function 里科特四重风刃生效(this: void): void {
      结算跳劈(boss, target);
      const id = addDelayedCallback(cfg.龙卷风延迟秒 * 1000, function 里科特四重龙卷风延迟发射(this: void): void {
        发射四重龙卷风(context);
      });
      context.清理.登记延迟回调("里科特-四重龙卷风", id);
    },
  });
}

export function 注册里科特四重风刃(this: void): void {
  if (已注册) return;
  已注册 = true;
  registerSpellEffectListener(on里科特四重风刃生效);
}

function on里科特四重风刃生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 四重风刃技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 里科特单位类型ID) return;
  const context = 获取或创建里科特上下文(castingUnit);
  if (context == null) return;
  释放里科特四重风刃(context);
}
