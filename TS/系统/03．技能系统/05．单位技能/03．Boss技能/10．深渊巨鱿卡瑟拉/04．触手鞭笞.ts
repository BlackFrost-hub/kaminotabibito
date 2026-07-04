/** @noSelfInFile */

import { 卡瑟拉单位技能配置 } from "./00．配置";
import { 获取或创建卡瑟拉上下文, 增加玩家触手残片, 取玩家触手残片, type 卡瑟拉运行时上下文 } from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置 } from "./02．数值与表现配置";
import { 播放卡瑟拉台词 } from "./11．台词播放";
import { 单位有效, stringToFourCC, 极坐标X, 极坐标Y } from "./14．公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomReal = jass.GetRandomReal as (lowBound: number, highBound: number) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
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
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 卡瑟拉BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.08．卡瑟拉") as {
  卡瑟拉BuffID: { 触手缠绕: string };
};
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number) => void;
};

interface 触手鞭笞实例 {
  context: 卡瑟拉运行时上下文;
  触手单位: any;
  目标: any;
  剩余跳数: number;
  周期ID: number;
}

const 卡瑟拉单位类型ID = stringToFourCC(卡瑟拉单位技能配置.单位ID);
const 触手鞭笞技能ID = stringToFourCC(卡瑟拉数值与表现配置.触手鞭笞.技能槽位);
let 已注册 = false;

function 选择触手鞭笞目标(this: void, context: 卡瑟拉运行时上下文): any {
  const boss = context.Boss单位;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  let best: any = undefined;
  let bestScore = -1;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const score = 取玩家触手残片(context, hero) * 10 + GetRandomReal(0, 10);
    if (score > bestScore) {
      bestScore = score;
      best = hero;
    }
  }
  return 单位有效(best) ? best : 获取Boss技能随机敌对英雄(boss, boss, 2000);
}

function 掉落触手残片给击杀者(this: void, context: 卡瑟拉运行时上下文, killer: any): void {
  if (!单位有效(killer)) return;
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  if (GetRandomReal(0, 1) > cfg.触手残片掉落概率) return;
  const next = 增加玩家触手残片(context, killer, 1);
  if (next > 卡瑟拉数值与表现配置.触手残片.大于数量时恢复已损生命) {
    const maxLife = GetUnitState(killer, UNIT_STATE_MAX_LIFE);
    const life = GetUnitState(killer, UNIT_STATE_LIFE);
    const heal = (maxLife - life) * 卡瑟拉数值与表现配置.触手残片.已损生命恢复比例;
    if (heal > 0) SetUnitState(killer, UNIT_STATE_LIFE, life + heal > maxLife ? maxLife : life + heal);
  }
}

function 触手鞭笞一跳(this: void, data: 触手鞭笞实例): void {
  const context = data.context;
  const boss = context.Boss单位;
  const target = data.目标;
  if (!单位有效(boss) || !单位有效(data.触手单位) || !单位有效(target) || data.剩余跳数 <= 0) {
    removePeriodicCallback(data.周期ID);
    return;
  }
  data.剩余跳数 = data.剩余跳数 - 1;
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  const dx = GetUnitX(target) - GetUnitX(data.触手单位);
  const dy = GetUnitY(target) - GetUnitY(data.触手单位);
  if (dx * dx + dy * dy > cfg.触手攻击半径 * cfg.触手攻击半径) return;
  UnitDamageTarget(boss, target, 读取单位攻击力(boss) * cfg.触手Boss攻击力比例, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
  施加快速减速Buff(boss, target, cfg.缠绕减速比例, cfg.缠绕减速比例, cfg.缠绕持续秒);
  registerManualBuff(target, 卡瑟拉BuffID.触手缠绕, cfg.缠绕持续秒, cfg.缠绕减速比例, {
    sourceName: "卡瑟拉-触手缠绕",
  });
}

function 创建单条触手(this: void, context: 卡瑟拉运行时上下文, target: any, x: number, y: number): void {
  const boss = context.Boss单位;
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "卡瑟拉-鞭笞触手",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: "hfoo",
    模型路径: cfg.触手模型路径,
    X: x,
    Y: y,
    朝向: 0,
    最大生命: cfg.触手生命值,
    缩放: cfg.触手缩放,
    持续时间: cfg.触手持续秒,
    on死亡: function 卡瑟拉鞭笞触手死亡(this: void, _unit: any, killer: any): void {
      掉落触手残片给击杀者(context, killer);
    },
  });
  if (instance == null || !单位有效(instance.单位)) return;
  const data: 触手鞭笞实例 = {
    context,
    触手单位: instance.单位,
    目标: target,
    剩余跳数: cfg.触手持续秒 / cfg.触手攻击间隔秒,
    周期ID: 0,
  };
  data.周期ID = addPeriodicCallback(cfg.触手攻击间隔秒 * 1000, function 卡瑟拉触手鞭笞周期(this: void): void {
    触手鞭笞一跳(data);
  });
  context.清理.登记周期回调("卡瑟拉-触手鞭笞周期", data.周期ID);
}

function 释放触手围攻(this: void, context: 卡瑟拉运行时上下文, target: any): void {
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  const cx = GetUnitX(target);
  const cy = GetUnitY(target);
  for (let i = 0; i < cfg.触手数量; i++) {
    const angle = i * 120;
    创建单条触手(context, target, 极坐标X(cx, angle, cfg.触手半径), 极坐标Y(cy, angle, cfg.触手半径));
  }
}

export function 释放卡瑟拉触手鞭笞(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 选择触手鞭笞目标(context);
  if (!单位有效(target)) return;
  const cfg = 卡瑟拉数值与表现配置.触手鞭笞;
  播放卡瑟拉台词(boss, "触手鞭笞");
  创建技能提示圈({
    类型: "圆形",
    X: GetUnitX(target),
    Y: GetUnitY(target),
    半径: cfg.触手半径 + 120,
    持续时间: cfg.延迟秒,
    来源单位: boss,
  });
  const id = addDelayedCallback(cfg.延迟秒 * 1000, function 卡瑟拉触手鞭笞延迟围攻(this: void): void {
    if (单位有效(target)) 释放触手围攻(context, target);
  });
  context.清理.登记延迟回调("卡瑟拉-触手鞭笞围攻", id);
}

function on卡瑟拉触手鞭笞施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 触手鞭笞技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 卡瑟拉单位类型ID) return;
  const context = 获取或创建卡瑟拉上下文(castingUnit);
  if (context == null) return;
  释放卡瑟拉触手鞭笞(context);
}

export function 注册卡瑟拉触手鞭笞(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "04．触手鞭笞",
    单位类型ID: 卡瑟拉单位类型ID,
    技能ID: 触手鞭笞技能ID,
    获取或创建上下文: 获取或创建卡瑟拉上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 卡瑟拉运行时上下文, boss: any): void {
      on卡瑟拉触手鞭笞施法(boss, 触手鞭笞技能ID);
    },
  });
}
