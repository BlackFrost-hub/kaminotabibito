/** @noSelfInFile */

import { 教派剑士单位技能配置 } from './00．配置';
import { 获取全部教派剑士上下文, 获取或创建教派剑士上下文, 教派剑士单位存活, type 教派剑士运行时上下文 } from './01．运行时上下文';
import { 教派剑士技能配置, 教派剑士音效配置 } from './02．数值与表现配置';
import { 创建召唤物 } from '../../../../00．技能模板+函数/01．技能函数/11．召唤物/04．对外接口';
import { 创建召唤物组状态, type 召唤物组状态 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/03．召唤物组状态管理';
import { 极坐标X, 极坐标Y, 读取单位最大生命 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 执行战斗自身传送到坐标 } from '../../../../00．技能模板+函数/02．通用函数/20．位移技能限制';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 执行非伤害生命移除 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/09．非伤害生命移除';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';

const { registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback, getGameDifficulty } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  getGameDifficulty: (this: void) => number;
};
const { 取当前有效玩家人数 } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数') as {
  取当前有效玩家人数: (this: void) => number;
};
const { 开始硬直 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require('lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统') as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { getEnemyUnitsInRange } = require('lib.扩展函数.自定义扩展函数.01．选取中心范围') as {
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerController = jass.GetPlayerController as (player: any) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animation: string) => void;
const ShowUnit = jass.ShowUnit as (unit: any, show: boolean) => void;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const MAP_CONTROL_USER = jass.MAP_CONTROL_USER as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 分身暂停来源 = 'Boss:教派剑士:深渊分身';

interface 深渊分身状态 {
  已结束: boolean;
  上下文: 教派剑士运行时上下文;
  起点X: number;
  起点Y: number;
  召唤组: 召唤物组状态;
  总数量: number;
  玩家摧毁数量: number;
  Boss已隐藏: boolean;
}

interface 分身爆炸快照 {
  上下文: 教派剑士运行时上下文;
  X: number;
  Y: number;
  分身Hid: number;
}

const 教派剑士单位类型ID = stringToFourCCSafe(教派剑士单位技能配置.单位ID);
const 深渊分身技能ID = stringToFourCCSafe(教派剑士单位技能配置.技能ID.深渊分身);
let 深渊分身已注册 = false;

function 单位属于分身状态(this: void, unit: any, 状态: 深渊分身状态): boolean {
  if (unit == null || unit === 0) return false;
  const hid = GetHandleId(unit);
  const 列表 = 状态.召唤组.取单位列表();
  for (let i = 0; i < 列表.length; i++) {
    if (GetHandleId(列表[i]) === hid) return true;
  }
  return false;
}

function 是否由玩家摧毁(this: void, killer: any): boolean {
  return killer != null
    && killer !== 0
    && (IsUnitType(killer, UNIT_TYPE_HERO) || GetPlayerController(GetOwningPlayer(killer)) === MAP_CONTROL_USER);
}

function 查找分身状态(this: void, unit: any): 深渊分身状态 | undefined {
  const 上下文列表 = 获取全部教派剑士上下文();
  for (let i = 0; i < 上下文列表.length; i++) {
    const 状态 = 上下文列表[i].分身状态 as 深渊分身状态 | undefined;
    if (状态 != null && !状态.已结束 && 单位属于分身状态(unit, 状态)) return 状态;
  }
  return undefined;
}

function 深渊分身伤害修正(this: void, context: any): number {
  if (context == null) return 0;
  if (查找分身状态(context.attacker) != null) {
    if (context.currentDamage > 0) debugLogForce('教派剑士-深渊分身', '分身造成伤害归零', 'cloneHid=', GetHandleId(context.attacker), 'prevented=', context.currentDamage);
    return 0;
  }
  if (查找分身状态(context.target) != null) return context.currentDamage * 教派剑士技能配置.深渊分身.分身承伤倍率;
  return context.currentDamage;
}

function 结束深渊分身(this: void, 状态: 深渊分身状态, 全由玩家摧毁: boolean, 原因: string): void {
  if (状态.已结束) return;
  状态.已结束 = true;
  const boss = 状态.上下文.Boss单位;
  if (boss != null && boss !== 0) {
    执行战斗自身传送到坐标(boss, 状态.起点X, 状态.起点Y);
    ShowUnit(boss, true);
    移除单位暂停(boss, 分身暂停来源);
    状态.Boss已隐藏 = false;
    if (全由玩家摧毁 && 教派剑士单位存活(boss)) 开始硬直(boss, 教派剑士技能配置.深渊分身.全部摧毁硬直秒);
  }
  关闭吟唱条(教派剑士技能配置.深渊分身.读条通道);
  if (状态.上下文.分身状态 === 状态) 状态.上下文.分身状态 = undefined;
  debugLogForce('教派剑士-深渊分身', '分身阶段结束并恢复Boss', 'bossHid=', boss != null && boss !== 0 ? GetHandleId(boss) : 0, 'reason=', 原因, 'allPlayerDestroyed=', 全由玩家摧毁, 'playerKills=', 状态.玩家摧毁数量, 'total=', 状态.总数量);
}

function on深渊分身清理(this: void, variable?: any): void {
  const 状态 = variable as 深渊分身状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  状态.召唤组.清空(true);
  结束深渊分身(状态, false, '上下文清理');
}

function on分身死亡爆炸(this: void, variable?: any): void {
  const 快照 = variable as 分身爆炸快照 | undefined;
  if (快照 == null || !教派剑士单位存活(快照.上下文.Boss单位)) return;
  const boss = 快照.上下文.Boss单位;
  const 配置 = 教派剑士技能配置.深渊分身;
  EC_CreateEffect(配置.爆炸特效路径, 快照.X, 快照.Y, 0, 0, 配置.爆炸特效缩放, 1, 配置.爆炸特效持续秒);
  播放Boss坐标音效(教派剑士音效配置.深渊分身.分身死亡爆炸, 快照.X, 快照.Y, 教派剑士音效配置.音效裁断距离);
  const 目标列表 = getEnemyUnitsInRange(boss, 快照.X, 快照.Y, 配置.分身死亡爆炸半径);
  let 命中数 = 0;
  for (let i = 0; i < 目标列表.length; i++) {
    const 结果 = 执行BossAOE技能伤害({
      来源: boss,
      目标: 目标列表[i],
      技能ID: 深渊分身技能ID,
      伤害公式: { 来源攻击力比例: 配置.分身死亡伤害Boss攻击力比例 },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: 配置.伤害标签,
    });
    if (结果.是否造成伤害) 命中数++;
  }
  debugLogForce('教派剑士-深渊分身', '分身死亡延迟爆炸结算', 'cloneHid=', 快照.分身Hid, 'x=', 快照.X, 'y=', 快照.Y, 'hitCount=', 命中数);
}

function on分身单位死亡(this: void, unit: any, killer: any, _group: 召唤物组状态, variable?: any): void {
  const 状态 = variable as 深渊分身状态 | undefined;
  if (状态 == null) return;
  if (是否由玩家摧毁(killer)) 状态.玩家摧毁数量++;
  const 快照: 分身爆炸快照 = { 上下文: 状态.上下文, X: GetUnitX(unit), Y: GetUnitY(unit), 分身Hid: GetHandleId(unit) };
  const 爆炸ID = addDelayedCallback(教派剑士技能配置.深渊分身.分身死亡爆炸延迟秒 * 1000, on分身死亡爆炸, 快照);
  状态.上下文.清理.登记延迟回调('教派剑士-分身死亡爆炸', 爆炸ID);
  debugLogForce('教派剑士-深渊分身', '分身死亡', 'cloneHid=', 快照.分身Hid, 'killerHid=', killer != null && killer !== 0 ? GetHandleId(killer) : 0, 'playerDestroyedCount=', 状态.玩家摧毁数量);
}

function on全部分身死亡(this: void, _group: 召唤物组状态, variable?: any): void {
  const 状态 = variable as 深渊分身状态 | undefined;
  if (状态 == null) return;
  结束深渊分身(状态, 状态.总数量 > 0 && 状态.玩家摧毁数量 >= 状态.总数量, '全部分身消失');
}

function on深渊分身兜底结束(this: void, variable?: any): void {
  const 状态 = variable as 深渊分身状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  状态.召唤组.清空(true);
  结束深渊分身(状态, false, '持续时间兜底结束');
}

function on创建深渊分身(this: void, variable?: any): void {
  const 状态 = variable as 深渊分身状态 | undefined;
  if (状态 == null || 状态.已结束 || !教派剑士单位存活(状态.上下文.Boss单位)) return;
  const boss = 状态.上下文.Boss单位;
  const 配置 = 教派剑士技能配置.深渊分身;
  关闭吟唱条(配置.读条通道);
  执行非伤害生命移除({
    目标: boss,
    数值: 读取单位最大生命(boss) * 配置.自损最大生命比例,
    不致死: false,
    显示文字: false,
    显示特效: false,
  });
  if (!教派剑士单位存活(boss)) {
    结束深渊分身(状态, false, '自损后死亡');
    return;
  }
  播放Boss坐标音效(配置.分身音效路径, GetUnitX(boss), GetUnitY(boss), 配置.分身音效裁断距离);
  状态.召唤组.开始批次(状态.总数量);
  let 实际数量 = 0;
  for (let i = 0; i < 状态.总数量; i++) {
    const 角度 = GetRandomReal(0, 360);
    const clone = 创建召唤物({
      主人单位: boss,
      所属玩家: GetOwningPlayer(boss),
      单位类型: 教派剑士单位技能配置.单位ID,
      单位名称: '深渊分身',
      X: 极坐标X(状态.起点X, 角度, 配置.分身散开距离),
      Y: 极坐标Y(状态.起点Y, 角度, 配置.分身散开距离),
      朝向: 角度,
      持续时间: 配置.分身持续秒,
      缩放: 配置.分身缩放,
    });
    if (clone != null && clone !== 0) {
      状态.召唤组.登记(clone);
      实际数量++;
      debugLogForce('教派剑士-深渊分身', '分身创建并登记', 'cloneHid=', GetHandleId(clone), 'index=', i + 1);
    }
  }
  状态.召唤组.结束批次();
  状态.总数量 = 实际数量;
  if (实际数量 <= 0) {
    结束深渊分身(状态, false, '分身创建失败');
    return;
  }
  添加单位暂停(boss, 分身暂停来源);
  ShowUnit(boss, false);
  状态.Boss已隐藏 = true;
  const 兜底ID = addDelayedCallback((配置.分身持续秒 + 0.2) * 1000, on深渊分身兜底结束, 状态);
  状态.上下文.清理.登记延迟回调('教派剑士-深渊分身兜底', 兜底ID);
  debugLogForce('教派剑士-深渊分身', '召唤批次结束并隐藏Boss', 'bossHid=', GetHandleId(boss), 'count=', 实际数量, 'duration=', 配置.分身持续秒);
}

export function 释放教派剑士深渊分身(this: void, 上下文: 教派剑士运行时上下文): boolean {
  const boss = 上下文?.Boss单位;
  if (!教派剑士单位存活(boss) || 上下文.分身状态 != null) return false;
  const 配置 = 教派剑士技能配置.深渊分身;
  const playerCount = 取当前有效玩家人数();
  const difficulty = getGameDifficulty() > 0 ? getGameDifficulty() : 1;
  const count = playerCount >= 配置.高人数阈值 || difficulty >= 配置.高难度阈值 ? 配置.强化分身数量 : 配置.默认分身数量;
  const 状态: 深渊分身状态 = { 已结束: false, 上下文, 起点X: GetUnitX(boss), 起点Y: GetUnitY(boss), 召唤组: undefined as any, 总数量: count, 玩家摧毁数量: 0, Boss已隐藏: false };
  状态.召唤组 = 创建召唤物组状态({
    清理: 上下文.清理,
    名称: '教派剑士-深渊分身组',
    全灭延迟秒: 0,
    变量: 状态,
    on单位死亡: on分身单位死亡,
    on全部死亡: on全部分身死亡,
  });
  上下文.分身状态 = 状态;
  上下文.清理.登记清理('教派剑士-深渊分身清理', on深渊分身清理, 状态);
  开始硬直(boss, 配置.施法硬直秒);
  SetUnitAnimation(boss, 配置.动作名);
  EC_CreateEffect(配置.起始特效路径, 状态.起点X, 状态.起点Y, 0, 270, 配置.起始特效缩放, 1, 配置.起始特效持续秒);
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 配置.施法硬直秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  const 创建ID = addDelayedCallback(配置.施法硬直秒 * 1000, on创建深渊分身, 状态);
  上下文.清理.登记延迟回调('教派剑士-创建深渊分身', 创建ID);
  debugLogForce('教派剑士-深渊分身', '施法前摇开始', 'bossHid=', GetHandleId(boss), 'playerCount=', playerCount, 'difficulty=', difficulty, 'count=', count);
  return true;
}

function on教派剑士深渊分身生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 深渊分身技能ID || GetUnitTypeId(castingUnit) !== 教派剑士单位类型ID) return;
  const 上下文 = 获取或创建教派剑士上下文(castingUnit);
  const 已开始 = 上下文 != null && 释放教派剑士深渊分身(上下文);
  debugLogForce('教派剑士-深渊分身', '正式SPELL_EFFECT入口', 'bossHid=', GetHandleId(castingUnit), 'started=', 已开始);
}

export function 注册教派剑士深渊分身(this: void): void {
  if (深渊分身已注册) return;
  深渊分身已注册 = true;
  registerSpellEffectListener(on教派剑士深渊分身生效);
  registerDamageModifier(深渊分身伤害修正, 教派剑士技能配置.深渊分身.分身伤害修正优先级);
}
