/** @noSelfInFile */

import { 八云紫单位技能配置 } from "../00．配置";
import {
  八云紫单位存活,
  是八云紫,
  是八云紫合法敌人,
  查找八云紫裂隙,
  创建八云紫裂隙,
  创建八云紫点特效,
  注册八云紫裂隙创建监听器,
  设置八云紫E期间D排斥豁免,
  type 八云紫裂隙记录,
} from "../07．公共与单位壳/01．裂隙系统";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 八云紫BuffID } from "../../../../../05．Buff系统/03．Buff表/02．英雄/14．八云紫";
import { 播放八云紫单位音效, 播放八云紫随机单位音效 } from "../00A．表现工具";

const jass = require("jass.common") as any;
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback, getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getGameTime: (this: void) => number;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 移除单位负面Buff } = require("系统.05．Buff系统.05．Buff清除函数") as {
  移除单位负面Buff: (this: void, target: any, onlyPurgable?: boolean) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 单位是否无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  单位是否无敌安全: (this: void, unit: any) => boolean;
};
const { 单位扩展_设移动类型, 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  单位扩展_设移动类型: (this: void, unit: any, moveType: number) => void;
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};
const { 技能_获取技能当前冷却时间, 技能_获取技能最大冷却时间 } = require("平台扩展API取值") as {
  技能_获取技能当前冷却时间: (this: void, unit: any, abilityId: number) => number;
  技能_获取技能最大冷却时间: (this: void, unit: any, abilityId: number) => number;
};
const { 读取单位攻击力, 极坐标X, 极坐标Y } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  极坐标X: (this: void, x: number, angleDeg: number, distance: number) => number;
  极坐标Y: (this: void, y: number, angleDeg: number, distance: number) => number;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};

const 配置 = 八云紫单位技能配置;
const E暂停来源 = "八云紫-E-友方神隐准备";
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as any;

type 神隐方式 = "自身" | "裂隙" | "友方" | "敌方";

interface 神隐上下文 {
  英雄: any;
  方式: 神隐方式;
  目标: any;
  目标裂隙?: 八云紫裂隙记录;
  出现X: number;
  出现Y: number;
  原始无敌: boolean;
  技能实例ID?: number;
  到期时间: number;
  周期ID: number;
  已结束: boolean;
  友方已隐藏: boolean;
}

interface 冷却调整参数 {
  英雄: any;
  减少比例: number;
}

const 神隐上下文表: Record<number, 神隐上下文 | undefined> = {};

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && jass.GetUnitTypeId(unit) !== 0;
}

function 句柄ID(this: void, unit: any): number {
  return 单位有效(unit) ? jass.GetHandleId(unit) : 0;
}

function 创建E裂隙(this: void, hero: any, x: number, y: number, skillInstanceId?: number): void {
  for (let i = 0; i < 配置.D.展开音效键.length; i++) 播放八云紫单位音效(hero, 配置.D.展开音效键[i]);
  创建八云紫裂隙(hero, x, y, 配置.技能.E.类型ID, skillInstanceId, {
    持续秒: 配置.裂隙.短期持续秒,
    长期: false,
  });
}

function 造成E伤害(this: void, context: 神隐上下文, target: any, damage: number, tag: string): void {
  if (!是八云紫合法敌人(context.英雄, target) || !(damage > 0)) return;
  造成单体技能伤害({
    来源: context.英雄,
    目标: target,
    伤害: damage,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 配置.技能.E.类型ID,
    技能实例ID: context.技能实例ID,
    标签: tag,
    伤害形态: "AOE",
    参与技能伤害加成: true,
  });
}

function 调整E冷却(this: void, variable?: any): void {
  const data = variable as 冷却调整参数 | undefined;
  if (data == null || !单位有效(data.英雄) || !(data.减少比例 > 0)) return;
  const current = 技能_获取技能当前冷却时间(data.英雄, 配置.技能.E.类型ID) || 0;
  const maximum = 技能_获取技能最大冷却时间(data.英雄, 配置.技能.E.类型ID) || 0;
  if (!(current > 0) || !(maximum > 0)) return;
  技能_设置技能冷却时间(data.英雄, 配置.技能.E.类型ID, current * (1 - data.减少比例), maximum);
}

function 隐藏八云紫(this: void, context: 神隐上下文): void {
  const hero = context.英雄;
  jass.SetUnitVertexColor(hero, 255, 255, 255, 0);
  单位扩展_设移动类型(hero, 0x01);
  jass.SetUnitScale(hero, 配置.E.隐藏缩放, 配置.E.隐藏缩放, 配置.E.隐藏缩放);
  jass.SetUnitAcquireRange(hero, 0);
  jass.SetUnitInvulnerable(hero, true);
  创建八云紫点特效(
    配置.E.消失特效,
    jass.GetUnitX(hero),
    jass.GetUnitY(hero),
    1.5,
    配置.E.消失特效缩放,
    配置.E.消失特效高度,
  );
}

function 恢复八云紫(this: void, context: 神隐上下文): void {
  const hero = context.英雄;
  if (!单位有效(hero)) return;
  jass.ShowUnit(hero, true);
  jass.SetUnitVertexColor(hero, 255, 255, 255, 255);
  单位扩展_设移动类型(hero, 0x02);
  jass.SetUnitScale(hero, 配置.E.恢复缩放, 配置.E.恢复缩放, 配置.E.恢复缩放);
  jass.SetUnitAcquireRange(hero, 配置.E.恢复索敌范围);
  jass.SetUnitInvulnerable(hero, context.原始无敌);
  移除单位暂停(hero, E暂停来源);
}

function 获取敌方背后点(this: void, target: any): { x: number; y: number } {
  const 背后角度 = jass.GetUnitFacing(target) + 180;
  let distance: number = 配置.E.敌方背后距离;
  let x = 极坐标X(jass.GetUnitX(target), 背后角度, distance);
  let y = 极坐标Y(jass.GetUnitY(target), 背后角度, distance);
  if (jass.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) === true) {
    distance = 配置.E.敌方阻挡回退距离;
    x = 极坐标X(jass.GetUnitX(target), 背后角度, distance);
    y = 极坐标Y(jass.GetUnitY(target), 背后角度, distance);
  }
  return { x, y };
}

function 结算敌方分支(this: void, context: 神隐上下文): void {
  const target = context.目标;
  if (!八云紫单位存活(target) || !是八云紫合法敌人(context.英雄, target)) return;
  const point = 获取敌方背后点(target);
  context.出现X = point.x;
  context.出现Y = point.y;
  jass.SetUnitPosition(context.英雄, point.x, point.y);
  播放八云紫单位音效(context.英雄, 配置.E.敌方出现语音键);
  创建E裂隙(context.英雄, point.x, point.y, context.技能实例ID);
  施加眩晕(context.英雄, target, 配置.E.敌方眩晕秒, "八云紫-E-神隐突袭", "技能");
  创建点特效({
    模型路径: 配置.E.敌方结算特效,
    X: jass.GetUnitX(target),
    Y: jass.GetUnitY(target),
    Z: 配置.E.敌方结算特效高度,
    缩放: 配置.E.敌方结算特效缩放,
    动画速度: 配置.E.敌方结算特效速度,
    持续秒: 配置.E.敌方结算特效持续秒,
  });
  const attack = 读取单位攻击力(context.英雄);
  const 缺失生命 = jass.GetUnitState(target, UNIT_STATE_MAX_LIFE) - jass.GetUnitState(target, UNIT_STATE_LIFE);
  const missingLife = 缺失生命 > 0 ? 缺失生命 : 0;
  造成E伤害(
    context,
    target,
    attack * 配置.E.敌方额外伤害攻击力比例 + missingLife * 配置.E.敌方已损失生命比例,
    "八云紫-E-敌方神隐突袭",
  );
}

function 结算最终展开(this: void, context: 神隐上下文): void {
  if (!八云紫单位存活(context.英雄)) return;
  const heroX = jass.GetUnitX(context.英雄);
  const heroY = jass.GetUnitY(context.英雄);
  创建八云紫点特效(配置.E.出现特效, heroX, heroY, 1.5);
  const damage = 读取单位攻击力(context.英雄) * 配置.E.最终伤害攻击力比例;
  const enemies = getEnemyUnitsInRange(context.英雄, heroX, heroY, 配置.E.最终范围);
  for (let i = 0; i < enemies.length; i++) {
    造成E伤害(context, enemies[i], damage, "八云紫-E-神隐最终展开");
  }
}

function 结束神隐(this: void, context: 神隐上下文, 结算伤害: boolean): void {
  if (context.已结束) return;
  context.已结束 = true;
  if (context.周期ID !== 0) removePeriodicCallback(context.周期ID);
  const heroId = 句柄ID(context.英雄);
  if (heroId !== 0 && 神隐上下文表[heroId] === context) delete 神隐上下文表[heroId];
  设置八云紫E期间D排斥豁免(context.英雄, false);

  jass.SetPlayerAbilityAvailable(jass.GetOwningPlayer(context.英雄), 配置.技能.E.类型ID, true);
  jass.UnitRemoveAbility(context.英雄, 配置.技能.E出现.类型ID);
  移除单位指定Buff(context.英雄, 八云紫BuffID.神隐);

  if (context.友方已隐藏 && 单位有效(context.目标)) {
    jass.ShowUnit(context.目标, true);
    移除单位指定Buff(context.目标, 八云紫BuffID.神隐);
  }

  if (结算伤害 && context.方式 === "敌方") 结算敌方分支(context);
  else if (context.方式 === "裂隙") jass.SetUnitPosition(context.英雄, context.出现X, context.出现Y);
  else if (context.方式 === "友方" && 单位有效(context.目标)) {
    context.出现X = jass.GetUnitX(context.目标);
    context.出现Y = jass.GetUnitY(context.目标);
    jass.SetUnitPosition(context.英雄, context.出现X, context.出现Y);
    jass.SetUnitPosition(context.目标, context.出现X, context.出现Y);
    移除单位负面Buff(context.目标, false);
  } else if (context.方式 !== "自身") jass.SetUnitPosition(context.英雄, context.出现X, context.出现Y);

  恢复八云紫(context);
  if (结算伤害) 结算最终展开(context);
}

function 神隐检查(this: void, variable?: any): void {
  const context = variable as 神隐上下文 | undefined;
  if (context == null || context.已结束) return;
  if (!八云紫单位存活(context.英雄)) {
    结束神隐(context, false);
    return;
  }
  if (getGameTime() >= context.到期时间) 结束神隐(context, true);
}

function 友方神隐到达(this: void, variable?: any): void {
  const context = variable as 神隐上下文 | undefined;
  if (context == null || context.已结束 || !八云紫单位存活(context.目标)) return;
  context.出现X = jass.GetUnitX(context.目标);
  context.出现Y = jass.GetUnitY(context.目标);
  播放八云紫随机单位音效(context.英雄, 配置.E.友方出现语音键);
  jass.SetUnitPosition(context.英雄, context.出现X, context.出现Y);
  创建八云紫点特效(配置.E.出现特效, context.出现X, context.出现Y, 1.5);
  创建E裂隙(context.英雄, context.出现X, context.出现Y, context.技能实例ID);
  addDelayedCallback(配置.E.友方消失延迟秒 * 1000, 友方共同消失, context);
}

function 友方共同消失(this: void, variable?: any): void {
  const context = variable as 神隐上下文 | undefined;
  if (context == null || context.已结束 || !八云紫单位存活(context.目标)) return;
  context.友方已隐藏 = true;
  jass.ShowUnit(context.目标, false);
  const 剩余秒 = (context.到期时间 - getGameTime()) / 1000;
  registerManualBuff(context.目标, 八云紫BuffID.神隐, 剩余秒 >= 0.1 ? 剩余秒 : 0.1, 0, {
    sourceUnit: context.英雄,
    effectSourceType: "技能",
  });
  移除单位暂停(context.英雄, E暂停来源);
}

function 进入神隐(this: void, context: 神隐上下文, 减少冷却比例: number): void {
  const heroId = 句柄ID(context.英雄);
  const previous = 神隐上下文表[heroId];
  if (previous != null && !previous.已结束) 结束神隐(previous, false);
  神隐上下文表[heroId] = context;
  设置八云紫E期间D排斥豁免(context.英雄, true);

  隐藏八云紫(context);
  jass.SetPlayerAbilityAvailable(jass.GetOwningPlayer(context.英雄), 配置.技能.E.类型ID, false);
  jass.UnitAddAbility(context.英雄, 配置.技能.E出现.类型ID);
  registerManualBuff(context.英雄, 八云紫BuffID.神隐, 配置.E.最大间隙秒, 0, {
    sourceUnit: context.英雄,
    effectSourceType: "技能",
  });
  context.周期ID = addPeriodicCallback(配置.E.检查间隔毫秒, 神隐检查, context);
  if (减少冷却比例 > 0) addDelayedCallback(10, 调整E冷却, { 英雄: context.英雄, 减少比例: 减少冷却比例 } as 冷却调整参数);

  if (context.方式 === "友方") {
    添加单位暂停(context.英雄, E暂停来源);
    addDelayedCallback(配置.E.友方前置延迟秒 * 1000, 友方神隐到达, context);
  }
}

function 获取E监听上下文(this: void, hero: any): { 英雄: any } | undefined {
  return 是八云紫(hero) ? { 英雄: hero } : undefined;
}

function 释放E(this: void, _entry: { 英雄: any }, hero: any, skillInstanceId?: number): void {
  const target = jass.GetSpellTargetUnit();
  const targetX = jass.GetSpellTargetX();
  const targetY = jass.GetSpellTargetY();
  const now = getGameTime();
  let mode: 神隐方式;
  let gap: 八云紫裂隙记录 | undefined;
  let cooldownReduction = 0;
  let appearX = jass.GetUnitX(hero);
  let appearY = jass.GetUnitY(hero);

  创建E裂隙(hero, appearX, appearY, skillInstanceId);

  if (target === hero) {
    mode = "自身";
    cooldownReduction = 配置.E.自身额外减冷却比例;
  } else if (target != null && target !== 0 && jass.IsUnitEnemy(target, jass.GetOwningPlayer(hero)) === true) {
    if (!是八云紫合法敌人(hero, target)) return;
    mode = "敌方";
  } else if (target != null && target !== 0 && jass.IsUnitAlly(target, jass.GetOwningPlayer(hero)) === true) {
    if (!八云紫单位存活(target)) return;
    mode = "友方";
    cooldownReduction = 配置.E.友方额外减冷却比例;
    appearX = jass.GetUnitX(target);
    appearY = jass.GetUnitY(target);
  } else {
    gap = 查找八云紫裂隙(targetX, targetY, 配置.E.裂隙搜索范围, hero);
    if (gap == null) {
      jass.DisplayTimedTextToPlayer(jass.GetOwningPlayer(hero), 0, 0, 3, "目标位置附近没有可用的『间隙』。 ");
      技能_设置技能冷却时间(hero, 配置.技能.E.类型ID, 5, 5);
      return;
    }
    mode = "裂隙";
    cooldownReduction = 配置.E.裂隙额外减冷却比例;
    appearX = jass.GetUnitX(gap.单位);
    appearY = jass.GetUnitY(gap.单位);
  }

  进入神隐({
    英雄: hero,
    方式: mode,
    目标: target,
    目标裂隙: gap,
    出现X: appearX,
    出现Y: appearY,
    原始无敌: 单位是否无敌安全(hero),
    技能实例ID: skillInstanceId,
    到期时间: now + 配置.E.最大间隙秒 * 1000,
    周期ID: 0,
    已结束: false,
    友方已隐藏: false,
  }, cooldownReduction);
}

function 监听主动出现(this: void, caster: any, spellAbilityId: number): void {
  if (spellAbilityId !== 配置.技能.E出现.类型ID || !是八云紫(caster)) return;
  const context = 神隐上下文表[句柄ID(caster)];
  if (context != null) {
    播放八云紫随机单位音效(caster, 配置.E.主动出现语音键);
    结束神隐(context, true);
  }
}

function 监听自身神隐D间隙(this: void, hero: any, gap: 八云紫裂隙记录, skillId: number): void {
  if (skillId !== 配置.技能.D.类型ID) return;
  const context = 神隐上下文表[句柄ID(hero)];
  if (context == null || context.已结束 || context.方式 !== "自身") return;
  context.出现X = jass.GetUnitX(gap.单位);
  context.出现Y = jass.GetUnitY(gap.单位);
  jass.SetUnitPosition(hero, context.出现X, context.出现Y);
  播放八云紫随机单位音效(hero, 配置.E.主动出现语音键);
  结束神隐(context, true);
}

注册单位技能壳监听({
  名称: "八云紫-八云紫的神隐（E）",
  单位类型ID: 配置.单位.英雄类型ID,
  技能ID: 配置.技能.E.类型ID,
  获取或创建上下文: 获取E监听上下文,
  释放技能: 释放E,
  创建独立技能实例: true,
  独立技能来源类型: "单位技能",
  技能实例持续时间秒: 3,
});
registerSpellEffectListener(监听主动出现);
注册八云紫裂隙创建监听器(监听自身神隐D间隙);

export {};
