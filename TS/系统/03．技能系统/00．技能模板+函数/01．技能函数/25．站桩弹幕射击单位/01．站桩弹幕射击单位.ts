/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};
const {
  单位是否硬直中,
  单位是否处于施法硬直效果,
  单位是否处于硬控制效果合集,
  单位是否拥有指定Buff,
} = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  单位是否硬直中: (this: void, 单位: any) => boolean;
  单位是否处于施法硬直效果: (this: void, 单位: any) => boolean;
  单位是否处于硬控制效果合集: (this: void, 单位: any) => boolean;
  单位是否拥有指定Buff: (this: void, 单位: any, BuffID: string) => boolean;
};
const { X_FixUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const SetUnitX = jass.SetUnitX as (unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animation: string) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const QueueUnitAnimation = jass.QueueUnitAnimation as ((unit: any, animation: string) => void) | undefined;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const SetUnitAcquireRange = jass.SetUnitAcquireRange as (unit: any, acquireRange: number) => void;
const IssueImmediateOrder = jass.IssueImmediateOrder as (unit: any, order: string) => boolean;
const IsUnitPaused = jass.IsUnitPaused as (unit: any) => boolean;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const ConvertUnitState = jass.ConvertUnitState as (i: number) => any;
const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any,
) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const SetUnitStateJapi = japi.SetUnitState as (unit: any, state: any, value: number) => void;
const DzSetUnitMissileModel = japi.DzSetUnitMissileModel as ((unit: any, model: string) => void) | undefined;
const DzSetUnitMissileArc = japi.DzSetUnitMissileArc as ((unit: any, arc: number) => void) | undefined;
const DzSetUnitMissileSpeed = japi.DzSetUnitMissileSpeed as ((unit: any, speed: number) => void) | undefined;
const DzUnitDisableAttack = japi.DzUnitDisableAttack as ((unit: any, disabled: boolean) => void) | undefined;
const EXSetUnitFacing = japi.EXSetUnitFacing as ((unit: any, angle: number) => void) | undefined;

const BJ_RADTODEG = 57.29577951308232;
const BJ_DEGTORAD = 0.017453292519943295;
const 攻击力状态 = 0x12;
const 攻击范围状态 = 0x16;
const 攻击间隔状态 = 0x25;
const 驱动间隔毫秒 = 50;

const 阻止攻击的控制Buff列表 = [
  "C001", // 击晕
  "C002", // 冰冻
  "C004", // 变形
  "C006", // 缴械
  "C008", // 硬直
  "C009", // 暂停
  "C010", // EX暂停
  "C016", // 睡眠
  "C018", // 飓风
  "C037", // 施法硬直展示
];

export interface 站桩弹幕射击单位参数 {
  射手单位: any;
  来源单位: any;
  持续秒?: number;
  攻击间隔秒: number;
  出手延迟秒?: number;
  伤害值: number;
  弹道模型: string;
  弹道速度: number;
  命中半径: number;
  最大飞行距离: number;
  飞行高度?: number;
  弹道缩放?: number;
  起射偏移?: number;
  攻击动画名?: string;
  攻击动画编号?: number;
  攻击动画速度?: number;
  选择目标: (this: void, 射手单位: any, 来源单位: any) => any;
  攻击类型?: any;
  伤害类型?: any;
  武器类型?: any;
}

interface 站桩弹幕射击状态 {
  id: number;
  参数: 站桩弹幕射击单位参数;
  到期时间: number;
  下次攻击时间: number;
  待出手时间: number;
  待出手目标: any;
  待出手目标ID: number;
  固定X: number;
  固定Y: number;
}

const 射击状态表: Record<number, 站桩弹幕射击状态 | undefined> = {};
const 射击状态ID列表: number[] = [];
let 驱动ID = 0;

function 单位有效且存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 加入状态ID(this: void, id: number): void {
  for (let i = 0; i < 射击状态ID列表.length; i++) {
    if (射击状态ID列表[i] === id) return;
  }
  射击状态ID列表.push(id);
}

function 移除状态ID(this: void, id: number): void {
  for (let i = 0; i < 射击状态ID列表.length; i++) {
    if (射击状态ID列表[i] === id) {
      射击状态ID列表.splice(i, 1);
      return;
    }
  }
}

function 确保驱动(this: void): void {
  if (驱动ID !== 0) return;
  驱动ID = addPeriodicCallback(驱动间隔毫秒, on站桩弹幕射击单位Tick);
}

function 尝试停止驱动(this: void): void {
  if (驱动ID === 0 || 射击状态ID列表.length > 0) return;
  removePeriodicCallback(驱动ID);
  驱动ID = 0;
}

function 单位有阻止攻击Buff(this: void, unit: any): boolean {
  for (let i = 0; i < 阻止攻击的控制Buff列表.length; i++) {
    if (单位是否拥有指定Buff(unit, 阻止攻击的控制Buff列表[i])) return true;
  }
  return false;
}

export function 单位是否可以站桩弹幕射击(this: void, unit: any): boolean {
  if (!单位有效且存活(unit)) return false;
  if (IsUnitPaused(unit) === true) return false;
  if (单位是否硬直中(unit)) return false;
  if (单位是否处于施法硬直效果(unit)) return false;
  if (单位是否处于硬控制效果合集(unit)) return false;
  if (单位有阻止攻击Buff(unit)) return false;
  return true;
}

export function 禁用单位原生攻击并固定站桩(this: void, unit: any): void {
  if (!单位有效且存活(unit)) return;
  SetUnitAcquireRange(unit, 0);
  X_FixUnitStandingSafe(unit);
  SetUnitStateJapi(unit, ConvertUnitState(攻击力状态), 0);
  SetUnitStateJapi(unit, ConvertUnitState(攻击范围状态), 0);
  SetUnitStateJapi(unit, ConvertUnitState(攻击间隔状态), 99);
  if (DzSetUnitMissileModel != null) DzSetUnitMissileModel(unit, "");
  if (DzSetUnitMissileArc != null) DzSetUnitMissileArc(unit, 0);
  if (DzSetUnitMissileSpeed != null) DzSetUnitMissileSpeed(unit, 0);
  if (DzUnitDisableAttack != null) DzUnitDisableAttack(unit, true);
  IssueImmediateOrder(unit, "stop");
}

function 维持站桩状态(this: void, 状态: 站桩弹幕射击状态): void {
  const unit = 状态.参数.射手单位;
  if (!单位有效且存活(unit)) return;
  SetUnitAcquireRange(unit, 0);
  X_FixUnitStandingSafe(unit);
  if (DzUnitDisableAttack != null) DzUnitDisableAttack(unit, true);

  const dx = GetUnitX(unit) - 状态.固定X;
  const dy = GetUnitY(unit) - 状态.固定Y;
  if (dx > 1 || dx < -1 || dy > 1 || dy < -1) {
    SetUnitX(unit, 状态.固定X);
    SetUnitY(unit, 状态.固定Y);
  }
}

function 取面向目标角度(this: void, source: any, target: any): number {
  return Atan2(GetUnitY(target) - GetUnitY(source), GetUnitX(target) - GetUnitX(source)) * BJ_RADTODEG;
}

function 立即面向目标(this: void, source: any, target: any): number {
  const angle = 取面向目标角度(source, target);
  SetUnitFacing(source, angle);
  if (EXSetUnitFacing != null) EXSetUnitFacing(source, angle * BJ_DEGTORAD);
  return angle;
}

function 播放攻击动作(this: void, 状态: 站桩弹幕射击状态): void {
  const 参数 = 状态.参数;
  const 射手 = 参数.射手单位;
  SetUnitTimeScale(射手, 参数.攻击动画速度 ?? 1);
  if (参数.攻击动画编号 != null && 参数.攻击动画编号 >= 0) {
    SetUnitAnimationByIndex(射手, 参数.攻击动画编号);
  } else {
    SetUnitAnimation(射手, 参数.攻击动画名 ?? "attack");
  }
  if (QueueUnitAnimation != null) QueueUnitAnimation(射手, "stand");
}

function 目标仍是待出手目标(this: void, 状态: 站桩弹幕射击状态): boolean {
  const target = 状态.待出手目标;
  return 单位有效且存活(target) && 取单位ID(target) === 状态.待出手目标ID;
}

function 发射站桩直线弹幕(this: void, 状态: 站桩弹幕射击状态): void {
  const 参数 = 状态.参数;
  const 射手 = 参数.射手单位;
  let target = 状态.待出手目标;
  if (!单位有效且存活(射手) || !单位有效且存活(参数.来源单位) || !目标仍是待出手目标(状态)) return;
  if (!单位是否可以站桩弹幕射击(射手)) return;

  const currentTarget = 参数.选择目标(射手, 参数.来源单位);
  if (单位有效且存活(currentTarget)) target = currentTarget;

  const angle = 立即面向目标(射手, target);
  const angleRad = angle * BJ_DEGTORAD;
  const offset = 参数.起射偏移 ?? 32;

  function 站桩直线弹幕命中伤害(this: void, 目标单位: any): void {
    if (!单位有效且存活(参数.来源单位) || !单位有效且存活(目标单位) || !(参数.伤害值 > 0)) return;
    UnitDamageTarget(
      参数.来源单位,
      目标单位,
      参数.伤害值,
      false,
      false,
      参数.攻击类型 ?? ATTACK_TYPE_NORMAL,
      参数.伤害类型 ?? DAMAGE_TYPE_NORMAL,
      参数.武器类型 ?? WEAPON_TYPE_WHOKNOWS,
    );
  }

  创建原生弹幕({
    所有者: 参数.来源单位,
    X: GetUnitX(射手) + Cos(angleRad) * offset,
    Y: GetUnitY(射手) + Sin(angleRad) * offset,
    方向角: angle,
    轨迹类型: "直线",
    显式改向后锁定方向: true,
    速度: 参数.弹道速度,
    命中半径: 参数.命中半径,
    最大距离: 参数.最大飞行距离,
    生命周期: 4,
    碰撞消失: true,
    最大总命中次数: 1,
    每单位最大命中次数: 1,
    模型: 参数.弹道模型,
    飞行高度: 参数.飞行高度 ?? 80,
    缩放: 参数.弹道缩放 ?? 1,
    影响目标: "敌方",
    伤害值: 0,
    攻击类型: 参数.攻击类型 ?? ATTACK_TYPE_NORMAL,
    伤害类型: 参数.伤害类型 ?? DAMAGE_TYPE_NORMAL,
    武器类型: 参数.武器类型 ?? WEAPON_TYPE_WHOKNOWS,
    on命中单位: 站桩直线弹幕命中伤害,
  });
}

function 开始一次模拟攻击(this: void, 状态: 站桩弹幕射击状态, now: number): void {
  const 参数 = 状态.参数;
  const target = 参数.选择目标(参数.射手单位, 参数.来源单位);
  if (!单位有效且存活(target)) {
    状态.下次攻击时间 = now + 250;
    return;
  }

  立即面向目标(参数.射手单位, target);
  播放攻击动作(状态);
  状态.待出手目标 = target;
  状态.待出手目标ID = 取单位ID(target);
  状态.待出手时间 = now + (参数.出手延迟秒 ?? 0.35) * 1000;
}

function 中断待出手(this: void, 状态: 站桩弹幕射击状态, now: number): void {
  状态.待出手目标 = null;
  状态.待出手目标ID = 0;
  状态.待出手时间 = 0;
  状态.下次攻击时间 = now + 250;
  if (单位有效且存活(状态.参数.射手单位)) {
    SetUnitTimeScale(状态.参数.射手单位, 1);
    SetUnitAnimation(状态.参数.射手单位, "stand");
  }
}

function 更新单个射击状态(this: void, 状态: 站桩弹幕射击状态, now: number): boolean {
  const 参数 = 状态.参数;
  if (!单位有效且存活(参数.射手单位) || !单位有效且存活(参数.来源单位)) return false;
  if (状态.到期时间 > 0 && now >= 状态.到期时间) return false;

  维持站桩状态(状态);

  if (状态.待出手时间 > 0) {
    if (!单位是否可以站桩弹幕射击(参数.射手单位) || !目标仍是待出手目标(状态)) {
      中断待出手(状态, now);
      return true;
    }
    if (now >= 状态.待出手时间) {
      发射站桩直线弹幕(状态);
      状态.待出手目标 = null;
      状态.待出手目标ID = 0;
      状态.待出手时间 = 0;
      状态.下次攻击时间 = now + 参数.攻击间隔秒 * 1000;
      SetUnitTimeScale(参数.射手单位, 1);
    }
    return true;
  }

  if (now < 状态.下次攻击时间) return true;
  if (!单位是否可以站桩弹幕射击(参数.射手单位)) {
    状态.下次攻击时间 = now + 250;
    return true;
  }

  开始一次模拟攻击(状态, now);
  return true;
}

function 清理状态(this: void, id: number): void {
  const 状态 = 射击状态表[id];
  if (状态 != null && 单位有效且存活(状态.参数.射手单位)) {
    SetUnitTimeScale(状态.参数.射手单位, 1);
  }
  delete 射击状态表[id];
  移除状态ID(id);
}

function on站桩弹幕射击单位Tick(this: void): void {
  const now = getServerTime();
  let index = 0;
  while (index < 射击状态ID列表.length) {
    const id = 射击状态ID列表[index];
    const 状态 = 射击状态表[id];
    if (状态 == null || !更新单个射击状态(状态, now)) {
      清理状态(id);
    } else {
      index++;
    }
  }
  尝试停止驱动();
}

export function 注册站桩弹幕射击单位(this: void, 参数: 站桩弹幕射击单位参数): number {
  const id = 取单位ID(参数.射手单位);
  if (id === 0 || 参数.选择目标 == null || !(参数.攻击间隔秒 > 0) || !(参数.弹道速度 > 0)) return 0;
  清理状态(id);
  禁用单位原生攻击并固定站桩(参数.射手单位);

  const now = getServerTime();
  射击状态表[id] = {
    id,
    参数,
    到期时间: 参数.持续秒 != null && 参数.持续秒 > 0 ? now + 参数.持续秒 * 1000 : 0,
    下次攻击时间: now + 200,
    待出手时间: 0,
    待出手目标: null,
    待出手目标ID: 0,
    固定X: GetUnitX(参数.射手单位),
    固定Y: GetUnitY(参数.射手单位),
  };
  加入状态ID(id);
  确保驱动();
  return id;
}

export function 停止站桩弹幕射击单位(this: void, 射手单位: any): void {
  const id = 取单位ID(射手单位);
  if (id === 0) return;
  清理状态(id);
  尝试停止驱动();
}
