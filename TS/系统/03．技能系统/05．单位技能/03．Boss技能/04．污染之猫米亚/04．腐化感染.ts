/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";

export function 添加米亚腐化感染(this: void, context: 米亚运行时上下文, 单位: any, 层数: number, 来源: string): number {
  return context.腐化层数控制器.增加(单位, 层数, 来源);
}

export function 取米亚腐化感染层数(this: void, context: 米亚运行时上下文, 单位: any): number {
  return context.腐化层数控制器.取层数(单位);
}

export function 清空米亚腐化感染(this: void, context: 米亚运行时上下文, 单位: any, 原因: string): void {
  context.腐化层数控制器.清空(单位, 原因);
}

export function 注册米亚腐化感染机制(this: void): void {
  // 伤害提高、治疗降低和表现切换在这里接入，避免散落到各个技能文件。
}
