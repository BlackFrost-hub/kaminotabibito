/** @noSelfInFile */
// 塞拉斯火/冰/雷普通魔法 + 灼烧/冻结/减速 + W 大魔法化。
// 源 JASS 真源：主要技能.j。伤害走统一技能伤害封装，控制走项目控制封装，Buff 走 TS Buff 表。
// 审计保留项见 00．配置.ts 注释与 塞拉斯迁移计划.md 差异清单。

import { 塞拉斯技能配置, 塞拉斯元素 } from "./00．配置";
import { 塞拉斯BuffID } from "../../../../05．Buff系统/03．Buff表/02．英雄/06．塞拉斯";
import {
  获取或创建塞拉斯魔法状态,
  消费塞拉斯大魔法化,
  设置塞拉斯攻击标记,
  塞拉斯魔法技能增幅倍率,
} from "./01．状态表";
import { 塞拉斯元素施法后自动关闭 } from "./02．技能入口与关闭";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 读取单位攻击力, 单位存活 } from "../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;

const { 施加眩晕, 施加减速 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
  施加减速: (this: void, source: any, target: any, reduceRatio: number, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 获取单位Buff层数 } = require("系统.05．Buff系统.00．Buff系统") as {
  获取单位Buff层数: (this: void, unit: any, buffID: string) => number;
};
const { 造成批量AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成批量AOE技能伤害: (this: void, params: any) => number;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, params: any) => boolean;
};
const { 获取范围敌军, 在坐标播放特效 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
  在坐标播放特效: (this: void, model: string, x: number, y: number, z: number, size: number, lifeSec: number) => void;
};
const { createTimedUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, durationSec: number) => any;
};
const { Sound3DII_UnitPlayReuse } = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放") as {
  Sound3DII_UnitPlayReuse: (this: void, path: string, unit: any, cutoff: number) => any;
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, 单位: any, 技能代码: number, 冷却: number, 最大冷却: number) => boolean;
};

const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (this: void, unit: any, abilityId: number) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;

const 配置 = 塞拉斯技能配置;
const 元素配置 = 配置.元素魔法;
const 英雄单位类型ID = 配置.单位类型ID;
const Q入口类型ID = 配置.Q入口.技能类型ID;

interface 元素施法上下文 {
  施法者: any;
  技能实例ID?: number;
  元素: 塞拉斯元素;
  技能类型ID: number;
  结算次数: number;
  已结算次数: number;
  伤害快照: number;
  目标单位: any;
  目标X: number;
  目标Y: number;
  tick回调ID: number;
}

const 元素上下文表: Record<number, 元素施法上下文 | undefined> = {};
const 灼烧周期表: Record<number, { caster: any; target: any; 回调ID: number } | undefined> = {};
let 死亡监听已注册 = false;

function 取句柄ID(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

function 过滤元素魔法标的(this: void, 敌军列表: any[]): any[] {
  const result: any[] = [];
  for (let i = 0; i < 敌军列表.length; i++) {
    const u = 敌军列表[i];
    if (u == null || u === 0) continue;
    if (IsUnitType(u, UNIT_TYPE_ANCIENT) || IsUnitType(u, UNIT_TYPE_MECHANICAL) || IsUnitType(u, UNIT_TYPE_STRUCTURE)) continue;
    result.push(u);
  }
  return result;
}

function 清理元素上下文(this: void, context: 元素施法上下文): void {
  if (context.tick回调ID !== 0) {
    removePeriodicCallback(context.tick回调ID);
    context.tick回调ID = 0;
  }
  const id = 取句柄ID(context.施法者);
  if (id !== 0 && 元素上下文表[id] === context) delete 元素上下文表[id];
}

// ---------------------------------------------------------------------------
// 灼烧（源 JASS SLSQ 计数：每次火焰命中 +2 层，每秒 -1 层并按已损失生命 1.5% 结算）
// ---------------------------------------------------------------------------

function 推进灼烧周期(this: void, variable?: any): void {
  const record = variable as { caster: any; target: any; 回调ID: number } | undefined;
  if (record == null) return;
  const caster = record.caster;
  const target = record.target;

  if (caster == null || caster === 0 || target == null || target === 0 || !单位存活(target)) {
    removePeriodicCallback(record.回调ID);
    delete 灼烧周期表[record.回调ID];
    return;
  }
  const 层数 = 获取单位Buff层数(target, 塞拉斯BuffID.灼烧);
  if (层数 <= 0) {
    removePeriodicCallback(record.回调ID);
    delete 灼烧周期表[record.回调ID];
    return;
  }

  registerManualBuff(target, 塞拉斯BuffID.灼烧, 层数 * 1.0, 0.015, { stack: 层数 - 1, allowZeroStack: true, sourceUnit: caster });

  // 每秒目标已损失生命值的 1.5%；灼烧周期伤害不参与 E 增幅、不触发远程普攻被动（标签过滤）
  const 已损失生命 = GetUnitState(target, UNIT_STATE_MAX_LIFE) - GetUnitState(target, UNIT_STATE_LIFE);
  const 伤害 = 已损失生命 * 元素配置.火焰.灼烧每秒已损失生命比例;
  if (伤害 > 0.5 && 单位存活(caster)) {
    造成技能伤害({
      来源: caster,
      目标: target,
      伤害: 伤害,
      伤害类型: jass.DAMAGE_TYPE_FIRE,
      attackType: jass.ATTACK_TYPE_NORMAL,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      标签: "塞拉斯-灼烧",
    });
  }
  createTimedUnitEffect(target, 元素配置.火焰.灼烧特效.挂点, 元素配置.火焰.灼烧特效.模型路径, 元素配置.火焰.灼烧特效.持续秒);
}

function 施加灼烧(this: void, caster: any, target: any): void {
  const 当前层数 = 获取单位Buff层数(target, 塞拉斯BuffID.灼烧);
  const 新层数 = 当前层数 + 元素配置.火焰.灼烧每次命中加层;
  registerManualBuff(target, 塞拉斯BuffID.灼烧, 新层数 * 1.0, 0.015, { stack: 新层数, sourceUnit: caster });
  // 源 JASS 每次命中创建独立 1 秒周期计时器；此处按回调ID登记，便于死亡清理
  const record: { caster: any; target: any; 回调ID: number } = { caster: caster, target: target, 回调ID: 0 };
  record.回调ID = addPeriodicCallback(1000, 推进灼烧周期 as unknown as (this: void, variable?: any) => void, record);
  灼烧周期表[record.回调ID] = record;
}

// ---------------------------------------------------------------------------
// 元素命中后处理（统一批量 AOE 结算后回调）
// ---------------------------------------------------------------------------

function 元素命中结算处理(this: void, target: any, _索引: number, _成功: boolean, 变量?: any): void {
  if (target == null || target === 0) return;
  const payload = 变量 as { caster: any; 元素: 塞拉斯元素 } | undefined;
  if (payload == null) return;
  const caster = payload.caster;
  const 元素 = payload.元素;

  if (元素 === "火") {
    施加灼烧(caster, target);
    设置塞拉斯攻击标记(caster, "火");
    registerManualBuff(caster, 塞拉斯BuffID.火焰附加攻击, 30, 1, { stack: 1 });
  } else if (元素 === "冰") {
    // 冻结命中目标 0.6 秒（审计：源 JASS 冻结施法者本人，按介绍修正）
    施加眩晕(caster, target, 元素配置.冰冻.冻结秒, 塞拉斯BuffID.冻结, "技能");
    registerManualBuff(target, 塞拉斯BuffID.冻结, 元素配置.冰冻.冻结秒, 1, { stack: 1, sourceUnit: caster });
    设置塞拉斯攻击标记(caster, "冰");
    registerManualBuff(caster, 塞拉斯BuffID.冰冻附加攻击, 30, 1, { stack: 1 });
  } else if (元素 === "雷") {
    // 减速口径按技能介绍 1.4 秒（JASS 1.20 秒保留审计）
    施加减速(caster, target, 元素配置.雷击.减速比例, 元素配置.雷击.减速秒, 塞拉斯BuffID.雷击减速, "技能");
    registerManualBuff(target, 塞拉斯BuffID.雷击减速, 元素配置.雷击.减速秒, 元素配置.雷击.减速比例, { stack: 1, sourceUnit: caster });
    createTimedUnitEffect(target, "origin", 元素配置.雷击.目标特效.模型路径, 元素配置.雷击.目标特效.持续秒);
    设置塞拉斯攻击标记(caster, "雷");
    registerManualBuff(caster, 塞拉斯BuffID.雷击附加攻击, 30, 1, { stack: 1 });
  }
}

// ---------------------------------------------------------------------------
// tick 结算
// ---------------------------------------------------------------------------

function 播放元素落点表现(this: void, caster: any, 元素: 塞拉斯元素, x: number, y: number): void {
  if (元素 === "火") {
    for (let i = 0; i < 元素配置.火焰.特效.length; i++) {
      const fx = 元素配置.火焰.特效[i];
      在坐标播放特效(fx.模型路径, x, y, 0, fx.缩放, fx.持续秒);
    }
  } else if (元素 === "冰") {
    for (let i = 0; i < 元素配置.冰冻.特效.length; i++) {
      const fx = 元素配置.冰冻.特效[i];
      在坐标播放特效(fx.模型路径, x, y, 0, fx.缩放, fx.持续秒);
    }
  } else if (元素 === "雷") {
    Sound3DII_UnitPlayReuse(元素配置.雷击.目标音效.路径, caster, 元素配置.雷击.目标音效.裁断距离);
    在坐标播放特效(元素配置.雷击.落点特效.模型路径, x, y, 0, 元素配置.雷击.落点特效.缩放, 元素配置.雷击.落点特效.持续秒);
  }
}

function 推进元素魔法tick(this: void, variable?: any): void {
  const context = variable as 元素施法上下文 | undefined;
  if (context == null) return;
  const caster = context.施法者;
  if (caster == null || caster === 0 || !单位存活(caster)) {
    清理元素上下文(context);
    return;
  }

  // 目标点：目标单位存活则跟随，否则使用施法时坐标（源 JASS 以目标单位坐标为准）
  let x = context.目标X;
  let y = context.目标Y;
  const 目标单位 = context.目标单位;
  if (目标单位 != null && 目标单位 !== 0 && 单位存活(目标单位)) {
    x = GetUnitX(目标单位);
    y = GetUnitY(目标单位);
    context.目标X = x;
    context.目标Y = y;
  }

  // 伤害前后顺序按源 JASS：先命中特效/控制，再统一伤害封装（批量 AOE 结算后处理器挂元素状态）
  const 敌军列表 = 过滤元素魔法标的(获取范围敌军(caster, x, y, 元素配置.范围));
  if (context.伤害快照 > 0 && 敌军列表.length > 0) {
    const 伤害类型 =
      context.元素 === "火" ? jass.DAMAGE_TYPE_FIRE : context.元素 === "冰" ? jass.DAMAGE_TYPE_COLD : jass.DAMAGE_TYPE_LIGHTNING;
    造成批量AOE技能伤害({
      来源: caster,
      目标列表: 敌军列表,
      伤害: context.伤害快照,
      伤害类型: 伤害类型,
      attackType: jass.ATTACK_TYPE_NORMAL,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      标签: "塞拉斯-元素魔法",
      技能ID: context.技能类型ID,
      技能实例ID: context.技能实例ID,
      变量: { caster: caster, 元素: context.元素 },
      每目标结算后处理器: 元素命中结算处理,
    });
  }

  播放元素落点表现(caster, context.元素, x, y);

  context.已结算次数 = context.已结算次数 + 1;
  if (context.已结算次数 >= context.结算次数) {
    清理元素上下文(context);
    // 源 JASS：元素施放 0.15 秒后自动关闭普通魔法面板
    塞拉斯元素施法后自动关闭(caster);
  }
}

// ---------------------------------------------------------------------------
// 施法入口
// ---------------------------------------------------------------------------

function 取元素与类型ID(this: void, 技能类型ID: number): 塞拉斯元素 {
  if (技能类型ID === 元素配置.火焰技能类型ID) return "火";
  if (技能类型ID === 元素配置.冰冻技能类型ID) return "冰";
  if (技能类型ID === 元素配置.雷击技能类型ID) return "雷";
  return "";
}

function 取元素伤害类型基数(this: void, 元素: 塞拉斯元素): { 基础倍率: number; 每级成长: number } {
  if (元素 === "冰") return { 基础倍率: 元素配置.冰冻.基础倍率, 每级成长: 元素配置.冰冻.每级成长 };
  if (元素 === "雷") return { 基础倍率: 元素配置.雷击.基础倍率, 每级成长: 元素配置.雷击.每级成长 };
  return { 基础倍率: 元素配置.火焰.基础倍率, 每级成长: 元素配置.火焰.每级成长 };
}

function 播放元素施法音效(this: void, caster: any, 元素: 塞拉斯元素, 是大魔法: boolean): void {
  if (元素 === "冰") {
    const snd = 是大魔法 ? 元素配置.冰冻.音效大魔法 : 元素配置.冰冻.音效普通;
    Sound3DII_UnitPlayReuse(snd.路径, caster, snd.裁断距离);
  } else if (元素 === "雷") {
    const snd = 是大魔法 ? 元素配置.雷击.音效大魔法 : 元素配置.雷击.音效普通;
    Sound3DII_UnitPlayReuse(snd.路径, caster, snd.裁断距离);
  } else {
    const snd = 是大魔法 ? 元素配置.火焰.音效大魔法 : 元素配置.火焰.音效普通;
    Sound3DII_UnitPlayReuse(snd.路径, caster, snd.裁断距离);
  }
}

function 获取或创建元素上下文(this: void, unit: any): 元素施法上下文 | undefined {
  const id = 取句柄ID(unit);
  if (id === 0) return undefined;
  const current = 元素上下文表[id];
  if (current != null && current.tick回调ID !== 0) return undefined; // 上一次未结算完成时拒绝重复施法
  if (current != null) return current;
  const created: 元素施法上下文 = {
    施法者: unit,
    元素: "",
    技能类型ID: 0,
    结算次数: 1,
    已结算次数: 0,
    伤害快照: 0,
    目标单位: null,
    目标X: 0,
    目标Y: 0,
    tick回调ID: 0,
  };
  元素上下文表[id] = created;
  return created;
}

function 释放元素魔法(this: void, context: 元素施法上下文, caster: any, 技能实例ID?: number): void {
  const 技能类型ID = 取当前施法技能类型ID();
  const 元素 = 取元素与类型ID(技能类型ID);
  if (元素 === "") return;

  const state = 获取或创建塞拉斯魔法状态(caster);
  const 是大魔法 = 消费塞拉斯大魔法化(caster);
  if (是大魔法) {
    // 消费大魔法状态：移除 Buff 图标
    移除单位指定Buff(caster, 塞拉斯BuffID.大魔法化);
  }
  if (state != null) state.当前元素 = 元素;

  const 等级 = GetUnitAbilityLevel(caster, Q入口类型ID);
  const 倍率组 = 取元素伤害类型基数(元素);
  const 攻击力 = 读取单位攻击力(caster);
  const 增幅 = 塞拉斯魔法技能增幅倍率(caster);
  const 伤害快照 = 攻击力 * (倍率组.基础倍率 + 倍率组.每级成长 * 等级) * 增幅;

  context.施法者 = caster;
  context.技能实例ID = 技能实例ID;
  context.元素 = 元素;
  context.技能类型ID = 技能类型ID;
  context.结算次数 = 是大魔法 ? 元素配置.大魔法结算次数 : 元素配置.普通结算次数;
  context.已结算次数 = 0;
  context.伤害快照 = 伤害快照;

  const 目标单位 = GetSpellTargetUnit();
  context.目标单位 = 目标单位;
  if (目标单位 != null && 目标单位 !== 0) {
    context.目标X = GetUnitX(目标单位);
    context.目标Y = GetUnitY(目标单位);
  } else {
    context.目标X = GetSpellTargetX();
    context.目标Y = GetSpellTargetY();
  }

  播放元素施法音效(caster, 元素, 是大魔法);

  context.tick回调ID = addPeriodicCallback(
    元素配置.tick间隔秒 * 1000,
    推进元素魔法tick as unknown as (this: void, variable?: any) => void,
    context,
  );
}

// 技能壳监听按技能ID分发，但释放时需要知道具体技能ID；这里通过三个独立注册各自绑定
let 当前施法技能类型ID缓存 = 0;

function 取当前施法技能类型ID(this: void): number {
  return 当前施法技能类型ID缓存;
}

function 释放火焰魔法(this: void, context: 元素施法上下文, caster: any, 技能实例ID?: number): void {
  当前施法技能类型ID缓存 = 元素配置.火焰技能类型ID;
  释放元素魔法(context, caster, 技能实例ID);
}

function 释放冰冻魔法(this: void, context: 元素施法上下文, caster: any, 技能实例ID?: number): void {
  当前施法技能类型ID缓存 = 元素配置.冰冻技能类型ID;
  释放元素魔法(context, caster, 技能实例ID);
}

function 释放雷击魔法(this: void, context: 元素施法上下文, caster: any, 技能实例ID?: number): void {
  当前施法技能类型ID缓存 = 元素配置.雷击技能类型ID;
  释放元素魔法(context, caster, 技能实例ID);
}

function 元素魔法可释放(this: void, context: 元素施法上下文): boolean {
  return context.tick回调ID === 0;
}

// ---------------------------------------------------------------------------
// W 大魔法化
// ---------------------------------------------------------------------------

interface W上下文 {
  施法者: any;
}

function 获取或创建W上下文(this: void, unit: any): W上下文 | undefined {
  if (unit == null || unit === 0) return undefined;
  return { 施法者: unit };
}

function 释放W大魔法化(this: void, _context: W上下文, caster: any): void {
  const state = 获取或创建塞拉斯魔法状态(caster);
  if (state == null) return;
  if (state.大魔法化) return; // 重复施法不叠加，旧状态由消费逻辑管理

  for (let i = 0; i < 配置.W.音效.length; i++) {
    const snd = 配置.W.音效[i];
    Sound3DII_UnitPlayReuse(snd.路径, caster, snd.裁断距离);
  }
  const x = GetUnitX(caster);
  const y = GetUnitY(caster);
  for (let i = 0; i < 配置.W.特效.length; i++) {
    const fx = 配置.W.特效[i];
    在坐标播放特效(fx.模型路径, x, y, 0, fx.缩放, fx.持续秒);
  }

  // 同步置大魔法化状态；审计：源 JASS 直接改真实冷却为 0.05，TS 禁止，只记状态
  state.大魔法化 = true;
  registerManualBuff(caster, 塞拉斯BuffID.大魔法化, 60, 1, { stack: 1 });

  // W 冷却按等级：20 - 0.5 × 技能等级（技能自身定义，同步设置）
  const W等级 = GetUnitAbilityLevel(caster, 配置.W.技能类型ID);
  const W冷却 = 配置.W.冷却基础秒 - 配置.W.冷却每级递减秒 * W等级;
  技能_设置技能冷却时间(caster, 配置.W.技能类型ID, W冷却, W冷却);
}

// ---------------------------------------------------------------------------
// 死亡清理
// ---------------------------------------------------------------------------

function 元素魔法单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;

  const id = 取句柄ID(dyingUnit);
  if (id !== 0) {
    const context = 元素上下文表[id];
    if (context != null) 清理元素上下文(context);
  }

  // 清理以该单位为目标的灼烧周期
  for (const key in 灼烧周期表) {
    const record = 灼烧周期表[Number(key)];
    if (record == null) continue;
    if (record.target === dyingUnit || record.caster === dyingUnit) {
      removePeriodicCallback(record.回调ID);
      delete 灼烧周期表[Number(key)];
    }
  }
}

export function 注册塞拉斯元素魔法(this: void): void {
  注册单位技能壳监听({
    名称: "塞拉斯-火焰魔法（A0JQ）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 元素配置.火焰技能ID,
    获取或创建上下文: 获取或创建元素上下文,
    可释放: 元素魔法可释放,
    释放技能: 释放火焰魔法,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 元素配置.tick间隔秒 * 元素配置.大魔法结算次数 + 1,
  });
  注册单位技能壳监听({
    名称: "塞拉斯-冰冻魔法（A0JR）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 元素配置.冰冻技能ID,
    获取或创建上下文: 获取或创建元素上下文,
    可释放: 元素魔法可释放,
    释放技能: 释放冰冻魔法,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 元素配置.tick间隔秒 * 元素配置.大魔法结算次数 + 1,
  });
  注册单位技能壳监听({
    名称: "塞拉斯-雷击魔法（A0JS）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 元素配置.雷击技能ID,
    获取或创建上下文: 获取或创建元素上下文,
    可释放: 元素魔法可释放,
    释放技能: 释放雷击魔法,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 元素配置.tick间隔秒 * 元素配置.大魔法结算次数 + 1,
  });
  注册单位技能壳监听({
    名称: "塞拉斯-大魔法化（W）",
    单位类型ID: 英雄单位类型ID,
    技能ID: 配置.W.技能ID,
    获取或创建上下文: 获取或创建W上下文,
    释放技能: 释放W大魔法化,
    创建独立技能实例: false,
  });
  if (!死亡监听已注册) {
    死亡监听已注册 = true;
    registerDeathListener(元素魔法单位死亡);
  }
}

注册塞拉斯元素魔法();
