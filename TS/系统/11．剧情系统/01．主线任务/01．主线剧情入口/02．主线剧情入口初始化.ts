/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (this: void, s: string) => number;
};
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};
const { TriggerRegisterEnterRectSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterEnterRectSimple: (this: void, trig: any, r: any) => any;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 查找主线剧情片段 } = require("../02．剧情步骤/02．剧情步骤播放器") as {
  查找主线剧情片段: (this: void, 片段ID: string) => any;
};
const { 播放主线剧情片段 } = require("../02．剧情步骤/02．剧情步骤播放器") as {
  播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
};

import {
  主线NPC初始化延迟秒,
  主线NPC初始化配置表,
  主线剧情全局单位入口配置表,
  主线剧情单位范围入口配置表,
  主线剧情可破坏物初始化配置表,
  主线剧情矩形入口配置表,
} from "./01．主线NPC初始化配置表";
import type { 主线NPC初始化配置, 主线剧情入口配置 } from "./00．主线剧情入口类型";
import { 读取剧情进度 } from "../00．剧情系统核心工具/01．剧情动作上下文";
import { 初始化进度01_精灵村长老发布任务核心 } from "../02．剧情步骤/00．主线剧情/01．精灵村长老发布任务";
import { 初始化进度02_地精洞窟进入演出核心 } from "../02．剧情步骤/00．主线剧情/02．地精洞窟进入演出";
import { 初始化进度03_地精祭祀Boss前导核心 } from "../02．剧情步骤/00．主线剧情/03．地精祭祀Boss前导";
import { 初始化进度04_地精祭祀死亡演出核心 } from "../02．剧情步骤/00．主线剧情/04．地精祭祀死亡演出";
import { 初始化进度05_击败地精返回长老核心 } from "../02．剧情步骤/00．主线剧情/05．击败地精返回长老";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const CreateTimer = jass.CreateTimer as (this: void) => any;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetExpiredTimer = jass.GetExpiredTimer as (this: void) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetTriggeringTrigger = jass.GetTriggeringTrigger as (this: void) => any;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const SetDestructableInvulnerable = jass.SetDestructableInvulnerable as (this: void, destructable: any, flag: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;
const TriggerRegisterUnitInRange = jass.TriggerRegisterUnitInRange as (this: void, trig: any, whichUnit: any, range: number, filter: any) => any;
const 中立被动玩家ID = 15;
let 已请求初始化主线剧情入口 = false;
let 已执行初始化主线剧情入口 = false;
const NPC运行时表: Record<string, any> = {};
const 入口配置By触发器ID: Record<string, 主线剧情入口配置> = {};


function 获取全局句柄(this: void, 变量名: string): any {
  return jglobals[变量名];
}

function 读取已绑定NPC(this: void, 配置: 主线NPC初始化配置): any {
  if (配置.YD表 == null || 配置.YD键 == null || 配置.YD字段 == null) return undefined;
  const unit = YDUserDataGetSafe("string", 配置.YD表, 配置.YD键, 配置.YD类型 ?? "unit");
  return unit == null || unit === 0 ? undefined : unit;
}

function 写入NPC绑定(this: void, 配置: 主线NPC初始化配置, unit: any): void {
  if (配置.YD表 == null || 配置.YD键 == null || 配置.YD字段 == null) return;
  YDUserDataSetSafe("string", 配置.YD表, 配置.YD键, 配置.YD类型 ?? "unit", unit);
}

function 记录NPC运行时(this: void, 配置: 主线NPC初始化配置, unit: any): void {
  if (unit == null || unit === 0) return;
  NPC运行时表[配置.配置名] = unit;
}

function 初始化单个NPC(this: void, 配置: 主线NPC初始化配置): void {
  let unit = 读取已绑定NPC(配置);
  if (unit == null) {
    unit = CreateUnit(Player(配置.玩家ID ?? 中立被动玩家ID), stringToFourCC(配置.单位ID), 配置.X, 配置.Y, 配置.朝向);
    写入NPC绑定(配置, unit);
  }
  记录NPC运行时(配置, unit);
}

function 记录入口触发器配置(this: void, trigger: any, 配置: 主线剧情入口配置): void {
  if (trigger == null) return;
  入口配置By触发器ID[tostring(GetHandleId(trigger))] = 配置;
}

function 剧情进度满足入口配置(this: void, 配置: 主线剧情入口配置): boolean {
  const 当前剧情进度 = 读取剧情进度();
  if (配置.需要剧情进度 != null && 当前剧情进度 !== 配置.需要剧情进度) return false;
  if (配置.最低剧情进度 != null && 当前剧情进度 < 配置.最低剧情进度) return false;
  if (配置.最高剧情进度 != null && 当前剧情进度 > 配置.最高剧情进度) return false;
  return true;
}

function 触发单位满足入口物品配置(this: void, 配置: 主线剧情入口配置, 触发单位: any): boolean {
  if (配置.需要物品名 == null || 配置.需要物品名 === "") return true;
  if (触发单位 == null || 触发单位 === 0) return false;
  const 物品类型ID = stringToFourCCSafe(按名字反查物品ID(配置.需要物品名));
  if (!(物品类型ID > 0)) return false;
  return UnitHasItemOfTypeBJ(触发单位, 物品类型ID);
}

function on主线剧情入口触发(this: void): void {
  const trigger = GetTriggeringTrigger();
  if (trigger == null) return;
  const 配置 = 入口配置By触发器ID[tostring(GetHandleId(trigger))];
  if (配置 == null || 配置.剧情片段ID == null) return;
  if (!剧情进度满足入口配置(配置)) return;
  const 触发单位 = GetTriggerUnit();
  if (!触发单位满足入口物品配置(配置, 触发单位)) return;

  const 片段 = 查找主线剧情片段(配置.剧情片段ID);
  if (片段 == null) return;

  YDUserDataSetSafe("string", "主线剧情入口", "触发配置", "string", 配置.配置名);
  YDUserDataSetSafe("string", "主线剧情入口", "剧情片段ID", "string", 配置.剧情片段ID);
  if (触发单位 != null) {
    YDUserDataSetSafe("string", "主线剧情入口", "触发单位", "unit", 触发单位);
  }
  播放主线剧情片段(配置.剧情片段ID, {
    片段ID: 配置.剧情片段ID,
    触发配置名: 配置.配置名,
    触发单位,
  });
}

function 创建入口触发器(this: void, 配置: 主线剧情入口配置): any {
  const trigger = CreateTrigger();
  记录入口触发器配置(trigger, 配置);
  TriggerAddAction(trigger, on主线剧情入口触发);
  return trigger;
}

function 初始化单位范围入口(this: void): void {
  for (let i = 0; i < 主线剧情单位范围入口配置表.length; i++) {
    const 配置 = 主线剧情单位范围入口配置表[i];
    const unit = NPC运行时表[配置.NPC配置名];
    if (unit == null) continue;
    TriggerRegisterUnitInRange(创建入口触发器(配置), unit, 配置.注册范围, null);
  }
}

function 初始化矩形入口(this: void): void {
  for (let i = 0; i < 主线剧情矩形入口配置表.length; i++) {
    const 配置 = 主线剧情矩形入口配置表[i];
    const 矩形 = 获取全局句柄(配置.矩形变量名);
    if (矩形 == null) continue;
    TriggerRegisterEnterRectSimple(创建入口触发器(配置), 矩形);
  }
}

function 初始化全局单位入口(this: void): void {
  for (let i = 0; i < 主线剧情全局单位入口配置表.length; i++) {
    const 配置 = 主线剧情全局单位入口配置表[i];
    const unit = 获取全局句柄(配置.单位变量名);
    if (unit == null) continue;
    TriggerRegisterUnitInRange(创建入口触发器(配置), unit, 配置.注册范围, null);
  }
}

function 初始化可破坏物(this: void): void {
  for (let i = 0; i < 主线剧情可破坏物初始化配置表.length; i++) {
    const 配置 = 主线剧情可破坏物初始化配置表[i];
    const destructable = 获取全局句柄(配置.变量名);
    if (destructable == null) continue;
    SetDestructableInvulnerable(destructable, 配置.无敌);
  }
}

function on主线剧情入口延迟初始化(this: void): void {
  if (已执行初始化主线剧情入口) return;
  已执行初始化主线剧情入口 = true;

  for (let i = 0; i < 主线NPC初始化配置表.length; i++) {
    初始化单个NPC(主线NPC初始化配置表[i]);
  }
  初始化单位范围入口();
  初始化矩形入口();
  初始化全局单位入口();
  初始化可破坏物();
  初始化进度01_精灵村长老发布任务核心();
  初始化进度02_地精洞窟进入演出核心();
  初始化进度03_地精祭祀Boss前导核心();
  初始化进度04_地精祭祀死亡演出核心();
  初始化进度05_击败地精返回长老核心();
}

function on主线剧情入口延迟初始化并销毁计时器(this: void): void {
  on主线剧情入口延迟初始化();
  safeDestroyTimer(GetExpiredTimer());
}

export function 初始化主线剧情入口(this: void): void {
  if (已请求初始化主线剧情入口) return;
  已请求初始化主线剧情入口 = true;

  const timer = CreateTimer();
  safeTimerStart(timer, 主线NPC初始化延迟秒, false, on主线剧情入口延迟初始化并销毁计时器);
}

export function 立即初始化主线剧情入口_兼容旧JASS数据(this: void): void {
  on主线剧情入口延迟初始化();
}
