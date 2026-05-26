import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 章节末最终收束剧情片段 } from "../02．第二章/34．第二章后续承接";

export function 执行章节末最终收束(this: void, 参数: 剧情动作参数表): void {
  写入剧情进度(Number(参数.设置剧情进度) || Number(参数.目标进度) || 35);
}

function 执行章节末任务刷新(this: void): void {}

export const 第二章后续承接剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_章节末最终收束": 执行章节末最终收束,
  "JLC精灵城_章节末任务刷新": 执行章节末任务刷新,
};
