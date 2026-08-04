/** @noSelfInFile */

import type { Boss弱点定义, Boss弱点韧性配置 } from "./00．类型";
import type { 战斗启动属性配置 } from "../00．战斗启动属性/00．配置类型";
import { Boss弱点反馈默认配置, Boss弱点候选列表, Boss弱点YD字段 } from "./01．常量定义";
import { Boss战斗启动属性配置表 } from "../00．战斗启动属性/01．Boss战斗启动属性配置表";
import { 英雄Boss战斗启动属性配置表 } from "../00．战斗启动属性/02．英雄Boss战斗启动属性配置表";
import { 异界Boss战斗启动属性配置表 } from "../00．战斗启动属性/03．异界Boss战斗启动属性配置表";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const jglobals = require("jass.globals") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichState: number) => number;
const R2I = jass.R2I as (r: number) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, lowBound: number, highBound: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as number;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableTypeName: string, tableKey: any, attr: string, valueTypeName: string) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查异界Boss单位ID } = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表") as {
  按名字反查异界Boss单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
};

const 全部战斗启动属性配置表: 战斗启动属性配置[] = [
  ...Boss战斗启动属性配置表,
  ...英雄Boss战斗启动属性配置表,
  ...异界Boss战斗启动属性配置表,
];

// TS 启动属性优先；JASS 预写 YD 只作为还没迁入 TS 表的 Boss 兼容转发。
export const Boss弱点韧性配置表: Boss弱点韧性配置[] = [];

export function Boss是否启用弱点韧性机制(this: void, config: Boss弱点韧性配置 | undefined): boolean {
  return config != null
    && config.弱点列表.length > 0
    && config.初始护盾值 != null
    && config.初始护盾值 > 0;
}

function 读取Boss弱点标记(this: void, bossUnit: any, weakKey: string): boolean {
  return YDUserDataGetSafe("unit", bossUnit, weakKey, "boolean") === true;
}

function 读取Boss护盾值(this: void, bossUnit: any, attr: string): number | undefined {
  const value = Number(YDUserDataGetSafe("unit", bossUnit, attr, "integer")) || 0;
  return value > 0 ? value : undefined;
}

function 读取Boss实数字段(this: void, bossUnit: any, attr: string): number | undefined {
  const value = Number(YDUserDataGetSafe("unit", bossUnit, attr, "real")) || 0;
  return value > 0 ? value : undefined;
}

function 读取Boss秒数字段毫秒(this: void, bossUnit: any, attr: string): number | undefined {
  const value = Number(YDUserDataGetSafe("unit", bossUnit, attr, "real")) || 0;
  return value > 0 ? value * 1000 : undefined;
}

function 当前N值(this: void): number {
  return Number(jglobals.udg_N) || 0;
}

function 解析配置单位类型ID(this: void, 配置: 战斗启动属性配置): number {
  if (配置.单位ID != null && 配置.单位ID !== "") {
    return stringToFourCCSafe(配置.单位ID);
  }
  if (配置.归类 === "Boss") {
    return stringToFourCCSafe(按名字反查Boss单位ID(配置.单位名!));
  }
  if (配置.归类 === "英雄Boss") {
    return stringToFourCCSafe(
      按名字反查Boss单位ID(配置.单位名!)
      ?? 按名字反查玩家英雄单位ID(配置.单位名!)
    );
  }
  if (配置.归类 === "异界Boss") {
    return stringToFourCCSafe(按名字反查异界Boss单位ID(配置.单位名!));
  }
  return 0;
}

function 按单位查找战斗启动属性配置(this: void, bossUnit: any): 战斗启动属性配置 | undefined {
  const unitTypeId = GetUnitTypeId(bossUnit);
  if (unitTypeId === 0) return undefined;
  for (let i = 0; i < 全部战斗启动属性配置表.length; i++) {
    const 配置 = 全部战斗启动属性配置表[i];
    if (解析配置单位类型ID(配置) === unitTypeId) return 配置;
  }
  return undefined;
}

function 读取启动属性弱点标记(this: void, 配置: 战斗启动属性配置, weakKey: string): boolean {
  return (配置 as Record<string, any>)[weakKey] === true;
}

function 从启动属性创建弱点列表(this: void, 配置: 战斗启动属性配置): Boss弱点定义[] {
  const weakList: Boss弱点定义[] = [];
  const remainingCandidates: Boss弱点定义[] = [];
  for (let i = 0; i < Boss弱点候选列表.length; i++) {
    const candidate = Boss弱点候选列表[i];
    if (读取启动属性弱点标记(配置, candidate.弱点键)) {
      weakList.push(candidate);
    } else {
      remainingCandidates.push(candidate);
    }
  }

  const requestedExtraWeakPointCount = R2I(配置.额外随机弱点数 ?? 0);
  const extraWeakPointCount = requestedExtraWeakPointCount < remainingCandidates.length
    ? requestedExtraWeakPointCount
    : remainingCandidates.length;
  for (let i = 0; i < extraWeakPointCount; i++) {
    if (remainingCandidates.length <= 0) break;
    const randomIndex = GetRandomInt(0, remainingCandidates.length - 1);
    weakList.push(remainingCandidates[randomIndex]);
    remainingCandidates.splice(randomIndex, 1);
  }

  return weakList;
}

function 从YD创建弱点列表(this: void, bossUnit: any): Boss弱点定义[] {
  const weakList: Boss弱点定义[] = [];
  for (let i = 0; i < Boss弱点候选列表.length; i++) {
    const candidate = Boss弱点候选列表[i];
    if (读取Boss弱点标记(bossUnit, candidate.弱点键)) {
      weakList.push(candidate);
    }
  }
  return weakList;
}

function 填充默认反馈配置(this: void, config: Boss弱点韧性配置): Boss弱点韧性配置 {
  config.弱点发现音效路径 = config.弱点发现音效路径 ?? Boss弱点反馈默认配置.弱点发现音效路径;
  config.弱点击中音效路径 = config.弱点击中音效路径 ?? Boss弱点反馈默认配置.弱点击中音效路径;
  config.护盾破碎音效路径 = config.护盾破碎音效路径 ?? Boss弱点反馈默认配置.护盾破碎音效路径;
  config.弱点发现提示启用 = config.弱点发现提示启用 ?? Boss弱点反馈默认配置.弱点发现提示启用;
  config.护盾命中削减值 = config.护盾命中削减值 ?? Boss弱点反馈默认配置.护盾命中削减值;
  config.弱点命中表现毫秒 = config.弱点命中表现毫秒 ?? Boss弱点反馈默认配置.弱点命中表现毫秒;
  config.弱点命中伤害加成 = config.弱点命中伤害加成 ?? Boss弱点反馈默认配置.弱点命中伤害加成;
  config.破盾控制Buff类型 = config.破盾控制Buff类型 ?? Boss弱点反馈默认配置.破盾控制Buff类型;
  config.破盾控制持续秒 = config.破盾控制持续秒 ?? Boss弱点反馈默认配置.破盾控制持续秒;
  config.破盾伤害倍率 = config.破盾伤害倍率 ?? Boss弱点反馈默认配置.破盾伤害倍率;
  config.破碎护盾显示毫秒 = config.破碎护盾显示毫秒 ?? Boss弱点反馈默认配置.破碎护盾显示毫秒;
  return config;
}

function 创建TS启动属性弱点配置(this: void, bossUnit: any, 配置: 战斗启动属性配置): Boss弱点韧性配置 | undefined {
  const weakList = 从启动属性创建弱点列表(配置);
  if (weakList.length <= 0) return undefined;

  const n = 当前N值();
  const shieldValue = (配置.护盾基础值 ?? 0) + (配置.护盾每层N增量 ?? 0) * n;
  const maxLife = GetUnitStateJapi(bossUnit, UNIT_STATE_MAX_LIFE) || 0;
  const demand = (配置.器弱伤害需求生命百分比 ?? 0) * maxLife;

  return 填充默认反馈配置({
    配置键: "TS战斗启动属性",
    Boss单位名: 配置.单位名,
    Boss引用键: 配置.单位ID,
    弱点列表: weakList,
    天生弱点数: 配置.天生弱点数 ?? weakList.length,
    初始护盾值: shieldValue > 0 ? R2I(shieldValue) : undefined,
    弱点伤害需求: demand > 0 ? demand : undefined,
    护盾冷却毫秒: Boss弱点反馈默认配置.护盾恢复延迟毫秒,
  });
}

function 创建YD弱点配置(this: void, bossUnit: any): Boss弱点韧性配置 | undefined {
  const weakList = 从YD创建弱点列表(bossUnit);
  if (weakList.length <= 0) return undefined;

  return 填充默认反馈配置({
    配置键: "YD弱点标记",
    弱点列表: weakList,
    天生弱点数: weakList.length,
    初始护盾值: 读取Boss护盾值(bossUnit, Boss弱点YD字段.原始护盾值),
    弱点伤害需求: 读取Boss实数字段(bossUnit, Boss弱点YD字段.器弱伤害需求)
      ?? 读取Boss护盾值(bossUnit, Boss弱点YD字段.器弱伤害需求),
    护盾冷却毫秒: 读取Boss秒数字段毫秒(bossUnit, Boss弱点YD字段.护盾冷却) ?? Boss弱点反馈默认配置.护盾恢复延迟毫秒,
  });
}

export function 查找Boss弱点韧性配置(this: void, bossUnit: any): Boss弱点韧性配置 | undefined {
  if (bossUnit == null || bossUnit === 0) return undefined;
  const tsConfig = 按单位查找战斗启动属性配置(bossUnit);
  if (tsConfig != null) {
    const weakConfig = 创建TS启动属性弱点配置(bossUnit, tsConfig);
    if (weakConfig != null) return weakConfig;
  }
  const ydConfig = 创建YD弱点配置(bossUnit);
  if (ydConfig != null) return ydConfig;
  return undefined;
}
