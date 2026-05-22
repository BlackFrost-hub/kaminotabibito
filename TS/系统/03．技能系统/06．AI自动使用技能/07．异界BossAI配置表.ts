/** @noSelfInFile */

import type { 单位AI配置 } from "./01．AI配置类型";
import { 创建单位AI配置 } from "./02．AI配置工具";

export const 异界BossAI配置表: 单位AI配置[] = [
  创建单位AI配置({
    AI配置ID: "神罗战士AI",
    单位名: "神罗战士",
    归类: "异界Boss",
    AI模式: "固定技能表",
    默认目标选择方式: "最高仇恨",
    说明: "异界Boss 单独成组，后续可在这里补阶段技能、主动技能和 override 策略。",
  }),
];
