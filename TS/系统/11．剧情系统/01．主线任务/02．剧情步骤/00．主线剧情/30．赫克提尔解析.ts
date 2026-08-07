const jglobals = require("jass.globals") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 移除玩家主副背包物品 } = require("系统.03．技能系统.04．快捷键技能.02．按Ctrl切换背包") as {
  移除玩家主副背包物品: (this: void, hero: any, itemTypeId: number) => boolean;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 停止触发单位, 读取触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 发送剧情任务消息 } from "../../00．剧情系统核心工具/02．剧情动作桥接";

export { 赫克提尔解析信件剧情片段 } from "../02．第二章/30．赫克提尔解析";

const bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING as number;
const 残缺魔法信件物品ID = stringToFourCCSafe("I0ES");

export function 执行赫克提尔解析信件(this: void): void {
  停止触发单位();
  const 触发单位 = 读取触发单位();
  if (触发单位 == null || 触发单位 === 0 || !(残缺魔法信件物品ID > 0)) return;
  移除玩家主副背包物品(触发单位, 残缺魔法信件物品ID);
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
