/** @noSelfInFile */

import { 一方通行单位技能配置 } from "./00．配置";
import {
  两点角度,
  单位存活,
  读取单位攻击力,
} from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const {
  YDUserDataGetSafe,
  YDUserDataSetSafe,
  getObjectPropertySafe,
  getObjectPropertyRealSafe,
} = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
  getObjectPropertySafe: (this: void, objectType: number, objectId: number | string, property: string) => string;
  getObjectPropertyRealSafe: (this: void, objectType: number, objectId: number | string, property: string) => number;
};
const { addDelayedCallback, addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const { 减少魔法值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少魔法值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string) => number;
};
const {
  创建原生弹幕,
  获取单位原生弹幕ID,
  获取原生弹幕,
  重置原生弹幕命中记录,
  设置原生弹幕指定角度飞行,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index") as {
  创建原生弹幕: (this: void, 参数: any) => any;
  获取单位原生弹幕ID: (this: void, unit: any) => number;
  获取原生弹幕: (this: void, projectileId: number) => any;
  重置原生弹幕命中记录: (this: void, projectileId: number) => boolean;
  设置原生弹幕指定角度飞行: (this: void, projectileId: number, angle: number, speed?: number) => boolean;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const CreateGroup = jass.CreateGroup as (this: void) => any;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (this: void, player: any, x: number, y: number, duration: number, text: string) => void;
const FirstOfGroup = jass.FirstOfGroup as (this: void, group: any) => any;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GroupClear = jass.GroupClear as (this: void, group: any) => void;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (this: void, group: any, x: number, y: number, radius: number, filter: any) => void;
const GroupRemoveUnit = jass.GroupRemoveUnit as (this: void, group: any, unit: any) => void;
const IsUnitEnemy = jass.IsUnitEnemy as (this: void, unit: any, player: any) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, unit: any, player: any, changeColor: boolean) => void;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const EXSetUnitFacing = japi.EXSetUnitFacing as (this: void, unit: any, angle: number) => void;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_TAUREN = jass.UNIT_TYPE_TAUREN as any;

const YDWE对象类型单位 = 2;
const 一方通行单位类型ID = stringToFourCCSafe(一方通行单位技能配置.单位类型ID);
const 矢量反射开启技能ID = stringToFourCCSafe(一方通行单位技能配置.矢量反射开启技能ID);
const 矢量反射关闭技能ID = stringToFourCCSafe(一方通行单位技能配置.矢量反射关闭技能ID);
const 弹幕枚举组 = CreateGroup();

interface 一方通行矢量反射上下文 {
  单位: any;
  已开启: boolean;
}

interface 延迟普攻反射记录 {
  一方通行: any;
  反击目标: any;
  受到伤害: number;
  是否远程: boolean;
  攻击类型: any;
  伤害类型: any;
  武器类型: any;
}

const 矢量反射上下文表: Record<number, 一方通行矢量反射上下文 | undefined> = {};
const 矢量反射上下文列表: 一方通行矢量反射上下文[] = [];
let 矢量反射系统已注册 = false;

function 取单位句柄ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 获取或创建一方通行矢量反射上下文(this: void, unit: any): 一方通行矢量反射上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  if (unitId === 0) return undefined;
  const current = 矢量反射上下文表[unitId];
  if (current != null) return current;
  const created: 一方通行矢量反射上下文 = {
    单位: unit,
    已开启: false,
  };
  矢量反射上下文表[unitId] = created;
  矢量反射上下文列表.push(created);
  return created;
}

function 获取一方通行矢量反射上下文(this: void, unit: any): 一方通行矢量反射上下文 | undefined {
  const unitId = 取单位句柄ID(unit);
  return unitId === 0 ? undefined : 矢量反射上下文表[unitId];
}

function 移除一方通行矢量反射上下文(this: void, unit: any): void {
  const unitId = 取单位句柄ID(unit);
  if (unitId === 0) return;
  const context = 矢量反射上下文表[unitId];
  if (context == null) return;
  delete 矢量反射上下文表[unitId];
  for (let i = 矢量反射上下文列表.length - 1; i >= 0; i--) {
    if (矢量反射上下文列表[i] === context) {
      矢量反射上下文列表.splice(i, 1);
      break;
    }
  }
}

function 读取最大魔法值(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  const value = GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA);
  return typeof value === "number" && value > 0 ? value : 0;
}

function 读取当前魔法比例(this: void, unit: any): number {
  const maxMana = 读取最大魔法值(unit);
  if (!(maxMana > 0)) return 0;
  return GetUnitState(unit, UNIT_STATE_MANA) / maxMana;
}

function 播放矢量反射音效(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  Sound3DII_UnitPlayReuse(
    一方通行单位技能配置.W.施法音效路径,
    unit,
    一方通行单位技能配置.W.施法音效裁断距离,
  );
}

function 显示矢量反射强制关闭提示(this: void, unit: any): void {
  if (unit == null || unit === 0) return;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return;
  DisplayTimedTextToPlayer(
    owner,
    0,
    0,
    6,
    "|cffffcc00[矢量反射]|r 魔法值已降至10%或以下，反射强制关闭并进入10秒固定冷却。",
  );
}

function 关闭矢量反射(this: void, context: 一方通行矢量反射上下文, 强制关闭: boolean): void {
  const unit = context.单位;
  context.已开启 = false;
  if (unit == null || unit === 0) return;
  const owner = GetOwningPlayer(unit);
  UnitRemoveAbility(unit, 矢量反射关闭技能ID);
  if (owner != null && owner !== 0) {
    SetPlayerAbilityAvailable(owner, 矢量反射开启技能ID, true);
  }
  if (!强制关闭) return;
  技能_设置技能冷却时间(
    unit,
    矢量反射开启技能ID,
    一方通行单位技能配置.强制关闭固定冷却秒,
    一方通行单位技能配置.强制关闭固定冷却秒,
  );
  显示矢量反射强制关闭提示(unit);
}

function 检查魔法并按需强制关闭(this: void, context: 一方通行矢量反射上下文): boolean {
  if (读取当前魔法比例(context.单位) > 一方通行单位技能配置.强制关闭魔法比例) return true;
  关闭矢量反射(context, true);
  return false;
}

function 开启矢量反射(this: void, context: 一方通行矢量反射上下文, unit: any): void {
  if (!单位存活(unit) || GetUnitTypeId(unit) !== 一方通行单位类型ID) return;
  context.单位 = unit;
  context.已开启 = true;
  const owner = GetOwningPlayer(unit);
  if (owner != null && owner !== 0) {
    SetPlayerAbilityAvailable(owner, 矢量反射开启技能ID, false);
  }
  UnitAddAbility(unit, 矢量反射关闭技能ID);
}

function 一方通行开启矢量反射监听(this: void, context: 一方通行矢量反射上下文, unit: any): void {
  开启矢量反射(context, unit);
}

function 一方通行关闭矢量反射监听(this: void, context: 一方通行矢量反射上下文, _unit: any): void {
  关闭矢量反射(context, false);
}

function 结算单体普攻反射伤害(this: void, record: 延迟普攻反射记录, damage: number): void {
  造成单体技能伤害({
    来源: record.一方通行,
    目标: record.反击目标,
    伤害: damage,
    伤害类型: record.伤害类型 ?? DAMAGE_TYPE_NORMAL,
    attack: false,
    ranged: record.是否远程,
    attackType: record.攻击类型 ?? ATTACK_TYPE_NORMAL,
    weaponType: record.武器类型 ?? WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 矢量反射开启技能ID,
    标签: 一方通行单位技能配置.反射伤害标签 + "-普攻",
    伤害形态: "单体",
    参与技能伤害加成: true,
  });
}

function 尝试创建普攻反射弹幕(this: void, record: 延迟普攻反射记录, damage: number): boolean {
  const source = record.一方通行;
  const target = record.反击目标;
  const targetTypeId = GetUnitTypeId(target);
  const model = getObjectPropertySafe(YDWE对象类型单位, targetTypeId, "Missileart");
  let speed = getObjectPropertyRealSafe(YDWE对象类型单位, targetTypeId, "Missilespeed");
  if (model == null || model === "") return false;
  if (!(speed > 0)) speed = 一方通行单位技能配置.普攻反射弹幕默认速度;

  创建原生弹幕({
    所有者: source,
    X: GetUnitX(source),
    Y: GetUnitY(source),
    方向角: 两点角度(GetUnitX(source), GetUnitY(source), GetUnitX(target), GetUnitY(target)),
    速度: speed,
    最大距离: 一方通行单位技能配置.普攻反射弹幕最大距离,
    命中半径: 一方通行单位技能配置.普攻反射弹幕命中半径,
    碰撞消失: true,
    每单位最大命中次数: 1,
    最大总命中次数: 1,
    影响目标: "敌方",
    伤害值: damage,
    伤害类型: record.伤害类型 ?? DAMAGE_TYPE_NORMAL,
    攻击类型: record.攻击类型 ?? ATTACK_TYPE_NORMAL,
    武器类型: record.武器类型 ?? WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 矢量反射开启技能ID,
    技能标签: 一方通行单位技能配置.反射伤害标签 + "-普攻弹幕",
    伤害形态: "单体",
    参与技能伤害加成: true,
    模型: model,
    飞行高度: GetUnitFlyHeight(source) + GetUnitDefaultFlyHeight(source) + 一方通行单位技能配置.普攻反射弹幕基础高度,
  });
  return true;
}

function 结算延迟普攻反射(this: void, variable?: any): void {
  const record = variable as 延迟普攻反射记录 | undefined;
  if (record == null || !单位存活(record.一方通行) || !单位存活(record.反击目标)) return;
  const damage = record.受到伤害 * 一方通行单位技能配置.普攻反射受伤倍率
    + 读取单位攻击力(record.一方通行) * 一方通行单位技能配置.普攻反射攻击力倍率;
  if (!(damage > 0)) return;
  播放矢量反射音效(record.一方通行);
  if (record.是否远程 && 尝试创建普攻反射弹幕(record, damage)) return;
  结算单体普攻反射伤害(record, damage);
}

function 矢量反射普攻伤害修正(this: void, damageContext: any): number {
  const currentDamage = damageContext.currentDamage as number;
  if (!(currentDamage >= 0.1) || damageContext.isNormalAttack !== true) return currentDamage;
  const target = damageContext.target;
  const context = 获取一方通行矢量反射上下文(target);
  if (context == null || !context.已开启 || !单位存活(target)) return currentDamage;
  const attacker = damageContext.originalAttacker ?? damageContext.attacker;
  if (!单位存活(attacker)) return currentDamage;
  const owner = GetOwningPlayer(target);
  if (owner == null || owner === 0 || !IsUnitEnemy(attacker, owner)) return currentDamage;

  减少魔法值(
    target,
    currentDamage * 一方通行单位技能配置.普攻反射魔法消耗倍率,
    false,
    false,
  );
  if (!检查魔法并按需强制关闭(context)) return 0;

  const record: 延迟普攻反射记录 = {
    一方通行: target,
    反击目标: attacker,
    受到伤害: currentDamage,
    是否远程: damageContext.isRangedAttack === true,
    攻击类型: damageContext.effectiveAttackType ?? damageContext.rawAttackType ?? ATTACK_TYPE_NORMAL,
    伤害类型: damageContext.effectiveDamageType ?? damageContext.rawDamageType ?? DAMAGE_TYPE_NORMAL,
    武器类型: damageContext.effectiveWeaponType ?? damageContext.rawWeaponType ?? WEAPON_TYPE_WHOKNOWS,
  };
  addDelayedCallback(0, 结算延迟普攻反射, record);
  return 0;
}

function 是可反射弹幕基础单位(this: void, context: 一方通行矢量反射上下文, projectile: any): boolean {
  if (projectile == null || projectile === 0 || projectile === context.单位) return false;
  if (GetUnitState(projectile, UNIT_STATE_LIFE) <= 0.405) return false;
  if (!IsUnitType(projectile, UNIT_TYPE_MECHANICAL)) return false;
  if (IsUnitType(projectile, UNIT_TYPE_TAUREN)) return false;
  const owner = GetOwningPlayer(context.单位);
  return owner != null && owner !== 0 && IsUnitEnemy(projectile, owner);
}

function 反射TS原生弹幕(this: void, context: 一方通行矢量反射上下文, projectile: any, projectileId: number): boolean {
  const instance = 获取原生弹幕(projectileId);
  if (instance == null || instance.已结束 || instance.参数?.不可阻挡 === true) return false;
  const unit = context.单位;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  const angle = 两点角度(GetUnitX(unit), GetUnitY(unit), GetUnitX(projectile), GetUnitY(projectile));
  const currentSpeed = instance.当前速度 > 0 ? instance.当前速度 : instance.参数.速度;
  if (!设置原生弹幕指定角度飞行(
    projectileId,
    angle,
    currentSpeed * 一方通行单位技能配置.反射弹幕速度倍率,
  )) return false;

  instance.参数.所有者 = unit;
  instance.参数.所属玩家 = owner;
  instance.参数.指定目标 = undefined;
  instance.参数.目标筛选 = undefined;
  instance.参数.影响目标 = "敌方";
  instance.参数.允许命中所有者 = false;
  instance.参数.来源类型 = "单位技能";
  instance.参数.技能ID = 矢量反射开启技能ID;
  instance.参数.技能实例ID = undefined;
  instance.参数.技能标签 = 一方通行单位技能配置.反射伤害标签 + "-原生弹幕";
  instance.参数.参与技能伤害加成 = true;
  SetUnitOwner(projectile, owner, true);
  重置原生弹幕命中记录(projectileId);
  return true;
}

function 读取旧弹幕主人(this: void, projectile: any): any {
  return YDUserDataGetSafe("unit", projectile, "主人", "unit");
}

function 读取旧弹幕速度(this: void, projectile: any): number {
  const value = YDUserDataGetSafe("unit", projectile, "飞行速度", "real");
  return typeof value === "number" ? value : 0;
}

function 反射旧JASS弹幕(this: void, context: 一方通行矢量反射上下文, projectile: any): boolean {
  const oldMaster = 读取旧弹幕主人(projectile);
  const oldSpeed = 读取旧弹幕速度(projectile);
  if (oldMaster == null || oldMaster === 0 || !(oldSpeed > 0)) return false;
  const unit = context.单位;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  const angle = 两点角度(GetUnitX(unit), GetUnitY(unit), GetUnitX(projectile), GetUnitY(projectile));
  SetUnitOwner(projectile, owner, true);
  SetUnitFacing(projectile, angle);
  EXSetUnitFacing(projectile, angle * 0.017453292519943295);
  YDUserDataSetSafe("unit", projectile, "主人", "unit", unit);
  YDUserDataSetSafe("unit", projectile, "飞行距离", "real", 0);
  YDUserDataSetSafe(
    "unit",
    projectile,
    "飞行速度",
    "real",
    oldSpeed * 一方通行单位技能配置.反射弹幕速度倍率,
  );
  const maxLife = GetUnitStateJapi(projectile, UNIT_STATE_MAX_LIFE);
  if (typeof maxLife === "number" && maxLife > 0) SetUnitState(projectile, UNIT_STATE_LIFE, maxLife);
  return true;
}

function 尝试反射范围内弹幕(this: void, context: 一方通行矢量反射上下文, projectile: any): boolean {
  if (!context.已开启 || !是可反射弹幕基础单位(context, projectile)) return false;
  const projectileId = 获取单位原生弹幕ID(projectile);
  const isNativeProjectile = projectileId > 0 && 获取原生弹幕(projectileId) != null;
  if (!isNativeProjectile) {
    const oldMaster = 读取旧弹幕主人(projectile);
    if (oldMaster == null || oldMaster === 0 || !(读取旧弹幕速度(projectile) > 0)) return false;
  }

  const maxMana = 读取最大魔法值(context.单位);
  if (!(maxMana > 0)) return false;
  减少魔法值(
    context.单位,
    maxMana * 一方通行单位技能配置.技能弹幕最大魔法消耗比例,
    false,
    false,
  );
  if (!检查魔法并按需强制关闭(context)) return false;

  const reflected = isNativeProjectile
    ? 反射TS原生弹幕(context, projectile, projectileId)
    : 反射旧JASS弹幕(context, projectile);
  if (reflected) 播放矢量反射音效(context.单位);
  return reflected;
}

function 扫描单个一方通行周围弹幕(this: void, context: 一方通行矢量反射上下文): void {
  const unit = context.单位;
  if (!context.已开启) return;
  if (!单位存活(unit)) {
    关闭矢量反射(context, false);
    return;
  }
  if (!检查魔法并按需强制关闭(context)) return;

  GroupClear(弹幕枚举组);
  GroupEnumUnitsInRange(
    弹幕枚举组,
    GetUnitX(unit),
    GetUnitY(unit),
    一方通行单位技能配置.矢量反射范围,
    null,
  );
  let projectile = FirstOfGroup(弹幕枚举组);
  while (projectile != null && projectile !== 0) {
    GroupRemoveUnit(弹幕枚举组, projectile);
    尝试反射范围内弹幕(context, projectile);
    if (!context.已开启) break;
    projectile = FirstOfGroup(弹幕枚举组);
  }
  GroupClear(弹幕枚举组);
}

function 矢量反射弹幕扫描Tick(this: void): void {
  for (let i = 0; i < 矢量反射上下文列表.length; i++) {
    const context = 矢量反射上下文列表[i];
    if (context != null && context.已开启) 扫描单个一方通行周围弹幕(context);
  }
}

function 一方通行死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (GetUnitTypeId(dyingUnit) !== 一方通行单位类型ID) return;
  const context = 获取一方通行矢量反射上下文(dyingUnit);
  if (context != null) 关闭矢量反射(context, false);
  移除一方通行矢量反射上下文(dyingUnit);
}

export function 注册一方通行矢量反射(this: void): void {
  if (矢量反射系统已注册) return;
  矢量反射系统已注册 = true;
  注册单位技能壳监听({
    名称: "一方通行-开启矢量反射",
    单位类型ID: 一方通行单位类型ID,
    技能ID: 矢量反射开启技能ID,
    获取或创建上下文: 获取或创建一方通行矢量反射上下文,
    创建独立技能实例: false,
    释放技能: 一方通行开启矢量反射监听,
  });
  注册单位技能壳监听({
    名称: "一方通行-关闭矢量反射",
    单位类型ID: 一方通行单位类型ID,
    技能ID: 矢量反射关闭技能ID,
    获取或创建上下文: 获取或创建一方通行矢量反射上下文,
    创建独立技能实例: false,
    释放技能: 一方通行关闭矢量反射监听,
  });
  registerDamageModifier(矢量反射普攻伤害修正, 1000);
  registerDeathListener(一方通行死亡);
  addPeriodicCallback(一方通行单位技能配置.弹幕扫描间隔毫秒, 矢量反射弹幕扫描Tick);
}

注册一方通行矢量反射();

export const 一方通行矢量反射技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  快捷键槽位: "E/04",
  普攻反射: "取消本次普攻伤害，并以受到伤害100%+自身攻击力100%进行单体技能伤害反击",
  弹幕反射: "反射300码内可解析的旧JASS弹幕和TS原生弹幕，反射后速度提高50%",
  魔法消耗: "普攻反射消耗受到伤害115%的魔法值；技能弹幕每发消耗6%最大魔法值",
  强制关闭: "魔法值降至10%或以下时关闭，并进入10秒固定冷却",
} as const;
