/** @noSelfInFile */

const jass = require("jass.common") as any;

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 设置触发单位控制状态 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 注册剧情片段清理 } from "../../00．剧情系统核心工具/13．剧情片段清理注册表";
export { 蛇人族交凭证剧情片段 } from "../01．第一章/13．蛇人族交还食人魔凭证";

const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;

export function 执行蛇人族交还食人魔凭证(this: void, 参数: 剧情动作参数表): void {
  const 触发单位 = 读取当前剧情动作上下文().触发单位;
  const 阶段 = String(参数.阶段 ?? "");
  if (阶段 === "进入") {
    if (触发单位 != null && 触发单位 !== 0) {
      IssueImmediateOrder(触发单位, "stop");
      设置触发单位控制状态(true, false);
    }
    return;
  }

  if (阶段 === "触发单位转向" && 触发单位 != null && 触发单位 !== 0) {
    SetUnitFacing(触发单位, Number(参数.朝向) || 200);
  }
}

注册剧情片段清理("jlc_snake_keeper_return_item", () => {
  设置触发单位控制状态(false, false);
});

export const 蛇人族交还食人魔凭证剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SRZ蛇人族_交还食人魔凭证": 执行蛇人族交还食人魔凭证,
};
