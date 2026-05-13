/** @noSelfInFile */
/**
 * 仇恨面板 - 共享模块
 *
 * 包含 jass/japi 绑定、接口定义、状态容器和工具函数。
 */

const japi = require("jass.japi") as any;
const jass = require("jass.common") as any;

import {
  THREAT_PANEL_PLAYER_UNIT_MAX_PID,
  THREAT_PANEL_ROW_COUNT,
} from "./00．常量定义";
import { ThreatEntry } from "../../01．单位系统/06．仇恨系统/00．仇恨存储";
import { getSoleSelectedUnitForPlayer } from "../../00．核心系统/01．事件中心/05．玩家选中单位事件中心";

export const DzGetGameUI = japi.DzGetGameUI as () => number;
export const DzLoadToc = japi.DzLoadToc as (path: string) => void;
export const DzCreateFrame = japi.DzCreateFrame as (name: string, parent: number, id: number) => number;
export const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (
  type: string,
  name: string,
  parent: number,
  template: string,
  id: number
) => number;
export const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (
  frame: number,
  point: number,
  x: number,
  y: number
) => void;
export const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
export const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
export const DzFrameSetAlpha = japi.DzFrameSetAlpha as (frame: number, alpha: number) => void;
export const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
export const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
export const DzFrameSetFont = japi.DzFrameSetFont as (frame: number, path: string, size: number, flag: number) => void;
export const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment as (frame: number, align: number) => void;
export const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;

export const Player = jass.Player as (playerId: number) => any;
export const GetLocalPlayer = jass.GetLocalPlayer as () => any;
export const GetPlayerId = jass.GetPlayerId as (whichPlayer: any) => number;
export const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
export const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
export const GetUnitName = jass.GetUnitName as (whichUnit: any) => string;
export const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
export const IsUnitType = jass.IsUnitType as (whichUnit: any, whichType: any) => boolean;
export const R2I = jass.R2I as (value: number) => number;
export const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD;

export const ABS_BOTTOMLEFT = 6;
export const TEXT_ALIGN_CENTER = 18;
export const TEXT_ALIGN_LEFT = 2;
export const EMPTY_ROW = "|cff9f9f9f-|r";

export interface ThreatPanelFrames {
  root: number;
  inner: number;
  title: number;
  selected: number;
  summary: number;
  headerName: number;
  headerPercent: number;
  headerThreat: number;
  rowNames: number[];
  rowPercents: number[];
  rowThreats: number[];
}

export interface ThreatPanelViewModel {
  selectedText: string;
  summaryText: string;
  headerNameText: string;
  headerPercentText: string;
  headerThreatText: string;
  rowNameTexts: string[];
  rowPercentTexts: string[];
  rowThreatTexts: string[];
}

export const 玩家面板表: Record<number, ThreatPanelFrames | undefined> = {};
export const 玩家视图模型表: Record<number, ThreatPanelViewModel | undefined> = {};
export const 玩家上次有效敌方目标表: Record<number, any | undefined> = {};
export const 玩家面板显示状态表: Record<number, boolean | undefined> = {};

export function 单位是有效怪物单位(单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (GetUnitTypeId(单位) === 0) return false;
  if (IsUnitType(单位, UNIT_TYPE_DEAD)) return false;
  const 所有者 = GetOwningPlayer(单位);
  if (所有者 == null || 所有者 === 0) return false;
  const 玩家ID = GetPlayerId(所有者);
  return 玩家ID > THREAT_PANEL_PLAYER_UNIT_MAX_PID;
}

export function 获取单位所有者玩家ID(单位: any): number {
  if (单位 == null || 单位 === 0) return -1;
  const 所有者 = GetOwningPlayer(单位);
  if (所有者 == null || 所有者 === 0) return -1;
  return GetPlayerId(所有者);
}

export function 获取用于显示的目标单位(playerId: number): any | null {
  const 当前选中单位 = getSoleSelectedUnitForPlayer(playerId);
  if (当前选中单位 != null && 当前选中单位 !== 0) {
    if (单位是有效怪物单位(当前选中单位)) {
      玩家上次有效敌方目标表[playerId] = 当前选中单位;
      return 当前选中单位;
    }

    const 当前所有者玩家ID = 获取单位所有者玩家ID(当前选中单位);
    if (当前所有者玩家ID >= 0 && 当前所有者玩家ID <= THREAT_PANEL_PLAYER_UNIT_MAX_PID) {
      const 缓存单位 = 玩家上次有效敌方目标表[playerId];
      if (缓存单位 != null && 缓存单位 !== 0 && 单位是有效怪物单位(缓存单位)) {
        return 缓存单位;
      }
      return null;
    }

    return null;
  }

  return null;
}

export function 截断名称(name: string, maxLen: number): string {
  if (name == null || name.length <= maxLen) return name;
  return name.substring(0, maxLen) + "…";
}

export function 十倍精度文本(value: number): string {
  const 十倍整数 = R2I(value * 10 + 0.5);
  const 整数部分 = R2I(十倍整数 / 10);
  const 小数部分 = 十倍整数 - 整数部分 * 10;
  return `${整数部分}.${小数部分}`;
}

export function 百分比文本(仇恨值: number): string {
  return 十倍精度文本(仇恨值 / 10) + "%";
}

export function 按仇恨降序排序(entries: ThreatEntry[]): ThreatEntry[] {
  const result: ThreatEntry[] = [];
  for (let i = 0; i < entries.length; i++) {
    result.push(entries[i]);
  }
  for (let i = 0; i < result.length - 1; i++) {
    let bestIndex = i;
    for (let j = i + 1; j < result.length; j++) {
      if (result[j].threat > result[bestIndex].threat) {
        bestIndex = j;
      }
    }
    if (bestIndex !== i) {
      const temp = result[i];
      result[i] = result[bestIndex];
      result[bestIndex] = temp;
    }
  }
  return result;
}
