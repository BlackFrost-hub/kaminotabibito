/** @noSelfInFile */

import type { 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔数值与表现配置 } from "./02．数值与表现配置";
import { 播放菲尼克斯尔台词 } from "./17．台词播放";
import {
  播放点特效,
  设置单位动画,
  设置单位模型,
  取单位X,
  取单位Y,
  单位存活,
} from "./19．公共工具";

const japi = require("jass.japi") as any;

const DzSetUnitName = japi.DzSetUnitName as ((unit: any, name: string) => boolean) | undefined;

export function 切换菲尼克斯尔第二形态(this: void, context: 菲尼克斯尔运行时上下文): void {
  const boss = context.Boss;
  if (!单位存活(boss) || context.当前形态 !== "第一形态") return;
  context.当前形态 = "第二形态";
  设置单位模型(boss, 菲尼克斯尔单位技能配置.模型.第二形态);
  if (typeof DzSetUnitName === "function") DzSetUnitName(boss, 菲尼克斯尔单位技能配置.第二形态名称);
  设置单位动画(boss, 菲尼克斯尔数值与表现配置.动画.第二形态.待机.编号, 菲尼克斯尔数值与表现配置.动画.第二形态.待机.倍速);
  播放点特效(菲尼克斯尔数值与表现配置.特效.形态转换, 取单位X(boss), 取单位Y(boss), 2500);
  播放菲尼克斯尔台词(boss, "转第二形态");
}

export function 注册菲尼克斯尔双形态转换(this: void): void {
  // 形态切换由永恒冰核/导管机制触发。
}
