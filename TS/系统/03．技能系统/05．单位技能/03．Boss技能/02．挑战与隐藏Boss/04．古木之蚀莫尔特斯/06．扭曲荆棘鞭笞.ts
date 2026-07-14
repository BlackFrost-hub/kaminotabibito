/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, 播放莫尔特斯限时动作, 极坐标X, 极坐标Y, 点到线段距离平方, stringToFourCC } from "./16．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 施加寄生 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.06．对外接口") as {
  施加寄生: (this: void, 参数: any) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 莫尔特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯") as {
  莫尔特斯BuffID: { 荆棘寄生: string };
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

interface 鞭笞通道 {
  X: number;
  Y: number;
  朝向: number;
}

interface 鞭笞命中变量 {
  context: 莫尔特斯运行时上下文;
  channel: 鞭笞通道;
  命中次数表: Record<number, number | undefined>;
}

interface 鞭笞波次变量 {
  context: 莫尔特斯运行时上下文;
  命中次数表: Record<number, number | undefined>;
}

const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);
const 扭曲荆棘鞭笞技能ID = stringToFourCC(莫尔特斯数值与表现配置.扭曲荆棘鞭笞.技能槽位);
let 已注册 = false;

function 构造鞭笞通道列表(this: void, context: 莫尔特斯运行时上下文): 鞭笞通道[] {
  const grid = context.根须宫格;
  const result: 鞭笞通道[] = [];
  if (grid == null) return result;
  for (let col = 0; col < 3; col++) {
    const top = grid.获取格子(2, col);
    const bottom = grid.获取格子(0, col);
    if (top != null) result.push({ X: top.中心X, Y: top.上, 朝向: 270 });
    if (bottom != null) result.push({ X: bottom.中心X, Y: bottom.下, 朝向: 90 });
  }
  for (let row = 0; row < 3; row++) {
    const left = grid.获取格子(row, 0);
    const right = grid.获取格子(row, 2);
    if (left != null) result.push({ X: left.左, Y: left.中心Y, 朝向: 0 });
    if (right != null) result.push({ X: right.右, Y: right.中心Y, 朝向: 180 });
  }
  return result;
}

function 选择本波通道(this: void, context: 莫尔特斯运行时上下文): 鞭笞通道[] {
  const pool = 构造鞭笞通道列表(context);
  const result: 鞭笞通道[] = [];
  const count = 莫尔特斯数值与表现配置.扭曲荆棘鞭笞.藤蔓数量;
  for (let i = 0; i < count && pool.length > 0; i++) {
    const index = GetRandomInt(0, pool.length - 1);
    result.push(pool[index]);
    pool.splice(index, 1);
  }
  return result;
}

function 单通道鞭笞命中(this: void, context: 莫尔特斯运行时上下文, channel: 鞭笞通道, 命中次数表: Record<number, number | undefined>): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.扭曲荆棘鞭笞;
  const endX = 极坐标X(channel.X, channel.朝向, cfg.矩形长度);
  const endY = 极坐标Y(channel.Y, channel.朝向, cfg.矩形长度);
  AddSpecialEffect(cfg.藤蔓模型路径, channel.X, channel.Y);
  for (let i = 1; i <= 3; i++) {
    AddSpecialEffect(cfg.路径爆点特效路径, 极坐标X(channel.X, channel.朝向, i * 512), 极坐标Y(channel.Y, channel.朝向, i * 512));
  }
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const dist2 = 点到线段距离平方(GetUnitX(hero), GetUnitY(hero), channel.X, channel.Y, endX, endY);
    if (dist2 > (cfg.矩形宽度 * cfg.矩形宽度) / 4) continue;
    const hid = GetHandleId(hero) || 0;
    const oldHits = 命中次数表[hid] ?? 0;
    命中次数表[hid] = oldHits + 1;
    const damage = 读取单位攻击力(boss) * cfg.Boss攻击力比例 * (1 + oldHits * cfg.重复命中增伤比例);
    造成AOE技能伤害({
      技能ID: 扭曲荆棘鞭笞技能ID,
      来源: boss,
      目标: hero,
      伤害: damage,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_PLANT,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "Boss技能",
    });
    应用莫尔特斯腐败值(context, hero, 8);
    施加寄生({
      来源单位: boss,
      目标单位: hero,
      持续时间: cfg.寄生持续秒,
      伤害: cfg.寄生每跳伤害,
      伤害间隔: cfg.寄生伤害间隔秒,
    });
    registerManualBuff(hero, 莫尔特斯BuffID.荆棘寄生, cfg.寄生持续秒, cfg.寄生每跳伤害, {
      sourceName: "莫尔特斯-荆棘寄生",
    });
  }
}

function 莫尔特斯荆棘鞭笞命中(this: void, variable?: any): void {
  const data = variable as 鞭笞命中变量 | undefined;
  if (data == null) return;
  单通道鞭笞命中(data.context, data.channel, data.命中次数表);
}

function 莫尔特斯荆棘鞭笞扫击音效(this: void, variable?: any): void {
  const context = variable as 莫尔特斯运行时上下文 | undefined;
  if (context == null || !单位有效(context.Boss单位)) return;
  播放Boss坐标音效(莫尔特斯音效配置.扭曲荆棘鞭笞.扫击, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 莫尔特斯音效配置.默认裁断距离);
}

function 执行一波鞭笞(this: void, context: 莫尔特斯运行时上下文, 命中次数表: Record<number, number | undefined>): void {
  const cfg = 莫尔特斯数值与表现配置.扭曲荆棘鞭笞;
  const channels = 选择本波通道(context);
  if (channels.length > 0) {
    const sfxId = addDelayedCallback(cfg.预警秒 * 1000, 莫尔特斯荆棘鞭笞扫击音效, context);
    context.清理.登记延迟回调("莫尔特斯-荆棘鞭笞扫击音效", sfxId);
  }
  for (let i = 0; i < channels.length; i++) {
    const channel = channels[i];
    创建技能提示圈({
      类型: "矩形",
      X: 极坐标X(channel.X, channel.朝向, cfg.矩形长度 / 2),
      Y: 极坐标Y(channel.Y, channel.朝向, cfg.矩形长度 / 2),
      宽度: cfg.矩形宽度,
      长度: cfg.矩形长度,
      朝向: channel.朝向,
      持续时间: cfg.预警秒,
    });
    const id = addDelayedCallback(cfg.预警秒 * 1000, 莫尔特斯荆棘鞭笞命中, { context, channel, 命中次数表 } as 鞭笞命中变量);
    context.清理.登记延迟回调("莫尔特斯-荆棘鞭笞命中", id);
  }
}

function 莫尔特斯荆棘鞭笞波次(this: void, variable?: any): void {
  const data = variable as 鞭笞波次变量 | undefined;
  if (data == null) return;
  执行一波鞭笞(data.context, data.命中次数表);
}

export function 释放莫尔特斯扭曲荆棘鞭笞(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 莫尔特斯数值与表现配置.扭曲荆棘鞭笞;
  播放莫尔特斯限时动作(boss, cfg.动画编号, cfg.动画速度, cfg.动作播放秒);
  播放莫尔特斯台词(boss, "扭曲荆棘鞭笞");
  const hitMap: Record<number, number | undefined> = {};
  for (let wave = 0; wave < cfg.扫击次数; wave++) {
    const delay = (cfg.开始延迟秒 + wave * cfg.波次间隔秒) * 1000;
    const id = addDelayedCallback(delay, 莫尔特斯荆棘鞭笞波次, { context, 命中次数表: hitMap } as 鞭笞波次变量);
    context.清理.登记延迟回调("莫尔特斯-荆棘鞭笞波次", id);
  }
}

function on莫尔特斯扭曲荆棘鞭笞施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 扭曲荆棘鞭笞技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 莫尔特斯单位类型ID) return;
  const context = 获取或创建莫尔特斯上下文(castingUnit);
  if (context == null) return;
  释放莫尔特斯扭曲荆棘鞭笞(context);
}

export function 注册莫尔特斯扭曲荆棘鞭笞(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "06．扭曲荆棘鞭笞",
    单位类型ID: 莫尔特斯单位类型ID,
    技能ID: 扭曲荆棘鞭笞技能ID,
    获取或创建上下文: 获取或创建莫尔特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 莫尔特斯运行时上下文, boss: any): void {
      on莫尔特斯扭曲荆棘鞭笞施法(boss, 扭曲荆棘鞭笞技能ID);
    },
  });
}
