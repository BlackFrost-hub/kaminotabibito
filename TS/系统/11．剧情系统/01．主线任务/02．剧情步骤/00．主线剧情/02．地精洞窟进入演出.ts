/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { CinematicModeBJ, CinematicFilterGenericBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  CinematicModeBJ: (this: void, cineMode: boolean, forForce: any) => void;
  CinematicFilterGenericBJ: (
    this: void,
    duration: number,
    bmode: any,
    tex: string,
    red0: number,
    green0: number,
    blue0: number,
    trans0: number,
    red1: number,
    green1: number,
    blue1: number,
    trans1: number,
  ) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { TriggerRegisterEnterRectSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterEnterRectSimple: (this: void, trig: any, r: any) => any;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度, 写入当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 播放主线剧情片段 } from "../02．剧情步骤播放器";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const IsUnitInGroup = jass.IsUnitInGroup as (this: void, whichUnit: any, whichGroup: any) => boolean;
const SetTimeOfDay = jass.SetTimeOfDay as (this: void, time: number) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;

let 已初始化进度02核心 = false;
let 已触发地精洞窟演出 = false;

function 触发单位是玩家英雄(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  return 玩家英雄组 != null && 玩家英雄组 !== 0 && IsUnitInGroup(unit, 玩家英雄组);
}

function on地精洞窟进入触发(this: void): void {
  if (已触发地精洞窟演出) return;
  const 触发单位 = GetTriggerUnit();
  if (!触发单位是玩家英雄(触发单位)) return;
  if (读取剧情进度() !== 1) return;

  const 片段ID = "jlc_goblin_cave_intro";
  写入当前剧情动作上下文({ 片段ID, 触发配置名: "地精洞窟进入演出核心", 触发单位 });
  if (播放主线剧情片段(片段ID, { 片段ID, 触发配置名: "地精洞窟进入演出核心", 触发单位 })) {
    已触发地精洞窟演出 = true;
  }
}

export function 执行地精洞窟演出前置(this: void, 参数: 剧情动作参数表): void {
  SetTimeOfDay(0);
  CinematicModeBJ(true, GetPlayersAll());
  CinematicFilterGenericBJ(2, 1, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 50, 50, 50, 50, 0, 0, 0, 0);
}

export const 地精洞窟进入演出剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_地精洞窟演出前置": 执行地精洞窟演出前置,
};

export function 初始化进度02_地精洞窟进入演出核心(this: void): void {
  if (已初始化进度02核心) return;
  已初始化进度02核心 = true;

  const rect = jglobals.gg_rct______________020;
  if (rect == null || rect === 0) return;
  const trigger = CreateTrigger();
  TriggerRegisterEnterRectSimple(trigger, rect);
  TriggerAddAction(trigger, on地精洞窟进入触发);
}
