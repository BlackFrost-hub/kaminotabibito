/** @noSelfInFile */

import { type 卡瑟拉运行时上下文, 消耗玩家触手残片, 刷新卡瑟拉阶段 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, stringToFourCC, 极坐标X, 极坐标Y, 距离平方XY } from "./14．公共工具";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { DzDoodadCreate, DzDoodadSetModel, DzDoodadSetVisible } = require("lib.扩展函数.KK扩展API.00．装饰物函数") as {
  DzDoodadCreate: (this: void, id: number, varId: number, x: number, y: number, z: number, rotate: number, scale: number) => number;
  DzDoodadSetModel: (this: void, doodad: number, modelFile: string) => void;
  DzDoodadSetVisible: (this: void, doodad: number, enable: boolean) => void;
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, source: any, target: any, controlType: number, duration: number) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 卡瑟拉BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.08．卡瑟拉") as {
  卡瑟拉BuffID: { 麻痹电流: string; 绝缘庇护: string };
};

function 播放点特效(this: void, model: string, x: number, y: number): void {
  if (model === "") return;
  const effect = AddSpecialEffect(model, x, y);
  DestroyEffect(effect);
}

function 播放单位特效(this: void, model: string, unit: any): void {
  if (model === "" || !单位有效(unit)) return;
  const effect = AddSpecialEffectTarget(model, unit, "origin");
  DestroyEffect(effect);
}

function 确保绝缘珊瑚(this: void, context: 卡瑟拉运行时上下文): void {
  if (context.绝缘珊瑚列表.length > 0) return;
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);
  for (let i = 0; i < cfg.珊瑚数量; i++) {
    const angle = i * 120 + 40;
    const x = 极坐标X(bx, angle, cfg.珊瑚距离);
    const y = 极坐标Y(by, angle, cfg.珊瑚距离);
    const doodad = DzDoodadCreate(stringToFourCC(cfg.珊瑚装饰物ID), 1, x, y, 0, angle, cfg.珊瑚缩放);
    DzDoodadSetModel(doodad, cfg.珊瑚模型路径);
    context.清理.登记清理("卡瑟拉-绝缘珊瑚装饰物", function 卡瑟拉绝缘珊瑚隐藏(this: void): void {
      DzDoodadSetVisible(doodad, false);
    });
    context.绝缘珊瑚列表.push({ X: x, Y: y, 半径: cfg.安全半径, 装饰单位: doodad });
  }
}

function 玩家在绝缘珊瑚内(this: void, context: 卡瑟拉运行时上下文, hero: any): boolean {
  const hx = GetUnitX(hero);
  const hy = GetUnitY(hero);
  for (let i = 0; i < context.绝缘珊瑚列表.length; i++) {
    const coral = context.绝缘珊瑚列表[i];
    if (距离平方XY(hx, hy, coral.X, coral.Y) <= coral.半径 * coral.半径) return true;
  }
  return false;
}

function 预警绝缘珊瑚(this: void, context: 卡瑟拉运行时上下文): void {
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  for (let i = 0; i < context.绝缘珊瑚列表.length; i++) {
    const coral = context.绝缘珊瑚列表[i];
    创建技能提示圈({
      类型: "白色安全圆",
      X: coral.X,
      Y: coral.Y,
      半径: coral.半径,
      持续时间: cfg.预警秒,
      来源单位: context.Boss单位,
    });
  }
}

function 结算卡瑟拉共生电击(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.Boss潜入中) return;
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  播放点特效(cfg.全屏命中特效路径, GetUnitX(boss), GetUnitY(boss));
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (玩家在绝缘珊瑚内(context, hero)) {
      registerManualBuff(hero, 卡瑟拉BuffID.绝缘庇护, cfg.麻痹秒, 1, { sourceName: "卡瑟拉-绝缘庇护" });
      continue;
    }
    if (消耗玩家触手残片(context, hero, cfg.抵消残片数)) continue;
    UnitDamageTarget(boss, hero, cfg.雷伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_LIGHTNING, WEAPON_TYPE_WHOKNOWS);
    播放单位特效(cfg.麻痹命中特效路径, hero);
    施加快速控制Buff(boss, hero, 0, cfg.麻痹秒);
    registerManualBuff(hero, 卡瑟拉BuffID.麻痹电流, cfg.麻痹秒, 1, { sourceName: "卡瑟拉-麻痹电流" });
  }
}

export function 尝试释放卡瑟拉共生电击(this: void, context: 卡瑟拉运行时上下文, nowMs: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.Boss潜入中) return;
  if (刷新卡瑟拉阶段(context) < 3) return;
  const cfg = 卡瑟拉数值与表现配置.共生电击;
  确保绝缘珊瑚(context);
  if (context.下次共生电击时间 <= 0) {
    context.下次共生电击时间 = nowMs + cfg.间隔秒 * 1000;
    return;
  }
  if (nowMs < context.下次共生电击时间) return;
  context.下次共生电击时间 = nowMs + cfg.间隔秒 * 1000;
  播放卡瑟拉台词(boss, "共生电击");
  播放点特效(cfg.蓄力特效路径, GetUnitX(boss), GetUnitY(boss));
  预警绝缘珊瑚(context);
  const id = addDelayedCallback(cfg.预警秒 * 1000, function 卡瑟拉共生电击结算(this: void): void {
    结算卡瑟拉共生电击(context);
  });
  context.清理.登记延迟回调("卡瑟拉-共生电击结算", id);
}

export function 注册卡瑟拉共生电击(this: void): void {
}
