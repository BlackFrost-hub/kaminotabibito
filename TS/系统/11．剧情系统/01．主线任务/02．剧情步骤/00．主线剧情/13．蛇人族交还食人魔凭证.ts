/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 蛇人族交凭证剧情片段 } from "../01．第一章/13．蛇人族交还食人魔凭证";

const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (this: void, whichUnit: any, order: string, x: number, y: number) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;

export function 执行蛇人族交还食人魔凭证(this: void, 参数: 剧情动作参数表): void {
  const 触发单位 = 读取当前剧情动作上下文().触发单位;
  if (触发单位 != null && 触发单位 !== 0) {
    IssueImmediateOrder(触发单位, "stop");
  }

  const 队长类型ID = stringToFourCCSafe("h01D");
  if (!(队长类型ID > 0)) return;
  const 队长 = CreateUnit(Player(6), 队长类型ID, -22935.9, 3154.3, 0);
  if (队长 == null || 队长 === 0) return;
  YDUserDataSetSafe("string", "主线NPC", "蛇人族卫队长", "unit", 队长);
  IssuePointOrder(队长, "move", Number(参数.目标X) || -21023.4, Number(参数.目标Y) || 3259.5);
}

export const 蛇人族交还食人魔凭证剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SRZ蛇人族_交还食人魔凭证": 执行蛇人族交还食人魔凭证,
};
