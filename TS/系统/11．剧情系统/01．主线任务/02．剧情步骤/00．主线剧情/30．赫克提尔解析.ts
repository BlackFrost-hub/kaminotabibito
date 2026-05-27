const jglobals = require("jass.globals") as any;

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 停止触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 发送剧情任务消息 } from "../../00．剧情系统核心工具/02．剧情动作桥接";

export { 赫克提尔解析信件剧情片段 } from "../02．第二章/30．赫克提尔解析";

const bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING as number;

export function 执行赫克提尔解析信件(this: void): void {
  停止触发单位();
}

export function 执行敌袭紧急传讯警告(this: void, 参数: 剧情动作参数表): void {
  发送剧情任务消息({
    消息类型: bj_QUESTMESSAGE_WARNING,
    文本: String(参数.文本 ?? ""),
  });
}

export const 赫克提尔解析剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_赫克提尔解析信件": 执行赫克提尔解析信件,
  "JLC精灵城_敌袭紧急传讯警告": 执行敌袭紧急传讯警告,
};
