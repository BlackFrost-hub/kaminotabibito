/** @noSelfInFile */

import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔数值与表现配置 } from "./02．数值与表现配置";
import { 获取或创建菲尼克斯尔上下文, 注册菲尼克斯尔运行时 } from "./03．运行时上下文";
import { 初始化菲尼克斯尔永恒冰核与导管 } from "./05．永恒冰核与导管";
import { 注册菲尼克斯尔技能结构 } from "./18．技能入口";
import { stringToFourCC } from "./19．公共工具";

const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { 获取所有Boss自动技能启动上下文 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  获取所有Boss自动技能启动上下文: (this: void) => any[];
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 获取单位Buff层数 } = require("系统.05．Buff系统.00．Buff系统") as {
  获取单位Buff层数: (this: void, unit: any, buffID: string) => number;
};

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;

const 菲尼克斯尔单位类型ID = stringToFourCC(菲尼克斯尔单位技能配置.单位ID);
let 菲尼克斯尔被动已注册 = false;
let 菲尼克斯尔承伤修正已注册 = false;

function 扫描菲尼克斯尔启动上下文(this: void): void {
  const contexts = 获取所有Boss自动技能启动上下文();
  for (let i = 0; i < contexts.length; i++) {
    const item = contexts[i];
    const boss = item != null ? item.Boss单位 : undefined;
    if (boss == null || boss === 0 || GetUnitTypeId(boss) !== 菲尼克斯尔单位类型ID) continue;
    const context = 获取或创建菲尼克斯尔上下文(boss);
    if (context != null) 初始化菲尼克斯尔永恒冰核与导管(context);
  }
}

function 菲尼克斯尔导管破封承伤修正(this: void, damageContext: any): number {
  const target = damageContext != null ? damageContext.target : undefined;
  if (target == null || target === 0 || GetUnitTypeId(target) !== 菲尼克斯尔单位类型ID) return damageContext.currentDamage;
  const layers = 获取单位Buff层数(target, 菲尼克斯尔单位技能配置.BuffID.导管破封);
  if (layers <= 0) return damageContext.currentDamage;
  return damageContext.currentDamage * (1 + layers * 菲尼克斯尔数值与表现配置.机制.每根导管承伤提高);
}

function 确保菲尼克斯尔承伤修正(this: void): void {
  if (菲尼克斯尔承伤修正已注册) return;
  菲尼克斯尔承伤修正已注册 = true;
  registerDamageModifier(菲尼克斯尔导管破封承伤修正, 15);
}

export function 注册菲尼克斯尔被动效果(this: void): void {
  if (菲尼克斯尔被动已注册) return;
  菲尼克斯尔被动已注册 = true;
  注册菲尼克斯尔运行时();
  注册菲尼克斯尔技能结构();
  确保菲尼克斯尔承伤修正();
  addPeriodicCallback(1000, 扫描菲尼克斯尔启动上下文);
}

注册菲尼克斯尔被动效果();
