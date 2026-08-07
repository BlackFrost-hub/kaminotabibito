/** @noSelfInFile */

const jass = require("jass.common") as any;

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取触发单位, 设置触发单位控制状态 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
export { 精灵森谷传送抵达剧情片段 } from "../02．第二章/19．精灵森谷传送抵达";
const { 启用第二章精灵传送阵王城道中背景音乐 } = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐") as {
  启用第二章精灵传送阵王城道中背景音乐: (this: void) => boolean;
};
const { 单位是否存在其他暂停占用 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  单位是否存在其他暂停占用: (this: void, unit: any, 自身来源: string) => boolean;
};
const { StarOther_PanCameraToTimedForPlayer } = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (this: void, whichPlayer: any, x: number, y: number, duration: number) => void;
};

const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (this: void, whichPlayer: any, x: number, y: number, duration: number, message: string) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const SetUnitPosition = jass.SetUnitPosition as (this: void, whichUnit: any, x: number, y: number) => void;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const 触发单位控制暂停来源 = "剧情系统:触发单位控制";

export function 执行精灵森谷传送抵达(this: void, 参数: 剧情动作参数表): void {
  const 触发单位 = 读取触发单位();
  if (触发单位 == null || 触发单位 === 0) return;
  const 提示文本 = String(参数.提示文本 ?? "|cffffff00『系统提示』|r：现在的场景为：|cff339966『精灵森谷』|r");
  const 玩家 = GetOwningPlayer(触发单位);
  DisplayTimedTextToPlayer(玩家, 0, 0, 8.0, 提示文本);
  StarOther_PanCameraToTimedForPlayer(玩家, Number(参数.相机X) || -22835.7, Number(参数.相机Y) || -14874.0, 0);
  SetUnitPosition(触发单位, Number(参数.触发单位X) || -22835.7, Number(参数.触发单位Y) || -14874.0);
}

export function 执行启用精灵传送阵王城道中背景音乐(this: void): void {
  启用第二章精灵传送阵王城道中背景音乐();
}

/** 兼容旧 JASS/技能直接 PauseUnit(true) 留下的触发玩家暂停。 */
export function 执行精灵森谷传送抵达收尾(this: void): void {
  const 触发单位 = 读取触发单位();
  if (触发单位 == null || 触发单位 === 0) return;
  设置触发单位控制状态(false, false);
  if (!单位是否存在其他暂停占用(触发单位, 触发单位控制暂停来源)) {
    PauseUnit(触发单位, false);
  }
}

export const 精灵森谷传送抵达剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_传送阵抵达": 执行精灵森谷传送抵达,
  "第二章_启用精灵传送阵王城道中背景音乐": 执行启用精灵传送阵王城道中背景音乐,
  "JLC精灵城_传送阵抵达收尾": 执行精灵森谷传送抵达收尾,
};
