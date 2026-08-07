/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../../../01．杂鱼技能/03．第三章/00．封印守卫战公共/00．类型";
import { 深渊鳞将配置 } from "./00．配置";
import {
  单位处于硬控制,
  命令攻击目标,
  取两点方向角,
  取单位X,
  取单位Y,
  读取单位攻击力,
  取单位距离平方,
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
const { 开始牵引, 停止牵引 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.01．牵引系统.03．对外接口") as {
  开始牵引: (this: void, unit: any, params: any) => number;
  停止牵引: (this: void, id: number) => boolean;
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
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 深渊回潮状态 {
  朝向: number;
}

interface 潮汐牵引状态 {
  牵引ID列表: number[];
  清理中: boolean;
}

const 牵引来源表: Record<number, 封印守卫战敌人记录 | undefined> = {};

function 角度差(this: void, first: number, second: number): number {
  let value = first - second;
  while (value < -180) value += 360;
  while (value > 180) value -= 360;
  return value < 0 ? -value : value;
}

function 深渊回潮充能周期(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "深渊鳞将" || record.充能ID !== chargeId) return;
  if (单位处于硬控制(unit)) 停止单位充能(unit);
}

function 深渊回潮充能完成(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "深渊鳞将" || record.充能ID !== chargeId) return;
  record.充能ID = 0;
  const state = record.附加状态?.深渊回潮 as 深渊回潮状态 | undefined;
  if (state == null) return;
  const heroes = 读取封印守卫战玩家英雄列表();
  const damage = 读取单位攻击力(unit) * 深渊鳞将配置.回潮伤害攻击力比例;
  const x = 取单位X(unit);
  const y = 取单位Y(unit);
  for (let i = 0; i < 3; i++) {
    const lineAngle = state.朝向 + (i - 1) * 35;
    创建封印守卫战点特效({ 模型路径: 深渊鳞将配置.回潮特效, X: x, Y: y, Z: 0, Z轴角度: lineAngle, 缩放: 1, 持续秒: 1.4 });
  }
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!封印守卫战单位存活(target) || !是封印守卫战玩家英雄(target)) continue;
    const distance = 取单位距离平方(unit, target);
    if (distance > 深渊鳞将配置.回潮半径 * 深渊鳞将配置.回潮半径) continue;
    const targetAngle = 取两点方向角(x, y, 取单位X(target), 取单位Y(target));
    if (角度差(targetAngle, state.朝向) > 深渊鳞将配置.回潮扇形角度 * 0.5) continue;
    造成单体技能伤害({ 来源: unit, 目标: target, 伤害: damage, 伤害类型: DAMAGE_TYPE_NORMAL, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: "单位技能", 标签: "第三章-深渊鳞将-深渊回潮", 参与技能伤害加成: false });
    施加快速减速Buff(unit, target, 深渊鳞将配置.回潮减速比例, 深渊鳞将配置.回潮减速比例, 深渊鳞将配置.回潮减速秒, "深渊鳞将-深渊回潮", "技能");
  }
  if (record.附加状态 != null) delete record.附加状态.深渊回潮;
  if (record.附加状态 != null) record.附加状态.深渊回潮冷却毫秒 = getServerTime() + 深渊鳞将配置.回潮冷却毫秒;
}

function 深渊回潮充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "深渊鳞将") return;
  if (record.充能ID === chargeId) record.充能ID = 0;
  if (record.附加状态 != null) delete record.附加状态.深渊回潮;
  if (reason !== "完成" && record.附加状态 != null) record.附加状态.深渊回潮冷却毫秒 = getServerTime() + 深渊鳞将配置.回潮冷却毫秒;
}

export function 尝试释放深渊回潮(this: void, record: 封印守卫战敌人记录): boolean {
  if (record.充能ID !== 0 || 单位处于硬控制(record.单位)) return false;
  const heroes = 读取封印守卫战玩家英雄列表();
  if (heroes.length === 0) return false;
  const now = getServerTime();
  if ((record.附加状态?.深渊回潮冷却毫秒 ?? 0) > now || (record.附加状态?.回潮封锁毫秒 ?? 0) > now) return false;
  const target = heroes[0];
  const state: 深渊回潮状态 = { 朝向: 取两点方向角(取单位X(record.单位), 取单位Y(record.单位), 取单位X(target), 取单位Y(target)) };
  if (record.附加状态 == null) record.附加状态 = {};
  record.附加状态.深渊回潮 = state;
  创建技能提示圈({ 类型: "扇形", X: 取单位X(record.单位), Y: 取单位Y(record.单位), 半径: 深渊鳞将配置.回潮半径, 扇形角度: 深渊鳞将配置.回潮扇形角度, 朝向: state.朝向, 持续时间: 深渊鳞将配置.回潮预警秒, 来源单位: record.单位 });
  const id = 开始充能(record.单位, { 持续时间: 深渊鳞将配置.回潮预警秒, 强制硬直: true, 显示进度条特效: true, 周期回调间隔: 0.1, 周期回调: 深渊回潮充能周期, 充能完成回调: 深渊回潮充能完成, 结束回调: 深渊回潮充能结束 });
  record.充能ID = id;
  return id > 0;
}

function 潮汐牵引结束(this: void, unit: any, _reason: string, pullId: number): void {
  const record = 牵引来源表[pullId];
  if (record == null) return;
  delete 牵引来源表[pullId];
  const state = record.附加状态?.潮汐牵引 as 潮汐牵引状态 | undefined;
  if (state == null) return;
  const index = state.牵引ID列表.indexOf(pullId);
  if (index >= 0) state.牵引ID列表.splice(index, 1);
  if (state.清理中 || state.牵引ID列表.length > 0) return;
  if (封印守卫战单位存活(record.单位)) 创建封印守卫战点特效({ 模型路径: 深渊鳞将配置.牵引结束特效, X: 取单位X(record.单位), Y: 取单位Y(record.单位), Z: 0, 缩放: 1, 持续秒: 1.2 });
  if (record.附加状态 != null) {
    record.附加状态.回潮封锁毫秒 = getServerTime() + 深渊鳞将配置.回潮封锁秒 * 1000;
    delete record.附加状态.潮汐牵引;
  }
}

function 潮汐牵引充能周期(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "深渊鳞将" || record.充能ID !== chargeId) return;
  if (单位处于硬控制(unit)) 停止单位充能(unit);
}

function 潮汐牵引充能完成(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "深渊鳞将" || record.充能ID !== chargeId) return;
  record.充能ID = 0;
  if (record.附加状态 != null) delete record.附加状态.潮汐牵引准备;
  结算潮汐牵引(record);
}

function 潮汐牵引充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "深渊鳞将") return;
  if (record.充能ID === chargeId) record.充能ID = 0;
  if (reason !== "完成" && record.附加状态 != null) {
    delete record.附加状态.潮汐牵引准备;
    record.附加状态.潮汐牵引冷却毫秒 = getServerTime() + 深渊鳞将配置.牵引冷却毫秒;
  }
}

function 结算潮汐牵引(this: void, record: 封印守卫战敌人记录): void {
  if (!封印守卫战单位存活(record.单位) || record.附加状态?.潮汐牵引 != null) return;
  const now = getServerTime();
  if ((record.附加状态?.潮汐牵引冷却毫秒 ?? 0) > now) return;
  const heroes = 读取封印守卫战玩家英雄列表();
  const state: 潮汐牵引状态 = { 牵引ID列表: [], 清理中: false };
  if (record.附加状态 == null) record.附加状态 = {};
  record.附加状态.潮汐牵引 = state;
  创建封印守卫战点特效({ 模型路径: 深渊鳞将配置.牵引中心特效, X: 取单位X(record.单位), Y: 取单位Y(record.单位), Z: 0, 缩放: 1, 持续秒: 深渊鳞将配置.牵引持续秒 + 0.4 });
  const damage = 读取单位攻击力(record.单位) * 深渊鳞将配置.牵引伤害攻击力比例;
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!封印守卫战单位存活(target) || !是封印守卫战玩家英雄(target)) continue;
    if (取单位距离平方(record.单位, target) > 深渊鳞将配置.牵引范围 * 深渊鳞将配置.牵引范围) continue;
    造成单体技能伤害({ 来源: record.单位, 目标: target, 伤害: damage, 伤害类型: DAMAGE_TYPE_NORMAL, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: "单位技能", 标签: "第三章-深渊鳞将-潮汐牵引", 参与技能伤害加成: false });
    const pullId = 开始牵引(target, { 中心单位: record.单位, 主单位: record.单位, 持续时间: 深渊鳞将配置.牵引持续秒, 每秒速度: 深渊鳞将配置.牵引拉近距离 / 深渊鳞将配置.牵引持续秒, 最小距离: 96, 最大牵引距离: 深渊鳞将配置.牵引拉近距离, 到达后结束: true, 检查地形: true, 禁用碰撞: true, 暂停单位: false, 朝向跟随牵引: false, 启用闪电效果: false, 结束回调: 潮汐牵引结束 });
    if (pullId > 0) {
      state.牵引ID列表.push(pullId);
      牵引来源表[pullId] = record;
    }
  }
  record.附加状态.潮汐牵引冷却毫秒 = now + 深渊鳞将配置.牵引冷却毫秒;
  if (state.牵引ID列表.length === 0) {
    record.附加状态.回潮封锁毫秒 = now + 深渊鳞将配置.回潮封锁秒 * 1000;
    delete record.附加状态.潮汐牵引;
  }
}

function 释放潮汐牵引(this: void, record: 封印守卫战敌人记录): boolean {
  if (record.充能ID !== 0 || 单位处于硬控制(record.单位) || record.附加状态?.潮汐牵引 != null || record.附加状态?.潮汐牵引准备 === true) return false;
  const now = getServerTime();
  if ((record.附加状态?.潮汐牵引冷却毫秒 ?? 0) > now) return false;
  if (record.附加状态 == null) record.附加状态 = {};
  record.附加状态.潮汐牵引准备 = true;
  创建技能提示圈({ 类型: "圆形", X: 取单位X(record.单位), Y: 取单位Y(record.单位), 半径: 深渊鳞将配置.牵引范围, 持续时间: 深渊鳞将配置.牵引预警秒, 来源单位: record.单位 });
  const id = 开始充能(record.单位, { 持续时间: 深渊鳞将配置.牵引预警秒, 强制硬直: true, 显示进度条特效: true, 周期回调间隔: 0.1, 周期回调: 潮汐牵引充能周期, 充能完成回调: 潮汐牵引充能完成, 结束回调: 潮汐牵引充能结束 });
  record.充能ID = id;
  if (!(id > 0)) delete record.附加状态.潮汐牵引准备;
  return id > 0;
}

export function 刷新深渊鳞将AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (record.充能ID !== 0 || 当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 深渊鳞将配置.AI刷新毫秒;
  const pullState = record.附加状态?.潮汐牵引 as 潮汐牵引状态 | undefined;
  if (pullState != null && pullState.牵引ID列表.length === 0 && record.附加状态 != null) delete record.附加状态.潮汐牵引;
  if (当前毫秒 >= (record.附加状态?.深渊回潮冷却毫秒 ?? 0) && 当前毫秒 >= (record.附加状态?.回潮封锁毫秒 ?? 0) && 尝试释放深渊回潮(record)) return;
  if (当前毫秒 >= (record.附加状态?.潮汐牵引冷却毫秒 ?? 0) && 释放潮汐牵引(record)) return;
  const target = 读取封印守卫战玩家英雄列表()[0];
  if (封印守卫战单位存活(target)) {
    record.当前目标 = target;
    命令攻击目标(record.单位, target);
  }
}

export function 清理深渊鳞将机制(this: void, record: 封印守卫战敌人记录): void {
  if (record.充能ID !== 0 && 封印守卫战单位存活(record.单位)) 停止单位充能(record.单位);
  const state = record.附加状态?.潮汐牵引 as 潮汐牵引状态 | undefined;
  if (state != null) {
    state.清理中 = true;
    const ids = state.牵引ID列表.slice();
    for (let i = 0; i < ids.length; i++) {
      delete 牵引来源表[ids[i]];
      停止牵引(ids[i]);
    }
  }
  record.充能ID = 0;
  record.当前目标 = undefined;
  if (record.附加状态 != null) {
    delete record.附加状态.深渊回潮;
    delete record.附加状态.潮汐牵引;
  }
}
