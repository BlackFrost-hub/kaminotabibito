/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { addDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  getServerTime: (this: void) => number;
};
const { registerSyncHardwareKey } = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心") as {
  registerSyncHardwareKey: (this: void, key: number | string, status: number, callback: (this: void, event: 同步键盘事件) => void) => any;
};
const { KEY, KEY_STATE } = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义") as {
  KEY: { Y: number };
  KEY_STATE: { DOWN: number };
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, force: any, messageType: number, message: string) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};

import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 创建并冻结剧情Boss预置 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";
import { 启动剧情Boss战 } from "../../00．剧情系统核心工具/11．剧情Boss战启动桥接";

const AddSpecialEffect = jass.AddSpecialEffect as (this: void, modelName: string, x: number, y: number) => any;
const CreateGroup = jass.CreateGroup as (this: void) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, whichEffect: any) => void;
const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (this: void, whichPlayer: any, x: number, y: number, duration: number, message: string) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, whichGroup: any) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, whichPlayer: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (this: void, whichGroup: any, x: number, y: number, radius: number, filter: any) => void;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, whichGroup: any, whichUnit: any) => void;

interface 同步键盘事件 {
  player: any;
  key: number;
  status: number;
}

type 异界隐藏挑战类型 = "夏提雅" | "安兹乌尔恭";

interface 异界隐藏挑战状态 {
  类型: 异界隐藏挑战类型;
  Boss单位: any;
  特效列表: any[];
  已开始: boolean;
}

interface 延迟开战参数 {
  状态: 异界隐藏挑战状态;
  触发英雄: any;
}

interface 隐藏挑战配置 {
  类型: 异界隐藏挑战类型;
  Boss键: string;
  Boss名: string;
  X: number;
  Y: number;
  朝向: number;
  登场对白: string;
  玩家回应: string;
  Boss回应: string;
  特效路径: readonly string[];
}

const 隐藏挑战出现延迟毫秒 = 30000;
const 隐藏挑战确认范围 = 300;
const 隐藏挑战双击窗口毫秒 = 1200;
const 隐藏挑战状态表: 异界隐藏挑战状态[] = [];
const 玩家上次确认时间表: Record<number, number | undefined> = {};
let 夏提雅出现已安排 = false;
let 安兹乌尔恭出现已安排 = false;

const 夏提雅隐藏挑战配置: 隐藏挑战配置 = {
  类型: "夏提雅",
  Boss键: "Boss.夏提雅",
  Boss名: "夏提雅·布拉德弗伦",
  X: 27966.2,
  Y: -3680.7,
  朝向: 315,
  登场对白: "呵呵……能击败那头恶魔，看来你们并非无聊之辈。若还有余力，就来陪我尽兴一场吧。",
  玩家回应: "既然阁下亲自邀战，我们接受。",
  Boss回应: "很好。让我看看，你们究竟能让我愉悦到什么程度。",
  特效路径: [
    "Common\\Effect\\Form\\Illusion\\ShalltearRoseMirrorRim.mdx",
    "Common\\Effect\\Form\\Aura\\ShalltearBloodMirrorField.mdx",
  ],
};

const 安兹乌尔恭隐藏挑战配置: 隐藏挑战配置 = {
  类型: "安兹乌尔恭",
  Boss键: "Boss.安兹乌尔恭",
  Boss名: "安兹·乌尔·恭",
  X: 9336.8,
  Y: -13891.9,
  朝向: 225,
  登场对白: "诸位已经证明了自己的力量。我对你们的战斗方式产生了兴趣。若愿意，就在此接受我的试炼。",
  玩家回应: "既然阁下以挑战者的身份出现，我们奉陪。",
  Boss回应: "很好。无需保留，让我看看你们能够抵达何种境界。",
  特效路径: [
    "Common\\Effect\\Form\\Illusion\\AinzBlackGoldPortalFrame.mdx",
    "Common\\Effect\\Form\\Rotate\\AinzBlackGoldPortalCore.mdx",
    "Common\\Effect\\Form\\Rotate\\AinzBlackGoldPortalVortex.mdx",
  ],
};

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitAliveBJ(unit);
}

function 读取隐藏挑战配置(this: void, 类型: 异界隐藏挑战类型): 隐藏挑战配置 {
  return 类型 === "夏提雅" ? 夏提雅隐藏挑战配置 : 安兹乌尔恭隐藏挑战配置;
}

function 清理挑战入口特效(this: void, 状态: 异界隐藏挑战状态): void {
  for (let i = 0; i < 状态.特效列表.length; i++) {
    const effect = 状态.特效列表[i];
    if (effect != null && effect !== 0) DestroyEffect(effect);
  }
  状态.特效列表 = [];
}

function 查找玩家附近英雄(this: void, 状态: 异界隐藏挑战状态, 玩家: any): any {
  if (!单位存活(状态.Boss单位) || 玩家 == null || 玩家 === 0) return null;
  const group = CreateGroup();
  if (group == null || group === 0) return null;

  GroupEnumUnitsInRange(group, GetUnitX(状态.Boss单位), GetUnitY(状态.Boss单位), 隐藏挑战确认范围, null);
  let result: any = null;
  while (true) {
    const unit = FirstOfGroup(group);
    if (unit == null || unit === 0) break;
    GroupRemoveUnit(group, unit);
    if (GetOwningPlayer(unit) === 玩家 && 单位存活(unit) && 是玩家英雄组单位(unit)) {
      result = unit;
      break;
    }
  }
  DestroyGroup(group);
  return result;
}

function 查找可确认挑战(this: void, 玩家: any): { 状态: 异界隐藏挑战状态; 英雄: any } | undefined {
  for (let i = 0; i < 隐藏挑战状态表.length; i++) {
    const 状态 = 隐藏挑战状态表[i];
    if (状态.已开始) continue;
    const 英雄 = 查找玩家附近英雄(状态, 玩家);
    if (单位存活(英雄)) return { 状态, 英雄 };
  }
  return undefined;
}

function on启动隐藏挑战战斗(this: void, variable?: any): void {
  const 参数 = variable as 延迟开战参数 | undefined;
  if (参数 == null || !单位存活(参数.状态.Boss单位)) return;
  启动剧情Boss战(参数.状态.Boss单位, { 触发单位: 参数.触发英雄 });
}

function on播放隐藏挑战Boss回应(this: void, variable?: any): void {
  const 参数 = variable as 延迟开战参数 | undefined;
  if (参数 == null || !单位存活(参数.状态.Boss单位)) return;
  const 配置 = 读取隐藏挑战配置(参数.状态.类型);
  广播单位提示(参数.状态.Boss单位, 配置.Boss回应, 3600);
}

function 开始隐藏挑战(this: void, 状态: 异界隐藏挑战状态, 触发英雄: any): void {
  if (状态.已开始 || !单位存活(状态.Boss单位) || !单位存活(触发英雄)) return;
  状态.已开始 = true;
  清理挑战入口特效(状态);

  const 配置 = 读取隐藏挑战配置(状态.类型);
  广播单位提示(触发英雄, 配置.玩家回应, 3300);
  const 参数 = { 状态, 触发英雄 } as 延迟开战参数;
  addDelayedCallback(3500, on播放隐藏挑战Boss回应, 参数);
  addDelayedCallback(7300, on启动隐藏挑战战斗, 参数);
}

function on同步Y键按下(this: void, event: 同步键盘事件): void {
  const 玩家 = event.player;
  const 可确认挑战 = 查找可确认挑战(玩家);
  if (可确认挑战 == null) return;

  const 玩家ID = GetPlayerId(玩家);
  const 当前时间 = getServerTime();
  const 上次确认时间 = 玩家上次确认时间表[玩家ID];
  if (上次确认时间 == null || 当前时间 - 上次确认时间 > 隐藏挑战双击窗口毫秒) {
    玩家上次确认时间表[玩家ID] = 当前时间;
    DisplayTimedTextToPlayer(玩家, 0, 0, 2.2, "|cffffcc00『隐藏挑战』：|r再次按下 |cffffcc00Y|r 接受挑战。");
    return;
  }

  玩家上次确认时间表[玩家ID] = undefined;
  开始隐藏挑战(可确认挑战.状态, 可确认挑战.英雄);
}

function 创建隐藏挑战入口(this: void, 配置: 隐藏挑战配置): void {
  for (let i = 0; i < 隐藏挑战状态表.length; i++) {
    if (隐藏挑战状态表[i].类型 === 配置.类型) return;
  }

  const bossUnit = 创建并冻结剧情Boss预置({
    Boss键: 配置.Boss键,
    Boss名: 配置.Boss名,
    X: 配置.X,
    Y: 配置.Y,
    朝向: 配置.朝向,
    预创建后暂停: true,
    预创建后无敌: true,
  });
  if (!单位存活(bossUnit)) return;

  const 特效列表: any[] = [];
  for (let i = 0; i < 配置.特效路径.length; i++) {
    const effect = AddSpecialEffect(配置.特效路径[i], 配置.X, 配置.Y);
    if (effect != null && effect !== 0) 特效列表.push(effect);
  }
  隐藏挑战状态表.push({ 类型: 配置.类型, Boss单位: bossUnit, 特效列表, 已开始: false });

  广播单位提示(bossUnit, 配置.登场对白, 6200);
  QuestMessageBJ(
    GetPlayersAll(),
    jglobals.bj_QUESTMESSAGE_ALWAYSHINT,
    `|cffffcc00『隐藏挑战』：|r${配置.Boss名}正在等待回应。任意玩家英雄靠近其 300 码，在 1.2 秒内连续按下两次 Y 接受挑战。`,
  );
}

function on延迟创建夏提雅(this: void): void {
  创建隐藏挑战入口(夏提雅隐藏挑战配置);
}

function on延迟创建安兹乌尔恭(this: void): void {
  创建隐藏挑战入口(安兹乌尔恭隐藏挑战配置);
}

export function 创建夏提雅隐藏挑战(this: void): void {
  if (夏提雅出现已安排) return;
  夏提雅出现已安排 = true;
  addDelayedCallback(隐藏挑战出现延迟毫秒, on延迟创建夏提雅);
}

export function 创建安兹隐藏挑战(this: void): void {
  if (安兹乌尔恭出现已安排) return;
  安兹乌尔恭出现已安排 = true;
  addDelayedCallback(隐藏挑战出现延迟毫秒, on延迟创建安兹乌尔恭);
}

export function 执行创建夏提雅隐藏挑战动作(this: void): void {
  创建夏提雅隐藏挑战();
}

export const 异界隐藏挑战入口剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_创建夏提雅隐藏挑战": 执行创建夏提雅隐藏挑战动作,
};

registerSyncHardwareKey(KEY.Y, KEY_STATE.DOWN, on同步Y键按下);
