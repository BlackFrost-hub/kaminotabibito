/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚腐化感染配置 } from "./02．数值与表现配置";
import { 创建条件伤害修正 } from "../../../../00．技能模板+函数/04．机制组件/08．机制触发/11．条件伤害修正";

const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffRuntime: (this: void, unit: any, buffID: string) => { stack: number; remaining: number } | null;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { 创建单位脚下点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建单位脚下点特效: (this: void, unit: any, 参数: any) => any;
};
const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;

const 受到治疗率属性名 = "受到的治疗率";
const 召唤物主人属性名 = "Master";
const 米亚单位类型ID = stringToFourCCSafe(米亚单位技能配置.Boss单位ID);
const 腐化感染BuffID = 米亚单位技能配置.BuffID.腐化感染;
const 属性浮点归零阈值 = 0.000001;
let 米亚腐化感染机制已注册 = false;

function 取召唤物主人(this: void, unit: any): any {
  if (unit == null || unit === 0) return null;
  const master = YDUserDataGetSafe("unit", unit, 召唤物主人属性名, "unit");
  return master != null && master !== 0 ? master : null;
}

function 是米亚单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return GetUnitTypeId(unit) === 米亚单位类型ID;
}

function 是米亚相关伤害来源(this: void, attacker: any, originalAttacker: any): boolean {
  if (是米亚单位(attacker) || 是米亚单位(originalAttacker)) return true;
  const attackerMaster = 取召唤物主人(originalAttacker);
  if (是米亚单位(attackerMaster)) return true;
  const mappedAttackerMaster = 取召唤物主人(attacker);
  return 是米亚单位(mappedAttackerMaster);
}

function 满足米亚腐化感染伤害条件(this: void, damageContext: any): boolean {
  if (damageContext == null) return false;
  const target = damageContext.target;
  const buffRuntime = getBuffRuntime(target, 腐化感染BuffID);
  const stack = buffRuntime == null ? 0 : Number(buffRuntime.stack) || 0;
  if (stack <= 0) return false;
  return 是米亚相关伤害来源(damageContext.attacker, damageContext.originalAttacker);
}

function 播放米亚腐化感染叠层爆发(this: void, unit: any): void {
  const modelPath = 米亚单位技能配置.特效.腐化感染叠层爆发;
  创建单位脚下点特效(unit, {
    模型路径: modelPath,
    Z: 0,
    缩放: 1.0,
    持续秒: 1.2,
  });
}

function 米亚腐化感染伤害修正(this: void, damageContext: any): number {
  if (damageContext == null || !(damageContext.currentDamage > 0)) {
    return damageContext == null ? 0 : damageContext.currentDamage;
  }

  const target = damageContext.target;
  const buffRuntime = getBuffRuntime(target, 腐化感染BuffID);
  const stack = buffRuntime == null ? 0 : Number(buffRuntime.stack) || 0;
  if (stack <= 0) return damageContext.currentDamage;

  const attacker = damageContext.attacker;
  const originalAttacker = damageContext.originalAttacker;
  if (!是米亚相关伤害来源(attacker, originalAttacker)) return damageContext.currentDamage;

  const multiplier = 1 + stack * 米亚腐化感染配置.每层米亚相关伤害提高;
  const modifiedDamage = damageContext.currentDamage * multiplier;
  return modifiedDamage;
}

export interface 米亚腐化感染层数变化事件 {
  单位: any;
  旧层数: number;
  新层数: number;
  原因: string;
}

export function 同步米亚腐化感染治疗属性(this: void, event: 米亚腐化感染层数变化事件): void {
  if (event == null || event.单位 == null || event.单位 === 0) return;
  if (event.旧层数 === event.新层数) return;

  const owner = GetOwningPlayer(event.单位);
  if (owner == null || owner === 0) return;

  const layerDelta = event.新层数 - event.旧层数;
  const attributeDelta = -layerDelta * 米亚腐化感染配置.每层受到治疗降低;
  const oldValue = Number(YDUserDataGetSafe("player", owner, 受到治疗率属性名, "real")) || 0;
  let newValue = oldValue + attributeDelta;
  if (newValue < 属性浮点归零阈值 && newValue > -属性浮点归零阈值) newValue = 0;
  YDUserDataSetSafe("player", owner, 受到治疗率属性名, "real", newValue);
}

export function 添加米亚腐化感染(this: void, context: 米亚运行时上下文, 单位: any, 层数: number, 来源: string): number {
  const oldStack = context.腐化层数控制器.取层数(单位);
  const newStack = context.腐化层数控制器.增加(单位, 层数, 来源);
  if (newStack > oldStack) 播放米亚腐化感染叠层爆发(单位);
  return newStack;
}

export function 取米亚腐化感染层数(this: void, context: 米亚运行时上下文, 单位: any): number {
  return context.腐化层数控制器.取层数(单位);
}

export function 清空米亚腐化感染(this: void, context: 米亚运行时上下文, 单位: any, 原因: string): void {
  context.腐化层数控制器.清空(单位, 原因);
}

export function 注册米亚腐化感染机制(this: void): void {
  if (米亚腐化感染机制已注册) return;
  米亚腐化感染机制已注册 = true;
  创建条件伤害修正({
    名称: "米亚腐化感染伤害增幅",
    优先级: 30,
    条件: 满足米亚腐化感染伤害条件,
    修正: 米亚腐化感染伤害修正,
  });
}
