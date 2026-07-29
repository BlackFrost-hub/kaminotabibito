/** @noSelfInFile */

import {
  获取全部卡瑟拉上下文,
  清理卡瑟拉上下文,
  设置玩家触手残片,
  type 卡瑟拉运行时上下文,
  type 卡瑟拉地面触手残片,
} from "./01．运行时上下文";
import { 卡瑟拉数值与表现配置 } from "./02．数值与表现配置";
import { 释放卡瑟拉深渊召唤 } from "./06．深渊召唤";
import { 释放卡瑟拉共生电击 } from "./09．共生电击";
import { 单位有效, 极坐标X, 极坐标Y, 距离XY, 取坐标角度 } from "./14．公共工具";
import { 创建周期机制调度器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器';
import { 创建战斗技能调度器 } from '../../../../00．技能模板+函数/00．技能模板/13．战斗技能调度模板/01．战斗技能调度模板';
import { 创建血量节点触发器 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/01．血量节点触发器';
import { 取单位ID } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
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
const { 卡瑟拉BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.02．卡瑟拉") as {
  卡瑟拉BuffID: { 触手精华: string };
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};

interface 再生触手实例 {
  context: 卡瑟拉运行时上下文;
  触手单位: any;
  剩余跳数: number;
  周期ID: number;
}

let 已注册 = false;

function 治疗Boss固定值(this: void, boss: any, amount: number): void {
  if (!单位有效(boss) || !(amount > 0)) return;
  doHeal({ HealSource: boss, HealTarget: boss, HealAmount: amount, ItemHeal: false, HealEffect: false });
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

function 确保触手再生血量节点(this: void, context: 卡瑟拉运行时上下文): void {
  if (context.触手再生节点已注册) return;
  context.触手再生节点已注册 = true;
  const 节点列表: Array<{ ID: string; 百分比: number; on触发: (this: void, unit: any, 当前百分比: number) => void }> = [];
  for (let 档位 = 5; 档位 >= 1; 档位--) {
    节点列表.push({
      ID: "触手再生-" + 档位 + "0%",
      百分比: 档位 * 0.1,
      on触发: function 卡瑟拉触手再生节点触发(this: void): void {
        生成再生触手(context);
      },
    });
  }
  创建血量节点触发器({
    清理: context.清理,
    名称: "卡瑟拉-触手再生节点",
    单位: context.Boss单位,
    节点列表,
    Tick间隔毫秒: 卡瑟拉数值与表现配置.运行时.推进间隔毫秒,
  });
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

function 牵引地面触手残片(this: void, context: 卡瑟拉运行时上下文): number {
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

function 处理地面残片牵引(this: void, context: 卡瑟拉运行时上下文): void {
  const groundAbsorbed = 牵引地面触手残片(context);
  if (groundAbsorbed > 0) 应用触手精华(context, groundAbsorbed);
}

function 处理玩家残片吸收(this: void, context: 卡瑟拉运行时上下文): void {
  应用触手精华(context, 吸收玩家触手残片(context));
}

function 取卡瑟拉上下文键(this: void, context: 卡瑟拉运行时上下文): number {
  return 取单位ID(context.Boss单位);
}

function 可调度卡瑟拉深渊召唤(this: void, context: 卡瑟拉运行时上下文): boolean {
  return 单位有效(context.Boss单位) && context.阶段 >= 2 && !context.Boss潜入中;
}

function 执行卡瑟拉深渊召唤(this: void, context: 卡瑟拉运行时上下文): boolean {
  释放卡瑟拉深渊召唤(context);
  return true;
}

function 可调度卡瑟拉共生电击(this: void, context: 卡瑟拉运行时上下文): boolean {
  return 单位有效(context.Boss单位) && context.阶段 >= 3 && !context.Boss潜入中;
}

function on卡瑟拉运行时维护(this: void, context: 卡瑟拉运行时上下文): void {
  if (!单位有效(context.Boss单位)) {
    清理卡瑟拉上下文(context.Boss单位);
    return;
  }
  确保触手再生血量节点(context);
}

export function 注册卡瑟拉触手再生与残片(this: void): void {
  if (已注册) return;
  已注册 = true;
  创建周期机制调度器({
    名称: '卡瑟拉-运行时维护',
    间隔毫秒: 卡瑟拉数值与表现配置.运行时.推进间隔毫秒,
    取上下文列表: 获取全部卡瑟拉上下文,
    执行: on卡瑟拉运行时维护,
  });
  创建周期机制调度器({
    名称: '卡瑟拉-地面残片牵引',
    间隔毫秒: 卡瑟拉数值与表现配置.触手残片.吸引间隔秒 * 1000,
    取上下文列表: 获取全部卡瑟拉上下文,
    可执行: function 卡瑟拉地面残片牵引可执行(this: void, context: 卡瑟拉运行时上下文): boolean {
      return 单位有效(context.Boss单位) && context.场上触手残片列表.length > 0;
    },
    执行: 处理地面残片牵引,
  });
  创建周期机制调度器({
    名称: '卡瑟拉-玩家残片吸收',
    间隔毫秒: 卡瑟拉数值与表现配置.触手残片.Boss吸收间隔秒 * 1000,
    取上下文列表: 获取全部卡瑟拉上下文,
    可执行: function 卡瑟拉玩家残片吸收可执行(this: void, context: 卡瑟拉运行时上下文): boolean {
      return 单位有效(context.Boss单位) && !context.Boss潜入中;
    },
    执行: 处理玩家残片吸收,
  });
  创建战斗技能调度器<卡瑟拉运行时上下文>({
    名称: '卡瑟拉-深渊召唤调度',
    间隔毫秒: 卡瑟拉数值与表现配置.运行时.推进间隔毫秒,
    取当前时间: getServerTime,
    取上下文列表: 获取全部卡瑟拉上下文,
    取上下文键: 取卡瑟拉上下文键,
    可调度: 可调度卡瑟拉深渊召唤,
    技能列表: [{
      key: '深渊召唤',
      冷却毫秒: 卡瑟拉数值与表现配置.深渊召唤.触发间隔秒 * 1000,
      首次延迟毫秒: 0,
      执行: 执行卡瑟拉深渊召唤,
    }],
  });
  创建战斗技能调度器<卡瑟拉运行时上下文>({
    名称: '卡瑟拉-共生电击调度',
    间隔毫秒: 卡瑟拉数值与表现配置.运行时.推进间隔毫秒,
    取当前时间: getServerTime,
    取上下文列表: 获取全部卡瑟拉上下文,
    取上下文键: 取卡瑟拉上下文键,
    可调度: 可调度卡瑟拉共生电击,
    技能列表: [{
      key: '共生电击',
      冷却毫秒: 卡瑟拉数值与表现配置.共生电击.间隔秒 * 1000,
      首次延迟毫秒: 卡瑟拉数值与表现配置.共生电击.间隔秒 * 1000,
      执行: 释放卡瑟拉共生电击,
    }],
  });
}
