/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, 延迟毫秒: number, 回调: (this: void) => void) => number;
};
const { registerEnterRegionTrigger } = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  registerEnterRegionTrigger: (this: void, 触发器: any, 区域: any, 过滤器?: any) => (this: void) => void;
};
const { safeTriggerAddAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, 触发器: any, 回调: (this: void) => void) => { readonly id: number } | null;
  safeDestroyTrigger: (this: void, 触发器: any) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, 单位: any, 来源: string) => boolean;
  移除单位暂停: (this: void, 单位: any, 来源: string) => boolean;
};
const { YDWEAngleBetweenUnitsSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWEAngleBetweenUnitsSafe: (this: void, 起点单位: any, 终点单位: any) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块: string, ...参数: any[]) => void;
};
const { 按配置键注册动态矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.02．动态矩形区域动作") as {
  按配置键注册动态矩形区域: (this: void, 键: string) => any;
};

import {
  莫特斯入口矩形配置键,
  莫特斯入口落点X,
  莫特斯入口落点Y,
  莫特斯入口落点面向,
  莫特斯洞窟守卫暂停范围,
  莫特斯洞窟守卫演出暂停来源,
  莫特斯模块名,
} from "./00．常量";
import {
  单位存活,
  句柄有效,
  取广播完整播放毫秒,
  打开莫特斯洞窟门,
  是莫特斯副本玩家英雄,
  莫特斯运行状态,
} from "./01．运行状态";
import { 确保创建莫特斯 } from "./03．莫特斯Boss运行";

const CreateGroup = jass.CreateGroup as (this: void) => any;
const CreateRegion = jass.CreateRegion as (this: void) => any;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const DestroyGroup = jass.DestroyGroup as (this: void, 单位组: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, 单位组: any) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, 单位: any) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (
  this: void,
  单位组: any,
  X: number,
  Y: number,
  范围: number,
  过滤器: any,
) => void;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, 单位组: any, 单位: any) => void;
const IsUnitType = jass.IsUnitType as (this: void, 单位: any, 类型: any) => boolean;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, 单位: any, 命令: string) => boolean;
const IsQuestItemCompleted = jass.IsQuestItemCompleted as (this: void, 任务要求: any) => boolean;
const Player = jass.Player as (this: void, 玩家ID: number) => any;
const RegionAddRect = jass.RegionAddRect as (this: void, 区域: any, 矩形: any) => void;
const RemoveRegion = jass.RemoveRegion as (this: void, 区域: any) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, 单位: any, 角度: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, 单位: any, X: number, Y: number) => void;

function 释放首次入口暂停(this: void): void {
  if (句柄有效(莫特斯运行状态.当前入口英雄)) {
    移除单位暂停(莫特斯运行状态.当前入口英雄, 莫特斯洞窟守卫演出暂停来源);
  }
  for (let i = 0; i < 莫特斯运行状态.当前暂停小怪.length; i++) {
    const 小怪 = 莫特斯运行状态.当前暂停小怪[i];
    if (句柄有效(小怪)) 移除单位暂停(小怪, 莫特斯洞窟守卫演出暂停来源);
  }
  莫特斯运行状态.当前暂停小怪 = [];
}

function on首次入口对白结束(this: void): void {
  if (莫特斯运行状态.首次入口演出已完成) return;

  莫特斯运行状态.首次入口演出已完成 = true;
  释放首次入口暂停();
  打开莫特斯洞窟门();
  确保创建莫特斯();
  莫特斯运行状态.当前洞窟守卫 = null;
}

function 播放守卫第五段对白(this: void): void {
  if (!单位存活(莫特斯运行状态.当前洞窟守卫)) {
    on首次入口对白结束();
    return;
  }
  广播单位提示(
    莫特斯运行状态.当前洞窟守卫,
    "首领就在深处。真有胆子，就自己走到他面前。不过进了这座洞的人，从没活着出去过。",
    5200,
  );
  addDelayedCallback(取广播完整播放毫秒(5200), on首次入口对白结束);
}

function 播放守卫第四段对白(this: void): void {
  if (!单位存活(莫特斯运行状态.当前入口英雄)) {
    on首次入口对白结束();
    return;
  }
  广播单位提示(莫特斯运行状态.当前入口英雄, "我们来查盗贼团和分离教派的关系。让开。", 3200);
  addDelayedCallback(取广播完整播放毫秒(3200), 播放守卫第五段对白);
}

function 播放守卫第三段对白(this: void): void {
  if (!单位存活(莫特斯运行状态.当前洞窟守卫)) {
    on首次入口对白结束();
    return;
  }
  广播单位提示(
    莫特斯运行状态.当前洞窟守卫,
    "那两个领头的命倒是够硬，居然还能爬回去。怎么，你们也来替他们送死？",
    4800,
  );
  addDelayedCallback(取广播完整播放毫秒(4800), 播放守卫第四段对白);
}

function 播放守卫第二段对白(this: void): void {
  if (!单位存活(莫特斯运行状态.当前入口英雄)) {
    on首次入口对白结束();
    return;
  }
  广播单位提示(莫特斯运行状态.当前入口英雄, "就是你们袭击了沙漠里的佣兵团？", 2800);
  addDelayedCallback(取广播完整播放毫秒(2800), 播放守卫第三段对白);
}

function 播放守卫第一段对白(this: void): void {
  if (!单位存活(莫特斯运行状态.当前洞窟守卫)) {
    on首次入口对白结束();
    return;
  }
  广播单位提示(莫特斯运行状态.当前洞窟守卫, "站住！谁准你们闯进来的？这地方不欢迎活人。", 3400);
  addDelayedCallback(取广播完整播放毫秒(3400), 播放守卫第二段对白);
}

function 暂停附近小怪并找守卫(this: void, 英雄: any): any {
  const 单位组 = CreateGroup();
  if (!句柄有效(单位组)) return null;

  const 英雄X = GetUnitX(英雄);
  const 英雄Y = GetUnitY(英雄);
  const 中立敌对 = Player(jass.PLAYER_NEUTRAL_AGGRESSIVE as number);
  let 最近小怪: any = null;
  let 最近距离平方 = 0.0;

  GroupEnumUnitsInRange(单位组, 英雄X, 英雄Y, 莫特斯洞窟守卫暂停范围, null);
  while (true) {
    const 单位 = FirstOfGroup(单位组);
    if (!句柄有效(单位)) break;
    GroupRemoveUnit(单位组, 单位);
    if (!单位存活(单位)
      || GetOwningPlayer(单位) !== 中立敌对
      || IsUnitType(单位, jass.UNIT_TYPE_HERO) === true) {
      continue;
    }

    莫特斯运行状态.当前暂停小怪.push(单位);
    IssueImmediateOrder(单位, "stop");
    添加单位暂停(单位, 莫特斯洞窟守卫演出暂停来源);
    const X差 = GetUnitX(单位) - 英雄X;
    const Y差 = GetUnitY(单位) - 英雄Y;
    const 距离平方 = X差 * X差 + Y差 * Y差;
    if (!句柄有效(最近小怪) || 距离平方 < 最近距离平方) {
      最近小怪 = 单位;
      最近距离平方 = 距离平方;
    }
  }
  DestroyGroup(单位组);
  return 最近小怪;
}

function 开始首次入口演出(this: void, 英雄: any): void {
  莫特斯运行状态.首次入口演出已开始 = true;
  莫特斯运行状态.当前入口英雄 = 英雄;
  IssueImmediateOrder(英雄, "stop");
  添加单位暂停(英雄, 莫特斯洞窟守卫演出暂停来源);
  莫特斯运行状态.当前洞窟守卫 = 暂停附近小怪并找守卫(英雄);
  if (!单位存活(莫特斯运行状态.当前洞窟守卫)) {
    debugLogForce(莫特斯模块名, "入口落点附近未找到中立敌对小怪", "radius=", 莫特斯洞窟守卫暂停范围);
    on首次入口对白结束();
    return;
  }

  SetUnitFacing(
    莫特斯运行状态.当前洞窟守卫,
    YDWEAngleBetweenUnitsSafe(莫特斯运行状态.当前洞窟守卫, 英雄),
  );
  SetUnitFacing(
    英雄,
    YDWEAngleBetweenUnitsSafe(英雄, 莫特斯运行状态.当前洞窟守卫),
  );
  播放守卫第一段对白();
}

function on永久入口进入(this: void): void {
  const 触发英雄 = GetTriggerUnit();
  if (!是莫特斯副本玩家英雄(触发英雄)) return;
  if (IsQuestItemCompleted(jglobals.udg_RWXM[18]) !== true) return;

  SetUnitPosition(触发英雄, 莫特斯入口落点X, 莫特斯入口落点Y);
  SetUnitFacing(触发英雄, 莫特斯入口落点面向);
  IssueImmediateOrder(触发英雄, "stop");

  if (!莫特斯运行状态.首次入口演出已开始) {
    开始首次入口演出(触发英雄);
  } else if (莫特斯运行状态.首次入口演出已完成) {
    确保创建莫特斯();
  }
}

/** 永久保留传送入口；首次对白、Boss 创建和靠近监听各自只执行一次。 */
export function 初始化莫特斯隐藏副本(this: void): void {
  if (莫特斯运行状态.永久入口已初始化) return;

  const 入口矩形 = 按配置键注册动态矩形区域(莫特斯入口矩形配置键);
  const 区域 = CreateRegion();
  const 触发器 = CreateTrigger();
  if (!句柄有效(入口矩形) || !句柄有效(区域) || !句柄有效(触发器)) {
    if (句柄有效(区域)) RemoveRegion(区域);
    if (句柄有效(触发器)) safeDestroyTrigger(触发器);
    debugLogForce(莫特斯模块名, "永久入口初始化失败", "rect=", 入口矩形, "region=", 区域, "trigger=", 触发器);
    return;
  }
  if (safeTriggerAddAction(触发器, on永久入口进入) == null) {
    RemoveRegion(区域);
    safeDestroyTrigger(触发器);
    debugLogForce(莫特斯模块名, "永久入口动作注册失败");
    return;
  }

  RegionAddRect(区域, 入口矩形);
  registerEnterRegionTrigger(触发器, 区域, null);
  莫特斯运行状态.永久入口区域 = 区域;
  莫特斯运行状态.永久入口触发器 = 触发器;
  莫特斯运行状态.永久入口已初始化 = true;
}
