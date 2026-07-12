/** @noSelfInFile */

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
const AddHeroXP = jass.AddHeroXP as (whichHero: any, xpToAdd: number, showEyeCandy: boolean) => void;
const ModifyHeroStat = jass.ModifyHeroStat as (whichStat: any, whichHero: any, modifyMethod: any, value: number) => void;
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
const bj_HEROSTAT_INT = jass.bj_HEROSTAT_INT as any;
const bj_MODIFYMETHOD_ADD = jass.bj_MODIFYMETHOD_ADD as any;
const GetUnitStateJapi = japi.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const DzSetUnitModel = japi.DzSetUnitModel as (whichUnit: any, model: string) => void;

const stringToFourCCSafe = (require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
}).stringToFourCCSafe;

const 火把单位类型ID = stringToFourCCSafe("e0FT");
const 限时生命BuffID = stringToFourCCSafe("BHwe");

export function 获取范围敌人(this: void, 来源: any, x: number, y: number, 半径: number): any[] {
  return getEnemyUnitsInRange(来源, x, y, 半径);
}

export function 获取范围友军(this: void, 来源: any, x: number, y: number, 半径: number): any[] {
  const all = getUnitsInRange(x, y, 半径);
  const result: any[] = [];
  const owner = GetOwningPlayer(来源);
  for (const unit of all) {
    if (unit != null && unit !== 0 && IsUnitAlly(unit, owner)) {
      result.push(unit);
    }
  }
  return result;
}

export function 获取范围尸体(this: void, x: number, y: number, 半径: number): any[] {
  const group = CreateGroup();
  GroupEnumUnitsInRange(group, x, y, 半径, null);
  const result: any[] = [];
  let unit = FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    if (
      IsUnitType(unit, UNIT_TYPE_DEAD) === true &&
      IsUnitType(unit, UNIT_TYPE_MECHANICAL) !== true &&
      IsUnitType(unit, UNIT_TYPE_ANCIENT) !== true &&
      GetUnitFlyHeight(unit) <= 999999
    ) {
      result.push(unit);
    }
    GroupRemoveUnit(group, unit);
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
  return result;
}

export function 取单位X(this: void, 单位: any): number {
  return GetUnitX(单位);
}

export function 取单位Y(this: void, 单位: any): number {
  return GetUnitY(单位);
}

export function 计算两点距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return SquareRoot(dx * dx + dy * dy);
}

export function 计算两点角度(this: void, x1: number, y1: number, x2: number, y2: number): number {
  return Atan2(y2 - y1, x2 - x1) * bj_RADTODEG;
}

export function 限制目标点距离(this: void, 起点X: number, 起点Y: number, 目标X: number, 目标Y: number, 最大距离: number): { x: number; y: number; angle: number } {
  const angle = 计算两点角度(起点X, 起点Y, 目标X, 目标Y);
  const distance = 计算两点距离(起点X, 起点Y, 目标X, 目标Y);
  if (distance <= 最大距离) {
    return { x: 目标X, y: 目标Y, angle };
  }
  const rad = angle * bj_DEGTORAD;
  return {
    x: 起点X + Cos(rad) * 最大距离,
    y: 起点Y + Sin(rad) * 最大距离,
    angle,
  };
}

export {};
