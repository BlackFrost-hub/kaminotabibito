/** @noSelfInFile */

import { 里科特单位技能配置 } from "./00．配置";
import { 获取或创建里科特上下文, 刷新里科特阶段, type 里科特运行时上下文 } from "./01．运行时上下文";
import { 里科特数值与表现配置 } from "./02．数值与表现配置";
import { 播放里科特台词 } from "./10．台词播放";
import { 单位有效, stringToFourCC, 距离平方XY } from "./13．公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ShowUnit = jass.ShowUnit as (whichUnit: any, show: boolean) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const GetRandomInt = jass.GetRandomInt as (lowBound: number, highBound: number) => number;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
};
const { 施加快速控制Buff, 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, source: any, target: any, controlType: number, duration: number) => void;
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number) => void;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  施加眩晕: (this: void, source: any, target: any, duration: number) => void;
};

interface 湮灭风场 {
  context: 里科特运行时上下文;
  剩余跳数: number;
  周期ID: number;
}

const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);
const 湮灭之风技能ID = stringToFourCC(里科特数值与表现配置.湮灭之风.技能槽位);
let 已注册 = false;

function 播放限时点特效(this: void, model: string, x: number, y: number, duration: number): void {
  if (model === "") return;
  const effect = AddSpecialEffect(model, x, y);
  const id = addDelayedCallback(duration * 1000, function 里科特湮灭之风特效销毁(this: void): void {
    DestroyEffect(effect);
  });
  if (id === 0) DestroyEffect(effect);
}

function 施加湮灭之风随机控制(this: void, boss: any, hero: any): void {
  const cfg = 里科特数值与表现配置.湮灭之风;
  const roll = GetRandomInt(0, 2);
  if (roll === 0) {
    施加眩晕(boss, hero, cfg.随机眩晕秒);
  } else if (roll === 1) {
    施加快速控制Buff(boss, hero, 2, cfg.随机控制持续秒);
  } else {
    施加快速减速Buff(boss, hero, cfg.随机减速比例, cfg.随机减速比例, cfg.随机减速秒);
  }
}

function 结算湮灭之风一跳(this: void, data: 湮灭风场): void {
  const context = data.context;
  const boss = context.Boss单位;
  if (!单位有效(boss) || data.剩余跳数 <= 0) {
    removePeriodicCallback(data.周期ID);
    ShowUnit(boss, true);
    return;
  }
  data.剩余跳数 = data.剩余跳数 - 1;
  const cfg = 里科特数值与表现配置.湮灭之风;
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);
  const radius2 = cfg.半径 * cfg.半径;
  const damage = 读取单位攻击力(boss) * cfg.Boss攻击力比例;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  创建技能提示圈({
    类型: "圆形",
    X: bx,
    Y: by,
    半径: cfg.半径,
    持续时间: cfg.tick秒,
    来源单位: boss,
  });
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (距离平方XY(GetUnitX(hero), GetUnitY(hero), bx, by) > radius2) continue;
    UnitDamageTarget(boss, hero, damage, false, false, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
    施加快速控制Buff(boss, hero, 2, cfg.沉默秒);
  }
  const randomHero = 获取Boss技能随机敌对英雄(boss, boss, cfg.半径);
  if (单位有效(randomHero)) 施加湮灭之风随机控制(boss, randomHero);
}

export function 释放里科特湮灭之风(this: void, context: 里科特运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 里科特数值与表现配置.湮灭之风;
  播放里科特台词(boss, "湮灭之风");
  播放限时点特效(cfg.扩散特效路径, GetUnitX(boss), GetUnitY(boss), cfg.扩散特效持续秒);
  播放限时点特效(cfg.风场特效路径, GetUnitX(boss), GetUnitY(boss), cfg.风场特效持续秒);
  if (刷新里科特阶段(context) < 3) ShowUnit(boss, false);

  const data: 湮灭风场 = {
    context,
    剩余跳数: cfg.持续秒 / cfg.tick秒,
    周期ID: 0,
  };
  data.周期ID = addPeriodicCallback(cfg.tick秒 * 1000, function 里科特湮灭之风周期(this: void): void {
    结算湮灭之风一跳(data);
  });
  context.清理.登记周期回调("里科特-湮灭之风周期", data.周期ID);
  const id = addDelayedCallback(cfg.持续秒 * 1000, function 里科特湮灭之风结束显形(this: void): void {
    ShowUnit(boss, true);
    removePeriodicCallback(data.周期ID);
  });
  context.清理.登记延迟回调("里科特-湮灭之风结束", id);
}

function on里科特湮灭之风施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 湮灭之风技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 里科特单位类型ID) return;
  const context = 获取或创建里科特上下文(castingUnit);
  if (context == null) return;
  释放里科特湮灭之风(context);
}

export function 注册里科特湮灭之风(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "08．湮灭之风",
    单位类型ID: 里科特单位类型ID,
    技能ID: 湮灭之风技能ID,
    获取或创建上下文: 获取或创建里科特上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 里科特运行时上下文, boss: any): void {
      on里科特湮灭之风施法(boss, 湮灭之风技能ID);
    },
  });
}
