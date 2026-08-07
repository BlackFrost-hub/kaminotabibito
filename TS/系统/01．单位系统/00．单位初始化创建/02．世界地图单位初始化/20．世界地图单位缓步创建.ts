/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查异界Boss单位ID } = require("系统.01．单位系统.08．单位配置表.03．异界Boss配置表") as {
  按名字反查异界Boss单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { AddItemToStockBJ } = require("lib.扩展函数.BJ函数.03．物品与库存") as {
  AddItemToStockBJ: (this: void, itemId: number, whichUnit: any, currentStock: number, stockMax: number) => void;
};
const { YDUserDataSetSafe, YDUserDataClearSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};

import type {
  世界地图Boss初始注册配置,
  世界地图单位出生配置,
  世界地图单位缓步创建状态,
  世界地图单位缓步创建选项,
  世界地图敌人归类,
} from "./00．开关与类型";
import {
  世界地图单位默认批次间隔秒,
  世界地图单位默认每批创建数量,
} from "./00．开关与类型";
import type { 中立生物创建配置 } from "./05．中立生物配置表";
import { 世界地图中立生物配置表 } from "./05．中立生物配置表";
import type { 世界地图植物单位配置, 世界地图植物随机物品配置 } from "./06．植物配置表";
import { 世界地图植物单位配置表, 世界地图植物随机物品配置表 } from "./06．植物配置表";
import type { 异界描述石配置 } from "./07．异界描述石配置表";
import { 世界地图异界描述石配置表 } from "./07．异界描述石配置表";
import {
  世界地图Boss初始注册延迟秒,
  世界地图Boss初始注册配置表,
  世界地图Boss初始额外单位配置表,
} from "./08．Boss初始注册配置表";
import { 尝试缓存世界地图单位 } from "./09．世界地图单位缓存";

const Player = jass.Player as (this: void, playerId: number) => any;
const GetRandomReal = jass.GetRandomReal as (this: void, lowBound: number, highBound: number) => number;
const GetRectMinX = jass.GetRectMinX as (this: void, whichRect: any) => number;
const GetRectMaxX = jass.GetRectMaxX as (this: void, whichRect: any) => number;
const GetRectMinY = jass.GetRectMinY as (this: void, whichRect: any) => number;
const GetRectMaxY = jass.GetRectMaxY as (this: void, whichRect: any) => number;
const ShowUnit = jass.ShowUnit as (this: void, whichUnit: any, show: boolean) => void;
const R2I = jass.R2I as (this: void, r: number) => number;
const S2R = jass.S2R as (this: void, value: string) => number;
const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const 中立被动玩家ID = jass.PLAYER_NEUTRAL_PASSIVE as number;
const 世界地图随机单位默认玩家ID = 中立被动玩家ID;
const 世界地图随机单位默认朝向 = 0.0;
const 初始注册Boss跳过死亡结算字段 = "初始注册Boss跳过死亡结算";
const 初始注册Boss死亡结算保护毫秒 = 3000;

let 初始注册Boss死亡结算保护清理已安排 = false;
const 待清理初始注册Boss死亡结算保护单位: any[] = [];

interface 世界地图单位缓步创建任务 {
  任务ID: number;
  配置表: 世界地图单位出生配置[];
  当前索引: number;
  已创建数量: number;
  每批创建数量: number;
  批次间隔毫秒: number;
  已累计毫秒: number;
  完成回调?: (this: void, 已创建数量: number) => void;
}

const 缓步创建调度器间隔毫秒 = 10;

let 当前默认任务ID: number | undefined;
let 下一个缓步创建任务ID = 1;
let 缓步创建调度器回调ID: number | undefined;
const 缓步创建任务表: Record<number, 世界地图单位缓步创建任务 | undefined> = {};
let 世界地图Boss初始注册完成回调: ((this: void) => void) | undefined;

function 归类反查单位ID(this: void, 敌人归类: 世界地图敌人归类, 单位名: string): string | undefined {
  if (敌人归类 === "Boss") return 按名字反查Boss单位ID(单位名);
  if (敌人归类 === "异界Boss") return 按名字反查异界Boss单位ID(单位名);
  if (敌人归类 === "NPC") return 按名字反查总单位ID(单位名);
  return undefined;
}

function 解析世界地图单位ID(this: void, 配置: 世界地图单位出生配置): string | undefined {
  if (配置.敌人归类 === "杂鱼" || 配置.敌人归类 === "精英") {
    const 兼容单位ID = 配置.兼容单位ID?.trim();
    if (兼容单位ID != null && 兼容单位ID.length >= 4) {
      return 兼容单位ID.substring(0, 4);
    }
    return undefined;
  }

  const 反查结果 = 归类反查单位ID(配置.敌人归类, 配置.单位名);
  if (反查结果 != null && 反查结果 !== "") {
    return 反查结果;
  }

  const 总表反查结果 = 按名字反查总单位ID(配置.单位名);
  if (总表反查结果 != null && 总表反查结果 !== "") {
    return 总表反查结果;
  }

  const 兼容单位ID = 配置.兼容单位ID?.trim();
  if (兼容单位ID != null && 兼容单位ID.length >= 4) {
    return 兼容单位ID.substring(0, 4);
  }

  return undefined;
}

function 解析世界地图单位朝向(this: void, 配置: 世界地图单位出生配置): number {
  if (配置.朝向 === "随机") {
    return GetRandomDirectionDeg();
  }
  if (typeof 配置.朝向 === "number") {
    return 配置.朝向;
  }
  return S2R(配置.朝向);
}

function 解析世界地图单位玩家(this: void, 配置: 世界地图单位出生配置): any {
  const 玩家ID = 配置.玩家ID ?? (配置.敌人归类 === "NPC" ? 中立被动玩家ID : 中立敌对玩家ID);
  return Player(玩家ID);
}

function 获取随机矩形X(this: void, rect: any): number {
  return GetRandomReal(GetRectMinX(rect), GetRectMaxX(rect));
}

function 获取随机矩形Y(this: void, rect: any): number {
  return GetRandomReal(GetRectMinY(rect), GetRectMaxY(rect));
}

function 解析世界地图物品ID(this: void, 物品名: string): string | undefined {
  const 反查结果 = 按名字反查物品ID(物品名);
  if (反查结果 != null && 反查结果 !== "") {
    return 反查结果;
  }
  return undefined;
}

function 创建世界地图单位实例(this: void, 配置: 世界地图单位出生配置): any {
  const 单位ID = 解析世界地图单位ID(配置);
  if (单位ID == null) return undefined;

  const 单位类型ID = stringToFourCC(单位ID);
  const 面向角度 = 解析世界地图单位朝向(配置);
  const 玩家 = 解析世界地图单位玩家(配置);
  const unit = 创建单位并登记排泄安全(玩家, 单位类型ID, 配置.X, 配置.Y, 面向角度);
  尝试缓存世界地图单位(配置, unit);
  return unit;
}

function 执行单条世界地图单位创建(this: void, 配置: 世界地图单位出生配置): boolean {
  const 单位 = 创建世界地图单位实例(配置);
  return 单位 != null;
}

function 获取缓步创建任务(this: void, 任务ID: number | undefined): 世界地图单位缓步创建任务 | undefined {
  if (任务ID == null) return undefined;
  return 缓步创建任务表[任务ID];
}

function 构造空缓步创建状态(this: void): 世界地图单位缓步创建状态 {
  return { 总数: 0, 当前索引: 0, 已创建数量: 0, 运行中: false };
}

function 构造缓步创建状态(this: void, 任务: 世界地图单位缓步创建任务 | undefined): 世界地图单位缓步创建状态 {
  if (任务 == null) {
    return 构造空缓步创建状态();
  }

  return {
    总数: 任务.配置表.length,
    当前索引: 任务.当前索引,
    已创建数量: 任务.已创建数量,
    运行中: true,
  };
}

function 是否仍有缓步创建任务(this: void): boolean {
  for (const 任务 of Object.values(缓步创建任务表)) {
    if (任务 != null) {
      return true;
    }
  }
  return false;
}

function 如无任务则停止缓步创建调度器(this: void): void {
  if (是否仍有缓步创建任务()) return;
  if (缓步创建调度器回调ID == null) return;
  removePeriodicCallback(缓步创建调度器回调ID);
  缓步创建调度器回调ID = undefined;
}

function 删除缓步创建任务(this: void, 任务ID: number): void {
  delete 缓步创建任务表[任务ID];
  if (当前默认任务ID === 任务ID) {
    当前默认任务ID = undefined;
  }
  如无任务则停止缓步创建调度器();
}

function 停止指定缓步创建任务(this: void, 任务ID: number | undefined): void {
  if (任务ID == null) return;
  删除缓步创建任务(任务ID);
}

function 执行单个缓步创建任务一批(this: void, 任务: 世界地图单位缓步创建任务): void {
  let 本批创建数 = 0;
  while (任务.当前索引 < 任务.配置表.length && 本批创建数 < 任务.每批创建数量) {
    const 配置 = 任务.配置表[任务.当前索引];
    任务.当前索引++;
    本批创建数++;
    if (执行单条世界地图单位创建(配置)) {
      任务.已创建数量++;
    }
  }

  if (任务.当前索引 < 任务.配置表.length) {
    return;
  }

  const 完成回调 = 任务.完成回调;
  const 已创建数量 = 任务.已创建数量;
  删除缓步创建任务(任务.任务ID);
  if (typeof 完成回调 === "function") {
    完成回调(已创建数量);
  }
}

function 处理全部缓步创建任务(this: void): void {
  for (const 任务 of Object.values(缓步创建任务表)) {
    if (任务 == null) continue;
    任务.已累计毫秒 += 缓步创建调度器间隔毫秒;
    if (任务.已累计毫秒 < 任务.批次间隔毫秒) {
      continue;
    }
    任务.已累计毫秒 = 0;
    执行单个缓步创建任务一批(任务);
  }
  如无任务则停止缓步创建调度器();
}

function 确保缓步创建调度器已启动(this: void): void {
  if (缓步创建调度器回调ID != null) return;
  缓步创建调度器回调ID = addPeriodicCallback(缓步创建调度器间隔毫秒, 处理全部缓步创建任务);
}

export function 预解析世界地图单位ID(this: void, 配置: 世界地图单位出生配置): string | undefined {
  return 解析世界地图单位ID(配置);
}

export function 获取世界地图单位缓步创建任务状态(this: void, 任务ID: number): 世界地图单位缓步创建状态 {
  return 构造缓步创建状态(获取缓步创建任务(任务ID));
}

export function 获取世界地图单位缓步创建状态(this: void): 世界地图单位缓步创建状态 {
  return 构造缓步创建状态(获取缓步创建任务(当前默认任务ID));
}

export function 启动世界地图单位缓步创建任务(
  this: void,
  配置表: 世界地图单位出生配置[],
  选项?: 世界地图单位缓步创建选项,
): number {
  const 每批创建数量原值 = 选项?.每批创建数量 ?? 世界地图单位默认每批创建数量;
  const 每批创建数量 = 每批创建数量原值 > 0 ? 每批创建数量原值 : 世界地图单位默认每批创建数量;
  const 批次间隔秒原值 = 选项?.批次间隔秒 ?? 世界地图单位默认批次间隔秒;
  const 批次间隔秒 = 批次间隔秒原值 >= 0 ? 批次间隔秒原值 : 世界地图单位默认批次间隔秒;
  const 批次间隔毫秒 = 批次间隔秒 <= 0 ? 1 : R2I(批次间隔秒 * 1000);
  const 任务ID = 下一个缓步创建任务ID;
  下一个缓步创建任务ID++;

  缓步创建任务表[任务ID] = {
    任务ID,
    配置表,
    当前索引: 0,
    已创建数量: 0,
    每批创建数量,
    批次间隔毫秒: 批次间隔毫秒 < 缓步创建调度器间隔毫秒 ? 缓步创建调度器间隔毫秒 : 批次间隔毫秒,
    已累计毫秒: 0,
    完成回调: 选项?.完成回调,
  };

  确保缓步创建调度器已启动();
  return 任务ID;
}

export function 启动世界地图单位缓步创建(
  this: void,
  配置表: 世界地图单位出生配置[],
  选项?: 世界地图单位缓步创建选项,
): 世界地图单位缓步创建状态 {
  停止指定缓步创建任务(当前默认任务ID);
  当前默认任务ID = 启动世界地图单位缓步创建任务(配置表, 选项);
  return 获取世界地图单位缓步创建状态();
}

export function 停止世界地图单位缓步创建任务(this: void, 任务ID: number): void {
  停止指定缓步创建任务(任务ID);
}

export function 停止世界地图单位缓步创建(this: void): void {
  停止指定缓步创建任务(当前默认任务ID);
  当前默认任务ID = undefined;
}

export function 立即创建世界地图单位(this: void, 配置: 世界地图单位出生配置): boolean {
  return 执行单条世界地图单位创建(配置);
}

function 清理初始注册Boss死亡结算保护(this: void): void {
  for (let i = 0; i < 待清理初始注册Boss死亡结算保护单位.length; i++) {
    const 单位 = 待清理初始注册Boss死亡结算保护单位[i];
    if (单位 != null && 单位 !== 0) {
      YDUserDataClearSafe("unit", 单位, 初始注册Boss跳过死亡结算字段, "boolean");
    }
  }
  待清理初始注册Boss死亡结算保护单位.length = 0;
  初始注册Boss死亡结算保护清理已安排 = false;
}

function 标记初始注册Boss临时跳过死亡结算(this: void, 单位: any): void {
  if (单位 == null || 单位 === 0) return;
  YDUserDataSetSafe("unit", 单位, 初始注册Boss跳过死亡结算字段, "boolean", true);
  待清理初始注册Boss死亡结算保护单位.push(单位);
  if (初始注册Boss死亡结算保护清理已安排) return;
  初始注册Boss死亡结算保护清理已安排 = true;
  addDelayedCallback(初始注册Boss死亡结算保护毫秒, 清理初始注册Boss死亡结算保护);
}

function 执行单条世界地图Boss初始注册(this: void, 配置: 世界地图Boss初始注册配置): any {
  const 单位 = 创建世界地图单位实例(配置);
  if (单位 == null) return undefined;
  标记初始注册Boss临时跳过死亡结算(单位);

  if (配置.记录到Boss表键名 != null && 配置.记录到Boss表键名 !== "") {
    YDUserDataSetSafe("string", "Boss", 配置.记录到Boss表键名, "unit", 单位);
  }

  if (配置.初始隐藏 === true) {
    ShowUnit(单位, false);
  }

  return 单位;
}

function 执行世界地图Boss初始注册配置表(this: void, 配置表: 世界地图Boss初始注册配置[]): number {
  let 已创建数量 = 0;
  for (const 配置 of 配置表) {
    if (执行单条世界地图Boss初始注册(配置) != null) {
      已创建数量++;
    }
  }
  return 已创建数量;
}

function on世界地图Boss初始注册延迟回调(this: void): void {
  初始化世界地图Boss初始注册();
  const 完成回调 = 世界地图Boss初始注册完成回调;
  世界地图Boss初始注册完成回调 = undefined;
  if (typeof 完成回调 === "function") {
    完成回调();
  }
}

export function 初始化世界地图Boss初始注册(this: void): number {
  return 执行世界地图Boss初始注册配置表(世界地图Boss初始注册配置表)
    + 执行世界地图Boss初始注册配置表(世界地图Boss初始额外单位配置表);
}

export function 延迟初始化世界地图Boss初始注册(this: void, 完成回调?: (this: void) => void): void {
  世界地图Boss初始注册完成回调 = 完成回调;
  addDelayedCallback(世界地图Boss初始注册延迟秒 * 1000, on世界地图Boss初始注册延迟回调);
}

function 解析区域随机创建单位ID(this: void, 单位名: string): string | undefined {
  const 总表反查结果 = 按名字反查总单位ID(单位名);
  if (总表反查结果 != null && 总表反查结果 !== "") {
    return 总表反查结果;
  }
  if (单位名.length >= 4) {
    return 单位名.substring(0, 4);
  }
  return undefined;
}

function 执行单条中立生物创建(this: void, 配置: 中立生物创建配置): number {
  const rect = (jglobals as Record<string, any>)[配置.矩形变量名];
  if (rect == null) return 0;

  const 单位ID = 解析区域随机创建单位ID(配置.单位名);
  if (单位ID == null) return 0;

  const 单位类型ID = stringToFourCC(单位ID);
  const 玩家 = Player(配置.玩家ID ?? 世界地图随机单位默认玩家ID);
  const 朝向 = 配置.朝向 ?? 世界地图随机单位默认朝向;
  let 已创建数量 = 0;

  for (let i = 0; i < 配置.创建数量; i++) {
    const x = 获取随机矩形X(rect);
    const y = 获取随机矩形Y(rect);
    const 单位 = 创建单位并登记排泄安全(玩家, 单位类型ID, x, y, 朝向);
    if (单位 != null && 单位 !== 0) {
      已创建数量++;
    }
  }

  return 已创建数量;
}

export function 执行世界地图中立生物创建(this: void, 配置表?: 中立生物创建配置[]): number {
  const 实际配置表 = 配置表 ?? 世界地图中立生物配置表;
  let 总创建数量 = 0;

  for (const 配置 of 实际配置表) {
    总创建数量 += 执行单条中立生物创建(配置);
  }

  return 总创建数量;
}

export function 初始化世界地图中立生物(this: void): number {
  return 执行世界地图中立生物创建(世界地图中立生物配置表);
}

function 执行单条世界地图植物单位创建(this: void, 配置: 世界地图植物单位配置): any {
  const 单位ID = 按名字反查总单位ID(配置.单位名);
  if (单位ID == null || 单位ID === "") return undefined;

  const 单位类型ID = stringToFourCC(单位ID);
  const 朝向 = 配置.朝向 === "随机" ? GetRandomDirectionDeg() : (配置.朝向 ?? 0.0);
  const 玩家 = Player(配置.玩家ID ?? 中立被动玩家ID);
  const 单位 = 创建单位并登记排泄安全(玩家, 单位类型ID, 配置.X, 配置.Y, 朝向);

  if (单位 != null && 配置.YD表名 != null && 配置.YD键名 != null) {
    YDUserDataSetSafe("string", 配置.YD表名, 配置.YD键名, "unit", 单位);
  }

  return 单位;
}

function 执行单条世界地图植物随机物品创建(this: void, 配置: 世界地图植物随机物品配置): number {
  const rect = (jglobals as Record<string, any>)[配置.矩形变量名];
  if (rect == null) return 0;

  const 物品ID = 解析世界地图物品ID(配置.物品名);
  if (物品ID == null) return 0;

  const 物品类型ID = stringToFourCC(物品ID);
  let 已创建数量 = 0;

  for (let i = 0; i < 配置.创建数量; i++) {
    const x = 获取随机矩形X(rect);
    const y = 获取随机矩形Y(rect);
    const 物品 = 创建物品并注册排泄监听(物品类型ID, x, y);
    if (物品 != null && 物品 !== 0) {
      已创建数量++;
    }
  }

  return 已创建数量;
}

export function 初始化世界地图植物(this: void): number {
  let 总创建数量 = 0;

  for (const 配置 of 世界地图植物单位配置表) {
    if (执行单条世界地图植物单位创建(配置) != null) {
      总创建数量++;
    }
  }

  for (const 配置 of 世界地图植物随机物品配置表) {
    总创建数量 += 执行单条世界地图植物随机物品创建(配置);
  }

  return 总创建数量;
}

function 执行单条异界描述石创建(this: void, 配置: 异界描述石配置): any {
  const 单位ID = 按名字反查总单位ID(配置.单位名);
  const 物品ID = 解析世界地图物品ID(配置.上架物品名);
  if (单位ID == null || 单位ID === "" || 物品ID == null) return undefined;

  const 单位类型ID = stringToFourCC(单位ID);
  const 物品类型ID = stringToFourCC(物品ID);
  const 朝向 = 配置.朝向 === "随机" ? GetRandomDirectionDeg() : (配置.朝向 ?? 0.0);
  const 玩家 = Player(配置.玩家ID ?? 中立被动玩家ID);
  const 单位 = 创建单位并登记排泄安全(玩家, 单位类型ID, 配置.X, 配置.Y, 朝向);

  if (单位 != null) {
    AddItemToStockBJ(物品类型ID, 单位, 配置.当前库存 ?? 1, 配置.最大库存 ?? 1);
  }

  return 单位;
}

export function 初始化世界地图异界描述石(this: void): number {
  let 总创建数量 = 0;

  for (const 配置 of 世界地图异界描述石配置表) {
    if (执行单条异界描述石创建(配置) != null) {
      总创建数量++;
    }
  }

  return 总创建数量;
}
