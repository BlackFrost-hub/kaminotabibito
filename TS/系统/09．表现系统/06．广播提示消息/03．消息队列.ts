/** @noSelfInFile */

const japi = require("jass.japi") as any;

import {
  广播提示玩家槽数,
  每玩家广播提示槽数,
  取广播提示槽索引,
  取广播提示槽位Y,
  广播提示状态_隐藏,
  广播提示状态_滑入,
  广播提示默认停留毫秒,
  广播提示起始X,
} from "./00．常量定义";
import { 广播提示槽帧表 } from "./02．UI创建";

const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (frame: number, point: number, x: number, y: number) => void;
const DzFrameSetAlpha = japi.DzFrameSetAlpha as (frame: number, alpha: number) => void;

export interface 广播提示槽状态 {
  active: boolean;
  playerId: number;
  slotId: number;
  state: number;
  elapsedMs: number;
  durationMs: number;
  x: number;
  alpha: number;
  text: string;
  iconPath: string;
}

export const 广播提示槽状态表: Array<广播提示槽状态 | undefined> = [];

const 玩家下一个槽位表: number[] = [];

function 取安全持续时间(this: void, 持续时间: number | undefined): number {
  if (持续时间 == null || 持续时间 <= 0) return 广播提示默认停留毫秒;
  return 持续时间;
}

export function 初始化广播提示消息状态(this: void): void {
  for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
    玩家下一个槽位表[玩家ID] = 0;
    for (let 槽位ID = 0; 槽位ID < 每玩家广播提示槽数; 槽位ID++) {
      const 序号 = 取广播提示槽索引(玩家ID, 槽位ID);
      if (广播提示槽状态表[序号] == null) {
        广播提示槽状态表[序号] = {
          active: false,
          playerId: 玩家ID,
          slotId: 槽位ID,
          state: 广播提示状态_隐藏,
          elapsedMs: 0,
          durationMs: 广播提示默认停留毫秒,
          x: 广播提示起始X,
          alpha: 0,
          text: "",
          iconPath: "",
        };
      }
    }
  }
}

function 写入槽帧内容(this: void, 序号: number, 状态: 广播提示槽状态): void {
  const 帧组 = 广播提示槽帧表[序号];
  if (帧组 == null) return;

  DzFrameSetTexture(帧组.icon, 状态.iconPath, 0);
  DzFrameSetText(帧组.text, 状态.text);
  DzFrameSetAbsolutePoint(帧组.root, 3, 广播提示起始X, 取广播提示槽位Y(状态.slotId));
  DzFrameSetAlpha(帧组.root, 0);
}

export function 入队头像提示(this: void, 玩家ID: number, 头像路径: string, 文本: string, 持续时间?: number): void {
  if (玩家ID < 0 || 玩家ID >= 广播提示玩家槽数) return;
  if (文本 == null || 文本 === "") return;

  const 当前槽位 = 玩家下一个槽位表[玩家ID] || 0;
  const 序号 = 取广播提示槽索引(玩家ID, 当前槽位);
  const 下一个槽位 = 当前槽位 + 1 >= 每玩家广播提示槽数 ? 0 : 当前槽位 + 1;
  玩家下一个槽位表[玩家ID] = 下一个槽位;

  const 状态 = 广播提示槽状态表[序号];
  if (状态 == null) return;

  状态.active = true;
  状态.playerId = 玩家ID;
  状态.slotId = 当前槽位;
  状态.state = 广播提示状态_滑入;
  状态.elapsedMs = 0;
  状态.durationMs = 取安全持续时间(持续时间);
  状态.x = 广播提示起始X;
  状态.alpha = 0;
  状态.text = 文本;
  状态.iconPath = 头像路径;

  写入槽帧内容(序号, 状态);
}
