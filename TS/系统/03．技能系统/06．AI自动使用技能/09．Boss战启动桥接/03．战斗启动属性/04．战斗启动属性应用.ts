/** @noSelfInFile */

import type { 战斗启动属性配置 } from "./00．配置类型";
import { Boss战斗启动属性配置表 } from "./01．Boss战斗启动属性配置表";
import { 英雄Boss战斗启动属性配置表 } from "./02．英雄Boss战斗启动属性配置表";
import { 异界Boss战斗启动属性配置表 } from "./03．异界Boss战斗启动属性配置表";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichState: number) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const R2I = jass.R2I as (r: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as number;

const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
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
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const 模块名 = "Boss战启动属性应用";
const 已应用属性单位表: Record<number, true | undefined> = {};
const 全部战斗启动属性配置表: 战斗启动属性配置[] = [
  ...Boss战斗启动属性配置表,
  ...英雄Boss战斗启动属性配置表,
  ...异界Boss战斗启动属性配置表,
];

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

function 按单位查找战斗启动属性配置(this: void, unit: any): 战斗启动属性配置 | undefined {
  const unitTypeId = GetUnitTypeId(unit);
  if (unitTypeId === 0) return undefined;

  for (let i = 0; i < 全部战斗启动属性配置表.length; i++) {
    const 配置 = 全部战斗启动属性配置表[i];
    if (解析配置单位类型ID(配置) === unitTypeId) {
      return 配置;
    }
  }
  return undefined;
}

function 写入整数属性(this: void, unit: any, 属性名: string, 值?: number): void {
  if (值 == null) return;
  YDUserDataSetSafe("unit", unit, 属性名, "integer", 值);
}

function 写入实数属性(this: void, unit: any, 属性名: string, 值?: number): void {
  if (值 == null) return;
  YDUserDataSetSafe("unit", unit, 属性名, "real", 值);
}

function 写入布尔属性(this: void, unit: any, 属性名: string, 值?: boolean): void {
  if (值 == null) return;
  YDUserDataSetSafe("unit", unit, 属性名, "boolean", 值);
}

function 写入Boss战字符串表实数(this: void, 属性名: string, 值?: number): void {
  if (值 == null) return;
  YDUserDataSetSafe("string", "Boss战", 属性名, "real", 值);
}

function 写入Boss战单位布尔(this: void, unit: any, 属性名: string, 值?: boolean): void {
  if (值 == null) return;
  YDUserDataSetSafe("unit", unit, 属性名, "boolean", 值);
}

function 写入Boss战音频(this: void, 属性名: string, 变量名?: string): void {
  if (变量名 == null || 变量名 === "") return;
  const 音频句柄 = jglobals[变量名];
  if (音频句柄 == null) return;
  YDUserDataSetSafe("string", "Boss战", 属性名, "sound", 音频句柄);
}

function 写入Boss战矩形(this: void, 属性名: string, 变量名?: string): void {
  if (变量名 == null || 变量名 === "") return;
  const 矩形句柄 = jglobals[变量名];
  if (矩形句柄 == null) return;
  YDUserDataSetSafe("string", "Boss战", 属性名, "rect", 矩形句柄);
}

export function 应用Boss战启动属性配置(this: void, unit: any): void {
  if (unit == null || unit === 0) return;

  const handleId = GetHandleId(unit);
  if (handleId === 0 || 已应用属性单位表[handleId]) return;

  const 配置 = 按单位查找战斗启动属性配置(unit);
  if (配置 == null) return;

  const n = 当前N值();
  const 弱点数量 = (配置.弱点数量基础值 ?? 0) + (配置.弱点数量每层N增量 ?? 0) * n;
  const 护盾值 = (配置.护盾基础值 ?? 0) + (配置.护盾每层N增量 ?? 0) * n;
  const 最大生命值 = GetUnitState(unit, UNIT_STATE_MAX_LIFE);
  const 器弱伤害需求 = (配置.器弱伤害需求生命百分比 ?? 0) * 最大生命值;

  写入Boss战音频("战斗音乐", 配置.战斗音乐变量名);
  写入Boss战音频("胜利音乐", 配置.胜利音乐变量名);
  写入Boss战矩形("地点", 配置.地点变量名);
  写入Boss战单位布尔(unit, "转换场景", 配置.转换场景);
  写入Boss战字符串表实数("BS移动X轴", 配置.BS移动X轴 ?? GetUnitX(unit));
  写入Boss战字符串表实数("BS移动Y轴", 配置.BS移动Y轴 ?? GetUnitY(unit));
  写入Boss战字符串表实数("玩家移动X轴", 配置.玩家移动X轴);
  写入Boss战字符串表实数("玩家移动Y轴", 配置.玩家移动Y轴);
  写入实数属性(unit, "魔抗", 配置.魔抗);
  写入实数属性(unit, "暴击率", 配置.暴击率);
  写入实数属性(unit, "暴击伤害", 配置.暴击伤害);
  写入实数属性(unit, "眩晕抗性", 配置.眩晕抗性);
  写入实数属性(unit, "命中率", 配置.命中率);
  写入实数属性(unit, "闪避率", 配置.闪避率);
  写入实数属性(unit, "护甲穿透", 配置.护甲穿透);
  写入实数属性(unit, "金属性抗性", 配置.金属性抗性);
  写入实数属性(unit, "伤害吸血", 配置.伤害吸血);
  写入实数属性(unit, "魔法伤害吸血", 配置.魔法伤害吸血);
  写入实数属性(unit, "普攻伤害吸血", 配置.普攻伤害吸血);
  写入实数属性(unit, "魔法穿透", 配置.魔法穿透);
  写入整数属性(unit, "弱点数量", 弱点数量);
  写入整数属性(unit, "天生弱点数", 配置.天生弱点数);
  写入整数属性(unit, "武器弱点数", 配置.武器弱点数);
  写入整数属性(unit, "属性弱点数", 配置.属性弱点数);
  写入布尔属性(unit, "弓弱", 配置.弓弱);
  写入布尔属性(unit, "斧弱", 配置.斧弱);
  写入布尔属性(unit, "枪弱", 配置.枪弱);
  写入布尔属性(unit, "剑弱", 配置.剑弱);
  写入布尔属性(unit, "短剑弱", 配置.短剑弱);
  写入布尔属性(unit, "杖弱", 配置.杖弱);
  写入布尔属性(unit, "暗弱", 配置.暗弱);
  写入布尔属性(unit, "冰弱", 配置.冰弱);
  写入布尔属性(unit, "火弱", 配置.火弱);
  写入布尔属性(unit, "风弱", 配置.风弱);
  写入布尔属性(unit, "雷弱", 配置.雷弱);
  写入布尔属性(unit, "光弱", 配置.光弱);
  写入实数属性(unit, "器弱伤害需求", 器弱伤害需求);
  写入整数属性(unit, "护盾值", R2I(护盾值));
  写入整数属性(unit, "原始护盾值", R2I(护盾值));

  已应用属性单位表[handleId] = true;

  debugLogForce(
    模块名,
    "应用配置",
    "unitTypeId=",
    GetUnitTypeId(unit),
    "分类=",
    配置.归类,
    "weakCount=",
    弱点数量,
    "shield=",
    护盾值,
    "N=",
    n
  );
}
