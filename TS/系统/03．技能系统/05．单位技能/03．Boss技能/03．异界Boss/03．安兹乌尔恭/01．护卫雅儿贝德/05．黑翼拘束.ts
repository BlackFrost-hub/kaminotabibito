/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';
import { 创建可攻击机制单位 } from '../../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位';
import { 启动雅儿贝德至尊共护 } from './04．至尊共护';

const { 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { 取当前有效玩家人数 } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数') as {
  取当前有效玩家人数: (this: void) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require('lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统') as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, unit: any, point: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const 黑翼拘束暂停来源 = '雅儿贝德-黑翼拘束';

function 启动黑翼拘束核心(this: void, context: 安兹运行时上下文, target: any, remainingSeconds: number): void {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !单位有效(albedo) || !单位有效(target) || context.挑战已结束) return;
  const cfg = 安兹乌尔恭数值与表现配置;
  const maxByAlbedo = GetUnitState(albedo, UNIT_STATE_LIFE) * cfg.守护者模式.黑翼拘束生命比例;
  const maxByBoss = GetUnitState(context.安兹单位, UNIT_STATE_MAX_LIFE) * cfg.守护者模式.黑翼拘束安兹最大生命上限比例;
  const coreLife = maxByAlbedo < maxByBoss ? maxByAlbedo : maxByBoss;
  const wing = AddSpecialEffectTarget(cfg.表现资源.雅儿贝德黑翼拘束特效路径, target, 'origin');
  let paused = false;
  if (取当前有效玩家人数() > 1) paused = 添加单位暂停(target, 黑翼拘束暂停来源);
  let cleaned = false;
  function cleanup(this: void): void {
    if (cleaned) return;
    cleaned = true;
    if (paused) 移除单位暂停(target, 黑翼拘束暂停来源);
    if (wing != null && wing !== 0) DestroyEffect(wing);
  }
  const core = 创建可攻击机制单位({
    清理: context.清理,
    名称: '雅儿贝德-黑翼拘束核心',
    主人单位: albedo,
    所属玩家: GetOwningPlayer(albedo),
    单位类型: cfg.守护者模式.黑翼拘束核心单位ID,
    模型路径: cfg.表现资源.雅儿贝德黑翼拘束核心路径,
    X: GetUnitX(target),
    Y: GetUnitY(target),
    最大生命: coreLife,
    生命值受小怪倍率: false,
    缩放: cfg.守护者模式.黑翼拘束核心缩放,
    持续时间: remainingSeconds,
    on死亡: cleanup,
    on销毁: cleanup,
  });
  if (core == null) cleanup();
}

export function 启动雅儿贝德天空坠落联动(this: void, context: 安兹运行时上下文, castSeconds: number): void {
  const state = context.雅儿贝德;
  if (state == null || !单位有效(state.单位) || state.阶段状态 === '失衡') return;
  启动雅儿贝德至尊共护(context, castSeconds);
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const target = 获取Boss技能随机敌对英雄(context.安兹单位);
  if (!单位有效(target)) return;
  const remaining = castSeconds - cfg.黑翼拘束启动延迟秒;
  if (remaining <= 0.5) return;
  const delayedId = addDelayedCallback(cfg.黑翼拘束启动延迟秒 * 1000, function 黑翼拘束延迟启动(this: void): void {
    启动黑翼拘束核心(context, target, remaining);
  });
  context.清理.登记延迟回调('雅儿贝德-天空坠落黑翼拘束', delayedId);
}

export const 黑翼拘束技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: '单体',
  类型: '控制机制',
  语义: '天空坠落期间拘束一名玩家，但拘束核心必须可处理，且不得把玩家推出已确认安全区。',
} as const;
