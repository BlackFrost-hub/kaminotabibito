import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 设置触发单位控制状态, 停止触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";

export { 巨魔首领战前剧情片段 } from "../02．第二章/26．巨魔首领战前";

export function 执行巨魔首领战前(this: void): void {
  停止触发单位();
  设置触发单位控制状态(true, false);
}

export function 执行巨魔首领开战承接(this: void): void {
  设置触发单位控制状态(false, false);
}

export const 巨魔首领战前剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_巨魔首领战前": 执行巨魔首领战前,
  "JLC精灵城_巨魔首领开战承接": 执行巨魔首领开战承接,
};
