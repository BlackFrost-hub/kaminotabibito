/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataSet, YDUserDataClear } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataSet: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClear: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
};
const { getObjectPropertyInteger, ObjectType } = require("lib.扩展函数.YDWE函数.index") as {
  getObjectPropertyInteger: (this: void, objectType: number, objectId: number | string, property: string) => number;
  ObjectType: { ABILITY: number };
};

const CreateTimer = jass.CreateTimer as () => any;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, callback: (this: void) => void) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UnitHasItemOfTypeBJ = jass.UnitHasItemOfTypeBJ as (whichUnit: any, itemTypeId: number) => boolean;

import { 巨魔大剑物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 巨魔大剑配置 } from "../03．主动技能/02．施法触发/00．施法触发配置";

const 巨魔大剑计时器表: Record<number, any> = {};

function 单位持有巨魔大剑(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (巨魔大剑物品ID <= 0) return false;
  return UnitHasItemOfTypeBJ(单位, 巨魔大剑物品ID) === true;
}

function 巨魔大剑条件成立(this: void, 施法单位: any, 技能ID: number): boolean {
  if (!IsUnitType(施法单位, UNIT_TYPE_HERO)) return false;
  if (!单位持有巨魔大剑(施法单位)) return false;
  const DataB1 = getObjectPropertyInteger(ObjectType.ABILITY, 技能ID, "DataB1");
  return DataB1 === 1 || DataB1 === 3;
}

function on巨魔大剑标记结束(this: void): void {
  const 计时器 = GetExpiredTimer();
  if (计时器 == null || 计时器 === 0) return;

  const 计时器ID = GetHandleId(计时器);
  const 单位 = 巨魔大剑计时器表[计时器ID];
  delete 巨魔大剑计时器表[计时器ID];
  DestroyTimer(计时器);

  if (单位 == null || 单位 === 0) return;
  YDUserDataSet("unit", 单位, 巨魔大剑配置.标记名, "boolean", false);
  YDUserDataClear("unit", 单位, 巨魔大剑配置.标记名, "boolean");
}

export function 处理巨魔大剑施法(this: void, 施法单位: any, 技能ID: number): void {
  if (!巨魔大剑条件成立(施法单位, 技能ID)) return;

  YDUserDataSet("unit", 施法单位, 巨魔大剑配置.标记名, "boolean", true);

  const 计时器 = CreateTimer();
  const 计时器ID = GetHandleId(计时器);
  巨魔大剑计时器表[计时器ID] = 施法单位;
  TimerStart(计时器, 巨魔大剑配置.持续时间, false, on巨魔大剑标记结束);
}

export {};
