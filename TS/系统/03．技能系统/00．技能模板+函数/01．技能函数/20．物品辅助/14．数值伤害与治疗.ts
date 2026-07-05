/** @noSelfInFile */

import { 单位存活 } from "./12．物品与单位";
import { 造成装备技能伤害 } from "../../../../04．伤害系统/08．技能伤害系统";

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
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  getServerTime: (this: void) => number;
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
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => boolean;
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

const 火把单位类型ID = stringToFourCCSafe("e00D");
const 限时生命BuffID = stringToFourCCSafe("BHwe");

type 待销毁特效记录 = {
  句柄: any;
  到期时间: number;
};

const 待销毁特效列表: 待销毁特效记录[] = [];
let 已注册特效销毁驱动 = false;

function 处理待销毁特效(): void {
  const 当前时间 = getServerTime();
  for (let i = 待销毁特效列表.length - 1; i >= 0; i--) {
    const 记录 = 待销毁特效列表[i];
    if (当前时间 < 记录.到期时间) continue;
    DestroyEffect(记录.句柄);
    待销毁特效列表.splice(i, 1);
  }
}

function 安排特效销毁(effect: any, 持续秒: number = 1): void {
  if (effect == null || effect === 0) return;
  if (!已注册特效销毁驱动) {
    已注册特效销毁驱动 = true;
    addPeriodicCallback(100, 处理待销毁特效);
  }
  待销毁特效列表.push({
    句柄: effect,
    到期时间: getServerTime() + 持续秒 * 1000,
  });
}

export function 取当前生命(this: void, 单位: any): number {
  return GetUnitState(单位, UNIT_STATE_LIFE);
}

export function 取当前魔法(this: void, 单位: any): number {
  return GetUnitState(单位, UNIT_STATE_MANA);
}

export function 取最大生命(this: void, 单位: any): number {
  return GetUnitStateJapi(单位, UNIT_STATE_MAX_LIFE);
}

export function 取最大魔法(this: void, 单位: any): number {
  return GetUnitStateJapi(单位, UNIT_STATE_MAX_MANA);
}

export function 取单位攻击(this: void, 单位: any): number {
  return GetUnitStateJapi(单位, ConvertUnitState(0x15));
}

export function 设置生命(this: void, 单位: any, 数值: number): void {
  SetUnitState(单位, UNIT_STATE_LIFE, 数值);
}

export function 设置魔法(this: void, 单位: any, 数值: number): void {
  SetUnitState(单位, UNIT_STATE_MANA, 数值);
}

export function 调整生命(this: void, 单位: any, 数值: number): void {
  SetUnitState(单位, UNIT_STATE_LIFE, GetUnitState(单位, UNIT_STATE_LIFE) + 数值);
}

export function 调整魔法(this: void, 单位: any, 数值: number): void {
  SetUnitState(单位, UNIT_STATE_MANA, GetUnitState(单位, UNIT_STATE_MANA) + 数值);
}

export function 造成强化伤害(this: void, 来源: any, 目标: any, 伤害: number): void {
  if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0)) return;
  造成装备技能伤害({ 来源, 目标, 伤害, 伤害类型: DAMAGE_TYPE_ENHANCED, ranged: false, attackType: ATTACK_TYPE_NORMAL, weaponType: WEAPON_TYPE_WHOKNOWS });
}

export function 造成火焰伤害(this: void, 来源: any, 目标: any, 伤害: number): void {
  if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0)) return;
  造成装备技能伤害({ 来源, 目标, 伤害, 伤害类型: DAMAGE_TYPE_FIRE, ranged: true, attackType: ATTACK_TYPE_NORMAL, weaponType: WEAPON_TYPE_WHOKNOWS });
}

export function 造成暗影伤害(this: void, 来源: any, 目标: any, 伤害: number): void {
  if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0)) return;
  造成装备技能伤害({ 来源, 目标, 伤害, 伤害类型: DAMAGE_TYPE_SHADOW_STRIKE, ranged: true, attackType: ATTACK_TYPE_NORMAL, weaponType: WEAPON_TYPE_WHOKNOWS });
}

export function 造成普通伤害(this: void, 来源: any, 目标: any, 伤害: number): void {
  if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0)) return;
  造成装备技能伤害({ 来源, 目标, 伤害, 伤害类型: DAMAGE_TYPE_NORMAL, ranged: false, attackType: ATTACK_TYPE_NORMAL, weaponType: WEAPON_TYPE_WHOKNOWS });
}

export function 造成精神自伤(this: void, 单位: any, 伤害: number): void {
  if (!单位存活(单位) || !(伤害 > 0)) return;
  造成装备技能伤害({ 来源: 单位, 目标: 单位, 伤害, 伤害类型: DAMAGE_TYPE_MIND, ranged: false, attackType: ATTACK_TYPE_NORMAL, weaponType: WEAPON_TYPE_WHOKNOWS });
}

export function 执行治疗(this: void, 来源: any, 目标: any, 生命: number, 魔法: number = 0): void {
  if (目标 == null || 目标 === 0) return;
  doHeal({
    HealSource: 来源,
    HealTarget: 目标,
    HealAmount: 生命,
    HealManaAmount: 魔法,
    ItemHeal: true,
    HealEffect: false,
    UseDefaultHealEffect: false,
    HealEffectPath: undefined,
    ManaEffect: false,
    UseDefaultManaEffect: false,
    ManaEffectPath: undefined,
  });
}

export {};
