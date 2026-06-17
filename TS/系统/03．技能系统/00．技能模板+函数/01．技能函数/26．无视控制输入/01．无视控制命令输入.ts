/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const fourCcUtil = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string | undefined | null) => number;
};

const 单位指令事件中心 = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerImmediateOrderListener: (this: void, callback: (this: void, unit: any, orderId: number) => void) => void;
  unregisterImmediateOrderListener: (this: void, callback: (this: void, unit: any, orderId: number) => void) => void;
  registerPointOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, x: number, y: number) => void) => void;
  unregisterPointOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, x: number, y: number) => void) => void;
};

export const 无视控制狂战士技能ID = "USKB";
export const 无视控制疾风步技能ID = "USKW";
export const 无视控制无敌护甲技能ID = "USKD";
export const 无视控制显示技能ID = "USKS";
export const 无视控制无敌护甲技能槽位ID列表 = ["USKD", "UD01", "UD02", "UD03", "UD04", "UD05", "UD06", "UD07"] as const;
export const 无视控制显示技能槽位ID列表 = ["USKS", "UW01", "UW02", "UW03", "UW04", "UW05", "UW06", "UW07"] as const;
export const 无视控制狂战士命令 = "berserk";
export const 无视控制疾风步命令 = "windwalk";
export const 无视控制无敌护甲命令 = "divineshield";
export const 无视控制显示命令 = "reveal";

export type 无视控制输入类型 = "狂战士" | "疾风步" | "无敌护甲" | "显示";

export interface 无视控制输入事件 {
  单位: any;
  命令ID: number;
  输入类型: 无视控制输入类型;
  输入方式: "无目标" | "点目标";
  目标点X?: number;
  目标点Y?: number;
}

export type 无视控制输入回调 = (this: void, event: 无视控制输入事件) => void;

const OrderId = jass.OrderId as (order: string) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const UnitAddAbility = jass.UnitAddAbility as (unit: any, abilityId: number) => boolean;
const stringToFourCC = fourCcUtil.stringToFourCC;

const DzSetUnitAbilityArea = japi.DzSetUnitAbilityArea as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityArt = japi.DzSetUnitAbilityArt as (unit: any, abilityId: number, art: string) => boolean;
const DzSetUnitAbilityBackSwing = japi.DzSetUnitAbilityBackSwing as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityButtonPos = japi.DzSetUnitAbilityButtonPos as (unit: any, abilityId: number, x: number, y: number) => boolean;
const DzSetUnitAbilityCastPoint = japi.DzSetUnitAbilityCastPoint as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityCastTime = japi.DzSetUnitAbilityCastTime as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityCool = japi.DzSetUnitAbilityCool as (unit: any, abilityId: number, cool: number, maxCool: number) => boolean;
const DzSetUnitAbilityCost = japi.DzSetUnitAbilityCost as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityDataA = japi.DzSetUnitAbilityDataA as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityDataB = japi.DzSetUnitAbilityDataB as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityDataC = japi.DzSetUnitAbilityDataC as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityDataD = japi.DzSetUnitAbilityDataD as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityDataE = japi.DzSetUnitAbilityDataE as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityDuration = japi.DzSetUnitAbilityDuration as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityHeroDuration = japi.DzSetUnitAbilityHeroDuration as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityHotkey = japi.DzSetUnitAbilityHotkey as (unit: any, abilityId: number, hotkey: string) => boolean;
const DzSetUnitAbilityOrderId = japi.DzSetUnitAbilityOrderId as (unit: any, abilityId: number, orderId: number) => boolean;
const DzSetUnitAbilityRange = japi.DzSetUnitAbilityRange as (unit: any, abilityId: number, value: number) => boolean;
const DzSetUnitAbilityTip = japi.DzSetUnitAbilityTip as (unit: any, abilityId: number, tip: string) => boolean;
const DzSetUnitAbilityUberTip = japi.DzSetUnitAbilityUberTip as (unit: any, abilityId: number, tip: string) => boolean;
const DzSetUnitAbilityUpdate = japi.DzSetUnitAbilityUpdate as (unit: any, abilityId: number) => boolean;

let 狂战士命令ID = 0;
let 疾风步命令ID = 0;
let 无敌护甲命令ID = 0;
let 显示命令ID = 0;
let 已接入单位指令事件 = false;

const 监听列表: 无视控制输入回调[] = [];
const 动态命令类型映射: Record<number, 无视控制输入类型 | undefined> = {};

export interface 无视控制技能壳子配置 {
  单位: any;
  技能ID: string | number;
  输入类型?: 无视控制输入类型;
  命令?: string | number;
  自动添加?: boolean;
  图标?: string;
  提示?: string;
  扩展提示?: string;
  热键?: string;
  按钮X?: number;
  按钮Y?: number;
  冷却?: number;
  最大冷却?: number;
  魔法消耗?: number;
  施法距离?: number;
  施法区域?: number;
  持续时间?: number;
  英雄持续时间?: number;
  施法前摇?: number;
  施法时间?: number;
  后摇?: number;
  数据A?: number;
  数据B?: number;
  数据C?: number;
  数据D?: number;
  数据E?: number;
  刷新?: boolean;
}

function 初始化命令ID(): void {
  if (狂战士命令ID === 0) 狂战士命令ID = OrderId(无视控制狂战士命令);
  if (疾风步命令ID === 0) 疾风步命令ID = OrderId(无视控制疾风步命令);
  if (无敌护甲命令ID === 0) 无敌护甲命令ID = OrderId(无视控制无敌护甲命令);
  if (显示命令ID === 0) 显示命令ID = OrderId(无视控制显示命令);
}

function 转技能ID(id: string | number): number {
  if (typeof id === "number") return id;
  return stringToFourCC(id);
}

function 转命令ID(order: string | number): number {
  if (typeof order === "number") return order;
  return OrderId(order);
}

function 取技能默认输入类型(技能ID: number): 无视控制输入类型 {
  if (技能ID === 转技能ID(无视控制狂战士技能ID)) return "狂战士";
  if (技能ID === 转技能ID(无视控制疾风步技能ID)) return "疾风步";
  for (let i = 0; i < 无视控制无敌护甲技能槽位ID列表.length; i++) {
    if (技能ID === 转技能ID(无视控制无敌护甲技能槽位ID列表[i])) return "无敌护甲";
  }
  for (let i = 0; i < 无视控制显示技能槽位ID列表.length; i++) {
    if (技能ID === 转技能ID(无视控制显示技能槽位ID列表[i])) return "显示";
  }
  return "无敌护甲";
}

function 已注册(callback: 无视控制输入回调): boolean {
  for (let i = 0; i < 监听列表.length; i++) {
    if (监听列表[i] === callback) return true;
  }
  return false;
}

function 分发无视控制输入(unit: any, orderId: number, 输入方式: "无目标" | "点目标", x?: number, y?: number): void {
  const 输入类型 = 取无视控制输入类型(orderId);
  if (输入类型 == null) return;

  const event: 无视控制输入事件 = {
    单位: unit,
    命令ID: orderId,
    输入类型,
    输入方式,
    目标点X: x,
    目标点Y: y,
  };

  for (let i = 0; i < 监听列表.length; i++) {
    const callback = 监听列表[i];
    if (callback != null) callback(event);
  }
}

function 分发无目标无视控制输入(unit: any, orderId: number): void {
  分发无视控制输入(unit, orderId, "无目标");
}

function 分发点目标无视控制输入(unit: any, orderId: number, x: number, y: number): void {
  分发无视控制输入(unit, orderId, "点目标", x, y);
}

function 确保接入单位指令事件(): void {
  if (已接入单位指令事件) return;
  已接入单位指令事件 = true;
  初始化命令ID();
  单位指令事件中心.registerImmediateOrderListener(分发无目标无视控制输入);
  单位指令事件中心.registerPointOrderListener(分发点目标无视控制输入);
}

export function 是否无视控制输入命令(orderId: number): boolean {
  初始化命令ID();
  return orderId === 狂战士命令ID
    || orderId === 疾风步命令ID
    || orderId === 无敌护甲命令ID
    || orderId === 显示命令ID
    || 动态命令类型映射[orderId] != null;
}

export function 取无视控制输入类型(orderId: number): 无视控制输入类型 | undefined {
  初始化命令ID();
  if (orderId === 狂战士命令ID) return "狂战士";
  if (orderId === 疾风步命令ID) return "疾风步";
  if (orderId === 无敌护甲命令ID) return "无敌护甲";
  if (orderId === 显示命令ID) return "显示";
  const 动态输入类型 = 动态命令类型映射[orderId];
  if (动态输入类型 != null) return 动态输入类型;
  return undefined;
}

export function 注册无视控制输入命令(命令: string | number, 输入类型: 无视控制输入类型): number {
  const 命令ID = 转命令ID(命令);
  if (命令ID !== 0) 动态命令类型映射[命令ID] = 输入类型;
  return 命令ID;
}

export function 配置无视控制技能壳子(配置: 无视控制技能壳子配置): number {
  const 单位 = 配置.单位;
  if (单位 == null || 单位 === 0) return 0;

  const 技能ID = 转技能ID(配置.技能ID);
  if (技能ID === 0) return 0;

  if (配置.自动添加 !== false && GetUnitAbilityLevel(单位, 技能ID) <= 0) {
    UnitAddAbility(单位, 技能ID);
  }

  if (配置.图标 != null) DzSetUnitAbilityArt(单位, 技能ID, 配置.图标);
  if (配置.提示 != null) DzSetUnitAbilityTip(单位, 技能ID, 配置.提示);
  if (配置.扩展提示 != null) DzSetUnitAbilityUberTip(单位, 技能ID, 配置.扩展提示);
  if (配置.热键 != null) DzSetUnitAbilityHotkey(单位, 技能ID, 配置.热键);
  if (配置.按钮X != null && 配置.按钮Y != null) DzSetUnitAbilityButtonPos(单位, 技能ID, 配置.按钮X, 配置.按钮Y);
  if (配置.冷却 != null) DzSetUnitAbilityCool(单位, 技能ID, 配置.冷却, 配置.最大冷却 ?? 配置.冷却);
  if (配置.魔法消耗 != null) DzSetUnitAbilityCost(单位, 技能ID, 配置.魔法消耗);
  if (配置.施法距离 != null) DzSetUnitAbilityRange(单位, 技能ID, 配置.施法距离);
  if (配置.施法区域 != null) DzSetUnitAbilityArea(单位, 技能ID, 配置.施法区域);
  if (配置.持续时间 != null) DzSetUnitAbilityDuration(单位, 技能ID, 配置.持续时间);
  if (配置.英雄持续时间 != null) DzSetUnitAbilityHeroDuration(单位, 技能ID, 配置.英雄持续时间);
  if (配置.施法前摇 != null) DzSetUnitAbilityCastPoint(单位, 技能ID, 配置.施法前摇);
  if (配置.施法时间 != null) DzSetUnitAbilityCastTime(单位, 技能ID, 配置.施法时间);
  if (配置.后摇 != null) DzSetUnitAbilityBackSwing(单位, 技能ID, 配置.后摇);
  if (配置.数据A != null) DzSetUnitAbilityDataA(单位, 技能ID, 配置.数据A);
  if (配置.数据B != null) DzSetUnitAbilityDataB(单位, 技能ID, 配置.数据B);
  if (配置.数据C != null) DzSetUnitAbilityDataC(单位, 技能ID, 配置.数据C);
  if (配置.数据D != null) DzSetUnitAbilityDataD(单位, 技能ID, 配置.数据D);
  if (配置.数据E != null) DzSetUnitAbilityDataE(单位, 技能ID, 配置.数据E);

  if (配置.命令 != null) {
    const 命令ID = 注册无视控制输入命令(配置.命令, 配置.输入类型 ?? 取技能默认输入类型(技能ID));
    DzSetUnitAbilityOrderId(单位, 技能ID, 命令ID);
  }

  if (配置.刷新 !== false) DzSetUnitAbilityUpdate(单位, 技能ID);
  return 技能ID;
}

export function 注册无视控制输入监听(callback: 无视控制输入回调): void {
  if (typeof callback !== "function") return;
  确保接入单位指令事件();
  if (!已注册(callback)) 监听列表.push(callback);
}

export function 注销无视控制输入监听(callback: 无视控制输入回调): void {
  const index = 监听列表.indexOf(callback);
  if (index >= 0) 监听列表.splice(index, 1);

  if (监听列表.length === 0 && 已接入单位指令事件) {
    单位指令事件中心.unregisterImmediateOrderListener(分发无目标无视控制输入);
    单位指令事件中心.unregisterPointOrderListener(分发点目标无视控制输入);
    已接入单位指令事件 = false;
  }
}

export {};
