/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import {
  广播提示玩家槽数,
  每玩家广播提示槽数,
  取广播提示槽索引,
  取广播提示槽位Y,
  广播提示状态_隐藏,
  广播提示状态_滑入,
  广播提示状态_停留,
  广播提示状态_淡出,
  广播提示滑入毫秒,
  广播提示淡出毫秒,
  广播提示刷新毫秒,
  广播提示起始X,
  广播提示停留X,
  广播提示最大透明度,
  帧点左,
} from "./00．常量定义";
import { 广播提示槽帧表 } from "./02．UI创建";
import { 广播提示槽状态表, 广播提示槽状态 } from "./03．消息队列";
import { addPeriodicCallback } from "../../00．核心系统/05．中心计时器";

const GetLocalPlayer = jass.GetLocalPlayer as () => any;
const GetPlayerId = jass.GetPlayerId as (whichPlayer: any) => number;
const R2I = jass.R2I as (value: number) => number;

const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (frame: number, point: number, x: number, y: number) => void;
const DzFrameSetAlpha = japi.DzFrameSetAlpha as (frame: number, alpha: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;

let 动画回调ID = 0;

function 限制01(this: void, 值: number): number {
  if (值 <= 0) return 0;
  if (值 >= 1) return 1;
  return 值;
}

function 取本机玩家ID(this: void): number {
  const 本机玩家 = GetLocalPlayer();
  if (本机玩家 == null || 本机玩家 === 0) return -1;
  return GetPlayerId(本机玩家);
}

function 推进滑入(this: void, 状态: 广播提示槽状态): void {
  const 进度 = 限制01(状态.elapsedMs / 广播提示滑入毫秒);
  状态.x = 广播提示起始X + (广播提示停留X - 广播提示起始X) * 进度;
  状态.alpha = 广播提示最大透明度 * 进度;
  if (状态.elapsedMs >= 广播提示滑入毫秒) {
    状态.state = 广播提示状态_停留;
    状态.elapsedMs = 0;
    状态.x = 广播提示停留X;
    状态.alpha = 广播提示最大透明度;
  }
}

function 推进停留(this: void, 状态: 广播提示槽状态): void {
  状态.x = 广播提示停留X;
  状态.alpha = 广播提示最大透明度;
  if (状态.elapsedMs >= 状态.durationMs) {
    状态.state = 广播提示状态_淡出;
    状态.elapsedMs = 0;
  }
}

function 推进淡出(this: void, 状态: 广播提示槽状态): void {
  const 进度 = 限制01(状态.elapsedMs / 广播提示淡出毫秒);
  状态.x = 广播提示停留X;
  状态.alpha = 广播提示最大透明度 * (1 - 进度);
  if (状态.elapsedMs >= 广播提示淡出毫秒) {
    状态.active = false;
    状态.state = 广播提示状态_隐藏;
    状态.elapsedMs = 0;
    状态.alpha = 0;
  }
}

function 推进槽位状态(this: void, 状态: 广播提示槽状态): void {
  if (!状态.active) return;
  状态.elapsedMs += 广播提示刷新毫秒;
  if (状态.state === 广播提示状态_滑入) {
    推进滑入(状态);
  } else if (状态.state === 广播提示状态_停留) {
    推进停留(状态);
  } else if (状态.state === 广播提示状态_淡出) {
    推进淡出(状态);
  }
}

function 应用槽位帧(this: void, 序号: number, 状态: 广播提示槽状态, 本机玩家ID: number): void {
  const 帧组 = 广播提示槽帧表[序号];
  if (帧组 == null) return;

  const 可见 = 状态.active && 本机玩家ID === 状态.playerId;
  DzFrameSetAbsolutePoint(帧组.root, 帧点左, 状态.x, 取广播提示槽位Y(状态.slotId));
  DzFrameSetAlpha(帧组.root, R2I(状态.alpha));
  DzFrameShow(帧组.root, 可见);
}

export function on广播提示消息Tick(this: void): void {
  const 本机玩家ID = 取本机玩家ID();
  for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
    for (let 槽位ID = 0; 槽位ID < 每玩家广播提示槽数; 槽位ID++) {
      const 序号 = 取广播提示槽索引(玩家ID, 槽位ID);
      const 状态 = 广播提示槽状态表[序号];
      if (状态 == null) continue;
      推进槽位状态(状态);
      应用槽位帧(序号, 状态, 本机玩家ID);
    }
  }
}

export function 启动广播提示动画驱动(this: void): void {
  if (动画回调ID !== 0) return;
  动画回调ID = addPeriodicCallback(广播提示刷新毫秒, on广播提示消息Tick);
}
