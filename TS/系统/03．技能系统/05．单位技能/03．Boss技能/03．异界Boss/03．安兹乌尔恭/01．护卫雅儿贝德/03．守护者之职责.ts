/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';
import { 创建友军范围承伤转移 } from '../../../../../00．技能模板+函数/04．机制组件/09．装备通用机制/20．友军范围承伤转移';
import type { 友军范围承伤转移控制器 } from '../../../../../00．技能模板+函数/04．机制组件/09．装备通用机制/20．友军范围承伤转移';
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const EXSetEffectXY = japi.EXSetEffectXY as (effect: any, x: number, y: number) => void;
const EXSetEffectZ = japi.EXSetEffectZ as (effect: any, z: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as (effect: any, degrees: number) => void;
const RAD_TO_DEG = 57.29577951308232;

interface 守护职责表现状态 {
  context: 安兹运行时上下文;
  token: number;
  特效: any;
  刷新ID: number;
  承伤转移: 友军范围承伤转移控制器;
  已结束: boolean;
}

function 是否直接伤害(this: void, damage: any): boolean {
  if (!单位有效(damage.attacker) || damage.attacker === damage.target) return false;
  if (damage.isNormalAttack !== true && damage.isSkillAttack !== true && damage.isSkillDamage !== true) return false;
  const tag = damage.skillDamageTag;
  if (typeof tag === 'string' && (tag.indexOf('DOT') >= 0 || tag.indexOf('反伤') >= 0 || tag.indexOf('环境') >= 0)) return false;
  return true;
}

function 创建守护职责承伤转移(
  this: void,
  context: 安兹运行时上下文,
  boss: any,
  albedo: any,
): 友军范围承伤转移控制器 {
  const state = context.雅儿贝德!;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  return 创建友军范围承伤转移({
    名称: '安兹-守护者之职责',
    清理: context.清理,
    转移半径: cfg.守护者之职责断裂距离,
    优先级: 45,
    初始启用: false,
    获取转移比例: function 读取守护职责共享比例(this: void): number {
      return cfg.守护者之职责共享比例;
    },
    获取候选单位列表: function 获取守护职责承受者(this: void, event): any[] {
      if (event.受击者 === boss) return [albedo];
      if (event.受击者 === albedo) return [boss];
      return [];
    },
    可承受者: function 守护职责承受者有效(this: void, event): boolean {
      return 单位有效(event.候选单位);
    },
    过滤伤害: function 过滤守护职责伤害(this: void, event): boolean {
      return !context.挑战已结束 && state.守护连接生效 && 是否直接伤害(event.上下文);
    },
    获取最低生命: function 读取守护职责最低生命(this: void, event): number {
      if (event.承受者 !== albedo) return 1;
      return GetUnitStateJapi(albedo, UNIT_STATE_MAX_LIFE) * cfg.雅儿贝德锁血比例;
    },
    显示文字: true,
    显示特效: false,
  });
}

function 刷新守护职责连接表现(this: void, visual: 守护职责表现状态): void {
  if (visual.已结束) return;
  const boss = visual.context.安兹单位;
  const albedo = visual.context.雅儿贝德?.单位;
  if (!单位有效(boss) || !单位有效(albedo)) return;
  const ax = GetUnitX(boss);
  const ay = GetUnitY(boss);
  const bx = GetUnitX(albedo);
  const by = GetUnitY(albedo);
  const dx = bx - ax;
  const dy = by - ay;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  if (visual.特效 == null || visual.特效 === 0) return;
  EXSetEffectXY(visual.特效, (ax + bx) * 0.5, (ay + by) * 0.5);
  EXSetEffectZ(visual.特效, cfg.守护者之职责连接高度);
  EXEffectMatRotateZ(visual.特效, Atan2(dy, dx) * RAD_TO_DEG);
  EXSetEffectSize(visual.特效, SquareRoot(dx * dx + dy * dy)
    / cfg.守护者之职责连接基础长度
    * cfg.守护者之职责连接缩放倍率);
}

function 清理守护职责表现(this: void, visual: 守护职责表现状态): void {
  if (visual.已结束) return;
  visual.已结束 = true;
  visual.context.雅儿贝德!.守护连接生效 = false;
  visual.承伤转移.停止();
  if (visual.刷新ID !== 0) removePeriodicCallback(visual.刷新ID);
  if (visual.特效 != null && visual.特效 !== 0) DestroyEffect(visual.特效);
}

export function 释放雅儿贝德守护者之职责(this: void, context: 安兹运行时上下文): boolean {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  const boss = context.安兹单位;
  if (state == null || !单位有效(albedo) || !单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null) return false;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  if (state.阶段状态 === '失衡' || state.阶段状态 === '已离场'
    || state.当前生命比例 < cfg.守护者之职责最低生命比例) return false;
  const now = getServerTime();
  if (now < state.上次守护职责Ms + cfg.守护者之职责冷却秒 * 1000) return false;
  const dx = GetUnitX(albedo) - GetUnitX(boss);
  const dy = GetUnitY(albedo) - GetUnitY(boss);
  if (dx * dx + dy * dy > cfg.守护者之职责断裂距离 * cfg.守护者之职责断裂距离) return false;
  let visual: 守护职责表现状态;
  const token = state.独占状态?.开始({
    key: '雅儿贝德-守护者之职责',
    优先级: 10,
    持续毫秒: (cfg.守护者之职责预连接秒 + cfg.守护者之职责持续秒) * 1000,
    可被抢占: true,
    on结束: function 守护职责结束(this: void): void {
      if (visual != null) 清理守护职责表现(visual);
    },
  }) ?? 0;
  if (token === 0) return false;
  state.上次守护职责Ms = now;
  const effect = AddSpecialEffect(安兹乌尔恭数值与表现配置.表现资源.雅儿贝德守护连接特效路径,
    (GetUnitX(boss) + GetUnitX(albedo)) * 0.5,
    (GetUnitY(boss) + GetUnitY(albedo)) * 0.5);
  const transfer = 创建守护职责承伤转移(context, boss, albedo);
  visual = { context, token, 特效: effect, 刷新ID: 0, 承伤转移: transfer, 已结束: false };
  刷新守护职责连接表现(visual);
  visual.刷新ID = addPeriodicCallback(cfg.守护者之职责连接刷新间隔毫秒, function 守护职责连接刷新(this: void): void {
    if (context.挑战已结束 || !单位有效(boss) || !单位有效(albedo)) {
      state.独占状态?.结束(token, '取消', '守护连接单位失效');
      return;
    }
    if (context.当前大型技能 != null || state.阶段状态 === '失衡') {
      state.独占状态?.结束(token, '抢占', context.当前大型技能 ?? '雅儿贝德失衡');
      return;
    }
    const distanceX = GetUnitX(albedo) - GetUnitX(boss);
    const distanceY = GetUnitY(albedo) - GetUnitY(boss);
    if (distanceX * distanceX + distanceY * distanceY > cfg.守护者之职责断裂距离 * cfg.守护者之职责断裂距离) {
      state.独占状态?.结束(token, '取消', '双方距离过远');
      return;
    }
    刷新守护职责连接表现(visual);
  });
  const activeId = addDelayedCallback(cfg.守护者之职责预连接秒 * 1000, function 守护职责正式连接(this: void): void {
    if (state.独占状态?.取当前()?.token === token) {
      state.守护连接生效 = true;
      visual.承伤转移.设置启用(true);
    }
  });
  context.清理.登记延迟回调('雅儿贝德-守护职责预连接', activeId);
  context.清理.登记清理('雅儿贝德-守护职责表现', function 守护职责挑战清理(this: void): void {
    清理守护职责表现(visual);
  });
  return true;
}

export function 注册雅儿贝德守护者之职责(this: void): void {
  // 承伤转移控制器随每次职责连接创建，并由对应安兹上下文独立清理。
}

export const 守护者之职责技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: '独占伤害共享状态',
  语义: '一秒预连接后，安兹与雅儿贝德短时按比例共享直接伤害。',
  实现要求: '转移伤害不得再次触发吸血、反伤、受击效果或二次转移；与其他主动技能互斥。',
} as const;
