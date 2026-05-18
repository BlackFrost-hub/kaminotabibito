/** @noSelfInFile */


const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};

const jass = require("jass.common") as any;
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};
const { YDUserDataSetSafe, YDUserDataClearSafe, getObjectPropertyIntegerSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
  getObjectPropertyIntegerSafe: (this: void, objectType: number, objectId: number | string, property: string) => number;
};
const { ObjectType } = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  ObjectType: { ABILITY: number };
};

const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
import { 巨魔大剑物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 巨魔大剑配置 } from "../03．主动技能/02．施法触发/00．施法触发配置";

function 单位持有巨魔大剑(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (巨魔大剑物品ID <= 0) return false;
  return UnitHasItemOfTypeBJ(单位, 巨魔大剑物品ID) === true;
}

function 巨魔大剑条件成立(this: void, 施法单位: any, 技能ID: number): boolean {
  if (!IsUnitType(施法单位, UNIT_TYPE_HERO)) return false;
  if (!单位持有巨魔大剑(施法单位)) return false;
  const DataB1 = getObjectPropertyIntegerSafe(ObjectType.ABILITY, 技能ID, "DataB1");
  return DataB1 === 1 || DataB1 === 3;
}

export function 处理巨魔大剑施法(this: void, 施法单位: any, 技能ID: number): void {
  debugLogForce("10．巨魔大剑", "进入", "处理巨魔大剑施法");

  if (!巨魔大剑条件成立(施法单位, 技能ID)) return;

  YDUserDataSetSafe("unit", 施法单位, 巨魔大剑配置.标记名, "boolean", true);

  addDelayedCallback(巨魔大剑配置.持续时间 * 1000, function (this: void): void {
    YDUserDataSetSafe("unit", 施法单位, 巨魔大剑配置.标记名, "boolean", false);
    YDUserDataClearSafe("unit", 施法单位, 巨魔大剑配置.标记名, "boolean");
  });
}

export {};
