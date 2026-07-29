import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 清理剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 定位并登记王宫密室剧情单位, 王宫密室场景站位表, 播放王宫密室演出特效 } from "./33A．王宫密室场景单位";
export { 章节末最终收束剧情片段 } from "../02．第二章/34．第二章后续承接";

const jass = require("jass.common") as any;
const { YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};

const RemoveUnit = jass.RemoveUnit as (this: void, whichUnit: any) => void;

export function 执行章节末最终收束(this: void, 参数: 剧情动作参数表): void {
  写入剧情进度(Number(参数.设置剧情进度) || Number(参数.目标进度) || 35);
}

export function 执行布置王宫密室受伤现场(this: void): void {
  定位并登记王宫密室剧情单位("ZX.克林姆德王", "主线NPC.克林姆德王", 王宫密室场景站位表.克林姆德王受伤);
  定位并登记王宫密室剧情单位("ZX.赫克提尔", "主线NPC.赫克提尔", 王宫密室场景站位表.赫克提尔受伤);
}

export function 执行里科特战后撤离(this: void): void {
  播放王宫密室演出特效("里科特战后撤离", 王宫密室场景站位表.里科特密室);
  const 里科特 = 读取语义单位引用("Boss.里科特");
  if (里科特 != null && 里科特 !== 0) RemoveUnit(里科特);
  YDUserDataClearSafe("string", "Boss", "里科特", "unit");
  清理剧情运行时单位("Boss.里科特");
}

export const 第二章后续承接剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SW01死亡事件_章节末最终收束": 执行章节末最终收束,
  "JLC精灵城_布置王宫密室受伤现场": 执行布置王宫密室受伤现场,
  "JLC精灵城_里科特战后撤离": 执行里科特战后撤离,
};
