/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
};
const selectionSnapshotSystem = require("系统.03．技能系统.00．本地选中技能快照") as {
  初始化本地选中技能快照: (this: void) => void;
  获取本地选中技能快照: (this: void) => {
    hero: any | null;
    skills: Record<热键位, number>;
    slots: Record<热键位, { x: number; y: number }>;
  };
};
const 功能开关模块 = require("系统.00．核心系统.02．功能开关.01．QWERD显示开关") as {
  本地玩家是否开启冷却显示: (this: void) => boolean;
};
const platformAbilityApi = require("平台扩展API取值") as {
  技能_获取技能当前冷却时间: (this: void, 单位: any, 技能代码: number) => number;
};
const { 技能_获取技能当前冷却时间 } = platformAbilityApi;
const fourCCTools = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  fourCCToString: (this: void, four: number) => string;
};
const fourCCToStringRaw = fourCCTools.fourCCToString;
const 冷却数字文本模块 = require("系统.09．表现系统.01．UI工具.06．冷却数字文本") as {
  创建冷却数字文本组: (this: void, 配置: any) => any;
  设置冷却数字文本锚点: (this: void, 文本组: any, relativeFrame: number, point: number, relativePoint: number, x: number, y: number) => void;
  设置冷却数字文本: (this: void, 文本组: any, text: string) => void;
  显示冷却数字文本: (this: void, 文本组: any, visible: boolean) => void;
  技能冷却数字层: any[];
};
const 创建冷却数字文本组 = 冷却数字文本模块.创建冷却数字文本组;
const 设置冷却数字文本锚点 = 冷却数字文本模块.设置冷却数字文本锚点;
const 设置冷却数字文本 = 冷却数字文本模块.设置冷却数字文本;
const 显示冷却数字文本 = 冷却数字文本模块.显示冷却数字文本;

type 热键位 = "Q" | "W" | "E" | "R" | "D";
type 文本组表 = Record<热键位, any>;

const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton as (row: number, column: number) => number;

const DEBUG_FORCE_PLACEHOLDER = true;
const REFRESH_MS = 100;
const OFFSET_X = 0.010;
const OFFSET_Y = 0.006;
const FONT_SIZE = 0.020;
const TEXT_W = 0.042;
const TEXT_H = 0.020;

let initialized = false;
let 文本组缓存: 文本组表 | null = null;

function isValidHandle(handle: any): boolean {
  return handle != null && handle !== 0;
}

function getLocalHero(this: void): any | null {
  return selectionSnapshotSystem.获取本地选中技能快照().hero;
}

function createTextGroup(this: void, name: string): any {
  const gameUI = DzGetGameUI();
  if (!isValidHandle(gameUI)) return null;
  return 创建冷却数字文本组({
    名称前缀: name,
    父级: gameUI,
    宽度: TEXT_W,
    高度: TEXT_H,
    字体大小: FONT_SIZE,
    优先级: 0,
    对齐: 8,
    层: 冷却数字文本模块.技能冷却数字层,
  });
}

function 确保文本组缓存(this: void): 文本组表 | null {
  if (文本组缓存 != null) return 文本组缓存;

  文本组缓存 = { Q: null, W: null, E: null, R: null, D: null };
  return 文本组缓存;
}

function fourCCText(this: void, abilityId: number): string {
  if (abilityId === 0) return "0";
  return fourCCToStringRaw(abilityId);
}

function getCooldown(this: void, whichHero: any, abilityId: number): number {
  if (!isValidHandle(whichHero) || abilityId === 0) return 0;
  return 技能_获取技能当前冷却时间(whichHero, abilityId) || 0;
}

function formatCooldown(this: void, cooldown: number): string {
  if (!(cooldown > 0.05)) return "";

  const tenth = jass.R2I(cooldown * 10 + 0.5);
  const sec = jass.R2I(tenth / 10);
  const decimal = tenth - sec * 10;
  return jass.I2S(sec) + "." + jass.I2S(decimal);
}

function 构建显示文本(this: void, hotkey: 热键位, abilityId: number, cooldown: number): string {
  const cdText = formatCooldown(cooldown);
  if (cdText !== "") return cdText;
  if (DEBUG_FORCE_PLACEHOLDER && abilityId !== 0) return hotkey;
  return "";
}

function 获取按钮框(this: void, hotkey: 热键位): number {
  const slot = selectionSnapshotSystem.获取本地选中技能快照().slots[hotkey];
  return DzFrameGetCommandBarButton(slot.y, slot.x);
}

function 获取技能Id(this: void, hotkey: 热键位): number {
  return selectionSnapshotSystem.获取本地选中技能快照().skills[hotkey];
}

function 刷新单个技能(this: void, whichHero: any, hotkey: 热键位, textGroup: any): void {
  const buttonFrame = 获取按钮框(hotkey);
  if (!isValidHandle(buttonFrame)) {
    设置冷却数字文本(textGroup, "");
    显示冷却数字文本(textGroup, false);
    return;
  }

  let currentTextGroup = textGroup;
  if (currentTextGroup == null) {
    currentTextGroup = createTextGroup(`SkillCooldown${hotkey}`);
    if (currentTextGroup == null) return;
    if (文本组缓存 != null) 文本组缓存[hotkey] = currentTextGroup;
  }

  设置冷却数字文本锚点(currentTextGroup, buttonFrame, 8, 8, OFFSET_X, OFFSET_Y);

  const abilityId = 获取技能Id(hotkey);
  if (abilityId === 0) {
    设置冷却数字文本(currentTextGroup, "");
    显示冷却数字文本(currentTextGroup, false);
    return;
  }

  const cooldown = getCooldown(whichHero, abilityId);
  const text = 构建显示文本(hotkey, abilityId, cooldown);
  设置冷却数字文本(currentTextGroup, text);
  显示冷却数字文本(currentTextGroup, text !== "");
}

function hideAll(this: void): void {
  if (文本组缓存 == null) return;
  设置冷却数字文本(文本组缓存.Q, "");
  显示冷却数字文本(文本组缓存.Q, false);
  设置冷却数字文本(文本组缓存.W, "");
  显示冷却数字文本(文本组缓存.W, false);
  设置冷却数字文本(文本组缓存.E, "");
  显示冷却数字文本(文本组缓存.E, false);
  设置冷却数字文本(文本组缓存.R, "");
  显示冷却数字文本(文本组缓存.R, false);
  设置冷却数字文本(文本组缓存.D, "");
  显示冷却数字文本(文本组缓存.D, false);
}

function onTick(this: void): void {
  const currentGroups = 确保文本组缓存();
  if (currentGroups == null) return;
  if (功能开关模块.本地玩家是否开启冷却显示() !== true) {
    hideAll();
    return;
  }

  const hero = getLocalHero();
  if (!isValidHandle(hero)) {
    hideAll();
    return;
  }

  刷新单个技能(hero, "Q", currentGroups.Q);
  刷新单个技能(hero, "W", currentGroups.W);
  刷新单个技能(hero, "E", currentGroups.E);
  刷新单个技能(hero, "R", currentGroups.R);
  刷新单个技能(hero, "D", currentGroups.D);
}

export function 获取QWERD冷却调试快照(this: void): string {
  const hero = getLocalHero();
  if (!isValidHandle(hero)) return `NO_HERO`;

  const qId = 获取技能Id("Q");
  const wId = 获取技能Id("W");
  const eId = 获取技能Id("E");
  const rId = 获取技能Id("R");
  const dId = 获取技能Id("D");

  const qCd = getCooldown(hero, qId);
  const wCd = getCooldown(hero, wId);
  const eCd = getCooldown(hero, eId);
  const rCd = getCooldown(hero, rId);
  const dCd = getCooldown(hero, dId);

  return [
    `hero=${hero}`,
    `Q=${fourCCText(qId)}/${构建显示文本("Q", qId, qCd)}`,
    `W=${fourCCText(wId)}/${构建显示文本("W", wId, wCd)}`,
    `E=${fourCCText(eId)}/${构建显示文本("E", eId, eCd)}`,
    `R=${fourCCText(rId)}/${构建显示文本("R", rId, rCd)}`,
    `D=${fourCCText(dId)}/${构建显示文本("D", dId, dCd)}`,
  ].join(" ");
}

export function 初始化QWERD冷却显示(this: void): void {
  if (initialized) return;
  initialized = true;
  selectionSnapshotSystem.初始化本地选中技能快照();
  addPeriodicCallback(REFRESH_MS, onTick);
}

export {};
