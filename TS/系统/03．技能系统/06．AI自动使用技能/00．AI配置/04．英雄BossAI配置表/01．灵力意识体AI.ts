/** @noSelfInFile */

import type { 单位AI配置 } from "../01．AI配置类型";
import { 创建单位AI配置 } from "../02．AI配置工具";

export const 灵力意识体AI配置: 单位AI配置 = 创建单位AI配置({
  AI配置ID: "灵力意识体AI",
  单位ID: "N05D",
  单位名: "灵力意识体",
  归类: "英雄Boss",
  AI模式: "固定技能表",
  默认目标选择方式: "最高仇恨",
  说明: "当前先保留 AI 配置占位；后续有主动技能或阶段技能时，在这里补施法策略。",
});
