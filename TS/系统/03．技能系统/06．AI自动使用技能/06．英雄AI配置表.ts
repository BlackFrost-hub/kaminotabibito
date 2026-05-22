/** @noSelfInFile */

import type { 单位AI配置 } from "./01．AI配置类型";
import { 创建单位AI配置 } from "./02．AI配置工具";

export const 英雄AI配置表: 单位AI配置[] = [
  创建单位AI配置({
    AI配置ID: "cloudAI",
    单位名: "cloud",
    归类: "英雄",
    AI模式: "固定技能表",
    默认目标选择方式: "最高仇恨",
    说明: "当前先保留 AI 配置占位；后续如果敌方英雄版 cloud 需要自动施法，可在这里补策略。",
  }),
];
