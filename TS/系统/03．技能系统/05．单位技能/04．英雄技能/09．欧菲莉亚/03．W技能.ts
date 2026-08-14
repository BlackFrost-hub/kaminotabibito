/** @noSelfInFile */

import { 欧菲莉亚单位技能配置 } from "./00．配置";
import { 播放欧菲莉亚单位音效 } from "./00A．表现工具";
import { 读取单位攻击力, 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string) => number;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, caster: any, abilityId: number) => void) => void;
};
const { 造成单体技能伤害, 造成批量AOE技能伤害, 创建独立技能伤害实例, 绑定单位当前独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, 参数: any) => any;
  造成批量AOE技能伤害: (this: void, 参数: any) => any;
  创建独立技能伤害实例: (this: void, 参数: any) => number;
  绑定单位当前独立技能伤害实例: (this: void, unit: any, instanceId: number) => void;
};

const 欧菲莉亚单位类型ID = stringToFourCCSafe(欧菲莉亚单位技能配置.单位类型ID);
const 欧菲莉亚W技能ID = stringToFourCCSafe(欧菲莉亚单位技能配置.W技能ID);
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;

function 欧菲莉亚W目标可受伤(this: void, unit: any): boolean {
  return 单位存活(unit)
    && IsUnitType(unit, jass.UNIT_TYPE_ANCIENT) !== true
    && IsUnitType(unit, jass.UNIT_TYPE_MECHANICAL) !== true
    && IsUnitType(unit, jass.UNIT_TYPE_STRUCTURE) !== true;
}

function 处理欧菲莉亚W(this: void, caster: any, abilityId: number): void {
  if (abilityId !== 欧菲莉亚W技能ID || GetUnitTypeId(caster) !== 欧菲莉亚单位类型ID) return;
  const cfg = 欧菲莉亚单位技能配置.W;
  const soundIndex = jass.GetRandomInt(0, cfg.全局音效键.length - 1) as number;
  播放欧菲莉亚单位音效(caster, cfg.全局音效键[soundIndex]);
  const target = jass.GetSpellTargetUnit();
  if (!欧菲莉亚W目标可受伤(target)) return;

  const level = GetUnitAbilityLevel(caster, 欧菲莉亚W技能ID);
  const baseDamage = 读取单位攻击力(caster) * (cfg.基础攻击力倍率 + cfg.每级攻击力倍率 * level);
  const skillInstanceId = 创建独立技能伤害实例({
    技能ID: 欧菲莉亚W技能ID,
    来源类型: "单位技能",
    标签: "欧菲莉亚-圣光",
    持续时间秒: 1,
  });
  绑定单位当前独立技能伤害实例(caster, skillInstanceId);
  const lightWeak = YDUserDataGetSafe("unit", target, "光弱", "boolean") === true;
  const mainDamage = lightWeak ? baseDamage * cfg.光弱额外倍率 : baseDamage;

  造成单体技能伤害({
    来源: caster,
    目标: target,
    伤害: mainDamage,
    伤害类型: jass.DAMAGE_TYPE_DIVINE,
    attack: false,
    ranged: false,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 欧菲莉亚W技能ID,
    技能实例ID: skillInstanceId,
    标签: "欧菲莉亚-圣光-主目标",
    参与技能伤害加成: true,
  });
  创建点特效({
    模型路径: cfg.命中特效模型,
    X: GetUnitX(target),
    Y: GetUnitY(target),
    Z: cfg.命中特效Z,
    Z轴角度: cfg.命中特效Z轴角度,
    缩放: cfg.命中特效缩放,
    持续秒: cfg.命中特效持续秒,
  });

  const candidates = getEnemyUnitsInRange(caster, GetUnitX(target), GetUnitY(target), cfg.溅射范围);
  const targets: any[] = [];
  for (let i = 0; i < candidates.length; i++) {
    const candidate = candidates[i];
    if (candidate !== target && 欧菲莉亚W目标可受伤(candidate)) targets.push(candidate);
  }
  造成批量AOE技能伤害({
    来源: caster,
    目标列表: targets,
    伤害: baseDamage * cfg.溅射倍率,
    伤害类型: jass.DAMAGE_TYPE_DIVINE,
    attack: false,
    ranged: false,
    attackType: jass.ATTACK_TYPE_NORMAL,
    weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 欧菲莉亚W技能ID,
    技能实例ID: skillInstanceId,
    标签: "欧菲莉亚-圣光-溅射",
    参与技能伤害加成: true,
  });
}

registerSpellEffectListener(处理欧菲莉亚W);

export {};
