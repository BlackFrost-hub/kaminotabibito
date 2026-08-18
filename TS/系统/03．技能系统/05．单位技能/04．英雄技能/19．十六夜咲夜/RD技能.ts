/** @noSelfInFile */

import { 十六夜咲夜基础技能配置 as 配置 } from "./00．配置";
import { 创建咲夜单位壳, 安全移除单位壳, 极坐标X, 极坐标Y, 单位存活, 播放咲夜单位音效, 注册咲夜周期任务, 移除咲夜周期任务 } from "./01．飞刀与时间工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示常规技能吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { 造成批量AOE技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, duration: number, effect: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 十六夜咲夜BuffID } = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜") as {
  十六夜咲夜BuffID: { 收缩世界目标封印: string; 收缩世界吟唱: string };
};

interface RD监听上下文 { 占位: boolean; }
interface RD上下文 {
  施法者: any;
  目标: any;
  技能实例ID?: number;
  来源: string;
  法阵: any;
  刀光: any[];
  目标生命快照: number;
  目标魔法快照: number;
  攻击力快照: number;
  快照周期ID: number;
  刀光周期ID: number;
  切割周期ID: number;
  刀光计数: number;
  切割计数: number;
  已结束: boolean;
}

let RD序号 = 0;

function 获取RD监听上下文(this: void, _caster: any): RD监听上下文 { return { 占位: true }; }

function RD枚举敌军(this: void, context: RD上下文): any[] {
  const result: any[] = [];
  const group = jass.CreateGroup();
  jass.GroupEnumUnitsInRange(group, jass.GetUnitX(context.目标), jass.GetUnitY(context.目标), 配置.RD.伤害半径, null);
  while (true) {
    const unit = jass.FirstOfGroup(group);
    if (unit == null || unit === 0) break;
    jass.GroupRemoveUnit(group, unit);
    if (!单位存活(unit) || !jass.IsUnitEnemy(unit, jass.GetOwningPlayer(context.施法者)) || jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT)) continue;
    result.push(unit);
  }
  jass.DestroyGroup(group);
  return result;
}

function RD清理(this: void, context: RD上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  if (context.快照周期ID !== 0) 移除咲夜周期任务(context.快照周期ID);
  if (context.刀光周期ID !== 0) 移除咲夜周期任务(context.刀光周期ID);
  if (context.切割周期ID !== 0) 移除咲夜周期任务(context.切割周期ID);
  context.快照周期ID = 0;
  context.刀光周期ID = 0;
  context.切割周期ID = 0;
  for (let i = 0; i < context.刀光.length; i++) 安全移除单位壳(context.刀光[i]);
  context.刀光 = [];
  安全移除单位壳(context.法阵);
  if (context.目标 != null && context.目标 !== 0) {
    jass.SetUnitInvulnerable(context.目标, false);
    移除单位暂停(context.目标, context.来源);
    移除单位指定Buff(context.目标, 十六夜咲夜BuffID.收缩世界目标封印);
  }
  if (context.施法者 != null && context.施法者 !== 0) {
    jass.SetUnitInvulnerable(context.施法者, false);
    移除单位暂停(context.施法者, context.来源);
    jass.SetUnitTimeScale(context.施法者, 1);
    jass.SetUnitAnimation(context.施法者, "stand");
    移除单位指定Buff(context.施法者, 十六夜咲夜BuffID.收缩世界吟唱);
  }
  关闭吟唱条("常规技能");
  结束独立技能伤害实例(context.技能实例ID);
}

function RD维持封印(this: void, variable?: any): void {
  const context = variable as RD上下文 | undefined;
  if (context == null || context.已结束) return;
  if (!单位存活(context.施法者) || !单位存活(context.目标)) {
    RD清理(context);
    return;
  }
  jass.SetUnitState(context.目标, jass.UNIT_STATE_LIFE, context.目标生命快照);
  jass.SetUnitState(context.目标, jass.UNIT_STATE_MANA, context.目标魔法快照);
}

function RD执行切割(this: void, variable?: any): void {
  const context = variable as RD上下文 | undefined;
  if (context == null || context.已结束) return;
  if (!单位存活(context.施法者) || !单位存活(context.目标)) {
    RD清理(context);
    return;
  }
  if (context.切割计数 >= 配置.RD.刀光数量) {
    RD清理(context);
    return;
  }
  const targets = RD枚举敌军(context);
  造成批量AOE技能伤害({
    来源: context.施法者,
    目标列表: targets,
    伤害类型: jass.DAMAGE_TYPE_NORMAL,
    attack: false,
    ranged: false,
    attackType: jass.ATTACK_TYPE_HERO,
    weaponType: jass.WEAPON_TYPE_METAL_HEAVY_SLICE,
    来源类型: "单位技能",
    技能ID: 配置.技能.RD.类型ID,
    技能实例ID: context.技能实例ID,
    标签: "十六夜咲夜-RD-收缩的世界",
    伤害形态: "AOE",
    每目标处理器: function RD每目标伤害(this: void): any { return { 伤害: context.攻击力快照 * 配置.RD.伤害攻击力倍率 }; },
  });
  if (context.刀光[context.切割计数] != null) {
    jass.SetUnitTimeScale(context.刀光[context.切割计数], 20);
    jass.SetUnitAnimation(context.刀光[context.切割计数], "death");
  }
  context.切割计数 += 1;
}

function RD开始切割(this: void, variable?: any): void {
  const context = variable as RD上下文 | undefined;
  if (context == null || context.已结束) return;
  context.切割计数 = 0;
  RD执行切割(context);
  context.切割周期ID = 注册咲夜周期任务(配置.RD.切割间隔毫秒, RD执行切割, context);
}

function RD创建刀光(this: void, variable?: any): void {
  const context = variable as RD上下文 | undefined;
  if (context == null || context.已结束) return;
  if (context.刀光计数 >= 配置.RD.刀光数量) {
    if (context.刀光周期ID !== 0) 移除咲夜周期任务(context.刀光周期ID);
    context.刀光周期ID = 0;
    addDelayedCallback(配置.RD.准备后延迟秒 * 1000, RD开始切割, context);
    return;
  }
  const angle = jass.GetRandomReal(0, 360) as number;
  const distance = jass.GetRandomReal(0, 配置.RD.伤害半径) as number;
  const x = 极坐标X(jass.GetUnitX(context.目标), distance, angle);
  const y = 极坐标Y(jass.GetUnitY(context.目标), distance, angle);
  const slash = 创建咲夜单位壳(context.施法者, 配置.单位壳.收缩刀光, x, y, jass.GetRandomReal(0, 360));
  if (slash != null && slash !== 0) {
    jass.SetUnitScale(slash, 配置.RD.刀光缩放, 配置.RD.刀光缩放, 配置.RD.刀光缩放);
    jass.SetUnitFlyHeight(slash, 配置.RD.刀光高度, 0);
    jass.SetUnitTimeScale(slash, 0);
    context.刀光.push(slash);
  }
  context.刀光计数 += 1;
}

function RD吟唱完成(this: void, variable?: any): void {
  const context = variable as RD上下文 | undefined;
  if (context == null || context.已结束) return;
  if (context.快照周期ID !== 0) 移除咲夜周期任务(context.快照周期ID);
  context.快照周期ID = 0;
  关闭吟唱条("常规技能");
  jass.SetUnitInvulnerable(context.目标, false);
  jass.SetUnitAnimationByIndex(context.施法者, 3);
  jass.SetUnitTimeScale(context.施法者, 1.5);
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RD2", context.施法者);
  context.刀光周期ID = 注册咲夜周期任务(配置.RD.刀光准备间隔毫秒, RD创建刀光, context);
}

function 释放十六夜咲夜RD(this: void, _listener: RD监听上下文, caster: any, 技能实例ID?: number): void {
  const target = jass.GetSpellTargetUnit();
  if (!单位存活(target)) {
    结束独立技能伤害实例(技能实例ID);
    return;
  }
  RD序号 += 1;
  const context: RD上下文 = {
    施法者: caster,
    目标: target,
    技能实例ID,
    来源: `十六夜咲夜-RD:${RD序号}`,
    法阵: 创建咲夜单位壳(caster, 配置.单位壳.收缩法阵, jass.GetUnitX(caster), jass.GetUnitY(caster), jass.GetRandomReal(0, 360)),
    刀光: [],
    目标生命快照: jass.GetUnitState(target, jass.UNIT_STATE_LIFE),
    目标魔法快照: jass.GetUnitState(target, jass.UNIT_STATE_MANA),
    攻击力快照: 读取单位攻击力(caster),
    快照周期ID: 0,
    刀光周期ID: 0,
    切割周期ID: 0,
    刀光计数: 0,
    切割计数: 0,
    已结束: false,
  };
  添加单位暂停(caster, context.来源);
  添加单位暂停(target, context.来源);
  jass.SetUnitInvulnerable(caster, true);
  jass.SetUnitInvulnerable(target, true);
  jass.SetUnitAnimationByIndex(caster, 8);
  registerManualBuff(caster, 十六夜咲夜BuffID.收缩世界吟唱, 配置.RD.吟唱秒, 0, { sourceUnit: caster });
  registerManualBuff(target, 十六夜咲夜BuffID.收缩世界目标封印, 配置.RD.吟唱秒, 0, { sourceUnit: caster });
  播放咲夜单位音效("gg_snd_IzayoiSakuya_RD1", caster);
  显示常规技能吟唱条({ 总时长: 配置.RD.吟唱秒, 标题文本: "收缩的世界", 提示文本: "时间正在收缩" });
  context.快照周期ID = 注册咲夜周期任务(配置.RD.快照周期毫秒, RD维持封印, context);
  addDelayedCallback(配置.RD.吟唱秒 * 1000, RD吟唱完成, context);
}

export function 注册十六夜咲夜RD(this: void): void {
  注册单位技能壳监听({ 名称: "十六夜咲夜-收缩的世界（RD）", 单位类型ID: 配置.英雄单位类型ID, 技能ID: 配置.技能.RD.类型ID, 获取或创建上下文: 获取RD监听上下文, 释放技能: 释放十六夜咲夜RD, 创建独立技能实例: true, 独立技能来源类型: "单位技能", 技能实例持续时间秒: 20 });
}

注册十六夜咲夜RD();

export {};
