/** @noSelfInFile */

import { 增加玩家腐败值, 清除玩家腐败值, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效 } from "./16．公共工具";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../00．公共/00．Boss音效播放";

const { 造成单体技能伤害, 创建独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
  创建独立技能伤害实例: (this: void, 参数?: any) => number;
};
const jass = require("jass.common") as any;

const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const Location = jass.Location as (x: number, y: number) => any;
const RemoveLocation = jass.RemoveLocation as (whichLocation: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 莫尔特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.09．莫尔特斯") as {
  莫尔特斯BuffID: { 净化庇护: string };
};
const { CreateUbersplatBJ, ShowUbersplatBJ } = require("lib.扩展函数.BJ函数.11．贴图函数") as {
  CreateUbersplatBJ: (this: void, file: string, where: any, red: number, green: number, blue: number, alpha: number, forcePaused: boolean, noBirthTime: boolean) => any;
  ShowUbersplatBJ: (this: void, flag: boolean, whichUbersplat: any) => void;
};

interface 莫尔特斯腐朽领域根须延迟上下文 {
  context: 莫尔特斯运行时上下文;
  target: any;
  X: number;
  Y: number;
  技能实例ID?: number;
}

let 腐朽领域根须延迟上下文: 莫尔特斯腐朽领域根须延迟上下文 | undefined = undefined;

function 创建腐朽领域沼泽地表(this: void, context: 莫尔特斯运行时上下文): void {
  const grid = context.根须宫格;
  if (grid == null) return;
  const cfg = 莫尔特斯数值与表现配置.腐朽领域;
  const color = cfg.沼泽贴图颜色;
  for (let i = 0; i < grid.格子列表.length; i++) {
    const cell = grid.格子列表[i];
    if (cell == null) continue;
    const loc = Location(cell.中心X, cell.中心Y);
    const ubersplat = CreateUbersplatBJ(cfg.沼泽贴图类型, loc, color.r, color.g, color.b, color.a, cfg.沼泽贴图强制暂停, cfg.沼泽贴图无出生时间);
    RemoveLocation(loc);
    if (ubersplat == null || ubersplat === 0) continue;
    ShowUbersplatBJ(true, ubersplat);
    context.清理.登记贴图("莫尔特斯-腐朽领域沼泽", ubersplat);
  }
}

function 创建净化符文(this: void, context: 莫尔特斯运行时上下文): void {
  const grid = context.根须宫格;
  if (grid == null) return;
  const cfg = 莫尔特斯数值与表现配置.腐朽领域;
  const cells = [
    grid.获取格子(0, 0),
    grid.获取格子(0, 2),
    grid.获取格子(2, 0),
    grid.获取格子(2, 2),
  ];
  for (let i = 0; i < cfg.净化符文数量 && i < cells.length; i++) {
    const cell = cells[i];
    if (cell == null) continue;
    const effect = AddSpecialEffect(cfg.净化符文模型路径, cell.中心X, cell.中心Y);
    context.清理.登记特效("莫尔特斯-净化符文", effect);
    创建技能提示圈({
      类型: "白色安全圆",
      X: cell.中心X,
      Y: cell.中心Y,
      半径: cfg.净化符文半径,
      持续时间: cfg.净化持续秒,
    });
  }
}

function 处理净化符文(this: void, context: 莫尔特斯运行时上下文, hero: any): boolean {
  const grid = context.根须宫格;
  if (grid == null) return false;
  const cfg = 莫尔特斯数值与表现配置.腐朽领域;
  const cells = [
    grid.获取格子(0, 0),
    grid.获取格子(0, 2),
    grid.获取格子(2, 0),
    grid.获取格子(2, 2),
  ];
  for (let i = 0; i < cells.length; i++) {
    const cell = cells[i];
    if (cell == null) continue;
    const dx = GetUnitX(hero) - cell.中心X;
    const dy = GetUnitY(hero) - cell.中心Y;
    if (dx * dx + dy * dy <= cfg.净化符文半径 * cfg.净化符文半径) {
      清除玩家腐败值(context, hero, 莫尔特斯数值与表现配置.腐败值.净化光斑每秒清除);
      registerManualBuff(hero, 莫尔特斯BuffID.净化庇护, 1.2, 1, {
        sourceName: "莫尔特斯-净化符文",
      });
      return true;
    }
  }
  return false;
}

function 莫尔特斯腐朽沼泽根须(this: void): void {
  const variable = 腐朽领域根须延迟上下文;
  腐朽领域根须延迟上下文 = undefined;
  if (variable == null) return;
  const context = variable.context;
  const target = variable.target;
  if (!单位有效(context.Boss单位) || !单位有效(target)) return;
  AddSpecialEffect(莫尔特斯数值与表现配置.腐朽根须穿刺.穿刺特效路径, variable.X, variable.Y);
  造成单体技能伤害({
    来源: context.Boss单位,
    目标: target,
    伤害: 读取单位攻击力(context.Boss单位),
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_PLANT,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "Boss技能",
    技能实例ID: variable.技能实例ID,
    标签: "莫尔特斯腐朽领域根须",
  });
  增加玩家腐败值(context, target, 莫尔特斯数值与表现配置.腐朽根须穿刺.腐败值);
}

export function 尝试触发莫尔特斯腐朽领域(this: void, context: 莫尔特斯运行时上下文): void {
  if (context.腐朽领域已触发 || context.阶段 < 3 || !单位有效(context.Boss单位)) return;
  context.腐朽领域已触发 = true;
  播放莫尔特斯台词(context.Boss单位, "低血量");
  创建腐朽领域沼泽地表(context);
  创建净化符文(context);
  播放Boss坐标音效(莫尔特斯音效配置.腐朽领域.展开, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 莫尔特斯音效配置.默认裁断距离);
  尝试播放Boss拟声池({
    标识: 莫尔特斯音效配置.怪物拟声.标识,
    音效路径列表: 莫尔特斯音效配置.怪物拟声.音效路径列表,
    X: GetUnitX(context.Boss单位),
    Y: GetUnitY(context.Boss单位),
    裁断距离: 莫尔特斯音效配置.默认裁断距离,
    冷却Ms: 莫尔特斯音效配置.怪物拟声.冷却Ms,
    触发概率百分比: 莫尔特斯音效配置.怪物拟声.转阶段触发概率百分比,
  });
}

export function 处理莫尔特斯腐朽领域周期(this: void, context: 莫尔特斯运行时上下文, nowMs: number): void {
  if (!context.腐朽领域已触发 || !单位有效(context.Boss单位)) return;
  const cfg = 莫尔特斯数值与表现配置.腐朽领域;
  if (context.下次沼泽腐败时间 <= 0) context.下次沼泽腐败时间 = nowMs;
  if (nowMs < context.下次沼泽腐败时间) return;
  context.下次沼泽腐败时间 = nowMs + cfg.沼泽腐败间隔秒 * 1000;
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (处理净化符文(context, hero)) continue;
    施加快速减速Buff(context.Boss单位, hero, cfg.减速比例, cfg.减速比例, 1.3);
    增加玩家腐败值(context, hero, cfg.沼泽每跳腐败值);
  }
  if (context.下次沼泽根须时间 <= 0) context.下次沼泽根须时间 = nowMs + cfg.根须触发间隔秒 * 1000;
  if (nowMs >= context.下次沼泽根须时间 && heroes.length > 0) {
    context.下次沼泽根须时间 = nowMs + cfg.根须触发间隔秒 * 1000;
    const target = heroes[GetRandomInt(0, heroes.length - 1)];
    if (单位有效(target)) {
      const x = GetUnitX(target);
      const y = GetUnitY(target);
      const 技能实例ID = 创建独立技能伤害实例({
        来源类型: "Boss技能",
        标签: "莫尔特斯腐朽领域根须",
        持续时间秒: 3,
      });
      创建技能提示圈({
        类型: "圆形",
        X: x,
        Y: y,
        半径: 莫尔特斯数值与表现配置.根须领域.单格边长 * 0.5,
        持续时间: 1,
      });
      腐朽领域根须延迟上下文 = { context, target, X: x, Y: y, 技能实例ID };
      const id = addDelayedCallback(1000, 莫尔特斯腐朽沼泽根须);
      context.清理.登记延迟回调("莫尔特斯-腐朽沼泽根须", id);
    }
  }
}

export function 注册莫尔特斯腐朽领域(this: void): void {
}
