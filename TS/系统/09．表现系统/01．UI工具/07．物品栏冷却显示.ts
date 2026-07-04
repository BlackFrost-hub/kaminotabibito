/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const 冷却数字文本模块 = require("系统.09．表现系统.01．UI工具.06．冷却数字文本") as {
  创建冷却数字文本组: (this: void, 配置: any) => any;
  设置冷却数字文本锚点: (this: void, 文本组: any, relativeFrame: number, point: number, relativePoint: number, x: number, y: number) => void;
  设置冷却数字文本: (this: void, 文本组: any, text: string) => void;
  显示冷却数字文本: (this: void, 文本组: any, visible: boolean) => void;
};
const 创建冷却数字文本组 = 冷却数字文本模块.创建冷却数字文本组;
const 设置冷却数字文本锚点 = 冷却数字文本模块.设置冷却数字文本锚点;
const 设置冷却数字文本 = 冷却数字文本模块.设置冷却数字文本;
const 显示冷却数字文本 = 冷却数字文本模块.显示冷却数字文本;

const GetLocalPlayer = jass.GetLocalPlayer as () => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (type: string, name: string, parent: number, template: string, id: number) => number;
const DzFrameGetItemBarButton = japi.DzFrameGetItemBarButton as (slot: number) => number;
const DzFrameClearAllPoints = japi.DzFrameClearAllPoints as (frame: number) => void;
const DzFrameSetAllPoints = japi.DzFrameSetAllPoints as (frame: number, relativeFrame: number) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameSetModel = japi.DzFrameSetModel as (frame: number, model: string, modelType: number, flag: number) => void;
const DzFrameSetAnimate = japi.DzFrameSetAnimate as (frame: number, animId: number, auto: boolean) => void;
const DzFrameSetAnimateOffset = japi.DzFrameSetAnimateOffset as (frame: number, offset: number) => void;

const 物品栏槽位数量 = 6;
const 刷新间隔毫秒 = 100;
const 冷却转圈模型 = "UI\\Feedback\\Cooldown\\UI-Cooldown-Indicator.mdl";
const 物品冷却数字层 = [
  { 后缀: "Text", 偏移X: 0.0, 偏移Y: 0.0, 颜色码: "fffff2d8", r: 255, g: 242, b: 216, a: 255, 优先级偏移: 0 },
];

interface 物品冷却记录 {
  hero: any;
  item: any;
  结束毫秒: number;
  总毫秒: number;
}

interface 物品栏冷却槽位UI {
  转圈框体: number;
  数字文本组: any;
}

const 冷却记录列表: 物品冷却记录[] = [];
const 槽位UI列表: 物品栏冷却槽位UI[] = [];

let 已初始化 = false;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 当前毫秒(this: void): number {
  return os.clock() * 1000;
}

function 单位有效(this: void, unit: any): boolean {
  return 句柄有效(unit) && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 是否本地玩家单位(this: void, unit: any): boolean {
  if (!单位有效(unit)) return false;
  const owner = GetOwningPlayer(unit);
  if (!句柄有效(owner)) return false;
  return GetPlayerId(owner) === GetPlayerId(GetLocalPlayer());
}

function 查找物品所在槽位(this: void, hero: any, targetItem: any): number {
  if (!单位有效(hero) || !句柄有效(targetItem)) return -1;
  for (let slot = 0; slot < 物品栏槽位数量; slot++) {
    if (UnitItemInSlot(hero, slot) === targetItem) return slot;
  }
  return -1;
}

function 格式化剩余秒(this: void, 剩余毫秒: number): string {
  if (剩余毫秒 <= 0) return "";
  const 十分秒 = math.floor(剩余毫秒 / 100 + 0.999);
  const 秒 = math.floor(十分秒 / 10);
  const 小数 = 十分秒 - 秒 * 10;
  return tostring(秒) + "." + tostring(小数);
}

function 计算冷却转圈进度(this: void, 剩余毫秒: number, 总毫秒: number): number {
  if (总毫秒 <= 0) return 0;
  const progress = 1 - 剩余毫秒 / 总毫秒;
  if (progress <= 0) return 0;
  if (progress >= 1) return 0.9999;
  return progress;
}

function 隐藏槽位UI(this: void, ui: 物品栏冷却槽位UI | null): void {
  if (ui == null) return;
  if (ui.转圈框体 !== 0) {
    DzFrameSetAnimateOffset(ui.转圈框体, 0);
    DzFrameShow(ui.转圈框体, false);
  }
  设置冷却数字文本(ui.数字文本组, "");
  显示冷却数字文本(ui.数字文本组, false);
}

function 隐藏全部槽位UI(this: void): void {
  for (let i = 0; i < 物品栏槽位数量; i++) {
    隐藏槽位UI(槽位UI列表[i]);
  }
}

function 隐藏物品所在槽位UI(this: void, hero: any, item: any): void {
  if (!是否本地玩家单位(hero)) return;
  const slot = 查找物品所在槽位(hero, item);
  if (slot < 0) return;
  隐藏槽位UI(槽位UI列表[slot]);
}

function 确保槽位UI(this: void, slot: number): 物品栏冷却槽位UI | null {
  const old = 槽位UI列表[slot];
  if (old != null) return old;

  const root = DzGetGameUI();
  if (!句柄有效(root)) return null;

  const 转圈框体 = DzCreateFrameByTagName("SPRITE", `ItemBarCooldownSprite_${slot}`, root, "template", 0);
  const 数字文本组 = 创建冷却数字文本组({
    名称前缀: `ItemBarCooldownText_${slot}_`,
    父级: root,
    宽度: 0.042,
    高度: 0.020,
    字体大小: 0.020,
    优先级: 9001,
    对齐: 18,
    层: 物品冷却数字层,
  });
  if (!句柄有效(转圈框体) || 数字文本组 == null) return null;

  DzFrameSetModel(转圈框体, 冷却转圈模型, 0, 0);
  DzFrameSetAnimate(转圈框体, 0, false);
  DzFrameSetAnimateOffset(转圈框体, 0);
  DzFrameSetPriority(转圈框体, 9000);
  DzFrameSetSize(转圈框体, 0.032, 0.032);
  DzFrameShow(转圈框体, false);
  显示冷却数字文本(数字文本组, false);

  const ui = { 转圈框体, 数字文本组 };
  槽位UI列表[slot] = ui;
  return ui;
}

function 刷新物品栏冷却显示(this: void): void {
  const now = 当前毫秒();
  let writeIndex = 0;
  隐藏全部槽位UI();

  for (let i = 0; i < 冷却记录列表.length; i++) {
    const record = 冷却记录列表[i];
    const remaining = record.结束毫秒 - now;
    if (remaining <= 0 || !单位有效(record.hero) || !句柄有效(record.item)) continue;

    冷却记录列表[writeIndex] = record;
    writeIndex++;
    if (!是否本地玩家单位(record.hero)) continue;

    const slot = 查找物品所在槽位(record.hero, record.item);
    if (slot < 0) continue;

    const button = DzFrameGetItemBarButton(slot);
    const ui = 确保槽位UI(slot);
    if (!句柄有效(button) || ui == null) continue;

    DzFrameClearAllPoints(ui.转圈框体);
    DzFrameSetAllPoints(ui.转圈框体, button);
    DzFrameSetAnimateOffset(ui.转圈框体, 计算冷却转圈进度(remaining, record.总毫秒));
    设置冷却数字文本锚点(ui.数字文本组, button, 4, 4, 0, 0);
    设置冷却数字文本(ui.数字文本组, 格式化剩余秒(remaining));
    DzFrameShow(ui.转圈框体, true);
    显示冷却数字文本(ui.数字文本组, true);
  }

  for (let i = 冷却记录列表.length - 1; i >= writeIndex; i--) {
    冷却记录列表.pop();
  }
}

export function 初始化物品栏冷却显示(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  addPeriodicCallback(刷新间隔毫秒, 刷新物品栏冷却显示);
}

export function 显示物品栏物品冷却(this: void, hero: any, item: any, durationMs: number): void {
  if (!单位有效(hero) || !句柄有效(item) || durationMs <= 0) return;
  初始化物品栏冷却显示();
  const now = 当前毫秒();
  const nextEnd = now + durationMs;
  for (let i = 0; i < 冷却记录列表.length; i++) {
    const record = 冷却记录列表[i];
    if (record.item === item) {
      record.hero = hero;
      if (nextEnd > record.结束毫秒) {
        record.结束毫秒 = nextEnd;
        record.总毫秒 = durationMs;
      }
      return;
    }
  }
  冷却记录列表.push({
    hero,
    item,
    结束毫秒: nextEnd,
    总毫秒: durationMs,
  });
}

export function 设置物品栏物品冷却(this: void, hero: any, item: any, durationMs: number): void {
  if (!句柄有效(item)) return;
  初始化物品栏冷却显示();
  if (durationMs <= 0) {
    隐藏物品所在槽位UI(hero, item);
    let writeIndex = 0;
    for (let i = 0; i < 冷却记录列表.length; i++) {
      const record = 冷却记录列表[i];
      if (record.item === item) continue;
      冷却记录列表[writeIndex] = record;
      writeIndex++;
    }
    for (let i = 冷却记录列表.length - 1; i >= writeIndex; i--) {
      冷却记录列表.pop();
    }
    刷新物品栏冷却显示();
    隐藏物品所在槽位UI(hero, item);
    return;
  }

  if (!单位有效(hero)) return;
  const now = 当前毫秒();
  const nextEnd = now + durationMs;
  for (let i = 0; i < 冷却记录列表.length; i++) {
    const record = 冷却记录列表[i];
    if (record.item === item) {
      record.hero = hero;
      record.结束毫秒 = nextEnd;
      record.总毫秒 = durationMs;
      刷新物品栏冷却显示();
      return;
    }
  }
  冷却记录列表.push({
    hero,
    item,
    结束毫秒: nextEnd,
    总毫秒: durationMs,
  });
  刷新物品栏冷却显示();
}

export function 清除物品栏物品冷却(this: void, hero: any, item: any): void {
  设置物品栏物品冷却(hero, item, 0);
}

export {};
