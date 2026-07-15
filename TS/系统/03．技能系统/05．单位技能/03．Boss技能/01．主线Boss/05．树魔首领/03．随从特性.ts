/** @noSelfInFile */

import { 树魔首领单位技能配置 } from "./00．配置";
import { 获取树魔首领上下文, 获取或创建树魔首领上下文, 获取全部树魔首领上下文, 清理树魔首领上下文, 树魔首领运行时上下文 } from "./01．运行时上下文";
import { 树魔首领数值与表现配置, 树魔首领音效配置 } from "./02．数值与表现配置";
import { 播放树魔首领台词 } from "./08．台词播放";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as { udg_Boss?: any; [key: string]: any };

const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (whichUnit: any) => number;
const GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed as (whichUnit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const CreateUnit = jass.CreateUnit as (id: any, unitid: number, x: number, y: number, face: number) => any;
const IssueTargetOrder = jass.IssueTargetOrder as (whichUnit: any, order: string, targetWidget: any) => boolean;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const {
  addPeriodicCallback,
  removePeriodicCallback,
  getServerTime,
} = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, unit: any, buffID: string, duration: number, effect: number, extra?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => void;
};
const { 树魔首领BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.04．树魔首领") as {
  树魔首领BuffID: { 兽群号令: string; 无从暴怒: string };
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, model: string, x: number, y: number, z: number, duration: number) => any;
};

const 攻速属性ID = 10;
const 叠加移动速度属性ID = 9;
const 树魔首领单位类型ID = stringToFourCC(树魔首领单位技能配置.单位ID);
const 猎头者单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.猎头者);
const 巫医单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.巫医);
const 投掷者单位类型ID = stringToFourCC(树魔首领单位技能配置.召唤物ID.投掷者);

let 树魔首领随从特性已注册 = false;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 是树魔首领(this: void, unit: any): boolean {
  return 单位存活(unit) && GetUnitTypeId(unit) === 树魔首领单位类型ID;
}

function 单位类型是树魔首领(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) === 树魔首领单位类型ID;
}

function 随机召唤点(this: void, boss: any): { x: number; y: number } {
  const cfg = 树魔首领数值与表现配置.随从特性;
  return {
    x: GetUnitX(boss) + GetRandomReal(-cfg.召唤范围, cfg.召唤范围),
    y: GetUnitY(boss) + GetRandomReal(-cfg.召唤范围, cfg.召唤范围),
  };
}

function 召唤树魔随从(this: void, context: 树魔首领运行时上下文, unitTypeId: number): any {
  const boss = context.Boss单位;
  const 点 = 随机召唤点(boss);
  const minion = CreateUnit(GetOwningPlayer(boss), unitTypeId, 点.x, 点.y, GetRandomReal(0, 360));
  if (minion == null || minion === 0) return null;
  context.随从组.登记(minion);
  context.清理.登记单位("树魔首领随从", minion);
  IssueTargetOrder(minion, "patrol", boss);
  return minion;
}

function 随机取音效路径(this: void, list: readonly string[]): string {
  if (list.length <= 0) return "";
  return list[GetRandomInt(0, list.length - 1)];
}

function 尝试播放树魔首领怪叫(this: void, boss: any, 触发概率百分比: number): void {
  const soundCfg = 树魔首领音效配置;
  尝试播放Boss拟声池({
    标识: soundCfg.怪物拟声.标识,
    音效路径列表: soundCfg.怪物拟声.音效路径列表,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    裁断距离: soundCfg.默认裁断距离,
    冷却Ms: soundCfg.怪物拟声.冷却Ms,
    触发概率百分比,
  });
}

function 召唤一波随从(this: void, context: 树魔首领运行时上下文): void {
  const roll = GetRandomInt(1, 3);
  let 已召唤随从 = false;
  if (roll === 1) {
    if (召唤树魔随从(context, 猎头者单位类型ID) != null) 已召唤随从 = true;
    if (召唤树魔随从(context, 猎头者单位类型ID) != null) 已召唤随从 = true;
  } else if (roll === 2) {
    const witchDoctor = 召唤树魔随从(context, 巫医单位类型ID);
    if (witchDoctor != null && witchDoctor !== 0) {
      已召唤随从 = true;
      let healId = 0;
      healId = addPeriodicCallback(树魔首领数值与表现配置.随从特性.巫医治疗间隔秒 * 1000, function 树魔巫医治疗Tick(this: void): void {
        if (!单位存活(witchDoctor) || !单位存活(context.Boss单位)) {
          removePeriodicCallback(healId);
          return;
        }
        IssueTargetOrder(witchDoctor, "healingwave", context.Boss单位);
      });
      context.清理.登记周期回调("树魔巫医治疗", healId);
    }
  } else {
    if (召唤树魔随从(context, 投掷者单位类型ID) != null) 已召唤随从 = true;
  }
  if (已召唤随从) {
    const soundCfg = 树魔首领音效配置;
    播放Boss坐标音效(
      随机取音效路径(soundCfg.随从特性.召唤号令列表),
      GetUnitX(context.Boss单位),
      GetUnitY(context.Boss单位),
      soundCfg.默认裁断距离,
    );
    尝试播放树魔首领怪叫(context.Boss单位, soundCfg.怪物拟声.召唤触发概率百分比);
  }
  播放树魔首领台词(context.Boss单位, "随从特性");
}

function 进入无从暴怒(this: void, context: 树魔首领运行时上下文): void {
  if (context.无从暴怒中) return;
  const cfg = 树魔首领数值与表现配置.随从特性;
  context.无从暴怒中 = true;
  context.暴怒攻速增量 = cfg.无小弟攻速提高;
  context.暴怒移速增量 = GetUnitDefaultMoveSpeed(context.Boss单位) * cfg.无小弟移速提高;
  SGSS_SetState(context.Boss单位, 攻速属性ID, context.暴怒攻速增量);
  SGSS_SetState(context.Boss单位, 叠加移动速度属性ID, context.暴怒移速增量);
  播放Boss坐标音效(树魔首领音效配置.随从特性.无从暴怒, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 树魔首领音效配置.默认裁断距离);
  尝试播放树魔首领怪叫(context.Boss单位, 树魔首领音效配置.怪物拟声.暴怒触发概率百分比);
}

function 退出无从暴怒(this: void, context: 树魔首领运行时上下文): void {
  if (!context.无从暴怒中) return;
  context.无从暴怒中 = false;
  if (context.暴怒攻速增量 !== 0) SGSS_SetState(context.Boss单位, 攻速属性ID, -context.暴怒攻速增量);
  if (context.暴怒移速增量 !== 0) SGSS_SetState(context.Boss单位, 叠加移动速度属性ID, -context.暴怒移速增量);
  context.暴怒攻速增量 = 0;
  context.暴怒移速增量 = 0;
  移除单位指定Buff(context.Boss单位, 树魔首领BuffID.无从暴怒);
}

function 刷新随从状态(this: void, context: 树魔首领运行时上下文): void {
  if (!单位存活(context.Boss单位)) {
    清理树魔首领上下文(context.Boss单位);
    return;
  }
  const cfg = 树魔首领数值与表现配置.随从特性;
  const count = context.随从组.取存活数量();
  context.当前随从数量 = count;
  context.当前兽群层数 = Math.min(4, count);

  if (count > 0) {
    退出无从暴怒(context);
    registerManualBuff(context.Boss单位, 树魔首领BuffID.兽群号令, cfg.兽群Buff刷新秒, context.当前兽群层数, {
      sourceName: "树魔首领",
    });
  } else {
    移除单位指定Buff(context.Boss单位, 树魔首领BuffID.兽群号令);
    进入无从暴怒(context);
    registerManualBuff(context.Boss单位, 树魔首领BuffID.无从暴怒, cfg.暴怒Buff刷新秒, 1, {
      sourceName: "树魔首领",
    });
    createTimedEffect(cfg.暴怒持续特效路径, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 0, cfg.暴怒持续特效刷新毫秒 / 1000);
  }
}

function 树魔首领随从伤害修正(this: void, damageContext: any): number {
  const attacker = damageContext.attacker;
  if (!是树魔首领(attacker)) return damageContext.currentDamage;
  const context = 获取或创建树魔首领上下文(attacker);
  if (context == null || context.当前兽群层数 <= 0) return damageContext.currentDamage;
  const cfg = 树魔首领数值与表现配置.随从特性;
  const bonus = Math.min(cfg.最高攻击提高, context.当前兽群层数 * cfg.每个小弟攻击提高);
  return damageContext.currentDamage * (1 + bonus);
}

function on树魔首领死亡(this: void, dyingUnit: any): void {
  if (!单位类型是树魔首领(dyingUnit)) return;
  const context = 获取树魔首领上下文(dyingUnit);
  if (context != null) 退出无从暴怒(context);
  清理树魔首领上下文(dyingUnit);
}

function 树魔首领随从特性Tick(this: void): void {
  const currentBoss = jglobals.udg_Boss;
  if (是树魔首领(currentBoss)) {
    const context = 获取或创建树魔首领上下文(currentBoss);
    if (context != null && !context.随从特性已初始化) {
      context.随从特性已初始化 = true;
      context.下一次召唤Ms = getServerTime() + 树魔首领数值与表现配置.随从特性.召唤间隔秒 * 1000;
    }
  }

  const now = getServerTime();
  const list = 获取全部树魔首领上下文();
  for (let i = 0; i < list.length; i++) {
    const context = list[i];
    if (context == null) continue;
    刷新随从状态(context);
    if (context.下一次召唤Ms > 0 && now >= context.下一次召唤Ms) {
      召唤一波随从(context);
      context.下一次召唤Ms = now + 树魔首领数值与表现配置.随从特性.召唤间隔秒 * 1000;
    }
  }
}

export function 注册树魔首领随从特性(this: void): void {
  if (树魔首领随从特性已注册) return;
  树魔首领随从特性已注册 = true;
  registerDamageModifier(树魔首领随从伤害修正, 45);
  registerDeathListener(on树魔首领死亡);
  addPeriodicCallback(树魔首领数值与表现配置.随从特性.追随刷新间隔毫秒, 树魔首领随从特性Tick);
}
