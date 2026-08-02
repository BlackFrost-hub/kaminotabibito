/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, 极坐标X, 极坐标Y, 点到线段距离平方, stringToFourCC } from "./16．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 创建固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂";
import { 执行BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const DzSetEffectVertexAlpha = japi.DzSetEffectVertexAlpha as ((effect: any, alpha: number) => void) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

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
  边框键: string;
  边框方向: string;
  对面边框键: string;
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
    if (top != null) result.push({ X: top.中心X, Y: top.上, 朝向: 270, 边框键: "top-" + col, 边框方向: "top", 对面边框键: "bottom-" + col });
    if (bottom != null) result.push({ X: bottom.中心X, Y: bottom.下, 朝向: 90, 边框键: "bottom-" + col, 边框方向: "bottom", 对面边框键: "top-" + col });
  }
  for (let row = 2; row >= 0; row--) {
    const left = grid.获取格子(row, 0);
    const right = grid.获取格子(row, 2);
    if (left != null) result.push({ X: left.左, Y: left.中心Y, 朝向: 360, 边框键: "left-" + row, 边框方向: "left", 对面边框键: "right-" + row });
    if (right != null) result.push({ X: right.右, Y: right.中心Y, 朝向: 180, 边框键: "right-" + row, 边框方向: "right", 对面边框键: "left-" + row });
  }
  return result;
}

function 选择本波通道(this: void, context: 莫尔特斯运行时上下文): 鞭笞通道[] {
  const pool = 构造鞭笞通道列表(context);
  const result: 鞭笞通道[] = [];
  const 已选边框: Record<string, boolean> = {};
  const 边框方向数量: Record<string, number> = {};
  const count = 莫尔特斯数值与表现配置.扭曲荆棘鞭笞.藤蔓数量;
  for (let i = 0; i < count; i++) {
    const 可选通道: 鞭笞通道[] = [];
    for (let j = 0; j < pool.length; j++) {
      const candidate = pool[j];
      if (已选边框[candidate.边框键] === true) continue;
      if (已选边框[candidate.对面边框键] === true) continue;
      if ((边框方向数量[candidate.边框方向] ?? 0) >= 2) continue;
      可选通道.push(candidate);
    }
    if (可选通道.length <= 0) break;
    const selected = 可选通道[GetRandomInt(0, 可选通道.length - 1)];
    result.push(selected);
    已选边框[selected.边框键] = true;
    边框方向数量[selected.边框方向] = (边框方向数量[selected.边框方向] ?? 0) + 1;
    const poolIndex = pool.indexOf(selected);
    if (poolIndex >= 0) pool.splice(poolIndex, 1);
  }
  return result;
}

function 清理莫尔特斯扭曲荆棘鞭笞特效(this: void, context: 莫尔特斯运行时上下文): void {
  const state = context as any;
  const effects = state.__moltesWhipEffects as any[] | undefined;
  if (effects == null) return;
  for (let i = 0; i < effects.length; i++) {
    const effect = effects[i];
    if (effect != null && effect !== 0) {
      if (typeof DzSetEffectVertexAlpha === "function") DzSetEffectVertexAlpha(effect, 0);
      if (typeof EXSetEffectSize === "function") EXSetEffectSize(effect, 0.01);
      DestroyEffect(effect);
    }
  }
  state.__moltesWhipEffects = [];
}

function 延迟清理莫尔特斯扭曲荆棘鞭笞特效(this: void, effects: any[]): void {
  if (effects == null) return;
  for (let i = 0; i < effects.length; i++) {
    const effect = effects[i];
    if (effect != null && effect !== 0) {
      if (typeof DzSetEffectVertexAlpha === "function") DzSetEffectVertexAlpha(effect, 0);
      if (typeof EXSetEffectSize === "function") EXSetEffectSize(effect, 0.01);
      DestroyEffect(effect);
    }
  }
}

function 安排清理莫尔特斯扭曲荆棘鞭笞特效(this: void, context: 莫尔特斯运行时上下文): void {
  const state = context as any;
  const effects = state.__moltesWhipEffects as any[] | undefined;
  if (effects == null || effects.length <= 0) return;
  state.__moltesWhipEffects = [];
  const callbackId = addDelayedCallback(500, 延迟清理莫尔特斯扭曲荆棘鞭笞特效, effects);
  context.清理.登记延迟回调("莫尔特斯-扭曲荆棘鞭笞延迟清理", callbackId);
}

function 创建莫尔特斯扭曲荆棘鞭笞特效(this: void, context: 莫尔特斯运行时上下文, 参数: any): void {
  const effect = 创建点特效(参数);
  if (effect == null || effect === 0) return;
  const state = context as any;
  let effects = state.__moltesWhipEffects as any[] | undefined;
  if (effects == null) {
    effects = [];
    state.__moltesWhipEffects = effects;
  }
  effects.push(effect);
}

function 获取莫尔特斯通道荆棘模型路径(this: void, 模型路径列表: readonly string[]): string {
  return 模型路径列表[GetRandomInt(0, 模型路径列表.length - 1)];
}

function 单通道鞭笞命中(this: void, context: 莫尔特斯运行时上下文, channel: 鞭笞通道, 命中次数表: Record<number, number | undefined>): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.扭曲荆棘鞭笞;
  const endX = 极坐标X(channel.X, channel.朝向, cfg.矩形长度);
  const endY = 极坐标Y(channel.Y, channel.朝向, cfg.矩形长度);
  创建莫尔特斯扭曲荆棘鞭笞特效(context, {
    模型路径: cfg.藤蔓模型路径,
    X: channel.X,
    Y: channel.Y,
    持续秒: cfg.瞬时特效持续秒,
    缩放: cfg.藤蔓缩放,
    动画索引: cfg.触手攻击动画索引,
    Y轴角度: cfg.触手下俯角度,
    Z轴角度: channel.朝向,
  });
  const 单格边长 = 莫尔特斯数值与表现配置.根须领域.单格边长;
  const 通道格子数量 = 莫尔特斯数值与表现配置.根须领域.列数;
  for (let i = 0; i < 通道格子数量; i++) {
    const distance = (i + 0.5) * 单格边长;
    const effectX = 极坐标X(channel.X, channel.朝向, distance);
    const effectY = 极坐标Y(channel.Y, channel.朝向, distance);
    创建莫尔特斯扭曲荆棘鞭笞特效(context, {
      模型路径: 获取莫尔特斯通道荆棘模型路径(cfg.路径荆棘模型路径列表),
      X: effectX,
      Y: effectY,
      持续秒: cfg.瞬时特效持续秒,
      缩放: cfg.路径荆棘缩放,
      Z轴角度: channel.朝向,
    });
    创建莫尔特斯扭曲荆棘鞭笞特效(context, {
      模型路径: cfg.路径爆点特效路径,
      X: effectX,
      Y: effectY,
      持续秒: cfg.瞬时特效持续秒,
    });
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
    执行BossAOE技能伤害({
      技能ID: 扭曲荆棘鞭笞技能ID,
      来源: boss,
      目标: hero,
      伤害公式: {
        来源攻击力比例: cfg.Boss攻击力比例,
        总倍率: 1 + oldHits * cfg.重复命中增伤比例,
      },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_PLANT,
      weaponType: WEAPON_TYPE_WHOKNOWS,
    });
    应用莫尔特斯腐败值(context, hero, 8);
    const 寄生每跳伤害 = 读取单位攻击力(boss) * cfg.寄生每跳Boss攻击力比例;
    施加寄生({
      来源单位: boss,
      目标单位: hero,
      持续时间: cfg.寄生持续秒,
      伤害: 寄生每跳伤害,
      伤害间隔: cfg.寄生伤害间隔秒,
      伤害类型: DAMAGE_TYPE_PLANT,
    });
    registerManualBuff(hero, 莫尔特斯BuffID.荆棘寄生, cfg.寄生持续秒, 寄生每跳伤害, {
      sourceName: "莫尔特斯-荆棘寄生",
    });
  }
}

function 追加鞭笞波次时间轴(
  this: void,
  事件列表: 固定时间轴事件[],
  context: 莫尔特斯运行时上下文,
  命中次数表: Record<number, number | undefined>,
  波次索引: number,
): void {
  const cfg = 莫尔特斯数值与表现配置.扭曲荆棘鞭笞;
  const 波次序号 = 波次索引 + 1;
  const 预警时点毫秒 = (cfg.开始延迟秒 + 波次索引 * cfg.波次间隔秒) * 1000;
  const 通道列表: 鞭笞通道[] = [];
  事件列表.push({
    时点毫秒: 预警时点毫秒,
    名称: "扭曲荆棘鞭笞第" + String(波次序号) + "波预警",
    执行: function 莫尔特斯荆棘鞭笞波次预警(this: void): void {
      if (!单位有效(context.Boss单位)) return;
      const state = context as any;
      if (state.__moltesWhipHasWaveEffects === true) 清理莫尔特斯扭曲荆棘鞭笞特效(context);
      const selected = 选择本波通道(context);
      for (let i = 0; i < selected.length; i++) {
        const channel = selected[i];
        通道列表.push(channel);
        创建技能提示圈({
          类型: "矩形",
          X: channel.X,
          Y: channel.Y,
          宽度: cfg.矩形宽度,
          长度: cfg.矩形长度,
          朝向: channel.朝向,
          持续时间: cfg.预警秒,
        });
      }
    },
  });
  事件列表.push({
    时点毫秒: 预警时点毫秒 + cfg.预警秒 * 1000,
    名称: "扭曲荆棘鞭笞第" + String(波次序号) + "波结算",
    执行: function 莫尔特斯荆棘鞭笞波次结算(this: void): void {
      const boss = context.Boss单位;
      if (!单位有效(boss) || 通道列表.length <= 0) return;
      const state = context as any;
      state.__moltesWhipHasWaveEffects = true;
      播放Boss坐标音效(莫尔特斯音效配置.扭曲荆棘鞭笞.扫击, GetUnitX(boss), GetUnitY(boss), 莫尔特斯音效配置.默认裁断距离);
      for (let i = 0; i < 通道列表.length; i++) 单通道鞭笞命中(context, 通道列表[i], 命中次数表);
    },
  });
}

export function 释放莫尔特斯扭曲荆棘鞭笞(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 莫尔特斯数值与表现配置.扭曲荆棘鞭笞;
  if (cfg.扫击次数 <= 0) return;
  if (context.扭曲荆棘鞭笞组合执行器 == null) {
    context.扭曲荆棘鞭笞组合执行器 = 创建固定组合技能执行器<莫尔特斯运行时上下文>({
      名称: "莫尔特斯-扭曲荆棘鞭笞",
      清理: context.清理,
      互斥组: "莫尔特斯扭曲荆棘鞭笞",
    });
  }
  if (context.扭曲荆棘鞭笞组合执行器.是否运行中()) return;
  const hitMap: Record<number, number | undefined> = {};
  const state = context as any;
  state.__moltesWhipHasWaveEffects = false;
  const 事件列表: 固定时间轴事件[] = [];
  for (let wave = 0; wave < cfg.扫击次数; wave++) 追加鞭笞波次时间轴(事件列表, context, hitMap, wave);
  const 最后结算秒 = cfg.开始延迟秒 + (cfg.扫击次数 - 1) * cfg.波次间隔秒 + cfg.预警秒;
  const 执行ID = context.扭曲荆棘鞭笞组合执行器.开始({
    key: "扭曲荆棘鞭笞",
    单位: boss,
    上下文: context,
    最大持续毫秒: 最后结算秒 * 1000 + 1000,
    阶段列表: 创建固定时间轴阶段列表(事件列表),
  });
  if (执行ID === 0) return;
  启动基础施法时间线({
    名称: "莫尔特斯-扭曲荆棘鞭笞",
    施法者: boss,
    硬直秒: cfg.开始延迟秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    后续动画编号: 0,
    后续动画速度: 1,
    后续动画延迟毫秒: cfg.动作播放秒 * 1000,
    完成后恢复动作: false,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.开始延迟秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    清理: context.清理,
    播放台词: function 莫尔特斯扭曲荆棘鞭笞台词(this: void): void {
      播放莫尔特斯台词(boss, "扭曲荆棘鞭笞");
    },
    on生效: function 莫尔特斯扭曲荆棘鞭笞时间线生效(this: void): void {
    },
  });
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
