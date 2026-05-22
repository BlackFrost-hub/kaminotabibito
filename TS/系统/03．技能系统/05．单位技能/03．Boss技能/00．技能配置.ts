/** @noSelfInFile */

import { 创建单位技能配置 } from "../00．公共/01．技能配置工具";
import type { 单位技能配置 } from "../00．公共/00．技能配置类型";

export const Boss技能配置表: 单位技能配置[] = [
  创建单位技能配置({
    技能ID: "Boss示例",
    技能名: "Boss示例技能",
    归类: "Boss",
    触发方式: "初始化",
    说明: "占位示例，后续按实际 Boss 技能替换。",
  }),
];
