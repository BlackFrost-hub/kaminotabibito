/** @noSelfInFile */

const { 是否在前方 } = require("lib.扩展函数.Star扩展函数.Star扩展库.11．方位判断函数") as {
  是否在前方: (this: void, unit: any, target: any) => boolean;
};
import { 注册最终伤害触发模板 } from "../../../03．技能系统/00．技能模板+函数/00．技能模板/08．装备触发模板";
import { 创建伤害修正阈值触发 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/13．伤害修正阈值触发";
import { 造成装备伤害 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/10．装备战斗执行";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const UNIT_TYPE_MELEE_ATTACKER = jass.UNIT_TYPE_MELEE_ATTACKER as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

const 格挡大盾近战范围 = 200;
const 格挡大盾近战范围平方 = 格挡大盾近战范围 * 格挡大盾近战范围;
const 格挡大盾普通前方减伤 = 0.15;
const 格挡大盾近战前方减伤 = 0.30;
const 格挡大盾盾击护甲系数 = 1.40;
const 单位护甲状态 = ConvertUnitState(0x20);

let 已初始化格挡大盾 = false;

function 取单位距离平方(this: void, unitA: any, unitB: any): number {
  const dx = GetUnitX(unitA) - GetUnitX(unitB);
  const dy = GetUnitY(unitA) - GetUnitY(unitB);
  return dx * dx + dy * dy;
}

function 是否近战普攻(this: void, source: any, target: any, snapshot: any): boolean {
  if (source == null || source === 0 || target == null || target === 0) return false;
  if (snapshot == null || snapshot.isNormalAttack !== true) return false;
  if (IsUnitType(source, UNIT_TYPE_MELEE_ATTACKER) !== true) return false;
  return 取单位距离平方(source, target) <= 格挡大盾近战范围平方;
}

function 取单位护甲(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetUnitStateJapi(unit, 单位护甲状态);
}

function 格挡大盾减伤过滤(this: void, event: any): boolean {
  const context = event.上下文;
  if (context.isTrueDamage === true) return false;
  const target = context.target;
  const attacker = context.attacker;
  if (target == null || target === 0 || attacker == null || attacker === 0) return false;
  return 是否在前方(target, attacker);
}

function 计算格挡大盾减伤(this: void, event: any): number {
  const context = event.上下文;
  const target = context.target;
  const attacker = context.attacker;
  const 减伤比例 = 是否近战普攻(attacker, target, context) ? 格挡大盾近战前方减伤 : 格挡大盾普通前方减伤;
  return context.currentDamage * (1 - 减伤比例);
}

function on格挡大盾盾击(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (target == null || target === 0 || attacker == null || attacker === 0) return;
  if (!(applied >= 1)) return;
  if (snapshot != null && snapshot.isTrueDamage === true) return;
  if (!是否近战普攻(attacker, target, snapshot)) return;

  const 伤害值 = 取单位护甲(attacker) * 格挡大盾盾击护甲系数;
  if (!(伤害值 > 0)) return;
  造成装备伤害(attacker, target, 伤害值, DAMAGE_TYPE_ENHANCED, false, WEAPON_TYPE_METAL_HEAVY_BASH, { 伤害形态: "单体" });
}

export function 初始化格挡大盾(this: void): void {
  if (已初始化格挡大盾) return;
  已初始化格挡大盾 = true;
  创建伤害修正阈值触发({
    名称: "格挡大盾前方减伤",
    装备名: "格挡大盾",
    持有者: "受击者",
    优先级: 35,
    过滤伤害: 格挡大盾减伤过滤,
    计算伤害: 计算格挡大盾减伤,
  });
  注册最终伤害触发模板({
    名称: "格挡大盾盾击",
    装备名: "格挡大盾",
    持有者: "攻击者",
    伤害过滤: "任意",
    自定义过滤: function 格挡大盾盾击过滤(this: void, event): boolean {
      const snapshot = event.伤害快照;
      if (snapshot != null && snapshot.isTrueDamage === true) return false;
      return 是否近战普攻(event.攻击者, event.目标, snapshot);
    },
    on触发: function on格挡大盾盾击触发(this: void, event): void {
      on格挡大盾盾击(event.目标, event.攻击者, event.本次伤害, event.伤害快照);
    },
  });
}

初始化格挡大盾();

export {};
