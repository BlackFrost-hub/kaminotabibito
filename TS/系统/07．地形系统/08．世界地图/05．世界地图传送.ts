/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

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
const 英雄桥接 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const FourCC安全版 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, raw: string | undefined | null) => number;
};
const 单位函数 = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  UnitHasBuffBJ: (this: void, unit: any, buffId: number) => boolean;
};
const 电影函数 = require("lib.扩展函数.BJ函数.05A．电影函数") as {
  CinematicFilterGenericBJ: (
    this: void,
    duration: number,
    blendMode: any,
    texture: string,
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
const 镜头函数 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数") as {
  StarOther_PanCameraToTimedForPlayer: (
    this: void,
    player: any,
    x: number,
    y: number,
    duration: number,
  ) => void;
};
const 音效函数 = require("lib.扩展函数.封装函数.02．音效系统.04．MP3音效播放") as {
  Sound3DII_Mp3Play: (this: void, path: string, player?: any) => any;
};
const 剧情进度系统 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文") as {
  读取剧情进度: (this: void) => number;
};

import { 世界地图传送配置表 } from "./01．世界地图地点配置";
import { 获取世界地图地点帧 } from "./02．世界地图界面";
import { 本地隐藏世界地图 } from "./03．世界地图交互";
import type { 世界地图传送配置 } from "./00．类型定义";

const DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame as (this: void) => number;
const DzGetTriggerUIEventPlayer = japi.DzGetTriggerUIEventPlayer as (this: void) => any;
const GetLocalPlayer = jass.GetLocalPlayer as (this: void) => any;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const CreateTimer = jass.CreateTimer as (this: void) => any;
const TimerStart = jass.TimerStart as (
  this: void,
  timer: any,
  timeout: number,
  periodic: boolean,
  callback: (this: void) => void,
) => void;
const GetExpiredTimer = jass.GetExpiredTimer as (this: void) => any;
const DestroyTimer = jass.DestroyTimer as (this: void, timer: any) => void;
const DisplayCineFilter = jass.DisplayCineFilter as (this: void, show: boolean) => void;

const 双击事件 = 12;
const 黑幕持续秒 = 2.5;
const 镜头移动秒 = 0.03;
const 已注册传送地点表: Record<number, boolean | undefined> = {};

function 获取传送配置By地点ID(this: void, 地点ID: number): 世界地图传送配置 | undefined {
  for (let 索引 = 0; 索引 < 世界地图传送配置表.length; 索引++) {
    const 配置 = 世界地图传送配置表[索引];
    if (配置.地点ID === 地点ID) return 配置;
  }
  return undefined;
}

function 获取传送配置By配置ID(this: void, 配置ID: string): 世界地图传送配置 | undefined {
  for (let 索引 = 0; 索引 < 世界地图传送配置表.length; 索引++) {
    const 配置 = 世界地图传送配置表[索引];
    if (配置.配置ID === 配置ID) return 配置;
  }
  return undefined;
}

function 获取触发帧传送配置(this: void): 世界地图传送配置 | undefined {
  const 触发帧 = DzGetTriggerUIEventFrame();
  for (let 索引 = 0; 索引 < 世界地图传送配置表.length; 索引++) {
    const 配置 = 世界地图传送配置表[索引];
    if (配置.地点ID == null) continue;
    const 地点帧 = 获取世界地图地点帧(配置.地点ID);
    if (地点帧 != null && 地点帧.按钮 === 触发帧) return 配置;
  }
  return undefined;
}

function on世界地图黑幕结束(this: void): void {
  const timer = GetExpiredTimer();
  DisplayCineFilter(false);
  if (timer != null && timer !== 0) DestroyTimer(timer);
}

function 创建世界地图黑幕Timer(this: void): void {
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;
  TimerStart(timer, 黑幕持续秒, false, on世界地图黑幕结束);
}

function 传送条件通过(this: void, 配置: 世界地图传送配置, 英雄: any): boolean {
  if (配置.禁止剧情进度 != null) {
    if (剧情进度系统.读取剧情进度() === 配置.禁止剧情进度) return false;
  }
  const BuffID = FourCC安全版.stringToFourCCSafe(配置.所需BuffID);
  return BuffID > 0 && 单位函数.UnitHasBuffBJ(英雄, BuffID);
}

function 执行传送配置(this: void, 配置: 世界地图传送配置, 玩家: any): boolean {
  if (玩家 == null || 玩家 === 0) return false;
  const 英雄 = 英雄桥接.getRegisteredPlayerHero(玩家);
  if (英雄 == null || 英雄 === 0 || !传送条件通过(配置, 英雄)) return false;

  if (GetLocalPlayer() === 玩家) {
    本地隐藏世界地图(玩家);
    电影函数.CinematicFilterGenericBJ(
      0.5,
      jass.BLEND_MODE_BLEND,
      "ReplaceableTextures\\CameraMasks\\Black_mask.blp",
      15,
      15,
      15,
      15,
      0,
      0,
      0,
      0,
    );
  }

  创建世界地图黑幕Timer();
  音效函数.Sound3DII_Mp3Play("XT\\YX-CS.mp3", 玩家);

  if (配置.镜头先于单位) {
    镜头函数.StarOther_PanCameraToTimedForPlayer(玩家, 配置.镜头X, 配置.镜头Y, 镜头移动秒);
    SetUnitPosition(英雄, 配置.目标X, 配置.目标Y);
  } else {
    SetUnitPosition(英雄, 配置.目标X, 配置.目标Y);
    镜头函数.StarOther_PanCameraToTimedForPlayer(玩家, 配置.镜头X, 配置.镜头Y, 镜头移动秒);
  }
  return true;
}

function on世界地图地点双击(this: void): void {
  const 配置 = 获取触发帧传送配置();
  if (配置 == null) return;
  执行传送配置(配置, DzGetTriggerUIEventPlayer());
}

export function 执行世界地图传送(this: void, 配置ID: string, 玩家: any): boolean {
  const 配置 = 获取传送配置By配置ID(配置ID);
  if (配置 == null) return false;
  return 执行传送配置(配置, 玩家);
}

export function 注册世界地图地点传送(this: void, 地点ID: number): void {
  if (已注册传送地点表[地点ID] === true) return;
  const 配置 = 获取传送配置By地点ID(地点ID);
  if (配置 == null) return;
  const 地点帧 = 获取世界地图地点帧(地点ID);
  if (地点帧 == null || 地点帧.按钮 === 0) return;
  Frame工具.frameSetScriptByCode(地点帧.按钮, 双击事件, on世界地图地点双击, true);
  已注册传送地点表[地点ID] = true;
}
