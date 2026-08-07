/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/00．类型";
import { 黑暗残响配置 } from "./00．配置";
import {
  单位处于硬控制,
  取两点方向角,
  取单位X,
  取单位Y,
  取最近单位,
  取最近玩家英雄,
  读取单位攻击力,
  读取单位最大生命,
  读取封印守卫战敌人记录,
  读取封印守卫战核心,
  读取正在修复封印锚点的英雄列表,
  命令攻击目标,
  封印守卫战单位存活,
  创建封印守卫战点特效,
} from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/01．共享";

const jass = require("jass.common") as any;
const { 开始充能, 停止单位充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, unit: any, params: any) => number;
  停止单位充能: (this: void, unit: any) => boolean;
};
const { 创建原生弹幕, 销毁原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index") as {
  创建原生弹幕: (this: void, params: any) => { 弹幕ID: number } | null;
  销毁原生弹幕: (this: void, barrageId: number, reason?: string) => boolean;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 施加快速减速Buff, 清除单位指定Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number, sourceName?: string, sourceType?: string, displayBuffID?: string) => void;
  清除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 封印守卫战BuffID } = require("系统.05．Buff系统.03．Buff表.04．单位.01．封印守卫战") as {
  封印守卫战BuffID: { 缚魂减速: string; 暗影侵蚀减速: string };
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;

interface 暗影弹上下文 {
  来源: any;
  目标: any;
}

const 暗影弹上下文表: Record<number, 暗影弹上下文 | undefined> = {};
const 活动暗影弹ID列表: number[] = [];

function 选择黑暗残响玩家目标(this: void, record: 封印守卫战敌人记录): any {
  const repairing = 读取正在修复封印锚点的英雄列表();
  const repairTarget = 取最近单位(record.单位, repairing, 黑暗残响配置.索敌范围);
  if (封印守卫战单位存活(repairTarget)) return repairTarget;
  return 取最近玩家英雄(record.单位, 黑暗残响配置.索敌范围);
}

function 筛选黑暗残响暗影弹目标(this: void, unit: any, barrageId: number): boolean {
  const context = 暗影弹上下文表[barrageId];
  return context != null && context.目标 === unit && 封印守卫战单位存活(unit);
}

function on黑暗残响暗影弹命中(this: void, target: any, barrageId: number): void {
  const context = 暗影弹上下文表[barrageId];
  if (context == null || context.目标 !== target || !封印守卫战单位存活(context.来源) || !封印守卫战单位存活(target)) return;
  const damage = 读取单位攻击力(context.来源) * 黑暗残响配置.攻击力伤害比例
    + 读取单位最大生命(target) * 黑暗残响配置.目标最大生命伤害比例;
  造成单体技能伤害({
    来源: context.来源,
    目标: target,
    伤害: damage,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    来源类型: "单位技能",
    标签: "封印守卫战-黑暗残响暗影索敌",
    参与技能伤害加成: false,
  });
  清除单位指定Buff(target, 封印守卫战BuffID.缚魂减速);
  施加快速减速Buff(
    context.来源,
    target,
    0,
    黑暗残响配置.减速比例,
    黑暗残响配置.减速持续秒,
    "封印守卫战-黑暗残响暗影索敌",
    "技能",
    封印守卫战BuffID.暗影侵蚀减速,
  );
  创建封印守卫战点特效({
    模型路径: 黑暗残响配置.命中特效,
    X: 取单位X(target),
    Y: 取单位Y(target),
    Z: 0,
    缩放: 0.7,
    持续秒: 2,
  });
}

function on黑暗残响暗影弹结束(this: void, _reason: string, barrageId: number): void {
  delete 暗影弹上下文表[barrageId];
  const index = 活动暗影弹ID列表.indexOf(barrageId);
  if (index >= 0) 活动暗影弹ID列表.splice(index, 1);
}

function 发射黑暗残响暗影弹(this: void, source: any, target: any): boolean {
  if (!封印守卫战单位存活(source) || !封印守卫战单位存活(target)) return false;
  const barrage = 创建原生弹幕({
    所有者: source,
    载体模式: "特效",
    X: 取单位X(source),
    Y: 取单位Y(source),
    方向角: 取两点方向角(取单位X(source), 取单位Y(source), 取单位X(target), 取单位Y(target)),
    速度: 黑暗残响配置.弹幕速度,
    轨迹类型: "追踪",
    指定目标: target,
    追踪转向速度: 720,
    最大距离: 黑暗残响配置.弹幕最大距离,
    生命周期: 黑暗残响配置.弹幕生命周期秒,
    命中半径: 黑暗残响配置.弹幕命中范围,
    影响目标: "敌方",
    碰撞消失: true,
    每单位最大命中次数: 1,
    最大总命中次数: 1,
    飞行高度: 80,
    附加特效1: {
      模型: 黑暗残响配置.弹幕特效,
      缩放: 黑暗残响配置.弹幕缩放,
    },
    目标筛选: 筛选黑暗残响暗影弹目标,
    on命中: on黑暗残响暗影弹命中,
    on结束: on黑暗残响暗影弹结束,
  });
  if (barrage == null || !(barrage.弹幕ID > 0)) return false;
  暗影弹上下文表[barrage.弹幕ID] = { 来源: source, 目标: target };
  活动暗影弹ID列表.push(barrage.弹幕ID);
  return true;
}

function on黑暗残响充能周期(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "黑暗残响" || record.充能ID !== chargeId) return;
  if (!封印守卫战单位存活(record.当前目标) || 单位处于硬控制(unit)) 停止单位充能(unit);
}

function on黑暗残响充能完成(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "黑暗残响" || record.充能ID !== chargeId) return;
  record.充能ID = 0;
  const target = record.当前目标;
  record.当前目标 = undefined;
  if (封印守卫战单位存活(target)) 发射黑暗残响暗影弹(unit, target);
  record.下次技能毫秒 = getServerTime() + 黑暗残响配置.技能冷却毫秒;
}

function on黑暗残响充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "黑暗残响") return;
  if (record.充能ID === chargeId) record.充能ID = 0;
  record.当前目标 = undefined;
  if (reason !== "完成") record.下次技能毫秒 = getServerTime() + 黑暗残响配置.技能冷却毫秒;
}

function 开始黑暗残响暗影索敌(this: void, record: 封印守卫战敌人记录, target: any): boolean {
  if (record.充能ID !== 0 || 单位处于硬控制(record.单位) || !封印守卫战单位存活(target)) return false;
  record.当前目标 = target;
  const id = 开始充能(record.单位, {
    持续时间: 黑暗残响配置.引导持续秒,
    强制硬直: true,
    显示进度条特效: true,
    周期回调间隔: 0.1,
    周期回调: on黑暗残响充能周期,
    充能完成回调: on黑暗残响充能完成,
    结束回调: on黑暗残响充能结束,
  });
  record.充能ID = id;
  return id > 0;
}

export function 刷新黑暗残响AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (record.充能ID !== 0 || 当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 黑暗残响配置.AI刷新毫秒;
  const hero = 选择黑暗残响玩家目标(record);
  if (封印守卫战单位存活(hero)) {
    record.当前目标 = hero;
    if (当前毫秒 >= record.下次技能毫秒 && 开始黑暗残响暗影索敌(record, hero)) return;
    命令攻击目标(record.单位, hero);
    return;
  }
  const core = 读取封印守卫战核心();
  if (封印守卫战单位存活(core)) {
    record.当前目标 = core;
    命令攻击目标(record.单位, core);
  }
}

export function 清理黑暗残响机制(this: void, record: 封印守卫战敌人记录): void {
  if (record.充能ID !== 0 && 封印守卫战单位存活(record.单位)) 停止单位充能(record.单位);
  record.充能ID = 0;
  const keys: number[] = [];
  for (let i = 0; i < 活动暗影弹ID列表.length; i++) {
    const barrageId = 活动暗影弹ID列表[i];
    const context = 暗影弹上下文表[barrageId];
    if (context != null && context.来源 === record.单位) keys.push(barrageId);
  }
  for (let i = 0; i < keys.length; i++) 销毁原生弹幕(keys[i], "手动销毁");
}

export function 清理全部黑暗残响弹幕(this: void): void {
  const keys: number[] = [];
  for (let i = 0; i < 活动暗影弹ID列表.length; i++) keys.push(活动暗影弹ID列表[i]);
  for (let i = 0; i < keys.length; i++) {
    if (keys[i] > 0) 销毁原生弹幕(keys[i], "手动销毁");
  }
}
