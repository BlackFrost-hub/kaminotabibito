/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/00．类型";
import { 碎礁投石手配置 } from "./00．配置";
import {
  单位处于硬控制,
  命令攻击目标,
  取单位X,
  取单位Y,
  读取单位攻击力,
  取单位距离平方,
  读取封印守卫战玩家英雄列表,
  读取封印守卫战敌人记录,
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
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { 创建原生弹幕, 销毁原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, params: any) => any;
  销毁原生弹幕: (this: void, id: number, reason?: string) => void;
};
const { 创建二阶贝塞尔加速度抛物线轨迹 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index") as {
  创建二阶贝塞尔加速度抛物线轨迹: (this: void, startX: number, startY: number, startZ: number, controlX: number, controlY: number, endX: number, endY: number, endZ: number, height: number, speed: number) => any;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

const jass = require("jass.common") as any;
const CreateDeadDestructable = jass.CreateDeadDestructable as (this: void, objectId: number, x: number, y: number, face: number, scale: number, variation: number) => any;
const RemoveDestructable = jass.RemoveDestructable as (this: void, destructable: any) => void;
const GetRandomReal = jass.GetRandomReal as (this: void, low: number, high: number) => number;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const 岩石物编ID = stringToFourCCSafe(碎礁投石手配置.落地装饰物ID);

interface 碎礁投掷弹幕状态 {
  来源: any;
  目标X: number;
  目标Y: number;
  已结算: boolean;
}

interface 碎礁岩石删除状态 {
  岩石: any;
  删除回调ID: number;
}

const 活动弹幕ID列表: number[] = [];
const 弹幕状态表: Record<number, 碎礁投掷弹幕状态 | undefined> = {};
const 岩石状态列表: 碎礁岩石删除状态[] = [];

function 取最远玩家英雄(this: void, record: 封印守卫战敌人记录): any {
  const heroes = 读取封印守卫战玩家英雄列表();
  let target: any = null;
  let bestDistance = -1;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!封印守卫战单位存活(hero)) continue;
    const distance = 取单位距离平方(record.单位, hero);
    if (distance > bestDistance) {
      bestDistance = distance;
      target = hero;
    }
  }
  return target;
}

function 投石手被近身(this: void, record: 封印守卫战敌人记录): boolean {
  const heroes = 读取封印守卫战玩家英雄列表();
  for (let i = 0; i < heroes.length; i++) {
    if (封印守卫战单位存活(heroes[i]) && 取单位距离平方(record.单位, heroes[i]) <= 碎礁投石手配置.近身禁止距离 * 碎礁投石手配置.近身禁止距离) return true;
  }
  return false;
}

function 删除碎礁岩石(this: void, variable?: any): void {
  const state = variable as 碎礁岩石删除状态 | undefined;
  if (state == null) return;
  if (state.岩石 != null && state.岩石 !== 0) RemoveDestructable(state.岩石);
  const index = 岩石状态列表.indexOf(state);
  if (index >= 0) 岩石状态列表.splice(index, 1);
}

function 创建碎礁落地岩石(this: void, x: number, y: number): void {
  if (!(岩石物编ID > 0)) return;
  const rock = CreateDeadDestructable(岩石物编ID, x, y, GetRandomReal(0, 360), 1, 0);
  if (rock == null || rock === 0) return;
  const state: 碎礁岩石删除状态 = { 岩石: rock, 删除回调ID: 0 };
  state.删除回调ID = addDelayedCallback(碎礁投石手配置.岩石删除秒 * 1000, 删除碎礁岩石, state);
  岩石状态列表.push(state);
}

function 碎礁投掷到达目标点(this: void, barrageId: number, _reason: string): void {
  const state = 弹幕状态表[barrageId];
  if (state == null || state.已结算) return;
  state.已结算 = true;
  const source = state.来源;
  创建封印守卫战点特效({ 模型路径: 碎礁投石手配置.落地特效, X: state.目标X, Y: state.目标Y, Z: 0, 缩放: 0.85, 持续秒: 1.4 });
  创建碎礁落地岩石(state.目标X, state.目标Y);
  const heroes = 读取封印守卫战玩家英雄列表();
  const damage = 封印守卫战单位存活(source) ? 读取单位攻击力(source) * 碎礁投石手配置.伤害攻击力比例 : 0;
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!封印守卫战单位存活(target) || !是封印守卫战玩家英雄(target)) continue;
    const dx = 取单位X(target) - state.目标X;
    const dy = 取单位Y(target) - state.目标Y;
    if (dx * dx + dy * dy > 碎礁投石手配置.伤害半径 * 碎礁投石手配置.伤害半径) continue;
    开始硬直(target, 碎礁投石手配置.硬直秒);
    造成单体技能伤害({ 来源: source, 目标: target, 伤害: damage, 伤害类型: DAMAGE_TYPE_NORMAL, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: "单位技能", 标签: "第三章-碎礁投石手-碎礁投掷", 参与技能伤害加成: false });
  }
  清理碎礁弹幕状态(barrageId);
}

function 清理碎礁弹幕状态(this: void, barrageId: number): void {
  delete 弹幕状态表[barrageId];
  const index = 活动弹幕ID列表.indexOf(barrageId);
  if (index >= 0) 活动弹幕ID列表.splice(index, 1);
}

function 碎礁投掷结束(this: void, reason: string, barrageId: number): void {
  if (reason === "完成" || reason === "距离结束") return;
  清理碎礁弹幕状态(barrageId);
}

function 碎礁投掷充能周期(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "碎礁投石手" || record.充能ID !== chargeId) return;
  if (单位处于硬控制(unit) || 投石手被近身(record)) 停止单位充能(unit);
}

function 碎礁投掷充能完成(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "碎礁投石手" || record.充能ID !== chargeId) return;
  record.充能ID = 0;
  const target = record.当前目标;
  record.当前目标 = undefined;
  if (!封印守卫战单位存活(target) || 投石手被近身(record)) return;
  const startX = 取单位X(unit);
  const startY = 取单位Y(unit);
  const endX = 取单位X(target);
  const endY = 取单位Y(target);
  const controlX = (startX + endX) * 0.5;
  const controlY = (startY + endY) * 0.5;
  const barrage = 创建原生弹幕({
    所有者: unit,
    载体模式: "特效",
    X: startX,
    Y: startY,
    方向角: 0,
    速度: 0,
    生命周期: 4,
    轨迹采样器: 创建二阶贝塞尔加速度抛物线轨迹(startX, startY, 80, controlX, controlY, endX, endY, 0, 碎礁投石手配置.抛物线抬高, 碎礁投石手配置.抛物速度),
    附加特效1: { 模型: 碎礁投石手配置.投射物特效, 缩放: 1.1, 跟随轨迹俯仰: true },
    on到达目标点: 碎礁投掷到达目标点,
    on结束: 碎礁投掷结束,
  });
  if (barrage == null || !(barrage.弹幕ID > 0)) return;
  const barrageId = barrage.弹幕ID;
  弹幕状态表[barrageId] = { 来源: unit, 目标X: endX, 目标Y: endY, 已结算: false };
  活动弹幕ID列表.push(barrageId);
  record.下次技能毫秒 = getServerTime() + 碎礁投石手配置.技能冷却毫秒;
}

function 碎礁投掷充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "碎礁投石手") return;
  if (record.充能ID === chargeId) record.充能ID = 0;
  record.当前目标 = undefined;
  if (reason !== "完成") record.下次技能毫秒 = getServerTime() + 碎礁投石手配置.技能冷却毫秒;
}

export function 尝试释放碎礁投掷(this: void, record: 封印守卫战敌人记录): boolean {
  if (record.充能ID !== 0 || 单位处于硬控制(record.单位) || 投石手被近身(record)) return false;
  const target = 取最远玩家英雄(record);
  if (!封印守卫战单位存活(target)) return false;
  record.当前目标 = target;
  创建技能提示圈({ 类型: "圆形", X: 取单位X(target), Y: 取单位Y(target), 半径: 碎礁投石手配置.预警半径, 持续时间: 碎礁投石手配置.预警秒, 来源单位: record.单位 });
  const id = 开始充能(record.单位, { 持续时间: 碎礁投石手配置.预警秒, 强制硬直: true, 显示进度条特效: true, 周期回调间隔: 0.1, 周期回调: 碎礁投掷充能周期, 充能完成回调: 碎礁投掷充能完成, 结束回调: 碎礁投掷充能结束 });
  record.充能ID = id;
  return id > 0;
}

export function 刷新碎礁投石手AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (record.充能ID !== 0 || 当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 碎礁投石手配置.AI刷新毫秒;
  if (当前毫秒 >= record.下次技能毫秒 && 尝试释放碎礁投掷(record)) return;
  const target = 取最远玩家英雄(record);
  if (封印守卫战单位存活(target)) {
    record.当前目标 = target;
    命令攻击目标(record.单位, target);
  }
}

export function 清理碎礁投石手机制(this: void, record: 封印守卫战敌人记录): void {
  if (record.充能ID !== 0 && 封印守卫战单位存活(record.单位)) 停止单位充能(record.单位);
  record.充能ID = 0;
  record.当前目标 = undefined;
  const ids: number[] = [];
  for (let i = 0; i < 活动弹幕ID列表.length; i++) {
    const state = 弹幕状态表[活动弹幕ID列表[i]];
    if (state != null && state.来源 === record.单位) ids.push(活动弹幕ID列表[i]);
  }
  for (let i = 0; i < ids.length; i++) 销毁原生弹幕(ids[i], "手动销毁");
}
