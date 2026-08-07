/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../00．封印守卫战公共/00．类型";
import { 潮蚀巡鳞者配置 } from "./00．配置";
import {
  单位处于硬控制,
  命令攻击目标,
  取两点方向角,
  取单位X,
  取单位Y,
  读取单位攻击力,
  取最近玩家英雄,
  读取封印守卫战玩家英雄列表,
  读取封印守卫战敌人记录,
  封印守卫战单位存活,
  是封印守卫战玩家英雄,
  创建封印守卫战点特效,
} from "../00．封印守卫战公共/01．共享";

const { 开始充能, 停止单位充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, unit: any, params: any) => number;
  停止单位充能: (this: void, unit: any) => boolean;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 开始冲锋 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口") as {
  开始冲锋: (this: void, unit: any, params: any) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const jass = require("jass.common") as any;
const SquareRoot = jass.SquareRoot as (this: void, value: number) => number;
const Cos = jass.Cos as (this: void, value: number) => number;
const Sin = jass.Sin as (this: void, value: number) => number;
const DEGTORAD = jass.bj_DEGTORAD as number;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

function 取范围内突进目标(this: void, record: 封印守卫战敌人记录): any {
  const heroes = 读取封印守卫战玩家英雄列表();
  const x = 取单位X(record.单位);
  const y = 取单位Y(record.单位);
  let target: any = null;
  let best = 999999999;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!封印守卫战单位存活(hero)) continue;
    const dx = 取单位X(hero) - x;
    const dy = 取单位Y(hero) - y;
    const distance = SquareRoot(dx * dx + dy * dy);
    if (distance < 潮蚀巡鳞者配置.施法距离下限 || distance > 潮蚀巡鳞者配置.施法距离上限) continue;
    if (distance < best) {
      best = distance;
      target = hero;
    }
  }
  return target;
}

function 潮刃突袭充能周期(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "潮蚀巡鳞者" || record.充能ID !== chargeId) return;
  if (单位处于硬控制(unit) || !封印守卫战单位存活(record.当前目标)) 停止单位充能(unit);
}

function 潮刃突袭位移结束(this: void, unit: any, reason: string, _moveId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "潮蚀巡鳞者") return;
  const state = record.附加状态?.潮刃突袭;
  if (state == null || state.已结算) return;
  state.已结算 = true;
  创建封印守卫战点特效({
    模型路径: 潮蚀巡鳞者配置.结束特效,
    X: 取单位X(unit),
    Y: 取单位Y(unit),
    Z: 0,
    缩放: 0.75,
    持续秒: 1.2,
  });
  if (reason === "死亡" || reason === "中断" || reason === "主单位死亡") {
    if (record.附加状态 != null) delete record.附加状态.潮刃突袭;
    return;
  }
  const heroes = 读取封印守卫战玩家英雄列表();
  const damage = 读取单位攻击力(unit) * 潮蚀巡鳞者配置.伤害攻击力比例;
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!封印守卫战单位存活(target) || !是封印守卫战玩家英雄(target)) continue;
    const dx = 取单位X(target) - state.起点X;
    const dy = 取单位Y(target) - state.起点Y;
    const along = dx * Cos(state.朝向 * DEGTORAD) + dy * Sin(state.朝向 * DEGTORAD);
    const cross = dx * Sin(state.朝向 * DEGTORAD) - dy * Cos(state.朝向 * DEGTORAD);
    if (along < -64 || along > 潮蚀巡鳞者配置.突进距离 + 96 || (cross < 0 ? -cross : cross) > 潮蚀巡鳞者配置.命中范围) continue;
    造成单体技能伤害({ 来源: unit, 目标: target, 伤害: damage, 伤害类型: DAMAGE_TYPE_NORMAL, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: "单位技能", 标签: "第三章-潮蚀巡鳞者-潮刃突袭", 参与技能伤害加成: false });
    施加快速减速Buff(unit, target, 0, 潮蚀巡鳞者配置.命中减速比例, 潮蚀巡鳞者配置.命中减速秒, "潮蚀巡鳞者-潮刃突袭", "技能");
  }
  if (record.附加状态 != null) delete record.附加状态.潮刃突袭;
}

function 潮刃突袭充能完成(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "潮蚀巡鳞者" || record.充能ID !== chargeId) return;
  record.充能ID = 0;
  const target = record.当前目标;
  record.当前目标 = undefined;
  if (!封印守卫战单位存活(target)) return;
  const state = { 起点X: 取单位X(unit), 起点Y: 取单位Y(unit), 朝向: 取两点方向角(取单位X(unit), 取单位Y(unit), 取单位X(target), 取单位Y(target)), 已结算: false };
  if (record.附加状态 == null) record.附加状态 = {};
  record.附加状态.潮刃突袭 = state;
  const moveId = 开始冲锋(unit, { 角度: state.朝向, 距离: 潮蚀巡鳞者配置.突进距离, 持续时间: 潮蚀巡鳞者配置.突进持续秒, 检查地形: true, 朝向跟随位移: true, 暂停单位: true, 禁用碰撞: true, 位移特效: 潮蚀巡鳞者配置.突进特效, 结束回调: 潮刃突袭位移结束 });
  if (!(moveId > 0) && record.附加状态 != null) delete record.附加状态.潮刃突袭;
  record.下次技能毫秒 = getServerTime() + 潮蚀巡鳞者配置.技能冷却毫秒;
}

function 潮刃突袭充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "潮蚀巡鳞者") return;
  if (record.充能ID === chargeId) record.充能ID = 0;
  record.当前目标 = undefined;
  if (reason !== "完成") record.下次技能毫秒 = getServerTime() + 潮蚀巡鳞者配置.技能冷却毫秒;
}

export function 尝试释放潮刃突袭(this: void, record: 封印守卫战敌人记录): boolean {
  if (record.充能ID !== 0 || 当前有潮刃位移(record) || 单位处于硬控制(record.单位)) return false;
  const target = 取范围内突进目标(record);
  if (!封印守卫战单位存活(target)) return false;
  record.当前目标 = target;
  创建技能提示圈({ 类型: "方向直线", X: 取单位X(record.单位), Y: 取单位Y(record.单位), 宽度: 潮蚀巡鳞者配置.预警宽度, 长度: 潮蚀巡鳞者配置.预警长度, 朝向: 取两点方向角(取单位X(record.单位), 取单位Y(record.单位), 取单位X(target), 取单位Y(target)), 持续时间: 潮蚀巡鳞者配置.预警秒, 来源单位: record.单位 });
  const id = 开始充能(record.单位, { 持续时间: 潮蚀巡鳞者配置.预警秒, 强制硬直: true, 显示进度条特效: true, 周期回调间隔: 0.1, 周期回调: 潮刃突袭充能周期, 充能完成回调: 潮刃突袭充能完成, 结束回调: 潮刃突袭充能结束 });
  record.充能ID = id;
  return id > 0;
}

function 当前有潮刃位移(this: void, record: 封印守卫战敌人记录): boolean {
  return record.附加状态?.潮刃突袭 != null && record.附加状态.潮刃突袭.已结算 !== true;
}

export function 刷新潮蚀巡鳞者AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (当前有潮刃位移(record) || record.充能ID !== 0 || 当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 潮蚀巡鳞者配置.AI刷新毫秒;
  if (当前毫秒 >= record.下次技能毫秒 && 尝试释放潮刃突袭(record)) return;
  const target = 取最近玩家英雄(record.单位);
  if (封印守卫战单位存活(target)) {
    record.当前目标 = target;
    命令攻击目标(record.单位, target);
  }
}

export function 清理潮蚀巡鳞者机制(this: void, record: 封印守卫战敌人记录): void {
  if (record.充能ID !== 0 && 封印守卫战单位存活(record.单位)) 停止单位充能(record.单位);
  record.充能ID = 0;
  record.当前目标 = undefined;
  if (record.附加状态 != null) delete record.附加状态.潮刃突袭;
}
