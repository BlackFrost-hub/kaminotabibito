/** @noSelfInFile */

const japi = require("jass.japi") as any;
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: (this: void) => void) => void;
  offTick10ms: (this: void, callback: (this: void) => void) => void;
};
import { 护盾类型 } from "./01．护盾类型";

const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (type: string, name: string, parent: number, template: string, id: number) => number;
const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzFrameGetLowerLevelFrame = japi.DzFrameGetLowerLevelFrame as () => number;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: number, point: number, relativeFrame: number, relativePoint: number, x: number, y: number) => void;
const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment as (frame: number, align: number) => void;
const DzFrameSetTextColor = japi.DzFrameSetTextColor as (frame: number, r: number, g: number, b: number, a: number) => void;
const DzFrameSetFont = japi.DzFrameSetFont as (frame: number, path: string, size: number, flag: number) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameSetIgnoreTrackEvents = japi.DzFrameSetIgnoreTrackEvents as (frame: number, ignore: boolean) => void;
const DzFrameBindWorldPos = japi.DzFrameBindWorldPos as (
  frame: number,
  worldX: number,
  worldY: number,
  worldZ: number,
  screenX: number,
  screenY: number,
  fogVisible: boolean
) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const DzDestroyFrame = japi.DzDestroyFrame as (frame: number) => void;

const 护盾条底框 = "UI\\UnitHealthBar\\bar_frame.tga";
const 护盾条缓降贴图 = "UI\\UnitHealthBar\\bar_damage_lag_white.tga";

const 点左上 = 0;
const 点中 = 4;
const 世界护盾条宽 = 0.066;
const 世界护盾条高 = 0.012;
const 世界护盾条内宽 = 0.062;
const 世界护盾条内高 = 0.0064;
const 世界护盾条内X = 0.002;
const 世界护盾条内Y = -0.0028;
const 世界护盾条文字宽 = 0.085;
const 世界护盾条文字高 = 0.010;
const 世界护盾条层级 = 6500;
const 世界护盾条缓降追赶比例 = 0.008;

let 世界护盾条父帧 = 0;
let 下一个世界护盾条ID = 1;
let 已注册世界护盾条计时器 = false;
const 世界护盾条列表: 世界坐标护盾条[] = [];

export interface 世界坐标护盾条参数 {
  X: number;
  Y: number;
  Z?: number;
  最大值: number;
  当前值?: number;
  类型?: number;
  持续时间?: number;
  显示倒计时?: boolean;
  名称?: string;
}

export interface 世界坐标护盾条 {
  id: number;
  root: number;
  lag: number;
  fill: number;
  text: number;
  最大值: number;
  当前值: number;
  缓降比例: number;
  剩余时间: number;
  持续计时: boolean;
  显示倒计时: boolean;
  名称: string;
  刷新Tick: number;
  已销毁: boolean;
}

function 取护盾贴图(this: void, shieldType: number | undefined): string {
  if (shieldType === 护盾类型.物理) return "UI\\UnitHealthBar\\bar_shield_physical.tga";
  if (shieldType === 护盾类型.魔法) return "UI\\UnitHealthBar\\bar_shield_magic.tga";
  if (shieldType === 护盾类型.强化) return "UI\\UnitHealthBar\\bar_shield_enhanced.tga";
  if (shieldType === 护盾类型.火) return "UI\\UnitHealthBar\\bar_shield_fire.tga";
  if (shieldType === 护盾类型.水 || shieldType === 护盾类型.冰) return "UI\\UnitHealthBar\\bar_shield_water.tga";
  if (shieldType === 护盾类型.雷) return "UI\\UnitHealthBar\\bar_shield_thunder.tga";
  if (shieldType === 护盾类型.金 || shieldType === 护盾类型.毒) return "UI\\UnitHealthBar\\bar_shield_metal.tga";
  if (shieldType === 护盾类型.木 || shieldType === 护盾类型.风) return "UI\\UnitHealthBar\\bar_shield_wood.tga";
  if (shieldType === 护盾类型.光) return "UI\\UnitHealthBar\\bar_shield_light.tga";
  if (shieldType === 护盾类型.暗) return "UI\\UnitHealthBar\\bar_shield_dark.tga";
  return "UI\\UnitHealthBar\\bar_shield_white.tga";
}

function 取世界护盾条父帧(this: void): number {
  if (世界护盾条父帧 !== 0) return 世界护盾条父帧;
  const lower = DzFrameGetLowerLevelFrame();
  const parent = lower != null && lower !== 0 ? lower : DzGetGameUI();
  世界护盾条父帧 = DzCreateFrameByTagName("FRAME", "WorldShieldBarLayer", parent, "", 0);
  if (世界护盾条父帧 === 0) return parent;
  return 世界护盾条父帧;
}

function 创建贴图帧(this: void, 名称: string, 父级: number, 贴图: string, 优先级: number): number {
  const frame = DzCreateFrameByTagName("BACKDROP", 名称, 父级, "", 0);
  if (frame == null || frame === 0) return 0;
  DzFrameSetTexture(frame, 贴图, 0);
  DzFrameSetPriority(frame, 优先级);
  DzFrameSetIgnoreTrackEvents(frame, true);
  return frame;
}

function 限制01(this: void, value: number): number {
  if (!(value > 0)) return 0;
  if (value > 1) return 1;
  return value;
}

function 格式化数值(this: void, value: number): string {
  return tostring(math.floor(value + 0.5));
}

function 格式化秒数(this: void, value: number): string {
  if (!(value > 0)) return "0.0";
  return tostring(math.floor(value * 10 + 0.5) / 10);
}

function 从世界护盾条列表移除(this: void, bar: 世界坐标护盾条): void {
  for (let i = 世界护盾条列表.length - 1; i >= 0; i--) {
    if (世界护盾条列表[i] === bar) {
      世界护盾条列表.splice(i, 1);
      return;
    }
  }
}

function 世界护盾条已在列表(this: void, bar: 世界坐标护盾条): boolean {
  for (let i = 0; i < 世界护盾条列表.length; i++) {
    if (世界护盾条列表[i] === bar) return true;
  }
  return false;
}

function 确保世界护盾条在列表(this: void, bar: 世界坐标护盾条): void {
  if (bar.已销毁) return;
  if (!世界护盾条已在列表(bar)) 世界护盾条列表.push(bar);
  确保世界护盾条计时器();
}

function 尝试关闭世界护盾条计时器(this: void): void {
  if (!已注册世界护盾条计时器) return;
  if (世界护盾条列表.length > 0) return;
  已注册世界护盾条计时器 = false;
  offTick10ms(on世界护盾条Tick);
}

function 确保世界护盾条计时器(this: void): void {
  if (已注册世界护盾条计时器) return;
  已注册世界护盾条计时器 = true;
  onTick10ms(on世界护盾条Tick);
}

function 刷新世界护盾条文本(this: void, bar: 世界坐标护盾条): void {
  let text = "|cffccffff" + bar.名称 + " " + 格式化数值(bar.当前值) + "/" + 格式化数值(bar.最大值) + "|r";
  if (bar.显示倒计时) text = text + " |cffffe6a8" + 格式化秒数(bar.剩余时间) + "s|r";
  DzFrameSetText(bar.text, text);
}

function 刷新世界护盾条缓降(this: void, bar: 世界坐标护盾条, 当前比例: number): void {
  const lagPct = bar.缓降比例 - 当前比例;
  if (lagPct > 0.003) {
    DzFrameSetPoint(bar.lag, 点左上, bar.root, 点左上, 世界护盾条内X + 世界护盾条内宽 * 当前比例, 世界护盾条内Y);
    DzFrameSetSize(bar.lag, 世界护盾条内宽 * lagPct, 世界护盾条内高);
    DzFrameShow(bar.lag, true);
  } else {
    DzFrameShow(bar.lag, false);
  }
}

function on世界护盾条Tick(this: void): void {
  for (let i = 世界护盾条列表.length - 1; i >= 0; i--) {
    const bar = 世界护盾条列表[i];
    if (bar == null || bar.已销毁) {
      世界护盾条列表.splice(i, 1);
      continue;
    }
    const currentPct = 限制01(bar.当前值 / bar.最大值);
    if (bar.缓降比例 > currentPct) {
      const nextPct = bar.缓降比例 - 世界护盾条缓降追赶比例;
      bar.缓降比例 = nextPct > currentPct ? nextPct : currentPct;
      刷新世界护盾条缓降(bar, currentPct);
    } else {
      bar.缓降比例 = currentPct;
      DzFrameShow(bar.lag, false);
    }

    if (bar.持续计时) bar.剩余时间 = bar.剩余时间 - 0.01;
    bar.刷新Tick = bar.刷新Tick + 1;
    if (bar.刷新Tick >= 10) {
      bar.刷新Tick = 0;
      刷新世界护盾条文本(bar);
    }
    if (bar.持续计时 && bar.剩余时间 <= 0) {
      销毁世界坐标护盾条(bar);
    } else if (!bar.持续计时 && !(bar.缓降比例 - currentPct > 0.003)) {
      世界护盾条列表.splice(i, 1);
    }
    if (!bar.已销毁) DzFrameShow(bar.root, bar.当前值 > 0 || bar.缓降比例 - currentPct > 0.003);
  }
  尝试关闭世界护盾条计时器();
}

export function 创建世界坐标护盾条(this: void, 参数: 世界坐标护盾条参数): 世界坐标护盾条 | null {
  if (!(参数.最大值 > 0)) return null;

  const id = 下一个世界护盾条ID;
  下一个世界护盾条ID = 下一个世界护盾条ID + 1;
  const parent = 取世界护盾条父帧();
  const suffix = tostring(id);
  const root = 创建贴图帧("WorldShieldBarRoot_" + suffix, parent, 护盾条底框, 世界护盾条层级);
  if (root === 0) return null;

  const lag = 创建贴图帧("WorldShieldBarLag_" + suffix, root, 护盾条缓降贴图, 世界护盾条层级 + 1);
  const fill = 创建贴图帧("WorldShieldBarFill_" + suffix, root, 取护盾贴图(参数.类型), 世界护盾条层级 + 2);
  const text = DzCreateFrameByTagName("TEXT", "WorldShieldBarText_" + suffix, root, "", 0);
  if (lag === 0 || fill === 0 || text == null || text === 0) {
    DzDestroyFrame(root);
    return null;
  }

  DzFrameSetSize(root, 世界护盾条宽, 世界护盾条高);
  DzFrameSetSize(lag, 0, 世界护盾条内高);
  DzFrameSetPoint(lag, 点左上, root, 点左上, 世界护盾条内X, 世界护盾条内Y);
  DzFrameSetSize(fill, 世界护盾条内宽, 世界护盾条内高);
  DzFrameSetPoint(fill, 点左上, root, 点左上, 世界护盾条内X, 世界护盾条内Y);

  DzFrameSetSize(text, 世界护盾条文字宽, 世界护盾条文字高);
  DzFrameSetPoint(text, 点中, root, 点中, 0, 0.012);
  DzFrameSetTextAlignment(text, -1);
  DzFrameSetTextAlignment(text, 18);
  DzFrameSetTextColor(text, 210, 235, 255, 255);
  DzFrameSetFont(text, "UI\\unit_name_zcool_qingke.ttf", 0.010, 0);
  DzFrameSetPriority(text, 世界护盾条层级 + 2);
  DzFrameSetIgnoreTrackEvents(text, true);

  DzFrameBindWorldPos(root, 参数.X, 参数.Y, 参数.Z ?? 180, 0, 0, true);
  DzFrameShow(root, true);
  DzFrameShow(lag, false);
  DzFrameShow(fill, true);
  DzFrameShow(text, true);

  const currentValue = 参数.当前值 ?? 参数.最大值;
  const duration = 参数.持续时间 ?? 0;
  const bar: 世界坐标护盾条 = {
    id,
    root,
    lag,
    fill,
    text,
    最大值: 参数.最大值,
    当前值: currentValue,
    缓降比例: 限制01(currentValue / 参数.最大值),
    剩余时间: duration,
    持续计时: duration > 0,
    显示倒计时: (参数.显示倒计时 ?? true) && duration > 0,
    名称: 参数.名称 ?? "魔盾",
    刷新Tick: 0,
    已销毁: false,
  };
  if (bar.持续计时) 确保世界护盾条在列表(bar);
  更新世界坐标护盾条(bar, bar.当前值);
  return bar;
}

export function 更新世界坐标护盾条(this: void, bar: 世界坐标护盾条 | null, 当前值: number): void {
  if (bar == null || bar.已销毁) return;
  const oldPct = bar.缓降比例;
  bar.当前值 = 当前值;
  const pct = 限制01(当前值 / bar.最大值);
  if (pct >= oldPct) {
    bar.缓降比例 = pct;
  } else {
    bar.缓降比例 = oldPct;
    确保世界护盾条在列表(bar);
  }
  刷新世界护盾条缓降(bar, pct);
  DzFrameSetSize(bar.fill, 世界护盾条内宽 * pct, 世界护盾条内高);
  刷新世界护盾条文本(bar);
  DzFrameShow(bar.root, 当前值 > 0 || bar.缓降比例 - pct > 0.003);
}

export function 销毁世界坐标护盾条(this: void, bar: 世界坐标护盾条 | null): void {
  if (bar == null || bar.已销毁) return;
  bar.已销毁 = true;
  从世界护盾条列表移除(bar);
  DzFrameShow(bar.root, false);
  DzDestroyFrame(bar.root);
  尝试关闭世界护盾条计时器();
}

export {};
