/** @noSelfInFile */
/**
 * 冲锋残影表现模板
 *
 * 说明：
 * 1. 这是“冲锋位移 + 表现”的组合模板，不修改冲锋/击退底层。
 * 2. 残影改用特效模拟，不再用马甲单位。
 * 3. `DzSetEffectAnimation` / `DzPlayEffectAnimation` 为平台扩展 API，可能只在平台环境可用。
 * 4. 残影生命周期统一交给 `YDWETimerDestroyEffect`，其底层走中心计时器回收。
 */

const jass = require("jass.common") as any;
let japi: any = null;
try {
  japi = require("jass.japi") as any;
} catch (_e) {
  japi = null;
}

const {
  开始冲锋,
  获取单位当前位移ID,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统") as {
  开始冲锋: (单位: any, 参数: any) => number;
  获取单位当前位移ID: (单位: any) => number;
};

const {
  YDWETimerDestroyEffect,
  getObjectProperty,
  ObjectType,
} = require("lib.扩展函数.YDWE函数.00．YDWE函数") as {
  YDWETimerDestroyEffect: (duration: number, effect: any) => void;
  getObjectProperty: (objectType: number, objectId: number | string, property: string) => string;
  ObjectType: { UNIT: number };
};

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: () => void) => void;
  offTick10ms: (this: void, callback: () => void) => void;
};

const AddSpecialEffect = jass["AddSpecialEffect"] as (model: string, x: number, y: number) => any;
const GetUnitX = jass["GetUnitX"] as (u: any) => number;
const GetUnitY = jass["GetUnitY"] as (u: any) => number;
const GetUnitTypeId = jass["GetUnitTypeId"] as (u: any) => number;
const GetUnitState = jass["GetUnitState"] as (u: any, state: any) => number;
const SetUnitAnimationByIndex = jass["SetUnitAnimationByIndex"] as (u: any, index: number) => void;
const SetUnitAnimation = jass["SetUnitAnimation"] as (u: any, anim: string) => void;
const SetUnitTimeScale = jass["SetUnitTimeScale"] as (u: any, scale: number) => void;
const GetUnitFlyHeight = jass["GetUnitFlyHeight"] as (u: any) => number;
const SetUnitFlyHeight = jass["SetUnitFlyHeight"] as (u: any, height: number, rate: number) => void;
const UnitAddAbility = jass["UnitAddAbility"] as (u: any, abilityId: number) => void;
const UnitRemoveAbility = jass["UnitRemoveAbility"] as (u: any, abilityId: number) => void;
const R2I = jass["R2I"] as (value: number) => number;

const DzSetEffectAnimation = japi?.DzSetEffectAnimation as ((effect: any, index: number, flag: number) => void) | undefined;
const DzPlayEffectAnimation = japi?.DzPlayEffectAnimation as ((effect: any, anim: string, link: string) => void) | undefined;
const DzSetEffectVertexColor = japi?.DzSetEffectVertexColor as ((effect: any, color: number) => void) | undefined;
const DzSetEffectVertexAlpha = japi?.DzSetEffectVertexAlpha as ((effect: any, alpha: number) => void) | undefined;
const DzSetEffectScale = japi?.DzSetEffectScale as ((effect: any, scale: number) => void) | undefined;
const EXSetEffectXY = japi?.EXSetEffectXY as ((effect: any, x: number, y: number) => void) | undefined;
const EXSetEffectZ = japi?.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;
const EXSetEffectSize = japi?.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const EXSetEffectSpeed = japi?.EXSetEffectSpeed as ((effect: any, speed: number) => void) | undefined;

const TICK_INTERVAL = 0.01;
const UNIT_ALIVE_LIFE = 0.405;
const DEFAULT_AFTERIMAGE_INTERVAL = 0.05;
const DEFAULT_AFTERIMAGE_LIFETIME = 0.35;
const DEFAULT_AFTERIMAGE_ALPHA = 160;
const DEFAULT_AFTERIMAGE_SCALE = 1.0;
const DEFAULT_ANIMATION_SPEED = 1.0;
const CROW_FORM_ABILITY_ID = 1097691750;

export interface 冲锋残影表现参数 {
  动画序号?: number;
  动画名?: string;
  动画速度?: number;
  残影单位类型?: number | string;
  残影模型?: string;
  残影生命周期?: number;
  残影透明度?: number;
  染色R?: number;
  染色G?: number;
  染色B?: number;
  残影生成间隔?: number;
  飞行高度变化?: number;
  残影缩放?: number;
}

interface 冲锋残影表现实例 {
  冲锋ID: number;
  单位: any;
  残影模型: string;
  动画序号?: number;
  动画名?: string;
  动画速度: number;
  残影生命周期: number;
  残影透明度: number;
  染色R: number;
  染色G: number;
  染色B: number;
  残影生成间隔: number;
  下次生成剩余时间: number;
  飞行高度变化: number;
  已应用飞行高度变化: boolean;
  残影缩放: number;
}

const 活动冲锋残影表现列表: 冲锋残影表现实例[] = [];
const 冲锋残影表现映射: Record<number, 冲锋残影表现实例 | undefined> = {};
let 已注册到中心计时器 = false;

function 单位存活(u: any): boolean {
  return u != null && u !== 0 && GetUnitState(u, jass.UNIT_STATE_LIFE) > UNIT_ALIVE_LIFE;
}

function 限制到字节(v: number): number {
  if (v <= 0) return 0;
  if (v >= 255) return 255;
  return R2I(v);
}

function 组装颜色值(r: number, g: number, b: number): number {
  return 限制到字节(r) * 65536 + 限制到字节(g) * 256 + 限制到字节(b);
}

function 确保单位可设置飞行高度(单位: any): void {
  UnitAddAbility(单位, CROW_FORM_ABILITY_ID);
  UnitRemoveAbility(单位, CROW_FORM_ABILITY_ID);
}

function 解析残影模型(单位: any, 参数: 冲锋残影表现参数): string {
  if (参数.残影模型 != null && 参数.残影模型 !== "") {
    return 参数.残影模型;
  }

  const 残影单位类型 = 参数.残影单位类型 ?? GetUnitTypeId(单位);
  if (残影单位类型 == null || 残影单位类型 === 0 || 残影单位类型 === "") {
    return "";
  }

  return getObjectProperty(ObjectType.UNIT, 残影单位类型, "file") || "";
}

function 应用单位动画表现(单位: any, 参数: 冲锋残影表现参数): void {
  if (参数.动画序号 != null) {
    SetUnitAnimationByIndex(单位, 参数.动画序号);
  } else if (参数.动画名 != null && 参数.动画名 !== "") {
    SetUnitAnimation(单位, 参数.动画名);
  }

  if (参数.动画速度 != null && 参数.动画速度 > 0) {
    SetUnitTimeScale(单位, 参数.动画速度);
  }
}

function 恢复单位表现(实例: 冲锋残影表现实例): void {
  if (实例.单位 != null && 实例.单位 !== 0) {
    SetUnitTimeScale(实例.单位, 1.0);
    if (实例.已应用飞行高度变化 && 实例.飞行高度变化 !== 0) {
      const 当前高度 = GetUnitFlyHeight(实例.单位);
      SetUnitFlyHeight(实例.单位, 当前高度 - 实例.飞行高度变化, 0);
      实例.已应用飞行高度变化 = false;
    }
  }
}

function 销毁冲锋残影表现实例(实例: 冲锋残影表现实例): void {
  恢复单位表现(实例);
  delete 冲锋残影表现映射[实例.冲锋ID];

  const idx = 活动冲锋残影表现列表.indexOf(实例);
  if (idx >= 0) {
    活动冲锋残影表现列表.splice(idx, 1);
  }

  if (活动冲锋残影表现列表.length === 0 && 已注册到中心计时器) {
    已注册到中心计时器 = false;
    offTick10ms(on冲锋残影表现Tick);
  }
}

function 创建一次残影(实例: 冲锋残影表现实例): void {
  const effect = AddSpecialEffect(实例.残影模型, GetUnitX(实例.单位), GetUnitY(实例.单位));
  if (effect == null || effect === 0) return;

  if (typeof EXSetEffectXY === "function") {
    EXSetEffectXY(effect, GetUnitX(实例.单位), GetUnitY(实例.单位));
  }
  if (typeof EXSetEffectZ === "function" && 实例.飞行高度变化 !== 0) {
    EXSetEffectZ(effect, 实例.飞行高度变化);
  }
  if (typeof DzSetEffectScale === "function") {
    DzSetEffectScale(effect, 实例.残影缩放);
  }
  if (typeof EXSetEffectSize === "function") {
    EXSetEffectSize(effect, 实例.残影缩放);
  }
  if (typeof EXSetEffectSpeed === "function") {
    EXSetEffectSpeed(effect, 实例.动画速度);
  }
  if (typeof DzSetEffectAnimation === "function" && 实例.动画序号 != null) {
    DzSetEffectAnimation(effect, 实例.动画序号, 0);
  }
  if (typeof DzPlayEffectAnimation === "function" && 实例.动画名 != null && 实例.动画名 !== "") {
    DzPlayEffectAnimation(effect, 实例.动画名, "");
  }
  if (typeof DzSetEffectVertexColor === "function") {
    DzSetEffectVertexColor(effect, 组装颜色值(实例.染色R, 实例.染色G, 实例.染色B));
  }
  if (typeof DzSetEffectVertexAlpha === "function") {
    DzSetEffectVertexAlpha(effect, 实例.残影透明度);
  }

  YDWETimerDestroyEffect(实例.残影生命周期, effect);
}

function on冲锋残影表现Tick(): void {
  let i = 0;
  while (i < 活动冲锋残影表现列表.length) {
    const 实例 = 活动冲锋残影表现列表[i];
    if (!单位存活(实例.单位) || 获取单位当前位移ID(实例.单位) !== 实例.冲锋ID) {
      销毁冲锋残影表现实例(实例);
      continue;
    }

    实例.下次生成剩余时间 -= TICK_INTERVAL;
    if (实例.下次生成剩余时间 <= 0) {
      创建一次残影(实例);
      实例.下次生成剩余时间 += 实例.残影生成间隔;
    }
    i += 1;
  }
}

function 注册到中心计时器(): void {
  if (已注册到中心计时器) return;
  已注册到中心计时器 = true;
  onTick10ms(on冲锋残影表现Tick);
}

export function 开始冲锋并附带残影表现(单位: any, 位移参数: any, 表现参数: 冲锋残影表现参数): number {
  const 冲锋ID = 开始冲锋(单位, 位移参数);
  if (冲锋ID <= 0) return 0;

  const 残影模型 = 解析残影模型(单位, 表现参数);
  if (残影模型 === "") {
    return 冲锋ID;
  }

  应用单位动画表现(单位, 表现参数);

  const 飞行高度变化 = 表现参数.飞行高度变化 ?? 0;
  if (飞行高度变化 !== 0) {
    确保单位可设置飞行高度(单位);
    SetUnitFlyHeight(单位, GetUnitFlyHeight(单位) + 飞行高度变化, 0);
  }

  const 实例: 冲锋残影表现实例 = {
    冲锋ID,
    单位,
    残影模型,
    动画序号: 表现参数.动画序号,
    动画名: 表现参数.动画名,
    动画速度: 表现参数.动画速度 != null && 表现参数.动画速度 > 0 ? 表现参数.动画速度 : DEFAULT_ANIMATION_SPEED,
    残影生命周期: 表现参数.残影生命周期 != null && 表现参数.残影生命周期 > 0 ? 表现参数.残影生命周期 : DEFAULT_AFTERIMAGE_LIFETIME,
    残影透明度: 表现参数.残影透明度 != null ? 限制到字节(表现参数.残影透明度) : DEFAULT_AFTERIMAGE_ALPHA,
    染色R: 表现参数.染色R != null ? 限制到字节(表现参数.染色R) : 255,
    染色G: 表现参数.染色G != null ? 限制到字节(表现参数.染色G) : 255,
    染色B: 表现参数.染色B != null ? 限制到字节(表现参数.染色B) : 255,
    残影生成间隔: 表现参数.残影生成间隔 != null && 表现参数.残影生成间隔 > 0 ? 表现参数.残影生成间隔 : DEFAULT_AFTERIMAGE_INTERVAL,
    下次生成剩余时间: 0,
    飞行高度变化,
    已应用飞行高度变化: 飞行高度变化 !== 0,
    残影缩放: 表现参数.残影缩放 != null && 表现参数.残影缩放 > 0 ? 表现参数.残影缩放 : DEFAULT_AFTERIMAGE_SCALE,
  };

  冲锋残影表现映射[冲锋ID] = 实例;
  活动冲锋残影表现列表.push(实例);
  创建一次残影(实例);
  实例.下次生成剩余时间 = 实例.残影生成间隔;
  注册到中心计时器();
  return 冲锋ID;
}

export {};
