/** @noSelfInFile */

import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔数值与表现配置 } from "./02．数值与表现配置";
import { 获取或创建菲尼克斯尔上下文, 获取菲尼克斯尔上下文, 注册菲尼克斯尔运行时 } from "./03．运行时上下文";
import { 初始化菲尼克斯尔永恒冰核与导管 } from "./05．永恒冰核与导管";
import { 注册菲尼克斯尔技能结构 } from "./18．技能入口";
import { stringToFourCC, 取当前生命, 取最大生命 } from "./19．公共工具";
import { 创建条件伤害修正 } from "../../../../00．技能模板+函数/04．机制组件/08．机制触发/11．条件伤害修正";

const { 注册Boss自动技能启动监听 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};
const { 获取单位Buff层数 } = require("系统.05．Buff系统.00．Buff系统") as {
  获取单位Buff层数: (this: void, unit: any, buffID: string) => number;
};

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;

const 菲尼克斯尔单位类型ID = stringToFourCC(菲尼克斯尔单位技能配置.单位ID);
let 菲尼克斯尔被动已注册 = false;
let 菲尼克斯尔承伤修正已注册 = false;
let 菲尼克斯尔核心与轮回保护已注册 = false;

function on菲尼克斯尔Boss启动(this: void, 启动上下文: any): void {
  const context = 获取或创建菲尼克斯尔上下文(启动上下文.Boss单位);
  if (context != null) 初始化菲尼克斯尔永恒冰核与导管(context);
}

function 是菲尼克斯尔导管破封目标(this: void, damageContext: any): boolean {
  const target = damageContext != null ? damageContext.target : undefined;
  return target != null && target !== 0 && GetUnitTypeId(target) === 菲尼克斯尔单位类型ID;
}

function 菲尼克斯尔导管破封承伤修正(this: void, damageContext: any): number {
  const target = damageContext.target;
  const layers = 获取单位Buff层数(target, 菲尼克斯尔单位技能配置.BuffID.导管破封);
  if (layers <= 0) return damageContext.currentDamage;
  return damageContext.currentDamage * (1 + layers * 菲尼克斯尔数值与表现配置.机制.每根导管承伤提高);
}

function 确保菲尼克斯尔承伤修正(this: void): void {
  if (菲尼克斯尔承伤修正已注册) return;
  菲尼克斯尔承伤修正已注册 = true;
  创建条件伤害修正({
    名称: "菲尼克斯尔导管破封承伤",
    优先级: 15,
    条件: 是菲尼克斯尔导管破封目标,
    修正: 菲尼克斯尔导管破封承伤修正,
  });
}

function 是菲尼克斯尔Boss核心暴露目标(this: void, damageContext: any): boolean {
  const target = damageContext != null ? damageContext.target : undefined;
  const context = 获取菲尼克斯尔上下文(target);
  return context != null && context.怨火核心暴露中 === true;
}

function 菲尼克斯尔核心暴露承伤修正(this: void, damageContext: any): number {
  return damageContext.currentDamage * 3;
}

function 是菲尼克斯尔Boss轮回保护目标(this: void, damageContext: any): boolean {
  const target = damageContext != null ? damageContext.target : undefined;
  const context = 获取菲尼克斯尔上下文(target);
  return context != null && target === context.Boss;
}

function 菲尼克斯尔轮回锁血修正(this: void, damageContext: any): number {
  const target = damageContext.target;
  const context = 获取菲尼克斯尔上下文(target);
  if (context == null) return damageContext.currentDamage;
  if (context.当前形态 === "永恒轮回") return 0;
  const maxLife = 取最大生命(target);
  const currentLife = 取当前生命(target);
  const thresholdLife = maxLife * 菲尼克斯尔数值与表现配置.机制.永恒轮回触发生命比例;
  if (currentLife <= thresholdLife) return 0;
  if (currentLife - damageContext.currentDamage <= thresholdLife) return currentLife - thresholdLife;
  return damageContext.currentDamage;
}

function 确保菲尼克斯尔核心与轮回保护(this: void): void {
  if (菲尼克斯尔核心与轮回保护已注册) return;
  菲尼克斯尔核心与轮回保护已注册 = true;
  创建条件伤害修正({
    名称: "菲尼克斯尔-怨火核心暴露承伤",
    优先级: 16,
    条件: 是菲尼克斯尔Boss核心暴露目标,
    修正: 菲尼克斯尔核心暴露承伤修正,
  });
  创建条件伤害修正({
    名称: "菲尼克斯尔-永恒轮回锁血",
    优先级: 90,
    条件: 是菲尼克斯尔Boss轮回保护目标,
    修正: 菲尼克斯尔轮回锁血修正,
  });
}

export function 注册菲尼克斯尔被动效果(this: void): void {
  if (菲尼克斯尔被动已注册) return;
  菲尼克斯尔被动已注册 = true;
  注册菲尼克斯尔运行时();
  注册菲尼克斯尔技能结构();
  确保菲尼克斯尔承伤修正();
  确保菲尼克斯尔核心与轮回保护();
  注册Boss自动技能启动监听({
    名称: "菲尼克斯尔运行时上下文绑定",
    单位类型ID: 菲尼克斯尔单位类型ID,
    on启动: on菲尼克斯尔Boss启动,
  });
}

注册菲尼克斯尔被动效果();
