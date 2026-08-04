/** @noSelfInFile */

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 按名字反查Boss单位ID } = require("系统.01．单位系统.08．单位配置表.02．Boss配置表") as {
  按名字反查Boss单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { TriggerRegisterUnitInRangeSimple } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterUnitInRangeSimple: (this: void, trig: any, range: number, whichUnit: any) => any;
};
const { 添加单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 登记Boss战待带入护卫 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.06．Boss战护卫") as {
  登记Boss战待带入护卫: (this: void, boss: any, guard: any, 护卫类型: string) => boolean;
};
const { 注册剧情运行时单位 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位") as {
  注册剧情运行时单位: (this: void, 语义名: string, unit: any) => void;
};

import { 写入当前剧情动作上下文 } from "./01．剧情动作上下文";
import { 读取剧情进度 } from "./01．剧情动作上下文";
import { 发布主线Boss战前提示 } from "./12．剧情Boss战预警";

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const GetTriggeringTrigger = jass.GetTriggeringTrigger as (this: void) => any;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, whichPlayer: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, whichUnit: any) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, whichUnit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, whichUnit: any, whichType: any) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;
const CreateGroup = jass.CreateGroup as (this: void) => any;
const DestroyGroup = jass.DestroyGroup as (this: void, whichGroup: any) => void;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (this: void, whichGroup: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, whichGroup: any, whichUnit: any) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const StopMusic = jass.StopMusic as (this: void, fadeOut: boolean) => void;
const TriggerAddAction = jass.TriggerAddAction as (this: void, trig: any, action: (this: void) => void) => any;
const DestroyTrigger = jass.DestroyTrigger as (this: void, whichTrigger: any) => void;

interface 剧情Boss范围预置触发配置 {
  配置名: string;
  剧情片段ID?: string;
  Boss键?: string;
  需要剧情进度?: number;
}

export const 剧情Boss预置暂停来源 = "剧情系统:Boss预置";

interface 剧情Boss预置参数 {
  Boss键?: string;
  Boss名: string;
  X: number;
  Y: number;
  朝向?: number;
  注册范围?: number;
  预创建后暂停?: boolean;
  预创建后无敌?: boolean;
  范围触发配置名?: string;
  范围触发剧情片段ID?: string;
  需要剧情进度?: number;
}

export interface 剧情Boss预置随从参数 {
  单位名: string;
  X: number;
  Y: number;
  朝向?: number;
  预创建后暂停?: boolean;
  预创建后无敌?: boolean;
}

const 范围预置触发配置表: Record<number, 剧情Boss范围预置触发配置> = {};
const 剧情Boss预置随从表: Record<number, any[] | undefined> = {};
const 剧情Boss战带入随从表: Record<number, any[] | undefined> = {};

const 剧情Boss预置随从搜索半径 = 120;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

/**
 * 地图 JASS 已经摆放的战前随从优先复用；同一坐标的错误类型或重复单位会被清理。
 * 这样可以把旧地图预置和剧情配置的单位顺序统一起来。
 */
function 获取或清理附近预置随从(this: void, unitTypeId: number, x: number, y: number): any {
  const group = CreateGroup();
  if (group == null || group === 0) return null;

  GroupEnumUnitsInRange(group, x, y, 剧情Boss预置随从搜索半径, null);
  let result: any = null;
  while (true) {
    const candidate = FirstOfGroup(group);
    if (candidate == null || candidate === 0) break;
    GroupRemoveUnit(group, candidate);

    const owner = GetOwningPlayer(candidate);
    const dx = GetUnitX(candidate) - x;
    const dy = GetUnitY(candidate) - y;
    const isStaticNeutralHostile = GetPlayerId(owner) === 15 && dx * dx + dy * dy <= 剧情Boss预置随从搜索半径 * 剧情Boss预置随从搜索半径;
    if (!isStaticNeutralHostile || !单位存活(candidate)) continue;

    if (result == null && GetUnitTypeId(candidate) === unitTypeId) {
      result = candidate;
    } else {
      立即移除单位并取消排泄登记(candidate);
    }
  }
  DestroyGroup(group);
  return result;
}

function 解析Boss表键(this: void, boss键: string | undefined): { 表名: string; 键名: string } {
  if (boss键 == null || boss键 === "") return { 表名: "Boss", 键名: "" };
  const splitIndex = boss键.indexOf(".");
  if (splitIndex < 0) return { 表名: "Boss", 键名: boss键 };
  return {
    表名: boss键.substring(0, splitIndex),
    键名: boss键.substring(splitIndex + 1),
  };
}

function on剧情Boss范围预置触发(this: void): void {
  const trigger = GetTriggeringTrigger();
  if (trigger == null || trigger === 0) return;

  const 配置 = 范围预置触发配置表[GetHandleId(trigger)];
  if (配置 == null) return;
  if (配置.需要剧情进度 != null && 读取剧情进度() !== 配置.需要剧情进度) return;

  // Boss 前导只允许成功消费一次；否则玩家进出范围会永久保留一个无效触发器。
  delete 范围预置触发配置表[GetHandleId(trigger)];
  DestroyTrigger(trigger);

  写入当前剧情动作上下文({
    片段ID: 配置.剧情片段ID,
    触发配置名: 配置.配置名,
    触发单位: GetTriggerUnit(),
  });
  if (配置.剧情片段ID != null && 配置.剧情片段ID !== "") {
    const { 播放主线剧情片段 } = require("../02．剧情步骤/02．剧情步骤播放器") as {
      播放主线剧情片段: (this: void, 片段ID: string) => boolean;
    };
    播放主线剧情片段(配置.剧情片段ID);
  }
}

export function 注册剧情Boss范围预置触发器(
  this: void,
  bossUnit: any,
  注册范围: number,
  配置名: string,
  剧情片段ID?: string,
  Boss键?: string,
  需要剧情进度?: number,
): any {
  if (bossUnit == null || bossUnit === 0) return null;
  if (!(注册范围 > 0)) return null;

  const trigger = CreateTrigger();
  TriggerAddAction(trigger, on剧情Boss范围预置触发);
  TriggerRegisterUnitInRangeSimple(trigger, 注册范围, bossUnit);
  范围预置触发配置表[GetHandleId(trigger)] = {
    配置名,
    剧情片段ID,
    Boss键,
    需要剧情进度,
  };
  return trigger;
}

export function 清理剧情Boss预置随从(this: void, bossUnit: any): void {
  if (bossUnit == null || bossUnit === 0) return;

  const handleId = GetHandleId(bossUnit);
  const 随从列表 = 剧情Boss预置随从表[handleId] ?? 剧情Boss战带入随从表[handleId];
  delete 剧情Boss预置随从表[handleId];
  delete 剧情Boss战带入随从表[handleId];
  if (随从列表 == null) return;

  for (let i = 0; i < 随从列表.length; i++) {
    const unit = 随从列表[i];
    if (unit != null && unit !== 0) {
      移除单位暂停(unit, 剧情Boss预置暂停来源);
      立即移除单位并取消排泄登记(unit);
    }
  }
}

export function 创建并登记剧情Boss预置随从(
  this: void,
  bossUnit: any,
  参数列表: readonly 剧情Boss预置随从参数[],
): any[] {
  if (bossUnit == null || bossUnit === 0 || 参数列表.length <= 0) return [];

  清理剧情Boss预置随从(bossUnit);
  const handleId = GetHandleId(bossUnit);
  const 随从列表: any[] = [];

  for (let i = 0; i < 参数列表.length; i++) {
    const 参数 = 参数列表[i];
    const rawId = 按名字反查总单位ID(参数.单位名);
    const unitTypeId = stringToFourCCSafe(rawId);
    if (!(unitTypeId > 0)) continue;

    const unit = 获取或清理附近预置随从(unitTypeId, 参数.X, 参数.Y)
      ?? 创建单位并登记排泄安全(Player(15), unitTypeId, 参数.X, 参数.Y, 参数.朝向 ?? 0);
    if (unit == null || unit === 0) continue;

    SetUnitFacing(unit, 参数.朝向 ?? 0);
    if (参数.预创建后暂停 === true) 添加单位暂停(unit, 剧情Boss预置暂停来源);
    if (参数.预创建后无敌 === true) SetUnitInvulnerable(unit, true);
    随从列表.push(unit);
  }

  if (随从列表.length > 0) 剧情Boss预置随从表[handleId] = 随从列表;
  return 随从列表;
}

/** 将战前静态随从交给 Boss 战护卫系统，战斗结束由护卫系统统一清理。 */
export function 释放并登记剧情Boss预置随从(this: void, bossUnit: any): any[] {
  if (bossUnit == null || bossUnit === 0) return [];

  const bossHandleId = GetHandleId(bossUnit);
  const 随从列表 = 剧情Boss预置随从表[bossHandleId];
  delete 剧情Boss预置随从表[bossHandleId];
  if (随从列表 == null) return [];

  const 带入列表: any[] = [];
  for (let i = 0; i < 随从列表.length; i++) {
    const unit = 随从列表[i];
    if (!单位存活(unit)) continue;
    移除单位暂停(unit, 剧情Boss预置暂停来源);
    SetUnitInvulnerable(unit, false);
    if (登记Boss战待带入护卫(bossUnit, unit, "剧情Boss预置随从")) 带入列表.push(unit);
  }
  if (带入列表.length > 0) 剧情Boss战带入随从表[bossHandleId] = 带入列表;
  return 带入列表;
}

/** 树魔首领随从特性消费带入单位，避免初始化时重复补出同类型单位。 */
export function 消费剧情Boss战带入随从(this: void, bossUnit: any): any[] {
  if (bossUnit == null || bossUnit === 0) return [];
  const bossHandleId = GetHandleId(bossUnit);
  const 随从列表 = 剧情Boss战带入随从表[bossHandleId] ?? [];
  delete 剧情Boss战带入随从表[bossHandleId];
  return 随从列表;
}

export function 创建并冻结剧情Boss预置(this: void, 参数: 剧情Boss预置参数): any {
  const 键信息 = 解析Boss表键(参数.Boss键);
  if (键信息.键名 !== "") {
    const 已有Boss = YDUserDataGetSafe("string", 键信息.表名, 键信息.键名, "unit");
    if (已有Boss != null && 已有Boss !== 0 && 单位存活(已有Boss)) {
      注册剧情运行时单位(`${键信息.表名}.${键信息.键名}`, 已有Boss);
      if (参数.预创建后暂停 === true) 添加单位暂停(已有Boss, 剧情Boss预置暂停来源);
      if (参数.预创建后无敌 === true) SetUnitInvulnerable(已有Boss, true);
      return 已有Boss;
    }
  }

  const rawId = 按名字反查Boss单位ID(参数.Boss名);
  const unitTypeId = stringToFourCCSafe(rawId);
  if (!(unitTypeId > 0)) return null;

  StopMusic(false);

  const bossUnit = 创建单位并登记排泄安全(Player(15), unitTypeId, 参数.X, 参数.Y, 参数.朝向 ?? 0);
  if (bossUnit == null || bossUnit === 0) return null;

  if (键信息.键名 !== "") {
    注册剧情运行时单位(`${键信息.表名}.${键信息.键名}`, bossUnit);
  }
  发布主线Boss战前提示(bossUnit);

  if (参数.预创建后暂停 === true) {
    添加单位暂停(bossUnit, 剧情Boss预置暂停来源);
  }
  if (参数.预创建后无敌 === true) {
    SetUnitInvulnerable(bossUnit, true);
  }

  if (键信息.键名 !== "") {
    YDUserDataSetSafe("string", 键信息.表名, 键信息.键名, "unit", bossUnit);
  }

  if ((参数.注册范围 ?? 0) > 0) {
    注册剧情Boss范围预置触发器(
      bossUnit,
      参数.注册范围 ?? 0,
      参数.范围触发配置名 ?? `${参数.Boss名}范围预置触发`,
      参数.范围触发剧情片段ID,
      参数.Boss键,
      参数.需要剧情进度,
    );
  }

  return bossUnit;
}
