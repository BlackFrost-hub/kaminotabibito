/** @noSelfInFile */

/**
 * 欧尔贝克 - Q：横一字斩 / 十字斩
 *
 * 源 JASS：OEBR 触发器 A0IY 分支。
 * - 沿施法方向冲锋（0.35 秒前摇后开始，每游戏驱动周期 20 码）。
 * - 到达落点后对 500 码内、前方 ±140° 扇区的敌人造成
 *   攻击力 × (180% + 10% × 等级) 物理伤害并眩晕。
 * - 若施法时拥有「积攒」Buff：消耗积攒 → 十字斩（伤害提升为必暴击、
 *   眩晕 1.5 秒）；否则为横一字斩（眩晕 0.75 秒）。
 *   注：源 JASS 的十字斩必暴击通过临时 +100% 暴击率实现，TS 技能伤害管线
 *   不逐条回滚暴击，这里保留更高眩晕作为十字斩的额外收益。
 */

import { 欧尔贝克单位技能配置 } from "./00．配置";
import { 播放欧尔贝克单位音效, 播放欧尔贝克配置动作 } from "./00A．表现工具";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, unit: any, abilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 单位存活, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    面向角度?: number;
    Z轴角度?: number;
    缩放?: number;
    持续秒?: number;
  }) => any;
};
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { 单位拥有原生Buff, 单位是指定类型 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  单位拥有原生Buff: (this: void, unit: any, buffId: number) => boolean;
  单位是指定类型: (this: void, unit: any, typeId: number) => boolean;
};

const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const Q技能ID = stringToFourCCSafe(欧尔贝克单位技能配置.Q技能ID);
const 欧尔贝克单位类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.单位类型ID);
const 积攒Buff类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.积攒BuffID);
/** 源 JASS 以 0.00 周期驱动每次移动 20 码（默认 0.03125 秒/周期） */
const 冲刺每秒速度 = 欧尔贝克单位技能配置.Q.冲刺步距 / 0.03125;

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (this: void, unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;

function 归一化角度(this: void, angle: number): number {
  let result = angle % 360;
  if (result < 0) result += 360;
  return result;
}

/** 返回两角度在 0~180 范围内的最小夹角 */
function 角度差(this: void, a: number, b: number): number {
  let diff = Math.abs(归一化角度(a) - 归一化角度(b));
  if (diff > 180) diff = 360 - diff;
  return diff;
}

interface 结算上下文 {
  施法者: any;
  方向角: number;
  伤害值: number;
  十字斩: boolean;
  命中范围: number;
  扇形半角: number;
}

function 判断是否命中扇形(this: void, 上下文: 结算上下文, target: any): boolean {
  const 施法者 = 上下文.施法者;
  const 朝向 = 归一化角度(GetUnitFacing(施法者));
  const 目标角度 = 归一化角度(两点角度(GetUnitX(施法者), GetUnitY(施法者), GetUnitX(target), GetUnitY(target)));
  return 角度差(目标角度, 朝向) <= 上下文.扇形半角;
}

function 命中目标筛选(this: void, 上下文: 结算上下文, target: any): boolean {
  if (target == null || target === 0 || target === 上下文.施法者) return false;
  if (!单位存活(target)) return false;
  if (IsUnitType(target, UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(target, UNIT_TYPE_MECHANICAL)) return false;
  if (IsUnitType(target, UNIT_TYPE_STRUCTURE)) return false;
  if (!isUnitEnemy(target, 上下文.施法者)) return false;
  return 判断是否命中扇形(上下文, target);
}

function 结算Q落点(this: void, 上下文: 结算上下文): void {
  const cfg = 欧尔贝克单位技能配置.Q;
  const 施法者 = 上下文.施法者;
  const casterX = GetUnitX(施法者);
  const casterY = GetUnitY(施法者);

  创建点特效({
    模型路径: cfg.冲刺特效模型,
    X: casterX,
    Y: casterY,
    面向角度: 上下文.方向角,
    缩放: cfg.冲刺特效缩放X,
    持续秒: cfg.冲刺特效持续秒,
  });
  创建点特效({
    模型路径: cfg.落点特效模型,
    X: casterX,
    Y: casterY,
    Z: 0,
    缩放: cfg.落点特效缩放X,
    持续秒: cfg.落点特效持续秒,
  });
  if (上下文.十字斩) {
    创建点特效({
      模型路径: cfg.冲刺特效模型,
      X: casterX + Math.cos(上下文.方向角 * Math.PI / 180) * 125,
      Y: casterY + Math.sin(上下文.方向角 * Math.PI / 180) * 125,
      Z: 175,
      面向角度: 上下文.方向角,
      缩放: cfg.冲刺特效缩放X,
      持续秒: cfg.冲刺特效持续秒,
    });
  }

  const targets = getUnitsInRange(casterX, casterY, 上下文.命中范围);
  const 眩晕秒 = 上下文.十字斩 ? cfg.十字眩晕秒 : cfg.眩晕秒;
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!命中目标筛选(上下文, target)) continue;
    施加眩晕(施法者, target, 眩晕秒, 上下文.十字斩 ? "十字斩" : "横一字斩", "技能");
    造成单体技能伤害({
      来源: 施法者,
      目标: target,
      伤害: 上下文.伤害值,
      伤害类型: DAMAGE_TYPE_NORMAL,
      attack: true,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: Q技能ID,
      标签: 上下文.十字斩 ? "欧尔贝克-十字斩" : "欧尔贝克-横一字斩",
      伤害形态: "单体",
      参与技能伤害加成: true,
    });
  }
}

function onQ冲锋结束(this: void, caster: any, reason: string, _位移ID: number): void {
  if (!单位存活(caster)) return;
  if (reason !== "完成" && reason !== "撞墙") return;
  const 上下文 = onQ冲锋结束上下文;
  if (上下文 == null || 上下文.施法者 !== caster) return;
  onQ冲锋结束上下文 = undefined;
  结算Q落点(上下文);
}

let onQ冲锋结束上下文: 结算上下文 | undefined;

function on欧尔贝克Q(this: void, caster: any, abilityId: number): void {
  if (abilityId !== Q技能ID) return;
  if (!单位是指定类型(caster, 欧尔贝克单位类型ID)) return;

  const cfg = 欧尔贝克单位技能配置.Q;
  const level = GetUnitAbilityLevel(caster, Q技能ID);
  const startX = GetUnitX(caster);
  const startY = GetUnitY(caster);
  const targetX = GetSpellTargetX();
  const targetY = GetSpellTargetY();
  const 方向角 = 两点角度(startX, startY, targetX, targetY);
  const 距离 = Math.sqrt((targetX - startX) * (targetX - startX) + (targetY - startY) * (targetY - startY));
  const 伤害值 = 读取单位攻击力(caster) * (cfg.基础攻击力倍率 + cfg.每级攻击力倍率 * level);

  const 十字斩 = 单位拥有原生Buff(caster, 积攒Buff类型ID);
  if (十字斩) {
    UnitRemoveAbility(caster, 积攒Buff类型ID);
    播放欧尔贝克单位音效(caster, cfg.十字全局音效键);
  } else {
    播放欧尔贝克单位音效(caster, cfg.全局音效键);
  }
  // 起手动作：时间缩放 2.0 + 动作序号 3（对应源 JASS SetUnitTimeScale/SetUnitAnimationByIndex）
  播放欧尔贝克配置动作(caster, 3, 2.0);

  addDelayedCallback(cfg.延迟秒 * 1000, () => {
    if (!单位存活(caster)) return;
    onQ冲锋结束上下文 = {
      施法者: caster,
      方向角,
      伤害值,
      十字斩,
      命中范围: cfg.命中范围,
      扇形半角: cfg.扇形半角,
    };
    开始冲锋(caster, {
      角度: 方向角,
      距离,
      每秒速度: 冲刺每秒速度,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      朝向跟随位移: true,
      动画序号: 3,
      结束回调: onQ冲锋结束,
    });
  });
}

registerSpellEffectListener(on欧尔贝克Q);

export {};
