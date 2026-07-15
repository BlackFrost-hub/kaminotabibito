/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 获取或创建米亚上下文 } from "./03．运行时上下文";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置, 米亚运行时配置 } from "./02．数值与表现配置";
import { 播放米亚台词 } from "./15．台词播放";
import { 取米亚污染标记伤害倍率 } from "./08．污染标记";
import { 取米亚平台超载伤害倍率 } from "./12．平台超载惩罚";
import { stringToFourCC, 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;

const BJ_RADTODEG = 57.29577951308232;
const 米亚单位类型ID = stringToFourCC(米亚单位技能配置.Boss单位ID);
const 腐化爪击技能ID = stringToFourCC(米亚单位技能配置.腐化爪击技能);
let 米亚腐化爪击已注册 = false;

function 让单位面向目标(this: void, caster: any, target: any): void {
  if (!单位有效(caster) || !单位有效(target)) return;
  const angle = Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster)) * BJ_RADTODEG;
  SetUnitFacing(caster, angle);
}

function 播放爪击表现(this: void, boss: any, target: any): void {
  if (!单位有效(target)) return;
  const config = 米亚技能数值配置.腐化爪击;
  创建点特效({
    模型路径: config.命中特效路径,
    X: GetUnitX(target),
    Y: GetUnitY(target),
    缩放: config.命中特效缩放,
    持续秒: config.命中特效持续秒,
  });
  SetUnitTimeScale(boss, config.动画速度);
  SetUnitAnimationByIndex(boss, config.动画编号);
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
    提示圈: { 类型: "敌方圆形" },
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
  播放米亚台词(boss, "腐化爪击");
  让单位面向目标(boss, actualTarget);
  播放爪击表现(boss, actualTarget);
  造成单体技能伤害({
    技能ID: 腐化爪击技能ID,
    来源: boss,
    目标: actualTarget,
    伤害: (读取单位攻击力(boss) || 米亚运行时配置.Boss攻击力兜底) * config.攻击力倍率 * 取米亚污染标记伤害倍率(context, actualTarget) * 取米亚平台超载伤害倍率(actualTarget),
    attackType: jass.ATTACK_TYPE_CHAOS,
    伤害类型: jass.DAMAGE_TYPE_POISON,
    weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "Boss技能",
  });
  添加米亚腐化感染(context, actualTarget, config.残留每秒腐化层数, "腐化爪击");
  创建腐化爪击残留区(context, GetUnitX(actualTarget), GetUnitY(actualTarget));
}

export function 注册米亚腐化爪击(this: void): void {
  if (米亚腐化爪击已注册) return;
  米亚腐化爪击已注册 = true;
  注册单位技能壳监听({
    名称: "米亚-腐化爪击",
    单位类型ID: 米亚单位类型ID,
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
