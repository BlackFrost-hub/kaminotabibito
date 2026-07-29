/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const globals = require("jass.globals") as { gg_unit_Hamg_0002?: any; [key: string]: any };

const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};
const { X_FixUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
};
const { 注册Boss技能测试目标, 注销Boss技能测试目标 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  注册Boss技能测试目标: (this: void, unit: any) => void;
  注销Boss技能测试目标: (this: void, unit: any) => void;
};

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (whichGroup: any) => void;
const GroupEnumUnitsOfPlayer = jass.GroupEnumUnitsOfPlayer as (whichGroup: any, whichPlayer: any, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (whichGroup: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (whichGroup: any, whichUnit: any) => void;
const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const KillUnit = jass.KillUnit as (unit: any) => void;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const Player = jass.Player as (playerId: number) => any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const SetUnitStateJapi = japi.SetUnitState as (unit: any, state: any, value: number) => void;

export const Boss测试默认最大生命值 = 999999;
export const Boss测试固定步兵最大生命值 = 99999999;
export const Boss测试中立敌对玩家ID = 12;

const Boss测试固定步兵单位ID = stringToFourCCSafe("hfoo");
const Boss测试固定山丘之王单位ID = stringToFourCCSafe("Hmkg");
let 当前Boss测试固定步兵: any = null;
let 当前Boss测试固定山丘之王: any = null;
const Boss测试临时步兵列表: any[] = [];

export function Boss测试单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

export function Boss测试单位是存活英雄(this: void, unit: any): boolean {
  return Boss测试单位存活(unit) && IsUnitType(unit, UNIT_TYPE_HERO) === true;
}

export function Boss测试单位属于玩家(this: void, unit: any, player: any): boolean {
  return Boss测试单位存活(unit) && GetPlayerId(GetOwningPlayer(unit)) === GetPlayerId(player);
}

export function 设置Boss测试单位满血(this: void, unit: any, 最大生命值?: number): void {
  if (unit == null || unit === 0) return;
  const hp = 最大生命值 ?? Boss测试默认最大生命值;
  SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, hp);
  SetUnitState(unit, UNIT_STATE_LIFE, hp);
}

export function 准备Boss测试固定步兵(this: void, unit: any, x: number, y: number, facing: number = 90): any {
  let result = unit;
  const owner = Player(Boss测试中立敌对玩家ID);
  if (
    !Boss测试单位存活(result)
    || GetUnitTypeId(result) !== Boss测试固定步兵单位ID
    || GetPlayerId(GetOwningPlayer(result)) !== Boss测试中立敌对玩家ID
  ) {
    if (result != null && result !== 0) {
      注销Boss技能测试目标(result);
      RemoveUnit(result);
    }
    result = CreateUnit(owner, Boss测试固定步兵单位ID, x, y, facing);
  }
  if (!Boss测试单位存活(result)) return null;
  SetUnitPosition(result, x, y);
  SetUnitFacing(result, facing);
  设置Boss测试单位满血(result, Boss测试固定步兵最大生命值);
  X_FixUnitStandingSafe(result);
  注册Boss技能测试目标(result);
  当前Boss测试固定步兵 = result;
  return result;
}

export function 准备Boss测试固定山丘之王(this: void, unit: any, x: number, y: number, facing: number = 90): any {
  let result = unit;
  const owner = Player(Boss测试中立敌对玩家ID);
  if (
    !Boss测试单位存活(result)
    || GetUnitTypeId(result) !== Boss测试固定山丘之王单位ID
    || GetPlayerId(GetOwningPlayer(result)) !== Boss测试中立敌对玩家ID
  ) {
    if (result != null && result !== 0) {
      注销Boss技能测试目标(result);
      RemoveUnit(result);
    }
    result = CreateUnit(owner, Boss测试固定山丘之王单位ID, x, y, facing);
  }
  if (!Boss测试单位存活(result)) return null;
  SetUnitPosition(result, x, y);
  SetUnitFacing(result, facing);
  设置Boss测试单位满血(result, Boss测试固定步兵最大生命值);
  X_FixUnitStandingSafe(result);
  注册Boss技能测试目标(result);
  当前Boss测试固定山丘之王 = result;
  return result;
}

export function 创建Boss测试临时步兵(this: void, x: number, y: number, facing: number = 90): any {
  const unit = CreateUnit(Player(Boss测试中立敌对玩家ID), Boss测试固定步兵单位ID, x, y, facing);
  if (!Boss测试单位存活(unit)) return null;
  设置Boss测试单位满血(unit, Boss测试固定步兵最大生命值);
  注册Boss技能测试目标(unit);
  Boss测试临时步兵列表.push(unit);
  return unit;
}

export function 击杀最近Boss测试临时步兵(this: void): any {
  for (let i = Boss测试临时步兵列表.length - 1; i >= 0; i--) {
    const unit = Boss测试临时步兵列表[i];
    if (!Boss测试单位存活(unit)) continue;
    注销Boss技能测试目标(unit);
    KillUnit(unit);
    return unit;
  }
  return null;
}

export function 清理Boss测试临时步兵(this: void): void {
  for (let i = Boss测试临时步兵列表.length - 1; i >= 0; i--) {
    const unit = Boss测试临时步兵列表[i];
    Boss测试临时步兵列表.splice(i, 1);
    if (unit == null || unit === 0) continue;
    注销Boss技能测试目标(unit);
    RemoveUnit(unit);
  }
}

function 查找场上Boss测试固定单位(this: void, unitTypeId: number): any {
  const group = CreateGroup();
  GroupEnumUnitsOfPlayer(group, Player(Boss测试中立敌对玩家ID), null);
  let result: any = null;
  let unit = FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(group, unit);
    if (Boss测试单位存活(unit) && GetUnitTypeId(unit) === unitTypeId) {
      result = unit;
      break;
    }
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
  return result;
}

export function 获取Boss测试伤害来源单位(this: void): any {
  if (Boss测试单位存活(当前Boss测试固定步兵)) return 当前Boss测试固定步兵;
  if (Boss测试单位存活(当前Boss测试固定山丘之王)) return 当前Boss测试固定山丘之王;

  const infantry = 查找场上Boss测试固定单位(Boss测试固定步兵单位ID);
  if (Boss测试单位存活(infantry)) {
    当前Boss测试固定步兵 = infantry;
    return infantry;
  }

  const mountainKing = 查找场上Boss测试固定单位(Boss测试固定山丘之王单位ID);
  if (Boss测试单位存活(mountainKing)) {
    当前Boss测试固定山丘之王 = mountainKing;
    return mountainKing;
  }
  return null;
}

export function 移除Boss测试单位(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  if (unit === 当前Boss测试固定步兵) 当前Boss测试固定步兵 = null;
  if (unit === 当前Boss测试固定山丘之王) 当前Boss测试固定山丘之王 = null;
  注销Boss技能测试目标(unit);
  RemoveUnit(unit);
}

export function 获取Boss测试玩家基准英雄(this: void, player: any): any {
  const presetArchmage = globals.gg_unit_Hamg_0002;
  if (Boss测试单位是存活英雄(presetArchmage)) return presetArchmage;

  const registeredHero = getRegisteredPlayerHero(player);
  if (Boss测试单位是存活英雄(registeredHero)) return registeredHero;

  const group = CreateGroup();
  GroupEnumUnitsOfPlayer(group, player, null);
  let result: any = null;
  let unit = FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    GroupRemoveUnit(group, unit);
    if (Boss测试单位是存活英雄(unit)) {
      result = unit;
      break;
    }
    unit = FirstOfGroup(group);
  }
  DestroyGroup(group);
  return result;
}
