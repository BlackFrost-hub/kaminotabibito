import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 停止触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";

export { 魔法信件汇报剧情片段 } from "../02．第二章/29．魔法信件汇报";

export function 执行魔法信件汇报(this: void): void {
  停止触发单位();
}

function 执行前往赫克提尔(this: void): void {}

export const 魔法信件汇报剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_魔法信件汇报": 执行魔法信件汇报,
  "JLC精灵城_前往赫克提尔": 执行前往赫克提尔,
};
