/** @noSelfInFile */

const japi = require("jass.japi") as any;

import { createFrame as 创建帧 } from "../../09．表现系统/01．UI工具/01．帧创建";
import { FramePoint, FrameType } from "../../09．表现系统/01．UI工具/00．类型定义";
import { setFramePointRelative as 设置帧相对位置, setFrameSize as 设置帧尺寸 } from "../../09．表现系统/01．UI工具/02．位置尺寸";
import { setFrameClickEvent as 设置帧点击事件 } from "../../09．表现系统/01．UI工具/03．内容设置";

let __pcallFrameA = 0;
let __pcallFrameB = 0;

function __pcallClearAllPointsBody(this: any): void {
  japi.DzFrameClearAllPoints(__pcallFrameA);
}

function __pcallSetAllPointsBody(this: any): void {
  japi.DzFrameSetAllPoints(__pcallFrameA, __pcallFrameB);
}

function 清空帧锚点(this: void, 帧: number): void {
  __pcallFrameA = 帧;
  pcall(__pcallClearAllPointsBody);
}

function 铺满目标帧(this: void, 帧: number, 目标帧: number): void {
  __pcallFrameA = 帧;
  __pcallFrameB = 目标帧;
  pcall(__pcallSetAllPointsBody);
}

export interface 首领奖励底部按钮帧 {
  按钮: number;
  文本: number;
  命中框: number;
}

export function 创建首领奖励底部操作按钮(
  this: void,
  父帧: number,
  后缀: string,
  名字: string,
  文字: string,
  命中X: number,
  命中Y: number,
  命中宽度: number,
  命中高度: number,
  文本X: number,
  文本Y: number,
  文本宽度: number,
  文本高度: number,
  点击函数: (this: void) => void
): 首领奖励底部按钮帧 {
  const 命中框 = 创建帧({
    type: FrameType.BACKDROP,
    name: 名字 + "命中框" + 后缀,
    parent: 父帧,
    template: "template",
    visible: true,
    alpha: 0,
  }) || 0;
  if (命中框 !== 0) {
    设置帧相对位置(命中框, FramePoint.CENTER, 父帧, FramePoint.CENTER, 命中X, 命中Y);
    设置帧尺寸(命中框, { width: 命中宽度, height: 命中高度 });
    japi.DzFrameSetPriority(命中框, 259);
  }

  const 文本 = 创建帧({
    type: FrameType.TEXT,
    name: 名字 + "文字" + 后缀,
    parent: 父帧,
    template: "template",
    visible: true,
    enable: false,
  }) || 0;
  if (文本 !== 0) {
    设置帧相对位置(文本, FramePoint.TOPLEFT, 父帧, FramePoint.CENTER, 文本X, 文本Y);
    设置帧尺寸(文本, { width: 文本宽度, height: 文本高度 });
    japi.DzFrameSetTextAlignment(文本, 18);
    japi.DzFrameSetFont(文本, "Fonts\\dfst-m3u.ttf", 0.018, 0);
    japi.DzFrameSetTextColor(文本, 255, 255, 255, 255);
    japi.DzFrameSetPriority(文本, 255);
    japi.DzFrameSetText(文本, 文字);
  }

  const 按钮 = 创建帧({
    type: FrameType.GLUETEXTBUTTON,
    name: 名字 + "点击按钮" + 后缀,
    parent: 命中框 !== 0 ? 命中框 : 父帧,
    template: "template",
    visible: true,
    enable: true,
    alpha: 0,
  }) || 0;
  if (按钮 !== 0) {
    清空帧锚点(按钮);
    if (命中框 !== 0) {
      铺满目标帧(按钮, 命中框);
    } else {
      设置帧相对位置(按钮, FramePoint.CENTER, 父帧, FramePoint.CENTER, 命中X, 命中Y);
      设置帧尺寸(按钮, { width: 命中宽度, height: 命中高度 });
    }
    japi.DzFrameSetTextAlignment(按钮, 18);
    japi.DzFrameSetFont(按钮, "Fonts\\dfst-m3u.ttf", 0.014, 0);
    japi.DzFrameSetText(按钮, "");
    japi.DzFrameSetPriority(按钮, 260);
    设置帧点击事件(按钮, 点击函数 as any, true);
  }

  return { 按钮, 文本, 命中框 };
}
