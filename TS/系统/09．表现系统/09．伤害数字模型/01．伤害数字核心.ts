/** @noSelfInFile */
/**
 * 模型伤害数字显示（最小版）
 *
 * - 数据源：伤害计算完成后的最终伤害（registerAppliedFinalDamageListener）
 * - 显示：按位模型 DmgNum_0..9
 * - 动画：中心计时器 10ms 驱动上浮与淡出后销毁
 * - 不使用 DzBindEffect，完全由坐标驱动
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, cb: () => void) => void;
  offTick10ms: (this: void, cb: () => void) => void;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (target: any, attacker: any, applied: number, damageType: 伤害类型快照) => void) => void;
};

const AddSpecialEffect = (jass as any)["AddSpecialEffect"] as (modelPath: string, x: number, y: number) => any;
const DestroyEffect = (jass as any)["DestroyEffect"] as (eff: any) => void;
const GetUnitX = (jass as any)["GetUnitX"] as (unit: any) => number;
const GetUnitY = (jass as any)["GetUnitY"] as (unit: any) => number;
const GetUnitFlyHeight = (jass as any)["GetUnitFlyHeight"] as (unit: any) => number;
const IsUnitType = (jass as any)["IsUnitType"] as (unit: any, unitType: any) => boolean;
const R2I = (jass as any)["R2I"] as (v: number) => number;
const UNIT_TYPE_DEAD = (jass as any).UNIT_TYPE_DEAD;

const EXSetEffectXY = (japi as any)["EXSetEffectXY"] as ((eff: any, x: number, y: number) => void) | undefined;
const EXSetEffectZ = (japi as any)["EXSetEffectZ"] as ((eff: any, z: number) => void) | undefined;
const DzGetColor = (japi as any)["DzGetColor"] as ((a: number, r: number, g: number, b: number) => number) | undefined;
const DzSetEffectVertexColor = (japi as any)["DzSetEffectVertexColor"] as ((eff: any, color: number) => void) | undefined;
const DzSetEffectAnimation = (japi as any)["DzSetEffectAnimation"] as ((eff: any, index: number, flag: number) => void) | undefined;
const DzSetEffectScale = (japi as any)["DzSetEffectScale"] as ((eff: any, scale: number) => void) | undefined;
const DzSetEffectVisible = (japi as any)["DzSetEffectVisible"] as ((eff: any, enable: boolean) => void) | undefined;

interface 单位数字特效 {
  effect: any;
  xOffset: number;
}

interface 伤害数字实例 {
  id: number;
  target: any;
  source: any;
  elapsed: number;
  duration: number;
  startX: number;
  startY: number;
  startZ: number;
  riseHeight: number;
  effects: 单位数字特效[];
}

interface 伤害类型快照 {
  rawAttackType: any;
  rawDamageType: any;
  rawWeaponType: any;
  isPhysicalDamage: boolean;
  isMagicDamage: boolean;
  isEnhancedDamage: boolean;
  isTrueDamage: boolean;
  isNormalAttack: boolean;
  isSkillAttack: boolean;
  isSkillDamage: boolean;
  isMetalDamage: boolean;
  isWoodDamage: boolean;
  isWaterDamage: boolean;
  isFireDamage: boolean;
  isThunderDamage: boolean;
  isLightDamage: boolean;
  isDarkDamage: boolean;
}

const 已启用 = true;
const 模型基础路径 = "UI\\DamageNumbers\\DmgNum_";
const 模型扩展名 = ".mdx";
const 模型动画索引 = 2;
const 模型缩放 = 1.05;
const 最小显示伤害 = 1;
const 上浮持续时间 = 0.35;
const 上浮高度 = 80;
const 数字间距 = 24;
const 基础Z偏移 = 110;

let 已初始化 = false;
let 已注册Tick = false;
let 下一个实例ID = 0;

const 实例表: Record<number, 伤害数字实例 | undefined> = {};
const 实例ID列表: number[] = [];

function 限制颜色字节(this: void, value: number): number {
  if (value <= 0) return 0;
  if (value >= 255) return 255;
  return R2I(value);
}

function 转为显示整数伤害(this: void, applied: number): number {
  if (!(applied > 0)) return 0;
  // 不用 Math，走 JASS R2I
  return R2I(applied + 0.5);
}

function 单位存活(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  return !IsUnitType(unit, UNIT_TYPE_DEAD);
}

function 选取伤害颜色(this: void, damageType: 伤害类型快照): { r: number; g: number; b: number } {
  // 与 JASS 逻辑对齐：普通攻击优先按普攻色，不被魔法标记抢色。
  if (damageType.isNormalAttack) return { r: 160, g: 82, b: 45 };//普攻伤害
  if (damageType.isTrueDamage) return { r: 255, g: 255, b: 255 };//真实/精神伤害
  if (damageType.isEnhancedDamage) return { r: 255, g: 140, b: 0 };//强化伤害
  if (damageType.isFireDamage) return { r: 255, g: 66, b: 66 };//火属性伤害
  if (damageType.isWaterDamage) return { r: 80, g: 190, b: 255 };//水/冰属性伤害
  if (damageType.isThunderDamage) return { r: 170, g: 220, b: 255 };//雷属性伤害
  if (damageType.isMetalDamage) return { r: 255, g: 210, b: 80 };//毒/金属性伤害
  if (damageType.isWoodDamage) return { r: 120, g: 255, b: 120 };//风/木属性伤害
  if (damageType.isLightDamage) return { r: 255, g: 255, b: 170 };//光属性伤害
  if (damageType.isDarkDamage) return { r: 180, g: 130, b: 255 };//暗属性伤害
  if (damageType.isPhysicalDamage) return { r: 160, g: 82, b: 45 };//物理伤害（棕色）
  if (damageType.isMagicDamage) return { r: 120, g: 140, b: 255 };//魔法伤害
  //兜底颜色代码，先普攻色/精神/强化色，避免被物理/魔法伤害抢色。
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_MIND) return { r: 255, g: 255, b: 155 };//精神伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_ENHANCED) return { r: 255, g: 140, b: 0 };//强化伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_FIRE) return { r: 255, g: 66, b: 66 };//火属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_COLD) return { r: 80, g: 190, b: 255 };//水/冰属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_LIGHTNING) return { r: 170, g: 220, b: 255 };//雷属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_POISON) return { r: 255, g: 210, b: 80 };//金/毒属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_SLOW_POISON) return { r: 255, g: 210, b: 80 };//金/毒属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_ACID) return { r: 255, g: 210, b: 80 };//金/毒属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_DISEASE) return { r: 255, g: 210, b: 80 };//金/毒属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_PLANT) return { r: 120, g: 255, b: 120 };//风/木属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_DIVINE) return { r: 255, g: 255, b: 170 };//光属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_SHADOW_STRIKE) return { r: 180, g: 130, b: 255 };//暗属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_SONIC) return { r: 255, g: 160, b: 255 };//音速属性伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_MAGIC) return { r: 120, g: 140, b: 255 };//魔法伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_NORMAL) return { r: 160, g: 82, b: 45 };//物理伤害兜底
  if (damageType.rawDamageType === jass.DAMAGE_TYPE_UNIVERSAL) return { r: 255, g: 255, b: 255 };//通用伤害兜底
  return { r: 255, g: 255, b: 255 };
}

function 销毁单位数字特效(this: void, d: 单位数字特效): void {
  if (d.effect == null || d.effect === 0) return;
  DestroyEffect(d.effect);
}

function 移除伤害数字实例(this: void, id: number): void {
  const inst = 实例表[id];
  if (inst == null) return;
  实例表[id] = undefined;
  for (let i = 0; i < inst.effects.length; i++) {
    销毁单位数字特效(inst.effects[i]);
  }
  const idx = 实例ID列表.indexOf(id);
  if (idx >= 0) 实例ID列表.splice(idx, 1);
}

function 确保计时器(this: void): void {
  if (已注册Tick) return;
  已注册Tick = true;
  onTick10ms(驱动伤害数字);
}

function 尝试停止计时器(this: void): void {
  if (!已注册Tick) return;
  if (实例ID列表.length > 0) return;
  已注册Tick = false;
  offTick10ms(驱动伤害数字);
}

function 创建数字特效(this: void, digit: number, x: number, y: number, z: number, color: { r: number; g: number; b: number }): 单位数字特效 | null {
  const modelPath = 模型基础路径 + tostring(digit) + 模型扩展名;
  const effect = AddSpecialEffect(modelPath, x, y);
  if (effect == null || effect === 0) {
    return null;
  }

  if (typeof EXSetEffectZ === "function") {
    EXSetEffectZ(effect, z);
  }
  if (typeof DzSetEffectVisible === "function") {
    DzSetEffectVisible(effect, true);
  }
  if (typeof DzSetEffectScale === "function") {
    DzSetEffectScale(effect, 模型缩放);
  }
  if (typeof DzSetEffectAnimation === "function") {
    DzSetEffectAnimation(effect, 模型动画索引, 0);
  }
  if (typeof DzGetColor === "function" && typeof DzSetEffectVertexColor === "function") {
    const colorValue = DzGetColor(
      255,
      限制颜色字节(color.r),
      限制颜色字节(color.g),
      限制颜色字节(color.b),
    );
    DzSetEffectVertexColor(effect, colorValue);
  }

  return { effect, xOffset: 0 };
}

function 创建伤害数字(this: void, target: any, amount: number, source: any, damageType: 伤害类型快照): void {
  const text = tostring(amount);
  const len = text.length;
  if (len <= 0) return;

  const startX = GetUnitX(target);
  const startY = GetUnitY(target);
  const startZ = GetUnitFlyHeight(target) + 基础Z偏移;
  const color = 选取伤害颜色(damageType);

  const effects: 单位数字特效[] = [];
  let left = -((len - 1) * 数字间距) / 2;
  for (let i = 0; i < len; i++) {
    const ch = text.charAt(i);
    const digit = ch.charCodeAt(0) - 48;
    if (digit < 0 || digit > 9) {
      left += 数字间距;
      continue;
    }
    const x = startX + left;
    const e = 创建数字特效(digit, x, startY, startZ, color);
    if (e != null) {
      e.xOffset = left;
      effects.push(e);
    }
    left += 数字间距;
  }
  if (effects.length <= 0) return;

  const id = ++下一个实例ID;
  实例表[id] = {
    id,
    target,
    source,
    elapsed: 0,
    duration: 上浮持续时间,
    startX,
    startY,
    startZ,
    riseHeight: 上浮高度,
    effects,
  };
  实例ID列表.push(id);
  确保计时器();
}

function 驱动伤害数字(this: void): void {
  let i = 0;
  while (i < 实例ID列表.length) {
    const id = 实例ID列表[i];
    const inst = 实例表[id];
    if (inst == null) {
      实例ID列表.splice(i, 1);
      continue;
    }

    if (!单位存活(inst.target)) {
      移除伤害数字实例(id);
      continue;
    }

    inst.elapsed += 0.01;
    const t = inst.elapsed / inst.duration;
    if (t >= 1) {
      移除伤害数字实例(id);
      continue;
    }

    const x = GetUnitX(inst.target);
    const y = GetUnitY(inst.target);
    const z = GetUnitFlyHeight(inst.target) + 基础Z偏移 + inst.riseHeight * t;

    for (let k = 0; k < inst.effects.length; k++) {
      const d = inst.effects[k];
      if (d.effect == null || d.effect === 0) continue;
      if (typeof EXSetEffectXY === "function") {
        EXSetEffectXY(d.effect, x + d.xOffset, y);
      }
      if (typeof EXSetEffectZ === "function") {
        EXSetEffectZ(d.effect, z);
      }
    }
    i++;
  }
  尝试停止计时器();
}

function 应用最终伤害时(this: void, target: any, attacker: any, applied: number, damageType: 伤害类型快照): void {
  if (!已启用) return;
  if (!单位存活(target)) return;

  const value = 转为显示整数伤害(applied);
  if (value < 最小显示伤害) return;
  创建伤害数字(target, value, attacker, damageType);
}

export function 初始化伤害数字模型显示(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  registerAppliedFinalDamageListener(应用最终伤害时);
}

// 兼容旧入口命名，避免初始化链断开。
export function initDamageNumberModelDisplay(this: void): void {
  初始化伤害数字模型显示();
}

export {};
