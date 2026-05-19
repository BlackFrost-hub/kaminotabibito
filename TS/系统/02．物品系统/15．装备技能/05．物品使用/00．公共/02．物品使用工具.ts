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
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
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
const CreateUnit = jass.CreateUnit as (id: any, unitid: number, x: number, y: number, face: number) => any;
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

export function 是否为使用物品(this: void, 物品: any, 物品类型ID: number): boolean {
  if (物品 == null || 物品 === 0 || 物品类型ID === 0) return false;
  return GetItemTypeId(物品) === 物品类型ID;
}

export function 单位持有物品(this: void, 单位: any, 物品类型ID: number): boolean {
  if (单位 == null || 单位 === 0 || 物品类型ID === 0) return false;
  return UnitHasItemOfTypeBJ(单位, 物品类型ID) === true;
}

export function 获取单位指定物品(this: void, 单位: any, 物品类型ID: number): any {
  return GetItemOfTypeFromUnitBJ(单位, 物品类型ID);
}

export function 取句柄ID(this: void, h: any): number {
  if (h == null || h === 0) return 0;
  return GetHandleId(h);
}

export function 单位存活(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  return IsUnitType(单位, UNIT_TYPE_DEAD) !== true && GetUnitState(单位, UNIT_STATE_LIFE) > 0.405;
}

export function 单位是英雄(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_HERO) === true;
}

export function 单位可作为敌人目标(this: void, 单位: any): boolean {
  if (!单位存活(单位)) return false;
  if (IsUnitType(单位, UNIT_TYPE_MECHANICAL)) return false;
  if (IsUnitType(单位, UNIT_TYPE_ANCIENT)) return false;
  return true;
}

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
  UnitDamageTarget(来源, 目标, 伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS);
}

export function 造成火焰伤害(this: void, 来源: any, 目标: any, 伤害: number): void {
  if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0)) return;
  UnitDamageTarget(来源, 目标, 伤害, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS);
}

export function 造成暗影伤害(this: void, 来源: any, 目标: any, 伤害: number): void {
  if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0)) return;
  UnitDamageTarget(来源, 目标, 伤害, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS);
}

export function 造成普通伤害(this: void, 来源: any, 目标: any, 伤害: number): void {
  if (!单位存活(来源) || !单位存活(目标) || !(伤害 > 0)) return;
  UnitDamageTarget(来源, 目标, 伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

export function 造成精神自伤(this: void, 单位: any, 伤害: number): void {
  if (!单位存活(单位) || !(伤害 > 0)) return;
  UnitDamageTarget(单位, 单位, 伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS);
}

export function 执行治疗(this: void, 来源: any, 目标: any, 生命: number, 魔法: number = 0): void {
  if (目标 == null || 目标 === 0) return;
  doHeal({
    HealSource: 来源,
    HealTarget: 目标,
    HealAmount: 生命,
    HealManaAmount: 魔法,
    ItemHeal: true,
    HealEffect: 生命 > 0,
    HealEffectPath: "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl",
    ManaEffect: 魔法 > 0,
    ManaEffectPath: "Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl",
  });
}

export function 播放点特效(this: void, 模型: string, x: number, y: number): void {
  if (模型 === "") return;
  const effect = AddSpecialEffect(模型, x, y);
  if (effect != null && effect !== 0) DestroyEffect(effect);
}

export function 播放单位特效(this: void, 模型: string, 单位: any, 挂点: string = "origin"): void {
  if (单位 == null || 单位 === 0 || 模型 === "") return;
  const effect = AddSpecialEffectTarget(模型, 单位, 挂点);
  if (effect != null && effect !== 0) DestroyEffect(effect);
}

export function 施加眩晕(this: void, 来源: any, 目标: any, 持续时间: number): void {
  SFB_setBuff(来源, 目标, 0, 持续时间);
}

export function 施加减速(this: void, 来源: any, 目标: any, 降低比例: number, 持续时间: number): void {
  SFB_setSlow(来源, 目标, 降低比例, 降低比例, 持续时间);
}

export function 清除负面Buff(this: void, 单位: any): number {
  return 清除单位负面Buff(单位, false);
}

export function 临时调整攻击(this: void, 单位: any, 数值: number): void {
  SGSS_SetState(单位, 1, 数值);
}

export function 临时调整护甲(this: void, 单位: any, 数值: number): void {
  SGSS_SetState(单位, 2, 数值);
}

export function 临时调整攻速(this: void, 单位: any, 数值: number): void {
  SGSS_SetState(单位, 10, 数值);
}

export function 调整玩家属性(this: void, 单位: any, 属性名: string, 增量: number): void {
  if (单位 == null || 单位 === 0) return;
  const owner = GetOwningPlayer(单位);
  const oldValue = Number(YDUserDataGetSafe("player", owner, 属性名, "real")) || 0;
  YDUserDataSetSafe("player", owner, 属性名, "real", oldValue + 增量);
}

export function 调整单位属性(this: void, 单位: any, 属性名: string, 增量: number): void {
  if (单位 == null || 单位 === 0) return;
  const oldValue = Number(YDUserDataGetSafe("unit", 单位, 属性名, "real")) || 0;
  YDUserDataSetSafe("unit", 单位, 属性名, "real", oldValue + 增量);
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
  ModifyHeroStat(bj_HEROSTAT_INT, 英雄, bj_MODIFYMETHOD_ADD, 智力);
}

export function 获取物品次数(this: void, 单位: any, 物品类型ID: number): number {
  const item = 获取单位指定物品(单位, 物品类型ID);
  if (item == null || item === 0) return 0;
  return GetItemCharges(item);
}

export function 设置物品次数(this: void, 单位: any, 物品类型ID: number, 次数: number): void {
  const item = 获取单位指定物品(单位, 物品类型ID);
  if (item == null || item === 0) return;
  SetItemCharges(item, 次数);
}

export function 增加物品次数(this: void, 单位: any, 物品类型ID: number, 次数: number, 最大值: number): void {
  const current = 获取物品次数(单位, 物品类型ID);
  let next = current + 次数;
  if (next > 最大值) next = 最大值;
  设置物品次数(单位, 物品类型ID, next);
}

export function 单位所在点是荒芜(this: void, 单位: any): boolean {
  return IsPointBlighted(GetUnitX(单位), GetUnitY(单位)) === true;
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

export function 取玩家ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return -1;
  return GetPlayerId(GetOwningPlayer(单位));
}

export function 创建火把单位(this: void, 来源: any, x: number, y: number, face: number, 模型: string, 持续时间: number): void {
  if (火把单位类型ID === 0) return;
  const unit = CreateUnit(GetOwningPlayer(来源), 火把单位类型ID, x, y, face);
  if (unit == null || unit === 0) return;
  DzSetUnitModel(unit, 模型);
  SetUnitScale(unit, 1, 1, 1);
  SetUnitInvulnerable(unit, true);
  SetUnitFacing(来源, face);
  UnitApplyTimedLife(unit, 限时生命BuffID, 持续时间);
}

export {};
