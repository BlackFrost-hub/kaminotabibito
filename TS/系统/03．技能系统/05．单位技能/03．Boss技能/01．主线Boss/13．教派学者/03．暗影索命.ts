/** @noSelfInFile */

import { 教派学者单位技能配置 } from './00．配置';
import { 获取全部教派学者上下文, 获取或创建教派学者上下文, 教派学者单位存活, type 教派学者运行时上下文 } from './01．运行时上下文';
import { 教派学者技能配置, 教派学者音效配置 } from './02．数值与表现配置';
import { 创建原生弹幕, 销毁原生弹幕 } from '../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕';
import { 创建召唤物 } from '../../../../00．技能模板+函数/01．技能函数/11．召唤物/04．对外接口';
import { 两点角度, 读取单位攻击力, 读取单位最大生命 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 执行Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 施加快速控制Buff } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  施加快速控制Buff: (this: void, source: any, target: any, controlId: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { registerManualBuff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { doHeal } = require('系统.04．伤害系统.02．治疗系统.01．核心功能') as {
  doHeal: (this: void, params: any) => number;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { Sound3DII_CooPlayReuse } = require('lib.扩展函数.封装函数.02．音效系统.03．3D音效播放') as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};

const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerController = jass.GetPlayerController as (player: any) => any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;
const MAP_CONTROL_USER = jass.MAP_CONTROL_USER as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

export type 暗影索命发射来源 = '普通攻击' | '邪狱追魂冥法';

interface 暗影索命弹幕状态 {
  上下文: 教派学者运行时上下文;
  弹幕ID: number;
  弹幕单位: any;
  发射来源: 暗影索命发射来源;
}

interface 暗影索命普攻快照 {
  上下文: 教派学者运行时上下文;
  目标单位: any;
}

interface 暗影索命清理状态 {
  弹幕ID: number;
  已结束: boolean;
}

const 教派学者单位类型ID = stringToFourCCSafe(教派学者单位技能配置.单位ID);
const 暗影弹幕状态表: Record<number, 暗影索命弹幕状态 | undefined> = {};
const 暗影单位到弹幕ID: Record<number, number | undefined> = {};
let 暗影索命已注册 = false;

function 是否玩家摧毁者(this: void, unit: any): boolean {
  return unit != null
    && unit !== 0
    && (IsUnitType(unit, UNIT_TYPE_HERO) || GetPlayerController(GetOwningPlayer(unit)) === MAP_CONTROL_USER);
}

function on暗影索命命中(this: void, target: any, barrageId: number): void {
  const 状态 = 暗影弹幕状态表[barrageId];
  if (状态 == null || !教派学者单位存活(状态.上下文.Boss单位) || !教派学者单位存活(target)) return;
  const boss = 状态.上下文.Boss单位;
  const 配置 = 教派学者技能配置.暗影索命;
  const 结果 = 执行Boss单体技能伤害({
    来源: boss,
    目标: target,
    伤害公式: { 来源攻击力比例: 配置.命中Boss攻击力比例 },
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: 配置.伤害标签,
  });
  if (结果.是否造成伤害) {
    施加快速控制Buff(boss, target, 0, 配置.命中眩晕秒, '教派学者-暗影索命', '技能');
    EC_CreateEffect(配置.命中特效路径, GetUnitX(target), GetUnitY(target), 0, 0, 配置.命中特效缩放, 1, 1);
    Sound3DII_CooPlayReuse(配置.命中音效路径, GetUnitX(target), GetUnitY(target), 0, 教派学者技能配置.公共施法.音效裁断距离);
  }
}

function on暗影索命被击落(this: void, killer: any, barrageId: number): void {
  const 状态 = 暗影弹幕状态表[barrageId];
  if (状态 == null || !是否玩家摧毁者(killer) || !教派学者单位存活(killer)) return;
  const 配置 = 教派学者技能配置.暗影索命;
  const 攻击力 = 读取单位攻击力(killer);
  const 治疗量 = 攻击力 * 配置.击落治疗攻击力比例;
  const 回魔量 = 攻击力 * 配置.击落回魔攻击力比例;
  const 击落前魔法值 = GetUnitState(killer, UNIT_STATE_MANA);
  const 实际治疗 = doHeal({
    HealSource: killer,
    HealTarget: killer,
    HealAmount: 治疗量,
    HealManaAmount: 回魔量,
    ItemHeal: false,
    HealEffect: true,
    HealEffectPath: 配置.击落恢复特效路径,
    ManaEffect: true,
  });
  const 实际回魔 = GetUnitState(killer, UNIT_STATE_MANA) - 击落前魔法值;
  Sound3DII_CooPlayReuse(教派学者音效配置.弹幕击落, GetUnitX(killer), GetUnitY(killer), 0, 教派学者技能配置.公共施法.音效裁断距离);
}

function on暗影索命结束(this: void, reason: any, barrageId: number): void {
  const 状态 = 暗影弹幕状态表[barrageId];
  delete 暗影弹幕状态表[barrageId];
  if (状态 == null) return;
  if (状态.弹幕单位 != null && 状态.弹幕单位 !== 0) delete 暗影单位到弹幕ID[GetHandleId(状态.弹幕单位)];
  delete 状态.上下文.暗影弹幕ID表[barrageId];
}

function on暗影索命弹幕清理(this: void, variable?: any): void {
  const 清理状态 = variable as 暗影索命清理状态 | undefined;
  if (清理状态 == null || 清理状态.已结束) return;
  清理状态.已结束 = true;
  销毁原生弹幕(清理状态.弹幕ID, '手动销毁');
}

export function 创建教派学者暗影弹幕(this: void, 上下文: 教派学者运行时上下文, 角度: number, 缩放: number, 发射来源: 暗影索命发射来源): number {
  const boss = 上下文?.Boss单位;
  if (!教派学者单位存活(boss)) {
    return 0;
  }
  const 配置 = 教派学者技能配置.暗影索命;
  const X = GetUnitX(boss);
  const Y = GetUnitY(boss);
  const 生命值 = 读取单位最大生命(boss) * 配置.弹幕生命Boss最大生命比例;
  const 载体单位 = 创建召唤物({
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: 配置.弹幕马甲单位ID,
    单位名称: '暗影',
    X,
    Y,
    朝向: 角度,
    持续时间: 配置.弹幕生命周期秒,
    生命值,
    禁止普攻: true,
    禁用路径: true,
    模型文件: 配置.弹幕模型路径,
    缩放,
  });
  if (载体单位 == null || 载体单位 === 0) {
    return 0;
  }
  SetUnitState(载体单位, UNIT_STATE_LIFE, 生命值);
  const 弹幕 = 创建原生弹幕({
    所有者: boss,
    弹幕单位: 载体单位,
    X,
    Y,
    方向角: 角度,
    速度: 配置.弹幕速度,
    生命周期: 配置.弹幕生命周期秒,
    命中半径: 配置.弹幕碰撞半径,
    影响目标: '敌方',
    碰撞消失: true,
    每单位最大命中次数: 1,
    最大总命中次数: 1,
    弹幕生命值: 生命值,
    可攻击摧毁: true,
    被阻挡时销毁: false,
    弹射: true,
    随机弹射: true,
    弹射次数上限: 配置.随机弹射次数上限,
    模型: 配置.弹幕模型路径,
    缩放,
    禁用碰撞: true,
    死亡时移除单位: true,
    on命中: on暗影索命命中,
    on被击落: on暗影索命被击落,
    on结束: on暗影索命结束,
  });
  const 状态: 暗影索命弹幕状态 = { 上下文, 弹幕ID: 弹幕.弹幕ID, 弹幕单位: 载体单位, 发射来源 };
  暗影弹幕状态表[弹幕.弹幕ID] = 状态;
  暗影单位到弹幕ID[GetHandleId(载体单位)] = 弹幕.弹幕ID;
  上下文.暗影弹幕ID表[弹幕.弹幕ID] = true;
  上下文.清理.登记清理('教派学者-暗影弹幕销毁', on暗影索命弹幕清理, { 弹幕ID: 弹幕.弹幕ID, 已结束: false } as 暗影索命清理状态);
  registerManualBuff(载体单位, 教派学者技能配置.Buff.暗影弹幕, 配置.弹幕生命周期秒, 生命值, {
    sourceUnit: boss,
    effectSourceName: '暗影索命',
    effectSourceType: '技能',
  });
  Sound3DII_CooPlayReuse(配置.发射音效路径, X, Y, 0, 教派学者技能配置.公共施法.音效裁断距离);
  return 弹幕.弹幕ID;
}

function on暗影索命普攻派生(this: void, variable?: any): void {
  const 快照 = variable as 暗影索命普攻快照 | undefined;
  if (快照 == null || !教派学者单位存活(快照.上下文.Boss单位)) return;
  const boss = 快照.上下文.Boss单位;
  const target = 快照.目标单位;
  const 角度 = 教派学者单位存活(target)
    ? 两点角度(GetUnitX(boss), GetUnitY(boss), GetUnitX(target), GetUnitY(target))
    : 0;
  创建教派学者暗影弹幕(快照.上下文, 角度, 教派学者技能配置.暗影索命.普攻弹幕缩放, '普通攻击');
}

function 教派学者普攻替换修正(this: void, context: any): number {
  if (context == null || !(context.currentDamage > 0) || context.isNormalAttack !== true || context.isSkillAttack === true || context.isSkillDamage === true) return context?.currentDamage ?? 0;
  const attacker = context.attacker;
  if (attacker == null || attacker === 0 || GetUnitTypeId(attacker) !== 教派学者单位类型ID) return context.currentDamage;
  const 上下文 = 获取或创建教派学者上下文(attacker);
  if (上下文 == null) return context.currentDamage;
  const 快照: 暗影索命普攻快照 = { 上下文, 目标单位: context.target };
  const 回调ID = addDelayedCallback(0, on暗影索命普攻派生, 快照);
  上下文.清理.登记延迟回调('教派学者-暗影索命普攻派生', 回调ID);
  return 0;
}

function 暗影索命克制承伤修正(this: void, context: any): number {
  if (context == null || context.target == null || context.target === 0 || (context.isThunderDamage !== true && context.isLightDamage !== true)) return context?.currentDamage ?? 0;
  const barrageId = 暗影单位到弹幕ID[GetHandleId(context.target)] ?? 0;
  if (barrageId <= 0 || 暗影弹幕状态表[barrageId] == null) return context.currentDamage;
  const after = context.currentDamage * 教派学者技能配置.暗影索命.雷光承伤倍率;
  return after;
}

export function 注册教派学者暗影索命(this: void): void {
  if (暗影索命已注册) return;
  暗影索命已注册 = true;
  registerDamageModifier(教派学者普攻替换修正, 教派学者技能配置.暗影索命.普攻替换修正优先级);
  registerDamageModifier(暗影索命克制承伤修正, 教派学者技能配置.暗影索命.克制承伤修正优先级);
}
