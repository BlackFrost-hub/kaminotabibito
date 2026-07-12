/** @noSelfInFile */

import { 单位存活, 单位是英雄 } from "./12．物品与单位";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { UnitHasItemOfTypeBJ, GetItemOfTypeFromUnitBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
  GetItemOfTypeFromUnitBJ: (this: void, whichUnit: any, itemId: number) => any | null;
};
const { getUnitsInRange, getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { SFB_setBuff, SFB_setSlow } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  SFB_setBuff: (this: void, source: any, target: any, id: number, time: number) => void;
  SFB_setSlow: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, time: number) => void;
};
const { 清除单位负面Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  清除单位负面Buff: (this: void, unit: any, onlyPurgable?: boolean) => number;
};
const { 开始击退 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统") as {
  开始击退: (this: void, unit: any, params: any) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};

const GetItemTypeId = jass.GetItemTypeId as (whichItem: any) => number;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (whichUnit: any) => any;
const GetPlayerId = jass.GetPlayerId as (whichPlayer: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const SetUnitState = jass.SetUnitState as (whichUnit: any, whichUnitState: any, newVal: number) => void;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const IsUnitAlly = jass.IsUnitAlly as (whichUnit: any, whichPlayer: any) => boolean;
const GetHeroStr = jass.GetHeroStr as (whichHero: any, includeBonuses: boolean) => number;
const GetHeroAgi = jass.GetHeroAgi as (whichHero: any, includeBonuses: boolean) => number;
const GetHeroInt = jass.GetHeroInt as (whichHero: any, includeBonuses: boolean) => number;
const SetHeroInt = jass.SetHeroInt as (whichHero: any, value: number, permanent: boolean) => void;
const AddHeroXP = jass.AddHeroXP as (whichHero: any, xpToAdd: number, showEyeCandy: boolean) => void;
const IsPointBlighted = jass.IsPointBlighted as (x: number, y: number) => boolean;
const SetItemCharges = jass.SetItemCharges as (whichItem: any, charges: number) => void;
const GetItemCharges = jass.GetItemCharges as (whichItem: any) => number;
const UnitApplyTimedLife = jass.UnitApplyTimedLife as (whichUnit: any, buffId: number, duration: number) => void;
const SetUnitScale = jass.SetUnitScale as (whichUnit: any, scaleX: number, scaleY: number, scaleZ: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (whichUnit: any, flag: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (whichUnit: any, facingAngle: number) => void;
const IssueTargetOrder = jass.IssueTargetOrder as (whichUnit: any, order: string, targetWidget: any) => boolean;
const CreateGroup = jass.CreateGroup as () => any;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (whichGroup: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (whichGroup: any, whichUnit: any) => void;
const DestroyGroup = jass.DestroyGroup as (whichGroup: any) => void;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (whichUnit: any) => number;
const ConvertUnitState = jass.ConvertUnitState as (unitStateId: number) => any;
const SquareRoot = jass.SquareRoot as (x: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const bj_RADTODEG = jass.bj_RADTODEG as number;
const bj_DEGTORAD = jass.bj_DEGTORAD as number;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const GetUnitStateJapi = japi.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const DzSetUnitModel = japi.DzSetUnitModel as (whichUnit: any, model: string) => void;

const stringToFourCCSafe = (require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
}).stringToFourCCSafe;

const 火把单位类型ID = stringToFourCCSafe("e0FT");
const 限时生命BuffID = stringToFourCCSafe("BHwe");
const 属性浮点归零阈值 = 0.000001;

export function 临时调整攻击(this: void, 单位: any, 数值: number): void {
  SGSS_SetState(单位, 1, 数值);
}

export function 临时调整护甲(this: void, 单位: any, 数值: number): void {
  SGSS_SetState(单位, 2, 数值);
}

export function 临时调整攻速(this: void, 单位: any, 数值: number): void {
  SGSS_SetState(单位, 10, 数值);
}

export function 调整状态ID属性(this: void, 单位: any, 属性ID: number, 数值: number): void {
  SGSS_SetState(单位, 属性ID, 数值);
}

export function 调整玩家属性(this: void, 单位: any, 属性名: string, 增量: number): void {
  if (单位 == null || 单位 === 0) return;
  const owner = GetOwningPlayer(单位);
  const oldValue = Number(YDUserDataGetSafe("player", owner, 属性名, "real")) || 0;
  let newValue = oldValue + 增量;
  if (newValue < 属性浮点归零阈值 && newValue > -属性浮点归零阈值) newValue = 0;
  YDUserDataSetSafe("player", owner, 属性名, "real", newValue);
}

export function 调整单位属性(this: void, 单位: any, 属性名: string, 增量: number): void {
  if (单位 == null || 单位 === 0) return;
  const oldValue = Number(YDUserDataGetSafe("unit", 单位, 属性名, "real")) || 0;
  let newValue = oldValue + 增量;
  if (newValue < 属性浮点归零阈值 && newValue > -属性浮点归零阈值) newValue = 0;
  YDUserDataSetSafe("unit", 单位, 属性名, "real", newValue);
}

export function 读取玩家属性(this: void, 单位: any, 属性名: string): number {
  if (单位 == null || 单位 === 0) return 0;
  return Number(YDUserDataGetSafe("player", GetOwningPlayer(单位), 属性名, "real")) || 0;
}

export function 读取单位属性(this: void, 单位: any, 属性名: string): number {
  if (单位 == null || 单位 === 0) return 0;
  return Number(YDUserDataGetSafe("unit", 单位, 属性名, "real")) || 0;
}

export function 英雄主属性是智力(this: void, 英雄: any): boolean {
  if (!单位是英雄(英雄)) return false;
  const intValue = GetHeroInt(英雄, false);
  return intValue > GetHeroStr(英雄, false) && intValue > GetHeroAgi(英雄, false);
}

export function 增加英雄经验与智力(this: void, 英雄: any, 次数: number, 每次经验: number, 智力: number): void {
  for (let i = 0; i < 次数; i++) {
    AddHeroXP(英雄, 每次经验, true);
  }
  SetHeroInt(英雄, GetHeroInt(英雄, false) + 智力, true);
}

export function 击退远离来源(this: void, 来源: any, 目标: any, 距离: number, 持续时间: number): void {
  if (!单位存活(目标)) return;
  开始击退(目标, {
    来源单位: 来源,
    距离,
    持续时间,
    检查地形: true,
    暂停单位: false,
    禁用碰撞: true,
  });
}

export function 拉向来源(this: void, 来源: any, 目标: any, 距离: number, 持续时间: number): void {
  const tx = GetUnitX(目标);
  const ty = GetUnitY(目标);
  const sx = GetUnitX(来源);
  const sy = GetUnitY(来源);
  开始击退(目标, {
    来源X: tx * 2 - sx,
    来源Y: ty * 2 - sy,
    距离,
    持续时间,
    检查地形: true,
    暂停单位: false,
    禁用碰撞: true,
  });
}

export function 命令攻击来源(this: void, 目标: any, 来源: any): void {
  IssueTargetOrder(目标, "attack", 来源);
}

export {};
