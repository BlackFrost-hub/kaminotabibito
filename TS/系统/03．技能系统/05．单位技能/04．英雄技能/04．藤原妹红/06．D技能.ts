/** @noSelfInFile */

import { 藤原妹红单位技能配置 } from "./00．配置";
import { 播放藤原妹红单位音效, 创建藤原妹红点特效, 创建藤原妹红单位特效 } from "./00A．表现工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 开始线性升降, 停止单位线性升降 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.03．线性升降系统") as {
  开始线性升降: (this: void, unit: any, params: any) => number;
  停止单位线性升降: (this: void, unit: any, reason?: string) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 获取范围敌军 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const Cos = jass.Cos as (this: void, radians: number) => number;
const Sin = jass.Sin as (this: void, radians: number) => number;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const BJ_DEGTORAD = (jass.bj_DEGTORAD as number) || 0.017453292519943295;

interface 藤原妹红D击飞记录 {
  施法者: any;
  目标: any;
  已开始下降: boolean;
}

interface 藤原妹红D运行时上下文 {
  施法者: any;
  X: number;
  Y: number;
  技能实例ID?: number;
  爆炸计时回调ID: number;
  燃烧回调ID: number;
  爆炸已结算: boolean;
  持续表现次数: number;
  燃烧次数: number;
  燃烧伤害: number;
  击飞目标列表: any[];
  活跃: boolean;
}

const stringToFourCCSafe = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版").stringToFourCCSafe as (this: void, value: string | undefined | null) => number;
const 普通D技能ID = stringToFourCCSafe(藤原妹红单位技能配置.普通D技能ID);
const 普通D上下文表: Record<number, 藤原妹红D运行时上下文 | undefined> = {};
const D击飞表: Record<number, 藤原妹红D击飞记录 | undefined> = {};

function 取单位句柄ID(this: void, unit: any): number {
  return unit == null || unit === 0 ? 0 : (GetHandleId(unit) || 0);
}

function 获取D上下文(this: void, unit: any): any {
  return unit;
}

function D目标允许命中(this: void, caster: any, target: any): boolean {
  if (!单位存活(target)) return false;
  if (IsUnitType(target, UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(target, UNIT_TYPE_STRUCTURE)) return false;
  return IsUnitEnemy(target, GetOwningPlayer(caster));
}

function 清理D击飞目标(this: void, context: 藤原妹红D运行时上下文): void {
  for (let i = 0; i < context.击飞目标列表.length; i++) {
    const target = context.击飞目标列表[i];
    const targetId = 取单位句柄ID(target);
    const record = D击飞表[targetId];
    if (record != null && record.施法者 === context.施法者) {
      delete D击飞表[targetId];
      停止单位线性升降(target, "中断");
    }
  }
  context.击飞目标列表.length = 0;
}

function 清理藤原妹红D(this: void, context: 藤原妹红D运行时上下文): void {
  if (!context.活跃) return;
  context.活跃 = false;
  if (context.爆炸计时回调ID !== 0) {
    removePeriodicCallback(context.爆炸计时回调ID);
    context.爆炸计时回调ID = 0;
  }
  if (context.燃烧回调ID !== 0) {
    removePeriodicCallback(context.燃烧回调ID);
    context.燃烧回调ID = 0;
  }
  清理D击飞目标(context);
  const casterId = 取单位句柄ID(context.施法者);
  if (普通D上下文表[casterId] === context) delete 普通D上下文表[casterId];
}

function D击飞升降结束(this: void, unit: any, reason: string, _liftId: number): void {
  const targetId = 取单位句柄ID(unit);
  const record = D击飞表[targetId];
  if (record == null) return;
  if (reason === "完成" && !record.已开始下降 && 单位存活(record.施法者) && 单位存活(record.目标)) {
    record.已开始下降 = true;
    开始线性升降(record.目标, {
      持续时间: 0.25,
      高度变化: -2080,
      暂停单位: false,
      主单位: record.施法者,
      结束回调: D击飞升降结束,
    });
    return;
  }
  delete D击飞表[targetId];
}

function 开始D击飞(this: void, context: 藤原妹红D运行时上下文, target: any): void {
  const targetId = 取单位句柄ID(target);
  if (targetId === 0) return;
  const record: 藤原妹红D击飞记录 = { 施法者: context.施法者, 目标: target, 已开始下降: false };
  D击飞表[targetId] = record;
  context.击飞目标列表.push(target);
  开始线性升降(target, {
    持续时间: 0.25,
    高度变化: 2080,
    暂停单位: false,
    主单位: context.施法者,
    结束回调: D击飞升降结束,
  });
}

function 处理藤原妹红D燃烧目标(this: void, target: any, _index: number, variable?: any): any {
  const context = variable as 藤原妹红D运行时上下文 | undefined;
  if (context == null || !D目标允许命中(context.施法者, target)) return undefined;
  创建藤原妹红单位特效(target, 藤原妹红单位技能配置.普通D.持续特效资源, "origin");
  return {
    伤害: context.燃烧伤害,
    伤害类型: DAMAGE_TYPE_FIRE,
    attack: true,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
  };
}

function 藤原妹红D燃烧Tick(this: void, variable?: any): void {
  const context = variable as 藤原妹红D运行时上下文 | undefined;
  if (context == null || !context.活跃) return;
  const cfg = 藤原妹红单位技能配置.普通D;
  if (context.燃烧次数 >= cfg.燃烧次数) {
    清理藤原妹红D(context);
    return;
  }
  context.燃烧次数 += 1;
  const targets = 获取范围敌军(context.施法者, context.X, context.Y, cfg.爆炸范围);
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: targets,
    伤害类型: DAMAGE_TYPE_FIRE,
    来源类型: "单位技能",
    技能ID: 普通D技能ID,
    技能实例ID: context.技能实例ID,
    标签: "藤原妹红-燃烧殆尽",
    每目标处理器: 处理藤原妹红D燃烧目标,
    变量: context,
  });
}

function 藤原妹红D爆炸(this: void, context: 藤原妹红D运行时上下文): void {
  if (!context.活跃 || context.爆炸已结算 || !单位存活(context.施法者)) {
    清理藤原妹红D(context);
    return;
  }
  context.爆炸已结算 = true;
  const cfg = 藤原妹红单位技能配置.普通D;
  context.燃烧伤害 = 读取单位攻击力(context.施法者) * cfg.伤害攻击力倍率;
  创建藤原妹红点特效(cfg.中心特效, context.X, context.Y);
  for (let i = 0; i < cfg.外围特效数量; i++) {
    const angle = cfg.外围特效间隔角度 * (i + 1);
    const radians = angle * BJ_DEGTORAD;
    创建藤原妹红点特效(
      cfg.外围特效,
      context.X + Cos(radians) * cfg.外围特效半径,
      context.Y + Sin(radians) * cfg.外围特效半径,
      angle,
    );
  }
  const targets = 获取范围敌军(context.施法者, context.X, context.Y, cfg.爆炸范围);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!D目标允许命中(context.施法者, target)) continue;
    施加眩晕(context.施法者, target, cfg.控制秒, "藤原妹红-燃烧殆尽", "技能");
    开始D击飞(context, target);
  }
  context.燃烧回调ID = addPeriodicCallback(cfg.燃烧间隔毫秒, 藤原妹红D燃烧Tick, context);
  if (context.燃烧次数 === 0) context.燃烧次数 = 0;
}

function 藤原妹红D持续表现(this: void, context: 藤原妹红D运行时上下文): void {
  const cfg = 藤原妹红单位技能配置.普通D;
  const angle = cfg.持续特效角度列表[context.持续表现次数];
  if (angle == null) return;
  const radians = angle * BJ_DEGTORAD;
  创建藤原妹红点特效(
    cfg.持续特效资源,
    context.X + Cos(radians) * cfg.持续特效半径,
    context.Y + Sin(radians) * cfg.持续特效半径,
    angle,
  );
  context.持续表现次数 += 1;
}

function 藤原妹红D爆炸计时Tick(this: void, variable?: any): void {
  const context = variable as 藤原妹红D运行时上下文 | undefined;
  if (context == null || !context.活跃) return;
  藤原妹红D持续表现(context);
  if (context.持续表现次数 >= 藤原妹红单位技能配置.普通D.持续特效角度列表.length) {
    if (context.爆炸计时回调ID !== 0) removePeriodicCallback(context.爆炸计时回调ID);
    context.爆炸计时回调ID = 0;
    藤原妹红D爆炸(context);
  }
}

function 释放藤原妹红普通D(this: void, _context: any, caster: any, skillInstanceId?: number): void {
  if (!单位存活(caster)) return;
  const casterId = 取单位句柄ID(caster);
  const oldContext = 普通D上下文表[casterId];
  if (oldContext != null) 清理藤原妹红D(oldContext);
  const cfg = 藤原妹红单位技能配置.普通D;
  const context: 藤原妹红D运行时上下文 = {
    施法者: caster,
    X: GetSpellTargetX(),
    Y: GetSpellTargetY(),
    技能实例ID: skillInstanceId,
    爆炸计时回调ID: 0,
    燃烧回调ID: 0,
    爆炸已结算: false,
    持续表现次数: 0,
    燃烧次数: 0,
    燃烧伤害: 0,
    击飞目标列表: [],
    活跃: true,
  };
  普通D上下文表[casterId] = context;
  播放藤原妹红单位音效(caster, cfg.全局音效键);
  context.爆炸计时回调ID = addPeriodicCallback(cfg.启动间隔毫秒, 藤原妹红D爆炸计时Tick, context);
}

function 藤原妹红D单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  for (const key in 普通D上下文表) {
    const context = 普通D上下文表[Number(key)];
    if (context == null || context.施法者 !== dyingUnit) continue;
    清理藤原妹红D(context);
  }
  for (const key in D击飞表) {
    const record = D击飞表[Number(key)];
    if (record == null || (record.施法者 !== dyingUnit && record.目标 !== dyingUnit)) continue;
    停止单位线性升降(record.目标, "中断");
    delete D击飞表[Number(key)];
  }
}

export function 注册藤原妹红普通D(this: void): void {
  注册单位技能壳监听({
    名称: "藤原妹红-燃烧殆尽",
    单位类型ID: stringToFourCCSafe(藤原妹红单位技能配置.单位类型ID),
    技能ID: 普通D技能ID,
    获取或创建上下文: 获取D上下文,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 藤原妹红单位技能配置.技能实例持续秒,
    释放技能: 释放藤原妹红普通D,
  });
  registerDeathListener(藤原妹红D单位死亡);
}

注册藤原妹红普通D();

export const 藤原妹红普通D技能状态 = {
  已完成设计: true,
  已完成实现: true,
  伤害形态: "1.6秒爆炸后20次火焰批量AOE",
} as const;

export {};
