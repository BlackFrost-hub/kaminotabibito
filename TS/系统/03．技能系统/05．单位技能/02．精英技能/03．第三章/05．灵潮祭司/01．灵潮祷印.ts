/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/00．类型";
import { 灵潮祭司配置 } from "./00．配置";
import {
  单位处于硬控制,
  命令攻击目标,
  取单位X,
  取单位Y,
  读取单位攻击力,
  读取单位生命,
  读取单位最大生命,
  读取封印守卫战敌人列表,
  读取封印守卫战敌人记录,
  读取封印守卫战玩家英雄列表,
  封印守卫战单位存活,
  是封印守卫战玩家英雄,
  创建封印守卫战点特效,
} from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/01．共享";

const { 开始充能, 停止单位充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, unit: any, params: any) => number;
  停止单位充能: (this: void, unit: any) => boolean;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 创建持续单位连线 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.07．机制连线.01．持续单位连线") as {
  创建持续单位连线: (this: void, params: any) => any;
};
const { 闪电效果代码 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码") as {
  闪电效果代码: { 蓝色细束: string };
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number, sourceName?: string, sourceType?: string, displayBuffID?: string) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const jass = require("jass.common") as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 灵潮祭司BuffID = {
  祷印减速: "SGW6",
  潮蚀护持: "SGW7",
} as const;

interface 灵潮祷印状态 {
  目标X: number;
  目标Y: number;
}

interface 潮蚀护持状态 {
  祭司: any;
  目标: any;
  连线: any;
  结束毫秒: number;
  下次治疗毫秒: number;
}

function 获取祭司附加状态(this: void, record: 封印守卫战敌人记录): Record<string, any> {
  if (record.附加状态 == null) record.附加状态 = {};
  return record.附加状态;
}

function 选择最密集玩家位置(this: void): 灵潮祷印状态 | undefined {
  const heroes = 读取封印守卫战玩家英雄列表();
  let bestCount = 0;
  let best: 灵潮祷印状态 | undefined;
  for (let i = 0; i < heroes.length; i++) {
    const center = heroes[i];
    if (!封印守卫战单位存活(center)) continue;
    let count = 0;
    for (let j = 0; j < heroes.length; j++) {
      const target = heroes[j];
      if (!封印守卫战单位存活(target)) continue;
      const dx = 取单位X(target) - 取单位X(center);
      const dy = 取单位Y(target) - 取单位Y(center);
      if (dx * dx + dy * dy <= 灵潮祭司配置.祷印半径 * 灵潮祭司配置.祷印半径) count += 1;
    }
    if (count > bestCount) {
      bestCount = count;
      best = { 目标X: 取单位X(center), 目标Y: 取单位Y(center) };
    }
  }
  return best;
}

function 灵潮祷印充能周期(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "灵潮祭司" || record.充能ID !== chargeId) return;
  if (单位处于硬控制(unit)) 停止单位充能(unit);
}

function 灵潮祷印充能完成(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "灵潮祭司" || record.充能ID !== chargeId) return;
  record.充能ID = 0;
  const state = record.附加状态?.灵潮祷印 as 灵潮祷印状态 | undefined;
  if (state == null) return;
  创建封印守卫战点特效({ 模型路径: 灵潮祭司配置.爆发特效, X: state.目标X, Y: state.目标Y, Z: 0, 缩放: 1, 持续秒: 1.5 });
  const heroes = 读取封印守卫战玩家英雄列表();
  const damage = 读取单位攻击力(unit) * 灵潮祭司配置.祷印伤害攻击力比例;
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!封印守卫战单位存活(target) || !是封印守卫战玩家英雄(target)) continue;
    const dx = 取单位X(target) - state.目标X;
    const dy = 取单位Y(target) - state.目标Y;
    if (dx * dx + dy * dy > 灵潮祭司配置.祷印半径 * 灵潮祭司配置.祷印半径) continue;
    造成单体技能伤害({ 来源: unit, 目标: target, 伤害: damage, 伤害类型: DAMAGE_TYPE_NORMAL, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: "单位技能", 标签: "第三章-灵潮祭司-灵潮祷印", 参与技能伤害加成: false });
    施加快速减速Buff(unit, target, 0, 灵潮祭司配置.祷印减速比例, 灵潮祭司配置.祷印减速秒, "灵潮祭司-灵潮祷印", "技能", 灵潮祭司BuffID.祷印减速);
  }
  if (record.附加状态 != null) {
    delete record.附加状态.灵潮祷印;
    record.附加状态.灵潮祷印冷却毫秒 = getServerTime() + 灵潮祭司配置.祷印冷却毫秒;
  }
}

function 灵潮祷印充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "灵潮祭司") return;
  if (record.充能ID === chargeId) record.充能ID = 0;
  if (record.附加状态 != null) delete record.附加状态.灵潮祷印;
  if (reason !== "完成") 获取祭司附加状态(record).灵潮祷印冷却毫秒 = getServerTime() + 灵潮祭司配置.祷印冷却毫秒;
}

export function 尝试释放灵潮祷印(this: void, record: 封印守卫战敌人记录): boolean {
  if (record.充能ID !== 0 || 单位处于硬控制(record.单位)) return false;
  const state = 选择最密集玩家位置();
  if (state == null) return false;
  const now = getServerTime();
  if ((record.附加状态?.灵潮祷印冷却毫秒 ?? 0) > now) return false;
  获取祭司附加状态(record).灵潮祷印 = state;
  创建技能提示圈({ 类型: "圆形", X: state.目标X, Y: state.目标Y, 半径: 灵潮祭司配置.祷印半径, 持续时间: 灵潮祭司配置.祷印预警秒, 来源单位: record.单位 });
  创建封印守卫战点特效({ 模型路径: 灵潮祭司配置.祷印特效, X: state.目标X, Y: state.目标Y, Z: 0, 缩放: 0.9, 持续秒: 灵潮祭司配置.祷印预警秒 + 0.1 });
  const id = 开始充能(record.单位, { 持续时间: 灵潮祭司配置.祷印预警秒, 强制硬直: true, 显示进度条特效: true, 周期回调间隔: 0.1, 周期回调: 灵潮祷印充能周期, 充能完成回调: 灵潮祷印充能完成, 结束回调: 灵潮祷印充能结束 });
  record.充能ID = id;
  return id > 0;
}

function 是灵潮祭司精英(this: void, 类型: string): boolean {
  return 类型 === "碎礁投石手" || 类型 === "灵潮祭司" || 类型 === "金鳞执刑官" || 类型 === "深渊鳞将";
}

function 选择潮蚀护持目标(this: void, source: 封印守卫战敌人记录): any {
  const list = 读取封印守卫战敌人列表();
  let eliteTarget: any = null;
  let eliteRatio = 999999;
  let normalTarget: any = null;
  let normalRatio = 999999;
  for (let i = 0; i < list.length; i++) {
    const record = list[i];
    if (record === source || !封印守卫战单位存活(record.单位)) continue;
    const dx = 取单位X(record.单位) - 取单位X(source.单位);
    const dy = 取单位Y(record.单位) - 取单位Y(source.单位);
    if (dx * dx + dy * dy > 灵潮祭司配置.支持范围 * 灵潮祭司配置.支持范围) continue;
    const maxLife = 读取单位最大生命(record.单位);
    const ratio = maxLife > 0 ? 读取单位生命(record.单位) / maxLife : 1;
    if (是灵潮祭司精英(record.类型) && ratio < eliteRatio) {
      eliteRatio = ratio;
      eliteTarget = record.单位;
    } else if (record.类型 === "潮蚀巡鳞者" && ratio < normalRatio) {
      normalRatio = ratio;
      normalTarget = record.单位;
    }
  }
  return eliteTarget ?? normalTarget;
}

function 结束潮蚀护持(this: void, record: 封印守卫战敌人记录, reason: string): void {
  const state = record.附加状态?.潮蚀护持 as 潮蚀护持状态 | undefined;
  if (state == null) return;
  if (state.连线 != null) state.连线.停止(reason);
  if (封印守卫战单位存活(state.目标)) 移除单位指定Buff(state.目标, 灵潮祭司BuffID.潮蚀护持);
  if (record.附加状态 != null) delete record.附加状态.潮蚀护持;
}

function 潮蚀护持周期(this: void, source: any, target: any): void {
  const record = 读取封印守卫战敌人记录(source);
  if (record == null || record.类型 !== "灵潮祭司") return;
  const state = record.附加状态?.潮蚀护持 as 潮蚀护持状态 | undefined;
  if (state == null || state.目标 !== target) return;
  const now = getServerTime();
  if (!封印守卫战单位存活(target) || now >= state.结束毫秒 || 单位处于硬控制(source)) {
    结束潮蚀护持(record, "条件中断");
    return;
  }
  const dx = 取单位X(source) - 取单位X(target);
  const dy = 取单位Y(source) - 取单位Y(target);
  if (dx * dx + dy * dy > 灵潮祭司配置.护持断开距离 * 灵潮祭司配置.护持断开距离) {
    结束潮蚀护持(record, "距离断开");
    return;
  }
  if (now >= state.下次治疗毫秒) {
    const heal = 读取单位最大生命(target) * 灵潮祭司配置.护持每秒治疗比例;
    if (heal > 0) {
      doHeal({ HealSource: source, HealTarget: target, HealAmount: heal, ItemHeal: false, HealEffect: false });
      创建封印守卫战点特效({ 模型路径: 灵潮祭司配置.回灌特效, X: 取单位X(target), Y: 取单位Y(target), Z: 0, 缩放: 0.55, 持续秒: 0.8 });
    }
    state.下次治疗毫秒 = now + 1000;
  }
}

function 潮蚀护持连线断开(this: void, _reason: string): void {
  // 连接的条件检查和状态清理由潮蚀护持周期统一完成，避免回调丢失施法者引用。
}

function 释放潮蚀护持(this: void, record: 封印守卫战敌人记录): boolean {
  if (record.附加状态?.潮蚀护持 != null || 单位处于硬控制(record.单位)) return false;
  const target = 选择潮蚀护持目标(record);
  if (!封印守卫战单位存活(target)) return false;
  const now = getServerTime();
  if ((record.附加状态?.潮蚀护持冷却毫秒 ?? 0) > now) return false;
  const state: 潮蚀护持状态 = { 祭司: record.单位, 目标: target, 连线: null, 结束毫秒: now + 灵潮祭司配置.护持持续秒 * 1000, 下次治疗毫秒: now + 1000 };
  获取祭司附加状态(record).潮蚀护持 = state;
  registerManualBuff(target, 灵潮祭司BuffID.潮蚀护持, 灵潮祭司配置.护持持续秒, 灵潮祭司配置.护持减伤比例, { sourceUnit: record.单位, effectSourceName: "灵潮祭司-潮蚀护持", effectSourceType: "技能" });
  state.连线 = 创建持续单位连线({ 名称: "第三章-灵潮祭司-潮蚀护持", 起点单位: record.单位, 终点单位: target, 闪电代码: 闪电效果代码.蓝色细束, 持续秒: 灵潮祭司配置.护持持续秒, 断开距离: 灵潮祭司配置.护持断开距离, Tick间隔毫秒: 50, on周期: 潮蚀护持周期, on断开: 潮蚀护持连线断开 });
  if (state.连线 == null) {
    结束潮蚀护持(record, "创建失败");
    return false;
  }
  获取祭司附加状态(record).潮蚀护持冷却毫秒 = now + 灵潮祭司配置.护持冷却毫秒;
  return true;
}

export function 修正潮蚀护持减伤(this: void, context: any): number {
  const target = context?.target;
  if (!封印守卫战单位存活(target)) return context.currentDamage;
  const list = 读取封印守卫战敌人列表();
  const now = getServerTime();
  for (let i = 0; i < list.length; i++) {
    const state = list[i].附加状态?.潮蚀护持 as 潮蚀护持状态 | undefined;
    if (state != null && state.目标 === target && now < state.结束毫秒) return context.currentDamage * (1 - 灵潮祭司配置.护持减伤比例);
  }
  return context.currentDamage;
}

export function 刷新灵潮祭司AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (record.充能ID !== 0 || 当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 灵潮祭司配置.AI刷新毫秒;
  const support = record.附加状态?.潮蚀护持 as 潮蚀护持状态 | undefined;
  if (support != null && (当前毫秒 >= support.结束毫秒 || !封印守卫战单位存活(support.目标) || 单位处于硬控制(record.单位))) 结束潮蚀护持(record, "条件中断");
  if (当前毫秒 >= (record.附加状态?.灵潮祷印冷却毫秒 ?? 0) && 尝试释放灵潮祷印(record)) return;
  if (当前毫秒 >= (record.附加状态?.潮蚀护持冷却毫秒 ?? 0) && 释放潮蚀护持(record)) return;
  const target = 读取封印守卫战玩家英雄列表()[0];
  if (封印守卫战单位存活(target)) {
    record.当前目标 = target;
    命令攻击目标(record.单位, target);
  }
}

export function 清理灵潮祭司机制(this: void, record: 封印守卫战敌人记录): void {
  if (record.充能ID !== 0 && 封印守卫战单位存活(record.单位)) 停止单位充能(record.单位);
  record.充能ID = 0;
  结束潮蚀护持(record, "机制清理");
  record.当前目标 = undefined;
  if (record.附加状态 != null) delete record.附加状态.灵潮祷印;
}
