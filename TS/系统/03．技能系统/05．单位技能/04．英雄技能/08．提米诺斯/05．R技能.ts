/** @noSelfInFile */

import { 提米诺斯单位技能配置 } from "./00．配置";
import { 播放提米诺斯单位音效 } from "./00A．表现工具";

const jass = require("jass.common") as any;
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, unit: any, abilityId: number) => void) => void;
};
const { getAbilityManaCost } = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还") as {
  getAbilityManaCost: (this: void, unit: any, abilityId: number, level: number) => number;
};
const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, target: any, buffID: string) => any;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { YDWESetUnitAbilityStateSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWESetUnitAbilityStateSafe: (this: void, unit: any, abilityId: number, stateType: number, value: number) => boolean;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};

interface 祝福记录 { 剩余次数: number; }

const R技能ID = stringToFourCCSafe(提米诺斯单位技能配置.R技能ID);
const 提米诺斯单位ID = stringToFourCCSafe(提米诺斯单位技能配置.单位类型ID);
const 原生状态技能ID = stringToFourCCSafe(提米诺斯单位技能配置.R.原生状态技能ID);
const 祝福表: Record<number, 祝福记录 | undefined> = {};

function 清理祝福(this: void, target: any): void {
  if (target == null || target === 0) return;
  delete 祝福表[jass.GetHandleId(target) as number];
  jass.UnitRemoveAbility(target, 原生状态技能ID);
  移除单位指定Buff(target, 提米诺斯单位技能配置.R.BuffID);
}

function on祝福移除(this: void, target: any): void {
  if (target == null || target === 0) return;
  delete 祝福表[jass.GetHandleId(target) as number];
  jass.UnitRemoveAbility(target, 原生状态技能ID);
}

function 施加提米诺斯祝福(this: void, caster: any, target: any): void {
  const cfg = 提米诺斯单位技能配置.R;
  const hid = jass.GetHandleId(target) as number;
  if (祝福表[hid] != null || getBuffRuntime(target, cfg.BuffID) != null) 清理祝福(target);
  祝福表[hid] = { 剩余次数: cfg.刷新次数 };
  jass.UnitAddAbility(target, 原生状态技能ID);
  registerManualBuff(target, cfg.BuffID, cfg.持续秒, cfg.刷新次数, {
    sourceUnit: caster, sourceName: "圣火神爱尔福林克的祝福", stack: cfg.刷新次数,
    nativeBuffAbilityIds: [原生状态技能ID], onRemove: on祝福移除,
  });
  for (let i = 0; i < cfg.特效.length; i++) {
    const effect = cfg.特效[i];
    创建点特效({ 模型路径: effect.模型, X: jass.GetUnitX(target), Y: jass.GetUnitY(target), Z: effect.Z, Z轴角度: 270, 缩放: effect.缩放, 持续秒: cfg.特效持续秒 });
  }
}

function on提米诺斯R与祝福技能(this: void, caster: any, abilityId: number): void {
  if (abilityId === R技能ID && jass.GetUnitTypeId(caster) === 提米诺斯单位ID) {
    const target = jass.GetSpellTargetUnit();
    if (target == null || target === 0) return;
    播放提米诺斯单位音效(caster, 提米诺斯单位技能配置.R.全局音效键);
    施加提米诺斯祝福(caster, target);
    return;
  }

  const hid = jass.GetHandleId(caster) as number;
  const record = 祝福表[hid];
  const buff = getBuffRuntime(caster, 提米诺斯单位技能配置.R.BuffID);
  if (record == null || buff == null) return;
  const level = jass.GetUnitAbilityLevel(caster, abilityId) as number;
  if (!(level > 0) || getAbilityManaCost(caster, abilityId, level) > 提米诺斯单位技能配置.R.最大基础魔耗) return;
  YDWESetUnitAbilityStateSafe(caster, abilityId, 1, 0);
  record.剩余次数 -= 1;
  if (record.剩余次数 <= 0) 清理祝福(caster);
  else {
    buff.stack = record.剩余次数;
    buff.effect = record.剩余次数;
  }
}

registerSpellEffectListener(on提米诺斯R与祝福技能);

export {};
