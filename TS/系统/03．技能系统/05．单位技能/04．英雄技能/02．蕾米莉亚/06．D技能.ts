/** @noSelfInFile */

import { 蕾米莉亚单位技能配置 } from "./00．配置";
import { 蕾米莉亚BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/03．蕾米莉亚";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, caster: any, abilityId: number) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  removeDelayedCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};
const { 技能_获取技能最大冷却时间 } = require("平台扩展API取值") as {
  技能_获取技能最大冷却时间: (this: void, unit: any, abilityId: number) => number;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { 单位存活, 读取单位最大生命, 取单位ID } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  单位存活: (this: void, unit: any) => boolean;
  读取单位最大生命: (this: void, unit: any) => number;
  取单位ID: (this: void, unit: any) => number;
};

const D配置 = 蕾米莉亚单位技能配置.D;
const D技能ID = stringToFourCCSafe(D配置.技能ID);
const 单位类型ID = 蕾米莉亚单位技能配置.单位类型ID;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetHeroStr = jass.GetHeroStr as (this: void, unit: any, includeBonuses: boolean) => number;
const SetHeroStr = jass.SetHeroStr as (this: void, unit: any, value: number, permanent: boolean) => void;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const R2I = jass.R2I as (this: void, value: number) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

interface 蕾米莉亚D上下文 {
  施法者: any;
  中段回调ID: number;
  结算阶段回调ID: number;
  结果回调ID: number;
}

const D上下文表: Record<number, 蕾米莉亚D上下文 | undefined> = {};

function 清理蕾米莉亚D上下文(this: void, context: 蕾米莉亚D上下文): void {
  if (context.中段回调ID !== 0) {
    removeDelayedCallback(context.中段回调ID);
    context.中段回调ID = 0;
  }
  if (context.结算阶段回调ID !== 0) {
    removeDelayedCallback(context.结算阶段回调ID);
    context.结算阶段回调ID = 0;
  }
  if (context.结果回调ID !== 0) {
    removeDelayedCallback(context.结果回调ID);
    context.结果回调ID = 0;
  }
  const unitId = 取单位ID(context.施法者);
  if (unitId !== 0 && D上下文表[unitId] === context) delete D上下文表[unitId];
}

function 调整英雄力量(this: void, hero: any, delta: number): void {
  if (hero == null || hero === 0 || delta === 0) return;
  SetHeroStr(hero, (GetHeroStr(hero, false) || 0) + delta, true);
}

function 绯色命运Buff移除(this: void, unit: any, _buffID: string, row: any): void {
  if (unit == null || unit === 0) return;
  const delta = typeof row?.effect === "number" ? row.effect : 0;
  调整英雄力量(unit, -delta);
}

function 施加临时力量结果(this: void, caster: any, delta: number, buffID: string, voicePath: string): void {
  if (voicePath !== "") Sound3DII_UnitPlayReuse(voicePath, caster, 2000);
  if (delta === 0) return;
  调整英雄力量(caster, delta);
  registerManualBuff(caster, buffID, D配置.力量变化持续秒, delta, {
    sourceName: "蕾米莉亚-绯色命运",
    onRemove: 绯色命运Buff移除,
  });
}

function 刷新技能冷却(this: void, caster: any, rawId: string): void {
  const abilityId = stringToFourCCSafe(rawId);
  const maximum = 技能_获取技能最大冷却时间(caster, abilityId);
  if (maximum > 0) 技能_设置技能冷却时间(caster, abilityId, 0, maximum);
}

function 恢复生命魔法(this: void, caster: any): void {
  const maxLife = 读取单位最大生命(caster);
  const maxMana = GetUnitStateJapi(caster, UNIT_STATE_MAX_MANA) || 0;
  if (maxLife > 0) SetUnitState(caster, UNIT_STATE_LIFE, maxLife);
  if (maxMana > 0) SetUnitState(caster, UNIT_STATE_MANA, maxMana);
}

function 结算蕾米莉亚D结果(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚D上下文 | undefined;
  if (context == null) return;
  context.结果回调ID = 0;
  if (!单位存活(context.施法者)) {
    清理蕾米莉亚D上下文(context);
    return;
  }
  const caster = context.施法者;
  const result = GetRandomInt(1, 100);
  if (result <= 25) {
    const delta = R2I(GetHeroStr(caster, true) * D配置.力量变化比例);
    施加临时力量结果(caster, delta, 蕾米莉亚BuffID.绯色命运增益, D配置.结果语音.增益);
    清理蕾米莉亚D上下文(context);
    return;
  }
  if (result <= 50) {
    const delta = -R2I(GetHeroStr(caster, true) * D配置.力量变化比例);
    施加临时力量结果(caster, delta, 蕾米莉亚BuffID.绯色命运减益, D配置.结果语音.减益);
    清理蕾米莉亚D上下文(context);
    return;
  }
  if (result <= 70) {
    Sound3DII_UnitPlayReuse(D配置.结果语音.增益, caster, 2000);
    恢复生命魔法(caster);
    刷新技能冷却(caster, 蕾米莉亚单位技能配置.Q.技能ID);
    刷新技能冷却(caster, 蕾米莉亚单位技能配置.E.技能ID);
    清理蕾米莉亚D上下文(context);
    return;
  }
  if (result <= 85) {
    Sound3DII_UnitPlayReuse(D配置.结果语音.永久增益, caster, 2000);
    调整英雄力量(caster, D配置.永久力量增减);
    清理蕾米莉亚D上下文(context);
    return;
  }
  if (result <= 95) {
    调整英雄力量(caster, -D配置.永久力量增减);
    清理蕾米莉亚D上下文(context);
    return;
  }
  SetUnitInvulnerable(caster, false);
  造成单体技能伤害({
    来源: caster,
    目标: caster,
    伤害: D配置.自伤数值,
    伤害类型: DAMAGE_TYPE_MIND,
    attack: true,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: D技能ID,
    标签: "蕾米莉亚-绯色命运",
    参与技能伤害加成: true,
  });
  清理蕾米莉亚D上下文(context);
}

function 蕾米莉亚D结算阶段(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚D上下文 | undefined;
  if (context == null) return;
  context.结算阶段回调ID = 0;
  if (!单位存活(context.施法者)) {
    清理蕾米莉亚D上下文(context);
    return;
  }
  Sound3DII_UnitPlayReuse(D配置.结算语音.路径, context.施法者, D配置.结算语音.裁断距离);
  context.结果回调ID = addDelayedCallback(D配置.随机延迟秒 * 1000, 结算蕾米莉亚D结果, context);
}

function 蕾米莉亚D中段(this: void, variable?: any): void {
  const context = variable as 蕾米莉亚D上下文 | undefined;
  if (context == null) return;
  context.中段回调ID = 0;
  if (!单位存活(context.施法者)) {
    清理蕾米莉亚D上下文(context);
    return;
  }
  Sound3DII_UnitPlayReuse(D配置.中段语音.路径, context.施法者, D配置.中段语音.裁断距离);
  context.结算阶段回调ID = addDelayedCallback(D配置.结算延迟秒 * 1000, 蕾米莉亚D结算阶段, context);
}

function 处理蕾米莉亚D(this: void, caster: any, abilityId: number): void {
  if (abilityId !== D技能ID || GetUnitTypeId(caster) !== 单位类型ID || !单位存活(caster)) return;
  const unitId = 取单位ID(caster);
  if (unitId === 0 || D上下文表[unitId] != null) return;
  const context = {
    施法者: caster,
    中段回调ID: 0,
    结算阶段回调ID: 0,
    结果回调ID: 0,
  } as 蕾米莉亚D上下文;
  D上下文表[unitId] = context;
  Sound3DII_UnitPlayReuse(D配置.启动语音.路径, caster, D配置.启动语音.裁断距离);
  context.中段回调ID = addDelayedCallback(D配置.中段延迟秒 * 1000, 蕾米莉亚D中段, context);
}

function 蕾米莉亚D单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  const context = D上下文表[取单位ID(dyingUnit)];
  if (context != null) 清理蕾米莉亚D上下文(context);
}

registerSpellEffectListener(处理蕾米莉亚D);
registerDeathListener(蕾米莉亚D单位死亡);

export {};
