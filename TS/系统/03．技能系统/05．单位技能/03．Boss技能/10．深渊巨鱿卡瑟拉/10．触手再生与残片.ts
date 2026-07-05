/** @noSelfInFile */

import {
  获取全部卡瑟拉上下文,
  清理卡瑟拉上下文,
  设置玩家触手残片,
  刷新卡瑟拉阶段,
  type 卡瑟拉运行时上下文,
  type 卡瑟拉地面触手残片,
} from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置 } from "./02．数值与表现配置";
import { 释放卡瑟拉深渊召唤 } from "./06．深渊召唤";
import { 尝试触发卡瑟拉触手解放 } from "./08．触手解放";
import { 尝试释放卡瑟拉共生电击 } from "./09．共生电击";
import { 单位有效, 极坐标X, 极坐标Y, 距离XY, 取坐标角度 } from "./14．公共工具";

const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { addPeriodicCallback, removePeriodicCallback, addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 卡瑟拉BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.08．卡瑟拉") as {
  卡瑟拉BuffID: { 触手精华: string };
};

interface 再生触手实例 {
  context: 卡瑟拉运行时上下文;
  触手单位: any;
  剩余跳数: number;
  周期ID: number;
}

let 已注册 = false;
let 周期ID = 0;

function 治疗Boss固定值(this: void, boss: any, amount: number): void {
  if (!单位有效(boss) || !(amount > 0)) return;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  const life = GetUnitState(boss, UNIT_STATE_LIFE);
  const next = life + amount;
  SetUnitState(boss, UNIT_STATE_LIFE, next > maxLife ? maxLife : next);
}

function 取生命十档(this: void, boss: any): number {
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return 10;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  let grade = 10;
  while (grade > 0 && ratio <= (grade - 1) * 0.1) {
    grade = grade - 1;
  }
  return grade;
}

function 选择最低生命玩家(this: void, boss: any): any {
  const heroes = 获取Boss技能敌对英雄列表(boss);
  let best: any = undefined;
  let bestRatio = 2;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const maxLife = GetUnitState(hero, UNIT_STATE_MAX_LIFE);
    if (!(maxLife > 0)) continue;
    const ratio = GetUnitState(hero, UNIT_STATE_LIFE) / maxLife;
    if (ratio < bestRatio) {
      bestRatio = ratio;
      best = hero;
    }
  }
  return best;
}

function 创建地面触手残片(this: void, context: 卡瑟拉运行时上下文, x: number, y: number): void {
  const cfg = 卡瑟拉数值与表现配置.触手残片;
  const effect = AddSpecialEffect(cfg.地面模型路径, x, y);
  context.场上触手残片列表.push({ X: x, Y: y, 特效: effect, 已吸收: false });
}

function 结算再生触手一跳(this: void, data: 再生触手实例): void {
  const context = data.context;
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(data.触手单位) || data.剩余跳数 <= 0) {
    removePeriodicCallback(data.周期ID);
    return;
  }
  data.剩余跳数 = data.剩余跳数 - 1;
  const target = 选择最低生命玩家(boss);
  if (!单位有效(target)) return;
  const cfg = 卡瑟拉数值与表现配置.触手残片;
  if (距离XY(GetUnitX(data.触手单位), GetUnitY(data.触手单位), GetUnitX(target), GetUnitY(target)) > cfg.再生触手攻击半径) return;
  const damage = 读取单位攻击力(boss) * cfg.再生触手Boss攻击力比例;
  造成单体技能伤害({
    来源: boss,
    目标: target,
    伤害: damage,
    attack: true,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "Boss技能",
  });
  治疗Boss固定值(boss, damage * cfg.再生触手吸血比例);
}

function 生成再生触手(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.Boss潜入中) return;
  const cfg = 卡瑟拉数值与表现配置.触手残片;
  const angle = 取坐标角度(0, 0, GetUnitX(boss), GetUnitY(boss));
  const x = 极坐标X(GetUnitX(boss), angle, 520);
  const y = 极坐标Y(GetUnitY(boss), angle, 520);
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "卡瑟拉-再生触手",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: "hfoo",
    模型路径: 卡瑟拉数值与表现配置.触手解放.巨型触手模型路径,
    X: x,
    Y: y,
    朝向: angle + 180,
    最大生命: cfg.再生触手生命值,
    缩放: 卡瑟拉数值与表现配置.触手鞭笞.触手缩放,
    持续时间: cfg.再生触手持续秒,
    on死亡: function 卡瑟拉再生触手死亡(this: void, unit: any): void {
      创建地面触手残片(context, GetUnitX(unit), GetUnitY(unit));
    },
  });
  if (instance == null || !单位有效(instance.单位)) return;
  const data: 再生触手实例 = {
    context,
    触手单位: instance.单位,
    剩余跳数: cfg.再生触手持续秒 / cfg.再生触手攻击间隔秒,
    周期ID: 0,
  };
  data.周期ID = addPeriodicCallback(cfg.再生触手攻击间隔秒 * 1000, function 卡瑟拉再生触手周期(this: void): void {
    结算再生触手一跳(data);
  });
  context.清理.登记周期回调("卡瑟拉-再生触手周期", data.周期ID);
}

function 处理血量再生触手(this: void, context: 卡瑟拉运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const current = 取生命十档(boss);
  if (context.阶段 < 3) {
    context.上次触手再生档位 = current;
    return;
  }
  while (context.上次触手再生档位 > current) {
    context.上次触手再生档位 = context.上次触手再生档位 - 1;
    生成再生触手(context);
  }
}

function 移动单个地面残片(this: void, context: 卡瑟拉运行时上下文, fragment: 卡瑟拉地面触手残片): boolean {
  if (fragment.已吸收) return false;
  const boss = context.Boss单位;
  const cfg = 卡瑟拉数值与表现配置.触手残片;
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);
  const dist = 距离XY(fragment.X, fragment.Y, bx, by);
  if (dist <= cfg.吸引距离) {
    fragment.已吸收 = true;
    if (fragment.特效 != null) DestroyEffect(fragment.特效);
    return true;
  }
  const angle = 取坐标角度(fragment.X, fragment.Y, bx, by);
  if (fragment.特效 != null) DestroyEffect(fragment.特效);
  fragment.X = 极坐标X(fragment.X, angle, cfg.吸引距离);
  fragment.Y = 极坐标Y(fragment.Y, angle, cfg.吸引距离);
  fragment.特效 = AddSpecialEffect(cfg.地面模型路径, fragment.X, fragment.Y);
  return false;
}

function 牵引地面触手残片(this: void, context: 卡瑟拉运行时上下文, nowMs: number): number {
  const cfg = 卡瑟拉数值与表现配置.触手残片;
  if (context.下次残片牵引时间 <= 0) context.下次残片牵引时间 = nowMs + cfg.吸引间隔秒 * 1000;
  if (nowMs < context.下次残片牵引时间) return 0;
  context.下次残片牵引时间 = nowMs + cfg.吸引间隔秒 * 1000;
  let absorbed = 0;
  let index = 0;
  while (index < context.场上触手残片列表.length) {
    const fragment = context.场上触手残片列表[index];
    if (移动单个地面残片(context, fragment)) {
      context.场上触手残片列表.splice(index, 1);
      absorbed = absorbed + 1;
      continue;
    }
    index = index + 1;
  }
  return absorbed;
}

function 吸收玩家触手残片(this: void, context: 卡瑟拉运行时上下文): number {
  let count = 0;
  for (const key in context.玩家触手残片表) {
    const current = context.玩家触手残片表[key] ?? 0;
    if (current <= 0 || current >= 4) continue;
    const unit = context.玩家触手残片单位表[key];
    if (unit == null || unit === 0) continue;
    count = count + current;
    设置玩家触手残片(context, unit, 0);
  }
  return count;
}

function 应用触手精华(this: void, context: 卡瑟拉运行时上下文, count: number): void {
  if (count <= 0) return;
  const boss = context.Boss单位;
  const cfg = 卡瑟拉数值与表现配置.触手残片;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  治疗Boss固定值(boss, maxLife * cfg.Boss每片回血比例 * count);
  context.触手精华层数 = context.触手精华层数 + count;
  const attackBonus = 读取单位攻击力(boss) * cfg.精华每层攻击加成 * count;
  if (attackBonus > 0) {
    临时调整攻击(boss, attackBonus);
    const id = addDelayedCallback(cfg.精华持续秒 * 1000, function 卡瑟拉触手精华攻击回滚(this: void): void {
      if (!单位有效(boss)) return;
      临时调整攻击(boss, -attackBonus);
      context.触手精华层数 = context.触手精华层数 - count;
      if (context.触手精华层数 > 0) {
        registerManualBuff(boss, 卡瑟拉BuffID.触手精华, cfg.精华持续秒, context.触手精华层数, {
          stack: context.触手精华层数,
          sourceName: "卡瑟拉-触手精华",
        });
      } else {
        context.触手精华层数 = 0;
        移除单位指定Buff(boss, 卡瑟拉BuffID.触手精华);
      }
    });
    context.清理.登记延迟回调("卡瑟拉-触手精华攻击回滚", id);
  }
  registerManualBuff(boss, 卡瑟拉BuffID.触手精华, cfg.精华持续秒, context.触手精华层数, {
    stack: context.触手精华层数,
    sourceName: "卡瑟拉-触手精华",
  });
}

function 处理残片吸收(this: void, context: 卡瑟拉运行时上下文, nowMs: number): void {
  const cfg = 卡瑟拉数值与表现配置.触手残片;
  const groundAbsorbed = 牵引地面触手残片(context, nowMs);
  if (groundAbsorbed > 0) 应用触手精华(context, groundAbsorbed);
  if (context.下次残片吸收时间 <= 0) context.下次残片吸收时间 = nowMs + cfg.Boss吸收间隔秒 * 1000;
  if (nowMs < context.下次残片吸收时间) return;
  context.下次残片吸收时间 = nowMs + cfg.Boss吸收间隔秒 * 1000;
  应用触手精华(context, 吸收玩家触手残片(context));
}

function 处理深渊召唤(this: void, context: 卡瑟拉运行时上下文, nowMs: number): void {
  if (context.阶段 < 2 || context.Boss潜入中) return;
  const cfg = 卡瑟拉数值与表现配置.深渊召唤;
  if (context.下次深渊召唤时间 <= 0) context.下次深渊召唤时间 = nowMs;
  if (nowMs < context.下次深渊召唤时间) return;
  context.下次深渊召唤时间 = nowMs + cfg.触发间隔秒 * 1000;
  释放卡瑟拉深渊召唤(context);
}

function on卡瑟拉运行时周期(this: void): void {
  const now = getServerTime();
  const contexts = 获取全部卡瑟拉上下文();
  for (let i = 0; i < contexts.length; i++) {
    const context = contexts[i];
    if (!单位有效(context.Boss单位)) {
      清理卡瑟拉上下文(context.Boss单位);
      continue;
    }
    刷新卡瑟拉阶段(context);
    处理深渊召唤(context, now);
    尝试触发卡瑟拉触手解放(context);
    处理血量再生触手(context);
    尝试释放卡瑟拉共生电击(context, now);
    处理残片吸收(context, now);
  }
}

export function 注册卡瑟拉触手再生与残片(this: void): void {
  if (已注册) return;
  已注册 = true;
  周期ID = addPeriodicCallback(1000, on卡瑟拉运行时周期);
}
