/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔场地配置 } from "./01．场地配置";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import {
  延迟,
  周期,
  单位存活,
  取最大生命,
  取当前生命,
  设置当前生命,
  创建菲尼克斯尔机制单位,
  播放点特效,
  取单位X,
  取单位Y,
  设置单位动画,
} from "./19．公共工具";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const RemoveUnit = jass.RemoveUnit as (whichUnit: any) => void;

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

const 怨火核心上下文表: Record<number, 菲尼克斯尔运行时上下文 | undefined> = {};
let 怨火核心承伤修正已注册 = false;

function on菲尼克斯尔怨火核心死亡(this: void, context: 菲尼克斯尔运行时上下文, unit: any): void {
  context.怨火核心暴露中 = false;
  const id = GetHandleId(unit) || 0;
  if (id !== 0) delete 怨火核心上下文表[id];
  const damage = 取最大生命(context.Boss) * 菲尼克斯尔数值与表现配置.机制.怨火核心摧毁Boss最大生命伤害比例;
  设置当前生命(context.Boss, 取当前生命(context.Boss) - damage);
  播放点特效(菲尼克斯尔数值与表现配置.特效.核心暴露, 取单位X(unit), 取单位Y(unit), 1800);
}

function 创建怨火核心死亡回调(this: void, context: 菲尼克斯尔运行时上下文): (this: void, unit: any, killer: any) => void {
  return function 菲尼克斯尔怨火核心死亡(this: void, unit: any): void {
    on菲尼克斯尔怨火核心死亡(context, unit);
  };
}

function 菲尼克斯尔怨火核心承伤修正(this: void, damageContext: any): number {
  const target = damageContext != null ? damageContext.target : undefined;
  const id = target != null && target !== 0 ? GetHandleId(target) || 0 : 0;
  if (id === 0) return damageContext.currentDamage;
  const context = 怨火核心上下文表[id];
  if (context == null || !context.怨火核心暴露中) return damageContext.currentDamage;
  return damageContext.currentDamage * (1 + 菲尼克斯尔数值与表现配置.机制.怨火核心暴露承伤提高);
}

export function 触发菲尼克斯尔怨火核心暴露(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.怨火核心暴露中 || context.当前形态 !== "第二形态" || !单位存活(context.Boss)) return;
  context.怨火核心暴露中 = true;
  设置单位动画(context.Boss, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.施法.倍速);
  播放菲尼克斯尔台词(context.Boss, "怨火核心暴露");
  const center = 菲尼克斯尔场地配置.中心点;
  context.怨火核心 = 创建菲尼克斯尔机制单位(
    context,
    菲尼克斯尔单位技能配置.机制单位ID.怨火核心,
    "怨火核心",
    菲尼克斯尔单位技能配置.模型.怨火核心,
    center.x,
    center.y,
    取最大生命(context.Boss) * 菲尼克斯尔数值与表现配置.机制.怨火核心生命Boss最大生命比例,
    创建怨火核心死亡回调(context)
  );
  const id = GetHandleId(context.怨火核心) || 0;
  if (id !== 0) 怨火核心上下文表[id] = context;
  播放点特效(菲尼克斯尔数值与表现配置.特效.核心暴露, center.x, center.y, 2500);
  播放Boss坐标音效(菲尼克斯尔音效配置.怨火核心.暴露, center.x, center.y, 菲尼克斯尔音效配置.默认裁断距离);
  延迟(菲尼克斯尔数值与表现配置.机制.怨火核心暴露持续秒 * 1000, function 菲尼克斯尔怨火核心暴露结束(this: void): void {
    if (单位存活(context.怨火核心)) {
      const coreId = GetHandleId(context.怨火核心) || 0;
      if (coreId !== 0) delete 怨火核心上下文表[coreId];
      RemoveUnit(context.怨火核心);
      context.怨火核心 = undefined;
    }
    context.怨火核心暴露中 = false;
  });
}

export function 初始化菲尼克斯尔怨火核心暴露节点(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.怨火核心暴露已初始化) return;
  context.怨火核心暴露已初始化 = true;
  const timerId = 周期(菲尼克斯尔数值与表现配置.机制.怨火核心周期暴露秒 * 1000, function 菲尼克斯尔怨火核心周期暴露(this: void): void {
    触发菲尼克斯尔怨火核心暴露(context);
  });
  context.清理.登记周期回调("菲尼克斯尔-怨火核心周期暴露", timerId);
}

export function 注册菲尼克斯尔怨火核心暴露(this: void): void {
  if (怨火核心承伤修正已注册) return;
  怨火核心承伤修正已注册 = true;
  registerDamageModifier(菲尼克斯尔怨火核心承伤修正, 15);
}
