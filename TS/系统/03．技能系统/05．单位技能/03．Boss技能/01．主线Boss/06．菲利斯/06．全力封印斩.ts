/** @noSelfInFile */

import { 菲利斯单位技能配置 } from "./00．配置";
import { 获取或创建菲利斯上下文, 菲利斯运行时上下文 } from "./01．运行时上下文";
import { 菲利斯数值与表现配置, 菲利斯音效配置 } from "./02．数值与表现配置";
import { 播放菲利斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC, 取难度, 取单位间角度, 极坐标X, 极坐标Y } from "./11．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 执行战斗自身位移到坐标 } from "../../../../00．技能模板+函数/02．通用函数/20．位移技能限制";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 菲利斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.05．菲利斯") as {
  菲利斯BuffID: { 封印标记: string };
};
const { 命令卡技能是否全部冷却中 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.14．命令卡技能冷却查询") as {
  命令卡技能是否全部冷却中: (this: void, unit: any, keys?: string[]) => boolean;
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, source: any, target: any, controlID: number, duration: number) => void;
};
const { 创建点特效, createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
};

const 快速控制_击晕 = 0;
const 菲利斯单位类型ID = stringToFourCC(菲利斯单位技能配置.单位ID);
const 全力封印斩技能ID = stringToFourCC(菲利斯数值与表现配置.全力封印斩.技能槽位);
let 全力封印斩已注册 = false;

function 选择封印目标(this: void, boss: any): any[] {
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const result: any[] = [];
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (命令卡技能是否全部冷却中(hero, ["Q", "W", "E", "R"])) result.push(hero);
  }
  return result;
}

function 标记封印目标(this: void, boss: any, targets: any[]): void {
  const cfg = 菲利斯数值与表现配置.全力封印斩;
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    registerManualBuff(target, 菲利斯BuffID.封印标记, cfg.前摇秒 + 0.5, 0, { sourceName: "菲利斯-全力封印斩" });
    创建技能提示圈({
      类型: "渐变圆形",
      X: GetUnitX(target),
      Y: GetUnitY(target),
      半径: 220,
      持续时间: cfg.前摇秒,
      来源单位: boss,
    });
    创建点特效({ 模型路径: cfg.玩家封印特效路径, X: GetUnitX(target), Y: GetUnitY(target), 缩放: 1.0, 持续秒: cfg.前摇秒 + 0.2 });
  }
}

function 执行封印惩罚(this: void, boss: any, target: any): void {
  if (!单位有效(boss) || !单位有效(target)) return;
  const cfg = 菲利斯数值与表现配置.全力封印斩;
  const n = 取难度();
  const mana = GetUnitState(target, UNIT_STATE_MANA);
  const manaLoss = mana * (cfg.魔法扣除基础比例 + cfg.魔法扣除每难度追加比例 * n);
  if (manaLoss > 0) {
    SetUnitState(target, UNIT_STATE_MANA, mana - manaLoss);
    造成单体技能伤害({
      技能ID: 全力封印斩技能ID,
      来源: boss,
      目标: target,
      伤害: manaLoss,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_MAGIC,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "Boss技能",
    });
  }
  施加快速控制Buff(boss, target, 快速控制_击晕, cfg.基础眩晕秒 + cfg.每难度眩晕追加秒 * n);
  createUnitEffect(target, "origin", cfg.命中特效路径, cfg.特效持续秒, "菲利斯-封印命中");
}

function 瞬移到封印目标(this: void, boss: any, target: any): void {
  if (!单位有效(boss) || !单位有效(target)) return;
  const cfg = 菲利斯数值与表现配置.全力封印斩;
  const angle = 取单位间角度(target, boss);
  执行战斗自身位移到坐标(boss, 极坐标X(GetUnitX(target), angle, cfg.瞬移距离), 极坐标Y(GetUnitY(target), angle, cfg.瞬移距离));
}

export function 释放菲利斯全力封印斩(this: void, context: 菲利斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 菲利斯数值与表现配置.全力封印斩;
  const targets = 选择封印目标(boss);
  标记封印目标(boss, targets);
  if (targets.length > 0) {
    播放Boss坐标音效(菲利斯音效配置.全力封印斩.起手标记, GetUnitX(boss), GetUnitY(boss), 菲利斯音效配置.默认裁断距离);
  }
  创建点特效({ 模型路径: cfg.Boss起手特效路径, X: GetUnitX(boss), Y: GetUnitY(boss), 缩放: 1.2, 持续秒: cfg.特效持续秒 });
  createUnitEffect(boss, "origin", cfg.Boss附身特效路径, cfg.特效持续秒, "菲利斯-全力封印斩附身");
  SetUnitInvulnerable(boss, true);
  const invulID = addDelayedCallback((cfg.前摇秒 + 0.2) * 1000, function 菲利斯封印无敌结束(this: void): void {
    if (单位有效(boss)) SetUnitInvulnerable(boss, false);
  });
  context.清理.登记延迟回调("菲利斯-封印无敌结束", invulID);

  启动基础施法时间线({
    施法者: boss,
    目标X: GetUnitX(boss),
    目标Y: GetUnitY(boss),
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
    播放台词: function 菲利斯全力封印斩台词(this: void): void {
      播放菲利斯台词(boss, "全力封印斩");
    },
    on生效: function 菲利斯全力封印斩生效(this: void): void {
      if (targets.length <= 0) return;
      const teleportTarget = targets[GetRandomInt(0, targets.length - 1)];
      播放Boss坐标音效(菲利斯音效配置.全力封印斩.结算, GetUnitX(teleportTarget), GetUnitY(teleportTarget), 菲利斯音效配置.默认裁断距离);
      for (let i = 0; i < targets.length; i++) 执行封印惩罚(boss, targets[i]);
      瞬移到封印目标(boss, teleportTarget);
    },
  });
}

export function 注册菲利斯全力封印斩(this: void): void {
  if (全力封印斩已注册) return;
  全力封印斩已注册 = true;
  注册单位技能壳监听({
    名称: "06．全力封印斩",
    单位类型ID: 菲利斯单位类型ID,
    技能ID: 全力封印斩技能ID,
    获取或创建上下文: 获取或创建菲利斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 菲利斯运行时上下文, boss: any): void {
      on菲利斯全力封印斩生效(boss, 全力封印斩技能ID);
    },
  });
}

function on菲利斯全力封印斩生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 全力封印斩技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 菲利斯单位类型ID) return;
  const context = 获取或创建菲利斯上下文(castingUnit);
  if (context == null) return;
  释放菲利斯全力封印斩(context);
}
