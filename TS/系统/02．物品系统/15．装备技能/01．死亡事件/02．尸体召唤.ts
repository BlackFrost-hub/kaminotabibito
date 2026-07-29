/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const itemJudgeFns = require("lib.扩展函数.物品相关函数.index") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};

const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};

const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string | undefined | null) => number;
};

const { 创建召唤物 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口") as {
  创建召唤物: (this: void, 参数: any) => any;
};

import { 获取死亡事件配置, 取物品四字码 } from "./01．死亡事件配置表";
import type { 死亡事件上下文 } from "./00．类型定义";

const 最大生命状态 = jass.UNIT_STATE_MAX_LIFE as number;
const 机械单位类型 = jass.UNIT_TYPE_MECHANICAL as number;
const 远古单位类型 = jass.UNIT_TYPE_ANCIENT as number;
const 当前生命状态 = jass.UNIT_STATE_LIFE as number;
const 死亡单位类型 = jass.UNIT_TYPE_DEAD as number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (whichUnit: any, whichPlayer: any) => boolean;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichState: any) => number;

function 是否符合持盾召唤条件(this: void, 单位: any, 上下文: 死亡事件上下文, 物品四字码: number): boolean {
  if (单位 == null || 单位 === 0) return false;
  if (IsUnitType(单位, 死亡单位类型)) return false;
  if (GetUnitState(单位, 当前生命状态) <= 0.405) return false;
  if (IsUnitType(单位, 机械单位类型)) return false;
  if (IsUnitType(单位, 远古单位类型)) return false;
  if (!IsUnitEnemy(单位, 上下文.死亡单位所有者)) return false;
  return itemJudgeFns.UnitHasItemOfTypeBJ(单位, 物品四字码);
}

function 计算召唤生命值(this: void, 持有者: any, 基础值: number, 系数: number): number {
  return 基础值 + (GetUnitStateJapi(持有者, 最大生命状态) as number) * 系数;
}

function 计算召唤攻击力(this: void, 持有者: any, 基础值: number, 攻击状态: number, 系数: number): number {
  return 基础值 + (jass.GetUnitState(持有者, jass.ConvertUnitState(攻击状态)) as number) * 系数;
}

function 创建尸体召唤物(this: void, 持有者: any, 上下文: 死亡事件上下文): void {
  const 配置 = 获取死亡事件配置().尸体召唤;
  const 召唤生命值 = 计算召唤生命值(持有者, 配置.额外生命值, 配置.生命值系数);
  const 召唤攻击力 = 计算召唤攻击力(持有者, 配置.额外攻击力, 配置.攻击力状态, 配置.攻击力系数);
  const 召唤物 = 创建召唤物({
    主人单位: 持有者,
    单位类型: 配置.召唤单位类型,
    X: 上下文.死亡坐标X,
    Y: 上下文.死亡坐标Y,
    持续时间: 配置.持续时间,
    生命值: 召唤生命值,
    攻击力: 召唤攻击力,
  });
  if (召唤物 == null || 召唤物 === 0) return;

  jass.UnitApplyTimedLife(召唤物, stringToFourCC(配置.限时生命Buff), 配置.持续时间);
  jass.SetUnitState(召唤物, 当前生命状态, GetUnitStateJapi(召唤物, 最大生命状态) as number);
  createTimedEffect(配置.特效路径, 上下文.死亡坐标X, 上下文.死亡坐标Y, 0, 配置.特效持续时间);
}

export function 处理尸体召唤(this: void, 上下文: 死亡事件上下文): void {
  const 配置 = 获取死亡事件配置().尸体召唤;
  const 物品四字码 = 取物品四字码(配置.装备ID);
  if (!(物品四字码 > 0)) return;

  const 范围单位组 = getUnitsInRange(上下文.死亡坐标X, 上下文.死亡坐标Y, 配置.搜索半径);
  for (const 单位 of 范围单位组) {
    if (!是否符合持盾召唤条件(单位, 上下文, 物品四字码)) continue;
    创建尸体召唤物(单位, 上下文);
  }
}
