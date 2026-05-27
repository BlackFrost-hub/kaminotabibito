const jglobals = require("jass.globals") as any;

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 发送剧情任务消息 } from "../../00．剧情系统核心工具/02．剧情动作桥接";
export { 章节末战后承接剧情片段 } from "../02．第二章/33．第二章王子Boss战后承接";

const bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING as number;

export function 执行章节末长对白承接(this: void, 参数: 剧情动作参数表): void {
  写入剧情进度(Number(参数.设置剧情进度) || Number(参数.目标进度) || 33);
}

export function 执行章节末紧急警告(this: void, 参数: 剧情动作参数表): void {
  发送剧情任务消息({
    消息类型: bj_QUESTMESSAGE_WARNING,
    文本: String(参数.文本 ?? ""),
  });
}

export const 第二章王子Boss战后承接剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_章节末长对白承接": 执行章节末长对白承接,
  "SW01死亡事件_章节末紧急警告": 执行章节末紧急警告,
};
