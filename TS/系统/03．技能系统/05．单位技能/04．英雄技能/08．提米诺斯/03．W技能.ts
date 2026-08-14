/** @noSelfInFile */

import { 提米诺斯单位技能配置 } from "./00．配置";
import { 播放提米诺斯单位音效 } from "./00A．表现工具";

const jass = require("jass.common") as any;
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, unit: any, abilityId: number) => void) => void;
};
const { 造成单体技能伤害, 造成批量AOE技能伤害, 创建独立技能伤害实例, 绑定单位当前独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  造成批量AOE技能伤害: (this: void, params: any) => number;
  创建独立技能伤害实例: (this: void, params: any) => number;
  绑定单位当前独立技能伤害实例: (this: void, unit: any, id: number) => void;
};
const { 读取单位攻击力, 单位存活 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  单位存活: (this: void, unit: any) => boolean;
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

const W技能ID = stringToFourCCSafe(提米诺斯单位技能配置.W技能ID);
const 提米诺斯单位ID = stringToFourCCSafe(提米诺斯单位技能配置.单位类型ID);

function on提米诺斯W(this: void, caster: any, abilityId: number): void {
  if (abilityId !== W技能ID || jass.GetUnitTypeId(caster) !== 提米诺斯单位ID) return;
  const target = jass.GetSpellTargetUnit();
  if (!单位存活(target)) return;
  const cfg = 提米诺斯单位技能配置.W;
  const level = jass.GetUnitAbilityLevel(caster, W技能ID) as number;
  const damage = 读取单位攻击力(caster) * (cfg.基础攻击力倍率 + cfg.每级攻击力倍率 * level);
  const skillInstanceId = 创建独立技能伤害实例({ 技能ID: W技能ID, 来源类型: "单位技能", 标签: "提米诺斯-圣光", 持续时间秒: 1 });
  绑定单位当前独立技能伤害实例(caster, skillInstanceId);
  const soundIndex = jass.GetRandomInt(0, cfg.全局音效键.length - 1) as number;
  播放提米诺斯单位音效(caster, cfg.全局音效键[soundIndex]);

  造成单体技能伤害({
    来源: caster, 目标: target, 伤害: damage, 伤害类型: jass.DAMAGE_TYPE_DIVINE,
    attack: true, ranged: false, attackType: jass.ATTACK_TYPE_NORMAL, weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能", 技能ID: W技能ID, 技能实例ID: skillInstanceId,
    标签: "提米诺斯-圣光-主目标", 参与技能伤害加成: true,
  });
  创建点特效({
    模型路径: cfg.特效模型, X: jass.GetUnitX(target), Y: jass.GetUnitY(target), Z: cfg.特效Z,
    Z轴角度: cfg.特效Z轴角度, 缩放: cfg.特效缩放, 持续秒: cfg.特效持续秒,
  });

  const targets = getEnemyUnitsInRange(caster, jass.GetUnitX(target), jass.GetUnitY(target), cfg.溅射范围);
  for (let i = targets.length - 1; i >= 0; i--) {
    if (targets[i] === target) targets.splice(i, 1);
  }
  造成批量AOE技能伤害({
    来源: caster, 目标列表: targets, 伤害: damage * cfg.溅射倍率, 伤害类型: jass.DAMAGE_TYPE_DIVINE,
    attack: true, ranged: false, attackType: jass.ATTACK_TYPE_NORMAL, weaponType: jass.WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能", 技能ID: W技能ID, 技能实例ID: skillInstanceId,
    标签: "提米诺斯-圣光-溅射", 参与技能伤害加成: true,
  });
}

registerSpellEffectListener(on提米诺斯W);

export {};
