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
  广播提示宽度,
  广播提示高度,
  广播提示文字宽度,
  广播提示文字高度,
} from "./00．常量定义";
import { 广播提示槽帧表 } from "./02．UI创建";

const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (frame: number, point: number, x: number, y: number) => void;
const DzFrameSetAlpha = japi.DzFrameSetAlpha as (frame: number, alpha: number) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;

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
  rootWidth: number;
  rootHeight: number;
  textWidth: number;
  textHeight: number;
}

export const 广播提示槽状态表: Array<广播提示槽状态 | undefined> = [];

interface 广播文本布局结果 {
  文本: string;
  可见长度: number;
  行数: number;
  rootWidth: number;
  rootHeight: number;
  textWidth: number;
  textHeight: number;
  durationMs: number;
}

const 玩家下一个槽位表: number[] = [];

function 取安全持续时间(this: void, 持续时间: number | undefined): number {
  if (持续时间 == null || 持续时间 <= 0) return 广播提示默认停留毫秒;
  return 持续时间;
}

function 计算广播文本可见长度(this: void, 文本: string): number {
  let 可见长度 = 0;
  let i = 0;
  while (i < 文本.length) {
    const 当前字符 = 文本.charAt(i);
    if (当前字符 === "|") {
      const 下一个字符 = 文本.charAt(i + 1);
      if (下一个字符 === "c" || 下一个字符 === "C") {
        i += 10;
        continue;
      }
      if (下一个字符 === "r" || 下一个字符 === "R") {
        i += 2;
        continue;
      }
    }
    if (当前字符 === "\n") {
      i++;
      continue;
    }
    可见长度++;
    i++;
  }
  return 可见长度;
}

function 按可见长度插入换行(this: void, 文本: string, 每行字符数: number, 最大行数: number): { 文本: string; 行数: number } {
  let 结果 = "";
  let 当前行长度 = 0;
  let 行数 = 1;
  let i = 0;
  while (i < 文本.length) {
    const 当前字符 = 文本.charAt(i);
    if (当前字符 === "|") {
      const 下一个字符 = 文本.charAt(i + 1);
      if (下一个字符 === "c" || 下一个字符 === "C") {
        结果 += 文本.substring(i, i + 10);
        i += 10;
        continue;
      }
      if (下一个字符 === "r" || 下一个字符 === "R") {
        结果 += 文本.substring(i, i + 2);
        i += 2;
        continue;
      }
    }
    if (当前字符 === "\n") {
      结果 += 当前字符;
      当前行长度 = 0;
      if (行数 < 最大行数) 行数++;
      i++;
      continue;
    }
    if (当前行长度 >= 每行字符数 && 行数 < 最大行数) {
      结果 += "\n";
      当前行长度 = 0;
      行数++;
    }
    结果 += 当前字符;
    当前行长度++;
    i++;
  }
  return { 文本: 结果, 行数 };
}

function 计算广播文本布局(this: void, 文本: string, 持续时间?: number): 广播文本布局结果 {
  const 可见长度 = 计算广播文本可见长度(文本);
  const 指定持续时间 = 取安全持续时间(持续时间);
  if (可见长度 <= 26) {
    return {
      文本,
      可见长度,
      行数: 1,
      rootWidth: 广播提示宽度,
      rootHeight: 广播提示高度,
      textWidth: 广播提示文字宽度,
      textHeight: 广播提示文字高度,
      durationMs: 指定持续时间,
    };
  }

  if (可见长度 <= 64) {
    const 格式化结果 = 按可见长度插入换行(文本, 30, 2);
    return {
      文本: 格式化结果.文本,
      可见长度,
      行数: 格式化结果.行数,
      rootWidth: 0.285,
      rootHeight: 0.05,
      textWidth: 0.235,
      textHeight: 0.032,
      durationMs: 指定持续时间 > 广播提示默认停留毫秒 ? 指定持续时间 : 4200,
    };
  }

  const 格式化结果 = 按可见长度插入换行(文本, 32, 3);
  return {
    文本: 格式化结果.文本,
    可见长度,
    行数: 格式化结果.行数,
    rootWidth: 0.325,
    rootHeight: 0.066,
    textWidth: 0.275,
    textHeight: 0.048,
    durationMs: 指定持续时间 > 广播提示默认停留毫秒 ? 指定持续时间 : 5600,
  };
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
          rootWidth: 广播提示宽度,
          rootHeight: 广播提示高度,
          textWidth: 广播提示文字宽度,
          textHeight: 广播提示文字高度,
        };
      }
    }
  }
}

function 写入槽帧内容(this: void, 序号: number, 状态: 广播提示槽状态): void {
  const 帧组 = 广播提示槽帧表[序号];
  if (帧组 == null) return;

  DzFrameSetSize(帧组.root, 状态.rootWidth, 状态.rootHeight);
  DzFrameSetSize(帧组.text, 状态.textWidth, 状态.textHeight);
  DzFrameSetTexture(帧组.icon, 状态.iconPath, 0);
  DzFrameSetText(帧组.text, 状态.text);
  DzFrameSetAbsolutePoint(帧组.root, 3, 广播提示起始X, 取广播提示槽位Y(状态.slotId));
  DzFrameSetAlpha(帧组.root, 0);
}

export function 入队头像提示(this: void, 玩家ID: number, 头像路径: string, 文本: string, 持续时间?: number): void {
  if (玩家ID < 0 || 玩家ID >= 广播提示玩家槽数) return;
  if (文本 == null || 文本 === "") return;
  const 布局 = 计算广播文本布局(文本, 持续时间);

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
  状态.durationMs = 布局.durationMs;
  状态.x = 广播提示起始X;
  状态.alpha = 0;
  状态.text = 布局.文本;
  状态.iconPath = 头像路径;
  状态.rootWidth = 布局.rootWidth;
  状态.rootHeight = 布局.rootHeight;
  状态.textWidth = 布局.textWidth;
  状态.textHeight = 布局.textHeight;

  写入槽帧内容(序号, 状态);
}
