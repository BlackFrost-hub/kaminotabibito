/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const 统一矩形区域读取 = require("系统.07．地形系统.09．动态矩形区域注册表.04．统一矩形区域读取") as {
  获取矩形区域: (this: void, 名称: string) => any;
};

const Frame工具 = require("lib.扩展函数.封装函数.04．硬件输入.07．Frame函数") as {
  frameSetScriptByCode: (
    this: void,
    frame: number,
    eventId: number,
    action: (this: void) => void,
    sync: boolean,
    playerId?: number,
  ) => void;
};
const 硬件常量 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义") as {
  KEY: { M: number };
  KEY_STATE: { DOWN: number };
};
const 英雄桥接 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const 矩形函数 = require("lib.扩展函数.BJ函数.04．矩形与区域") as {
  RectContainsUnit: (this: void, rect: any, unit: any) => boolean;
};
const 音效函数 = require("lib.扩展函数.封装函数.02．音效系统.04．MP3音效播放") as {
  Sound3DII_Mp3Play: (this: void, path: string, player?: any) => any;
};

import { 世界地图地点配置表 } from "./01．世界地图地点配置";
import { 获取世界地图地点帧, 世界地图帧 } from "./02．世界地图界面";

const DzFrameShow = japi.DzFrameShow as (this: void, frame: number, show: boolean) => void;
const DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame as (this: void) => number;
const DzIsChatBoxOpen = japi.DzIsChatBoxOpen as (this: void) => boolean;
const DzTriggerRegisterKeyEventByCode = japi.DzTriggerRegisterKeyEventByCode as (
  this: void,
  trigger: any,
  keyCode: number,
  status: number,
  sync: boolean,
  callback: (this: void) => void,
) => void;
const DzTriggerRegisterSyncData = japi.DzTriggerRegisterSyncData as (
  this: void,
  trigger: any,
  prefix: string,
  server: boolean,
) => void;
const DzSyncData = japi.DzSyncData as (this: void, prefix: string, data: string) => void;
const DzGetTriggerSyncPlayer = japi.DzGetTriggerSyncPlayer as (this: void) => any;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, player: any) => number;
const CreateTimer = jass.CreateTimer as (this: void) => any;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const TriggerAddAction = jass.TriggerAddAction as (
  this: void,
  trigger: any,
  callback: (this: void) => void,
) => any;
const TimerStart = jass.TimerStart as (
  this: void,
  timer: any,
  timeout: number,
  periodic: boolean,
  callback: (this: void) => void,
) => void;
const GetExpiredTimer = jass.GetExpiredTimer as (this: void) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const DestroyTimer = jass.DestroyTimer as (this: void, timer: any) => void;
const 获取矩形区域 = 统一矩形区域读取.获取矩形区域;

const 地点鼠标进入事件 = 2;
const 地点鼠标离开事件 = 3;
const 地图展开延迟秒 = 0.3;
const 世界地图按键同步前缀 = "WMAP";

const 玩家地图打开状态表: Record<number, boolean | undefined> = {};
const 地图展开玩家表: Record<number, any> = {};

let 世界地图交互已初始化 = false;
let 世界地图本机按键触发器: any = null;
let 世界地图同步触发器: any = null;

function 单位位于任一矩形(this: void, unit: any, 矩形区域名称列表: string[] | undefined): boolean {
  if (矩形区域名称列表 == null) return false;
  for (let 索引 = 0; 索引 < 矩形区域名称列表.length; 索引++) {
    const rect = 获取矩形区域(矩形区域名称列表[索引]);
    if (rect != null && rect !== 0 && 矩形函数.RectContainsUnit(rect, unit)) return true;
  }
  return false;
}

function 找到触发地点索引(this: void, 触发帧: number): number {
  for (let 索引 = 0; 索引 < 世界地图帧.地点帧组表.length; 索引++) {
    const 地点帧 = 世界地图帧.地点帧组表[索引];
    if (地点帧 != null && 地点帧.按钮 === 触发帧) return 索引;
  }
  return -1;
}

function on地点鼠标进入(this: void): void {
  const 索引 = 找到触发地点索引(DzGetTriggerUIEventFrame());
  if (索引 < 0) return;
  const 地点帧 = 世界地图帧.地点帧组表[索引];
  if (地点帧 != null) DzFrameShow(地点帧.文本框, true);
}

function on地点鼠标离开(this: void): void {
  const 索引 = 找到触发地点索引(DzGetTriggerUIEventFrame());
  if (索引 < 0) return;
  const 地点帧 = 世界地图帧.地点帧组表[索引];
  if (地点帧 != null) DzFrameShow(地点帧.文本框, false);
}

function on世界地图展开Timer(this: void): void {
  const timer = GetExpiredTimer();
  if (timer == null || timer === 0) return;
  const timerID = GetHandleId(timer);
  const 玩家 = 地图展开玩家表[timerID];
  地图展开玩家表[timerID] = undefined;
  if (玩家 != null && 玩家 !== 0 && GetLocalPlayer() === 玩家) {
    DzFrameShow(世界地图帧.放大图标, false);
    DzFrameShow(世界地图帧.地图根帧, true);
  }
  DestroyTimer(timer);
}

function 创建地图展开Timer(this: void, 玩家: any): void {
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;
  地图展开玩家表[GetHandleId(timer)] = 玩家;
  TimerStart(timer, 地图展开延迟秒, false, on世界地图展开Timer);
}

export function 本地隐藏世界地图(this: void, 玩家: any): void {
  if (玩家 == null || 玩家 === 0 || GetLocalPlayer() !== 玩家) return;
  DzFrameShow(世界地图帧.地图根帧, false);
}

export function 刷新世界地图当前位置(this: void, 玩家: any): void {
  if (玩家 == null || 玩家 === 0) return;
  const 是本地玩家 = GetLocalPlayer() === 玩家;
  for (let 地点ID = 1; 地点ID <= 世界地图地点配置表.length; 地点ID++) {
    const 地点帧 = 获取世界地图地点帧(地点ID);
    if (是本地玩家 && 地点帧 != null) DzFrameShow(地点帧.当前位置箭头, false);
  }

  const 英雄 = 英雄桥接.getRegisteredPlayerHero(玩家);
  if (英雄 == null || 英雄 === 0) return;

  for (let 索引 = 0; 索引 < 世界地图地点配置表.length; 索引++) {
    const 配置 = 世界地图地点配置表[索引];
    const 位于当前地点 = 单位位于任一矩形(英雄, 配置.当前位置矩形区域名称列表);
    if (!位于当前地点 || !是本地玩家) continue;
    const 地点帧 = 获取世界地图地点帧(配置.地点ID);
    if (地点帧 != null) DzFrameShow(地点帧.当前位置箭头, true);
  }
}

function on世界地图本机按键(this: void): void {
  if (DzIsChatBoxOpen() === true) return;
  DzSyncData(世界地图按键同步前缀, "1");
}

function on世界地图按键同步(this: void): void {
  const 玩家 = DzGetTriggerSyncPlayer();
  if (玩家 == null || 玩家 === 0) return;

  刷新世界地图当前位置(玩家);
  音效函数.Sound3DII_Mp3Play("XT\\YX-FY.mp3", 玩家);

  const 玩家ID = GetPlayerId(玩家);
  if (玩家地图打开状态表[玩家ID] !== true) {
    玩家地图打开状态表[玩家ID] = true;
    if (GetLocalPlayer() === 玩家) DzFrameShow(世界地图帧.放大图标, true);
    创建地图展开Timer(玩家);
  } else {
    玩家地图打开状态表[玩家ID] = false;
    本地隐藏世界地图(玩家);
  }
}

function 注册地点悬停事件(this: void): void {
  for (let 索引 = 0; 索引 < 世界地图帧.地点帧组表.length; 索引++) {
    const 地点帧 = 世界地图帧.地点帧组表[索引];
    if (地点帧 == null) continue;
    Frame工具.frameSetScriptByCode(地点帧.按钮, 地点鼠标进入事件, on地点鼠标进入, false);
    Frame工具.frameSetScriptByCode(地点帧.按钮, 地点鼠标离开事件, on地点鼠标离开, false);
  }
}

export function 初始化世界地图交互(this: void): void {
  if (世界地图交互已初始化) return;
  世界地图交互已初始化 = true;
  注册地点悬停事件();
  世界地图同步触发器 = CreateTrigger();
  TriggerAddAction(世界地图同步触发器, on世界地图按键同步);
  DzTriggerRegisterSyncData(世界地图同步触发器, 世界地图按键同步前缀, false);

  世界地图本机按键触发器 = CreateTrigger();
  DzTriggerRegisterKeyEventByCode(
    世界地图本机按键触发器,
    硬件常量.KEY.M,
    硬件常量.KEY_STATE.DOWN,
    false,
    on世界地图本机按键,
  );
}
