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
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const Player = jass.Player as (playerId: number) => any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const SetUnitStateJapi = japi.SetUnitState as (unit: any, state: any, value: number) => void;

export const Boss测试默认最大生命值 = 999999;
export const Boss测试固定步兵最大生命值 = 99999;
export const Boss测试中立敌对玩家ID = 12;

const Boss测试固定步兵单位ID = stringToFourCCSafe("hfoo");

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
  return result;
}

export function 移除Boss测试单位(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
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
