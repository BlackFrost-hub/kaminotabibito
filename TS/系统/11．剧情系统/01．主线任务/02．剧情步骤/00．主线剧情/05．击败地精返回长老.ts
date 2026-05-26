/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { TriggerRegisterUnitInRangeSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterUnitInRangeSimple: (this: void, trig: any, range: number, whichUnit: any) => any;
};
const { SetUnitFacingToFaceUnitTimed } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitFacingToFaceUnitTimed: (this: void, whichUnit: any, target: any, duration: number) => void;
};
const { YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEAngleBetweenUnitsSafe: (this: void, fromUnit: any, toUnit: any) => number;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度, 写入当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 写入剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 播放主线剧情片段 } from "../02．剧情步骤播放器";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const IsUnitInGroup = jass.IsUnitInGroup as (this: void, whichUnit: any, whichGroup: any) => boolean;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const SetUnitFacingTimed = jass.SetUnitFacingTimed as (this: void, whichUnit: any, facing: number, duration: number) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;

let 已初始化进度05核心 = false;

function 触发单位是玩家英雄(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  return 玩家英雄组 != null && 玩家英雄组 !== 0 && IsUnitInGroup(unit, 玩家英雄组);
}

function on击败地精返回长老触发(this: void): void {
  const 触发单位 = GetTriggerUnit();
  if (!触发单位是玩家英雄(触发单位)) return;
  if (读取剧情进度() !== 4) return;

  const 片段ID = "jlc_goblin_defeated_return_elder";
  写入当前剧情动作上下文({ 片段ID, 触发配置名: "击败地精返回长老核心", 触发单位 });
  播放主线剧情片段(片段ID, { 片段ID, 触发配置名: "击败地精返回长老核心", 触发单位 });
}

export function 执行击败地精回村前置(this: void, 参数: 剧情动作参数表): void {
  if (typeof 参数.设置剧情进度 === "number") {
    写入剧情进度(参数.设置剧情进度);
  }
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  const 长老单位 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
  if (触发单位 != null && 触发单位 !== 0) {
    IssueImmediateOrder(触发单位, "stop");
  }
  if (触发单位 != null && 触发单位 !== 0 && 长老单位 != null && 长老单位 !== 0) {
    SetUnitFacingToFaceUnitTimed(触发单位, 长老单位, Number(参数.触发单位转向耗时) || 1);
    SetUnitFacingTimed(长老单位, YDWEAngleBetweenUnitsSafe(长老单位, 触发单位), Number(参数.长老转向耗时) || 1);
  }
}

export const 击败地精返回长老剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵村_击败地精回村前置": 执行击败地精回村前置,
};

export function 初始化进度05_击败地精返回长老核心(this: void): void {
  if (已初始化进度05核心) return;
  已初始化进度05核心 = true;

  const 长老单位 = YDUserDataGetSafe("string", "主线NPC", "精灵村长老", "unit");
  if (长老单位 == null || 长老单位 === 0) return;
  const trigger = CreateTrigger();
  TriggerRegisterUnitInRangeSimple(trigger, 800, 长老单位);
  TriggerAddAction(trigger, on击败地精返回长老触发);
}
