/** @noSelfInFile */

/**
 * 阿伦劳特 - D：形态切换（光 H00F ⇄ 暗 H00G）
 *
 * 源 JASS：阿劳伦特\切换.j（berserk 命令监听）。TS 改为 registerSpellEffectListener
 * 监听 A0D8 技能施放触发（技能冷却由物编控制，不受冷却缩减）。
 *
 * 光 → 暗：
 * - DzSetUnitID 切换为 H00G，重设最大生命 = 30 + 力量 × 1.35
 * - 移除光形态属性（治疗加成、魔法伤害加成），增加暗形态属性（生命恢复增幅、受到治疗）
 * - 恢复已损失生命 15%，临时 +10% 攻击 2 秒（B017，到期回滚）
 *
 * 暗 → 光：
 * - DzSetUnitID 切换为 H00F，重设最大生命
 * - 反向恢复属性、驱散负面 Buff、0.5 秒免伤
 */

import { 阿伦劳特BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/13．阿伦劳特";

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => void;
};

const { 阿伦劳特单位技能配置 } = require("./00．配置") as {
  阿伦劳特单位技能配置: any;
};
const {
  是阿伦劳特英雄,
  是光形态,
  是暗形态,
  添加原生Buff持续,
  移除原生Buff,
} = require("./00B．形态与状态管理") as {
  是阿伦劳特英雄: (this: void, unit: any) => boolean;
  是光形态: (this: void, unit: any) => boolean;
  是暗形态: (this: void, unit: any) => boolean;
  添加原生Buff持续: (this: void, unit: any, buffId: number, duration: number) => void;
  移除原生Buff: (this: void, unit: any, buffId: number) => void;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, 施法单位: any, 技能ID: number) => void) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 调整玩家属性, 临时调整攻击 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令") as {
  调整玩家属性: (this: void, 单位: any, 属性名: string, 增量: number) => void;
  临时调整攻击: (this: void, 单位: any, 数值: number) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { 移除单位负面Buff } = require("系统.05．Buff系统.05．Buff清除函数") as {
  移除单位负面Buff: (this: void, unit: any, onlyPurgable?: boolean) => number;
};
const { 开始无敌帧 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.08．无敌帧") as {
  开始无敌帧: (this: void, 单位: any, 持续时间: number) => number;
};
const { createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitStateJass = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitStateJapi = japi.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const GetHeroStr = jass.GetHeroStr as (this: void, hero: any, includeBonuses: boolean) => number;
const DzSetUnitID = japi.DzSetUnitID as (this: void, unit: any, unitTypeId: number) => void;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_ATTACK = jass.ConvertUnitState(0x15) as any;

const 光形态单位ID = stringToFourCCSafe(阿伦劳特单位技能配置.光形态单位ID);
const 暗形态单位ID = stringToFourCCSafe(阿伦劳特单位技能配置.暗形态单位ID);
const D技能ID = stringToFourCCSafe(阿伦劳特单位技能配置.D技能ID);
const 切换加攻BuffID = stringToFourCCSafe(阿伦劳特单位技能配置.切换加攻BuffID);

/** 切换后重设最大生命 = 30 + 力量 × 1.35（源 切换.j） */
function 重设形态最大生命(this: void, unit: any): void {
  SetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE, 30 + GetHeroStr(unit, false) * 1.35);
}

/** 光 H00F → 暗 H00G */
function 光形态切换为暗(this: void, unit: any): void {
  const D配置 = 阿伦劳特单位技能配置.D;

  // 1. 同步切换单位类型为暗形态（DzSetUnitID 保留单位实例、等级、归属与技能状态）
  DzSetUnitID(unit, 暗形态单位ID);
  // 自定义 Buff：暗形态常驻显示，移除光形态显示
  registerManualBuff(unit, 阿伦劳特BuffID.裁决圣剑形态, 999, 0);
  移除单位指定Buff(unit, 阿伦劳特BuffID.光之圣剑形态);

  // 2. 重设最大生命
  重设形态最大生命(unit);

  // 3. 技能图标更新：源 JASS 用 YDWESetUnitAbilityDataString(204) 更新 Q/W/E/R/D 图标；
  //    图标属本地表现（仅本机可见），项目不在同步路径处理，故跳过。

  // 4. 播放切换特效（挂 origin，2 秒后自动销毁）
  createTimedUnitEffect(unit, "origin", D配置.光切暗特效A, D配置.切换特效持续秒);
  createTimedUnitEffect(unit, "origin", D配置.光切暗特效B, D配置.切换特效持续秒);

  // 5. 属性切换：移除光形态加成，增加暗形态加成
  调整玩家属性(unit, D配置.光治疗加成属性名, -D配置.光治疗加成);
  调整玩家属性(unit, D配置.光魔法伤害加成属性名, -D配置.光魔法伤害加成);
  调整玩家属性(unit, D配置.暗生命恢复增幅属性名, D配置.暗生命恢复增幅);
  调整玩家属性(unit, D配置.暗受到治疗加成属性名, D配置.暗受到治疗加成);

  // 6. 恢复已损失生命的 15%
  const 已损失生命 = Math.max(0, GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) - GetUnitStateJass(unit, UNIT_STATE_LIFE));
  doHeal({
    HealSource: unit,
    HealTarget: unit,
    HealAmount: 已损失生命 * D配置.恢复已损失生命比例,
    ItemHeal: false,
    HealEffect: false,
  });

  // 7. 临时加攻 10%，持续 2 秒；到期回滚攻击并移除 B017
  const 攻击力 = GetUnitStateJapi(unit, UNIT_STATE_ATTACK);
  const 加攻量 = 攻击力 * D配置.切换加攻比例;
  if (加攻量 > 0) {
    临时调整攻击(unit, 加攻量);
    添加原生Buff持续(unit, 切换加攻BuffID, D配置.切换加攻持续秒);
    registerManualBuff(unit, 阿伦劳特BuffID.切换加攻, 2, 0);
    addDelayedCallback(Math.round(D配置.切换加攻持续秒 * 1000), () => {
      临时调整攻击(unit, -加攻量);
      移除原生Buff(unit, 切换加攻BuffID);
    });
  }
}

/** 暗 H00G → 光 H00F */
function 暗形态切换为光(this: void, unit: any): void {
  const D配置 = 阿伦劳特单位技能配置.D;

  // 1. 同步切换单位类型为光形态
  DzSetUnitID(unit, 光形态单位ID);
  // 自定义 Buff：光形态常驻显示，移除暗形态显示与切换加攻
  registerManualBuff(unit, 阿伦劳特BuffID.光之圣剑形态, 999, 0);
  移除单位指定Buff(unit, 阿伦劳特BuffID.裁决圣剑形态);
  移除单位指定Buff(unit, 阿伦劳特BuffID.切换加攻);

  // 2. 重设最大生命
  重设形态最大生命(unit);

  // 3. 技能图标更新：本地表现，跳过（同光切暗）。

  // 4. 播放切换特效（挂 origin，2 秒后自动销毁）
  createTimedUnitEffect(unit, "origin", D配置.暗切光特效A, D配置.切换特效持续秒);
  createTimedUnitEffect(unit, "origin", D配置.暗切光特效B, D配置.切换特效持续秒);

  // 5. 属性反向恢复：补回光形态加成，移除暗形态加成
  调整玩家属性(unit, D配置.光治疗加成属性名, D配置.光治疗加成);
  调整玩家属性(unit, D配置.光魔法伤害加成属性名, D配置.光魔法伤害加成);
  调整玩家属性(unit, D配置.暗生命恢复增幅属性名, -D配置.暗生命恢复增幅);
  调整玩家属性(unit, D配置.暗受到治疗加成属性名, -D配置.暗受到治疗加成);

  // 6. 驱散不利状态（仅清除 Debuff，不清增益）
  移除单位负面Buff(unit, false);

  // 7. 0.5 秒免伤
  开始无敌帧(unit, D配置.免伤秒);
}

/** 入口：A0D8 施放触发形态切换 */
export function on阿伦劳特D切换(this: void, 施法单位: any, abilityId: number): void {
  if (abilityId !== D技能ID) return;
  if (!是阿伦劳特英雄(施法单位)) return;
  if (是光形态(施法单位)) {
    光形态切换为暗(施法单位);
    return;
  }
  if (是暗形态(施法单位)) {
    暗形态切换为光(施法单位);
  }
}

registerSpellEffectListener(on阿伦劳特D切换);

export {};
