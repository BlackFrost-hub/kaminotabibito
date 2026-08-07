/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require('jass.common') as any;
const globals = require('jass.globals') as { udg_Boss?: any; [key: string]: any };

const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { 应用Boss战启动属性配置 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用') as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { directRegisterPlayerHero } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接') as {
  directRegisterPlayerHero: (this: void, player: any, hero: any) => void;
};
const { 注册教派剑士技能结构 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.08．技能入口') as {
  注册教派剑士技能结构: (this: void) => void;
};
const { 获取或创建教派剑士上下文, 清理教派剑士上下文 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.01．运行时上下文') as {
  获取或创建教派剑士上下文: (this: void, boss: any) => any;
  清理教派剑士上下文: (this: void, boss: any) => void;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 施加快速控制Buff, 获取单位硬直剩余时间 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  施加快速控制Buff: (this: void, source: any, target: any, controlId: number, duration: number, sourceName?: string, sourceType?: string) => void;
  获取单位硬直剩余时间: (this: void, unit: any) => number;
};
const { 释放教派剑士深渊旋风 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.04．深渊旋风') as {
  释放教派剑士深渊旋风: (this: void, context: any) => boolean;
};
const { 释放教派剑士黑洞跨越 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.05．黑洞跨越') as {
  释放教派剑士黑洞跨越: (this: void, context: any) => boolean;
};
const { 释放教派剑士魔祭吸魂 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.06．魔祭吸魂') as {
  释放教派剑士魔祭吸魂: (this: void, context: any) => boolean;
};
const { 释放教派剑士深渊分身 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.12．教派剑士.07．深渊分身') as {
  释放教派剑士深渊分身: (this: void, context: any) => boolean;
};
const { 注册Boss技能测试目标, 注销Boss技能测试目标 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  注册Boss技能测试目标: (this: void, unit: any) => void;
  注销Boss技能测试目标: (this: void, unit: any) => void;
};
const { 标记测试Boss跳过死亡结算 } = require('系统.12．测试系统.00．测试系统辅助函数') as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const { Boss测试单位存活, 获取Boss测试玩家基准英雄, 设置Boss测试单位满血, 移除Boss测试单位, 注册Boss测试命令组 } = require('系统.12．测试系统.00．Boss测试系统.index') as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  设置Boss测试单位满血: (this: void, unit: any, maxLife?: number) => void;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, config: any) => void;
};
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (playerId: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const 教派剑士单位ID = stringToFourCCSafe('N05N');
const 测试中心X = -540.6;
const 测试中心Y = -2495.2;
const 中立敌对玩家ID = 12;
const 最近Boss: Record<number, any> = {};

interface 教派剑士测试上下文 {
  Boss单位: any;
  玩家英雄: any;
  运行时: any;
}

interface 教派剑士延迟测试数据 {
  上下文: 教派剑士测试上下文;
  操作: '黑洞摧毁' | '魔祭火光反噬' | '分身全灭' | '旋风打断' | '旋风打断检查' | '旋风结束检查' | '黑洞穿越结束检查' | '魔祭结算检查' | '分身自然结束检查';
}

function 重置教派剑士测试站位(this: void, context: 教派剑士测试上下文): void {
  SetUnitPosition(context.Boss单位, 测试中心X, 测试中心Y);
  SetUnitFacing(context.Boss单位, 270);
  SetUnitPosition(context.玩家英雄, 测试中心X - 450, 测试中心Y);
  SetUnitFacing(context.玩家英雄, 90);
  设置Boss测试单位满血(context.Boss单位, 100000);
  设置Boss测试单位满血(context.玩家英雄, 100000);
}

function 创建或获取教派剑士测试上下文(this: void, player: any): 教派剑士测试上下文 | undefined {
  const playerId = GetPlayerId(player);
  const 玩家英雄 = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(玩家英雄)) return undefined;
  注册教派剑士技能结构();
  directRegisterPlayerHero(player, 玩家英雄);
  注册Boss技能测试目标(玩家英雄);
  let boss = 最近Boss[playerId];
  if (!Boss测试单位存活(boss)) {
    boss = CreateUnit(Player(中立敌对玩家ID), 教派剑士单位ID, 测试中心X, 测试中心Y, 270);
    最近Boss[playerId] = boss;
  }
  if (!Boss测试单位存活(boss)) return undefined;
  应用Boss战启动属性配置(boss);
  标记测试Boss跳过死亡结算(boss);
  const 运行时 = 获取或创建教派剑士上下文(boss);
  if (运行时 == null) return undefined;
  const context: 教派剑士测试上下文 = { Boss单位: boss, 玩家英雄, 运行时 };
  重置教派剑士测试站位(context);
  globals.udg_Boss = boss;
  debugLogForce('教派剑士Boss技能测试', '中立敌对隔离测试场准备完成', 'playerId=', playerId, 'bossOwner=', 中立敌对玩家ID, 'bossHid=', GetHandleId(boss), 'targetHid=', GetHandleId(玩家英雄), 'passiveEnabled=', true);
  return context;
}

function 清理教派剑士测试上下文(this: void, player: any, context: 教派剑士测试上下文): void {
  const playerId = GetPlayerId(player);
  注销Boss技能测试目标(context?.玩家英雄);
  if (Boss测试单位存活(context?.Boss单位)) 清理教派剑士上下文(context.Boss单位);
  移除Boss测试单位(最近Boss[playerId]);
  最近Boss[playerId] = undefined;
  if (globals.udg_Boss === context?.Boss单位) globals.udg_Boss = null;
  debugLogForce('教派剑士Boss技能测试', '隔离测试场已清理', 'playerId=', playerId);
}

function 测试黑魔法侵蚀普攻(this: void, _player: any, context: 教派剑士测试上下文): void {
  重置教派剑士测试站位(context);
  const 是否造成伤害 = UnitDamageTarget(context.Boss单位, context.玩家英雄, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
  debugLogForce('教派剑士Boss技能测试', '真实普攻事件已提交，观察最大生命附加暗伤', 'damageStarted=', 是否造成伤害, 'bossHid=', GetHandleId(context.Boss单位), 'targetHid=', GetHandleId(context.玩家英雄));
}

function 测试黑魔法法术暴击(this: void, _player: any, context: 教派剑士测试上下文): void {
  重置教派剑士测试站位(context);
  let 已提交次数 = 0;
  for (let i = 0; i < 8; i++) {
    if (UnitDamageTarget(context.Boss单位, context.玩家英雄, 100, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)) 已提交次数++;
  }
  debugLogForce('教派剑士Boss技能测试', '连续提交八次暗魔法伤害，观察法术暴击日志', 'submitted=', 已提交次数);
}

function 测试深渊旋风(this: void, _player: any, context: 教派剑士测试上下文): void {
  重置教派剑士测试站位(context);
  const 是否开始 = 释放教派剑士深渊旋风(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(5000, on教派剑士延迟测试, { 上下文: context, 操作: '旋风结束检查' } as 教派剑士延迟测试数据);
    context.运行时.清理.登记延迟回调('教派剑士测试-旋风结束检查', callbackId);
  }
  debugLogForce('教派剑士Boss技能测试', '主动测试执行', 'skill=', '深渊旋风', 'started=', 是否开始);
}

function 测试深渊旋风打断(this: void, _player: any, context: 教派剑士测试上下文): void {
  重置教派剑士测试站位(context);
  const 是否开始 = 释放教派剑士深渊旋风(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(100, on教派剑士延迟测试, { 上下文: context, 操作: '旋风打断' } as 教派剑士延迟测试数据);
    context.运行时.清理.登记延迟回调('教派剑士测试-旋风打断', callbackId);
  }
  debugLogForce('教派剑士Boss技能测试', '深渊旋风受控打断测试', 'started=', 是否开始, 'expected=', '旋风状态存在时Boss受到硬控制，后续轮次停止');
}

function 测试黑洞跨越(this: void, _player: any, context: 教派剑士测试上下文): void {
  重置教派剑士测试站位(context);
  const 是否开始 = 释放教派剑士黑洞跨越(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(7000, on教派剑士延迟测试, { 上下文: context, 操作: '黑洞穿越结束检查' } as 教派剑士延迟测试数据);
    context.运行时.清理.登记延迟回调('教派剑士测试-黑洞穿越结束检查', callbackId);
  }
  debugLogForce('教派剑士Boss技能测试', '主动测试执行', 'skill=', '黑洞跨越', 'started=', 是否开始, 'expected=', 'Boss进入后在玩家身后出现并自动追击，最终状态清理');
}

function 测试黑洞摧毁(this: void, _player: any, context: 教派剑士测试上下文): void {
  重置教派剑士测试站位(context);
  const 是否开始 = 释放教派剑士黑洞跨越(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(4100, on教派剑士延迟测试, { 上下文: context, 操作: '黑洞摧毁' } as 教派剑士延迟测试数据);
    context.运行时.清理.登记延迟回调('教派剑士测试-黑洞摧毁', callbackId);
  }
  debugLogForce('教派剑士Boss技能测试', '施法硬直结束后攻击黑洞测试', 'started=', 是否开始, 'delayMs=', 4100, 'expected=', '黑洞真实创建后再攻击，触发摧毁爆炸、吸引与强化普攻窗口');
}

function 测试魔祭吸魂(this: void, _player: any, context: 教派剑士测试上下文): void {
  重置教派剑士测试站位(context);
  const 是否开始 = 释放教派剑士魔祭吸魂(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(4000, on教派剑士延迟测试, { 上下文: context, 操作: '魔祭结算检查' } as 教派剑士延迟测试数据);
    context.运行时.清理.登记延迟回调('教派剑士测试-魔祭结算检查', callbackId);
  }
  debugLogForce('教派剑士Boss技能测试', '主动测试执行', 'skill=', '魔祭吸魂', 'started=', 是否开始);
}

function 测试魔祭吸魂火光反噬(this: void, _player: any, context: 教派剑士测试上下文): void {
  重置教派剑士测试站位(context);
  const 是否开始 = 释放教派剑士魔祭吸魂(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(1400, on教派剑士延迟测试, { 上下文: context, 操作: '魔祭火光反噬' } as 教派剑士延迟测试数据);
    context.运行时.清理.登记延迟回调('教派剑士测试-魔祭火光反噬', callbackId);
  }
  debugLogForce('教派剑士Boss技能测试', '魔祭吸魂火属性反噬测试', 'started=', 是否开始, 'expected=', '进入2秒生效状态后提交火属性与光属性伤害，观察一次性反噬和无视韧性眩晕');
}

function 测试深渊分身(this: void, _player: any, context: 教派剑士测试上下文): void {
  重置教派剑士测试站位(context);
  const 是否开始 = 释放教派剑士深渊分身(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(5600, on教派剑士延迟测试, { 上下文: context, 操作: '分身自然结束检查' } as 教派剑士延迟测试数据);
    context.运行时.清理.登记延迟回调('教派剑士测试-分身自然结束检查', callbackId);
  }
  debugLogForce('教派剑士Boss技能测试', '主动测试执行', 'skill=', '深渊分身', 'started=', 是否开始);
}

function 测试深渊分身全灭(this: void, _player: any, context: 教派剑士测试上下文): void {
  重置教派剑士测试站位(context);
  const 是否开始 = 释放教派剑士深渊分身(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(700, on教派剑士延迟测试, { 上下文: context, 操作: '分身全灭' } as 教派剑士延迟测试数据);
    context.运行时.清理.登记延迟回调('教派剑士测试-分身全灭', callbackId);
  }
  debugLogForce('教派剑士Boss技能测试', '深渊分身玩家全灭测试', 'started=', 是否开始, 'expected=', '全部真实分身由玩家普攻摧毁，Boss返回起点并硬直2.5秒');
}

function on教派剑士延迟测试(this: void, variable?: any): void {
  const data = variable as 教派剑士延迟测试数据 | undefined;
  if (data == null) return;
  const context = data.上下文;
  if (data.操作 === '旋风结束检查') {
    debugLogForce('教派剑士Boss技能测试', '深渊旋风延迟结束检查', 'bossHid=', GetHandleId(context.Boss单位), 'bossLife=', GetUnitState(context.Boss单位, UNIT_STATE_LIFE), 'runtimeState=', context.运行时.旋风状态 != null ? '仍存在' : '已清理', 'expected=', '全部轮次结束后旋风状态、吟唱条和弹幕清理');
    return;
  }
  if (data.操作 === '魔祭结算检查') {
    debugLogForce('教派剑士Boss技能测试', '魔祭吸魂延迟结算检查', 'bossHid=', GetHandleId(context.Boss单位), 'bossLife=', GetUnitState(context.Boss单位, UNIT_STATE_LIFE), 'targetLife=', GetUnitState(context.玩家英雄, UNIT_STATE_LIFE), 'runtimeState=', context.运行时.魔祭状态 != null ? '仍存在' : '已清理', 'expected=', '1.9秒全体暗伤结算完成，2秒状态结束并清理');
    return;
  }
  if (data.操作 === '分身自然结束检查') {
    debugLogForce('教派剑士Boss技能测试', '深渊分身延迟结束检查', 'bossHid=', GetHandleId(context.Boss单位), 'bossLife=', GetUnitState(context.Boss单位, UNIT_STATE_LIFE), 'runtimeState=', context.运行时.分身状态 != null ? '仍存在' : '已清理', 'expected=', '5秒到期后分身组和状态清理，Boss恢复可行动');
    return;
  }
  if (data.操作 === '黑洞穿越结束检查') {
    debugLogForce('教派剑士Boss技能测试', '黑洞跨越延迟结束检查', 'bossHid=', GetHandleId(context.Boss单位), 'bossX=', GetUnitX(context.Boss单位), 'bossY=', GetUnitY(context.Boss单位), 'runtimeState=', context.运行时.黑洞状态 != null ? '仍存在' : '已清理', 'expected=', '入口/出口和强化普攻窗口按成功或失败原因清理');
    return;
  }
  if (data.操作 === '旋风打断') {
    施加快速控制Buff(context.玩家英雄, context.Boss单位, 0, 1, '教派剑士测试-旋风打断', '测试');
    debugLogForce('教派剑士Boss技能测试', '已向旋风中的Boss施加硬控制', 'bossHid=', GetHandleId(context.Boss单位), 'targetHid=', GetHandleId(context.玩家英雄));
    const callbackId = addDelayedCallback(350, on教派剑士延迟测试, { 上下文: context, 操作: '旋风打断检查' } as 教派剑士延迟测试数据);
    context.运行时.清理.登记延迟回调('教派剑士测试-旋风打断检查', callbackId);
    return;
  }
  if (data.操作 === '旋风打断检查') {
    const hardStunRemaining = 获取单位硬直剩余时间(context.Boss单位);
    debugLogForce('教派剑士Boss技能测试', '深渊旋风打断后硬直检查', 'bossHid=', GetHandleId(context.Boss单位), 'hardStunRemaining=', hardStunRemaining, 'runtimeState=', context.运行时.旋风状态 != null ? '仍存在' : '已清理', 'expected=', '施法硬直剩余0且旋风状态已清理；外部硬控制独立按自身持续时间结束');
    return;
  }
  if (data.操作 === '黑洞摧毁') {
    const 状态 = context.运行时.黑洞状态;
    const 黑洞 = 状态?.黑洞实例?.单位 ?? 状态?.黑洞单位;
    let submitted = 0;
    if (黑洞 != null && 黑洞 !== 0) {
      for (let i = 0; i < 8; i++) {
        if (UnitDamageTarget(context.玩家英雄, 黑洞, 100000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)) submitted++;
      }
    }
    debugLogForce('教派剑士Boss技能测试', '黑洞真实攻击已提交', 'blackHoleHid=', 黑洞 != null && 黑洞 !== 0 ? GetHandleId(黑洞) : 0, 'submitted=', submitted, 'expected=', '黑洞被摧毁后触发爆炸与清理');
    return;
  }
  if (data.操作 === '魔祭火光反噬') {
    const fire = UnitDamageTarget(context.玩家英雄, context.Boss单位, 1, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS);
    const light = UnitDamageTarget(context.玩家英雄, context.Boss单位, 1, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_DIVINE, WEAPON_TYPE_WHOKNOWS);
    debugLogForce('教派剑士Boss技能测试', '魔祭火光伤害已提交', 'bossHid=', GetHandleId(context.Boss单位), 'fireStarted=', fire, 'lightStarted=', light, 'expected=', '首个火/光伤害触发反噬，第二个伤害记录为状态结束后的对照');
    return;
  }
  const 状态 = context.运行时.分身状态;
  const 分身列表 = 状态?.召唤组?.取单位列表?.() ?? [];
  let submitted = 0;
  for (let i = 0; i < 分身列表.length; i++) {
    for (let hit = 0; hit < 2; hit++) {
      if (UnitDamageTarget(context.玩家英雄, 分身列表[i], 100000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)) submitted++;
    }
  }
  debugLogForce('教派剑士Boss技能测试', '分身真实普攻已提交', 'cloneCount=', 分身列表.length, 'submitted=', submitted, 'expected=', '每个分身两次纯普攻击破并触发死亡爆炸');
}

const 教派剑士测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 命令: '剑士1', 名称: '黑魔法侵蚀普攻', 执行: 测试黑魔法侵蚀普攻 },//测试完毕
  { 序号: 2, 命令: '剑士2', 名称: '黑魔法法术暴击', 执行: 测试黑魔法法术暴击 },//测试完毕
  { 序号: 3, 命令: '剑士3', 名称: '深渊旋风', 执行: 测试深渊旋风 },//测试完毕√
  { 序号: 3, 命令: '剑士3-2', 名称: '深渊旋风受控打断', 执行: 测试深渊旋风打断 },
  { 序号: 4, 命令: '剑士4', 名称: '黑洞跨越', 执行: 测试黑洞跨越 },
  { 序号: 4, 命令: '剑士4-2', 名称: '黑洞摧毁', 执行: 测试黑洞摧毁 },
  { 序号: 5, 命令: '剑士5', 名称: '魔祭吸魂', 执行: 测试魔祭吸魂 },
  { 序号: 5, 命令: '剑士5-2', 名称: '魔祭火光反噬', 执行: 测试魔祭吸魂火光反噬 },
  { 序号: 6, 命令: '剑士6', 名称: '深渊分身', 执行: 测试深渊分身 },
  { 序号: 6, 命令: '剑士6-2', 名称: '深渊分身全灭', 执行: 测试深渊分身全灭 },
];

注册Boss测试命令组({
  命令单位名: '教派剑士',
  Boss名称: '蒙面人（剑士姿态）',
  场地: { 正式中心: { x: 测试中心X, y: 测试中心Y }, 测试空地中心: { x: 测试中心X, y: 测试中心Y } },
  创建或获取上下文: 创建或获取教派剑士测试上下文,
  清理上下文: 清理教派剑士测试上下文,
  技能命令列表: 教派剑士测试技能列表,
});

debugLogForce('教派剑士Boss技能测试', '隔离测试命令组注册完成', 'commandCount=', 教派剑士测试技能列表.length);

export {};
