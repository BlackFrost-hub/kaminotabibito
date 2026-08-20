/** @noSelfInFile */

/**
 * 欧尔贝克 - D：刚剑骑士
 *
 * 源 JASS：OEBR 触发器 A0J3 分支 + Hero伤害系统ZH 的掩护分支。
 * 对目标施放，按目标关系三分支：
 * - 自己：『防御』附加防御技能 S00C 并提升 50% 伤害减免，持续 3 秒；
 * - 友军：『掩护』标记目标 2 秒，期间目标受到单次伤害超过其最大生命 10% 时，
 *   取消该伤害，欧尔贝克瞬间移动到目标与伤害来源之间（目标身后 125 码），
 *   并获得 0.5 秒免伤；
 * - 敌军：『挑衅』底层嘲讽目标 1 秒（C020），并给目标加「相当于造成 30% 最大生命伤害」的仇恨，
 *   在自身位置播放挑衅特效。
 */

import { 欧尔贝克单位技能配置 } from "./00．配置";
import { 播放欧尔贝克单位音效, 播放欧尔贝克配置动作 } from "./00A．表现工具";
import { 欧尔贝克BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/17．欧尔贝克";

const jass = require("jass.common") as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, unit: any, abilityId: number) => void) => void;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 调整单位属性 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整单位属性: (this: void, 单位: any, 属性名: string, 增量: number) => void;
};
const { 增加生命比例仇恨 } = require("系统.01．单位系统.06．仇恨系统.06．对外接口") as {
  增加生命比例仇恨: (this: void, 敌人: any, 仇恨目标: any, 相当于最大生命比例: number) => void;
};
const { 施加嘲讽 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.index") as {
  施加嘲讽: (this: void, 来源单位: any, 目标单位: any, 参数: { 持续时间: number; 反伤倍率?: number }) => number;
};
const { 单位存活, 两点角度, 读取单位最大生命, 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
  读取单位最大生命: (this: void, unit: any) => number;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    Z轴角度?: number;
    缩放?: number;
    持续秒?: number;
  }) => any;
};
const { isUnitAlly, isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitAlly: (this: void, targetUnit: any, sourceUnit: any) => boolean;
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { 单位是指定类型 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  单位是指定类型: (this: void, unit: any, typeId: number) => boolean;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};

const D技能ID = stringToFourCCSafe(欧尔贝克单位技能配置.D技能ID);
const 防御技能类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.D.防御技能ID);
const 欧尔贝克单位类型ID = stringToFourCCSafe(欧尔贝克单位技能配置.单位类型ID);

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => void;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;

// 免疫伤害布尔属性（伤害系统 isImmuneDamage 读取）
const 免疫伤害属性名 = "免疫伤害";

interface 防御记录 {
  单位: any;
  到期回调ID: number;
}

interface 掩护记录 {
  目标: any;
  施法者: any;
  到期回调ID: number;
}

const 防御记录缓存: Record<number, 防御记录 | undefined> = {};
const 掩护记录缓存: Record<number, 掩护记录 | undefined> = {};

//=============================================================================
// 分支一：自己 - 防御
//=============================================================================

function 结束防御(this: void, id: number, record: 防御记录): void {
  if (防御记录缓存[id] !== record) return;
  const cfg = 欧尔贝克单位技能配置.D;
  if (单位存活(record.单位)) {
    UnitRemoveAbility(record.单位, 防御技能类型ID);
  }
  调整单位属性(record.单位, "伤害减少%", -cfg.防御减免);
  移除单位指定Buff(record.单位, 欧尔贝克BuffID.防御);
  delete 防御记录缓存[id];
}

function 施加防御(this: void, caster: any): void {
  const cfg = 欧尔贝克单位技能配置.D;
  const id = GetHandleId(caster);
  const old = 防御记录缓存[id];
  if (old != null && old.单位 === caster) {
    // 重复施法：仅刷新持续时间，避免属性叠加
    removeDelayedCallback(old.到期回调ID);
    old.到期回调ID = addDelayedCallback(cfg.防御持续秒 * 1000, () => 结束防御(id, old));
    registerManualBuff(caster, 欧尔贝克BuffID.防御, cfg.防御持续秒, cfg.防御减免, { sourceUnit: caster });
    return;
  }
  UnitAddAbility(caster, 防御技能类型ID);
  调整单位属性(caster, "伤害减少%", cfg.防御减免);
  const record: 防御记录 = { 单位: caster, 到期回调ID: 0 };
  防御记录缓存[id] = record;
  registerManualBuff(caster, 欧尔贝克BuffID.防御, cfg.防御持续秒, cfg.防御减免, { sourceUnit: caster });
  record.到期回调ID = addDelayedCallback(cfg.防御持续秒 * 1000, () => 结束防御(id, record));
}

//=============================================================================
// 分支二：友军 - 掩护
//=============================================================================

function 结束掩护(this: void, id: number, record: 掩护记录): void {
  if (掩护记录缓存[id] !== record) return;
  if (record.到期回调ID !== 0) removeDelayedCallback(record.到期回调ID);
  移除单位指定Buff(record.目标, 欧尔贝克BuffID.掩护);
  delete 掩护记录缓存[id];
}

function 施加掩护(this: void, caster: any, target: any): void {
  const cfg = 欧尔贝克单位技能配置.D;
  const id = GetHandleId(target);
  const old = 掩护记录缓存[id];
  if (old != null && old.目标 === target) {
    // 重复施法：刷新掩护来源与持续时间
    removeDelayedCallback(old.到期回调ID);
    old.施法者 = caster;
    old.到期回调ID = addDelayedCallback(cfg.掩护持续秒 * 1000, () => 结束掩护(id, old));
    registerManualBuff(target, 欧尔贝克BuffID.掩护, cfg.掩护持续秒, 0, { sourceUnit: caster });
    return;
  }
  const record: 掩护记录 = { 目标: target, 施法者: caster, 到期回调ID: 0 };
  掩护记录缓存[id] = record;
  registerManualBuff(target, 欧尔贝克BuffID.掩护, cfg.掩护持续秒, 0, { sourceUnit: caster });
  record.到期回调ID = addDelayedCallback(cfg.掩护持续秒 * 1000, () => 结束掩护(id, record));
}

/** 掩护触发：目标受到单次伤害超过最大生命 10% 时取消伤害并移动施法者 */
function 处理掩护伤害(this: void, context: any): number {
  const target = context.target;
  if (target == null || target === 0) return context.currentDamage;
  const id = GetHandleId(target);
  const record = 掩护记录缓存[id];
  if (record == null || record.目标 !== target) return context.currentDamage;

  const cfg = 欧尔贝克单位技能配置.D;
  const maxLife = 读取单位最大生命(target);
  if (!(context.currentDamage >= maxLife * cfg.掩护阈值生命比例)) return context.currentDamage;

  // 触发掩护：一次性（取消标记并清空缓存）
  结束掩护(id, record);
  const 施法者 = record.施法者;
  if (!单位存活(施法者)) return context.currentDamage;

  const attacker = context.attacker;
  const 方向角 = attacker != null && attacker !== 0
    ? 两点角度(GetUnitX(target), GetUnitY(target), GetUnitX(attacker), GetUnitY(attacker))
    : jass.GetUnitFacing(施法者);
  // 施法者瞬移到目标身后（朝伤害来源方向 125 码）
  SetUnitPosition(施法者, 极坐标X(GetUnitX(target), 方向角, cfg.掩护位移距离), 极坐标Y(GetUnitY(target), 方向角, cfg.掩护位移距离));
  // 施法者短暂免伤
  YDUserDataSetSafe("unit", 施法者, 免疫伤害属性名, "boolean", true);
  addDelayedCallback(cfg.掩护后免伤持续秒 * 1000, () => {
    YDUserDataSetSafe("unit", 施法者, 免疫伤害属性名, "boolean", false);
  });
  播放欧尔贝克单位音效(施法者, cfg.掩护音效键);
  播放欧尔贝克配置动作(施法者, 3, 3.0);
  创建点特效({
    模型路径: cfg.掩护特效模型,
    X: GetUnitX(target),
    Y: GetUnitY(target),
    Z: 25,
    缩放: 1.0,
    持续秒: cfg.掩护特效持续秒,
  });
  return 0;
}

//=============================================================================
// 分支三：敌军 - 挑衅
//=============================================================================

function 施加挑衅(this: void, caster: any, target: any): void {
  const cfg = 欧尔贝克单位技能配置.D;
  // 底层嘲讽 Buff 系统：嘲讽 1 秒（C020，强制攻击来源并屏蔽其他指令）
  施加嘲讽(caster, target, { 持续时间: cfg.挑衅持续秒 });
  // 仇恨系统：施法时给目标加「相当于造成 30% 最大生命伤害」的仇恨（0.3×1000=300 点）
  增加生命比例仇恨(target, caster, cfg.挑衅仇恨生命比例);
  // 自身位置播放挑衅特效
  创建点特效({
    模型路径: cfg.挑衅特效模型,
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    Z: 0,
    持续秒: cfg.挑衅特效持续秒,
  });
}

//=============================================================================
// 施法入口
//=============================================================================

function on欧尔贝克D(this: void, caster: any, abilityId: number): void {
  if (abilityId !== D技能ID) return;
  if (!单位是指定类型(caster, 欧尔贝克单位类型ID)) return;

  const target = GetSpellTargetUnit();
  if (target == null || target === 0) return;

  if (target === caster) {
    // 自己：防御
    播放欧尔贝克单位音效(caster, 欧尔贝克单位技能配置.D.防御音效键);
    施加防御(caster);
    return;
  }
  if (isUnitAlly(target, caster)) {
    // 友军：掩护
    施加掩护(caster, target);
    return;
  }
  if (isUnitEnemy(target, caster)) {
    // 敌军：挑衅
    播放欧尔贝克单位音效(caster, 欧尔贝克单位技能配置.D.全局音效键);
    施加挑衅(caster, target);
  }
}

registerSpellEffectListener(on欧尔贝克D);
// 掩护的伤害判定为全局监听，初始化时注册一次
registerDamageModifier(处理掩护伤害, -1000);

export {};
