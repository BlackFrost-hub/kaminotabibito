/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};
const { getServerTime, addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { 开始护盾, 护盾类型, 查询单位标签护盾值, 充能单位标签护盾 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾") as {
  开始护盾: (this: void, unit: any, params: any) => number;
  护盾类型: { 通用: number };
  查询单位标签护盾值: (this: void, unit: any, tag: string) => number;
  充能单位标签护盾: (this: void, unit: any, tag: string, amount: number, maxValue: number, params?: any) => number;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;

const 叠加移动速度属性ID = 9;
const 米亚装备ID缓存: Record<string, number | undefined> = {};
const 米亚装备冷却表: Record<string, number | undefined> = {};
const 米亚临时移速移除队列: Array<{ 单位: any; 移速比例: number; 到期时间: number }> = [];
let 米亚临时移速Tick已启动 = false;

export const 米亚战利品装备名 = {
  腐化猫爪手套: "腐化猫爪手套",
  纯净水源吊坠: "纯净水源吊坠",
  灵猫步伐之靴: "灵猫步伐之靴",
  腐化核心法杖: "腐化核心法杖",
  米亚的项圈: "米亚的项圈",
} as const;

export function 取米亚装备物品ID(this: void, 装备名: string): number {
  const cached = 米亚装备ID缓存[装备名];
  if (cached != null) return cached;
  const rawId = 按名字反查物品ID(装备名);
  const id = stringToFourCCSafe(rawId);
  米亚装备ID缓存[装备名] = id;
  return id;
}

export function 单位持有米亚战利品(this: void, unit: any, 装备名: string): boolean {
  if (unit == null || unit === 0) return false;
  const itemId = 取米亚装备物品ID(装备名);
  if (itemId === 0) return false;
  return UnitHasItemOfTypeBJ(unit, itemId) === true;
}

export function 取米亚装备冷却键(this: void, unit: any, tag: string): string {
  if (unit == null || unit === 0) return "";
  return tag + ":" + String(GetHandleId(unit));
}

export function 米亚装备冷却中(this: void, key: string): boolean {
  if (key === "") return true;
  return (米亚装备冷却表[key] ?? 0) > getServerTime();
}

export function 设置米亚装备冷却(this: void, key: string, 秒数: number): void {
  if (key === "") return;
  米亚装备冷却表[key] = getServerTime() + 秒数 * 1000;
}

function 处理米亚临时移速移除(this: void): void {
  const now = getServerTime();
  for (let i = 米亚临时移速移除队列.length - 1; i >= 0; i--) {
    const 记录 = 米亚临时移速移除队列[i];
    if (记录 == null || now < 记录.到期时间) continue;
    SGSS_SetState(记录.单位, 叠加移动速度属性ID, -记录.移速比例);
    米亚临时移速移除队列.splice(i, 1);
  }
}

function 确保米亚临时移速Tick(this: void): void {
  if (米亚临时移速Tick已启动) return;
  米亚临时移速Tick已启动 = true;
  addPeriodicCallback(100, 处理米亚临时移速移除);
}

export function 施加米亚临时移速(this: void, unit: any, 移速比例: number, 持续秒数: number): void {
  if (unit == null || unit === 0 || 移速比例 === 0 || !(持续秒数 > 0)) return;
  SGSS_SetState(unit, 叠加移动速度属性ID, 移速比例);
  米亚临时移速移除队列.push({ 单位: unit, 移速比例, 到期时间: getServerTime() + 持续秒数 * 1000 });
  确保米亚临时移速Tick();
}

export function 施加米亚项圈护盾(this: void, unit: any, 护盾值: number, 持续秒数: number): void {
  if (unit == null || unit === 0 || !(护盾值 > 0) || !(持续秒数 > 0)) return;
  const tag = "装备:米亚的项圈";
  const params = {
    类型: 护盾类型.通用,
    数值: 护盾值,
    持续时间: 持续秒数,
    来源单位: unit,
    标签: tag,
    显示护盾条: true,
    可驱散: false,
  };
  const current = 查询单位标签护盾值(unit, tag);
  if (current > 0) {
    充能单位标签护盾(unit, tag, 护盾值, 护盾值, params);
    return;
  }
  开始护盾(unit, params);
}

export {};
