/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';
import type { 冥之念类型 } from '../../../03．技能系统/05．单位技能/03．Boss技能/01．主线Boss/13．教派学者/06．冥之念欲';

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
const { 注册教派学者技能结构 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.08．技能入口') as {
  注册教派学者技能结构: (this: void) => void;
};
const { 获取或创建教派学者上下文, 清理教派学者上下文 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.01．运行时上下文') as {
  获取或创建教派学者上下文: (this: void, boss: any) => any;
  清理教派学者上下文: (this: void, boss: any) => void;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 释放教派学者深渊之牢 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.04．深渊之牢') as {
  释放教派学者深渊之牢: (this: void, context: any, target: any) => boolean;
};
const { 释放教派学者冥神魔门 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.05．冥神魔门') as {
  释放教派学者冥神魔门: (this: void, context: any) => boolean;
};
const { 释放教派学者冥之念欲 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.06．冥之念欲') as {
  释放教派学者冥之念欲: (this: void, context: any, 指定类型?: 冥之念类型) => boolean;
};
const { 释放教派学者邪狱追魂冥法 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.07．邪狱追魂冥法') as {
  释放教派学者邪狱追魂冥法: (this: void, context: any) => boolean;
};
const { 创建教派学者暗影弹幕 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.03．暗影索命') as {
  创建教派学者暗影弹幕: (this: void, context: any, 角度: number, 缩放: number, 发射来源: '普通攻击' | '邪狱追魂冥法') => number;
};
const { 教派学者技能配置 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.02．数值与表现配置') as {
  教派学者技能配置: { 暗影索命: { 普攻弹幕缩放: number } };
};
const { 获取原生弹幕 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index') as {
  获取原生弹幕: (this: void, 弹幕ID: number) => any;
};
const { 读取单位攻击力 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具') as {
  读取单位攻击力: (this: void, unit: any) => number;
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

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (playerId: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;

const 教派学者单位ID = stringToFourCCSafe('N05M');
const 测试中心X = -540.6;
const 测试中心Y = -2495.2;
const 中立敌对玩家ID = 12;
const 最近Boss: Record<number, any> = {};

interface 教派学者测试上下文 {
  Boss单位: any;
  玩家英雄: any;
  运行时: any;
}

interface 教派学者邪狱追魂测试锁链 {
  机制实例?: { 单位?: any };
}

interface 教派学者邪狱追魂测试状态 {
  锁链列表?: 教派学者邪狱追魂测试锁链[];
  已发射弹幕?: boolean;
}

interface 教派学者暗影索命恢复测试数据 {
  上下文: 教派学者测试上下文;
  弹幕ID: number;
  载体单位: any;
  攻击力: number;
  生命值前: number;
  魔法值前: number;
  原始生命恢复: number;
  原始魔法恢复: number;
}

interface 教派学者延迟测试数据 {
  上下文: 教派学者测试上下文;
  操作:
    | '深渊之牢安全检查'
    | '深渊之牢离开'
    | '冥神魔门创建检查'
    | '冥神魔门摧毁'
    | '冥念随机结束检查'
    | '邪狱锁链击破'
    | '冥念违规位置'
    | '冥念引安全'
    | '冥念引违规'
    | '冥念退安全'
    | '冥念退违规'
    | '冥念赶安全'
    | '冥念赶违规'
    | '邪狱追魂状态检查';
}

function 重置教派学者测试站位(this: void, context: 教派学者测试上下文): void {
  SetUnitPosition(context.Boss单位, 测试中心X, 测试中心Y);
  SetUnitFacing(context.Boss单位, 270);
  SetUnitPosition(context.玩家英雄, 测试中心X - 450, 测试中心Y);
  SetUnitFacing(context.玩家英雄, 90);
  设置Boss测试单位满血(context.Boss单位, 100000);
  设置Boss测试单位满血(context.玩家英雄, 100000);
}

function 创建或获取教派学者测试上下文(this: void, player: any): 教派学者测试上下文 | undefined {
  const playerId = GetPlayerId(player);
  const 玩家英雄 = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(玩家英雄)) return undefined;
  注册教派学者技能结构();
  directRegisterPlayerHero(player, 玩家英雄);
  注册Boss技能测试目标(玩家英雄);
  let boss = 最近Boss[playerId];
  if (!Boss测试单位存活(boss)) {
    boss = CreateUnit(Player(中立敌对玩家ID), 教派学者单位ID, 测试中心X, 测试中心Y, 270);
    最近Boss[playerId] = boss;
  }
  if (!Boss测试单位存活(boss)) return undefined;
  应用Boss战启动属性配置(boss);
  标记测试Boss跳过死亡结算(boss);
  const 运行时 = 获取或创建教派学者上下文(boss);
  if (运行时 == null) return undefined;
  const context: 教派学者测试上下文 = { Boss单位: boss, 玩家英雄, 运行时 };
  重置教派学者测试站位(context);
  globals.udg_Boss = boss;
  return context;
}

function 清理教派学者测试上下文(this: void, player: any, context: 教派学者测试上下文): void {
  const playerId = GetPlayerId(player);
  注销Boss技能测试目标(context?.玩家英雄);
  if (Boss测试单位存活(context?.Boss单位)) 清理教派学者上下文(context.Boss单位);
  移除Boss测试单位(最近Boss[playerId]);
  最近Boss[playerId] = undefined;
  if (globals.udg_Boss === context?.Boss单位) globals.udg_Boss = null;
}

function 测试暗影索命被动(this: void, _player: any, context: 教派学者测试上下文): void {
  重置教派学者测试站位(context);
  const 是否造成伤害 = UnitDamageTarget(context.Boss单位, context.玩家英雄, 200, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

function 测试暗影索命击落恢复(this: void, _player: any, context: 教派学者测试上下文): void {
  重置教派学者测试站位(context);
  const 玩家英雄 = context.玩家英雄;
  const 攻击力 = 读取单位攻击力(玩家英雄);
  const 最大生命值 = GetUnitState(玩家英雄, UNIT_STATE_MAX_LIFE);
  const 最大魔法值 = GetUnitState(玩家英雄, UNIT_STATE_MAX_MANA);
  const 原始生命恢复 = 攻击力 * 0.5;
  const 原始魔法恢复 = 攻击力 * 0.25;
  const 生命值前 = 最大生命值 > 原始生命恢复 ? 最大生命值 - 原始生命恢复 : 最大生命值 * 0.5;
  const 魔法值前 = 最大魔法值 > 原始魔法恢复 ? 最大魔法值 - 原始魔法恢复 : 最大魔法值 * 0.5;
  SetUnitState(玩家英雄, UNIT_STATE_LIFE, 生命值前);
  SetUnitState(玩家英雄, UNIT_STATE_MANA, 魔法值前);

  const 弹幕ID = 创建教派学者暗影弹幕(context.运行时, 0, 教派学者技能配置.暗影索命.普攻弹幕缩放, '普通攻击');
  const 实例 = 弹幕ID > 0 ? 获取原生弹幕(弹幕ID) : undefined;
  const 载体单位 = 实例 != null ? 实例.弹幕单位 : undefined;
  if (载体单位 == null || 载体单位 === 0) {
    return;
  }

  const callbackId = addDelayedCallback(100, on教派学者暗影索命击落恢复检查, {
    上下文: context,
    弹幕ID,
    载体单位,
    攻击力,
    生命值前,
    魔法值前,
    原始生命恢复,
    原始魔法恢复,
  } as 教派学者暗影索命恢复测试数据);
  context.运行时.清理.登记延迟回调('教派学者测试-暗影索命击落恢复检查', callbackId);
  const submitted = UnitDamageTarget(玩家英雄, 载体单位, 100000000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

function 测试深渊之牢(this: void, _player: any, context: 教派学者测试上下文): void {
  重置教派学者测试站位(context);
  const 是否开始 = 释放教派学者深渊之牢(context.运行时, context.玩家英雄);
  if (是否开始) {
    const callbackId = addDelayedCallback(1900, on教派学者延迟测试, { 上下文: context, 操作: '深渊之牢安全检查' } as 教派学者延迟测试数据);
    context.运行时.清理.登记延迟回调('教派学者测试-深渊之牢安全检查', callbackId);
  }
}

function 测试深渊之牢离开(this: void, _player: any, context: 教派学者测试上下文): void {
  重置教派学者测试站位(context);
  const 是否开始 = 释放教派学者深渊之牢(context.运行时, context.玩家英雄);
  if (是否开始) {
    const callbackId = addDelayedCallback(500, on教派学者延迟测试, { 上下文: context, 操作: '深渊之牢离开' } as 教派学者延迟测试数据);
    context.运行时.清理.登记延迟回调('教派学者测试-深渊之牢离开', callbackId);
  }
}

function 测试冥神魔门(this: void, _player: any, context: 教派学者测试上下文): void {
  重置教派学者测试站位(context);
  const 是否开始 = 释放教派学者冥神魔门(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(1500, on教派学者延迟测试, { 上下文: context, 操作: '冥神魔门创建检查' } as 教派学者延迟测试数据);
    context.运行时.清理.登记延迟回调('教派学者测试-冥神魔门创建检查', callbackId);
  }
}

function 测试冥神魔门摧毁(this: void, _player: any, context: 教派学者测试上下文): void {
  重置教派学者测试站位(context);
  const 是否开始 = 释放教派学者冥神魔门(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(700, on教派学者延迟测试, { 上下文: context, 操作: '冥神魔门摧毁' } as 教派学者延迟测试数据);
    context.运行时.清理.登记延迟回调('教派学者测试-冥神魔门摧毁', callbackId);
  }
}

function 测试冥之念欲(this: void, _player: any, context: 教派学者测试上下文): void {
  重置教派学者测试站位(context);
  const 是否开始 = 释放教派学者冥之念欲(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(3000, on教派学者延迟测试, { 上下文: context, 操作: '冥念随机结束检查' } as 教派学者延迟测试数据);
    context.运行时.清理.登记延迟回调('教派学者测试-冥念随机结束检查', callbackId);
  }
}

function 测试冥之念欲违规位置(this: void, _player: any, context: 教派学者测试上下文): void {
  重置教派学者测试站位(context);
  const 是否开始 = 释放教派学者冥之念欲(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(500, on教派学者延迟测试, { 上下文: context, 操作: '冥念违规位置' } as 教派学者延迟测试数据);
    context.运行时.清理.登记延迟回调('教派学者测试-冥念违规位置', callbackId);
  }
}

function 测试指定冥之念(this: void, _player: any, context: 教派学者测试上下文, 类型: 冥之念类型, 是否测试安全位置: boolean): void {
  重置教派学者测试站位(context);
  const 是否开始 = 释放教派学者冥之念欲(context.运行时, 类型);
  const 操作 = 类型 === '念引'
    ? 是否测试安全位置 ? '冥念引安全' : '冥念引违规'
    : 类型 === '念退'
      ? 是否测试安全位置 ? '冥念退安全' : '冥念退违规'
      : 是否测试安全位置 ? '冥念赶安全' : '冥念赶违规';
  if (是否开始) {
    const callbackId = addDelayedCallback(500, on教派学者延迟测试, { 上下文: context, 操作 } as 教派学者延迟测试数据);
    context.运行时.清理.登记延迟回调('教派学者测试-' + 操作, callbackId);
  }
}

function 测试冥之念引安全(this: void, player: any, context: 教派学者测试上下文): void {
  测试指定冥之念(player, context, '念引', true);
}

function 测试冥之念引违规(this: void, player: any, context: 教派学者测试上下文): void {
  测试指定冥之念(player, context, '念引', false);
}

function 测试冥之念退安全(this: void, player: any, context: 教派学者测试上下文): void {
  测试指定冥之念(player, context, '念退', true);
}

function 测试冥之念退违规(this: void, player: any, context: 教派学者测试上下文): void {
  测试指定冥之念(player, context, '念退', false);
}

function 测试冥之念赶安全(this: void, player: any, context: 教派学者测试上下文): void {
  测试指定冥之念(player, context, '念赶', true);
}

function 测试冥之念赶违规(this: void, player: any, context: 教派学者测试上下文): void {
  测试指定冥之念(player, context, '念赶', false);
}

function 测试邪狱追魂冥法(this: void, _player: any, context: 教派学者测试上下文): void {
  重置教派学者测试站位(context);
  const 是否开始 = 释放教派学者邪狱追魂冥法(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(1300, on教派学者延迟测试, { 上下文: context, 操作: '邪狱追魂状态检查' } as 教派学者延迟测试数据);
    context.运行时.清理.登记延迟回调('教派学者测试-邪狱追魂状态检查', callbackId);
  }
}

function 测试邪狱锁链击破(this: void, _player: any, context: 教派学者测试上下文): void {
  重置教派学者测试站位(context);
  const 是否开始 = 释放教派学者邪狱追魂冥法(context.运行时);
  if (是否开始) {
    const callbackId = addDelayedCallback(700, on教派学者延迟测试, { 上下文: context, 操作: '邪狱锁链击破' } as 教派学者延迟测试数据);
    context.运行时.清理.登记延迟回调('教派学者测试-邪狱锁链击破', callbackId);
  }
}

function on教派学者暗影索命击落恢复检查(this: void, variable?: any): void {
  const data = variable as 教派学者暗影索命恢复测试数据 | undefined;
  if (data == null) return;
  const 玩家英雄 = data.上下文.玩家英雄;
  const 当前生命值 = GetUnitState(玩家英雄, UNIT_STATE_LIFE);
  const 当前魔法值 = GetUnitState(玩家英雄, UNIT_STATE_MANA);
}

function on教派学者延迟测试(this: void, variable?: any): void {
  const data = variable as 教派学者延迟测试数据 | undefined;
  if (data == null) return;
  const context = data.上下文;
  if (data.操作 === '深渊之牢安全检查') {
    return;
  }
  if (data.操作 === '冥神魔门创建检查') {
    const 状态 = context.运行时.冥神魔门状态;
    const 门 = 状态?.门实例?.单位 ?? 状态?.门单位;
    return;
  }
  if (data.操作 === '邪狱追魂状态检查') {
    const 状态 = context.运行时.邪狱追魂状态 as 教派学者邪狱追魂测试状态 | undefined;
    const 锁链数量 = 状态 != null && 状态.锁链列表 != null ? 状态.锁链列表.length : -1;
    const 已发射弹幕 = 状态 != null && 状态.已发射弹幕 === true;
    return;
  }
  if (data.操作 === '冥念随机结束检查') {
    const 状态 = context.运行时.冥之念欲状态;
    return;
  }
  if (data.操作 === '深渊之牢离开') {
    SetUnitPosition(context.玩家英雄, 测试中心X + 900, 测试中心Y + 900);
    return;
  }
  if (data.操作 === '冥神魔门摧毁') {
    const 状态 = context.运行时.冥神魔门状态;
    const 门 = 状态?.门实例?.单位 ?? 状态?.门单位;
    let submitted = 0;
    if (门 != null && 门 !== 0) {
      for (let i = 0; i < 8; i++) {
        if (UnitDamageTarget(context.玩家英雄, 门, 100000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)) submitted++;
      }
    }
    return;
  }
  if (data.操作 === '冥念违规位置') {
    SetUnitPosition(context.玩家英雄, 测试中心X + 1400, 测试中心Y + 1400);
    return;
  }
  if (data.操作 === '冥念引安全' || data.操作 === '冥念引违规' || data.操作 === '冥念退安全' || data.操作 === '冥念退违规') {
    const 是否安全 = data.操作 === '冥念引安全' || data.操作 === '冥念退安全';
    const 是否念引 = data.操作 === '冥念引安全' || data.操作 === '冥念引违规';
    const 距离 = 是否念引 === 是否安全 ? 100 : 900;
    SetUnitPosition(context.玩家英雄, 测试中心X + 距离, 测试中心Y);
    return;
  }
  if (data.操作 === '冥念赶安全' || data.操作 === '冥念赶违规') {
    const 状态 = context.运行时.冥之念欲状态;
    const 安全点 = 状态?.安全点列表?.[0];
    const 是否安全 = data.操作 === '冥念赶安全';
    if (是否安全 && 安全点 != null) {
      SetUnitPosition(context.玩家英雄, 安全点.X, 安全点.Y);
    } else {
      SetUnitPosition(context.玩家英雄, 测试中心X, 测试中心Y);
    }
    return;
  }
  const 状态 = context.运行时.邪狱追魂状态 as 教派学者邪狱追魂测试状态 | undefined;
  const 锁链列表 = 状态 != null && 状态.锁链列表 != null ? 状态.锁链列表 : [];
  let submitted = 0;
  for (let i = 0; i < 锁链列表.length; i++) {
    const 锁链 = 锁链列表[i];
    const 机制实例 = 锁链 != null ? 锁链.机制实例 : undefined;
    const 锁链单位 = 机制实例 != null ? 机制实例.单位 : undefined;
    if (锁链单位 == null || 锁链单位 === 0) continue;
    for (let hit = 0; hit < 2; hit++) {
      if (UnitDamageTarget(context.玩家英雄, 锁链单位, 100000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)) submitted++;
    }
  }
}

const 教派学者测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 命令: '学者1', 名称: '暗影索命真实普攻', 执行: 测试暗影索命被动 },//测试完毕
  { 序号: 1, 命令: '学者1-2', 名称: '暗影弹幕击落恢复', 执行: 测试暗影索命击落恢复 },
  { 序号: 2, 命令: '学者2', 名称: '深渊之牢', 执行: 测试深渊之牢 },//测试完毕
  { 序号: 2, 命令: '学者2-2', 名称: '深渊之牢离开分支', 执行: 测试深渊之牢离开 },//测试完毕 
  { 序号: 3, 命令: '学者3', 名称: '冥神魔门', 执行: 测试冥神魔门 },
  { 序号: 3, 命令: '学者3-2', 名称: '冥神魔门摧毁', 执行: 测试冥神魔门摧毁 },//测试完毕
  { 序号: 4, 命令: '学者4', 名称: '冥之念欲', 执行: 测试冥之念欲 },
  { 序号: 4, 命令: '学者4-2', 名称: '冥之念欲违规位置', 执行: 测试冥之念欲违规位置 },
  { 序号: 4, 命令: '学者4-3', 名称: '冥之念引安全', 执行: 测试冥之念引安全 },
  { 序号: 4, 命令: '学者4-4', 名称: '冥之念引违规', 执行: 测试冥之念引违规 },
  { 序号: 4, 命令: '学者4-5', 名称: '冥之念退安全', 执行: 测试冥之念退安全 },
  { 序号: 4, 命令: '学者4-6', 名称: '冥之念退违规', 执行: 测试冥之念退违规 },
  { 序号: 4, 命令: '学者4-7', 名称: '冥之念赶安全', 执行: 测试冥之念赶安全 },
  { 序号: 4, 命令: '学者4-8', 名称: '冥之念赶违规', 执行: 测试冥之念赶违规 },
  { 序号: 5, 命令: '学者5', 名称: '邪狱追魂冥法', 执行: 测试邪狱追魂冥法 },
  { 序号: 5, 命令: '学者5-2', 名称: '邪狱锁链击破', 执行: 测试邪狱锁链击破 },
];

注册Boss测试命令组({
  命令单位名: '教派学者',
  Boss名称: '蒙面人（学者姿态）',
  场地: { 正式中心: { x: 测试中心X, y: 测试中心Y }, 测试空地中心: { x: 测试中心X, y: 测试中心Y } },
  创建或获取上下文: 创建或获取教派学者测试上下文,
  清理上下文: 清理教派学者测试上下文,
  技能命令列表: 教派学者测试技能列表,
});


export {};
