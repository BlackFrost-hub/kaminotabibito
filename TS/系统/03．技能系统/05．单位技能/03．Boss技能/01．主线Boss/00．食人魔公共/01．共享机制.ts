/** @noSelfInFile */

import { 开始硬直, 单位是否处于硬控制效果合集 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 播放食人魔公共台词 } from './03．台词播放';

const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { registerDeathListener } = require('系统.00．核心系统.01．事件中心.07．单位死亡事件中心') as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { getRegisteredPlayerHero } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接') as {
  getRegisteredPlayerHero: (this: void, player: any) => any | null;
};
const { 获取Boss技能敌对英雄列表, 是否已登记Boss技能测试目标 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  是否已登记Boss技能测试目标: (this: void, unit: any) => boolean;
};
const { getGameDifficulty, addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getGameDifficulty: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, callbackId: number) => void;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
};
const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require('lib.扩展函数.自定义扩展函数.06．单位状态安全包装') as {
  暂停并设置无敌安全: (this: void, unit: any, source: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, source: string) => boolean;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { 闪电效果代码 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码') as {
  闪电效果代码: { 灵魂锁链: string };
};
const { 创建单位绑定闪电, 销毁单位绑定闪电 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电') as {
  创建单位绑定闪电: (this: void, 参数: any) => any;
  销毁单位绑定闪电: (this: void, 闪电句柄: any) => void;
};
const { 开始方向抵抗牵引 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.05．吸附·牵引.方向抵抗牵引') as {
  开始方向抵抗牵引: (this: void, 参数: any) => { 停止: (this: void) => void };
};
const { 显示大招吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示大招吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { Sound3DII_CooPlayReuse } = require('lib.扩展函数.封装函数.02．音效系统.03．3D音效播放') as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number, model?: any) => any;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animation: string) => void;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;
const UnitResetCooldown = jass.UnitResetCooldown as (unit: any) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 普通食人魔ID = stringToFourCCSafe('N05J');
const 杀戮食人魔ID = stringToFourCCSafe('N05K');
const 啃食无敌来源 = '食人魔-击杀啃食';
const 雷霆震怒无敌来源 = '食人魔-雷霆震怒';
const 雷霆震怒音效裁断距离 = 2800;
let 食人魔共享机制已注册 = false;

interface 啃食状态 {
  Boss单位: any;
  完成回调ID: number;
  周期ID: number;
}

const 啃食状态表: Record<number, 啃食状态 | undefined> = {};

export interface 食人魔雷霆震怒配置 {
  总硬直秒: number;
  牵引开始秒: number;
  结算秒: number;
  牵引范围: number;
  爆心筛选范围: number;
  爆心范围: number;
  牵引次数: number;
  牵引间隔秒: number;
  每次牵引距离: number;
  攻击力比例: number;
  目标最大生命比例: number;
  起手动画编号: number;
  起手动画名?: string;
  敲击动画编号: number;
  蓄力特效: string;
  牵引结束特效: string;
  结算特效: string;
  结算附加特效: string;
  起手音效路径?: string;
}

interface 雷霆震怒数据 {
  Boss单位: any;
  配置: 食人魔雷霆震怒配置;
  牵引控制器?: { 停止: (this: void) => void };
  无敌尚未恢复: boolean;
  起手闪电句柄列表: any[];
}

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && !IsUnitType(unit, UNIT_TYPE_DEAD) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 取句柄ID(this: void, handle: any): number {
  return handle != null && handle !== 0 ? GetHandleId(handle) : 0;
}

function 创建食人魔雷霆震怒起手闪电(this: void, boss: any, 持续秒: number): any[] {
  const targets = 获取Boss技能敌对英雄列表(boss);
  const 闪电句柄列表: any[] = [];
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位存活(target)) continue;
    const lightning = 创建单位绑定闪电({
      效果代码: 闪电效果代码.灵魂锁链,
      起点单位: boss,
      终点单位: target,
      持续时间: 持续秒,
      起点高度偏移: 80,
      终点高度偏移: 80,
      任一死亡时销毁: true,
    });
    if (lightning != null && lightning !== 0) {
      闪电句柄列表.push(lightning);
    }
  }
  return 闪电句柄列表;
}

function 销毁食人魔雷霆震怒起手闪电(this: void, data: 雷霆震怒数据): void {
  for (let i = 0; i < data.起手闪电句柄列表.length; i++) {
    销毁单位绑定闪电(data.起手闪电句柄列表[i]);
  }
  data.起手闪电句柄列表 = [];
}

function 清理啃食状态(this: void, 状态: 啃食状态): void {
  if (状态.完成回调ID !== 0) {
    removeDelayedCallback(状态.完成回调ID);
    状态.完成回调ID = 0;
  }
  if (状态.周期ID !== 0) {
    removePeriodicCallback(状态.周期ID);
    状态.周期ID = 0;
  }
  delete 啃食状态表[取句柄ID(状态.Boss单位)];
}

function on啃食完成(this: void, variable?: any): void {
  const data = variable as 啃食状态 | undefined;
  if (data == null) {
    debugLogForce('食人魔-共享机制', '啃食完成回调跳过：数据为空');
    return;
  }
  if (!单位存活(data.Boss单位)) {
    debugLogForce('食人魔-共享机制', '啃食完成回调跳过：Boss已失效', 'bossHid=', 取句柄ID(data.Boss单位));
    清理啃食状态(data);
    return;
  }
  const boss = data.Boss单位;
  清理啃食状态(data);
  const maxLife = GetUnitStateJapi(boss, UNIT_STATE_MAX_LIFE);
  const maxMana = GetUnitStateJapi(boss, UNIT_STATE_MAX_MANA);
  UnitResetCooldown(boss);
  const 解除无敌成功 = 解除暂停并取消无敌安全(boss, 啃食无敌来源);
  SetUnitState(boss, UNIT_STATE_LIFE, maxLife);
  SetUnitState(boss, UNIT_STATE_MANA, maxMana);
  debugLogForce('食人魔-共享机制', '啃食完成：恢复生命魔法并重置冷却', 'bossHid=', 取句柄ID(boss), '解除无敌成功=', 解除无敌成功, 'lifeAfterRestore=', GetUnitState(boss, UNIT_STATE_LIFE), 'maxLife=', maxLife, 'manaAfterRestore=', GetUnitState(boss, UNIT_STATE_MANA), 'maxMana=', maxMana);
}

function 中断啃食(this: void, 状态: 啃食状态): void {
  const boss = 状态.Boss单位;
  清理啃食状态(状态);
  if (单位存活(boss)) {
    解除暂停并取消无敌安全(boss, 啃食无敌来源);
  }
  播放食人魔公共台词(boss, '击杀啃食被打断');
  debugLogForce('食人魔-共享机制', '击杀啃食被硬控制打断', 'bossHid=', 取句柄ID(boss));
}

function on啃食控制打断检查(this: void, variable?: any): void {
  const data = variable as 啃食状态 | undefined;
  if (data == null || !单位存活(data.Boss单位)) return;
  if (!单位是否处于硬控制效果合集(data.Boss单位)) return;
  中断啃食(data);
}

function on食人魔击杀(this: void, dyingUnit: any, killingUnit: any): void {
  if (!单位存活(killingUnit)) return;
  const killerType = GetUnitTypeId(killingUnit);
  if (killerType !== 普通食人魔ID && killerType !== 杀戮食人魔ID) return;
  const owner = GetOwningPlayer(dyingUnit);
  const 是玩家英雄 = owner != null && owner !== 0 && getRegisteredPlayerHero(owner) === dyingUnit;
  const 是测试目标 = 是否已登记Boss技能测试目标(dyingUnit);
  if (!是玩家英雄 && !是测试目标) {
    debugLogForce('食人魔-共享机制', '击杀啃食忽略：目标不是玩家英雄或测试目标', 'bossHid=', 取句柄ID(killingUnit), 'targetHid=', 取句柄ID(dyingUnit), 'killerType=', killerType);
    return;
  }
  const difficulty = getGameDifficulty() > 0 ? getGameDifficulty() : 1;
  const duration = 2.6 - difficulty * 0.2;
  const bossId = 取句柄ID(killingUnit);
  const 旧状态 = 啃食状态表[bossId];
  if (旧状态 != null) 清理啃食状态(旧状态);
  开始硬直(killingUnit, duration);
  const 暂停无敌成功 = 暂停并设置无敌安全(killingUnit, 啃食无敌来源);
  const 啃食动画编号 = killerType === 普通食人魔ID ? 3 : 11;
  播放限时单位动画({ 单位: killingUnit, 动画编号: 啃食动画编号, 持续秒: duration, 恢复动画编号: 1 });
  EC_CreateEffect('Abilities\\Spells\\Undead\\DeathPact\\DeathPactTarget.mdl', GetUnitX(killingUnit), GetUnitY(killingUnit), 0, 270, 1, 1, duration);
  播放食人魔公共台词(killingUnit, '击杀啃食');
  const 状态: 啃食状态 = { Boss单位: killingUnit, 完成回调ID: 0, 周期ID: 0 };
  状态.完成回调ID = addDelayedCallback(duration * 1000, on啃食完成, 状态);
  状态.周期ID = addPeriodicCallback(250, on啃食控制打断检查, 状态);
  啃食状态表[bossId] = 状态;
  debugLogForce('食人魔-共享机制', '击杀啃食开始', 'bossHid=', 取句柄ID(killingUnit), 'targetHid=', 取句柄ID(dyingUnit), 'difficulty=', difficulty, 'duration=', duration, '动画编号=', 啃食动画编号, '是玩家英雄=', 是玩家英雄, '是测试目标=', 是测试目标, '暂停无敌成功=', 暂停无敌成功, '完成回调ID=', 状态.完成回调ID);
}

function 获取雷霆震怒牵引目标(this: void, data: 雷霆震怒数据): any[] {
  return 获取Boss技能敌对英雄列表(data.Boss单位);
}

function 过滤雷霆震怒牵引目标(this: void, data: 雷霆震怒数据, target: any): boolean {
  if (!单位存活(target) || !单位存活(data.Boss单位)) return false;
  const dx = GetUnitX(data.Boss单位) - GetUnitX(target);
  const dy = GetUnitY(data.Boss单位) - GetUnitY(target);
  return dx * dx + dy * dy <= data.配置.牵引范围 * data.配置.牵引范围;
}

function on雷霆震怒开始牵引(this: void, variable?: any): void {
  const data = variable as 雷霆震怒数据 | undefined;
  if (data == null || !单位存活(data.Boss单位)) return;
  data.牵引控制器 = 开始方向抵抗牵引({
    名称: '食人魔-雷霆震怒',
    目标单位列表: [],
    目标单位提供器: function 雷霆震怒动态目标(this: void): any[] {
      return 获取雷霆震怒牵引目标(data);
    },
    中心单位: data.Boss单位,
    持续秒: data.配置.牵引间隔秒 * (data.配置.牵引次数 + 1),
    每秒拉力速度: data.配置.每次牵引距离 / data.配置.牵引间隔秒,
    抵抗方向角度: 0,
    启用方向抵抗: false,
    Tick毫秒: data.配置.牵引间隔秒 * 1000,
    最大执行次数: data.配置.牵引次数,
    到达距离: 0,
    过滤单位: function 雷霆震怒目标过滤(this: void, target: any): boolean {
      return 过滤雷霆震怒牵引目标(data, target);
    },
  });
}

function on雷霆震怒结算(this: void, variable?: any): void {
  const data = variable as 雷霆震怒数据 | undefined;
  if (data == null || !单位存活(data.Boss单位)) return;
  const boss = data.Boss单位;
  const cfg = data.配置;
  if (data.无敌尚未恢复) {
    data.无敌尚未恢复 = false;
    解除暂停并取消无敌安全(boss, 雷霆震怒无敌来源);
  }
  播放限时单位动画({ 单位: boss, 动画编号: cfg.敲击动画编号, 持续秒: 1, 恢复动画编号: 1 });
  EC_CreateEffect(cfg.牵引结束特效, GetUnitX(boss), GetUnitY(boss), 50, 270, 4, 1, 2);
  const centers = 获取Boss技能敌对英雄列表(boss);
  const bx = GetUnitX(boss);
  const by = GetUnitY(boss);
  const selectSquared = cfg.爆心筛选范围 * cfg.爆心筛选范围;
  const hitSquared = cfg.爆心范围 * cfg.爆心范围;
  for (let i = 0; i < centers.length; i++) {
    const center = centers[i];
    if (!单位存活(center)) continue;
    const cdx = GetUnitX(center) - bx;
    const cdy = GetUnitY(center) - by;
    if (cdx * cdx + cdy * cdy > selectSquared) continue;
    const cx = GetUnitX(center);
    const cy = GetUnitY(center);
    EC_CreateEffect(cfg.结算附加特效, cx, cy, 50, 270, 1.4, 1, 2);
    EC_CreateEffect(cfg.结算特效, cx, cy, 50, 270, 2, 1, 2);
    for (let j = 0; j < centers.length; j++) {
      const target = centers[j];
      if (!单位存活(target)) continue;
      const dx = GetUnitX(target) - cx;
      const dy = GetUnitY(target) - cy;
      if (dx * dx + dy * dy > hitSquared) continue;
      执行BossAOE技能伤害({
        来源: boss,
        目标: target,
        伤害公式: { 来源攻击力比例: cfg.攻击力比例, 目标最大生命比例: cfg.目标最大生命比例 },
        attack: true,
        ranged: false,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        标签: '食人魔·雷霆震怒',
      });
    }
  }
}

function on雷霆震怒硬直结束(this: void, variable?: any): void {
  const data = variable as 雷霆震怒数据 | undefined;
  if (data == null) return;
  if (data.牵引控制器 != null) data.牵引控制器.停止();
  data.牵引控制器 = undefined;
  if (data.无敌尚未恢复) {
    data.无敌尚未恢复 = false;
    if (单位存活(data.Boss单位)) {
      解除暂停并取消无敌安全(data.Boss单位, 雷霆震怒无敌来源);
    }
  }
  销毁食人魔雷霆震怒起手闪电(data);
  关闭吟唱条('大招');
}

export function 施放食人魔雷霆震怒(this: void, boss: any, 配置: 食人魔雷霆震怒配置): boolean {
  if (!单位存活(boss)) return false;
  开始硬直(boss, 配置.总硬直秒);
  暂停并设置无敌安全(boss, 雷霆震怒无敌来源);
  if (配置.起手音效路径 != null && 配置.起手音效路径 !== '') {
    Sound3DII_CooPlayReuse(
      配置.起手音效路径,
      GetUnitX(boss),
      GetUnitY(boss),
      0,
      雷霆震怒音效裁断距离,
    );
  }
  显示大招吟唱条({
    通道: '大招',
    总时长: 配置.总硬直秒,
    颜色ID: 3,
    标题文本: '雷霆震怒',
    提示文本: '远离重叠爆心',
  });
  if (配置.起手动画名 != null && 配置.起手动画名 !== '') {
    SetUnitAnimation(boss, 配置.起手动画名);
  } else {
    播放限时单位动画({ 单位: boss, 动画编号: 配置.起手动画编号, 持续秒: 配置.结算秒, 恢复动画编号: 1 });
  }
  EC_CreateEffect(配置.蓄力特效, GetUnitX(boss), GetUnitY(boss), 50, 270, 2, 1, 配置.结算秒);
  const data: 雷霆震怒数据 = {
    Boss单位: boss,
    配置,
    牵引控制器: undefined,
    无敌尚未恢复: true,
    起手闪电句柄列表: [],
  };
  data.起手闪电句柄列表 = 创建食人魔雷霆震怒起手闪电(boss, 配置.总硬直秒);
  addDelayedCallback(配置.牵引开始秒 * 1000, on雷霆震怒开始牵引, data);
  addDelayedCallback(配置.结算秒 * 1000, on雷霆震怒结算, data);
  addDelayedCallback(配置.总硬直秒 * 1000, on雷霆震怒硬直结束, data);
  return true;
}

export function 注册食人魔共享机制(this: void): void {
  if (食人魔共享机制已注册) {
    debugLogForce('食人魔-共享机制', '重复注册请求已忽略');
    return;
  }
  食人魔共享机制已注册 = true;
  registerDeathListener(on食人魔击杀);
  debugLogForce('食人魔-共享机制', '共享机制注册完成：击杀啃食与雷霆震怒');
}
