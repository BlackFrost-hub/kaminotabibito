/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 申请单位暂停独立占用, 释放单位暂停来源全部 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  申请单位暂停独立占用: (this: void, unit: any, 来源: string) => boolean;
  释放单位暂停来源全部: (this: void, unit: any, 来源: string) => boolean;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const IsUnitInvulnerable = jass.IsUnitInvulnerable as (this: void, unit: any) => boolean;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;

interface 无敌占用记录 {
  单位: any;
  原始无敌: boolean;
  来源列表: string[];
}

const 无敌占用记录表: Record<number, 无敌占用记录 | undefined> = {};

function 读取句柄ID(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

function 查找来源(this: void, 来源列表: string[], 来源: string): number {
  for (let i = 0; i < 来源列表.length; i++) {
    if (来源列表[i] === 来源) return i;
  }
  return -1;
}

/**
 * 统一维护剧情单位的待战状态。
 * 暂停使用来源计数，解除时只释放本次来源，避免破坏其他系统的暂停占用。
 */
export function 暂停并设置无敌安全(this: void, unit: any, 来源: string): boolean {
  if (unit == null || unit === 0 || 来源 == null || 来源 === "") return false;
  const 单位ID = 读取句柄ID(unit);
  if (单位ID === 0) return false;

  let 记录 = 无敌占用记录表[单位ID];
  if (记录 == null) {
    记录 = {
      单位: unit,
      原始无敌: IsUnitInvulnerable(unit),
      来源列表: [],
    };
    无敌占用记录表[单位ID] = 记录;
  }

  if (查找来源(记录.来源列表, 来源) < 0) 记录.来源列表.push(来源);
  const 已暂停 = 申请单位暂停独立占用(unit, 来源);
  SetUnitInvulnerable(unit, true);
  return 已暂停;
}

/** 解除由暂停并设置无敌安全建立的剧情待战状态。 */
export function 解除暂停并取消无敌安全(this: void, unit: any, 来源: string): boolean {
  if (unit == null || unit === 0 || 来源 == null || 来源 === "") return false;
  const 单位ID = 读取句柄ID(unit);
  if (单位ID === 0) return false;

  const 记录 = 无敌占用记录表[单位ID];
  if (记录 == null || 查找来源(记录.来源列表, 来源) < 0) return false;

  const 已解除暂停 = 释放单位暂停来源全部(unit, 来源);
  const 来源索引 = 查找来源(记录.来源列表, 来源);
  if (来源索引 >= 0) 记录.来源列表.splice(来源索引, 1);

  if (记录.来源列表.length === 0) {
    SetUnitInvulnerable(unit, 记录.原始无敌);
    delete 无敌占用记录表[单位ID];
  } else {
    SetUnitInvulnerable(unit, true);
  }
  return 已解除暂停;
}

export {};
