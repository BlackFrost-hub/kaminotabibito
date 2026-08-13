/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { 获取矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  获取矩形区域: (this: void, 名称: string) => any;
};

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 玩家主副背包持有物品 } = require("系统.03．技能系统.04．快捷键技能.02．按Ctrl切换背包") as {
  玩家主副背包持有物品: (this: void, hero: any, itemTypeId: number) => boolean;
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
const { registerUnitInRangeTrigger } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerUnitInRangeTrigger: (this: void, trigger: any, unit: any, range: number, filter?: any, once?: boolean) => () => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 登记外部任务NPC单位 } = require("系统.08．任务系统.00．配置表.04．NPC生成器") as {
  登记外部任务NPC单位: (this: void, 任务ID: number, 单位: any) => boolean;
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
import type {
  主线NPC初始化配置,
  主线剧情入口分支配置,
  主线剧情入口配置,
  主线剧情全局单位入口配置,
} from "./00．主线剧情入口类型";
import { 创建剧情NPC单位 } from "../../00．公共/02．剧情NPC创建";
import { 读取剧情进度 } from "../00．剧情系统核心工具/01．剧情动作上下文";
import { 注册剧情运行时单位 } from "../00．剧情系统核心工具/08．剧情运行时单位";
import { 初始化进度01_精灵村长老发布任务核心 } from "../02．剧情步骤/00．主线剧情/01．精灵村长老发布任务";
import { 初始化进度02_地精洞窟进入演出核心 } from "../02．剧情步骤/00．主线剧情/02．地精洞窟进入演出";
import { 初始化进度03_地精祭祀Boss前导核心 } from "../02．剧情步骤/00．主线剧情/03．地精祭祀Boss前导";
import { 初始化进度04_地精祭祀死亡演出核心 } from "../02．剧情步骤/00．主线剧情/04．地精祭祀死亡演出";
import { 初始化进度05_击败地精返回长老核心 } from "../02．剧情步骤/00．主线剧情/05．击败地精返回长老";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetTriggeringTrigger = jass.GetTriggeringTrigger as (this: void) => any;
const SetDestructableInvulnerable = jass.SetDestructableInvulnerable as (this: void, destructable: any, flag: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;
const DestroyTrigger = jass.DestroyTrigger as (this: void, trig: any) => void;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (this: void, playerId: number) => any;
let 已请求初始化主线剧情入口 = false;
let 已执行初始化主线剧情入口 = false;
const NPC运行时表: Record<string, any> = {};
const 触发器ID对应入口配置列表: Record<string, 主线剧情入口分支配置[]> = {};
const 动态入口单位表: Record<string, any> = {};


function 获取全局句柄(this: void, 变量名: string): any {
  return jglobals[变量名];
}

function 记录NPC运行时(this: void, 配置: 主线NPC初始化配置, unit: any): void {
  if (unit == null || unit === 0) return;
  NPC运行时表[配置.配置名] = unit;
  注册剧情运行时单位(`主线NPC.${配置.配置名}`, unit);
  if (配置.任务NPC任务ID != null) {
    登记外部任务NPC单位(配置.任务NPC任务ID, unit);
  }
}

function 初始化单个NPC(this: void, 配置: 主线NPC初始化配置): void {
  const unit = 创建剧情NPC单位(配置);
  if (unit == null) return;
  记录NPC运行时(配置, unit);
}

function 记录入口触发器配置(this: void, trigger: any, 配置列表: 主线剧情入口分支配置[]): void {
  if (trigger == null) return;
  触发器ID对应入口配置列表[tostring(GetHandleId(trigger))] = 配置列表;
}

function 剧情进度满足入口配置(this: void, 配置: 主线剧情入口分支配置): boolean {
  const 当前剧情进度 = 读取剧情进度();
  if (配置.需要剧情进度 != null && 当前剧情进度 !== 配置.需要剧情进度) return false;
  if (配置.最低剧情进度 != null && 当前剧情进度 < 配置.最低剧情进度) return false;
  if (配置.最高剧情进度 != null && 当前剧情进度 > 配置.最高剧情进度) return false;
  return true;
}

function 触发单位满足入口物品配置(this: void, 配置: 主线剧情入口分支配置, 触发单位: any): boolean {
  if (配置.需要物品名 == null || 配置.需要物品名 === "") return true;
  if (触发单位 == null || 触发单位 === 0) return false;
  const 物品类型ID = stringToFourCCSafe(按名字反查物品ID(配置.需要物品名));
  if (!(物品类型ID > 0)) return false;
  return 玩家主副背包持有物品(触发单位, 物品类型ID);
}

function 触发单位满足玩家英雄配置(this: void, _配置: 主线剧情入口分支配置, 触发单位: any): boolean {
  // 主线的矩形与单位范围入口统一只接受已注册玩家英雄，避免召唤物、NPC 或小怪推进剧情。
  return 触发单位 != null && 触发单位 !== 0 && 是玩家英雄组单位(触发单位);
}

function 尝试播放入口配置(this: void, 配置: 主线剧情入口分支配置, 触发单位: any): boolean {
  if (配置 == null || 配置.剧情片段ID == null) return false;
  if (配置.运行时条件 != null && !配置.运行时条件()) return false;
  if (!剧情进度满足入口配置(配置)) return false;
  if (!触发单位满足玩家英雄配置(配置, 触发单位)) return false;
  if (!触发单位满足入口物品配置(配置, 触发单位)) return false;

  const 片段 = 查找主线剧情片段(配置.剧情片段ID);
  if (片段 == null) return false;

  YDUserDataSetSafe("string", "主线剧情入口", "触发配置", "string", 配置.配置名);
  YDUserDataSetSafe("string", "主线剧情入口", "剧情片段ID", "string", 配置.剧情片段ID);
  if (触发单位 != null) {
    YDUserDataSetSafe("string", "主线剧情入口", "触发单位", "unit", 触发单位);
  }
  return 播放主线剧情片段(配置.剧情片段ID, {
    片段ID: 配置.剧情片段ID,
    触发配置名: 配置.配置名,
    触发单位,
  });
}

function on主线剧情入口触发(this: void): void {
  const trigger = GetTriggeringTrigger();
  if (trigger == null) return;
  const 配置列表 = 触发器ID对应入口配置列表[tostring(GetHandleId(trigger))];
  if (配置列表 == null) return;

  const 触发单位 = GetTriggerUnit();
  for (let i = 0; i < 配置列表.length; i++) {
    if (!尝试播放入口配置(配置列表[i], 触发单位)) continue;
    if (配置列表[i].触发后注销 === true) {
      delete 触发器ID对应入口配置列表[tostring(GetHandleId(trigger))];
      DestroyTrigger(trigger);
    }
    return;
  }
}

function 创建入口触发器(this: void, 配置列表: 主线剧情入口分支配置[]): any {
  const trigger = CreateTrigger();
  记录入口触发器配置(trigger, 配置列表);
  TriggerAddAction(trigger, on主线剧情入口触发);
  return trigger;
}

/** 为剧情中途创建或重新布置的 NPC 动态注册主线范围入口。 */
export function 注册主线剧情运行时单位范围入口(
  this: void,
  unit: any,
  配置: 主线剧情入口分支配置,
): (this: void) => void {
  if (unit == null || unit === 0 || !(配置.注册范围 != null && 配置.注册范围 > 0)) {
    return function 空范围入口清理(this: void): void {};
  }
  const trigger = 创建入口触发器([配置]);
  return registerUnitInRangeTrigger(trigger, unit, 配置.注册范围, null, false);
}

function 展开入口剧情分支(this: void, 配置: 主线剧情入口配置): 主线剧情入口分支配置[] {
  const 分支列表 = 配置.剧情进度分支;
  if (分支列表 != null && 分支列表.length > 0) return 分支列表;
  return [配置];
}

function 初始化单位范围入口(this: void): void {
  for (let i = 0; i < 主线剧情单位范围入口配置表.length; i++) {
    const 配置 = 主线剧情单位范围入口配置表[i];
    const unit = NPC运行时表[配置.NPC配置名];
    if (unit == null) continue;
    const 分支列表 = 展开入口剧情分支(配置);
    for (let j = 0; j < 分支列表.length; j++) {
      const 分支 = 分支列表[j];
      registerUnitInRangeTrigger(创建入口触发器([分支]), unit, 分支.注册范围 ?? 配置.注册范围, null, false);
    }
  }
}

function 初始化矩形入口(this: void): void {
  for (let i = 0; i < 主线剧情矩形入口配置表.length; i++) {
    const 配置 = 主线剧情矩形入口配置表[i];
    const 矩形 = 获取矩形区域(配置.矩形区域名称);
    if (矩形 == null) continue;
    TriggerRegisterEnterRectSimple(创建入口触发器(展开入口剧情分支(配置)), 矩形);
  }
}

function 初始化全局单位入口(this: void): void {
  for (let i = 0; i < 主线剧情全局单位入口配置表.length; i++) {
    const 配置 = 主线剧情全局单位入口配置表[i];
    if (配置.动态创建 != null) continue;
    if (配置.单位变量名 == null || 配置.单位变量名 === "") continue;
    const unit = 获取全局句柄(配置.单位变量名);
    if (unit == null) continue;
    registerUnitInRangeTrigger(创建入口触发器(展开入口剧情分支(配置)), unit, 配置.注册范围, null, false);
  }
}

function 查找全局单位入口配置(this: void, 配置名: string): 主线剧情全局单位入口配置 | undefined {
  for (let i = 0; i < 主线剧情全局单位入口配置表.length; i++) {
    const 配置 = 主线剧情全局单位入口配置表[i];
    if (配置.配置名 === 配置名) return 配置;
  }
  return undefined;
}

/** 动态创建并注册需要在剧情节点出现的全局单位入口。 */
export function 动态创建并注册主线剧情全局单位入口(this: void, 配置名: string): any {
  const 已创建单位 = 动态入口单位表[配置名];
  if (已创建单位 != null && 已创建单位 !== 0) return 已创建单位;

  const 配置 = 查找全局单位入口配置(配置名);
  if (配置 == null || 配置.动态创建 == null) return null;
  const 动态配置 = 配置.动态创建;
  const unitTypeId = stringToFourCCSafe(动态配置.单位ID);
  if (!(unitTypeId > 0)) return null;

  const unit = CreateUnit(Player(Math.max(0, 动态配置.玩家ID - 1)), unitTypeId, 动态配置.X, 动态配置.Y, 动态配置.朝向);
  if (unit == null || unit === 0) return null;
  动态入口单位表[配置名] = unit;
  if (配置.单位变量名 != null && 配置.单位变量名 !== "") jglobals[配置.单位变量名] = unit;

  const trigger = 创建入口触发器(展开入口剧情分支(配置));
  registerUnitInRangeTrigger(trigger, unit, 配置.注册范围, null, 配置.触发后注销 === true);
  return unit;
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

function on主线剧情入口延迟初始化到时(this: void): void {
  on主线剧情入口延迟初始化();
}

export function 初始化主线剧情入口(this: void): void {
  if (已请求初始化主线剧情入口) return;
  已请求初始化主线剧情入口 = true;

  addDelayedCallback(主线NPC初始化延迟秒 * 1000, on主线剧情入口延迟初始化到时);
}

export function 立即初始化主线剧情入口_兼容旧JASS数据(this: void): void {
  on主线剧情入口延迟初始化();
}
