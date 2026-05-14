/** @noSelfInFile */

const japi = require("jass.japi") as any;

import {
  广播提示玩家槽数,
  每玩家广播提示槽数,
  取广播提示槽索引,
  广播提示背景贴图,
  广播提示默认头像,
  广播提示字体,
  广播提示宽度,
  广播提示高度,
  广播提示头像大小,
  广播提示文字宽度,
  广播提示文字高度,
  广播提示起始X,
  广播提示基准Y,
  广播提示槽间距Y,
  广播提示最大透明度,
  广播提示优先级,
  帧点左,
  帧点中,
  帧点右,
  文本左对齐,
} from "./00．常量定义";

const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (
  type: string,
  name: string,
  parent: number,
  template: string,
  id: number
) => number;
const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (frame: number, point: number, x: number, y: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (
  frame: number,
  point: number,
  relativeFrame: number,
  relativePoint: number,
  x: number,
  y: number
) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetFont = japi.DzFrameSetFont as (frame: number, path: string, size: number, flag: number) => void;
const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment as (frame: number, align: number) => void;
const DzFrameSetAlpha = japi.DzFrameSetAlpha as (frame: number, alpha: number) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;

export interface 广播提示槽帧 {
  root: number;
  icon: number;
  text: number;
}

export const 广播提示槽帧表: Array<广播提示槽帧 | undefined> = [];

let 已创建广播提示UI = false;

function 取槽位Y(this: void, 槽位ID: number): number {
  return 广播提示基准Y - 槽位ID * 广播提示槽间距Y;
}

function 创建背景帧(this: void, 名称: string, 父级: number): number {
  return DzCreateFrameByTagName("BACKDROP", 名称, 父级, "template", 0);
}

function 创建文本帧(this: void, 名称: string, 父级: number): number {
  return DzCreateFrameByTagName("TEXT", 名称, 父级, "template", 0);
}

function 创建单槽(this: void, 玩家ID: number, 槽位ID: number, 游戏UI: number): 广播提示槽帧 | undefined {
  const 序号 = 取广播提示槽索引(玩家ID, 槽位ID);
  const root = 创建背景帧("BroadcastNoticeRoot_P" + 玩家ID + "_S" + 槽位ID, 游戏UI);
  if (root === 0) return undefined;

  const icon = 创建背景帧("BroadcastNoticeIcon_P" + 玩家ID + "_S" + 槽位ID, root);
  const text = 创建文本帧("BroadcastNoticeText_P" + 玩家ID + "_S" + 槽位ID, root);
  if (icon === 0 || text === 0) return undefined;

  DzFrameSetAbsolutePoint(root, 帧点左, 广播提示起始X, 取槽位Y(槽位ID));
  DzFrameSetSize(root, 广播提示宽度, 广播提示高度);
  DzFrameSetTexture(root, 广播提示背景贴图, 0);
  DzFrameSetAlpha(root, 0);
  DzFrameSetPriority(root, 广播提示优先级);

  DzFrameSetSize(icon, 广播提示头像大小, 广播提示头像大小);
  DzFrameSetTexture(icon, 广播提示默认头像, 0);
  DzFrameSetPoint(icon, 帧点左, root, 帧点左, 0.006, 0);
  DzFrameSetPriority(icon, 广播提示优先级 + 1);

  DzFrameSetSize(text, 广播提示文字宽度, 广播提示文字高度);
  DzFrameSetText(text, "");
  DzFrameSetFont(text, 广播提示字体, 0.0115, 0);
  DzFrameSetTextAlignment(text, -1);
  DzFrameSetTextAlignment(text, 文本左对齐);
  DzFrameSetPoint(text, 帧点左, icon, 帧点右, 0.006, 0);
  DzFrameSetPriority(text, 广播提示优先级 + 2);

  DzFrameShow(icon, true);
  DzFrameShow(text, true);
  DzFrameShow(root, false);
  DzFrameSetAlpha(root, 广播提示最大透明度);

  const 帧组 = { root, icon, text };
  广播提示槽帧表[序号] = 帧组;
  return 帧组;
}

export function 创建全部广播提示槽(this: void): void {
  if (已创建广播提示UI) return;
  已创建广播提示UI = true;

  const 游戏UI = DzGetGameUI();
  if (游戏UI === 0) return;

  for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
    for (let 槽位ID = 0; 槽位ID < 每玩家广播提示槽数; 槽位ID++) {
      创建单槽(玩家ID, 槽位ID, 游戏UI);
    }
  }
}
