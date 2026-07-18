/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';
import { 创建反击窗口模板, type 反击窗口模板实例 } from '../../../../../00．技能模板+函数/00．技能模板/09．复杂战斗模板/01．反击窗口模板';
import { 开始冲锋 } from '../../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统';
import { 播放限时单位动画 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 播放Boss坐标音效 } from '../../../00．公共/00．Boss音效播放';

const { 造成单体技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成单体技能伤害: (this: void, 参数: any) => boolean;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;

function 结算护卫反击(this: void, context: 安兹运行时上下文, attacker: any, token: number): void {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !单位有效(albedo) || !单位有效(attacker) || context.挑战已结束) {
    state?.独占状态?.结束(token, '取消', '反击目标失效');
    return;
  }
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const dx = GetUnitX(attacker) - GetUnitX(albedo);
  const dy = GetUnitY(attacker) - GetUnitY(albedo);
  if (dx * dx + dy * dy <= cfg.护卫反击攻击距离 * cfg.护卫反击攻击距离) {
    const damage = 计算组合技能伤害(albedo, attacker, {
      来源攻击力比例: cfg.护卫反击伤害攻击力比例,
      目标最大生命比例: cfg.护卫反击伤害目标最大生命比例,
    });
    造成单体技能伤害({
      来源: albedo,
      目标: attacker,
      伤害: damage,
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
      来源类型: 'Boss技能',
      标签: '雅儿贝德·护卫反击',
    });
  }
  state.独占状态?.结束(token, '完成');
}

function 启动护卫反击动作(this: void, context: 安兹运行时上下文, attacker: any, token: number): void {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !单位有效(albedo) || !单位有效(attacker) || context.挑战已结束) {
    state?.独占状态?.结束(token, '取消', '反击目标失效');
    return;
  }
  const guardState = state;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const dx = GetUnitX(attacker) - GetUnitX(albedo);
  const dy = GetUnitY(attacker) - GetUnitY(albedo);
  const distance = SquareRoot(dx * dx + dy * dy);
  const angle = Atan2(dy, dx);
  SetUnitFacing(albedo, angle * RAD_TO_DEG);
  const needMove = distance > cfg.护卫反击攻击距离;
  const moveDistance = needMove
    ? (distance - cfg.护卫反击攻击距离 < cfg.护卫反击最大冲锋距离
      ? distance - cfg.护卫反击攻击距离
      : cfg.护卫反击最大冲锋距离)
    : 0;

function 播放反击砸击并结算(this: void): void {
  播放Boss坐标音效(安兹乌尔恭数值与表现配置.音效.雅儿贝德护卫拦截, GetUnitX(albedo), GetUnitY(albedo), 安兹乌尔恭数值与表现配置.音效默认裁断距离);
    if (!单位有效(albedo) || !单位有效(attacker) || context.挑战已结束) {
      guardState.独占状态?.结束(token, '取消', '反击目标失效');
      return;
    }
    SetUnitFacing(albedo, Atan2(GetUnitY(attacker) - GetUnitY(albedo), GetUnitX(attacker) - GetUnitX(albedo)) * RAD_TO_DEG);
    播放限时单位动画({
      单位: albedo,
      动画编号: cfg.护卫反击攻击动画编号,
      持续秒: cfg.护卫反击结算延迟秒 + 0.35,
      恢复动画编号: 1,
    });
    const damageId = addDelayedCallback(cfg.护卫反击结算延迟秒 * 1000, function 护卫反击延迟结算(this: void): void {
      结算护卫反击(context, attacker, token);
    });
    context.清理.登记延迟回调('雅儿贝德-护卫反击结算', damageId);
  }

  if (moveDistance <= 1) {
    播放反击砸击并结算();
    return;
  }
  const endX = GetUnitX(albedo) + Cos(angle) * moveDistance;
  const endY = GetUnitY(albedo) + Sin(angle) * moveDistance;
  const chargeId = 开始冲锋(albedo, {
    目标X: endX,
    目标Y: endY,
    距离: moveDistance,
    持续时间: cfg.护卫反击冲锋秒,
    检查地形: true,
    暂停单位: true,
    禁用碰撞: true,
    结束回调: function 护卫反击冲锋结束(this: void): void {
      播放反击砸击并结算();
    },
  });
  if (chargeId === 0) 播放反击砸击并结算();
}

export function 释放雅儿贝德护卫反击(this: void, context: 安兹运行时上下文): boolean {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !单位有效(albedo) || context.挑战已结束 || context.当前大型技能 != null) return false;
  if (state.阶段状态 === '失衡' || state.阶段状态 === '已离场') return false;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const now = getServerTime();
  if (now < state.上次护卫反击Ms + cfg.护卫反击冷却秒 * 1000) return false;
  let window: 反击窗口模板实例 | undefined;
  let counterTriggered = false;
  const exclusive = state.独占状态;
  const token = exclusive?.开始({
    key: '雅儿贝德-护卫反击',
    优先级: 20,
    持续毫秒: (cfg.护卫反击窗口秒 + cfg.护卫反击冲锋秒 + cfg.护卫反击结算延迟秒 + 1) * 1000,
    可被抢占: true,
    on结束: function 护卫反击独占结束(this: void): void {
      window?.取消('手动取消');
    },
  }) ?? 0;
  if (token === 0) return false;
  state.守护连接生效 = false;
  state.上次护卫反击Ms = now;
  播放限时单位动画({
    单位: albedo,
    动画编号: cfg.护卫反击守势动画编号,
    持续秒: cfg.护卫反击窗口秒,
    恢复动画编号: 1,
  });
  window = 创建反击窗口模板({
    清理: context.清理,
    名称: '雅儿贝德-护卫反击窗口',
    单位: albedo,
    持续秒: cfg.护卫反击窗口秒,
    正面减伤角度: cfg.护卫反击正面角度,
    正面伤害倍率: cfg.护卫反击承伤倍率,
    修正优先级: 45,
    触发条件: function 护卫反击爆发过滤(this: void, damage: any): boolean {
      if (!单位有效(damage.attacker) || !IsUnitEnemy(damage.attacker, GetOwningPlayer(albedo))) return false;
      if (damage.isNormalAttack !== true && damage.isSkillDamage !== true && damage.isSkillAttack !== true) return false;
      return damage.currentDamage >= GetUnitState(albedo, UNIT_STATE_MAX_LIFE) * cfg.护卫反击触发伤害最大生命比例;
    },
    on反击: function 护卫反击触发(this: void, damage: any): void {
      if (counterTriggered) return;
      counterTriggered = true;
      const attacker = damage.attacker;
      const triggerId = addDelayedCallback(0, function 护卫反击脱离伤害栈(this: void): void {
        window?.取消('手动取消');
        启动护卫反击动作(context, attacker, token);
      });
      context.清理.登记延迟回调('雅儿贝德-护卫反击启动', triggerId);
    },
    on结束: function 护卫反击窗口结束(this: void): void {
      if (!counterTriggered) exclusive?.结束(token, '完成');
    },
  });
  return true;
}

export const 护卫反击技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: '单体',
  包含战斗自身位移: true,
  语义: '短暂守势只格挡一次来自正面的高额直接伤害，并向原攻击者发动短距离反击。',
} as const;
