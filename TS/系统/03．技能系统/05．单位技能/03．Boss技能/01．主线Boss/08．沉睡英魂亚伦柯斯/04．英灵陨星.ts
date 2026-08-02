/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 亚伦柯斯运行时上下文 } from './01．运行时上下文';
import { 亚伦柯斯正式设计配置 } from './02．数值与表现配置';
import { 播放亚伦柯斯台词 } from './11．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};

const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { getServerTime, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 创建点特效 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 读取Boss战运行上下文 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文') as {
  读取Boss战运行上下文: (this: void, boss: any) => any;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRectCenterX = jass.GetRectCenterX as (rect: any) => number;
const GetRectCenterY = jass.GetRectCenterY as (rect: any) => number;
const GetRectMinX = jass.GetRectMinX as (rect: any) => number;
const GetRectMaxX = jass.GetRectMaxX as (rect: any) => number;
const GetRectMinY = jass.GetRectMinY as (rect: any) => number;
const GetRectMaxY = jass.GetRectMaxY as (rect: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const 英灵陨星技能Key = '英灵陨星';
const 角度转弧度 = 0.017453292519943295;

interface 英灵陨星场地 {
  中心X: number;
  中心Y: number;
  左边界?: number;
  右边界?: number;
  下边界?: number;
  上边界?: number;
}

interface 英灵陨星落点 {
  X: number;
  Y: number;
}

function 取批次数量(this: void, context: 亚伦柯斯运行时上下文): number {
  const cfg = 亚伦柯斯正式设计配置.英灵陨星;
  if (context.阶段 === 'P3最后的誓约') return cfg.P3批次数量;
  if (context.阶段 === 'P2旧誓回响') return cfg.P2批次数量;
  return cfg.P1批次数量;
}

function 取每批落点数量(this: void, context: 亚伦柯斯运行时上下文): number {
  const cfg = 亚伦柯斯正式设计配置.英灵陨星;
  if (context.阶段 === 'P3最后的誓约') return cfg.P3落点数量;
  if (context.阶段 === 'P2旧誓回响') return cfg.P2落点数量;
  return cfg.P1落点数量;
}

function 结束英灵陨星(this: void, context: 亚伦柯斯运行时上下文): void {
  if (context.当前大型技能 === 英灵陨星技能Key) context.当前大型技能 = undefined;
}

function 取英灵陨星场地(this: void, boss: any): 英灵陨星场地 {
  const battle = 读取Boss战运行上下文(boss);
  const rect = battle?.地点矩形;
  if (rect == null || rect === 0) return { 中心X: GetUnitX(boss), 中心Y: GetUnitY(boss) };
  return {
    中心X: GetRectCenterX(rect),
    中心Y: GetRectCenterY(rect),
    左边界: GetRectMinX(rect),
    右边界: GetRectMaxX(rect),
    下边界: GetRectMinY(rect),
    上边界: GetRectMaxY(rect),
  };
}

function 限制到场地内(this: void, point: 英灵陨星落点, field: 英灵陨星场地, padding: number): 英灵陨星落点 {
  let x = point.X;
  let y = point.Y;
  if (field.左边界 != null && field.右边界 != null && field.左边界 + padding < field.右边界 - padding) {
    if (x < field.左边界 + padding) x = field.左边界 + padding;
    else if (x > field.右边界 - padding) x = field.右边界 - padding;
  }
  if (field.下边界 != null && field.上边界 != null && field.下边界 + padding < field.上边界 - padding) {
    if (y < field.下边界 + padding) y = field.下边界 + padding;
    else if (y > field.上边界 - padding) y = field.上边界 - padding;
  }
  return { X: x, Y: y };
}

function 取未安魂墓碑列表(this: void, context: 亚伦柯斯运行时上下文): any[] {
  const result: any[] = [];
  for (let i = 0; i < context.墓碑状态列表.length; i++) {
    const state = context.墓碑状态列表[i];
    if (state != null && state.已安魂 !== true) result.push(state);
  }
  return result;
}

function 落点避开安魂区域(this: void, point: 英灵陨星落点, tombstones: any[], radius: number): boolean {
  const cfg = 亚伦柯斯正式设计配置;
  const safeDistance = cfg.旧誓墓碑.安魂范围 + radius + cfg.英灵陨星.P2墓碑安全间隔;
  const safeDistanceSquared = safeDistance * safeDistance;
  for (let i = 0; i < tombstones.length; i++) {
    const dx = point.X - tombstones[i].X;
    const dy = point.Y - tombstones[i].Y;
    if (dx * dx + dy * dy < safeDistanceSquared) return false;
  }
  return true;
}

function 取普通随机落点(this: void, field: 英灵陨星场地, tombstones: any[], radius: number): 英灵陨星落点 {
  const cfg = 亚伦柯斯正式设计配置.英灵陨星;
  const fallback = 限制到场地内({ X: field.中心X, Y: field.中心Y }, field, radius + 32);
  for (let attempt = 0; attempt < 10; attempt++) {
    const angle = GetRandomReal(0, 360);
    const distance = SquareRoot(GetRandomReal(0, 1)) * cfg.生成半径;
    const radians = angle * 角度转弧度;
    const point = 限制到场地内({ X: field.中心X + Cos(radians) * distance, Y: field.中心Y + Sin(radians) * distance }, field, radius + 32);
    if (落点避开安魂区域(point, tombstones, radius)) return point;
  }
  return fallback;
}

function 取墓碑外围加权落点(this: void, field: 英灵陨星场地, tombstones: any[], radius: number): 英灵陨星落点 {
  if (tombstones.length <= 0) return 取普通随机落点(field, tombstones, radius);
  const cfg = 亚伦柯斯正式设计配置;
  const tombstone = tombstones[GetRandomInt(0, tombstones.length - 1)];
  const toCenterFacing = jass.Atan2(field.中心Y - tombstone.Y, field.中心X - tombstone.X) * 57.29577951308232;
  const minDistance = cfg.旧誓墓碑.安魂范围 + radius + cfg.英灵陨星.P2墓碑安全间隔;
  for (let attempt = 0; attempt < 10; attempt++) {
    const angle = toCenterFacing + GetRandomReal(-70, 70);
    const distance = GetRandomReal(minDistance, minDistance + cfg.英灵陨星.P2墓碑加权外环宽度);
    const radians = angle * 角度转弧度;
    const point = 限制到场地内({ X: tombstone.X + Cos(radians) * distance, Y: tombstone.Y + Sin(radians) * distance }, field, radius + 32);
    if (落点避开安魂区域(point, tombstones, radius)) return point;
  }
  return 取普通随机落点(field, tombstones, radius);
}

function 结算英灵陨星(this: void, context: 亚伦柯斯运行时上下文, x: number, y: number, radius: number, isP3: boolean): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束) return;
  const cfg = 亚伦柯斯正式设计配置;
  const meteor = AddSpecialEffect(cfg.表现资源.英灵陨星正式特效路径, x, y);
  创建点特效({ 模型路径: cfg.表现资源.英灵陨星落地特效路径, X: x, Y: y, 缩放: cfg.表现资源.英灵陨星落地特效缩放, 持续秒: 0.8 });
  播放Boss坐标音效(cfg.音效.英灵陨星命中, x, y, cfg.音效默认裁断距离);
  if (meteor != null && meteor !== 0) YDWETimerDestroyEffectSafe(0.8, meteor);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    const dx = GetUnitX(target) - x;
    const dy = GetUnitY(target) - y;
    if (dx * dx + dy * dy > radius * radius) continue;
    执行BossAOE技能伤害({
      来源: boss,
      目标: target,
      伤害公式: {
        来源攻击力比例: isP3 ? cfg.英灵陨星.P3伤害攻击力比例 : cfg.英灵陨星.伤害攻击力比例,
        目标最大生命比例: isP3 ? cfg.英灵陨星.P3伤害目标最大生命比例 : cfg.英灵陨星.伤害目标最大生命比例,
      },
      attack: false,
      ranged: true,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_MAGIC,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: isP3 ? '亚伦柯斯·英灵陨星-送葬' : '亚伦柯斯·英灵陨星',
    });
  }
  const aftershock = AddSpecialEffect(cfg.表现资源.英灵陨星余波特效路径, x, y);
  if (aftershock != null && aftershock !== 0) YDWETimerDestroyEffectSafe(0.7, aftershock);
}

function 安排英灵陨星落点(this: void, context: 亚伦柯斯运行时上下文, point: 英灵陨星落点, radius: number, isP3: boolean): void {
  const boss = context.Boss单位;
  const cfg = 亚伦柯斯正式设计配置;
  创建技能提示圈({ 类型: '敌方圆形', X: point.X, Y: point.Y, 半径: radius, 持续时间: cfg.英灵陨星.预警秒, 来源单位: boss });
  const warning = AddSpecialEffect(cfg.表现资源.英灵陨星预警特效路径, point.X, point.Y);
  if (warning != null && warning !== 0) YDWETimerDestroyEffectSafe(cfg.英灵陨星.预警秒, warning);
  const impactId = addDelayedCallback(cfg.英灵陨星.预警秒 * 1000, function 亚伦柯斯英灵陨星单点结算(this: void): void {
    结算英灵陨星(context, point.X, point.Y, radius, isP3);
  });
  context.清理.登记延迟回调('亚伦柯斯-英灵陨星单点结算', impactId);
}

function 创建英灵陨星批次(this: void, context: 亚伦柯斯运行时上下文, count: number, radius: number, isP2: boolean, isP3: boolean): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束 || context.当前大型技能 !== 英灵陨星技能Key) return;
  const field = 取英灵陨星场地(boss);
  const tombstones = isP2 ? 取未安魂墓碑列表(context) : [];
  const weightedCount = count * 亚伦柯斯正式设计配置.英灵陨星.P2墓碑加权比例;
  for (let i = 0; i < count; i++) {
    const point = isP2 && i < weightedCount && tombstones.length > 0
      ? 取墓碑外围加权落点(field, tombstones, radius)
      : 取普通随机落点(field, tombstones, radius);
    安排英灵陨星落点(context, point, radius, isP3);
  }
}

export function 释放亚伦柯斯英灵陨星(this: void, context: 亚伦柯斯运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束 || context.当前大型技能 != null) return false;
  const cfg = 亚伦柯斯正式设计配置.英灵陨星;
  const batchCount = 取批次数量(context);
  const countPerBatch = 取每批落点数量(context);
  const isP2 = context.阶段 === 'P2旧誓回响';
  const isP3 = context.阶段 === 'P3最后的誓约';
  const radius = isP3 ? cfg.P3伤害半径 : cfg.常规伤害半径;
  const totalDuration = (batchCount - 1) * cfg.批次间隔秒 + cfg.预警秒;
  context.当前大型技能 = 英灵陨星技能Key;
  context.普通机制忙碌到Ms = getServerTime() + (totalDuration + 0.4) * 1000;
  开始硬直(boss, cfg.施法硬直秒);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: 1, 恢复动画编号: 1 });
  播放亚伦柯斯台词(boss, isP3 ? '英灵陨星送葬' : '英灵陨星');
  播放Boss坐标音效(亚伦柯斯正式设计配置.音效.英灵陨星坠落, GetUnitX(boss), GetUnitY(boss), 亚伦柯斯正式设计配置.音效默认裁断距离);

  创建英灵陨星批次(context, countPerBatch, radius, isP2, isP3);
  for (let batch = 1; batch < batchCount; batch++) {
    const batchId = addDelayedCallback(batch * cfg.批次间隔秒 * 1000, function 亚伦柯斯英灵陨星后续批次(this: void): void {
      创建英灵陨星批次(context, countPerBatch, radius, isP2, isP3);
    });
    context.清理.登记延迟回调('亚伦柯斯-英灵陨星后续批次', batchId);
  }
  const finishId = addDelayedCallback((totalDuration + 0.1) * 1000, function 亚伦柯斯英灵陨星全部结束(this: void): void {
    结束英灵陨星(context);
  });
  context.清理.登记延迟回调('亚伦柯斯-英灵陨星结束', finishId);
  return true;
}

export const 英灵陨星迁移状态 = {
  旧技能ID: 'A0F5',
  通用技能壳ID: 'AN00',
  已保留旧原型语义: true,
  已完成TS实现: true,
  已注册: true,
  伤害形态: 'AOE',
  语义: '以Boss或正式场地中心生成2-3轮重型落点；P2提高未安魂墓碑外围权重但避开安魂范围，P3减少落点并扩大范围与冲击。',
} as const;
