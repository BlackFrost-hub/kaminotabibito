/** @noSelfInFile */

import { 提米诺斯单位技能配置 } from "./00．配置";
import { 播放提米诺斯单位音效, 播放提米诺斯配置动作 } from "./00A．表现工具";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, unit: any, abilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { 读取单位攻击力, 单位存活, 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
  极坐标X: (this: void, x: number, angle: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angle: number, distance: number) => number;
};
const { 执行战斗自身传送到坐标 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.20．位移技能限制") as {
  执行战斗自身传送到坐标: (this: void, unit: any, x: number, y: number) => boolean;
};
const { 造成批量AOE技能伤害, 创建独立技能伤害实例, 绑定单位当前独立技能伤害实例, 注册技能伤害实例结束监听 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
  创建独立技能伤害实例: (this: void, params: any) => number;
  绑定单位当前独立技能伤害实例: (this: void, unit: any, id: number) => void;
  注册技能伤害实例结束监听: (this: void, callback: (this: void, id: number) => void) => void;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { applyManaSteal } = require("系统.04．伤害系统.00．伤害计算.03．吸血吸魔") as {
  applyManaSteal: (this: void, attacker: any, mana: number, showText?: boolean) => void;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

interface D记录 {
  caster: any;
  target: any;
  originX: number;
  originY: number;
  facing: number;
  damage: number;
  skillInstanceId: number;
}

const D技能ID = stringToFourCCSafe(提米诺斯单位技能配置.D技能ID);
const 提米诺斯单位ID = stringToFourCCSafe(提米诺斯单位技能配置.单位类型ID);
const EXSetUnitMoveType = japi.EXSetUnitMoveType as (this: void, unit: any, moveType: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const 提米诺斯D技能实例表: Record<number, true> = {};

function on提米诺斯D最终伤害(this: void, _target: any, attacker: any, applied: number, snapshot: any): void {
  const skillInstanceId = snapshot?.skillInstanceId as number | undefined;
  if (!(applied > 0) || attacker == null || snapshot?.abilityId !== D技能ID || skillInstanceId == null) return;
  if (提米诺斯D技能实例表[skillInstanceId] !== true || jass.GetUnitTypeId(attacker) !== 提米诺斯单位ID) return;
  applyManaSteal(attacker, applied * 提米诺斯单位技能配置.D.实际伤害回魔比例, true);
}

function on提米诺斯D技能实例结束(this: void, skillInstanceId: number): void {
  if (提米诺斯D技能实例表[skillInstanceId] === true) delete 提米诺斯D技能实例表[skillInstanceId];
}

function 提米诺斯D播放动作(this: void, variable?: any): void {
  const record = variable as D记录 | undefined;
  if (record == null || !单位存活(record.caster)) return;
  jass.SetUnitFacing(record.caster, record.facing);
  japi.EXSetUnitFacing(record.caster, record.facing);
  播放提米诺斯配置动作(record.caster, 提米诺斯单位技能配置.D.动作编号, 提米诺斯单位技能配置.D.动作速度);
}

function 提米诺斯D结算(this: void, variable?: any): void {
  const record = variable as D记录 | undefined;
  if (record == null || !单位存活(record.caster)) return;
  const cfg = 提米诺斯单位技能配置.D;
  const centerX = record.target != null && record.target !== 0 ? jass.GetUnitX(record.target) : jass.GetUnitX(record.caster);
  const centerY = record.target != null && record.target !== 0 ? jass.GetUnitY(record.target) : jass.GetUnitY(record.caster);
  const targets = getEnemyUnitsInRange(record.caster, centerX, centerY, cfg.伤害范围);
  造成批量AOE技能伤害({
    来源: record.caster, 目标列表: targets, 伤害: record.damage, 伤害类型: jass.DAMAGE_TYPE_NORMAL,
    attack: true, ranged: false, attackType: jass.ATTACK_TYPE_NORMAL, weaponType: jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
    来源类型: "单位技能", 技能ID: D技能ID, 技能实例ID: record.skillInstanceId,
    标签: "提米诺斯-吸魔权杖", 参与技能伤害加成: true,
  });
  执行战斗自身传送到坐标(record.caster, record.originX, record.originY);
  创建点特效({
    模型路径: cfg.返回特效模型, X: jass.GetUnitX(record.caster), Y: jass.GetUnitY(record.caster), Z: cfg.返回特效Z,
    Z轴角度: cfg.返回特效Z轴角度, 缩放: cfg.返回特效缩放, 持续秒: cfg.返回特效持续秒,
  });
  EXSetUnitMoveType(record.caster, 0x02);
  jass.SetUnitTimeScale(record.caster, 1);
}

function on提米诺斯D(this: void, caster: any, abilityId: number): void {
  if (abilityId !== D技能ID || jass.GetUnitTypeId(caster) !== 提米诺斯单位ID) return;
  const target = jass.GetSpellTargetUnit();
  if (!单位存活(target)) return;
  const cfg = 提米诺斯单位技能配置.D;
  const targetFacing = jass.GetUnitFacing(target) as number;
  const skillInstanceId = 创建独立技能伤害实例({ 技能ID: D技能ID, 来源类型: "单位技能", 标签: "提米诺斯-吸魔权杖", 持续时间秒: 1 });
  提米诺斯D技能实例表[skillInstanceId] = true;
  绑定单位当前独立技能伤害实例(caster, skillInstanceId);
  const record: D记录 = {
    caster, target,
    originX: jass.GetUnitX(caster), originY: jass.GetUnitY(caster),
    facing: targetFacing + 180,
    damage: 读取单位攻击力(caster) * cfg.攻击力倍率,
    skillInstanceId,
  };
  开始硬直(caster, cfg.硬直秒);
  EXSetUnitMoveType(caster, 0x04);
  SetUnitAnimation(caster, "stand");
  jass.SetUnitTimeScale(caster, cfg.动作速度);
  执行战斗自身传送到坐标(caster, 极坐标X(jass.GetUnitX(target), targetFacing, cfg.目标偏移距离), 极坐标Y(jass.GetUnitY(target), targetFacing, cfg.目标偏移距离));
  播放提米诺斯单位音效(caster, cfg.全局音效键);
  addDelayedCallback(cfg.动作延迟秒 * 1000, 提米诺斯D播放动作, record);
  addDelayedCallback((cfg.动作延迟秒 + cfg.伤害延迟秒) * 1000, 提米诺斯D结算, record);
}

registerSpellEffectListener(on提米诺斯D);
registerAppliedFinalDamageListener(on提米诺斯D最终伤害);
注册技能伤害实例结束监听(on提米诺斯D技能实例结束);

export {};
