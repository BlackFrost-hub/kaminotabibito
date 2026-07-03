/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 获取或创建米亚上下文 } from "./03．运行时上下文";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置 } from "./02．数值与表现配置";
import { 播放米亚台词 } from "./15．台词播放";
import { 取米亚污染标记伤害倍率 } from "./08．污染标记";
import { 取米亚平台超载伤害倍率 } from "./12．平台超载惩罚";
import { stringToFourCC, 单位有效 } from "../../../00．技能模板+函数/02．通用函数/19．Boss公共工具";
import { 注册Boss技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．Boss技能壳监听注册器";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const GetUnitStateJapi = japi.GetUnitState as ((unit: any, state: any) => number) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;

const BJ_RADTODEG = 57.29577951308232;
const 米亚单位类型ID = stringToFourCC(米亚单位技能配置.Boss单位ID);
const 腐化爪击技能ID = stringToFourCC(米亚单位技能配置.腐化爪击技能);
let 米亚腐化爪击已注册 = false;

function 让单位面向目标(this: void, caster: any, target: any): void {
  if (!单位有效(caster) || !单位有效(target)) return;
  const angle = Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster)) * BJ_RADTODEG;
  SetUnitFacing(caster, angle);
}

function 取单位攻击力(this: void, unit: any): number {
  if (!单位有效(unit) || typeof GetUnitStateJapi !== "function") return 1000;
  const value = GetUnitStateJapi(unit, ConvertUnitState(0x15));
  return value > 0 ? value : 1000;
}

function 播放爪击表现(this: void, boss: any, target: any): void {
  if (!单位有效(target)) return;
  const effect = AddSpecialEffect("Common\\Effect\\Form\\ClawMark\\reapers_claws_green.mdx", GetUnitX(target), GetUnitY(target));
  if (effect != null && effect !== 0) {
    if (typeof EXSetEffectSize === "function") EXSetEffectSize(effect, 1.3);
    YDWETimerDestroyEffectSafe(1.2, effect);
  }
  SetUnitAnimationByIndex(boss, 7);
}

function 创建腐化爪击残留区(this: void, context: 米亚运行时上下文, x: number, y: number): void {
  const config = 米亚技能数值配置.腐化爪击;
  创建持续危险区域({
    X: x,
    Y: y,
    半径: config.残留半径,
    持续时间: config.残留持续秒,
    检测间隔: 1,
    影响目标: "敌方",
    所有者: context.Boss单位,
    模型路径: 米亚单位技能配置.特效.腐化残留云,
    特效高度: 0,
    显示提示圈: false,
    on周期: function 米亚腐化爪击残留区周期(this: void, 区域内单位: any[]): void {
      for (let i = 0; i < 区域内单位.length; i++) {
        添加米亚腐化感染(context, 区域内单位[i], config.残留每秒腐化层数, "腐化爪击残留");
      }
    },
  });
}

export function 释放米亚腐化爪击(this: void, context: 米亚运行时上下文, target?: any): void {
  const boss = context.Boss单位;
  const actualTarget = target;
  if (!单位有效(boss) || !单位有效(actualTarget)) return;

  const config = 米亚技能数值配置.腐化爪击;
  context.上次腐化爪击Ms = getServerTime();
  播放米亚台词(boss, "腐化爪击");
  让单位面向目标(boss, actualTarget);
  播放爪击表现(boss, actualTarget);
  UnitDamageTarget(boss, actualTarget, 取单位攻击力(boss) * config.攻击力倍率 * 取米亚污染标记伤害倍率(context, actualTarget) * 取米亚平台超载伤害倍率(actualTarget), false, false, jass.ATTACK_TYPE_CHAOS, jass.DAMAGE_TYPE_POISON, jass.WEAPON_TYPE_WHOKNOWS);
  添加米亚腐化感染(context, actualTarget, config.残留每秒腐化层数, "腐化爪击");
  创建腐化爪击残留区(context, GetUnitX(actualTarget), GetUnitY(actualTarget));
}

export function 注册米亚腐化爪击(this: void): void {
  if (米亚腐化爪击已注册) return;
  米亚腐化爪击已注册 = true;
  注册Boss技能壳监听({
    名称: "米亚-腐化爪击",
    Boss单位类型ID: 米亚单位类型ID,
    技能ID: 腐化爪击技能ID,
    获取或创建上下文: 获取或创建米亚上下文,
    释放技能: function 米亚腐化爪击监听释放(this: void, _context: 米亚运行时上下文, boss: any): void {
      on米亚腐化爪击生效(boss, 腐化爪击技能ID);
    },
  });
}

function on米亚腐化爪击生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 腐化爪击技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 米亚单位类型ID) return;
  const context = 获取或创建米亚上下文(castingUnit);
  if (context == null) return;
  释放米亚腐化爪击(context, GetSpellTargetUnit());
}
