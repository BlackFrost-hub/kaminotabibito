/** @noSelfInFile */
/**
 * 召唤物系统 - 核心创建与属性应用
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const japi = require("jass.japi") as any;
const 共享 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享") as {
  CreateUnit: (this: void, owner: any, unitTypeId: number, x: number, y: number, face: number) => any;
  GetHandleId: (this: void, h: any) => number;
  GetOwningPlayer: (this: void, unit: any) => any;
  RemoveUnit: (this: void, unit: any) => void;
  SetUnitFacing: (this: void, unit: any, facing: number) => void;
  SetUnitFlyHeight: (this: void, unit: any, height: number, rate: number) => void;
  SetUnitScale: (this: void, unit: any, x: number, y: number, z: number) => void;
  UnitAddAbility: (this: void, unit: any, abilityId: number) => boolean;
  UnitRemoveAbility: (this: void, unit: any, abilityId: number) => boolean;
  DzSetUnitModel?: (this: void, unit: any, model: string) => void;
  UNIT_STATE_LIFE: any;
};

const { YDUserDataSet } = require("lib.扩展函数.YDWE函数.01．YDUserData兼容") as {
  YDUserDataSet: (tableTypeName: string, tableKey: any, attr: string, valueTypeName: string, value: any) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import type { 规范化召唤物参数 } from "./01．类型";

const KillUnit = jass.KillUnit as (unit: any) => void;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitVertexColor = jass.SetUnitVertexColor as (unit: any, red: number, green: number, blue: number, alpha: number) => void;
const ConvertUnitState = jass.ConvertUnitState as (i: number) => any;

const CreateUnit = 共享.CreateUnit;
const GetHandleId = 共享.GetHandleId;
const GetOwningPlayer = 共享.GetOwningPlayer;
const RemoveUnit = 共享.RemoveUnit;
const SetUnitFacing = 共享.SetUnitFacing;
const SetUnitFlyHeight = 共享.SetUnitFlyHeight;
const SetUnitScale = 共享.SetUnitScale;
const UnitAddAbility = 共享.UnitAddAbility;
const UnitRemoveAbility = 共享.UnitRemoveAbility;
const DzSetUnitModel = 共享.DzSetUnitModel ?? (japi.DzSetUnitModel as ((unit: any, model: string) => void) | undefined);

const UNIT_STATE_LIFE = 共享.UNIT_STATE_LIFE;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const AMRF = 0x416d7266;
const ATTACK_POWER_STATE = 0x12;
const ARMOR_STATE = 0x20;
const ATTACK_INTERVAL_STATE = 0x25;
const DEFAULT_FLY_HEIGHT = 50.0;
const 死亡后删除延迟 = 2.0;
const 模块名 = "召唤物核心";
const 限时召唤物死亡清理表: Record<number, true | undefined> = {};
const 限时召唤物到期击杀表: Record<number, any | undefined> = {};
const 限时召唤物延迟删除表: Record<number, any | undefined> = {};
let 已注册召唤物死亡清理 = false;

function 设置最后创建单位(this: void, unit: any): void {
  (globalThis as any).bj_lastCreatedUnit = unit;
  (jglobals as any).bj_lastCreatedUnit = unit;
}

function 读取小怪生命倍率(this: void): number {
  const hp2 = (jglobals as any).udg_HP2;
  if (typeof hp2 === "number" && hp2 > 0) return hp2;
  return 1;
}

function 赋予飞行高度能力(this: void, unit: any): void {
  UnitAddAbility(unit, AMRF);
  UnitRemoveAbility(unit, AMRF);
}

function 设置单位飞行高度(this: void, unit: any, height: number): void {
  赋予飞行高度能力(unit);
  SetUnitFlyHeight(unit, height, 0.0);
}

function 执行召唤物到期击杀(this: void, callbackId: number): void {
  const unit = 限时召唤物到期击杀表[callbackId];
  限时召唤物到期击杀表[callbackId] = undefined;
  if (unit != null && unit !== 0) {
    KillUnit(unit);
  }
}

function 执行召唤物延迟删除(this: void, callbackId: number): void {
  const unit = 限时召唤物延迟删除表[callbackId];
  限时召唤物延迟删除表[callbackId] = undefined;
  if (unit != null && unit !== 0) {
    RemoveUnit(unit);
  }
}

function 安排召唤物死亡后删除(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  let callbackId = 0;
  callbackId = addDelayedCallback(死亡后删除延迟 * 1000, () => 执行召唤物延迟删除(callbackId));
  限时召唤物延迟删除表[callbackId] = unit;
}

function on召唤物死亡清理(this: void, 死亡单位: any, _击杀者: any): void {
  if (死亡单位 == null || 死亡单位 === 0) return;
  const hid = GetHandleId(死亡单位);
  if (限时召唤物死亡清理表[hid] == null) return;
  限时召唤物死亡清理表[hid] = undefined;
  安排召唤物死亡后删除(死亡单位);
}

function 确保召唤物死亡清理监听(this: void): void {
  if (已注册召唤物死亡清理) return;
  已注册召唤物死亡清理 = true;
  registerDeathListener(on召唤物死亡清理);
}

function 应用召唤物限时生命(this: void, unit: any, duration: number): void {
  if (unit == null || unit === 0) return;
  if (!(duration > 0)) return;
  确保召唤物死亡清理监听();
  限时召唤物死亡清理表[GetHandleId(unit)] = true;
  let callbackId = 0;
  callbackId = addDelayedCallback(duration * 1000, () => 执行召唤物到期击杀(callbackId));
  限时召唤物到期击杀表[callbackId] = unit;
}

function 应用单位颜色(this: void, unit: any, 参数: 规范化召唤物参数): void {
  const alpha = 参数.透明度;
  const red = 参数.红;
  const green = 参数.绿;
  const blue = 参数.蓝;
  if (alpha == null && red == null && green == null && blue == null) return;

  SetUnitVertexColor(unit, red ?? 255, green ?? 255, blue ?? 255, alpha ?? 255);
}

function 应用召唤物属性(this: void, unit: any, 参数: 规范化召唤物参数): void {
  if (参数.朝向 != null) {
    SetUnitFacing(unit, 参数.朝向);
  }

  if (参数.飞行高度 != null) {
    设置单位飞行高度(unit, 参数.飞行高度);
  }

  应用单位颜色(unit, 参数);

  if (参数.模型文件 != null && 参数.模型文件 !== "" && DzSetUnitModel != null) {
    DzSetUnitModel(unit, 参数.模型文件);
  }

  if (参数.主人单位 != null && 参数.主人单位 !== 0) {
    YDUserDataSet("unit", unit, "Master", "unit", 参数.主人单位);
  }

  if (参数.生命值 != null && 参数.生命值 > 0) {
    const scaledHp = 参数.生命值 * 读取小怪生命倍率();
    SetUnitState(unit, UNIT_STATE_MAX_LIFE, scaledHp);
    SetUnitState(unit, UNIT_STATE_LIFE, scaledHp);
  }

  if (参数.生命恢复 != null) {
    YDUserDataSet("unit", unit, "生命恢复", "real", 参数.生命恢复);
  }

  if (参数.攻击力 != null && 参数.攻击力 > 0) {
    SetUnitState(unit, ConvertUnitState(ATTACK_POWER_STATE), 参数.攻击力);
  }

  if (参数.攻击间隔 != null && 参数.攻击间隔 > 0) {
    SetUnitState(unit, ConvertUnitState(ATTACK_INTERVAL_STATE), 参数.攻击间隔);
  }

  if (参数.护甲 != null) {
    SetUnitState(unit, ConvertUnitState(ARMOR_STATE), 参数.护甲);
  }

  if (参数.缩放 != null && 参数.缩放 > 0) {
    SetUnitScale(unit, 参数.缩放, 参数.缩放, 参数.缩放);
  }
}

export function 创建召唤物核心(this: void, 参数: 规范化召唤物参数): any {
  let summon = 参数.召唤物单位;
  let created = false;
  debugLogForce(
    模块名,
    "进入创建",
    "summon=", summon,
    "owner=", 参数.所属玩家,
    "master=", 参数.主人单位,
    "unitType=", 参数.单位类型,
    "x=", 参数.X,
    "y=", 参数.Y,
    "facing=", 参数.朝向,
  );

  if (summon == null || summon === 0) {
    const owner = 参数.所属玩家 ?? ((参数.主人单位 != null && 参数.主人单位 !== 0) ? GetOwningPlayer(参数.主人单位) : null);
    if (owner == null || owner === 0) {
      debugLogForce(模块名, "创建失败：owner 无效", owner);
      return null;
    }
    if (参数.单位类型 == null || 参数.单位类型 === 0) {
      debugLogForce(模块名, "创建失败：unitType 无效", 参数.单位类型);
      return null;
    }

    summon = CreateUnit(owner, 参数.单位类型, 参数.X, 参数.Y, 参数.朝向 ?? 0.0);
    if (summon == null || summon === 0) {
      debugLogForce(模块名, "CreateUnit 返回空", "owner=", owner, "unitType=", 参数.单位类型);
      return null;
    }

    created = true;
    设置最后创建单位(summon);
    设置单位飞行高度(summon, 参数.飞行高度 ?? DEFAULT_FLY_HEIGHT);
    debugLogForce(模块名, "CreateUnit 成功", "summon=", summon);
  }

  应用召唤物属性(summon, 参数);

  if (参数.持续时间 != null && 参数.持续时间 > 0) {
    应用召唤物限时生命(summon, 参数.持续时间);
  }

  debugLogForce(模块名, "返回 summon=", summon, "created=", created);
  return summon;
}
