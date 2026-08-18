/** @noSelfInFile */

import { 八云紫单位技能配置 } from "../00．配置";
import { 八云紫诊断日志, 八云紫诊断句柄 } from "../00B．诊断";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addDelayedCallback, getGameTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  getGameTime: (this: void) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 是否精英单位 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.06．精英单位判断") as {
  是否精英单位: (this: void, unit: any) => boolean;
};
const { 读取单位攻击力 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 造成单体技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};

const 配置 = 八云紫单位技能配置;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as any;

export interface 八云紫裂隙记录 {
  单位: any;
  主人: any;
  长期: boolean;
  到期时间: number;
  扩散冷却到: number;
  已结束: boolean;
}

export interface 八云紫D裂隙放置结果 {
  可创建: boolean;
  持续秒: number;
  长期: boolean;
  失败原因?: string;
}

export interface 八云紫裂隙指定寿命 {
  持续秒: number;
  长期: boolean;
}

export type 裂隙扩散发射器 = (this: void, hero: any, gap: 八云紫裂隙记录) => void;
export type 裂隙创建监听器 = (this: void, hero: any, gap: 八云紫裂隙记录, skillId: number, skillInstanceId?: number) => void;

const 裂隙记录表: Record<number, 八云紫裂隙记录 | undefined> = {};
const 英雄长期裂隙数: Record<number, number | undefined> = {};
const 间隙命中次数: Record<number, number | undefined> = {};
let 已注册裂隙扩散发射器: 裂隙扩散发射器 | undefined;
const 裂隙创建监听器列表: 裂隙创建监听器[] = [];

function 句柄ID(this: void, handle: any): number {
  return handle == null || handle === 0 ? 0 : jass.GetHandleId(handle);
}

// 裂隙物编属于 Ancient，不能经过公共战斗单位筛选器。
function 获取范围内原生单位(this: void, x: number, y: number, radius: number): any[] {
  const group = jass.CreateGroup();
  const result: any[] = [];
  jass.GroupEnumUnitsInRange(group, x, y, radius, null);
  let unit = jass.FirstOfGroup(group);
  while (unit != null && unit !== 0) {
    result.push(unit);
    jass.GroupRemoveUnit(group, unit);
    unit = jass.FirstOfGroup(group);
  }
  jass.DestroyGroup(group);
  return result;
}

export function 八云紫单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0
    && jass.GetUnitTypeId(unit) !== 0
    && jass.GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

export function 是八云紫(this: void, unit: any): boolean {
  return 八云紫单位存活(unit) && jass.GetUnitTypeId(unit) === 配置.单位.英雄类型ID;
}

export function 是八云紫合法敌人(this: void, hero: any, target: any): boolean {
  return 八云紫单位存活(target)
    && jass.IsUnitEnemy(target, jass.GetOwningPlayer(hero)) === true
    && jass.IsUnitType(target, UNIT_TYPE_STRUCTURE) !== true
    && jass.IsUnitType(target, UNIT_TYPE_MECHANICAL) !== true
    && jass.IsUnitType(target, UNIT_TYPE_ANCIENT) !== true;
}

function 销毁点特效(this: void, variable?: any): void {
  const effect = variable as any;
  if (effect != null && effect !== 0) jass.DestroyEffect(effect);
}

export function 创建八云紫点特效(
  this: void,
  model: string,
  x: number,
  y: number,
  durationSec: number,
  scale: number = 1,
  height: number = 0,
): any {
  const effect = jass.AddSpecialEffect(model, x, y);
  if (effect == null || effect === 0) return effect;
  if (scale !== 1 && japi.EXSetEffectSize != null) japi.EXSetEffectSize(effect, scale);
  if (height !== 0 && japi.EXSetEffectZ != null) japi.EXSetEffectZ(effect, height);
  addDelayedCallback(durationSec * 1000, 销毁点特效, effect);
  return effect;
}

function 清理间隙命中层(this: void, variable?: any): void {
  const targetId = variable as number;
  const count = 间隙命中次数[targetId] ?? 0;
  if (count <= 1) delete 间隙命中次数[targetId];
  else 间隙命中次数[targetId] = count - 1;
}

function 结算裂隙命中(this: void, hero: any, target: any, skillId: number, skillInstanceId?: number): void {
  const baseDamage = 读取单位攻击力(hero) * 配置.裂隙.展开伤害攻击力比例;
  造成单体技能伤害({
    来源: hero,
    目标: target,
    伤害: baseDamage,
    伤害类型: DAMAGE_TYPE_MIND,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: skillId,
    技能实例ID: skillInstanceId,
    标签: "八云紫-裂隙展开",
    参与技能伤害加成: true,
  });

  const targetId = 句柄ID(target);
  const next = (间隙命中次数[targetId] ?? 0) + 1;
  间隙命中次数[targetId] = next;
  if (next >= 2) {
    delete 间隙命中次数[targetId];
    造成单体技能伤害({
      来源: hero,
      目标: target,
      伤害: baseDamage * 配置.裂隙.二次命中额外倍率,
      伤害类型: DAMAGE_TYPE_MIND,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: skillId,
      技能实例ID: skillInstanceId,
      标签: "八云紫-裂隙二次展开",
      参与技能伤害加成: true,
    });
    施加眩晕(hero, target, 配置.裂隙.二次命中眩晕秒, "八云紫-裂隙二次展开", "技能");
    for (let i = 0; i < 配置.裂隙.二次特效.length; i++) {
      创建八云紫点特效(配置.裂隙.二次特效[i], jass.GetUnitX(target), jass.GetUnitY(target), 1.25);
    }
  } else {
    addDelayedCallback(配置.裂隙.二次命中窗口秒 * 1000, 清理间隙命中层, targetId);
  }
}

export function 结算八云紫裂隙展开(
  this: void,
  hero: any,
  x: number,
  y: number,
  skillId: number = 配置.技能.D.类型ID,
  skillInstanceId?: number,
): void {
  创建八云紫点特效(配置.裂隙.冲击特效, x, y, 配置.裂隙.冲击特效持续秒);
  创建八云紫点特效(
    配置.裂隙.出现特效,
    x,
    y,
    配置.裂隙.出现特效持续秒,
    配置.裂隙.出现特效缩放,
    配置.裂隙.出现特效高度,
  );
  const targets = getEnemyUnitsInRange(hero, x, y, 配置.裂隙.展开范围);
  for (let i = 0; i < targets.length; i++) {
    if (是八云紫合法敌人(hero, targets[i])) 结算裂隙命中(hero, targets[i], skillId, skillInstanceId);
  }
}

function 清理裂隙记录(this: void, record: 八云紫裂隙记录): void {
  if (record.已结束) return;
  record.已结束 = true;
  const unitId = 句柄ID(record.单位);
  if (裂隙记录表[unitId] === record) delete 裂隙记录表[unitId];
  if (record.长期) {
    const heroId = 句柄ID(record.主人);
    const next = (英雄长期裂隙数[heroId] ?? 1) - 1;
    if (next > 0) 英雄长期裂隙数[heroId] = next;
    else delete 英雄长期裂隙数[heroId];
  }
  if (record.单位 != null && record.单位 !== 0 && jass.GetUnitTypeId(record.单位) !== 0) jass.RemoveUnit(record.单位);
}

function 裂隙到期(this: void, variable?: any): void {
  const record = variable as 八云紫裂隙记录 | undefined;
  if (record != null) 清理裂隙记录(record);
}

function 附近存在长期裂隙(this: void, x: number, y: number): boolean {
  const units = 获取范围内原生单位(x, y, 配置.裂隙.附近检测范围);
  for (let i = 0; i < units.length; i++) {
    const record = 裂隙记录表[句柄ID(units[i])];
    if (record != null && !record.已结束 && record.长期) return true;
  }
  return false;
}

function 附近存在精英敌人(this: void, hero: any, x: number, y: number): boolean {
  const units = getEnemyUnitsInRange(hero, x, y, 配置.裂隙.附近检测范围);
  for (let i = 0; i < units.length; i++) {
    if (八云紫单位存活(units[i]) && 是否精英单位(units[i]) === true) return true;
  }
  return false;
}

function 选择裂隙持续时间(this: void, hero: any, x: number, y: number): { duration: number; long: boolean } {
  const heroId = 句柄ID(hero);
  if (附近存在精英敌人(hero, x, y)) return { duration: 配置.裂隙.短期持续秒, long: false };
  if (附近存在长期裂隙(x, y)) return { duration: 配置.裂隙.短期持续秒, long: false };
  if ((英雄长期裂隙数[heroId] ?? 0) >= 配置.裂隙.最多长期裂隙) return { duration: 配置.裂隙.短期持续秒, long: false };
  return { duration: 配置.裂隙.长期持续秒, long: true };
}

export function 检查八云紫D裂隙放置(this: void, hero: any, x: number, y: number): 八云紫D裂隙放置结果 {
  if (!是八云紫(hero)) return { 可创建: false, 持续秒: 0, 长期: false, 失败原因: "施法者无效。" };
  if (附近存在精英敌人(hero, x, y)) {
    八云紫诊断日志("裂隙", "D放置判定为短期间隙", "英雄", 八云紫诊断句柄(hero), "X", x, "Y", y, "原因", "附近存在精英敌人");
    return { 可创建: true, 持续秒: 配置.裂隙.短期持续秒, 长期: false };
  }
  if (附近存在长期裂隙(x, y)) {
    八云紫诊断日志("裂隙", "D放置被拒绝", "英雄", 八云紫诊断句柄(hero), "X", x, "Y", y, "原因", "附近已有长期裂隙");
    return { 可创建: false, 持续秒: 0, 长期: false, 失败原因: "附近已有长期『间隙』，无法再次放置。" };
  }
  const heroId = 句柄ID(hero);
  if ((英雄长期裂隙数[heroId] ?? 0) >= 配置.裂隙.最多长期裂隙) {
    八云紫诊断日志("裂隙", "D放置被拒绝", "英雄", heroId, "X", x, "Y", y, "原因", "长期裂隙达到上限", "当前数量", 英雄长期裂隙数[heroId] ?? 0);
    return { 可创建: false, 持续秒: 0, 长期: false, 失败原因: "长期『间隙』数量已达到上限。" };
  }
  return { 可创建: true, 持续秒: 配置.裂隙.长期持续秒, 长期: true };
}

export function 计算裂隙可达终点(this: void, startX: number, startY: number, targetX: number, targetY: number): { x: number; y: number } {
  const dx = targetX - startX;
  const dy = targetY - startY;
  const distance = Math.sqrt(dx * dx + dy * dy);
  if (distance <= 0.01) return { x: startX, y: startY };
  const maxDistance = Math.min(distance, 配置.裂隙.放置距离);
  const ux = dx / distance;
  const uy = dy / distance;
  let x = startX;
  let y = startY;
  let travelled = 0;
  while (travelled < maxDistance) {
    const step = Math.min(配置.裂隙.移动步长, maxDistance - travelled);
    const nextX = x + ux * step;
    const nextY = y + uy * step;
    if (jass.IsTerrainPathable(nextX, nextY, PATHING_TYPE_WALKABILITY) === true) break;
    x = nextX;
    y = nextY;
    travelled += step;
  }
  return { x, y };
}

export function 创建八云紫裂隙(
  this: void,
  hero: any,
  x: number,
  y: number,
  skillId: number = 配置.技能.D.类型ID,
  skillInstanceId?: number,
  指定寿命?: 八云紫裂隙指定寿命,
): 八云紫裂隙记录 | undefined {
  if (!是八云紫(hero)) return undefined;
  let lifetime = 指定寿命 != null
    ? { duration: 指定寿命.持续秒, long: 指定寿命.长期 }
    : 选择裂隙持续时间(hero, x, y);
  八云紫诊断日志("裂隙", "请求创建间隙", "英雄", 八云紫诊断句柄(hero), "技能ID", skillId, "请求X", x, "请求Y", y, "初选长期", lifetime.long, "初选持续秒", lifetime.duration, "指定寿命", 指定寿命 != null, "技能实例ID", skillInstanceId ?? 0);
  if (skillId === 配置.技能.D.类型ID) {
    const placement = 检查八云紫D裂隙放置(hero, x, y);
    if (!placement.可创建) {
      八云紫诊断日志("裂隙", "创建间隙终止", "技能ID", skillId, "原因", placement.失败原因 ?? "D放置判定失败");
      return undefined;
    }
    lifetime = { duration: placement.持续秒, long: placement.长期 };
  }
  const gap = 创建单位并登记排泄安全(jass.GetOwningPlayer(hero), 配置.单位.裂隙类型ID, x, y, 0);
  if (gap == null || gap === 0) {
    八云紫诊断日志("裂隙", "CreateUnit失败", "单位类型ID", 配置.单位.裂隙类型ID, "X", x, "Y", y);
    return undefined;
  }
  const record: 八云紫裂隙记录 = {
    单位: gap,
    主人: hero,
    长期: lifetime.long,
    到期时间: getGameTime() + lifetime.duration * 1000,
    扩散冷却到: 0,
    已结束: false,
  };
  裂隙记录表[句柄ID(gap)] = record;
  if (lifetime.long) {
    const heroId = 句柄ID(hero);
    英雄长期裂隙数[heroId] = (英雄长期裂隙数[heroId] ?? 0) + 1;
  }
  jass.SetUnitState(gap, UNIT_STATE_MAX_LIFE, lifetime.duration);
  jass.SetUnitState(gap, UNIT_STATE_LIFE, lifetime.duration);
  八云紫诊断日志("裂隙", "间隙创建成功", "间隙", 八云紫诊断句柄(gap), "单位类型ID", jass.GetUnitTypeId(gap), "实际X", jass.GetUnitX(gap), "实际Y", jass.GetUnitY(gap), "长期", lifetime.long, "持续秒", lifetime.duration, "英雄长期数量", 英雄长期裂隙数[句柄ID(hero)] ?? 0, "监听器数", 裂隙创建监听器列表.length);
  addDelayedCallback(lifetime.duration * 1000, 裂隙到期, record);
  结算八云紫裂隙展开(hero, x, y, skillId, skillInstanceId);
  for (let i = 0; i < 裂隙创建监听器列表.length; i++) {
    裂隙创建监听器列表[i](hero, record, skillId, skillInstanceId);
  }
  return record;
}

export function 创建八云紫临时裂隙(this: void, hero: any, x: number, y: number, durationSec: number): any {
  const unit = 创建单位并登记排泄安全(jass.GetOwningPlayer(hero), 配置.单位.临时裂隙类型ID, x, y, 0);
  if (unit == null || unit === 0) return unit;
  结算八云紫裂隙展开(hero, x, y, 配置.技能.W.类型ID);
  addDelayedCallback(durationSec * 1000, 移除临时裂隙, unit);
  return unit;
}

function 移除临时裂隙(this: void, variable?: any): void {
  const unit = variable as any;
  if (unit != null && unit !== 0 && jass.GetUnitTypeId(unit) !== 0) jass.RemoveUnit(unit);
}

export function 获取八云紫裂隙记录(this: void, unit: any): 八云紫裂隙记录 | undefined {
  const record = 裂隙记录表[句柄ID(unit)];
  return record != null && !record.已结束 && 八云紫单位存活(record.单位) ? record : undefined;
}

export function 查找八云紫裂隙(this: void, x: number, y: number, radius: number, owner?: any): 八云紫裂隙记录 | undefined {
  const units = 获取范围内原生单位(x, y, radius);
  for (let i = 0; i < units.length; i++) {
    const record = 获取八云紫裂隙记录(units[i]);
    if (record == null) continue;
    if (owner == null || owner === 0 || jass.GetOwningPlayer(record.主人) === jass.GetOwningPlayer(owner)) return record;
  }
  return undefined;
}

export function 获取范围内八云紫裂隙(this: void, x: number, y: number, radius: number, owner?: any): 八云紫裂隙记录[] {
  const result: 八云紫裂隙记录[] = [];
  const units = 获取范围内原生单位(x, y, radius);
  for (let i = 0; i < units.length; i++) {
    const record = 获取八云紫裂隙记录(units[i]);
    if (record == null) continue;
    if (owner != null && owner !== 0 && jass.GetOwningPlayer(record.主人) !== jass.GetOwningPlayer(owner)) continue;
    result.push(record);
  }
  return result;
}

export function 注册八云紫裂隙扩散发射器(this: void, handler: 裂隙扩散发射器): void {
  已注册裂隙扩散发射器 = handler;
}

export function 注册八云紫裂隙创建监听器(this: void, handler: 裂隙创建监听器): void {
  if (handler == null) return;
  for (let i = 0; i < 裂隙创建监听器列表.length; i++) {
    if (裂隙创建监听器列表[i] === handler) return;
  }
  裂隙创建监听器列表.push(handler);
}

export function 触发八云紫裂隙扩散(this: void, hero: any, centerGap: 八云紫裂隙记录): number {
  if (已注册裂隙扩散发射器 == null || centerGap.已结束) return 0;
  const gaps = 获取范围内八云紫裂隙(
    jass.GetUnitX(centerGap.单位),
    jass.GetUnitY(centerGap.单位),
    配置.裂隙.附近检测范围,
    hero,
  );
  const now = getGameTime();
  let count = 0;
  for (let i = 0; i < gaps.length; i++) {
    const gap = gaps[i];
    if (gap.扩散冷却到 > now) continue;
    const life = jass.GetUnitState(gap.单位, UNIT_STATE_LIFE);
    const maxLife = jass.GetUnitState(gap.单位, UNIT_STATE_MAX_LIFE);
    const cost = maxLife * 配置.裂隙.扩散生命消耗比例;
    if (life <= cost + 0.405) {
      清理裂隙记录(gap);
      continue;
    }
    jass.SetUnitState(gap.单位, UNIT_STATE_LIFE, life - cost);
    gap.扩散冷却到 = now + 配置.裂隙.扩散冷却秒 * 1000;
    已注册裂隙扩散发射器(hero, gap);
    count += 1;
  }
  return count;
}

export {};
