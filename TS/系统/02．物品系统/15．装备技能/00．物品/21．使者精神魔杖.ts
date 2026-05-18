/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGet, YDUserDataSet, YDUserDataHas, YDUserDataClear } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataHas: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => boolean;
  YDUserDataClear: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitRace = jass.IsUnitRace as (unit: any, race: any) => boolean;
const IsHeroUnitId = jass.IsHeroUnitId as (unitId: number) => boolean;
const KillUnit = jass.KillUnit as (unit: any) => void;
const CreateUnit = jass.CreateUnit as (player: any, unitId: number, x: number, y: number, facing: number) => any;
const UnitApplyTimedLife = jass.UnitApplyTimedLife as (unit: any, buffId: number, duration: number) => void;
const CreateTimer = jass.CreateTimer as () => any;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, callback: (this: void) => void) => void;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const RACE_DEMON = jass.RACE_DEMON as any;

import type { 物品技能事件上下文 } from "../03．主动技能/03．物品使用触发/01．物品使用触发常量";
import { 使者精神魔杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 使者精神魔杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";

const 清理表: Record<number, any | undefined> = {};
const 限时生命BuffID = stringToFourCCSafe("BHwe");

function 是否为使者精神魔杖(this: void, 物品: any): boolean {
  if (物品 == null || 物品 === 0) return false;
  return GetItemTypeId(物品) === 使者精神魔杖物品ID;
}

function 目标可存储(this: void, 目标单位: any): boolean {
  if (目标单位 == null || 目标单位 === 0) return false;
  if (IsUnitRace(目标单位, RACE_DEMON)) return false;
  return !IsHeroUnitId(GetUnitTypeId(目标单位));
}

function on使者精神魔杖存储过期(this: void): void {
  const timer = GetExpiredTimer();
  const timerID = GetHandleId(timer);
  const 施法单位 = 清理表[timerID];
  delete 清理表[timerID];
  if (施法单位 != null && 施法单位 !== 0) {
    YDUserDataClear("unit", 施法单位, 使者精神魔杖配置.存储字段, "unitcode");
  }
  DestroyTimer(timer);
}

function 启动存储过期计时(this: void, 施法单位: any): void {
  const timer = CreateTimer();
  if (timer == null || timer === 0) return;
  清理表[GetHandleId(timer)] = 施法单位;
  TimerStart(timer, 使者精神魔杖配置.存储持续时间, false, on使者精神魔杖存储过期);
}

export function 处理使者精神魔杖使用(this: void, 上下文: 物品技能事件上下文): void {
  if (!是否为使者精神魔杖(上下文.物品)) return;
  const 施法单位 = 上下文.施法单位;
  if (施法单位 == null || 施法单位 === 0) return;

  const 已存储 = YDUserDataHas("unit", 施法单位, 使者精神魔杖配置.存储字段, "unitcode");
  const 目标单位 = 上下文.目标单位;
  if (!已存储) {
    if (!目标可存储(目标单位)) return;
    KillUnit(目标单位);
    YDUserDataSet("unit", 施法单位, 使者精神魔杖配置.存储字段, "unitcode", GetUnitTypeId(目标单位));
    启动存储过期计时(施法单位);
    return;
  }

  const 存储单位类型 = YDUserDataGet("unit", 施法单位, 使者精神魔杖配置.存储字段, "unitcode");
  const x = 目标单位 == null || 目标单位 === 0 ? 上下文.目标X : GetUnitX(目标单位);
  const y = 目标单位 == null || 目标单位 === 0 ? 上下文.目标Y : GetUnitY(目标单位);
  const 召唤单位 = CreateUnit(GetOwningPlayer(施法单位), 存储单位类型, x, y, GetUnitFacing(施法单位));
  if (召唤单位 != null && 召唤单位 !== 0) {
    UnitApplyTimedLife(召唤单位, 限时生命BuffID, 使者精神魔杖配置.召唤持续时间);
  }
}

export {};
