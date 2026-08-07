/** @noSelfInFile */

import type { 战斗启动属性配置 } from "./00．配置类型";
import { Boss战斗启动属性配置表 } from "./01．Boss战斗启动属性配置表";
import { 英雄Boss战斗启动属性配置表 } from "./02．英雄Boss战斗启动属性配置表";
import { 异界Boss战斗启动属性配置表 } from "./03．异界Boss战斗启动属性配置表";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const Rect = jass.Rect as (minX: number, minY: number, maxX: number, maxY: number) => any;
const CreateSound = jass.CreateSound as (
  fileName: string,
  looping: boolean,
  is3D: boolean,
  stopWhenOutOfRange: boolean,
  fadeInRate: number,
  fadeOutRate: number,
  eaxSetting: string
) => any;

const { YDUserDataSetSafe, YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
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
const Boss战路径音乐缓存: Record<string, any | undefined> = {};
const 全部战斗启动属性配置表: 战斗启动属性配置[] = [
  ...Boss战斗启动属性配置表,
  ...英雄Boss战斗启动属性配置表,
  ...异界Boss战斗启动属性配置表,
];

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

function 写入实数属性(this: void, unit: any, 属性名: string, 值?: number): void {
  if (值 == null) return;
  YDUserDataSetSafe("unit", unit, 属性名, "real", 值);
}

function 写入Boss战字符串表实数(this: void, 属性名: string, 值?: number): void {
  if (值 == null) return;
  YDUserDataSetSafe("string", "Boss战", 属性名, "real", 值);
}

function 写入Boss战单位布尔(this: void, unit: any, 属性名: string, 值?: boolean): void {
  if (值 == null) return;
  YDUserDataSetSafe("unit", unit, 属性名, "boolean", 值);
}

function 获取或创建Boss战路径音乐(this: void, 路径?: string): any {
  if (路径 == null || 路径 === "") return null;
  const 已缓存 = Boss战路径音乐缓存[路径];
  if (已缓存 != null && 已缓存 !== 0) return 已缓存;

  // 区域 BGM 由 RegisterStackedSound 按矩形控制，不能创建成会受距离裁断的 3D 音频。
  const 音频句柄 = CreateSound(路径, true, false, false, 10, 10, "DefaultEAXON");
  if (音频句柄 == null || 音频句柄 === 0) return null;
  Boss战路径音乐缓存[路径] = 音频句柄;
  debugLogForce(模块名, "创建路径音乐缓存", "path=", 路径);
  return 音频句柄;
}

function 读取变量音频(this: void, 变量名?: string): any {
  if (变量名 == null || 变量名 === "") return;
  const 音频句柄 = jglobals[变量名];
  if (音频句柄 == null) return null;
  return 音频句柄;
}

function 写入Boss战音频(this: void, 属性名: string, 路径?: string, 变量名?: string): void {
  const 音频句柄 = 获取或创建Boss战路径音乐(路径) ?? 读取变量音频(变量名);
  if (音频句柄 == null || 音频句柄 === 0) return;
  YDUserDataSetSafe("string", "Boss战", 属性名, "sound", 音频句柄);
}

function 写入Boss战矩形(this: void, 属性名: string, 变量名?: string): void {
  if (变量名 == null || 变量名 === "") return;
  const 矩形句柄 = jglobals[变量名];
  if (矩形句柄 == null) return;
  YDUserDataSetSafe("string", "Boss战", 属性名, "rect", 矩形句柄);
}

function 清理Boss战地点(this: void): void {
  YDUserDataClearSafe("string", "Boss战", "地点", "rect");
  YDUserDataClearSafe("string", "Boss战", "地点动态", "boolean");
}

function 写入Boss战动态矩形(this: void, 配置: 战斗启动属性配置["动态地点矩形"]): void {
  if (配置 == null) return;
  if (!(配置.左 < 配置.右) || !(配置.下 < 配置.上)) return;

  const 矩形句柄 = Rect(配置.左, 配置.下, 配置.右, 配置.上);
  if (矩形句柄 == null || 矩形句柄 === 0) return;
  YDUserDataSetSafe("string", "Boss战", "地点", "rect", 矩形句柄);
  YDUserDataSetSafe("string", "Boss战", "地点动态", "boolean", true);
}

export function 应用Boss战启动属性配置(this: void, unit: any): void {
  if (unit == null || unit === 0) return;

  const handleId = GetHandleId(unit);
  if (handleId === 0 || 已应用属性单位表[handleId]) return;

  const 配置 = 按单位查找战斗启动属性配置(unit);
  if (配置 == null) return;

  写入Boss战音频("战斗音乐", 配置.战斗音乐路径, 配置.战斗音乐变量名);
  写入Boss战音频("胜利音乐", 配置.胜利音乐路径, 配置.胜利音乐变量名);
  清理Boss战地点();
  if (配置.动态地点矩形 != null) 写入Boss战动态矩形(配置.动态地点矩形);
  else 写入Boss战矩形("地点", 配置.地点变量名);
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

  已应用属性单位表[handleId] = true;

  debugLogForce(
    模块名,
    "应用配置",
    "unitTypeId=",
    GetUnitTypeId(unit),
    "分类=",
    配置.归类
  );
}
