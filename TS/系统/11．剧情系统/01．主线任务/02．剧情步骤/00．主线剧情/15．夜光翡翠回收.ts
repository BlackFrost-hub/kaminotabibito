/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { YDUserDataClearTable } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataClearTable: (this: void, tableTypeName: string, tableKey: any) => void;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC特效") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};
const { TriggerRegisterUnitInRangeSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterUnitInRangeSimple: (this: void, trig: any, range: number, whichUnit: any) => any;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文, 写入当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 沙漠情报商人回收夜光翡翠剧情片段 } from "../01．第一章/15．夜光翡翠回收";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const IsUnitInGroup = jass.IsUnitInGroup as (this: void, whichUnit: any, whichGroup: any) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, whichUnit: any) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, actionFunc: (this: void) => void) => any;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const 回村剧情片段ID = "jlc_return_village_after_guard_duel";

function 清理语义单位(this: void, 表: string, 键: string): void {
  const unit = YDUserDataGetSafe("string", 表, 键, "unit");
  if (unit != null && unit !== 0) RemoveUnit(unit);
  YDUserDataClearTable("string", 表);
}

function 触发裂缝回村(this: void): void {
  const 当前进度 = Number(YDUserDataGetSafe("string", "剧情进度", "整数", "integer"));
  if (当前进度 !== 16) return;

  const 触发单位 = GetTriggerUnit();
  const 玩家英雄组 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
  if (玩家英雄组 != null && 玩家英雄组 !== 0 && !IsUnitInGroup(触发单位, 玩家英雄组)) return;

  const 上下文 = {
    片段ID: 回村剧情片段ID,
    触发配置名: "裂缝回村入口",
    触发单位,
  };
  写入当前剧情动作上下文(上下文);
  const { 播放主线剧情片段 } = require("../02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, id: string, 上下文?: any) => boolean;
  };
  播放主线剧情片段(回村剧情片段ID, 上下文);
}

function 注册裂缝回村入口(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  const trigger = CreateTrigger();
  TriggerRegisterUnitInRangeSimple(trigger, 300, unit);
  TriggerAddAction(trigger, 触发裂缝回村);
}

export function 执行情报商人回收夜光翡翠(this: void, 参数: 剧情动作参数表): void {
  清理语义单位("ZXCS", "DW");
  清理语义单位("ZXCS2", "DW");

  const 触发单位 = 读取当前剧情动作上下文().触发单位;
  if (触发单位 != null && 触发单位 !== 0) {
    EC_CreateEffect("war3mapImported\\BlueBalllight.mdl", GetUnitX(触发单位), GetUnitY(触发单位), 0, 270, 5, 1, 1.25);
  }

  const 裂缝类型ID = stringToFourCCSafe(按名字反查总单位ID("进入单位范围用"));
  if (!(裂缝类型ID > 0)) return;

  const 裂缝A = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 裂缝类型ID, -27182.1, -25485.2, 0);
  const 裂缝B = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 裂缝类型ID, -24123.4, -26338.8, 0);

  if (裂缝A != null && 裂缝A !== 0) {
    YDUserDataSetSafe("string", "ZXCS", "DW", "unit", 裂缝A);
    注册裂缝回村入口(裂缝A);
  }
  if (裂缝B != null && 裂缝B !== 0) {
    YDUserDataSetSafe("string", "ZXCS2", "DW", "unit", 裂缝B);
    注册裂缝回村入口(裂缝B);
  }
}

function 执行源石入手目标刷新(this: void): void {}

export const 夜光翡翠回收剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC沙漠_情报商人回收夜光翡翠": 执行情报商人回收夜光翡翠,
  "JLC沙漠_源石入手目标刷新": 执行源石入手目标刷新,
};
