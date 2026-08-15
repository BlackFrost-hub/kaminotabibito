/** @noSelfInFile */

import { 八云紫单位技能配置 } from "../00．配置";
import { 是八云紫, 计算裂隙可达终点, 创建八云紫裂隙 } from "../07．公共与单位壳/01．裂隙系统";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};
const { 技能_获取技能最大冷却时间 } = require("平台扩展API取值") as {
  技能_获取技能最大冷却时间: (this: void, unit: any, abilityId: number) => number;
};

const 配置 = 八云紫单位技能配置;
const D暂停来源 = "八云紫-D-间隙";

function 获取D上下文(this: void, hero: any): { 英雄: any } | undefined {
  return 是八云紫(hero) ? { 英雄: hero } : undefined;
}

function 解除D硬直(this: void, variable?: any): void {
  const hero = variable as any;
  if (hero != null && hero !== 0) 移除单位暂停(hero, D暂停来源);
}

function 释放D(this: void, _context: { 英雄: any }, hero: any, skillInstanceId?: number): void {
  const startX = jass.GetUnitX(hero);
  const startY = jass.GetUnitY(hero);
  const end = 计算裂隙可达终点(startX, startY, jass.GetSpellTargetX(), jass.GetSpellTargetY());
  添加单位暂停(hero, D暂停来源);
  jass.SetUnitAnimation(hero, "attack,2");
  创建八云紫裂隙(hero, end.x, end.y, 配置.技能.D.类型ID, skillInstanceId);
  addDelayedCallback(1200, 解除D硬直, hero);
}

function 监听D刷新(this: void, caster: any, spellAbilityId: number): void {
  if (!是八云紫(caster) || spellAbilityId === 配置.技能.D.类型ID) return;
  const maxCooldown = 技能_获取技能最大冷却时间(caster, spellAbilityId) || 0;
  if (maxCooldown < 5.95) return;
  技能_设置技能冷却时间(caster, 配置.技能.D.类型ID, 0, 5.5);
}

注册单位技能壳监听({
  名称: "八云紫-间隙（D）",
  单位类型ID: 配置.单位.英雄类型ID,
  技能ID: 配置.技能.D.类型ID,
  获取或创建上下文: 获取D上下文,
  释放技能: 释放D,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 4,
});
registerSpellEffectListener(监听D刷新);

export {};
