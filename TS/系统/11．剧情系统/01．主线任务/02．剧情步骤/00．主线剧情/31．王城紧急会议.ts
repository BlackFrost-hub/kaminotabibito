import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 停止触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";

export { 王城紧急会议剧情片段 } from "../02．第二章/31．王城紧急会议";

export function 执行紧急会议(this: void): void {
  停止触发单位();
}

export const 王城紧急会议剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_紧急会议": 执行紧急会议,
};
