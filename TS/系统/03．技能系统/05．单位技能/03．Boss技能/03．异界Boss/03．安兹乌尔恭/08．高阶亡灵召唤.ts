/** @noSelfInFile */

import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 安兹模型动画配置, 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 创建召唤物 } from '../../../../00．技能模板+函数/01．技能函数/11．召唤物/04．对外接口';

const { 读取单位攻击力 } = require('系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具') as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { registerDeathListener } = require('系统.00．核心系统.01．事件中心.07．单位死亡事件中心') as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { 广播单位提示 } = require('系统.09．表现系统.06．广播提示消息.index') as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs: number) => void;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const DEG_TO_RAD = 0.017453292519943295;
const 高阶亡灵召唤大型技能Key = '高阶亡灵召唤';

interface 高阶亡灵召唤实例 {
  context: 安兹运行时上下文;
  unit: any;
  handleId: number;
  已移除: boolean;
}

const 高阶亡灵实例表: Record<number, 高阶亡灵召唤实例 | undefined> = {};
let 高阶亡灵死亡监听已注册 = false;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 清理高阶亡灵实例(this: void, instance: 高阶亡灵召唤实例): void {
  if (instance.已移除) return;
  instance.已移除 = true;
  delete 高阶亡灵实例表[instance.handleId];
  if (instance.context.高阶亡灵召唤物 === instance.unit) instance.context.高阶亡灵召唤物 = undefined;
  if (instance.unit != null && instance.unit !== 0) RemoveUnit(instance.unit);
  instance.unit = 0;
}

function on高阶亡灵死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (dyingUnit == null || dyingUnit === 0) return;
  const instance = 高阶亡灵实例表[GetHandleId(dyingUnit)];
  if (instance == null || instance.已移除) return;
  delete 高阶亡灵实例表[instance.handleId];
  const context = instance.context;
  if (context.高阶亡灵召唤物 === dyingUnit) context.高阶亡灵召唤物 = undefined;
  if (!context.挑战已结束 && !context.清理.已清理()) {
    context.亡灵箭削弱到Ms = getServerTime() + 安兹乌尔恭数值与表现配置.阶段技能.高阶亡灵击败削弱秒 * 1000;
    广播单位提示(
      context.安兹单位,
      '|cff80d8ff[机制]|r 高阶亡灵已消灭：亡灵箭伤害降低25%，持续12秒。',
      3500,
    );
  }
  const removeId = addDelayedCallback(3000, function 高阶亡灵尸体移除(this: void): void {
    清理高阶亡灵实例(instance);
  });
  context.清理.登记延迟回调('安兹-高阶亡灵尸体移除', removeId);
}

function 确保高阶亡灵死亡监听(this: void): void {
  if (高阶亡灵死亡监听已注册) return;
  高阶亡灵死亡监听已注册 = true;
  registerDeathListener(on高阶亡灵死亡);
}

function 播放召唤特效(this: void, model: string, x: number, y: number, scale: number): void {
  const effect = AddSpecialEffect(model, x, y);
  if (effect == null || effect === 0) return;
  if (typeof EXSetEffectSize === 'function') EXSetEffectSize(effect, scale);
  YDWETimerDestroyEffectSafe(安兹乌尔恭数值与表现配置.阶段技能.高阶亡灵召唤表现持续秒, effect);
}

function 创建高阶亡灵(this: void, context: 安兹运行时上下文, x: number, y: number, target: any): void {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束) return;
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  const summon = 创建召唤物({
    主人单位: boss,
    单位类型: cfg.高阶亡灵召唤单位ID,
    单位名称: cfg.高阶亡灵召唤单位名称,
    X: x,
    Y: y,
    朝向: GetUnitFacing(boss),
    生命值: GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg.高阶亡灵召唤生命Boss最大生命比例,
    生命值受小怪倍率: false,
    攻击力: 读取单位攻击力(boss) * cfg.高阶亡灵召唤攻击Boss攻击力比例,
    攻击间隔: cfg.高阶亡灵召唤攻击间隔,
    攻击范围: cfg.高阶亡灵召唤攻击范围,
    索敌范围: cfg.高阶亡灵召唤索敌范围,
    护甲: cfg.高阶亡灵召唤护甲,
    缩放: cfg.高阶亡灵召唤缩放,
    透明度: cfg.高阶亡灵召唤透明度,
    红: 150,
    绿: 205,
    蓝: 255,
  });
  if (!单位有效(summon)) return;
  const instance: 高阶亡灵召唤实例 = {
    context,
    unit: summon,
    handleId: GetHandleId(summon),
    已移除: false,
  };
  context.高阶亡灵召唤物 = summon;
  高阶亡灵实例表[instance.handleId] = instance;
  context.清理.登记清理('安兹-高阶亡灵召唤物', function 高阶亡灵挑战清理(this: void): void {
    清理高阶亡灵实例(instance);
  });
  if (单位有效(target)) IssueTargetOrder(summon, 'attack', target);
  广播单位提示(
    boss,
    '|cffff6060[机制]|r 死亡骑士存活期间，安兹的亡灵箭伤害提高35%。',
    3500,
  );
}

export function 取安兹亡灵箭伤害倍率(this: void, context: 安兹运行时上下文): number {
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  if (单位有效(context.高阶亡灵召唤物)) return cfg.高阶亡灵召唤亡灵箭强化倍率;
  if (getServerTime() < context.亡灵箭削弱到Ms) return cfg.高阶亡灵击败后亡灵箭倍率;
  return 1;
}

export function 释放安兹高阶亡灵召唤(this: void, context: 安兹运行时上下文): boolean {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null) return false;
  if (单位有效(context.高阶亡灵召唤物)) return false;
  context.高阶亡灵召唤物 = undefined;
  const target = 获取Boss技能随机敌对英雄(boss);
  if (!单位有效(target)) return false;
  const cfg = 安兹乌尔恭数值与表现配置;
  const stage = cfg.阶段技能;
  const angle = GetUnitFacing(boss) * DEG_TO_RAD;
  const summonX = GetUnitX(boss) + Cos(angle) * stage.高阶亡灵召唤距离;
  const summonY = GetUnitY(boss) + Sin(angle) * stage.高阶亡灵召唤距离;
  context.当前大型技能 = 高阶亡灵召唤大型技能Key;
  确保高阶亡灵死亡监听();
  播放召唤特效(cfg.表现资源.高阶亡灵召唤门特效路径, summonX, summonY, stage.高阶亡灵召唤门缩放);
  播放召唤特效(cfg.表现资源.高阶亡灵召唤外圈特效路径, summonX, summonY, stage.高阶亡灵召唤外圈缩放);
  播放召唤特效(cfg.表现资源.高阶亡灵召唤内圈特效路径, summonX, summonY, stage.高阶亡灵召唤内圈缩放);
  启动基础施法时间线({
    施法者: boss,
    目标X: summonX,
    目标Y: summonY,
    硬直秒: stage.高阶亡灵召唤施法秒,
    动画编号: stage.高阶亡灵召唤动画编号,
    动画速度: stage.高阶亡灵召唤动画速度,
    恢复动画编号: 安兹模型动画配置.待机编号,
    吟唱条: {
      通道: '常规技能',
      总时长: stage.高阶亡灵召唤施法秒,
      颜色ID: 4,
      标题文本: '高阶亡灵召唤',
      提示文本: '击败死亡骑士可暂时削弱亡灵箭法术',
    },
    on生效: function 高阶亡灵召唤生效(this: void): void {
      创建高阶亡灵(context, summonX, summonY, target);
      const finishId = addDelayedCallback(stage.高阶亡灵召唤收尾秒 * 1000, function 高阶亡灵召唤收尾(this: void): void {
        if (context.当前大型技能 === 高阶亡灵召唤大型技能Key) {
          context.当前大型技能 = undefined;
          context.上次大型技能结束Ms = getServerTime();
        }
      });
      context.清理.登记延迟回调('安兹-高阶亡灵召唤收尾', finishId);
    },
  });
  return true;
}

export const 高阶亡灵召唤技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: '高威胁单体召唤',
  语义: '每次只召唤一个高威胁亡灵，只强化安兹的一类法术，击败后给予明确团队收益。',
} as const;
