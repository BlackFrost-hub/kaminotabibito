/** @noSelfInFile */

import { 增加玩家腐败值, 清除玩家腐败值, 取腐败值最高玩家, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置 } from "./02．数值与表现配置";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, 极坐标X, 极坐标Y } from "./16．公共工具";

const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const KillUnit = jass.KillUnit as (unit: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建战斗内拾取物 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.06．战斗内拾取物") as {
  创建战斗内拾取物: (this: void, 参数: any) => any;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 莫尔特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.09．莫尔特斯") as {
  莫尔特斯BuffID: { 腐败虫尸净化: string };
};
const { 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  临时调整攻击: (this: void, unit: any, value: number) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

interface 甲虫追击实例 {
  context: 莫尔特斯运行时上下文;
  甲虫单位: any;
  接触目标: any;
  接触Ticks: number;
  周期ID: number;
}

interface 莫尔特斯虫尸变量 {
  context: 莫尔特斯运行时上下文;
}

interface 莫尔特斯甲虫死亡变量 {
  context: 莫尔特斯运行时上下文;
}

function 取甲虫目标(this: void, context: 莫尔特斯运行时上下文): any {
  const target = 取腐败值最高玩家(context);
  if (单位有效(target)) return target;
  return 获取Boss技能随机敌对英雄(context.Boss单位);
}

function 莫尔特斯虫尸可拾取单位(this: void, variable?: any): any[] {
  const data = variable as 莫尔特斯虫尸变量 | undefined;
  if (data == null) return [];
  return 获取Boss技能敌对英雄列表(data.context.Boss单位);
}

function 莫尔特斯虫尸拾取(this: void, picker: any, _实例: any, variable?: any): void {
  const data = variable as 莫尔特斯虫尸变量 | undefined;
  if (data == null) return;
  const amount = 莫尔特斯数值与表现配置.腐败值.虫尸清除值;
  清除玩家腐败值(data.context, picker, amount);
  registerManualBuff(picker, 莫尔特斯BuffID.腐败虫尸净化, 3, amount, {
    sourceName: "莫尔特斯-腐败虫尸",
  });
}

function 创建虫尸拾取物(this: void, context: 莫尔特斯运行时上下文, x: number, y: number): void {
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  创建战斗内拾取物({
    清理: context.清理,
    名称: "莫尔特斯-腐败虫尸",
    X: x,
    Y: y,
    模型路径: cfg.虫尸模型路径,
    缩放: 0.55,
    持续秒: cfg.虫尸持续秒,
    拾取半径: cfg.虫尸拾取半径,
    变量: { context } as 莫尔特斯虫尸变量,
    可拾取单位列表: 莫尔特斯虫尸可拾取单位,
    on拾取: 莫尔特斯虫尸拾取,
  });
}

function 爆炸甲虫(this: void, data: 甲虫追击实例): void {
  const boss = data.context.Boss单位;
  const target = data.接触目标;
  if (!单位有效(boss) || !单位有效(target)) return;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  造成AOE技能伤害({
    来源: boss,
    目标: target,
    伤害: 读取单位攻击力(boss) * cfg.爆炸伤害Boss攻击力比例,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_PLANT,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "Boss技能",
  });
  增加玩家腐败值(data.context, target, cfg.爆炸腐败值);
}

function 甲虫追击Tick(this: void, data: 甲虫追击实例): void {
  const beetle = data.甲虫单位;
  if (!单位有效(beetle) || !单位有效(data.context.Boss单位)) {
    removePeriodicCallback(data.周期ID);
    return;
  }
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  const target = 取甲虫目标(data.context);
  if (!单位有效(target)) return;
  IssueTargetOrder(beetle, "attack", target);
  const dx = GetUnitX(beetle) - GetUnitX(target);
  const dy = GetUnitY(beetle) - GetUnitY(target);
  if (dx * dx + dy * dy <= cfg.接触半径 * cfg.接触半径) {
    if (data.接触目标 === target) data.接触Ticks = data.接触Ticks + 1;
    else {
      data.接触目标 = target;
      data.接触Ticks = 1;
    }
    if (data.接触Ticks >= cfg.接触爆炸秒) {
      爆炸甲虫(data);
      KillUnit(beetle);
      removePeriodicCallback(data.周期ID);
    }
  } else {
    data.接触目标 = null;
    data.接触Ticks = 0;
  }
}

function 莫尔特斯甲虫追击周期(this: void, variable?: any): void {
  const data = variable as 甲虫追击实例 | undefined;
  if (data == null) return;
  甲虫追击Tick(data);
}

function 莫尔特斯甲虫死亡(this: void, unit: any, _击杀者: any, variable?: any): void {
  const data = variable as 莫尔特斯甲虫死亡变量 | undefined;
  if (data == null) return;
  创建虫尸拾取物(data.context, GetUnitX(unit), GetUnitY(unit));
}

function 创建腐化甲虫(this: void, context: 莫尔特斯运行时上下文, angle: number): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  const x = 极坐标X(GetUnitX(boss), angle, 360);
  const y = 极坐标Y(GetUnitY(boss), angle, 360);
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "莫尔特斯-腐化甲虫",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.甲虫单位类型,
    模型路径: cfg.甲虫模型路径,
    X: x,
    Y: y,
    朝向: angle,
    最大生命: cfg.甲虫生命值,
    缩放: cfg.甲虫缩放,
    变量: { context } as 莫尔特斯甲虫死亡变量,
    on死亡: 莫尔特斯甲虫死亡,
  });
  if (instance == null || !单位有效(instance.单位)) return;
  临时调整攻击(instance.单位, cfg.甲虫攻击力);
  const data: 甲虫追击实例 = { context, 甲虫单位: instance.单位, 接触目标: null, 接触Ticks: 0, 周期ID: 0 };
  data.周期ID = addPeriodicCallback(1000, 莫尔特斯甲虫追击周期, data);
  context.清理.登记周期回调("莫尔特斯-甲虫追击", data.周期ID);
}

export function 尝试释放莫尔特斯共生腐朽虫群(this: void, context: 莫尔特斯运行时上下文, nowMs: number): void {
  if (context.阶段 < 2 || !单位有效(context.Boss单位)) return;
  const cfg = 莫尔特斯数值与表现配置.共生腐朽虫群;
  if (context.下次虫群时间 <= 0) context.下次虫群时间 = nowMs + cfg.触发间隔秒 * 1000;
  if (nowMs < context.下次虫群时间) return;
  context.下次虫群时间 = nowMs + cfg.触发间隔秒 * 1000;
  播放莫尔特斯台词(context.Boss单位, "腐败之种");
  for (let i = 0; i < cfg.甲虫数量; i++) {
    创建腐化甲虫(context, i * 90);
  }
}

export function 注册莫尔特斯共生腐朽虫群(this: void): void {
}
