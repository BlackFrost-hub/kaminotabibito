/** @noSelfInFile */

import { 教派学者单位技能配置 } from './00．配置';
import { 获取全部教派学者上下文, 获取或创建教派学者上下文, 教派学者单位存活, type 教派学者运行时上下文 } from './01．运行时上下文';
import { 教派学者技能配置 } from './02．数值与表现配置';
import { 播放教派学者台词 } from './09．台词播放';
import { 创建可攻击机制单位, type 可攻击机制单位实例, type 可攻击机制单位结束原因 } from '../../../../00．技能模板+函数/04．机制组件/05．机制单位/01．可攻击机制单位';
import { 创建召唤物组状态, type 召唤物组状态 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/03．召唤物组状态管理';
import { 执行非伤害生命移除 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/09．非伤害生命移除';
import { 创建召唤物 } from '../../../../00．技能模板+函数/01．技能函数/11．召唤物/04．对外接口';
import { 极坐标X, 极坐标Y, 读取单位攻击力, 读取单位最大生命 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 执行Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';

const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
};
const { 取当前有效玩家人数 } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数') as {
  取当前有效玩家人数: (this: void) => number;
};
const { 开始硬直 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, target: any, buffID: string) => any | null;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};

const jass = require('jass.common') as any;
const globals = require('jass.globals') as { udg_N?: number; [key: string]: any };
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animation: string) => void;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 冥神魔门状态 {
  已结束: boolean;
  上下文: 教派学者运行时上下文;
  门实例?: 可攻击机制单位实例;
  门单位?: any;
  门X: number;
  门Y: number;
  召唤组: 召唤物组状态;
  已召唤次数: number;
  批次已结束: boolean;
  召唤周期ID: number;
}

interface 魔门召唤普攻快照 {
  状态: 冥神魔门状态;
  召唤物: any;
  目标单位: any;
  固定伤害: number;
  召唤物类型ID: number;
}

interface 魔门治疗压制状态 {
  已恢复: boolean;
  上下文: 教派学者运行时上下文;
  目标单位: any;
  降低比例: number;
  Buff运行时: any | null;
}

interface 魔门释放请求 {
  上下文: 教派学者运行时上下文;
}

interface 魔门读条关闭请求 {
  通道: string;
  Boss单位: any;
}

interface 魔门单位归属 {
  状态: 冥神魔门状态;
  类型: '门' | '召唤物';
}

const 冥神魔门技能ID = stringToFourCCSafe(教派学者单位技能配置.技能壳.冥神魔门);
const 邪尸鬼单位类型ID = stringToFourCCSafe('u00G');
const 地狱犬单位类型ID = stringToFourCCSafe('n05O');
let 冥神魔门已注册 = false;

function 读取当前难度N(this: void): number {
  const value = Number(globals.udg_N);
  return value === value && value > 0 ? value : 0;
}

function 读取单位实数属性(this: void, unit: any, attr: string): number {
  if (unit == null || unit === 0) return 0;
  return Number(YDUserDataGetSafe('unit', unit, attr, 'real')) || 0;
}

function 设置单位实数属性(this: void, unit: any, attr: string, value: number): void {
  if (unit == null || unit === 0) return;
  YDUserDataSetSafe('unit', unit, attr, 'real', value);
}

function 修改单位实数属性(this: void, unit: any, attr: string, delta: number): void {
  设置单位实数属性(unit, attr, 读取单位实数属性(unit, attr) + delta);
}

function on魔门读条关闭(this: void, variable?: any): void {
  const 请求 = variable as 魔门读条关闭请求 | undefined;
  if (请求 == null) return;
  关闭吟唱条(请求.通道);
}

function 开始冥神魔门施法表现(this: void, 上下文: 教派学者运行时上下文): void {
  const boss = 上下文.Boss单位;
  const 公共 = 教派学者技能配置.公共施法;
  const 配置 = 教派学者技能配置.冥神魔门;
  开始硬直(boss, 公共.通魔施法秒);
  SetUnitAnimation(boss, 公共.动作名);
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 公共.通魔施法秒, 颜色ID: 公共.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  const 回调ID = addDelayedCallback(公共.通魔施法秒 * 1000, on魔门读条关闭, { 通道: 配置.读条通道, Boss单位: boss } as 魔门读条关闭请求);
  上下文.清理.登记延迟回调('教派学者-冥神魔门读条关闭', 回调ID);
}

function 结束魔门反噬(this: void, 上下文: 教派学者运行时上下文, 原因: string): void {
  if (!上下文.魔门反噬生效) return;
  上下文.魔门反噬生效 = false;
  if (上下文.Boss单位 != null && 上下文.Boss单位 !== 0) 设置单位实数属性(上下文.Boss单位, '魔抗', 上下文.魔门反噬原魔抗);
  上下文.魔门反噬结束回调ID = 0;
  移除单位指定Buff(上下文.Boss单位, 教派学者技能配置.Buff.冥神魔门反噬);
}

function on魔门反噬到期(this: void, variable?: any): void {
  const 上下文 = variable as 教派学者运行时上下文 | undefined;
  if (上下文 != null) 结束魔门反噬(上下文, '持续时间结束');
}

function 触发魔门反噬(this: void, 状态: 冥神魔门状态): void {
  const 上下文 = 状态.上下文;
  const boss = 上下文.Boss单位;
  if (!教派学者单位存活(boss) || 上下文.魔门反噬生效) return;
  const 配置 = 教派学者技能配置.冥神魔门;
  上下文.魔门反噬生效 = true;
  上下文.魔门反噬原魔抗 = 读取单位实数属性(boss, '魔抗');
  设置单位实数属性(boss, '魔抗', 0);
  开始硬直(boss, 配置.反噬硬直秒);
  registerManualBuff(boss, 教派学者技能配置.Buff.冥神魔门反噬, 配置.反噬硬直秒, 上下文.魔门反噬原魔抗, {
    sourceUnit: boss,
    effectSourceName: '冥神魔门反噬',
    effectSourceType: '技能',
  });
  上下文.魔门反噬结束回调ID = addDelayedCallback(配置.反噬硬直秒 * 1000, on魔门反噬到期, 上下文);
  上下文.清理.登记延迟回调('教派学者-魔门反噬恢复', 上下文.魔门反噬结束回调ID);
}

function 恢复魔门治疗压制(this: void, variable?: any): void {
  const 状态 = variable as 魔门治疗压制状态 | undefined;
  if (状态 == null || 状态.已恢复) return;
  const buffID = 教派学者技能配置.Buff.魔门邪尸鬼治疗压制;
  const 当前Buff运行时 = getBuffRuntime(状态.目标单位, buffID);
  状态.已恢复 = true;
  修改单位实数属性(状态.目标单位, '受到的治疗率', 状态.降低比例);
  if (状态.Buff运行时 != null && 当前Buff运行时 === 状态.Buff运行时) 移除单位指定Buff(状态.目标单位, buffID);
  状态.Buff运行时 = null;
}

function 施加魔门治疗压制(this: void, 状态: 冥神魔门状态, target: any): void {
  const 配置 = 教派学者技能配置.冥神魔门;
  修改单位实数属性(target, '受到的治疗率', -配置.邪尸鬼治疗降低比例);
  const buffID = 教派学者技能配置.Buff.魔门邪尸鬼治疗压制;
  registerManualBuff(target, buffID, 配置.邪尸鬼治疗降低秒, -配置.邪尸鬼治疗降低比例, {
    sourceUnit: 状态.上下文.Boss单位,
    effectSourceName: '冥神魔门邪尸鬼',
    effectSourceType: '技能',
  });
  const 压制状态: 魔门治疗压制状态 = {
    已恢复: false,
    上下文: 状态.上下文,
    目标单位: target,
    降低比例: 配置.邪尸鬼治疗降低比例,
    Buff运行时: getBuffRuntime(target, buffID),
  };
  状态.上下文.清理.登记清理('教派学者-魔门治疗压制恢复', 恢复魔门治疗压制, 压制状态);
  const 回调ID = addDelayedCallback(配置.邪尸鬼治疗降低秒 * 1000, 恢复魔门治疗压制, 压制状态);
  状态.上下文.清理.登记延迟回调('教派学者-魔门治疗压制到期', 回调ID);
}

function 结束冥神魔门(this: void, 状态: 冥神魔门状态, 原因: string): void {
  if (状态.已结束) return;
  状态.已结束 = true;
  if (状态.召唤周期ID !== 0) {
    removePeriodicCallback(状态.召唤周期ID);
    状态.召唤周期ID = 0;
  }
  if (!状态.批次已结束) {
    状态.批次已结束 = true;
    状态.召唤组.结束批次();
  }
  状态.召唤组.清空(true);
  const 门实例 = 状态.门实例;
  状态.门实例 = undefined;
  状态.门单位 = undefined;
  if (门实例 != null) 门实例.销毁('主动销毁');
  if (状态.上下文.冥神魔门状态 === 状态) 状态.上下文.冥神魔门状态 = undefined;
}

function on冥神魔门清理(this: void, variable?: any): void {
  const 状态 = variable as 冥神魔门状态 | undefined;
  if (状态 == null) return;
  结束冥神魔门(状态, '上下文清理');
  结束魔门反噬(状态.上下文, '上下文清理');
}

function on魔门机制结束(this: void, _unit: any, reason: 可攻击机制单位结束原因, killer?: any, variable?: any): void {
  const 状态 = variable as 冥神魔门状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  状态.门实例 = undefined;
  状态.门单位 = undefined;
  if (reason === '被击杀' && killer != null && killer !== 0) 触发魔门反噬(状态);
  结束冥神魔门(状态, reason === '被击杀' ? '次元之门被摧毁' : reason);
}

function 创建魔门召唤物(this: void, 状态: 冥神魔门状态): void {
  if (状态.已结束 || !教派学者单位存活(状态.上下文.Boss单位) || 状态.门单位 == null || 状态.门单位 === 0) return;
  const 配置 = 教派学者技能配置.冥神魔门;
  const boss = 状态.上下文.Boss单位;
  const index = GetRandomInt(0, 教派学者单位技能配置.魔门召唤单位ID.length - 1);
  const 单位类型 = 教派学者单位技能配置.魔门召唤单位ID[index];
  const 角度 = GetRandomReal(0, 360);
  const summon = 创建召唤物({
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型,
    单位名称: '冥神魔门召唤物',
    X: 极坐标X(状态.门X, 角度, 配置.召唤散开距离),
    Y: 极坐标Y(状态.门Y, 角度, 配置.召唤散开距离),
    朝向: 角度,
    持续时间: 配置.召唤物持续秒,
    索敌范围: 配置.召唤物索敌范围,
  });
  if (summon == null || summon === 0) {
    return;
  }
  状态.召唤组.登记(summon);
  状态.已召唤次数++;
}

function on魔门召唤周期(this: void, variable?: any): void {
  const 状态 = variable as 冥神魔门状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  创建魔门召唤物(状态);
  if (状态.已召唤次数 >= 教派学者技能配置.冥神魔门.召唤次数) {
    if (状态.召唤周期ID !== 0) {
      removePeriodicCallback(状态.召唤周期ID);
      状态.召唤周期ID = 0;
    }
    if (!状态.批次已结束) {
      状态.批次已结束 = true;
      状态.召唤组.结束批次();
    }
  }
}

function 查找魔门单位归属(this: void, unit: any): 魔门单位归属 | undefined {
  if (unit == null || unit === 0) return undefined;
  const unitHid = GetHandleId(unit);
  const 上下文列表 = 获取全部教派学者上下文();
  for (let i = 0; i < 上下文列表.length; i++) {
    const 状态 = 上下文列表[i].冥神魔门状态 as 冥神魔门状态 | undefined;
    if (状态 == null || 状态.已结束) continue;
    if (状态.门单位 != null && 状态.门单位 !== 0 && GetHandleId(状态.门单位) === unitHid) return { 状态, 类型: '门' };
    const 召唤物列表 = 状态.召唤组.取单位列表();
    for (let j = 0; j < 召唤物列表.length; j++) {
      if (GetHandleId(召唤物列表[j]) === unitHid) return { 状态, 类型: '召唤物' };
    }
  }
  return undefined;
}

function on魔门召唤普攻派生(this: void, variable?: any): void {
  const 快照 = variable as 魔门召唤普攻快照 | undefined;
  if (快照 == null || 快照.状态.已结束 || !教派学者单位存活(快照.状态.上下文.Boss单位) || !教派学者单位存活(快照.目标单位)) return;
  const boss = 快照.状态.上下文.Boss单位;
  const target = 快照.目标单位;
  const 配置 = 教派学者技能配置.冥神魔门;
  const 结果 = 执行Boss单体技能伤害({
    来源: boss,
    目标: target,
    技能ID: 冥神魔门技能ID,
    伤害公式: { 固定值: 快照.固定伤害 },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_MAGIC,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: 配置.召唤普攻标签,
    来源类型: '召唤物技能',
  });
  if (结果.是否造成伤害) {
    EC_CreateEffect(配置.召唤普攻命中特效路径, GetUnitX(target), GetUnitY(target), 0, 0, 配置.召唤普攻命中特效缩放, 1, 1);
    if (快照.召唤物类型ID === 地狱犬单位类型ID) {
      const 扣魔 = 配置.地狱犬扣魔基础值 + 配置.地狱犬每难度扣魔值 * 读取当前难度N();
      SetUnitState(target, UNIT_STATE_MANA, GetUnitState(target, UNIT_STATE_MANA) - 扣魔);
    } else if (快照.召唤物类型ID === 邪尸鬼单位类型ID) {
      施加魔门治疗压制(快照.状态, target);
    }
  }
}

function 魔门召唤物普攻替换修正(this: void, context: any): number {
  if (context == null || !(context.currentDamage > 0) || context.isNormalAttack !== true || context.isSkillAttack === true || context.isSkillDamage === true) return context?.currentDamage ?? 0;
  const 归属 = 查找魔门单位归属(context.attacker);
  if (归属 == null || 归属.类型 !== '召唤物') return context.currentDamage;
  const 快照: 魔门召唤普攻快照 = {
    状态: 归属.状态,
    召唤物: context.attacker,
    目标单位: context.target,
    固定伤害: 读取单位攻击力(context.attacker),
    召唤物类型ID: GetUnitTypeId(context.attacker),
  };
  const 回调ID = addDelayedCallback(0, on魔门召唤普攻派生, 快照);
  归属.状态.上下文.清理.登记延迟回调('教派学者-魔门召唤普攻派生', 回调ID);
  return 0;
}

function 魔门雷光克制承伤修正(this: void, context: any): number {
  if (context == null || context.target == null || context.target === 0 || (context.isThunderDamage !== true && context.isLightDamage !== true)) return context?.currentDamage ?? 0;
  const 归属 = 查找魔门单位归属(context.target);
  if (归属 == null) return context.currentDamage;
  const after = context.currentDamage * 教派学者技能配置.冥神魔门.雷光承伤倍率;
  return after;
}

function 启动冥神魔门机制(this: void, 上下文: 教派学者运行时上下文): boolean {
  const boss = 上下文?.Boss单位;
  if (!教派学者单位存活(boss) || 上下文.冥神魔门状态 != null || 上下文.魔门反噬生效) {
    return false;
  }
  const 配置 = 教派学者技能配置.冥神魔门;
  const 方向 = GetRandomReal(0, 360);
  const 距离 = GetRandomReal(配置.生成最小距离, 配置.生成最大距离);
  const 门X = 极坐标X(GetUnitX(boss), 方向, 距离);
  const 门Y = 极坐标Y(GetUnitY(boss), 方向, 距离);
  const 玩家数 = 取当前有效玩家人数();
  const 难度 = 读取当前难度N();
  const 生命比例 = 玩家数 <= 1 ? 配置.单人生命比例 : 配置.多人生命基础比例 + 配置.每难度生命比例 * 难度;
  const 召唤组 = 创建召唤物组状态({ 清理: 上下文.清理, 名称: '教派学者-冥神魔门召唤组' });
  const 状态: 冥神魔门状态 = { 已结束: false, 上下文, 门X, 门Y, 召唤组, 已召唤次数: 0, 批次已结束: false, 召唤周期ID: 0 };
  上下文.冥神魔门状态 = 状态;
  上下文.清理.登记清理('教派学者-冥神魔门清理', on冥神魔门清理, 状态);
  const 移除量 = 执行非伤害生命移除({
    目标: boss,
    数值: 读取单位最大生命(boss) * 配置.自损最大生命比例,
    不致死: false,
    显示文字: false,
    显示特效: false,
  });
  if (!教派学者单位存活(boss)) {
    结束冥神魔门(状态, '自损后死亡');
    return false;
  }
  状态.门实例 = 创建可攻击机制单位({
    清理: 上下文.清理,
    名称: '教派学者-冥神魔门',
    单位名称: '次元之门',
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    模型路径: 配置.模型路径,
    X: 门X,
    Y: 门Y,
    最大生命: 读取单位最大生命(boss) * 生命比例,
    护甲: 配置.护甲,
    固定站桩: true,
    禁止普攻: true,
    飞行高度: 配置.飞行高度,
    缩放: 配置.缩放,
    红: 配置.红,
    绿: 配置.绿,
    蓝: 配置.蓝,
    持续时间: 配置.持续秒,
    变量: 状态,
    on结束: on魔门机制结束,
  });
  if (状态.门实例 == null) {
    结束冥神魔门(状态, '次元之门创建失败');
    return false;
  }
  状态.门单位 = 状态.门实例.单位;
  设置单位实数属性(状态.门单位, '魔抗', 配置.魔抗);
  播放教派学者台词(状态.门单位, '冥神魔门');
  状态.召唤组.开始批次(配置.召唤次数);
  状态.召唤周期ID = addPeriodicCallback(配置.召唤间隔秒 * 1000, on魔门召唤周期, 状态);
  上下文.清理.登记周期回调('教派学者-冥神魔门召唤周期', 状态.召唤周期ID);
  return true;
}

function on冥神魔门延迟启动(this: void, variable?: any): void {
  const 请求 = variable as 魔门释放请求 | undefined;
  if (请求 != null) 启动冥神魔门机制(请求.上下文);
}

export function 释放教派学者冥神魔门(this: void, 上下文: 教派学者运行时上下文): boolean {
  if (!教派学者单位存活(上下文?.Boss单位) || 上下文.冥神魔门状态 != null || 上下文.魔门反噬生效) return false;
  开始冥神魔门施法表现(上下文);
  const 回调ID = addDelayedCallback(教派学者技能配置.公共施法.通魔施法秒 * 1000, on冥神魔门延迟启动, { 上下文 } as 魔门释放请求);
  上下文.清理.登记延迟回调('教派学者-冥神魔门显式释放', 回调ID);
  return true;
}

export function 注册教派学者冥神魔门(this: void): void {
  if (冥神魔门已注册) return;
  冥神魔门已注册 = true;
  注册单位技能壳监听({
    名称: '教派学者-冥神魔门',
    单位类型ID: 教派学者单位技能配置.单位ID,
    技能ID: 教派学者单位技能配置.技能壳.冥神魔门,
    获取或创建上下文: 获取或创建教派学者上下文,
    释放技能: function 教派学者冥神魔门技能壳释放(this: void, 上下文: 教派学者运行时上下文): void {
      释放教派学者冥神魔门(上下文);
    },
  });
  registerDamageModifier(魔门召唤物普攻替换修正, 教派学者技能配置.冥神魔门.普攻替换修正优先级);
  registerDamageModifier(魔门雷光克制承伤修正, 教派学者技能配置.冥神魔门.克制承伤修正优先级);
}
