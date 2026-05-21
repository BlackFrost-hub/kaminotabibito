/** @noSelfInFile */

import type { 升级属性加成配置, 物品升级规则 } from "./00．类型定义";

const { 生命之吻升级规则 } = require("系统.02．物品系统.15．装备技能.00．物品.116．生命之吻") as {
  生命之吻升级规则: 物品升级规则;
};

export const 单位升级属性加成配置表: readonly 升级属性加成配置[] = [
  { 属性名: "智力加成", 数值类型: "integer", 应用属性名: "智力" },
  { 属性名: "敏捷加成", 数值类型: "integer", 应用属性名: "敏捷" },
  { 属性名: "力量加成", 数值类型: "integer", 应用属性名: "力量" },
  { 属性名: "攻击力加成", 数值类型: "real", 应用属性名: "攻击力" },
] as const;

export const 物品升级规则表: readonly 物品升级规则[] = [
  生命之吻升级规则,
] as const;

export {};


const 物品升级配置列表: 物品升级规则[] = [];

export const 物品升级测试装备顺序 = [
  "生命之吻",
] as const;
export const 物品升级测试命令列表 = [
  "wp116", 
] as const;