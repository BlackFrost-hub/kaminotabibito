/** @noSelfInFile */

import type { 战斗启动属性配置, Boss战斗启动护卫配置 } from "../00．配置类型";
import { 单位E079战斗启动属性配置 } from "./01．克洛克达尔";
import { 单位E07E战斗启动属性配置 } from "./02．赫萝";
import { 单位E07X战斗启动属性配置 } from "./03．比那名居天子";
import { 单位O005战斗启动属性配置 } from "./04．神罗战士（克隆形态）";
import { 单位U007战斗启动属性配置 } from "./05．安兹乌尔恭";
import { 单位U009战斗启动属性配置 } from "./06．夏提雅";

export const 异界Boss战斗启动属性配置表: 战斗启动属性配置[] = [
  单位E079战斗启动属性配置,
  单位E07E战斗启动属性配置,
  单位E07X战斗启动属性配置,
  单位O005战斗启动属性配置,
  单位U007战斗启动属性配置,
  单位U009战斗启动属性配置,
];

export const 异界Boss分类战斗启动护卫配置表: Boss战斗启动护卫配置[] = [

];

export * from "./01．克洛克达尔";
export * from "./02．赫萝";
export * from "./03．比那名居天子";
export * from "./04．神罗战士（克隆形态）";
export * from "./05．安兹乌尔恭";
export * from "./06．夏提雅";
export * from "./00．异界Boss共享配置";
