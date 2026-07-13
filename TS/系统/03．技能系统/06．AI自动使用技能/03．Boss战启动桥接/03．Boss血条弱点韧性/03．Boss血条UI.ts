/** @noSelfInFile */

import type { Boss血条弱点韧性运行状态 } from "./00．类型";
import { Boss血条UI常量, Boss护卫血条UI常量, Boss弱点UI常量 } from "./01．常量定义";
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
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, moduleName: string, ...args: any[]) => void;
};

const Boss血条头像调试模块名 = "Boss血条头像";

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
const DzFrameSetScale = japi.DzFrameSetScale as (frame: number, scale: number) => void;
const DzFrameSetModelScale = japi.DzFrameSetModelScale as (frame: number, x: number, y: number, z: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetAlpha = japi.DzFrameSetAlpha as (frame: number, alpha: number) => void;
const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (frame: number, point: number, x: number, y: number) => void;
const DzFrameClearAllPoints = japi.DzFrameClearAllPoints as (frame: number) => void;
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

function 取Boss单位默认头像路径(this: void, bossUnit: any): string {
  if (bossUnit == null || bossUnit === 0) {
    debugLogForce(Boss血条头像调试模块名, "默认头像读取失败", "原因=单位为空");
    return "";
  }
  const unitTypeId = GetUnitTypeId(bossUnit);
  if (unitTypeId === 0) {
    debugLogForce(Boss血条头像调试模块名, "默认头像读取失败", "原因=单位类型ID为0");
    return "";
  }
  const artPath = getObjectPropertySafe(ObjectType.UNIT, unitTypeId, "Art") || "";
  debugLogForce(Boss血条头像调试模块名, "读取物编头像", "unitTypeId=", unitTypeId, "Art=", artPath === "" ? "<空>" : artPath);
  return artPath;
}

function 计算Boss血条槽位Y偏移(this: void, state: Boss血条弱点韧性运行状态): number {
  const slotIndex = state.血条槽位索引 > 0 ? state.血条槽位索引 : 0;
  const 是否应用后续槽位补偿 = state.显示类型 === "护卫" ? slotIndex > 1 : slotIndex >= 1;
  return -Boss血条UI常量.槽位垂直间距 * slotIndex
    + (是否应用后续槽位补偿 ? Boss血条UI常量.第二槽及后续Y补偿 : 0)
    + (state.显示类型 === "护卫" ? Boss护卫血条UI常量.整组Y补偿 : 0);
}

function 计算护卫槽位中心偏移X(this: void, state: Boss血条弱点韧性运行状态): number {
  if (state.显示类型 !== "护卫") return 0;
  return state.护卫槽位索引 === 1
    ? Boss护卫血条UI常量.右槽中心偏移X
    : Boss护卫血条UI常量.左槽中心偏移X;
}

function 计算Boss血条X(this: void, state: Boss血条弱点韧性运行状态): number {
  return Boss血条UI常量.血条X
    + 计算护卫槽位中心偏移X(state)
    + (state.显示类型 === "护卫" ? Boss护卫血条UI常量.红色血条模型X补偿 : 0);
}

function 计算Boss损失血条X(this: void, state: Boss血条弱点韧性运行状态): number {
  return Boss血条UI常量.血条X + 计算护卫槽位中心偏移X(state);
}

function 计算Boss红色血条Y(this: void, state: Boss血条弱点韧性运行状态, yOffset: number): number {
  return Boss血条UI常量.血条Y
    + yOffset
    + (state.显示类型 === "护卫" ? Boss护卫血条UI常量.红色血条模型Y补偿 : 0);
}

function 计算Boss护盾填充Y(this: void, state: Boss血条弱点韧性运行状态, yOffset: number): number {
  return Boss血条UI常量.护盾填充Y
    + yOffset
    + (state.显示类型 === "护卫" ? Boss护卫血条UI常量.护盾填充Y补偿 : 0);
}

function 计算Boss机制图标Y(this: void, state: Boss血条弱点韧性运行状态, baseY: number, yOffset: number): number {
  return baseY
    + yOffset
    + (state.显示类型 === "护卫" ? Boss护卫血条UI常量.弱点图标Y补偿 : 0);
}

function 计算Boss护盾框X(this: void, state: Boss血条弱点韧性运行状态): number {
  return Boss血条UI常量.护盾框X + 计算护卫槽位中心偏移X(state);
}

function 计算Boss护盾填充基础X(this: void, state: Boss血条弱点韧性运行状态): number {
  return Boss血条UI常量.护盾填充基础X
    + 计算护卫槽位中心偏移X(state)
    + (state.显示类型 === "护卫" ? Boss护卫血条UI常量.护盾填充X补偿 : 0);
}

export function 计算Boss弱点X坐标(this: void, state: Boss血条弱点韧性运行状态, weakIndex: number): number {
  if (state.显示类型 !== "护卫") {
    return Boss弱点UI常量.弱点起始X + Boss弱点UI常量.弱点间距 * (weakIndex + 1);
  }
  const startX = state.护卫槽位索引 === 1
    ? Boss护卫血条UI常量.右槽弱点起始X
    : Boss护卫血条UI常量.左槽弱点起始X;
  return startX + Boss护卫血条UI常量.弱点间距 * weakIndex;
}

export function 计算Boss护盾图标X(this: void, state: Boss血条弱点韧性运行状态): number {
  if (state.显示类型 !== "护卫") return Boss弱点UI常量.护盾图标X;
  return state.护卫槽位索引 === 1
    ? Boss护卫血条UI常量.右槽弱点起始X
    : Boss护卫血条UI常量.左槽弱点起始X;
}

export function 获取Boss机制图标缩放(this: void, state: Boss血条弱点韧性运行状态): number {
  return state.显示类型 === "护卫" ? Boss护卫血条UI常量.机制图标缩放 : 1;
}

function 重设绝对点(this: void, frame: number, point: number, x: number, y: number): void {
  if (frame === 0) return;
  DzFrameClearAllPoints(frame);
  DzFrameSetAbsolutePoint(frame, point, x, y);
}

function 重设相对点(
  this: void,
  frame: number,
  point: number,
  relativeFrame: number,
  relativePoint: number,
  x: number,
  y: number,
): void {
  if (frame === 0) return;
  DzFrameClearAllPoints(frame);
  DzFrameSetPoint(frame, point, relativeFrame, relativePoint, x, y);
}

export function 刷新Boss血条槽位布局(this: void, state: Boss血条弱点韧性运行状态): void {
  if (!state.是否血条已注册 || state.是否已结束) return;
  const gameUI = DzGetGameUI();
  const yOffset = 计算Boss血条槽位Y偏移(state);

  重设相对点(
    state.血条Frame,
    Boss血条UI常量.锚点中心,
    gameUI,
    Boss血条UI常量.锚点中心,
    计算Boss血条X(state),
    计算Boss红色血条Y(state, yOffset),
  );
  重设相对点(
    state.损失血条Frame,
    Boss血条UI常量.锚点中心,
    gameUI,
    Boss血条UI常量.锚点中心,
    计算Boss损失血条X(state),
    Boss血条UI常量.血条Y + yOffset,
  );
  重设绝对点(
    state.血量文本Frame,
    Boss血条UI常量.锚点中心,
    state.显示类型 === "护卫" ? 计算Boss护盾框X(state) : Boss血条UI常量.血量文本X,
    Boss血条UI常量.血量文本Y + yOffset,
  );
  重设绝对点(
    state.护盾框Frame,
    Boss血条UI常量.锚点中心,
    计算Boss护盾框X(state),
    Boss血条UI常量.护盾框Y + yOffset,
  );

  const shieldRatio = state.最大护盾值 > 0 ? 限制比例(state.当前护盾值 / state.最大护盾值) : 1;
  重设绝对点(
    state.护盾填充Frame,
    Boss血条UI常量.锚点中心,
    计算Boss护盾填充基础X(state)
      - (state.显示类型 === "护卫" ? Boss护卫血条UI常量.护盾填充偏移系数 : Boss血条UI常量.护盾填充偏移系数) * (1 - shieldRatio),
    计算Boss护盾填充Y(state, yOffset),
  );

  for (let i = 0; i < state.弱点X轴列表.length; i++) {
    const x = 计算Boss弱点X坐标(state, i);
    state.弱点X轴列表[i] = x;
    重设绝对点(
      state.弱点问号Frame列表[i] || 0,
      Boss弱点UI常量.锚点中心,
      x,
      计算Boss机制图标Y(state, Boss弱点UI常量.弱点Y, yOffset),
    );
    重设绝对点(
      state.弱点图标Frame列表[i] || 0,
      Boss弱点UI常量.锚点中心,
      x,
      计算Boss机制图标Y(state, Boss弱点UI常量.弱点Y, yOffset),
    );
  }

  重设绝对点(
    state.护盾图标Frame,
    Boss弱点UI常量.锚点中心,
    计算Boss护盾图标X(state),
    计算Boss机制图标Y(state, Boss弱点UI常量.护盾图标Y, yOffset),
  );
  重设绝对点(
    state.护盾说明按钮Frame,
    Boss弱点UI常量.锚点中心,
    计算Boss护盾图标X(state),
    计算Boss机制图标Y(state, Boss弱点UI常量.护盾图标Y, yOffset),
  );
  重设绝对点(
    state.破碎护盾Frame,
    Boss弱点UI常量.锚点中心,
    计算Boss护盾图标X(state),
    计算Boss机制图标Y(state, Boss弱点UI常量.护盾状态图标Y, yOffset),
  );
  重设绝对点(
    state.灰色护盾Frame,
    Boss弱点UI常量.锚点中心,
    计算Boss护盾图标X(state),
    计算Boss机制图标Y(state, Boss弱点UI常量.护盾状态图标Y, yOffset),
  );
}

export function 重新排列Boss血条槽位(this: void): void {
  const allStates = 获取全部Boss血条弱点韧性运行状态();
  const activeBossStates: Boss血条弱点韧性运行状态[] = [];
  const activeIndependentGuardStates: Boss血条弱点韧性运行状态[] = [];
  const activeSharedGuardStates: Boss血条弱点韧性运行状态[] = [];
  for (let i = 0; i < allStates.length; i++) {
    const state = allStates[i];
    if (!state.是否血条已注册 || state.是否已结束) continue;
    if (state.显示类型 !== "护卫") {
      activeBossStates.push(state);
    } else if (state.护卫血条归属类型 === "共享") {
      activeSharedGuardStates.push(state);
    } else {
      activeIndependentGuardStates.push(state);
    }
  }

  let rowIndex = 0;
  const arrangedIndependentGuardStates: Boss血条弱点韧性运行状态[] = [];
  for (let i = 0; i < activeBossStates.length; i++) {
    const bossState = activeBossStates[i];
    bossState.血条槽位索引 = rowIndex;
    bossState.护卫槽位索引 = -1;
    刷新Boss血条槽位布局(bossState);
    rowIndex++;

    let guardSlotIndex = 0;
    for (let guardIndex = 0; guardIndex < activeIndependentGuardStates.length; guardIndex++) {
      const guardState = activeIndependentGuardStates[guardIndex];
      if (guardState.所属主Boss句柄ID !== bossState.所属主Boss句柄ID) continue;
      guardState.血条槽位索引 = rowIndex;
      guardState.护卫槽位索引 = guardSlotIndex;
      刷新Boss血条槽位布局(guardState);
      arrangedIndependentGuardStates.push(guardState);
      guardSlotIndex++;
    }
    if (guardSlotIndex > 0) rowIndex += Boss护卫血条UI常量.护卫行占用槽位;
  }

  for (let i = 0; i < activeIndependentGuardStates.length; i++) {
    const firstGuardState = activeIndependentGuardStates[i];
    let alreadyArranged = false;
    for (let arrangedIndex = 0; arrangedIndex < arrangedIndependentGuardStates.length; arrangedIndex++) {
      if (arrangedIndependentGuardStates[arrangedIndex] === firstGuardState) alreadyArranged = true;
    }
    if (alreadyArranged) continue;

    let guardSlotIndex = 0;
    for (let guardIndex = i; guardIndex < activeIndependentGuardStates.length; guardIndex++) {
      const guardState = activeIndependentGuardStates[guardIndex];
      if (guardState.所属主Boss句柄ID !== firstGuardState.所属主Boss句柄ID) continue;
      guardState.血条槽位索引 = rowIndex;
      guardState.护卫槽位索引 = guardSlotIndex;
      刷新Boss血条槽位布局(guardState);
      arrangedIndependentGuardStates.push(guardState);
      guardSlotIndex++;
    }
    if (guardSlotIndex > 0) rowIndex += Boss护卫血条UI常量.护卫行占用槽位;
  }

  for (let i = 0; i < activeSharedGuardStates.length; i++) {
    const state = activeSharedGuardStates[i];
    state.血条槽位索引 = rowIndex;
    state.护卫槽位索引 = i;
    刷新Boss血条槽位布局(state);
  }
}

function 取Boss头像路径(this: void, state: Boss血条弱点韧性运行状态): string {
  if (state.头像覆盖贴图路径 !== "") return state.头像覆盖贴图路径;
  return 取Boss单位默认头像路径(state.Boss单位);
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
  const yOffset = 计算Boss血条槽位Y偏移(state);
  if (state.护盾填充Frame !== 0) {
    DzFrameSetSize(
      state.护盾填充Frame,
      (state.显示类型 === "护卫" ? Boss护卫血条UI常量.护盾填充基础宽 : Boss血条UI常量.护盾填充基础宽) * shieldRatio,
      state.显示类型 === "护卫" ? Boss护卫血条UI常量.护盾填充高 : Boss血条UI常量.护盾填充高,
    );
    重设绝对点(
      state.护盾填充Frame,
      Boss血条UI常量.锚点中心,
      计算Boss护盾填充基础X(state)
        - (state.显示类型 === "护卫" ? Boss护卫血条UI常量.护盾填充偏移系数 : Boss血条UI常量.护盾填充偏移系数) * (1 - shieldRatio),
      计算Boss护盾填充Y(state, yOffset),
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
  const isGuard = state.显示类型 === "护卫";
  const barScale = isGuard ? Boss护卫血条UI常量.血条缩放 : 1;
  state.血条Frame = DzCreateFrameByTagName("SPRITE", "BossHealthBar", gameUI, "template", 0);
  DzFrameSetModel(state.血条Frame, Boss血条UI常量.血条模型, 0, 0);
  DzFrameSetAnimate(state.血条Frame, 0, true);
  DzFrameSetScale(state.血条Frame, barScale);
  if (isGuard) {
    DzFrameSetModelScale(
      state.血条Frame,
      Boss护卫血条UI常量.红色血条模型横向缩放,
      Boss护卫血条UI常量.红色血条模型高度缩放,
      1,
    );
  }
  DzFrameSetPoint(
    state.血条Frame,
    Boss血条UI常量.锚点中心,
    gameUI,
    Boss血条UI常量.锚点中心,
    计算Boss血条X(state),
    计算Boss红色血条Y(state, 0),
  );

  state.损失血条Frame = DzCreateFrameByTagName("SPRITE", "BossLostHealthBar", state.血条Frame, "template", 0);
  DzFrameSetModel(state.损失血条Frame, Boss血条UI常量.损失血条模型, 0, 0);
  DzFrameSetAnimate(state.损失血条Frame, 0, false);
  DzFrameSetScale(state.损失血条Frame, barScale);
  DzFrameSetPoint(
    state.损失血条Frame,
    Boss血条UI常量.锚点中心,
    gameUI,
    Boss血条UI常量.锚点中心,
    计算Boss损失血条X(state),
    Boss血条UI常量.血条Y,
  );
  DzFrameSetPriority(state.损失血条Frame, 2);

  state.头像Frame = DzCreateFrameByTagName("BACKDROP", "BossHealthPortrait", state.血条Frame, "UI_BACKDROP_5", 0);
  const portraitPath = 取Boss头像路径(state);
  DzFrameSetTexture(state.头像Frame, portraitPath, 0);
  debugLogForce(
    Boss血条头像调试模块名,
    "创建头像Frame",
    "boss=",
    state.Boss句柄ID,
    "frame=",
    state.头像Frame,
    "override=",
    state.头像覆盖贴图路径 === "" ? "<无>" : state.头像覆盖贴图路径,
    "finalPath=",
    portraitPath === "" ? "<空>" : portraitPath,
  );
  DzFrameSetPoint(
    state.头像Frame,
    Boss血条UI常量.锚点右下,
    state.血条Frame,
    Boss血条UI常量.锚点左下,
    isGuard ? Boss护卫血条UI常量.头像偏移X : Boss血条UI常量.头像偏移X,
    isGuard ? Boss护卫血条UI常量.头像偏移Y : Boss血条UI常量.头像偏移Y,
  );
  DzFrameSetSize(
    state.头像Frame,
    isGuard ? Boss护卫血条UI常量.头像宽 : Boss血条UI常量.头像宽,
    isGuard ? Boss护卫血条UI常量.头像高 : Boss血条UI常量.头像高,
  );

  state.血量文本Frame = DzCreateFrameByTagName("TEXT", "BossHealthText", gameUI, "UI_TEXT_10", 0);
  DzFrameSetAbsolutePoint(
    state.血量文本Frame,
    Boss血条UI常量.锚点中心,
    isGuard ? 计算Boss护盾框X(state) : Boss血条UI常量.血量文本X,
    Boss血条UI常量.血量文本Y,
  );
  if (isGuard) DzFrameSetScale(state.血量文本Frame, Boss护卫血条UI常量.血量文本缩放);

  if (state.是否启用机制UI) {
    state.护盾框Frame = DzCreateFrameByTagName("BACKDROP", "BossShieldBarBg", state.血条Frame, "template", 0);
    DzFrameSetAlpha(state.护盾框Frame, Boss血条UI常量.护盾框透明度);
    DzFrameSetTexture(state.护盾框Frame, Boss血条UI常量.护盾底图, 0);
    DzFrameSetAbsolutePoint(
      state.护盾框Frame,
      Boss血条UI常量.锚点中心,
      计算Boss护盾框X(state),
      Boss血条UI常量.护盾框Y,
    );
    DzFrameSetSize(
      state.护盾框Frame,
      isGuard ? Boss护卫血条UI常量.护盾框宽 : Boss血条UI常量.护盾框宽,
      isGuard ? Boss护卫血条UI常量.护盾框高 : Boss血条UI常量.护盾框高,
    );

    state.护盾填充Frame = DzCreateFrameByTagName("BACKDROP", "BossShieldBarFill", state.护盾框Frame, "template", 0);
    DzFrameSetTexture(state.护盾填充Frame, Boss血条UI常量.护盾填充图, 0);
    DzFrameSetAbsolutePoint(
      state.护盾填充Frame,
      Boss血条UI常量.锚点中心,
      计算Boss护盾填充基础X(state),
      计算Boss护盾填充Y(state, 0),
    );
    DzFrameSetSize(
      state.护盾填充Frame,
      isGuard ? Boss护卫血条UI常量.护盾填充显示宽 : Boss血条UI常量.护盾填充显示宽,
      isGuard ? Boss护卫血条UI常量.护盾填充高 : Boss血条UI常量.护盾填充高,
    );
  }
  显示血条帧组(state, true);
}

export function 注册Boss血条UI(this: void, state: Boss血条弱点韧性运行状态): void {
  if (state.是否已结束 || state.是否血条已注册) return;
  创建Boss血条帧组(state);
  state.是否血条已注册 = true;
  重新排列Boss血条槽位();
  刷新Boss血条UI(state);
  确保Boss血条刷新();
}

export function 更新Boss血条头像贴图(
  this: void,
  state: Boss血条弱点韧性运行状态,
  头像贴图路径: string,
): boolean {
  if (state.是否已结束) return false;
  state.头像覆盖贴图路径 = 头像贴图路径;
  if (state.头像Frame !== 0) {
    const portraitPath = 取Boss头像路径(state);
    DzFrameSetTexture(state.头像Frame, portraitPath, 0);
    debugLogForce(
      Boss血条头像调试模块名,
      "更新头像贴图",
      "boss=",
      state.Boss句柄ID,
      "frame=",
      state.头像Frame,
      "finalPath=",
      portraitPath === "" ? "<空>" : portraitPath,
    );
  }
  return true;
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
  state.血条槽位索引 = -1;
  重新排列Boss血条槽位();
  停止Boss血条刷新如果空闲();
}
