/** @noSelfInFile */

import type { 战斗启动属性配置, Boss战斗启动护卫配置 } from "../00．配置类型";
import { 单位n049战斗启动属性配置 } from "./01．水触须";
import { 单位n01G战斗启动属性配置 } from "./02．奇妙鹿";
import { 单位O008战斗启动属性配置 } from "./03．嗜血兽人";
import { 单位n011战斗启动属性配置 } from "./04．水龙蛇";
import { 单位N01T战斗启动属性配置 } from "./05．沙丘母虫";
import { 单位n02V战斗启动属性配置 } from "./06．蜘蛛女皇";
import { 单位n02Q战斗启动属性配置 } from "./07．沙漠蜥蜴（变异）";
import { 单位nbdo战斗启动属性配置, 单位nbdo战斗启动护卫配置 } from "./08．蛇之领主-奢恩";
import { 单位o000战斗启动属性配置, 单位o000战斗启动护卫配置 } from "./09．蛇之遗迹看守者-奢隆";
import { 单位n02U战斗启动属性配置 } from "./10．龙虾守卫";
import { 单位n02S战斗启动属性配置 } from "./11．湖底元素";
import { 单位O002战斗启动属性配置 } from "./12．黑暗恶魔军官";
import { 单位n03S战斗启动属性配置 } from "./13．恶魔看守者";
import { 单位N03O战斗启动属性配置, 单位N03O战斗启动护卫配置 } from "./14．恶魔领袖";
import { 单位N03B战斗启动属性配置 } from "./15．熔岩恶魔";

export const Boss战斗启动属性配置表: 战斗启动属性配置[] = [
  单位n049战斗启动属性配置,
  单位n01G战斗启动属性配置,
  单位O008战斗启动属性配置,
  单位n011战斗启动属性配置,
  单位N01T战斗启动属性配置,
  单位n02V战斗启动属性配置,
  单位n02Q战斗启动属性配置,
  单位nbdo战斗启动属性配置,
  单位o000战斗启动属性配置,
  单位n02U战斗启动属性配置,
  单位n02S战斗启动属性配置,
  单位O002战斗启动属性配置,
  单位n03S战斗启动属性配置,
  单位N03O战斗启动属性配置,
  单位N03B战斗启动属性配置,
];

export const Boss分类战斗启动护卫配置表: Boss战斗启动护卫配置[] = [
  单位nbdo战斗启动护卫配置,
  单位o000战斗启动护卫配置,
  单位N03O战斗启动护卫配置,
];

export * from "./01．水触须";
export * from "./02．奇妙鹿";
export * from "./03．嗜血兽人";
export * from "./04．水龙蛇";
export * from "./05．沙丘母虫";
export * from "./06．蜘蛛女皇";
export * from "./07．沙漠蜥蜴（变异）";
export * from "./08．蛇之领主-奢恩";
export * from "./09．蛇之遗迹看守者-奢隆";
export * from "./10．龙虾守卫";
export * from "./11．湖底元素";
export * from "./12．黑暗恶魔军官";
export * from "./13．恶魔看守者";
export * from "./14．恶魔领袖";
export * from "./15．熔岩恶魔";
