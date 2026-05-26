import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 停止触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";

export { 第二章王子Boss战过程剧情片段 } from "../02．第二章/32．第二章王子Boss战过程";

export function 执行第二章王子Boss战前置(this: void): void {
  停止触发单位();
}

export const 第二章王子Boss战过程剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_第二章王子Boss战前置": 执行第二章王子Boss战前置,
};
