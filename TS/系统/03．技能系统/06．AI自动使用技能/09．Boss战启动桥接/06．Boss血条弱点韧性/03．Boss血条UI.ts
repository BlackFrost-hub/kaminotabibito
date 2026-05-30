/** @noSelfInFile */

import type { Boss血条弱点韧性运行状态 } from "./00．类型";
import { Boss血条UI常量 } from "./01．常量定义";
import { 获取全部Boss血条弱点韧性运行状态 } from "./05．Boss弱点运行状态";

const japi = require("jass.japi") as any;
const jass = require("jass.common") as any;
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { GetUnitLifePercentBJ, IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  GetUnitLifePercentBJ: (this: void, whichUnit: any) => number;
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { getObjectPropertySafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  getObjectPropertySafe: (this: void, objectType: number, objectId: number | string, property: string) => string;
};
const { ObjectType } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  ObjectType: { UNIT: number };
};

const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (
  frameType: string,
  name: string,
  parent: number,
  template: string,
  id: number,
) => number;
const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzFrameSetModel = japi.DzFrameSetModel as (frame: number, model: string, modelType: number, flag: number) => void;
const DzFrameSetAnimate = japi.DzFrameSetAnimate as (frame: number, animId: number, auto: boolean) => void;
const DzFrameSetAnimateOffset = japi.DzFrameSetAnimateOffset as (frame: number, offset: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (
  frame: number,
  point: number,
  relativeFrame: number,
  relativePoint: number,
  x: number,
  y: number,
) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetAlpha = japi.DzFrameSetAlpha as (frame: number, alpha: number) => void;
const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (frame: number, point: number, x: number, y: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, show: boolean) => void;
const DzDestroyFrame = japi.DzDestroyFrame as (frame: number) => void;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const R2I = jass.R2I as (value: number) => number;

let 血条刷新回调ID = 0;

function 限制比例(this: void, value: number): number {
  if (value < 0) return 0;
  if (value > 1) return 1;
  return value;
}

function 取Boss头像路径(this: void, bossUnit: any): string {
  if (bossUnit == null || bossUnit === 0) return "";
  const unitTypeId = GetUnitTypeId(bossUnit);
  if (unitTypeId === 0) return "";
  return getObjectPropertySafe(ObjectType.UNIT, unitTypeId, "Art") || "";
}

function 显示血条帧组(this: void, state: Boss血条弱点韧性运行状态, visible: boolean): void {
  if (state.血条Frame !== 0) DzFrameShow(state.血条Frame, visible);
  if (state.损失血条Frame !== 0) DzFrameShow(state.损失血条Frame, visible);
  if (state.头像Frame !== 0) DzFrameShow(state.头像Frame, visible);
  if (state.血量文本Frame !== 0) DzFrameShow(state.血量文本Frame, visible);
  if (state.护盾框Frame !== 0) DzFrameShow(state.护盾框Frame, visible);
  if (state.护盾填充Frame !== 0) DzFrameShow(state.护盾填充Frame, visible);
}

function 销毁帧(this: void, frame: number): void {
  if (frame === 0) return;
  DzFrameShow(frame, false);
  DzDestroyFrame(frame);
}

function 刷新Boss血条UI(this: void, state: Boss血条弱点韧性运行状态): void {
  if (state.是否已结束 || !state.是否血条已注册) return;
  if (state.Boss单位 == null || state.Boss单位 === 0 || !IsUnitAliveBJ(state.Boss单位)) {
    显示血条帧组(state, false);
    return;
  }

  const hpPercent = GetUnitLifePercentBJ(state.Boss单位);
  const hpRatio = 限制比例(hpPercent / 100);
  const shieldValue = state.当前护盾值;
  const shieldMax = state.最大护盾值;

  if (state.血量文本Frame !== 0) {
    DzFrameSetText(state.血量文本Frame, " [HP] ：" + R2I(hpPercent).toString() + "%");
  }
  if (state.损失血条Frame !== 0) {
    DzFrameSetAnimateOffset(state.损失血条Frame, hpPercent >= 100 ? 0.9999 : hpRatio);
  }

  if (shieldValue <= 0 || shieldMax <= 0) {
    if (state.护盾填充Frame !== 0) DzFrameShow(state.护盾填充Frame, false);
    return;
  }

  const shieldRatio = 限制比例(shieldValue / shieldMax);
  if (state.护盾填充Frame !== 0) {
    DzFrameSetSize(
      state.护盾填充Frame,
      Boss血条UI常量.护盾填充基础宽 * shieldRatio,
      Boss血条UI常量.护盾填充高,
    );
    DzFrameSetAbsolutePoint(
      state.护盾填充Frame,
      Boss血条UI常量.锚点中心,
      Boss血条UI常量.护盾填充基础X - Boss血条UI常量.护盾填充偏移系数 * (1 - shieldRatio),
      Boss血条UI常量.护盾填充Y,
    );
    DzFrameShow(state.护盾填充Frame, true);
  }
}

function onBoss血条刷新Tick(this: void): void {
  const states = 获取全部Boss血条弱点韧性运行状态();
  for (let i = 0; i < states.length; i++) {
    刷新Boss血条UI(states[i]);
  }
}

function 确保Boss血条刷新(this: void): void {
  if (血条刷新回调ID !== 0) return;
  血条刷新回调ID = addPeriodicCallback(Boss血条UI常量.刷新间隔毫秒, onBoss血条刷新Tick);
}

function 停止Boss血条刷新如果空闲(this: void): void {
  if (血条刷新回调ID === 0) return;
  const states = 获取全部Boss血条弱点韧性运行状态();
  for (let i = 0; i < states.length; i++) {
    if (states[i].是否血条已注册 && !states[i].是否已结束) return;
  }
  removePeriodicCallback(血条刷新回调ID);
  血条刷新回调ID = 0;
}

function 创建Boss血条帧组(this: void, state: Boss血条弱点韧性运行状态): void {
  const gameUI = DzGetGameUI();
  state.血条Frame = DzCreateFrameByTagName("SPRITE", "BossHealthBar", gameUI, "template", 0);
  DzFrameSetModel(state.血条Frame, Boss血条UI常量.血条模型, 0, 0);
  DzFrameSetAnimate(state.血条Frame, 0, true);
  DzFrameSetPoint(
    state.血条Frame,
    Boss血条UI常量.锚点中心,
    gameUI,
    Boss血条UI常量.锚点中心,
    Boss血条UI常量.血条X,
    Boss血条UI常量.血条Y,
  );

  state.损失血条Frame = DzCreateFrameByTagName("SPRITE", "BossLostHealthBar", state.血条Frame, "template", 0);
  DzFrameSetModel(state.损失血条Frame, Boss血条UI常量.损失血条模型, 0, 0);
  DzFrameSetAnimate(state.损失血条Frame, 0, false);
  DzFrameSetPoint(
    state.损失血条Frame,
    Boss血条UI常量.锚点中心,
    gameUI,
    Boss血条UI常量.锚点中心,
    Boss血条UI常量.血条X,
    Boss血条UI常量.血条Y,
  );
  DzFrameSetPriority(state.损失血条Frame, 2);

  state.头像Frame = DzCreateFrameByTagName("BACKDROP", "BossHealthPortrait", state.血条Frame, "UI_BACKDROP_5", 0);
  DzFrameSetTexture(state.头像Frame, 取Boss头像路径(state.Boss单位), 0);
  DzFrameSetPoint(
    state.头像Frame,
    Boss血条UI常量.锚点右下,
    state.血条Frame,
    Boss血条UI常量.锚点左下,
    Boss血条UI常量.头像偏移X,
    Boss血条UI常量.头像偏移Y,
  );
  DzFrameSetSize(state.头像Frame, Boss血条UI常量.头像宽, Boss血条UI常量.头像高);

  state.血量文本Frame = DzCreateFrameByTagName("TEXT", "BossHealthText", gameUI, "UI_TEXT_10", 0);
  DzFrameSetAbsolutePoint(
    state.血量文本Frame,
    Boss血条UI常量.锚点中心,
    Boss血条UI常量.血量文本X,
    Boss血条UI常量.血量文本Y,
  );

  state.护盾框Frame = DzCreateFrameByTagName("BACKDROP", "BossShieldBarBg", state.血条Frame, "template", 0);
  DzFrameSetAlpha(state.护盾框Frame, Boss血条UI常量.护盾框透明度);
  DzFrameSetTexture(state.护盾框Frame, Boss血条UI常量.护盾底图, 0);
  DzFrameSetAbsolutePoint(
    state.护盾框Frame,
    Boss血条UI常量.锚点中心,
    Boss血条UI常量.护盾框X,
    Boss血条UI常量.护盾框Y,
  );
  DzFrameSetSize(state.护盾框Frame, Boss血条UI常量.护盾框宽, Boss血条UI常量.护盾框高);

  state.护盾填充Frame = DzCreateFrameByTagName("BACKDROP", "BossShieldBarFill", state.护盾框Frame, "template", 0);
  DzFrameSetTexture(state.护盾填充Frame, Boss血条UI常量.护盾填充图, 0);
  DzFrameSetAbsolutePoint(
    state.护盾填充Frame,
    Boss血条UI常量.锚点中心,
    Boss血条UI常量.护盾填充基础X,
    Boss血条UI常量.护盾填充Y,
  );
  DzFrameSetSize(state.护盾填充Frame, Boss血条UI常量.护盾填充显示宽, Boss血条UI常量.护盾填充高);
  显示血条帧组(state, true);
}

export function 注册Boss血条UI(this: void, state: Boss血条弱点韧性运行状态): void {
  if (state.是否已结束 || state.是否血条已注册) return;
  创建Boss血条帧组(state);
  state.是否血条已注册 = true;
  刷新Boss血条UI(state);
  确保Boss血条刷新();
}

export function 注销Boss血条UI(this: void, state: Boss血条弱点韧性运行状态): void {
  if (!state.是否血条已注册) return;
  销毁帧(state.护盾填充Frame);
  销毁帧(state.护盾框Frame);
  销毁帧(state.血量文本Frame);
  销毁帧(state.头像Frame);
  销毁帧(state.损失血条Frame);
  销毁帧(state.血条Frame);
  state.护盾填充Frame = 0;
  state.护盾框Frame = 0;
  state.血量文本Frame = 0;
  state.头像Frame = 0;
  state.损失血条Frame = 0;
  state.血条Frame = 0;
  state.是否血条已注册 = false;
  停止Boss血条刷新如果空闲();
}
