/** @noSelfInFile */

const { 计算组合技能伤害 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害") as {
  计算组合技能伤害: (this: void, 来源: any, 目标: any, 参数: any) => number;
};

import type { 巴尔扎罗斯运行时上下文 } from "./03．运行时上下文";
import { 获取或创建巴尔扎罗斯上下文 } from "./03．运行时上下文";
import { 巴尔扎罗斯单位技能配置 } from "./00．配置";
import { 巴尔扎罗斯技能数值配置, 巴尔扎罗斯音效配置 } from "./02．数值与表现配置";
import { 播放巴尔扎罗斯台词 } from "./14．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { stringToFourCC, 单位未标记死亡 as 单位有效, 单位间距离平方 as 距离平方 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.index") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 创建持续单位连线 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.07．机制连线.index") as {
  创建持续单位连线: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表, 获取Boss技能随机敌对英雄 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};

const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitX = jass.SetUnitX as (unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (unit: any, y: number) => void;
const Player = jass.Player as (id: number) => any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;

const 巴尔扎罗斯单位类型ID = stringToFourCC(巴尔扎罗斯单位技能配置.单位ID);
const 火焰锁链技能ID = stringToFourCC(巴尔扎罗斯技能数值配置.火焰锁链.技能槽位);
let 火焰锁链已注册 = false;

interface 火焰锁链状态 {
  context: 巴尔扎罗斯运行时上下文;
  target: any;
  chainUnit: any;
  line: any;
  tickId: number;
  lastDamageMs: number;
  stopped: boolean;
}

function 选择火焰锁链目标(this: void, boss: any): any {
  const config = 巴尔扎罗斯技能数值配置.火焰锁链;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  let farthest: any = undefined;
  let farthestDistance2 = -1;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const distance2 = 距离平方(boss, hero);
    if (distance2 > farthestDistance2) {
      farthest = hero;
      farthestDistance2 = distance2;
    }
  }
  if (farthest != null && farthestDistance2 >= config.最远目标最低距离 * config.最远目标最低距离) return farthest;
  return 获取Boss技能随机敌对英雄(boss);
}

function 计算超距伤害(this: void, boss: any, target: any): number {
  const config = 巴尔扎罗斯技能数值配置.火焰锁链;
  return 计算组合技能伤害(boss, target, {
    来源攻击力比例: config.超距伤害Boss攻击力比例,
    目标最大生命比例: config.超距伤害目标最大生命比例,
    总倍率: config.超距伤害总倍率,
  });
}

function 更新锁链单位位置(this: void, state: 火焰锁链状态): void {
  const boss = state.context.Boss单位;
  const target = state.target;
  const chainUnit = state.chainUnit;
  if (!单位有效(boss) || !单位有效(target) || !单位有效(chainUnit)) return;
  SetUnitX(chainUnit, (GetUnitX(boss) + GetUnitX(target)) * 0.5);
  SetUnitY(chainUnit, (GetUnitY(boss) + GetUnitY(target)) * 0.5);
}

function 停止火焰锁链(this: void, state: 火焰锁链状态, removeBuff: boolean): void {
  if (state.stopped) return;
  state.stopped = true;
  if (state.tickId !== 0) {
    removePeriodicCallback(state.tickId);
    state.tickId = 0;
  }
  if (state.line != null) state.line.停止("火焰锁链结束");
  if (removeBuff) 移除单位指定Buff(state.target, 巴尔扎罗斯单位技能配置.BuffID.火焰锁链);
}

function on火焰锁链Buff移除(this: void, unit: any, _buffID: string, row: any): void {
  const state = row != null ? (row.chainState as 火焰锁链状态 | undefined) : undefined;
  if (state != null) 停止火焰锁链(state, false);
}

function on火焰锁链Tick(this: void, state: 火焰锁链状态): void {
  if (state.stopped) return;
  const boss = state.context.Boss单位;
  const target = state.target;
  const chainUnit = state.chainUnit;
  if (!单位有效(boss) || !单位有效(target) || !单位有效(chainUnit)) {
    停止火焰锁链(state, true);
    return;
  }
  更新锁链单位位置(state);
  const config = 巴尔扎罗斯技能数值配置.火焰锁链;
  if (距离平方(boss, target) <= config.断链距离 * config.断链距离) return;
  const now = getServerTime();
  if (state.lastDamageMs > 0 && now - state.lastDamageMs < config.超距Tick秒 * 1000) return;
  state.lastDamageMs = now;
  造成单体技能伤害({
    技能ID: 火焰锁链技能ID,
    来源: boss,
    目标: target,
    伤害: 计算超距伤害(boss, target),
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_CHAOS,
    伤害类型: DAMAGE_TYPE_FIRE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "Boss技能",
  });
}

function 创建火焰锁链(this: void, context: 巴尔扎罗斯运行时上下文, target: any): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target)) return;
  const config = 巴尔扎罗斯技能数值配置.火焰锁链;
  const centerX = (GetUnitX(boss) + GetUnitX(target)) * 0.5;
  const centerY = (GetUnitY(boss) + GetUnitY(target)) * 0.5;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  const state: 火焰锁链状态 = {
    context,
    target,
    chainUnit: undefined,
    line: undefined,
    tickId: 0,
    lastDamageMs: 0,
    stopped: false,
  };
  const chain = 创建可攻击机制单位({
    清理: context.清理,
    名称: "巴尔扎罗斯-火焰锁链单位",
    主人单位: boss,
    所属玩家: Player(PLAYER_NEUTRAL_AGGRESSIVE),
    单位类型: config.锁链单位ID,
    X: centerX,
    Y: centerY,
    最大生命: maxLife * config.锁链单位生命Boss最大生命比例,
    生命值受小怪倍率: false,
    飞行高度: config.锁链单位飞行高度,
    缩放: config.锁链单位缩放,
    on死亡: function 巴尔扎罗斯火焰锁链单位死亡(this: void): void {
      停止火焰锁链(state, true);
    },
  });
  if (chain == null || !单位有效(chain.单位)) return;
  state.chainUnit = chain.单位;
  播放Boss坐标音效(巴尔扎罗斯音效配置.火焰锁链.锁定生成, centerX, centerY, 巴尔扎罗斯音效配置.默认裁断距离);
  state.line = 创建持续单位连线({
    清理: context.清理,
    名称: "巴尔扎罗斯-火焰锁链闪电",
    起点单位: boss,
    终点单位: target,
    闪电代码: config.闪电代码,
    持续秒: config.持续秒,
    起点高度: config.闪电起点高度,
    终点高度: config.闪电终点高度,
    Tick间隔毫秒: config.锁链Tick毫秒,
    on断开: function 巴尔扎罗斯火焰锁链断开(this: void): void {
      停止火焰锁链(state, true);
    },
  });
  state.tickId = addPeriodicCallback(config.锁链Tick毫秒, function 巴尔扎罗斯火焰锁链Tick(this: void): void {
    on火焰锁链Tick(state);
  });
  context.清理.登记周期回调("巴尔扎罗斯-火焰锁链Tick", state.tickId);
  registerManualBuff(target, 巴尔扎罗斯单位技能配置.BuffID.火焰锁链, config.持续秒, 0, {
    sourceName: "巴尔扎罗斯",
    chainState: state,
    onRemove: on火焰锁链Buff移除,
  });
}

export function 释放巴尔扎罗斯火焰锁链(this: void, context: 巴尔扎罗斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 选择火焰锁链目标(boss);
  if (!单位有效(target)) return;
  const config = 巴尔扎罗斯技能数值配置.火焰锁链;
  创建技能提示圈({
    类型: "渐变圆形",
    X: GetUnitX(target),
    Y: GetUnitY(target),
    半径: config.锁定提示半径,
    持续时间: config.施法硬直秒,
    来源单位: boss,
  });
  启动基础施法时间线({
    施法者: boss,
    目标单位: target,
    硬直秒: config.施法硬直秒,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: config.施法硬直秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 巴尔扎罗斯火焰锁链台词(this: void): void {
      播放巴尔扎罗斯台词(boss, "火焰锁链");
    },
    on生效: function 巴尔扎罗斯火焰锁链生效(this: void): void {
      创建火焰锁链(context, target);
    },
  });
}

export function 注册巴尔扎罗斯火焰锁链(this: void): void {
  if (火焰锁链已注册) return;
  火焰锁链已注册 = true;
  注册单位技能壳监听({
    名称: "巴尔扎罗斯火焰锁链",
    单位类型ID: 巴尔扎罗斯单位类型ID,
    技能ID: 火焰锁链技能ID,
    获取或创建上下文: 获取或创建巴尔扎罗斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 巴尔扎罗斯运行时上下文, boss: any): void {
      on巴尔扎罗斯火焰锁链生效(boss, 火焰锁链技能ID);
    },
  });
}

function on巴尔扎罗斯火焰锁链生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 火焰锁链技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 巴尔扎罗斯单位类型ID) return;
  const context = 获取或创建巴尔扎罗斯上下文(castingUnit);
  if (context == null) return;
  释放巴尔扎罗斯火焰锁链(context);
}

export {};
