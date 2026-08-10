/** @noSelfInFile */

const jass = require("jass.common") as any;
const jassGlobals = require("jass.globals") as any;

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
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};
const { TriggerRegisterUnitInRangeSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterUnitInRangeSimple: (this: void, trig: any, range: number, whichUnit: any) => any;
};
const { 切换区域背景音乐表达式 } = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时") as {
  切换区域背景音乐表达式: (this: void, expr: string | undefined, add: boolean) => number;
};
const { TransmissionFromUnitWithNameBJ } = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  TransmissionFromUnitWithNameBJ: (
    this: void,
    toForce: any,
    whichUnit: any,
    unitName: string,
    soundHandle: any,
    message: string,
    timeType: number,
    timeVal: number,
    wait: boolean,
  ) => void;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 沙漠情报商人回收夜光翡翠剧情片段 } from "../01．第一章/15．夜光翡翠回收";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const CreateGroup = jass.CreateGroup as (this: void) => any;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const DestroyTrigger = jass.DestroyTrigger as (this: void, trig: any) => void;
const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, whichGroup: any) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetTriggeringTrigger = jass.GetTriggeringTrigger as (this: void) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetUnitName = jass.GetUnitName as (this: void, whichUnit: any) => string;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, whichGroup: any, whichUnit: any) => boolean;
const GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect as (this: void, whichGroup: any, whichRect: any, filter: any) => void;
const IsPlayerInForce = jass.IsPlayerInForce as (this: void, whichPlayer: any, whichForce: any) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const Rect = jass.Rect as (this: void, minX: number, minY: number, maxX: number, maxY: number) => any;
const RemoveRect = jass.RemoveRect as (this: void, whichRect: any) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, actionFunc: (this: void) => void) => any;

const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const bj_QUESTMESSAGE_WARNING = jassGlobals.bj_QUESTMESSAGE_WARNING as number;
const bj_TIMETYPE_SET = jassGlobals.bj_TIMETYPE_SET as number;
const 回村剧情片段ID = "jlc_return_village_after_guard_duel";
const 裂缝入口触发器列表: any[] = [];
let 裂缝入口生效时间毫秒 = 0;

function 是村内旧精灵护卫(this: void, unit: any): boolean {
  if (unit == null || unit === 0 || GetUnitTypeId(unit) !== stringToFourCCSafe("nhea")) return false;
  const 玩家组 = YDUserDataGetSafe("string", "玩家", "玩家组", "force");
  return 玩家组 != null && 玩家组 !== 0 && !IsPlayerInForce(GetOwningPlayer(unit), 玩家组);
}

function 清理村内旧精灵护卫(this: void): void {
  // 旧 全局矩形区域在部分运行路径已被释放；这里使用同范围临时矩形，避免清理动作打断剧情。
  const 矩形 = Rect(-30016, -30464, -22240, -26016);
  const 单位组 = CreateGroup();
  if (矩形 == null || 矩形 === 0 || 单位组 == null || 单位组 === 0) {
    if (矩形 != null && 矩形 !== 0) RemoveRect(矩形);
    if (单位组 != null && 单位组 !== 0) DestroyGroup(单位组);
    return;
  }
  GroupEnumUnitsInRect(单位组, 矩形, null);
  let unit = FirstOfGroup(单位组);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(单位组, unit);
    if (是村内旧精灵护卫(unit)) 立即移除单位并取消排泄登记(unit);
    unit = FirstOfGroup(单位组);
  }
  DestroyGroup(单位组);
  RemoveRect(矩形);
}

function 清理裂缝回村入口(this: void): void {
  for (let i = 裂缝入口触发器列表.length - 1; i >= 0; i--) {
    const trigger = 裂缝入口触发器列表[i];
    if (trigger != null && trigger !== 0) DestroyTrigger(trigger);
  }
  裂缝入口触发器列表.length = 0;
  裂缝入口生效时间毫秒 = 0;
}

function 清理语义单位(this: void, 表: string, 键: string): void {
  const unit = YDUserDataGetSafe("string", 表, 键, "unit");
  if (unit != null && unit !== 0) 立即移除单位并取消排泄登记(unit);
  YDUserDataClearTable("string", 表);
}

function 触发裂缝回村(this: void): void {
  const 当前进度 = Number(YDUserDataGetSafe("string", "剧情进度", "整数", "integer"));
  if (当前进度 !== 16) return;
  // 注册范围事件时，已经站在裂缝附近的英雄可能被引擎立即判定进入。
  // 延后一秒启用入口，防止 15 -> 16 收尾在创建裂缝的同一时点直接推进到 17。
  if (裂缝入口生效时间毫秒 <= 0 || getServerTime() < 裂缝入口生效时间毫秒) return;

  const 触发单位 = GetTriggerUnit();
  if (!是玩家英雄组单位(触发单位)) return;

  // 入口是一次性剧情资源；先销毁两处监听，避免同一帧或后续重复进入。
  const 当前触发器 = GetTriggeringTrigger();
  if (当前触发器 != null && 当前触发器 !== 0) {
    for (let i = 裂缝入口触发器列表.length - 1; i >= 0; i--) {
      if (裂缝入口触发器列表[i] === 当前触发器) 裂缝入口触发器列表.splice(i, 1);
    }
    DestroyTrigger(当前触发器);
  }
  清理裂缝回村入口();

  const 上下文 = {
    片段ID: 回村剧情片段ID,
    触发配置名: "裂缝回村入口",
    触发单位,
  };
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
  裂缝入口触发器列表.push(trigger);
}

export function 执行情报商人回收夜光翡翠(this: void, 参数: 剧情动作参数表): void {
  const 阶段 = String(参数.阶段 ?? "");
  if (阶段 === "准备") return;

  const 触发单位 = 读取当前剧情动作上下文().触发单位;
  if (阶段 === "交付") {
    if (触发单位 != null && 触发单位 !== 0) {
      EC_CreateEffect("war3mapImported\\BlueBalllight.mdl", GetUnitX(触发单位), GetUnitY(触发单位), 0, 270, 5, 1, 1.25);
    }
    return;
  }
  if (阶段 !== "收束") return;

  清理裂缝回村入口();
  清理语义单位("ZXCS", "DW");
  清理语义单位("ZXCS2", "DW");
  清理村内旧精灵护卫();

  const 裂缝类型ID = stringToFourCCSafe(按名字反查总单位ID("进入单位范围用"));
  if (!(裂缝类型ID > 0)) return;

  裂缝入口生效时间毫秒 = getServerTime() + 1000;
  const 裂缝A = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_PASSIVE), 裂缝类型ID, -27182.1, -25485.2, 0);
  const 裂缝B = 创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_PASSIVE), 裂缝类型ID, -24123.4, -26338.8, 0);

  if (裂缝A != null && 裂缝A !== 0) {
    YDUserDataSetSafe("string", "ZXCS", "DW", "unit", 裂缝A);
    注册裂缝回村入口(裂缝A);
  }
  if (裂缝B != null && 裂缝B !== 0) {
    YDUserDataSetSafe("string", "ZXCS2", "DW", "unit", 裂缝B);
    注册裂缝回村入口(裂缝B);
  }
}

function 切换区域音乐(this: void, 表达式: string, 添加: boolean): void {
  切换区域背景音乐表达式(表达式, 添加);
}

export function 执行章节末Boss战预警(this: void, 参数: 剧情动作参数表): void {
  const 触发单位 = 读取当前剧情动作上下文().触发单位;
  const 延迟秒数 = Number(参数.预警延迟秒数) || 4;
  const 预警文本 = String(参数.章节末预警文本 ?? "");
  const 延迟对白 = String(参数.预警延迟对白 ?? "");
  const 延迟对白持续时间 = Number(参数.预警延迟对白持续时间) || 2.5;
  addDelayedCallback(延迟秒数 * 1000, () => {
    if (预警文本 !== "") {
      QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_WARNING, 预警文本);
      QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_WARNING, 预警文本);
    }
    切换区域音乐(String(参数.预警停止区域音乐 ?? ""), false);
    切换区域音乐(String(参数.预警开始音乐 ?? ""), true);
    if (延迟对白 === "") return;
    addDelayedCallback(5000, () => {
      if (触发单位 == null || 触发单位 === 0) return;
      TransmissionFromUnitWithNameBJ(
        GetPlayersAll(),
        null,
        GetUnitName(触发单位),
        null,
        延迟对白,
        bj_TIMETYPE_SET,
        延迟对白持续时间,
        false,
      );
    });
  });
}

export const 夜光翡翠回收剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC沙漠_情报商人回收夜光翡翠": 执行情报商人回收夜光翡翠,
  "JLC沙漠_章节末Boss战预警": 执行章节末Boss战预警,
};
