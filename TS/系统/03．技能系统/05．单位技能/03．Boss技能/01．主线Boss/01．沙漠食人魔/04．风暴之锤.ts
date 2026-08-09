/** @noSelfInFile */

import { 沙漠食人魔单位技能配置 } from './00．配置';
import { 沙漠食人魔技能配置 } from './02．数值与表现配置';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { 创建原生弹幕, 获取原生弹幕 } from '../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { 施加快速控制Buff } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  施加快速控制Buff: (this: void, source: any, target: any, controlId: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 取当前有效玩家人数 } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数') as {
  取当前有效玩家人数: (this: void) => number;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitStateJapi = japi.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 沙漠食人魔单位类型ID = stringToFourCCSafe(沙漠食人魔单位技能配置.单位ID);
const 风暴之锤技能ID = stringToFourCCSafe(沙漠食人魔单位技能配置.技能ID.风暴之锤);
let 风暴之锤已注册 = false;

interface 风暴之锤待发数据 {
  Boss单位: any;
  指定目标: any;
  技能实例ID?: number;
}

interface 风暴之锤弹幕数据 extends 风暴之锤待发数据 {
  基础倍率: number;
  基础眩晕秒: number;
}

const 风暴之锤待发队列: 风暴之锤待发数据[] = [];
const 风暴之锤弹幕表: Record<number, 风暴之锤弹幕数据 | undefined> = {};

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 获取沙漠食人魔技能上下文(this: void, boss: any): any | undefined {
  return 单位存活(boss) ? boss : undefined;
}

function 目标是Boss敌对英雄(this: void, boss: any, target: any): boolean {
  if (!单位存活(target)) return false;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    if (heroes[i] === target) return true;
  }
  return false;
}

function 取风暴之锤目标(this: void, boss: any): any {
  const spellTarget = GetSpellTargetUnit();
  if (目标是Boss敌对英雄(boss, spellTarget)) return spellTarget;
  return 获取Boss技能随机敌对英雄(boss);
}

function on风暴之锤目标筛选(this: void, target: any, barrageId: number): boolean {
  if (barrageId == null) {
    debugLogForce('沙漠食人魔-风暴之锤', '目标筛选跳过：弹幕 ID 为空');
    return false;
  }
  const data = 风暴之锤弹幕表[barrageId];
  return data != null && 目标是Boss敌对英雄(data.Boss单位, target);
}

function on风暴之锤命中(this: void, hitUnit: any, barrageId: number): void {
  if (barrageId == null) {
    debugLogForce('沙漠食人魔-风暴之锤', '命中回调跳过：弹幕 ID 为空');
    return;
  }
  const data = 风暴之锤弹幕表[barrageId];
  if (data == null || !单位存活(data.Boss单位) || !单位存活(hitUnit)) return;
  const cfg = 沙漠食人魔技能配置.风暴之锤;
  const instance = 获取原生弹幕(barrageId);
  const x = instance != null ? instance.当前X : GetUnitX(hitUnit);
  const y = instance != null ? instance.当前Y : GetUnitY(hitUnit);
  const actualMultiplier = hitUnit === data.指定目标 ? 1 : cfg.非指定目标倍率;
  const damageMultiplier = data.基础倍率 * actualMultiplier;
  const stunDuration = data.基础眩晕秒 * actualMultiplier;
  debugLogForce('沙漠食人魔-风暴之锤', '弹幕命中', 'barrageId=', barrageId, 'bossHid=', GetHandleId(data.Boss单位), 'hitHid=', GetHandleId(hitUnit), '指定目标Hid=', GetHandleId(data.指定目标), 'actualMultiplier=', actualMultiplier, 'damageMultiplier=', damageMultiplier, 'stunDuration=', stunDuration);
  EC_CreateEffect(cfg.爆炸特效, x, y, 0, 270, 2.5, 1, 1);
  const heroes = 获取Boss技能敌对英雄列表(data.Boss单位);
  const radiusSquared = cfg.爆炸范围 * cfg.爆炸范围;
  let 命中目标数量 = 0;
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!单位存活(target)) continue;
    const dx = GetUnitX(target) - x;
    const dy = GetUnitY(target) - y;
    if (dx * dx + dy * dy > radiusSquared) continue;
    命中目标数量++;
    执行BossAOE技能伤害({
      来源: data.Boss单位,
      目标: target,
      技能ID: 风暴之锤技能ID,
      技能实例ID: data.技能实例ID,
      伤害公式: { 来源攻击力比例: damageMultiplier },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_PLANT,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: '沙漠食人魔·风暴之锤',
    });
    施加快速控制Buff(data.Boss单位, target, 0, stunDuration, '沙漠食人魔-风暴之锤', '技能');
  }
  debugLogForce('沙漠食人魔-风暴之锤', '爆炸结算完成', 'barrageId=', barrageId, 'targetCount=', 命中目标数量, 'centerX=', x, 'centerY=', y);
}

function on风暴之锤结束(this: void, reason: any, barrageId: number): void {
  if (barrageId == null) {
    debugLogForce('沙漠食人魔-风暴之锤', '弹幕结束跳过清理：弹幕 ID 为空', 'reason=', reason);
    return;
  }
  debugLogForce('沙漠食人魔-风暴之锤', '弹幕结束', 'barrageId=', barrageId, 'reason=', reason);
  delete 风暴之锤弹幕表[barrageId];
}

function on风暴之锤生效(this: void): void {
  debugLogForce('沙漠食人魔-风暴之锤', '施法生效回调', 'pendingCount=', 风暴之锤待发队列.length);
  while (风暴之锤待发队列.length > 0) {
    const data = 风暴之锤待发队列[0];
    风暴之锤待发队列.splice(0, 1);
    if (data == null || !单位存活(data.Boss单位) || !单位存活(data.指定目标)) {
      debugLogForce('沙漠食人魔-风暴之锤', '弹幕创建跳过', 'dataValid=', data != null, 'bossAlive=', data != null && 单位存活(data.Boss单位), 'targetAlive=', data != null && 单位存活(data.指定目标));
      continue;
    }
    const cfg = 沙漠食人魔技能配置.风暴之锤;
    const singlePlayerMultiplier = 取当前有效玩家人数() <= 1 ? cfg.单人倍率 : 1;
    const projectileLife = cfg.弹幕生命值;
    const projectile = 创建原生弹幕({
      所有者: data.Boss单位,
      轨迹类型: '追踪',
      指定目标: data.指定目标,
      速度: cfg.速度,
      生命周期: cfg.生命周期秒,
      命中半径: cfg.命中半径,
      影响目标: '敌方',
      碰撞消失: true,
      最大总命中次数: 1,
      弹幕生命值: projectileLife,
      可攻击摧毁: true,
      模型: cfg.模型,
      缩放: 3,
      飞行高度: 325,
      目标筛选: on风暴之锤目标筛选,
      on命中: on风暴之锤命中,
      on结束: on风暴之锤结束,
    });
    const 弹幕ID = projectile != null ? projectile.弹幕ID : undefined;
    debugLogForce('沙漠食人魔-风暴之锤', '弹幕创建结果', 'barrageId=', 弹幕ID, 'projectileValid=', projectile != null, 'bossHid=', GetHandleId(data.Boss单位), 'targetHid=', GetHandleId(data.指定目标));
    if (弹幕ID == null) {
      debugLogForce('沙漠食人魔-风暴之锤', '弹幕数据登记跳过：弹幕 ID 为空');
      return;
    }
    风暴之锤弹幕表[弹幕ID] = {
      Boss单位: data.Boss单位,
      指定目标: data.指定目标,
      技能实例ID: data.技能实例ID,
      基础倍率: cfg.攻击力比例 * singlePlayerMultiplier,
      基础眩晕秒: cfg.眩晕秒 * singlePlayerMultiplier,
    };
    if (projectile.弹幕单位 != null && projectile.弹幕单位 !== 0) {
      SetUnitStateJapi(projectile.弹幕单位, UNIT_STATE_MAX_LIFE, projectileLife);
      SetUnitState(projectile.弹幕单位, UNIT_STATE_LIFE, projectileLife);
    }
    debugLogForce('沙漠食人魔-风暴之锤', '弹幕已创建', 'barrageId=', 弹幕ID, 'bossHid=', GetHandleId(data.Boss单位), 'targetHid=', GetHandleId(data.指定目标), 'life=', projectileLife, 'singlePlayerMultiplier=', singlePlayerMultiplier);
    return;
  }
}

export function 释放沙漠食人魔风暴之锤(this: void, boss: any, skillInstanceId?: number): boolean {
  if (!单位存活(boss)) {
    debugLogForce('沙漠食人魔-风暴之锤', '释放拒绝：Boss无效');
    return false;
  }
  const target = 取风暴之锤目标(boss);
  if (!单位存活(target)) {
    debugLogForce('沙漠食人魔-风暴之锤', '释放拒绝：目标无效', 'bossHid=', GetHandleId(boss), 'skillInstanceId=', skillInstanceId);
    return false;
  }
  风暴之锤待发队列.push({ Boss单位: boss, 指定目标: target, 技能实例ID: skillInstanceId });
  debugLogForce('沙漠食人魔-风暴之锤', '施法开始', 'bossHid=', GetHandleId(boss), 'targetHid=', GetHandleId(target), 'skillInstanceId=', skillInstanceId, 'pendingCount=', 风暴之锤待发队列.length);
  启动基础施法时间线({
    名称: '沙漠食人魔-风暴之锤',
    施法者: boss,
    目标单位: target,
    硬直秒: 1,
    动画编号: 5,
    恢复动画编号: 1,
    吟唱条: {
      通道: '常规技能',
      总时长: 1,
      颜色ID: 3,
      标题文本: '风暴之锤',
      提示文本: '追踪重锤即将发射',
    },
    on生效: on风暴之锤生效,
  });
  return true;
}

function on风暴之锤技能壳释放(this: void, _context: any, boss: any, skillInstanceId?: number): void {
  释放沙漠食人魔风暴之锤(boss, skillInstanceId);
}

export function 注册沙漠食人魔风暴之锤(this: void): void {
  if (风暴之锤已注册) return;
  风暴之锤已注册 = true;
  注册单位技能壳监听({
    名称: '沙漠食人魔-风暴之锤',
    单位类型ID: 沙漠食人魔单位类型ID,
    技能ID: 风暴之锤技能ID,
    获取或创建上下文: 获取沙漠食人魔技能上下文,
    释放技能: on风暴之锤技能壳释放,
    技能实例持续时间秒: 7,
  });
  debugLogForce('沙漠食人魔-风暴之锤', '技能监听注册完成', 'skillId=', 风暴之锤技能ID);
}
