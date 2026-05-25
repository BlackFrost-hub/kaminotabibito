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

const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (this: void, module: string, ...args: any[]) => void;
};
const { 按名字反查杂鱼单位ID } = require("系统.01．单位系统.08．单位配置表.00．杂鱼配置表") as {
  按名字反查杂鱼单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查精英单位ID } = require("系统.01．单位系统.08．单位配置表.01．精英配置表") as {
  按名字反查精英单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
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
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (this: void, timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (this: void, timer: any) => void;
};
const { GetRandomDirectionDeg } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetRandomDirectionDeg: (this: void) => number;
};
const { forEachUnitInGroup } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  forEachUnitInGroup: (this: void, group: any, action: (unit: any) => void) => void;
};

import type {
  刷怪延迟上下文,
  刷怪记录,
  怪物属性快照,
  怪物属性键,
} from "./00．常量与类型";
import {
  中立敌对玩家ID,
  刷怪区域全局名,
  刷怪单位组键,
  刷怪延迟秒,
  刷怪表名,
  怪物刷新模块名,
  特殊敌对玩家ID,
  需要复制的属性键列表,
} from "./00．常量与类型";
import {
  命中率固定配置表,
  暴击率固定配置表,
  特殊精英暴击覆写配置表,
  闪避率固定配置表,
} from "./01．怪物刷新配置表";

const GroupAddUnit = jass.GroupAddUnit as (this: void, whichGroup: any, whichUnit: any) => void;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, whichGroup: any, whichUnit: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, whichGroup: any) => any;
const CreateGroup = jass.CreateGroup as (this: void) => any;
const CreateTimer = jass.CreateTimer as (this: void) => any;
const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
const GetExpiredTimer = jass.GetExpiredTimer as (this: void) => any;
const GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect as (this: void, whichGroup: any, r: any, filter: any) => void;
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

const 刷怪区域 = (jglobals as any)[刷怪区域全局名] as any;
const 刷怪记录表 = new Map<number, 刷怪记录>();
const 延迟刷新上下文表 = new Map<number, 刷怪延迟上下文>();
const 固定属性单位ID缓存 = new Map<string, number>();

let 已初始化怪物刷新系统 = false;

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

function 是刷怪候选单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
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

function 按名字解析单位ID(this: void, 单位名: string): number | undefined {
  const 已缓存 = 固定属性单位ID缓存.get(单位名);
  if (typeof 已缓存 === "number") return 已缓存;

  const rawId = 按名字反查杂鱼单位ID(单位名) ?? 按名字反查精英单位ID(单位名) ?? 按名字反查总单位ID(单位名);
  if (rawId == null || rawId === "") {
    debugLog(怪物刷新模块名, "固定属性配置反查失败", 单位名);
    return undefined;
  }

  const unitTypeId = stringToFourCCSafe(rawId);
  固定属性单位ID缓存.set(单位名, unitTypeId);
  return unitTypeId;
}

function 写入固定属性配置(this: void, unit: any, 配置表: { 单位名: string; 属性名: 怪物属性键; 数值: number }[]): void {
  const 单位类型ID = GetUnitTypeId(unit);
  for (const 配置 of 配置表) {
    const 配置单位ID = 按名字解析单位ID(配置.单位名);
    if (配置单位ID == null) continue;
    if (单位类型ID !== 配置单位ID) continue;
    写入怪物属性(unit, 配置.属性名, 配置.数值);
  }
}

function 应用基础怪物属性(this: void, unit: any): void {
  写入固定属性配置(unit, 暴击率固定配置表);
  写入固定属性配置(unit, 闪避率固定配置表);
  写入固定属性配置(unit, 命中率固定配置表);

  if (IsUnitType(unit, jass.UNIT_TYPE_HERO) || IsUnitRace(unit, jass.RACE_DEMON)) {
    写入怪物属性(unit, "暴击率", 0.10);
    写入怪物属性(unit, "魔抗", 0.25);
    写入怪物属性(unit, "闪避率", 0.10);
  }
}

function 应用特殊精英暴击覆写(this: void, unit: any, 出生X: number, 出生Y: number): void {
  const 单位类型ID = GetUnitTypeId(unit);
  for (const 配置 of 特殊精英暴击覆写配置表) {
    if (配置.单位名 != null && 配置.单位名 !== "") {
      const 配置单位ID = 按名字解析单位ID(配置.单位名);
      if (配置单位ID == null) continue;
      if (单位类型ID !== 配置单位ID) continue;
    }
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

function 处理刷怪区域枚举单位(this: void, unit: any): void {
  if (!是刷怪候选单位(unit)) return;
  const 刷怪单位组 = 获取刷怪单位组();
  GroupAddUnit(刷怪单位组, unit);
  初始化单个刷怪单位(unit);
}

function 收集初始刷怪单位(this: void): void {
  const 刷怪单位组 = 获取刷怪单位组();
  清空单位组(刷怪单位组);
  刷怪记录表.clear();

  if (刷怪区域 == null || 刷怪区域 === 0) {
    debugLog(怪物刷新模块名, "未找到刷怪矩形", 刷怪区域全局名, "跳过初始化");
    return;
  }

  const 临时组 = CreateGroup();
  GroupEnumUnitsInRect(临时组, 刷怪区域, null);
  forEachUnitInGroup(临时组, 处理刷怪区域枚举单位);
  DestroyGroup(临时组);
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
  const timer = GetExpiredTimer();
  if (timer == null || timer === 0) return;

  const timerId = GetHandleId(timer);
  const ctx = 延迟刷新上下文表.get(timerId);
  延迟刷新上下文表.delete(timerId);
  safeDestroyTimer(timer);

  if (ctx == null) return;

  const owner = Player(ctx.所有者玩家ID);
  const 新单位 = 创建单位并登记排泄安全(owner, ctx.单位类型ID, ctx.出生X, ctx.出生Y, GetRandomDirectionDeg());
  if (新单位 == null || 新单位 === 0) {
    debugLog(怪物刷新模块名, "刷新怪物失败", "typeId=", ctx.单位类型ID, "x=", ctx.出生X, "y=", ctx.出生Y);
    return;
  }

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
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;

  const timerId = GetHandleId(timer);
  延迟刷新上下文表.set(timerId, {
    死亡单位: dyingUnit,
    单位类型ID: record.单位类型ID,
    所有者玩家ID: record.所有者玩家ID,
    出生X: record.出生X,
    出生Y: record.出生Y,
    属性快照: 快照死亡怪物属性(dyingUnit),
  });
  safeTimerStart(timer, 刷怪延迟秒, false, on怪物刷新计时器到期);
}

function on刷怪单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const 刷怪单位组 = 获取刷怪单位组();
  if (!IsUnitInGroup(dyingUnit, 刷怪单位组)) return;

  const record = 刷怪记录表.get(GetHandleId(dyingUnit));
  if (record != null) {
    安排怪物延迟刷新(dyingUnit, record);
    return;
  }

  const owner = GetOwningPlayer(dyingUnit);
  if (owner == null || owner === 0) return;
  安排怪物延迟刷新(dyingUnit, {
    单位类型ID: GetUnitTypeId(dyingUnit),
    所有者玩家ID: GetPlayerId(owner),
    出生X: GetUnitX(dyingUnit),
    出生Y: GetUnitY(dyingUnit),
  });
}

export function 初始化怪物刷新系统(this: void): void {
  if (已初始化怪物刷新系统) return;
  已初始化怪物刷新系统 = true;
  收集初始刷怪单位();
  registerDeathListener(on刷怪单位死亡);
}

export function 获取刷怪单位组引用(this: void): any {
  return 获取刷怪单位组();
}

export function 是刷怪单位(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return IsUnitInGroup(unit, 获取刷怪单位组()) === true;
}

初始化怪物刷新系统();

export {};
