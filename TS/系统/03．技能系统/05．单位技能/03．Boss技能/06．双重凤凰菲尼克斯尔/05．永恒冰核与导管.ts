/** @noSelfInFile */

import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔场地配置 } from "./01．场地配置";
import { 菲尼克斯尔数值与表现配置, 菲尼克斯尔音效配置 } from "./02．数值与表现配置";
import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import { 播放Boss坐标音效 } from "../00．公共/00．Boss音效播放";
import {
  创建菲尼克斯尔机制单位,
  取最大生命,
  播放点特效,
  单位有效,
} from "./19．公共工具";

const { 创建单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电") as {
  创建单位绑定闪电: (this: void, 参数: any) => any;
};
const { 闪电效果代码 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码") as {
  闪电效果代码: any;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;

function on菲尼克斯尔导管死亡(this: void, context: 菲尼克斯尔运行时上下文, unit: any): void {
  if (context.当前形态 !== "第一形态") return;
  context.已摧毁导管数 += 1;
  播放点特效(菲尼克斯尔数值与表现配置.特效.导管死亡, GetUnitX(unit), GetUnitY(unit), 1800);
  播放Boss坐标音效(菲尼克斯尔音效配置.导管死亡.小封印破口, GetUnitX(unit), GetUnitY(unit), 菲尼克斯尔音效配置.默认裁断距离);
  registerManualBuff(context.Boss, 菲尼克斯尔单位技能配置.BuffID.导管破封, 3600, context.已摧毁导管数, {
    stack: context.已摧毁导管数,
    sourceName: 菲尼克斯尔单位技能配置.单位名称,
  });
  if (context.已摧毁导管数 >= 菲尼克斯尔数值与表现配置.机制.导管数量) {
    const mod = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.09．浴火重生准备") as {
      触发菲尼克斯尔P1转场: (this: void, context: 菲尼克斯尔运行时上下文) => void;
    };
    mod.触发菲尼克斯尔P1转场(context);
  } else {
    播放菲尼克斯尔台词(context.Boss, "导管摧毁");
  }
}

function 创建导管死亡回调(this: void, context: 菲尼克斯尔运行时上下文): (this: void, unit: any, killer: any) => void {
  return function 菲尼克斯尔导管死亡回调(this: void, unit: any): void {
    on菲尼克斯尔导管死亡(context, unit);
  };
}

export function 初始化菲尼克斯尔永恒冰核与导管(this: void, context: 菲尼克斯尔运行时上下文): void {
  if (context.P1机制已初始化) return;
  context.P1机制已初始化 = true;
  const maxLife = 取最大生命(context.Boss);
  const ice = 菲尼克斯尔场地配置.永恒冰核点;
  context.永恒冰核 = 创建菲尼克斯尔机制单位(
    context,
    菲尼克斯尔单位技能配置.机制单位ID.永恒冰核,
    "永恒冰核",
    菲尼克斯尔单位技能配置.模型.永恒冰核,
    ice.x,
    ice.y,
    9999999
  );

  const points = 菲尼克斯尔场地配置.导管点位;
  for (let i = 0; i < points.length; i++) {
    const p = points[i];
    const conduit = 创建菲尼克斯尔机制单位(
      context,
      菲尼克斯尔单位技能配置.机制单位ID.能量导管,
      "能量导管" + (i + 1).toString(),
      菲尼克斯尔单位技能配置.模型.能量导管,
      p.x,
      p.y,
      maxLife * 菲尼克斯尔数值与表现配置.机制.导管生命Boss最大生命比例,
      创建导管死亡回调(context)
    );
    context.导管列表.push({ 单位: conduit, 已摧毁: false });
    if (单位有效(conduit) && 单位有效(context.永恒冰核)) {
      const lightning = 创建单位绑定闪电({
        效果代码: 闪电效果代码.蓝色细束,
        起点单位: conduit,
        终点单位: context.永恒冰核,
        持续时间: 3600,
        起点高度偏移: 90,
        终点高度偏移: 140,
        任一死亡时销毁: true,
      });
      context.清理.登记闪电("菲尼克斯尔导管闪电", lightning);
    }
  }
}

export function 注册菲尼克斯尔永恒冰核与导管(this: void): void {
  // 由开战上下文或测试场景初始化。
}
