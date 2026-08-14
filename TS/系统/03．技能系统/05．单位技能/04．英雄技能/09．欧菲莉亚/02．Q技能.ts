/** @noSelfInFile */

import { 欧菲莉亚单位技能配置 } from "./00．配置";
import { 播放欧菲莉亚单位音效 } from "./00A．表现工具";
import { 读取单位攻击力, 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { spellHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  spellHeal: (this: void, source: any, target: any, amount: number, showEffect?: boolean, effectPath?: string, manaAmount?: number, showManaEffect?: boolean) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, caster: any, abilityId: number) => void) => void;
};

const 欧菲莉亚单位类型ID = stringToFourCCSafe(欧菲莉亚单位技能配置.单位类型ID);
const 欧菲莉亚Q技能ID = stringToFourCCSafe(欧菲莉亚单位技能配置.Q技能ID);
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;

function 欧菲莉亚Q目标合法(this: void, caster: any, target: any, owner: any): boolean {
  if (target == null || target === 0 || !单位存活(target)) return false;
  if (target !== caster && jass.IsUnitAlly(target, owner) !== true) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_ANCIENT) === true) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_MECHANICAL) === true) return false;
  if (IsUnitType(target, jass.UNIT_TYPE_STRUCTURE) === true) return false;
  const currentLife = GetUnitState(target, jass.UNIT_STATE_LIFE) as number;
  const maxLife = GetUnitStateJapi(target, jass.UNIT_STATE_MAX_LIFE) as number;
  return currentLife > 0.405 && maxLife > currentLife;
}

function 处理欧菲莉亚Q(this: void, caster: any, abilityId: number): void {
  if (abilityId !== 欧菲莉亚Q技能ID || GetUnitTypeId(caster) !== 欧菲莉亚单位类型ID) return;
  const cfg = 欧菲莉亚单位技能配置.Q;
  const level = GetUnitAbilityLevel(caster, 欧菲莉亚Q技能ID);
  播放欧菲莉亚单位音效(caster, cfg.全局音效键);
  创建点特效({
    模型路径: cfg.主体特效模型,
    X: GetUnitX(caster),
    Y: GetUnitY(caster),
    Z: cfg.主体特效Z,
    缩放: cfg.主体特效缩放,
    持续秒: cfg.主体特效持续秒,
  });

  const lifeAmount = 读取单位攻击力(caster) * (cfg.基础治疗攻击力倍率 + cfg.每级治疗攻击力倍率 * level);
  const manaAmount = cfg.每级额外魔法恢复 * level;
  const owner = jass.GetOwningPlayer(caster);
  const targets = getUnitsInRange(GetUnitX(caster), GetUnitY(caster), cfg.范围);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!欧菲莉亚Q目标合法(caster, target, owner)) continue;
    spellHeal(caster, target, lifeAmount, false, undefined, target === caster ? 0 : manaAmount, false);
    for (let j = 0; j < cfg.特效.length; j++) {
      const effect = cfg.特效[j];
      创建点特效({
        模型路径: effect.模型,
        X: GetUnitX(target),
        Y: GetUnitY(target),
        Z: effect.Z,
        Z轴角度: effect.Z轴角度,
        缩放: effect.缩放,
        持续秒: cfg.特效持续秒,
      });
    }
  }
}

registerSpellEffectListener(处理欧菲莉亚Q);

export {};
