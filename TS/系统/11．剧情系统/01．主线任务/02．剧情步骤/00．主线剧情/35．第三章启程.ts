/** @noSelfInFile */

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 进入主线节点 } from "../../00．剧情系统核心工具/10．标准剧情动作";
import { 布置耶提尔战后奖励NPC } from "./31B．耶提尔协战控制器";
export { 王城战后与第三章启程剧情片段 } from "../03．第三章/35．王城战后与第三章启程";

export function 执行第三章启程布置(this: void, 参数: 剧情动作参数表): void {
  布置耶提尔战后奖励NPC();
  进入主线节点(Number(参数.节点进度) || 36);
}

export const 第三章启程剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_启程前往熔岩小镇": 执行第三章启程布置,
};
