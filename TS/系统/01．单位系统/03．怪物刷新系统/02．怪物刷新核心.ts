/** @noSelfInFile */
/**
 * 世界地图怪物刷新系统
 *
 * 迁移来源：
 * - JASS/jass复制粘贴/刷新怪物.j
 *
 * 保留：
 * - `YDUserData("刷怪","单位组")`
 * - 怪物单位上的 `暴击率 / 暴击伤害 / 魔抗 / 命中率 / 闪避率`
 *
 * 优化：
 * - 出生点 X/Y 改为模块内缓存，不再写回单位 YDUserData
 * - 死亡延迟刷新改为具名计时器回调 + 上下文表
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const {
  YDUserDataGetSafe,
  YDUserDataSetSafe,
  YDUserDataHasSafe,
  YDUserDataClearTableSafe,
} = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataHasSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => boolean;
  YDUserDataClearTableSafe: (this: void, tableType: string, tableKey: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, cb: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};
import type {
  刷怪延迟上下文,
  刷怪记录,
  怪物属性快照,
  怪物属性键,
} from "./00．常量与类型";
import type { 世界地图单位出生配置 } from "../00．单位初始化创建/02．世界地图单位初始化/00．开关与类型";
import { 世界地图杂鱼出生配置表 } from "../00．单位初始化创建/02．世界地图单位初始化/01．杂鱼出生配置";
import { 世界地图精英出生配置表 } from "../00．单位初始化创建/02．世界地图单位初始化/02．精英出生配置";
import {
  中立敌对玩家ID,
  刷怪区域全局名,
  刷怪单位组键,
  刷怪延迟秒,
  刷怪表名,
  特殊敌对玩家ID,
  需要复制的属性键列表,
} from "./00．常量与类型";
import {
  命中率固定配置表,
  暴击率固定配置表,
  额外精英刷怪单位ID列表,
  特殊精英暴击覆写配置表,
  闪避率固定配置表,
} from "./01．怪物刷新配置表";

const GroupAddUnit = jass.GroupAddUnit as (this: void, whichGroup: any, whichUnit: any) => void;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, whichGroup: any, whichUnit: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, whichGroup: any) => any;
const CreateGroup = jass.CreateGroup as (this: void) => any;
const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
const GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect as (this: void, whichGroup: any, r: any, filter: any) => void;
const GetWorldBounds = jass.GetWorldBounds as (this: void) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, whichPlayer: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const IsUnitInGroup = jass.IsUnitInGroup as (this: void, whichUnit: any, whichGroup: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, whichUnit: any, whichType: any) => boolean;
const IsUnitRace = jass.IsUnitRace as (this: void, whichUnit: any, whichRace: any) => boolean;
const Player = jass.Player as (this: void, playerId: number) => any;
const RemoveUnit = jass.RemoveUnit as (this: void, whichUnit: any) => void;

const 刷怪记录表 = new Map<number, 刷怪记录>();
const 延迟刷新上下文队列: 刷怪延迟上下文[] = [];
const 允许刷怪单位类型ID集合 = new Set<number>();
type 单位固定属性配置 = { 属性名: 怪物属性键; 数值: number };
type 特殊精英暴击覆写运行时配置 = { 单位类型ID: number; X: number; Y: number; 暴击率: number };
const 固定属性配置缓存 = new Map<number, 单位固定属性配置[]>();
const 特殊精英暴击覆写运行时配置表: 特殊精英暴击覆写运行时配置[] = [];

const 初始收集每批单位数量 = 10;
const 初始收集间隔毫秒 = 10;

let 已初始化怪物刷新系统 = false;
let 已初始化允许刷怪单位类型ID集合 = false;
let 固定属性配置已初始化 = false;
let 初始收集临时单位组: any = null;
let 初始收集回调ID: number | undefined;
let 死亡监听已注册 = false;

function 绝对值(this: void, value: number): number {
  return value >= 0 ? value : -value;
}

function 实数近似相等(this: void, a: number, b: number, tolerance: number): boolean {
  return 绝对值(a - b) <= tolerance;
}

function 获取刷怪单位组(this: void): any {
  let 单位组 = YDUserDataGetSafe("string", 刷怪表名, 刷怪单位组键, "group");
  if (单位组 == null || 单位组 === 0) {
    单位组 = CreateGroup();
    YDUserDataSetSafe("string", 刷怪表名, 刷怪单位组键, "group", 单位组);
  }
  return 单位组;
}

function 清空单位组(this: void, 单位组: any): void {
  if (单位组 == null || 单位组 === 0) return;
  while (true) {
    const 单位 = FirstOfGroup(单位组);
    if (单位 == null || 单位 === 0) break;
    GroupRemoveUnit(单位组, 单位);
  }
}

function 解析刷怪配置单位类型ID(this: void, 配置: 世界地图单位出生配置): number {
  const 兼容单位ID = 配置.兼容单位ID?.trim();
  if (兼容单位ID == null || 兼容单位ID.length < 4) return 0;
  return stringToFourCCSafe(兼容单位ID.substring(0, 4));
}

function 添加刷怪配置表到白名单(this: void, 配置表: 世界地图单位出生配置[]): void {
  for (const 配置 of 配置表) {
    const 单位类型ID = 解析刷怪配置单位类型ID(配置);
    if (单位类型ID > 0) 允许刷怪单位类型ID集合.add(单位类型ID);
  }
}

function 添加直接单位ID列表到白名单(this: void, 单位ID列表: string[]): void {
  for (const 单位ID of 单位ID列表) {
    const 单位类型ID = 解析直接单位类型ID(单位ID);
    if (单位类型ID > 0) 允许刷怪单位类型ID集合.add(单位类型ID);
  }
}

function 确保允许刷怪单位类型ID集合已初始化(this: void): void {
  if (已初始化允许刷怪单位类型ID集合) return;
  已初始化允许刷怪单位类型ID集合 = true;
  添加刷怪配置表到白名单(世界地图杂鱼出生配置表);
  添加刷怪配置表到白名单(世界地图精英出生配置表);
  添加直接单位ID列表到白名单(额外精英刷怪单位ID列表);
}

function 是刷怪候选单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  确保允许刷怪单位类型ID集合已初始化();
  if (!允许刷怪单位类型ID集合.has(GetUnitTypeId(unit))) return false;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  const playerId = GetPlayerId(owner);
  return playerId === 特殊敌对玩家ID || playerId === 中立敌对玩家ID;
}

function 记录怪物出生点(this: void, unit: any, x: number, y: number): void {
  if (unit == null || unit === 0) return;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return;
  刷怪记录表.set(GetHandleId(unit), {
    单位类型ID: GetUnitTypeId(unit),
    所有者玩家ID: GetPlayerId(owner),
    出生X: x,
    出生Y: y,
  });
}

function 读取怪物属性(this: void, unit: any, 属性名: 怪物属性键): number | undefined {
  if (!YDUserDataHasSafe("unit", unit, 属性名, "real")) return undefined;
  const value = Number(YDUserDataGetSafe("unit", unit, 属性名, "real"));
  if (value !== value) return undefined;
  return value;
}

function 写入怪物属性(this: void, unit: any, 属性名: 怪物属性键, value: number): void {
  YDUserDataSetSafe("unit", unit, 属性名, "real", value);
}

function 解析直接单位类型ID(this: void, 单位ID: string | undefined): number {
  const 清理后单位ID = 单位ID?.trim();
  if (清理后单位ID == null || 清理后单位ID.length < 4) return 0;
  return stringToFourCCSafe(清理后单位ID.substring(0, 4));
}

function 初始化固定属性配置缓存(this: void): void {
  if (固定属性配置已初始化) return;
  固定属性配置已初始化 = true;

  const 固定属性配置表列表 = [暴击率固定配置表, 闪避率固定配置表, 命中率固定配置表];
  for (const 配置表 of 固定属性配置表列表) {
    for (const 配置 of 配置表) {
      const 单位类型ID = 解析直接单位类型ID(配置.单位ID);
      if (单位类型ID <= 0) continue;
      let 单位属性配置列表 = 固定属性配置缓存.get(单位类型ID);
      if (单位属性配置列表 == null) {
        单位属性配置列表 = [];
        固定属性配置缓存.set(单位类型ID, 单位属性配置列表);
      }
      单位属性配置列表.push({ 属性名: 配置.属性名, 数值: 配置.数值 });
    }
  }

  for (const 配置 of 特殊精英暴击覆写配置表) {
    特殊精英暴击覆写运行时配置表.push({
      单位类型ID: 解析直接单位类型ID(配置.单位ID),
      X: 配置.X,
      Y: 配置.Y,
      暴击率: 配置.暴击率,
    });
  }
}

function 应用基础怪物属性(this: void, unit: any): void {
  const 单位属性配置列表 = 固定属性配置缓存.get(GetUnitTypeId(unit));
  if (单位属性配置列表 != null) {
    for (const 配置 of 单位属性配置列表) {
      写入怪物属性(unit, 配置.属性名, 配置.数值);
    }
  }

  if (IsUnitType(unit, jass.UNIT_TYPE_HERO) || IsUnitRace(unit, jass.RACE_DEMON)) {
    写入怪物属性(unit, "暴击率", 0.10);
    写入怪物属性(unit, "魔抗", 0.25);
    写入怪物属性(unit, "闪避率", 0.10);
  }
}

function 应用特殊精英暴击覆写(this: void, unit: any, 出生X: number, 出生Y: number): void {
  const 单位类型ID = GetUnitTypeId(unit);
  for (const 配置 of 特殊精英暴击覆写运行时配置表) {
    if (配置.单位类型ID <= 0 || 单位类型ID !== 配置.单位类型ID) continue;
    if (!实数近似相等(出生X, 配置.X, 0.05)) continue;
    if (!实数近似相等(出生Y, 配置.Y, 0.05)) continue;
    写入怪物属性(unit, "暴击率", 配置.暴击率);
    return;
  }
}

function 初始化单个刷怪单位(this: void, unit: any): void {
  const 出生X = GetUnitX(unit);
  const 出生Y = GetUnitY(unit);
  记录怪物出生点(unit, 出生X, 出生Y);
  应用基础怪物属性(unit);
  应用特殊精英暴击覆写(unit, 出生X, 出生Y);
}

function 登记刷怪单位(this: void, unit: any): void {
  if (!是刷怪候选单位(unit)) return;

  const 单位句柄ID = GetHandleId(unit);
  if (刷怪记录表.has(单位句柄ID)) return;

  const 刷怪单位组 = 获取刷怪单位组();
  if (!IsUnitInGroup(unit, 刷怪单位组)) {
    GroupAddUnit(刷怪单位组, unit);
  }
  初始化单个刷怪单位(unit);
}

/** 供任务等运行时入口把新建敌人纳入同一套死亡刷新流程。 */
export function 登记动态刷怪单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  初始化怪物刷新系统();
  确保允许刷怪单位类型ID集合已初始化();
  const 单位类型ID = GetUnitTypeId(unit);
  if (单位类型ID <= 0) return false;
  允许刷怪单位类型ID集合.add(单位类型ID);
  登记刷怪单位(unit);
  return 刷怪记录表.has(GetHandleId(unit));
}

function 获取刷怪区域(this: void): any {
  const 配置区域 = (jglobals as any)[刷怪区域全局名] as any;
  if (配置区域 != null && 配置区域 !== 0) return 配置区域;

  const 世界边界 = GetWorldBounds();
  if (世界边界 != null && 世界边界 !== 0) {
    return 世界边界;
  }
  return null;
}

function 处理刷怪区域枚举单位(this: void, unit: any): void {
  登记刷怪单位(unit);
}

function 完成初始刷怪单位收集(this: void): void {
  if (初始收集回调ID != null) {
    removePeriodicCallback(初始收集回调ID);
    初始收集回调ID = undefined;
  }

  if (初始收集临时单位组 != null && 初始收集临时单位组 !== 0) {
    DestroyGroup(初始收集临时单位组);
    初始收集临时单位组 = null;
  }

  if (死亡监听已注册) return;
  死亡监听已注册 = true;
  registerDeathListener(on刷怪单位死亡);
}

function on初始刷怪单位收集批次(this: void): void {
  const 临时组 = 初始收集临时单位组;
  if (临时组 == null || 临时组 === 0) {
    完成初始刷怪单位收集();
    return;
  }

  let 本批处理数量 = 0;
  while (本批处理数量 < 初始收集每批单位数量) {
    const 单位 = FirstOfGroup(临时组);
    if (单位 == null || 单位 === 0) break;
    GroupRemoveUnit(临时组, 单位);
    处理刷怪区域枚举单位(单位);
    本批处理数量++;
  }

  const 剩余单位 = FirstOfGroup(临时组);
  if (剩余单位 == null || 剩余单位 === 0) {
    完成初始刷怪单位收集();
  }
}

function 收集初始刷怪单位(this: void): void {
  const 刷怪单位组 = 获取刷怪单位组();
  清空单位组(刷怪单位组);
  刷怪记录表.clear();
  初始化固定属性配置缓存();

  const 刷怪区域 = 获取刷怪区域();
  if (刷怪区域 == null || 刷怪区域 === 0) {
    完成初始刷怪单位收集();
    return;
  }

  初始收集临时单位组 = CreateGroup();
  GroupEnumUnitsInRect(初始收集临时单位组, 刷怪区域, null);
  初始收集回调ID = addPeriodicCallback(初始收集间隔毫秒, on初始刷怪单位收集批次);
}

function 快照死亡怪物属性(this: void, unit: any): 怪物属性快照 {
  const result: 怪物属性快照 = {};
  for (const 属性名 of 需要复制的属性键列表) {
    const value = 读取怪物属性(unit, 属性名);
    if (typeof value === "number") {
      result[属性名] = value;
    }
  }
  return result;
}

function 应用属性快照到新单位(this: void, unit: any, 属性快照: 怪物属性快照): void {
  for (const 属性名 of 需要复制的属性键列表) {
    const value = 属性快照[属性名];
    if (typeof value === "number") {
      写入怪物属性(unit, 属性名, value);
    }
  }
}

function on怪物刷新计时器到期(this: void): void {
  const ctx = 延迟刷新上下文队列.shift();
  if (ctx == null) return;

  const owner = Player(ctx.所有者玩家ID);
  const 新单位 = 创建单位并登记排泄安全(owner, ctx.单位类型ID, ctx.出生X, ctx.出生Y, GetRandomDirectionDeg());
  if (新单位 == null || 新单位 === 0) return;

  记录怪物出生点(新单位, ctx.出生X, ctx.出生Y);
  应用属性快照到新单位(新单位, ctx.属性快照);

  const 刷怪单位组 = 获取刷怪单位组();
  GroupAddUnit(刷怪单位组, 新单位);
  GroupRemoveUnit(刷怪单位组, ctx.死亡单位);
  YDUserDataClearTableSafe("unit", ctx.死亡单位);
  刷怪记录表.delete(GetHandleId(ctx.死亡单位));
  RemoveUnit(ctx.死亡单位);
}

function 安排怪物延迟刷新(this: void, dyingUnit: any, record: 刷怪记录): void {
  延迟刷新上下文队列.push({
    死亡单位: dyingUnit,
    单位类型ID: record.单位类型ID,
    所有者玩家ID: record.所有者玩家ID,
    出生X: record.出生X,
    出生Y: record.出生Y,
    属性快照: 快照死亡怪物属性(dyingUnit),
  });
  addDelayedCallback(刷怪延迟秒 * 1000, on怪物刷新计时器到期);
}

function on刷怪单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const 刷怪单位组 = 获取刷怪单位组();
  if (!IsUnitInGroup(dyingUnit, 刷怪单位组)) return;

  const record = 刷怪记录表.get(GetHandleId(dyingUnit));
  if (record == null) return;
  安排怪物延迟刷新(dyingUnit, record);
}

export function 初始化怪物刷新系统(this: void): void {
  if (已初始化怪物刷新系统) return;
  已初始化怪物刷新系统 = true;
  收集初始刷怪单位();
}

export function 获取刷怪单位组引用(this: void): any {
  return 获取刷怪单位组();
}

export function 是刷怪单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return IsUnitInGroup(unit, 获取刷怪单位组()) === true;
}

export {};
