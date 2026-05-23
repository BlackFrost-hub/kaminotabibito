/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
};
const selectionCenterSystem = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  getSoleSelectedUnitForPlayer: (this: void, playerId: number) => any | null;
};
const 获取玩家唯一选中单位 = selectionCenterSystem.getSoleSelectedUnitForPlayer as
  | ((this: void, playerId: number) => any | null)
  | undefined;
const 功能开关模块 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关") as {
  本地玩家是否开启魔法消耗显示: (this: void) => boolean;
};
const heroBridge = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any | null;
};
const { 计算最终魔法消耗 } = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还") as {
  计算最终魔法消耗: (this: void, unit: any, abilityId: number, level: number) => number;
};
const 原生魔法消耗同步模块 = require("系统.03．技能系统.02．技能消耗.04．原生魔法消耗同步") as {
  获取已同步技能魔法消耗: (this: void, unit: any, abilityId: number) => number;
};
const { 获取已同步技能魔法消耗 } = 原生魔法消耗同步模块;
const commandBarAbility = require("系统.03．技能系统.01．技能冷却.04．命令卡技能槽位") as {
  读取命令卡按钮能力Id: (this: void, x: number, y: number) => number;
  获取D技能槽位: (this: void, whichHero: any) => readonly [number, number];
};

type 热键位 = "Q" | "W" | "E" | "R" | "D";
type 按钮槽位 = { x: number; y: number };
type 按钮显示单元 = {
  icon: number;
  text: number;
  shadow: number;
};
type 显示表 = Record<热键位, 按钮显示单元>;

const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (type: string, name: string, parent: number, template: string, id: number) => number;
const DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton as (row: number, column: number) => number;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: number, point: number, relativeFrame: number, relativePoint: number, x: number, y: number) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetFont = japi.DzFrameSetFont as (frame: number, fontFile: string, height: number, flag: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetTextColor = japi.DzFrameSetTextColor as (frame: number, r: number, g: number, b: number, a: number) => void;
const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: number, texture: string, flag: number) => void;
const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment as (frame: number, align: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;

const REFRESH_MS = 300;
const FONT_FILE = "UI\\uizt.ttf";
const FONT_SIZE = 0.01275;
const TEXT_W = 0.025;
const TEXT_H = 0.010;
const ICON_W = 0.0090;
const ICON_H = 0.0090;
const ICON_TEXTURE = "UI\\Widgets\\ToolTips\\Human\\ToolTipManaIcon.blp";
const ICON_OFFSET_X = 0.0010;
const ICON_OFFSET_Y = -0.0012;
const TEXT_OFFSET_X = 0.0090;
const TEXT_OFFSET_Y = -0.0013;
const SHADOW_OFFSET_X = 0.0006;
const SHADOW_OFFSET_Y = -0.0006;
const 固定槽位表: Record<"Q" | "W" | "E" | "R", 按钮槽位> = {
  Q: { x: 0, y: 2 },
  W: { x: 1, y: 2 },
  E: { x: 2, y: 2 },
  R: { x: 3, y: 2 },
};
let initialized = false;
let 显示缓存: 显示表 | null = null;

function isValidHandle(handle: any): boolean {
  return handle != null && handle !== 0;
}

function 安全设置文本(this: void, frame: number, text: string): void {
  if (!isValidHandle(frame)) return;
  DzFrameSetText(frame, text);
}

function 安全显示框体(this: void, frame: number, visible: boolean): void {
  if (!isValidHandle(frame)) return;
  DzFrameShow(frame, visible);
}

function 安全设置贴图(this: void, frame: number, texture: string): void {
  if (!isValidHandle(frame)) return;
  DzFrameSetTexture(frame, texture, 0);
}

function 安全设置锚点(this: void, frame: number, relativeFrame: number, x: number, y: number): void {
  if (!isValidHandle(frame) || !isValidHandle(relativeFrame)) return;
  DzFrameSetPoint(frame, 0, relativeFrame, 0, x, y);
}

function 读取玩家唯一选中单位(this: void, playerId: number): any | null {
  if (typeof 获取玩家唯一选中单位 !== "function") return null;
  return 获取玩家唯一选中单位(playerId);
}

function getHeroSource(this: void, localPlayer: any): any | null {
  const playerId = jass.GetPlayerId(localPlayer);
  const selectedUnit = 读取玩家唯一选中单位(playerId);
  if (!isValidHandle(selectedUnit)) return null;
  if (jass.IsUnitType(selectedUnit, jass.UNIT_TYPE_HERO) !== true) return null;

  const owner = jass.GetOwningPlayer(selectedUnit);
  if (!isValidHandle(owner)) return null;
  const registeredHero = heroBridge.getRegisteredPlayerHero(owner);
  if (!isValidHandle(registeredHero)) return null;
  if (registeredHero !== selectedUnit) return null;

  return selectedUnit;
}

function getLocalHero(this: void): any | null {
  const localPlayer = jass.GetLocalPlayer();
  if (!isValidHandle(localPlayer)) return null;
  return getHeroSource(localPlayer);
}

function createBackdrop(this: void, name: string): number {
  const gameUI = DzGetGameUI();
  if (!isValidHandle(gameUI)) return 0;

  const frame = DzCreateFrameByTagName("BACKDROP", name, gameUI, "template", 0);
  if (!isValidHandle(frame)) return 0;

  DzFrameSetSize(frame, ICON_W, ICON_H);
  DzFrameSetTexture(frame, ICON_TEXTURE, 0);
  DzFrameShow(frame, false);
  return frame;
}

function createText(this: void, name: string, r: number, g: number, b: number, a: number): number {
  const gameUI = DzGetGameUI();
  if (!isValidHandle(gameUI)) return 0;

  const frame = DzCreateFrameByTagName("TEXT", name, gameUI, "template", 0);
  if (!isValidHandle(frame)) return 0;

  DzFrameSetSize(frame, TEXT_W, TEXT_H);
  DzFrameSetText(frame, "");
  DzFrameSetFont(frame, FONT_FILE, FONT_SIZE, 0);
  DzFrameSetTextAlignment(frame, 0);
  DzFrameSetTextColor(frame, r, g, b, a);
  DzFrameShow(frame, false);
  return frame;
}

function 确保显示缓存(this: void): 显示表 | null {
  if (显示缓存 != null) return 显示缓存;

  显示缓存 = {
    Q: { icon: 0, text: 0, shadow: 0 },
    W: { icon: 0, text: 0, shadow: 0 },
    E: { icon: 0, text: 0, shadow: 0 },
    R: { icon: 0, text: 0, shadow: 0 },
    D: { icon: 0, text: 0, shadow: 0 },
  };
  return 显示缓存;
}

function formatManaCost(this: void, value: number): string {
  if (!(value > 0.05)) return "";
  const tenth = jass.R2I(value * 10 + 0.5);
  const sec = jass.R2I(tenth / 10);
  const decimal = tenth - sec * 10;
  if (decimal === 0) return jass.I2S(sec);
  return jass.I2S(sec) + "." + jass.I2S(decimal);
}

function calcDisplayManaCost(this: void, unit: any, abilityId: number, level: number): number {
  return 计算最终魔法消耗(unit, abilityId, level);
}

function 解析槽位(this: void, whichHero: any, hotkey: 热键位): 按钮槽位 {
  if (hotkey === "D") {
    const dSlot = commandBarAbility.获取D技能槽位(whichHero);
    return { x: dSlot[0], y: dSlot[1] };
  }
  return 固定槽位表[hotkey];
}

function 获取按钮框(this: void, whichHero: any, hotkey: 热键位): number {
  const slot = 解析槽位(whichHero, hotkey);
  return DzFrameGetCommandBarButton(slot.y, slot.x);
}

function 获取技能Id(this: void, whichHero: any, hotkey: 热键位): number {
  const slot = 解析槽位(whichHero, hotkey);
  return commandBarAbility.读取命令卡按钮能力Id(slot.x, slot.y);
}

function 隐藏单元(this: void, ui: 按钮显示单元): void {
  安全显示框体(ui.icon, false);
  安全设置文本(ui.text, "");
  安全显示框体(ui.text, false);
  安全设置文本(ui.shadow, "");
  安全显示框体(ui.shadow, false);
}

function toManaText(this: void, text: string): string {
  if (text === "") return "";
  return `|cffffd24a${text}|r`;
}

function toShadowText(this: void, text: string): string {
  if (text === "") return "";
  return `|cff101010${text}|r`;
}

function 确保按钮显示单元(this: void, hotkey: 热键位, ui: 按钮显示单元): boolean {
  if (!isValidHandle(ui.icon)) ui.icon = createBackdrop(`SkillMana${hotkey}Icon`);
  if (!isValidHandle(ui.text)) ui.text = createText(`SkillMana${hotkey}Text`, 255, 210, 74, 255);
  if (!isValidHandle(ui.shadow)) ui.shadow = createText(`SkillMana${hotkey}Shadow`, 16, 16, 16, 255);
  return isValidHandle(ui.icon) && isValidHandle(ui.text) && isValidHandle(ui.shadow);
}

function 刷新单个技能(this: void, whichHero: any, hotkey: 热键位, ui: 按钮显示单元): void {
  const buttonFrame = 获取按钮框(whichHero, hotkey);
  if (!isValidHandle(buttonFrame)) {
    隐藏单元(ui);
    return;
  }
  if (!确保按钮显示单元(hotkey, ui)) return;

  const abilityId = 获取技能Id(whichHero, hotkey);
  if (abilityId === 0) {
    隐藏单元(ui);
    return;
  }

  const level = jass.GetUnitAbilityLevel(whichHero, abilityId);
  if (level <= 0) {
    隐藏单元(ui);
    return;
  }

  const syncedManaCost = 获取已同步技能魔法消耗(whichHero, abilityId);
  const manaCost = syncedManaCost >= 0 ? syncedManaCost : calcDisplayManaCost(whichHero, abilityId, level);
  if (!(manaCost > 0)) {
    隐藏单元(ui);
    return;
  }

  const text = formatManaCost(manaCost);
  if (text === "") {
    隐藏单元(ui);
    return;
  }

  安全设置锚点(ui.icon, buttonFrame, ICON_OFFSET_X, ICON_OFFSET_Y);
  安全设置锚点(ui.shadow, buttonFrame, TEXT_OFFSET_X + SHADOW_OFFSET_X, TEXT_OFFSET_Y + SHADOW_OFFSET_Y);
  安全设置锚点(ui.text, buttonFrame, TEXT_OFFSET_X, TEXT_OFFSET_Y);
  安全设置贴图(ui.icon, ICON_TEXTURE);
  安全显示框体(ui.icon, true);
  安全设置文本(ui.shadow, toShadowText(text));
  安全显示框体(ui.shadow, true);
  安全设置文本(ui.text, toManaText(text));
  安全显示框体(ui.text, true);
}

function hideAll(this: void): void {
  if (显示缓存 == null) return;
  隐藏单元(显示缓存.Q);
  隐藏单元(显示缓存.W);
  隐藏单元(显示缓存.E);
  隐藏单元(显示缓存.R);
  隐藏单元(显示缓存.D);
}

function onTick(this: void): void {
  const currentUi = 确保显示缓存();
  if (currentUi == null) return;
  if (功能开关模块.本地玩家是否开启魔法消耗显示() !== true) {
    hideAll();
    return;
  }

  const hero = getLocalHero();
  if (!isValidHandle(hero)) {
    hideAll();
    return;
  }

  刷新单个技能(hero, "Q", currentUi.Q);
  刷新单个技能(hero, "W", currentUi.W);
  刷新单个技能(hero, "E", currentUi.E);
  刷新单个技能(hero, "R", currentUi.R);
  刷新单个技能(hero, "D", currentUi.D);
}

export function 初始化QWERD魔法消耗显示(this: void): void {
  if (initialized) return;
  initialized = true;
  addPeriodicCallback(REFRESH_MS, onTick);
}

export {};
