/** @noSelfInFile */

import type { Boss血条弱点韧性运行状态 } from "./00．类型";
import { Boss弱点UI常量 } from "./01．常量定义";
import {
  刷新Boss血条槽位布局,
  计算Boss弱点X坐标,
  计算Boss护盾图标X,
  获取Boss机制图标缩放,
} from "./03．Boss血条UI";

const japi = require("jass.japi") as any;
const { frameSetScriptByCode } = require("lib.扩展函数.封装函数.04．硬件输入.index") as {
  frameSetScriptByCode: (
    this: void,
    frame: number,
    eventId: number,
    action: any,
    sync: boolean,
    playerId?: number,
  ) => void;
};

const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (
  frameType: string,
  name: string,
  parent: number,
  template: string,
  id: number,
) => number;
const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (frame: number, point: number, x: number, y: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (
  frame: number,
  point: number,
  relativeFrame: number,
  relativePoint: number,
  x: number,
  y: number,
) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, show: boolean) => void;
const DzDestroyFrame = japi.DzDestroyFrame as (frame: number) => void;
const DzGetTriggerUIEventFrame = japi.DzGetTriggerUIEventFrame as () => number;
const DzFrameSetAlpha = japi.DzFrameSetAlpha as (frame: number, alpha: number) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;

const FRAME_EVENT_MOUSE_ENTER = 2;
const FRAME_EVENT_MOUSE_LEAVE = 3;
// DzFrame 返回数字 frame id，不是 JASS handle；这里直接用按钮 frame id 反查本地提示框。
const 护盾提示框By按钮: Record<number, number | undefined> = {};

function 记录弱点UIFrame(this: void, state: Boss血条弱点韧性运行状态, frame: number): void {
  if (frame === 0) return;
  state.弱点UIFrame列表.push(frame);
}

function 移除弱点UIFrame记录(this: void, state: Boss血条弱点韧性运行状态, frame: number): void {
  if (frame === 0) return;
  for (let i = state.弱点UIFrame列表.length - 1; i >= 0; i--) {
    if (state.弱点UIFrame列表[i] === frame) state.弱点UIFrame列表.splice(i, 1);
  }
}

function 销毁帧(this: void, frame: number): void {
  if (frame === 0) return;
  DzFrameShow(frame, false);
  DzDestroyFrame(frame);
}

function on护盾说明按钮进入(this: void): void {
  const buttonFrame = DzGetTriggerUIEventFrame();
  const tooltipFrame = 护盾提示框By按钮[buttonFrame] || 0;
  if (tooltipFrame !== 0) DzFrameShow(tooltipFrame, true);
}

function on护盾说明按钮离开(this: void): void {
  const buttonFrame = DzGetTriggerUIEventFrame();
  const tooltipFrame = 护盾提示框By按钮[buttonFrame] || 0;
  if (tooltipFrame !== 0) DzFrameShow(tooltipFrame, false);
}

function 创建Boss弱点问号UI(this: void, state: Boss血条弱点韧性运行状态): void {
  if (state.配置 == null) return;
  const weakList = state.配置.弱点列表;
  const iconScale = 获取Boss机制图标缩放(state);
  for (let i = 0; i < weakList.length; i++) {
    const x = 计算Boss弱点X坐标(state, i);
    const frame = DzCreateFrameByTagName("BACKDROP", "BossWeakQuestion", state.血条Frame, "template", i + 1);
    DzFrameSetSize(frame, Boss弱点UI常量.弱点图标宽 * iconScale, Boss弱点UI常量.弱点图标高 * iconScale);
    DzFrameSetAbsolutePoint(frame, Boss弱点UI常量.锚点中心, x, Boss弱点UI常量.弱点Y);
    DzFrameSetTexture(frame, Boss弱点UI常量.问号图标, 0);
    DzFrameShow(frame, true);
    state.弱点问号Frame列表.push(frame);
    state.弱点图标Frame列表.push(0);
    state.弱点X轴列表.push(x);
    state.弱点已暴露列表.push(false);
    state.弱点保护列表.push(false);
    state.弱点保护截止毫秒列表.push(0);
    state.弱点命中表现截止毫秒列表.push(0);
    记录弱点UIFrame(state, frame);
  }
}

function 创建Boss护盾说明UI(this: void, state: Boss血条弱点韧性运行状态): void {
  const shieldMax = state.最大护盾值;
  const iconScale = 获取Boss机制图标缩放(state);
  const shieldIconX = 计算Boss护盾图标X(state);

  state.护盾图标Frame = DzCreateFrameByTagName("BACKDROP", "BossWeakShieldIcon", state.血条Frame, "template", 13);
  DzFrameSetAbsolutePoint(
    state.护盾图标Frame,
    Boss弱点UI常量.锚点中心,
    shieldIconX,
    Boss弱点UI常量.护盾图标Y,
  );
  DzFrameSetTexture(state.护盾图标Frame, Boss弱点UI常量.护盾图标, 0);
  DzFrameSetSize(
    state.护盾图标Frame,
    Boss弱点UI常量.护盾图标宽 * iconScale,
    Boss弱点UI常量.护盾图标高 * iconScale,
  );
  记录弱点UIFrame(state, state.护盾图标Frame);

  state.护盾文本Frame = DzCreateFrameByTagName("TEXT", "BossWeakShieldText", state.护盾图标Frame, "template", 0);
  DzFrameSetPoint(
    state.护盾文本Frame,
    Boss弱点UI常量.锚点中心,
    state.护盾图标Frame,
    Boss弱点UI常量.锚点中心,
    0,
    0,
  );
  DzFrameSetText(state.护盾文本Frame, "|cffff6600" + shieldMax.toString() + "|r");
  DzFrameSetSize(state.护盾文本Frame, Boss弱点UI常量.护盾文本宽, Boss弱点UI常量.护盾文本高);
  记录弱点UIFrame(state, state.护盾文本Frame);

  state.护盾说明按钮Frame = DzCreateFrameByTagName("GLUETEXTBUTTON", "BossWeakShieldHelpButton", state.血条Frame, "template", 0);
  DzFrameSetAbsolutePoint(
    state.护盾说明按钮Frame,
    Boss弱点UI常量.锚点中心,
    shieldIconX,
    Boss弱点UI常量.护盾图标Y,
  );
  DzFrameSetSize(
    state.护盾说明按钮Frame,
    Boss弱点UI常量.护盾说明按钮宽 * iconScale,
    Boss弱点UI常量.护盾说明按钮高 * iconScale,
  );
  DzFrameSetText(state.护盾说明按钮Frame, "");
  DzFrameSetAlpha(state.护盾说明按钮Frame, 0);
  DzFrameSetPriority(state.护盾说明按钮Frame, Boss弱点UI常量.护盾说明按钮优先级);
  frameSetScriptByCode(state.护盾说明按钮Frame, FRAME_EVENT_MOUSE_ENTER, on护盾说明按钮进入, false);
  frameSetScriptByCode(state.护盾说明按钮Frame, FRAME_EVENT_MOUSE_LEAVE, on护盾说明按钮离开, false);
  记录弱点UIFrame(state, state.护盾说明按钮Frame);

  state.护盾提示文本框Frame = DzCreateFrameByTagName("BACKDROP", "BossWeakShieldTooltipBg", state.血条Frame, "template", 0);
  DzFrameSetTexture(state.护盾提示文本框Frame, Boss弱点UI常量.护盾提示框图, 0);
  DzFrameSetSize(state.护盾提示文本框Frame, Boss弱点UI常量.护盾提示框宽, Boss弱点UI常量.护盾提示框高);
  DzFrameSetPoint(
    state.护盾提示文本框Frame,
    Boss弱点UI常量.锚点中心,
    state.护盾图标Frame,
    Boss弱点UI常量.锚点中心,
    Boss弱点UI常量.护盾提示框偏移X,
    Boss弱点UI常量.护盾提示框偏移Y,
  );
  DzFrameSetPriority(state.护盾提示文本框Frame, Boss弱点UI常量.护盾提示框优先级);
  DzFrameShow(state.护盾提示文本框Frame, false);
  护盾提示框By按钮[state.护盾说明按钮Frame] = state.护盾提示文本框Frame;
  记录弱点UIFrame(state, state.护盾提示文本框Frame);

  state.护盾提示文本Frame = DzCreateFrameByTagName("TEXT", "BossWeakShieldTooltipText", state.护盾提示文本框Frame, "template", 0);
  DzFrameSetSize(state.护盾提示文本Frame, Boss弱点UI常量.护盾提示文本宽, Boss弱点UI常量.护盾提示文本高);
  DzFrameSetPoint(
    state.护盾提示文本Frame,
    Boss弱点UI常量.锚点中心,
    state.护盾提示文本框Frame,
    Boss弱点UI常量.锚点中心,
    0,
    0,
  );
  DzFrameSetText(state.护盾提示文本Frame, Boss弱点UI常量.护盾说明文本);
  DzFrameSetPriority(state.护盾提示文本Frame, Boss弱点UI常量.护盾提示框优先级);
  记录弱点UIFrame(state, state.护盾提示文本Frame);

  state.破碎护盾Frame = DzCreateFrameByTagName("BACKDROP", "BossWeakShieldBroken", state.血条Frame, "template", 14);
  DzFrameSetAbsolutePoint(
    state.破碎护盾Frame,
    Boss弱点UI常量.锚点中心,
    shieldIconX,
    Boss弱点UI常量.护盾状态图标Y,
  );
  DzFrameSetTexture(state.破碎护盾Frame, Boss弱点UI常量.破碎护盾图标, 0);
  DzFrameSetSize(
    state.破碎护盾Frame,
    Boss弱点UI常量.破碎护盾宽 * iconScale,
    Boss弱点UI常量.破碎护盾高 * iconScale,
  );
  DzFrameShow(state.破碎护盾Frame, false);
  记录弱点UIFrame(state, state.破碎护盾Frame);

  state.灰色护盾Frame = DzCreateFrameByTagName("BACKDROP", "BossWeakShieldGray", state.血条Frame, "template", 15);
  DzFrameSetAbsolutePoint(
    state.灰色护盾Frame,
    Boss弱点UI常量.锚点中心,
    shieldIconX,
    Boss弱点UI常量.护盾状态图标Y,
  );
  DzFrameSetTexture(state.灰色护盾Frame, Boss弱点UI常量.灰色护盾图标, 0);
  DzFrameSetSize(
    state.灰色护盾Frame,
    Boss弱点UI常量.护盾图标宽 * iconScale,
    Boss弱点UI常量.护盾图标高 * iconScale,
  );
  DzFrameShow(state.灰色护盾Frame, false);
  记录弱点UIFrame(state, state.灰色护盾Frame);
}

export function 注册Boss弱点UI(this: void, state: Boss血条弱点韧性运行状态): void {
  if (state.是否已结束 || state.是否弱点已注册) return;
  if (!state.是否血条已注册) return;
  if (!state.是否启用机制UI) return;
  创建Boss弱点问号UI(state);
  创建Boss护盾说明UI(state);
  state.是否弱点已注册 = true;
  刷新Boss血条槽位布局(state);
}

export function 注销Boss弱点UI(this: void, state: Boss血条弱点韧性运行状态): void {
  if (!state.是否弱点已注册) return;
  if (state.护盾说明按钮Frame !== 0) {
    护盾提示框By按钮[state.护盾说明按钮Frame] = undefined;
  }
  for (let i = state.弱点UIFrame列表.length - 1; i >= 0; i--) {
    销毁帧(state.弱点UIFrame列表[i]);
  }
  state.弱点UIFrame列表 = [];
  state.弱点问号Frame列表 = [];
  state.弱点图标Frame列表 = [];
  state.弱点X轴列表 = [];
  state.弱点已暴露列表 = [];
  state.弱点保护列表 = [];
  state.弱点保护截止毫秒列表 = [];
  state.弱点命中表现截止毫秒列表 = [];
  state.护盾图标Frame = 0;
  state.灰色护盾Frame = 0;
  state.破碎护盾Frame = 0;
  state.护盾文本Frame = 0;
  state.护盾说明按钮Frame = 0;
  state.护盾提示文本框Frame = 0;
  state.护盾提示文本Frame = 0;
  state.是否弱点已注册 = false;
}

export function 显示Boss弱点真实图标(this: void, state: Boss血条弱点韧性运行状态, weakIndex: number): void {
  if (state.配置 == null) return;
  if (weakIndex < 0 || weakIndex >= state.配置.弱点列表.length) return;
  if (state.弱点已暴露列表[weakIndex] === true) return;

  const questionFrame = state.弱点问号Frame列表[weakIndex] || 0;
  if (questionFrame !== 0) {
    移除弱点UIFrame记录(state, questionFrame);
    销毁帧(questionFrame);
  }
  state.弱点问号Frame列表[weakIndex] = 0;

  const weak = state.配置.弱点列表[weakIndex];
  const x = state.弱点X轴列表[weakIndex] || 计算Boss弱点X坐标(state, weakIndex);
  const iconScale = 获取Boss机制图标缩放(state);
  const iconFrame = DzCreateFrameByTagName("BACKDROP", "BossWeakIcon", state.血条Frame, "template", 30 + weakIndex);
  DzFrameSetSize(iconFrame, Boss弱点UI常量.弱点图标宽 * iconScale, Boss弱点UI常量.弱点图标高 * iconScale);
  DzFrameSetAbsolutePoint(iconFrame, Boss弱点UI常量.锚点中心, x, Boss弱点UI常量.弱点Y);
  DzFrameSetTexture(iconFrame, weak.贴图路径, 0);
  DzFrameShow(iconFrame, true);
  state.弱点图标Frame列表[weakIndex] = iconFrame;
  state.弱点已暴露列表[weakIndex] = true;
  记录弱点UIFrame(state, iconFrame);
  刷新Boss血条槽位布局(state);
}

export function 设置Boss弱点命中表现(this: void, state: Boss血条弱点韧性运行状态, weakIndex: number, active: boolean): void {
  const frame = state.弱点图标Frame列表[weakIndex] || 0;
  if (frame === 0) return;
  const iconScale = 获取Boss机制图标缩放(state);
  DzFrameSetSize(
    frame,
    (active ? Boss弱点UI常量.弱点命中图标宽 : Boss弱点UI常量.弱点图标宽) * iconScale,
    (active ? Boss弱点UI常量.弱点命中图标高 : Boss弱点UI常量.弱点图标高) * iconScale,
  );
}

export function 刷新Boss护盾文本(this: void, state: Boss血条弱点韧性运行状态, shieldValue: number): void {
  if (state.护盾文本Frame === 0) return;
  DzFrameSetText(state.护盾文本Frame, "|cffff6600" + shieldValue.toString() + "|r");
}

export function 设置Boss护盾完整显示(this: void, state: Boss血条弱点韧性运行状态): void {
  if (state.护盾图标Frame !== 0) DzFrameShow(state.护盾图标Frame, true);
  if (state.护盾文本Frame !== 0) DzFrameShow(state.护盾文本Frame, true);
  if (state.护盾说明按钮Frame !== 0) DzFrameShow(state.护盾说明按钮Frame, true);
  if (state.护盾提示文本框Frame !== 0) DzFrameShow(state.护盾提示文本框Frame, false);
  if (state.破碎护盾Frame !== 0) DzFrameShow(state.破碎护盾Frame, false);
  if (state.灰色护盾Frame !== 0) DzFrameShow(state.灰色护盾Frame, false);
}

export function 设置Boss护盾破碎显示(this: void, state: Boss血条弱点韧性运行状态): void {
  if (state.护盾图标Frame !== 0) DzFrameShow(state.护盾图标Frame, false);
  if (state.护盾提示文本框Frame !== 0) DzFrameShow(state.护盾提示文本框Frame, false);
  if (state.破碎护盾Frame !== 0) DzFrameShow(state.破碎护盾Frame, true);
  if (state.灰色护盾Frame !== 0) DzFrameShow(state.灰色护盾Frame, false);
}

export function 设置Boss护盾灰色显示(this: void, state: Boss血条弱点韧性运行状态): void {
  if (state.护盾图标Frame !== 0) DzFrameShow(state.护盾图标Frame, false);
  if (state.护盾提示文本框Frame !== 0) DzFrameShow(state.护盾提示文本框Frame, false);
  if (state.破碎护盾Frame !== 0) DzFrameShow(state.破碎护盾Frame, false);
  if (state.灰色护盾Frame !== 0) DzFrameShow(state.灰色护盾Frame, true);
}
