/** @noSelfInFile */

import { 树魔首领单位技能配置 } from "./00．配置";
import { 获取或创建树魔首领上下文, 树魔首领运行时上下文 } from "./01．运行时上下文";
import { 树魔首领数值与表现配置, 树魔首领音效配置 } from "./02．数值与表现配置";
import { 播放树魔首领台词 } from "./08．台词播放";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 创建持续危险区域, type 持续危险区域实例 } from "../../../../00．技能模板+函数/04．机制组件/03．持续危险区/01．持续危险区域";
import { 创建周期机制调度器, type 周期机制调度器 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器";
import { stringToFourCC, 距离平方XY, 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 执行BossAOE技能伤害, 提交预计算BossAOE技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { addDelayedCallback, getGameDifficulty } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getGameDifficulty: (this: void) => number;
};
const { registerManualBuff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => { effect: number; remaining: number } | null;
};
const { 树魔首领BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.04．树魔首领") as {
  树魔首领BuffID: { 治疗枯竭: string; 静止陷阱眩晕: string };
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, 来源单位: any, 目标单位: any, 控制ID: number, 持续时间: number) => void;
};
const { registerHealCallback } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  registerHealCallback: (this: void, cb: (this: void, source: any, target: any, amount: number, isItemHeal: boolean) => number) => void;
};
const { createTimedEffect, createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};
const { 读取Boss战运行上下文 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文") as {
  读取Boss战运行上下文: (this: void, boss: any) => { 地点矩形?: any } | undefined;
};
const GetRectCenterX = jass.GetRectCenterX as (rect: any) => number;
const GetRectCenterY = jass.GetRectCenterY as (rect: any) => number;

type 图腾分支 = 1 | 2 | 3;

const 快速控制_击晕 = 0;
const 树魔首领单位类型ID = stringToFourCC(树魔首领单位技能配置.单位ID);
const 树魔图腾技能ID = stringToFourCC(树魔首领数值与表现配置.树魔图腾.技能槽位);
const 猎头者单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.猎头者);
const 巫医单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.巫医);
const 投掷者单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.投掷者);
let 树魔图腾已注册 = false;
let 树魔图腾治疗回调已注册 = false;

function 取难度(this: void): number {
  const n = getGameDifficulty();
  return n > 0 ? n : 1;
}

function 取图腾中心(this: void, boss: any): { x: number; y: number } {
  const battle = 读取Boss战运行上下文(boss);
  const rect = battle?.地点矩形;
  if (rect != null && rect !== 0) {
    return { x: GetRectCenterX(rect), y: GetRectCenterY(rect) };
  }
  return { x: GetUnitX(boss), y: GetUnitY(boss) };
}

function 选择图腾分支(this: void, context: 树魔首领运行时上下文): 图腾分支 {
  const candidates: 图腾分支[] = [];
  const list = context.随从组.取单位列表();
  for (let i = 0; i < list.length; i++) {
    const unit = list[i];
    if (!单位有效(unit)) continue;
    const typeId = GetUnitTypeId(unit);
    if (typeId === 巫医单位类型ID) candidates.push(1);
    else if (typeId === 猎头者单位类型ID) candidates.push(2);
    else if (typeId === 投掷者单位类型ID) candidates.push(3);
  }
  if (candidates.length <= 0) return GetRandomInt(1, 3) as 图腾分支;
  return candidates[GetRandomInt(0, candidates.length - 1)];
}

function 尝试播放树魔首领关键怪叫(this: void, boss: any): void {
  const soundCfg = 树魔首领音效配置;
  尝试播放Boss拟声池({
    标识: soundCfg.怪物拟声.标识,
    音效路径列表: soundCfg.怪物拟声.音效路径列表,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    裁断距离: soundCfg.默认裁断距离,
    冷却Ms: soundCfg.怪物拟声.冷却Ms,
    触发概率百分比: soundCfg.怪物拟声.关键机制触发概率百分比,
  });
}

function 创建图腾单位(this: void, context: 树魔首领运行时上下文, 名称: string, 模型路径: string, 最大生命: number, 持续秒: number, 固定站桩: boolean = false, on死亡?: (this: void, unit: any, killer: any) => void): any {
  const boss = context.Boss单位;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  const center = 取图腾中心(boss);
  创建技能提示圈({
    类型: "渐变圆形",
    X: center.x,
    Y: center.y,
    半径: cfg.图腾落点提示半径,
    持续时间: 0.6,
    来源单位: boss,
  });
  const totem = 创建可攻击机制单位({
    清理: context.清理,
    名称,
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    模型路径,
    X: center.x,
    Y: center.y,
    最大生命,
    固定站桩,
    生命值受小怪倍率: false,
    飞行高度: cfg.图腾飞行高度,
    缩放: cfg.图腾缩放,
    持续时间: 持续秒,
    on死亡,
  });
  if (totem != null) {
    播放Boss坐标音效(树魔首领音效配置.树魔图腾.生成, center.x, center.y, 树魔首领音效配置.默认裁断距离);
  }
  return totem;
}

function 对所有玩家施加静止眩晕(this: void, boss: any): void {
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    施加快速控制Buff(boss, hero, 快速控制_击晕, cfg.静止陷阱眩晕秒);
    registerManualBuff(hero, 树魔首领BuffID.静止陷阱眩晕, cfg.静止陷阱眩晕秒, 0, {
      sourceName: "树魔首领-静止陷阱",
    });
  }
}

interface 树魔静止陷阱周期状态 {
  context: 树魔首领运行时上下文;
  boss: any;
  trap: any;
  提示累计毫秒: number;
  已开始触发: boolean;
  调度器?: 周期机制调度器;
}

function 执行树魔静止陷阱Tick(this: void, state: 树魔静止陷阱周期状态): void {
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  if (!单位有效(state.boss) || !state.trap.是否存活()) {
    state.调度器?.停止();
    return;
  }
  state.提示累计毫秒 += cfg.静止陷阱Tick毫秒;
  if (state.提示累计毫秒 >= cfg.静止陷阱范围提示间隔毫秒) {
    state.提示累计毫秒 = 0;
    创建技能提示圈({
      类型: "圆形",
      锚点单位: state.trap.单位,
      半径: cfg.静止陷阱触发半径,
      持续时间: cfg.静止陷阱范围提示间隔毫秒 / 1000 + 0.1,
    });
  }

  const heroes = 获取Boss技能敌对英雄列表(state.boss);
  const radius2 = cfg.静止陷阱触发半径 * cfg.静止陷阱触发半径;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (距离平方XY(GetUnitX(state.trap.单位), GetUnitY(state.trap.单位), GetUnitX(hero), GetUnitY(hero)) > radius2) continue;
    if (state.已开始触发) return;
    state.已开始触发 = true;
    state.调度器?.停止();
    const 触发延迟ID = addDelayedCallback(cfg.静止陷阱触发延迟秒 * 1000, function 树魔首领静止陷阱延迟触发(this: void): void {
      if (!单位有效(state.boss) || !state.trap.是否存活()) return;
      播放Boss坐标音效(树魔首领音效配置.树魔图腾.陷阱触发, GetUnitX(state.trap.单位), GetUnitY(state.trap.单位), 树魔首领音效配置.默认裁断距离);
      SetUnitAnimationByIndex(state.trap.单位, 3);
      对所有玩家施加静止眩晕(state.boss);
      state.trap.销毁();
    });
    state.context.清理.登记延迟回调("树魔首领-静止陷阱触发", 触发延迟ID);
    return;
  }
}

interface 树魔爆炸陷阱传送周期状态 {
  context: 树魔首领运行时上下文;
  boss: any;
  trap: any;
  naturalEnd: boolean;
  调度器?: 周期机制调度器;
}

function 执行树魔爆炸陷阱传送Tick(this: void, state: 树魔爆炸陷阱传送周期状态): void {
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  if (!单位有效(state.boss) || !state.trap.是否存活() || state.naturalEnd) {
    state.调度器?.停止();
    return;
  }
  const angle = GetRandomReal(0, 360);
  const distance = GetRandomReal(cfg.爆炸陷阱传送最近距离, cfg.爆炸陷阱传送最远距离);
  const x = GetUnitX(state.boss) + CosBJ(angle) * distance;
  const y = GetUnitY(state.boss) + SinBJ(angle) * distance;
  SetUnitPosition(state.trap.单位, x, y);
  创建技能提示圈({
    类型: "圆形",
    X: x,
    Y: y,
    半径: cfg.图腾落点提示半径,
    持续时间: 0.8,
    来源单位: state.boss,
  });
}

function 创建静止陷阱(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  const duration = cfg.静止陷阱基础持续秒 + cfg.静止陷阱每难度追加秒 * 取难度();
  const trap = 创建图腾单位(
    context,
    "树魔首领-静止陷阱",
    cfg.静止陷阱模型路径,
    GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * cfg.静止陷阱生命Boss最大生命比例,
    duration,
    true,
  );
  if (trap == null) return;

  const state: 树魔静止陷阱周期状态 = {
    context,
    boss,
    trap,
    提示累计毫秒: cfg.静止陷阱范围提示间隔毫秒,
    已开始触发: false,
  };
  state.调度器 = 创建周期机制调度器({
    名称: "树魔首领-静止陷阱Tick",
    清理: context.清理,
    间隔毫秒: cfg.静止陷阱Tick毫秒,
    取上下文列表: function 取树魔静止陷阱状态列表(this: void): 树魔静止陷阱周期状态[] {
      return [state];
    },
    执行: 执行树魔静止陷阱Tick,
  });
}

function 创建生命陷阱(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  const trap = 创建图腾单位(
    context,
    "树魔首领-生命陷阱",
    cfg.生命陷阱模型路径,
    GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * cfg.生命陷阱生命Boss最大生命比例,
    cfg.生命陷阱持续秒,
  );
  if (trap == null) return;
  const healReduce = cfg.生命陷阱治疗降低基础比例 + cfg.生命陷阱治疗降低每难度追加比例 * 取难度();
  创建技能提示圈({
    类型: "渐变圆形",
    锚点单位: trap.单位,
    半径: cfg.生命陷阱影响半径,
    持续时间: cfg.生命陷阱持续秒,
    来源单位: boss,
  });
  let 区域实例: 持续危险区域实例 | undefined;
  区域实例 = 创建持续危险区域({
    X: GetUnitX(trap.单位),
    Y: GetUnitY(trap.单位),
    半径: cfg.生命陷阱影响半径,
    持续时间: cfg.生命陷阱持续秒,
    检测间隔: cfg.生命陷阱Tick秒,
    影响目标: "敌方",
    所有者: boss,
    提示圈: false,
    on周期: function 树魔首领生命陷阱周期(this: void, heroes: any[]): void {
      if (!单位有效(boss) || !trap.是否存活()) {
        区域实例?.销毁();
        return;
      }
      for (let i = 0; i < heroes.length; i++) {
        const hero = heroes[i];
        if (!单位有效(hero)) continue;
        const 伤害结果 = 执行BossAOE技能伤害({
          技能ID: 树魔图腾技能ID,
          来源: boss,
          目标: hero,
          伤害公式: {
            目标最大生命比例: cfg.生命陷阱伤害目标最大生命比例,
          },
          attack: false,
          ranged: false,
          attackType: ATTACK_TYPE_NORMAL,
          伤害类型: DAMAGE_TYPE_ENHANCED,
          weaponType: WEAPON_TYPE_WHOKNOWS,
        });
        if (伤害结果.是否造成伤害) {
          createTimedUnitEffect(
            hero,
            cfg.生命陷阱伤害特效挂点,
            cfg.生命陷阱伤害特效路径,
            cfg.生命陷阱伤害特效持续秒,
          );
        }
        registerManualBuff(hero, 树魔首领BuffID.治疗枯竭, cfg.生命陷阱Tick秒 + 0.4, healReduce, {
          sourceName: "树魔首领-生命陷阱",
        });
      }
    },
  });
  context.清理.登记清理("树魔首领-生命陷阱区域", function 树魔首领生命陷阱区域清理(this: void): void {
    区域实例?.销毁();
  });
}

function 爆炸陷阱造成伤害(this: void, boss: any, x: number, y: number): void {
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  播放Boss坐标音效(树魔首领音效配置.树魔图腾.陷阱触发, x, y, 树魔首领音效配置.默认裁断距离);
  createTimedEffect(cfg.爆炸陷阱爆炸特效路径, x, y, 0, cfg.爆炸陷阱爆炸特效持续秒);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const damage = GetUnitState(hero, UNIT_STATE_LIFE) * cfg.爆炸陷阱当前生命伤害比例
      + cfg.爆炸陷阱每难度固定伤害 * 取难度();
    提交预计算BossAOE技能伤害({
      技能ID: 树魔图腾技能ID,
      来源: boss,
      目标: hero,
      伤害: damage,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_MAGIC,
      weaponType: WEAPON_TYPE_WHOKNOWS,
    });
  }
}

function 调度爆炸陷阱爆炸(this: void, context: 树魔首领运行时上下文, x: number, y: number): void {
  const boss = context.Boss单位;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  创建技能提示圈({
    类型: "渐变圆形",
    X: x,
    Y: y,
    半径: cfg.爆炸陷阱爆炸提示半径,
    持续时间: cfg.爆炸陷阱被摧毁爆炸延迟秒,
    来源单位: boss,
  });
  const delayedID = addDelayedCallback(cfg.爆炸陷阱被摧毁爆炸延迟秒 * 1000, function 树魔首领爆炸陷阱爆炸(this: void): void {
    if (!单位有效(boss)) return;
    爆炸陷阱造成伤害(boss, x, y);
  });
  context.清理.登记延迟回调("树魔首领-爆炸陷阱爆炸", delayedID);
}

function 创建爆炸陷阱(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  let exploded = false;
  let state: 树魔爆炸陷阱传送周期状态;
  const trap = 创建图腾单位(
    context,
    "树魔首领-爆炸陷阱",
    cfg.爆炸陷阱模型路径,
    GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE) * cfg.爆炸陷阱生命Boss最大生命比例,
    0,
    true,
    function 树魔首领爆炸陷阱死亡(this: void, unit: any): void {
      if (state?.naturalEnd || exploded) return;
      exploded = true;
      调度爆炸陷阱爆炸(context, GetUnitX(unit), GetUnitY(unit));
    },
  );
  if (trap == null) return;
  state = { context, boss, trap, naturalEnd: false };

  const naturalEndID = addDelayedCallback(cfg.爆炸陷阱持续秒 * 1000, function 树魔首领爆炸陷阱自然结束(this: void): void {
    state.naturalEnd = true;
    state.调度器?.停止();
    if (trap.是否存活()) trap.销毁();
  });
  context.清理.登记延迟回调("树魔首领-爆炸陷阱自然结束", naturalEndID);

  const 原始传送间隔 = cfg.爆炸陷阱传送基础间隔秒 - cfg.爆炸陷阱传送每难度减少秒 * 取难度();
  const interval = 原始传送间隔 > 1.2 ? 原始传送间隔 : 1.2;
  state.调度器 = 创建周期机制调度器({
    名称: "树魔首领-爆炸陷阱传送",
    清理: context.清理,
    间隔毫秒: interval * 1000,
    取上下文列表: function 取树魔爆炸陷阱状态列表(this: void): 树魔爆炸陷阱传送周期状态[] {
      return [state];
    },
    执行: 执行树魔爆炸陷阱传送Tick,
  });
}

function 创建树魔图腾分支(this: void, context: 树魔首领运行时上下文): void {
  const branch = 选择图腾分支(context);
  if (branch === 1) 创建静止陷阱(context);
  else if (branch === 2) 创建生命陷阱(context);
  else 创建爆炸陷阱(context);
}

export function 释放树魔首领树魔图腾(this: void, context: 树魔首领运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 树魔首领数值与表现配置.树魔图腾;
  尝试播放树魔首领关键怪叫(boss);
  启动基础施法时间线({
    施法者: boss,
    目标X: GetUnitX(boss),
    目标Y: GetUnitY(boss),
    硬直秒: cfg.施法硬直秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    恢复动画编号: cfg.恢复动画编号,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.施法硬直秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    播放台词: function 树魔首领树魔图腾台词(this: void): void {
      播放树魔首领台词(boss, "树魔图腾");
    },
    on生效: function 树魔首领树魔图腾生效(this: void): void {
      创建树魔图腾分支(context);
    },
  });
}

function 治疗枯竭治疗修正(this: void, _source: any, target: any, amount: number, _isItemHeal: boolean): number {
  const runtime = getBuffRuntime(target, 树魔首领BuffID.治疗枯竭);
  if (runtime == null) return amount;
  const reduce = runtime.effect > 0 ? runtime.effect : 0;
  return amount * (1 - reduce);
}

export function 注册树魔首领树魔图腾(this: void): void {
  if (!树魔图腾治疗回调已注册) {
    树魔图腾治疗回调已注册 = true;
    registerHealCallback(治疗枯竭治疗修正);
  }
  if (树魔图腾已注册) return;
  树魔图腾已注册 = true;
  注册单位技能壳监听({
    名称: "树魔首领-树魔图腾",
    单位类型ID: 树魔首领单位类型ID,
    技能ID: 树魔图腾技能ID,
    获取或创建上下文: 获取或创建树魔首领上下文,
    释放技能: function 树魔首领树魔图腾监听释放(this: void, _context: 树魔首领运行时上下文, boss: any): void {
      on树魔首领树魔图腾生效(boss, 树魔图腾技能ID);
    },
  });
}

function on树魔首领树魔图腾生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 树魔图腾技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 树魔首领单位类型ID) return;
  const context = 获取或创建树魔首领上下文(castingUnit);
  if (context == null) return;
  释放树魔首领树魔图腾(context);
}
