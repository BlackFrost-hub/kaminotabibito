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
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";

type 播放主线剧情片段函数 = (this: void, 片段ID: string, 上下文?: any) => boolean;
let 播放主线剧情片段实现: 播放主线剧情片段函数 | undefined;

function 播放主线剧情片段(this: void, 片段ID: string, 上下文?: any): boolean {
  if (播放主线剧情片段实现 == null) {
    const 播放器模块 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
      播放主线剧情片段: 播放主线剧情片段函数;
    };
    播放主线剧情片段实现 = 播放器模块.播放主线剧情片段;
  }
  return 播放主线剧情片段实现(片段ID, 上下文);
}

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const DestroyTrigger = jass.DestroyTrigger as (this: void, trig: any) => void;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const SetUnitFacingTimed = jass.SetUnitFacingTimed as (this: void, whichUnit: any, facing: number, duration: number) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;

let 已初始化进度05核心 = false;
let 进度05范围触发器: any = null;

function on击败地精返回长老触发(this: void): void {
  const 触发单位 = GetTriggerUnit();
  if (!是玩家英雄组单位(触发单位)) return;
  if (读取剧情进度() !== 4) return;

  const 片段ID = "jlc_goblin_defeated_return_elder";
  const 已开始播放 = 播放主线剧情片段(片段ID, { 片段ID, 触发配置名: "击败地精返回长老核心", 触发单位 });
  if (已开始播放 && 进度05范围触发器 != null && 进度05范围触发器 !== 0) {
    DestroyTrigger(进度05范围触发器);
    进度05范围触发器 = null;
  }
}

export function 执行击败地精回村前置(this: void, 参数: 剧情动作参数表): void {
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
  进度05范围触发器 = trigger;
}
