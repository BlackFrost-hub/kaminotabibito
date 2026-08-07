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
const { 注册地精祭祀技能结构 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.07．技能入口') as {
  注册地精祭祀技能结构: (this: void) => void;
};
const { 获取或创建地精祭祀上下文, 清理地精祭祀上下文 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.01．运行时上下文') as {
  获取或创建地精祭祀上下文: (this: void, boss: any) => any;
  清理地精祭祀上下文: (this: void, boss: any) => void;
};
const { 释放地精祭祀破坏死光 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.04．破坏死光') as {
  释放地精祭祀破坏死光: (this: void, context: any, target: any) => boolean;
};
const { 释放地精祭祀血爆 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.05．血爆') as {
  释放地精祭祀血爆: (this: void, context: any, target: any) => boolean;
};
const { 释放地精祭祀毒蕴 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.06．毒蕴') as {
  释放地精祭祀毒蕴: (this: void, context: any) => boolean;
};
const { 注册Boss技能测试目标, 注销Boss技能测试目标 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  注册Boss技能测试目标: (this: void, unit: any) => void;
  注销Boss技能测试目标: (this: void, unit: any) => void;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 标记测试Boss跳过死亡结算 } = require('系统.12．测试系统.00．测试系统辅助函数') as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const { Boss测试单位存活, 获取Boss测试玩家基准英雄, 准备Boss测试固定步兵, 设置Boss测试单位满血, 移除Boss测试单位, 注册Boss测试命令组 } = require('系统.12．测试系统.00．Boss测试系统.index') as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  设置Boss测试单位满血: (this: void, unit: any, maxLife?: number) => void;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, config: any) => void;
};

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (playerId: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 地精祭祀单位ID = stringToFourCCSafe('N00C');
const 测试步兵单位ID = stringToFourCCSafe('hfoo');
const 测试中心X = -540.6;
const 测试中心Y = -2495.2;
const 中立敌对玩家ID = 12;
const 最近地精祭祀: Record<number, any> = {};
const 最近测试步兵: Record<number, any> = {};
const 最近测试步兵二: Record<number, any> = {};

interface 地精祭祀测试上下文 {
  Boss单位: any;
  玩家英雄: any;
  运行时: any;
  测试步兵一: any;
  测试步兵二: any;
}

interface 地精延迟测试数据 {
  上下文: 地精祭祀测试上下文;
  操作: '移开血爆目标' | '血爆结算检查' | '破坏死光结算检查' | '毒蕴结算检查';
}

function 登记地精延迟测试(this: void, context: 地精祭祀测试上下文, 操作: 地精延迟测试数据['操作'], delayMs: number): void {
  const callbackId = addDelayedCallback(delayMs, on地精延迟测试, { 上下文: context, 操作 } as 地精延迟测试数据);
  context.运行时?.清理?.登记延迟回调?.('地精祭祀测试-' + 操作, callbackId);
}

function 创建或获取地精祭祀测试上下文(this: void, player: any): 地精祭祀测试上下文 | undefined {
  const playerId = GetPlayerId(player);
  const 玩家英雄 = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(玩家英雄)) return undefined;
  注册地精祭祀技能结构();
  directRegisterPlayerHero(player, 玩家英雄);
  设置Boss测试单位满血(玩家英雄);
  SetUnitPosition(玩家英雄, 测试中心X, 测试中心Y - 420);
  SetUnitFacing(玩家英雄, 90);
  let boss = 最近地精祭祀[playerId];
  if (!Boss测试单位存活(boss)) {
    boss = CreateUnit(Player(中立敌对玩家ID), 地精祭祀单位ID, 测试中心X, 测试中心Y, 270);
    最近地精祭祀[playerId] = boss;
  }
  if (!Boss测试单位存活(boss)) return undefined;
  SetUnitPosition(boss, 测试中心X, 测试中心Y);
  SetUnitFacing(boss, 270);
  应用Boss战启动属性配置(boss);
  标记测试Boss跳过死亡结算(boss);
  最近测试步兵[playerId] = 准备Boss测试固定步兵(最近测试步兵[playerId], 测试中心X + 450, 测试中心Y, 90);
  let 第二步兵 = 最近测试步兵二[playerId];
  if (!Boss测试单位存活(第二步兵)) 第二步兵 = CreateUnit(Player(中立敌对玩家ID), 测试步兵单位ID, 测试中心X - 450, 测试中心Y, 90);
  最近测试步兵二[playerId] = 第二步兵;
  if (Boss测试单位存活(第二步兵)) {
    SetUnitPosition(第二步兵, 测试中心X - 450, 测试中心Y);
    SetUnitFacing(第二步兵, 90);
    设置Boss测试单位满血(第二步兵);
    注册Boss技能测试目标(第二步兵);
  }
  const 运行时 = 获取或创建地精祭祀上下文(boss);
  if (运行时 == null) return undefined;
  globals.udg_Boss = boss;
  return { Boss单位: boss, 玩家英雄, 运行时, 测试步兵一: 最近测试步兵[playerId], 测试步兵二: 第二步兵 };
}

function 清理地精祭祀测试上下文(this: void, player: any, context: 地精祭祀测试上下文): void {
  const playerId = GetPlayerId(player);
  if (Boss测试单位存活(context?.Boss单位)) 清理地精祭祀上下文(context.Boss单位);
  注销Boss技能测试目标(最近测试步兵二[playerId]);
  移除Boss测试单位(最近测试步兵[playerId]);
  移除Boss测试单位(最近测试步兵二[playerId]);
  移除Boss测试单位(最近地精祭祀[playerId]);
  最近测试步兵[playerId] = undefined;
  最近测试步兵二[playerId] = undefined;
  最近地精祭祀[playerId] = undefined;
  if (globals.udg_Boss === context?.Boss单位) globals.udg_Boss = null;
}

function 测试破坏死光(this: void, _player: any, context: 地精祭祀测试上下文): void {
  设置Boss测试单位满血(context.Boss单位, 100000);
  设置Boss测试单位满血(context.玩家英雄, 100000);
  const 是否开始 = 释放地精祭祀破坏死光(context.运行时, context.玩家英雄);
  if (是否开始) 登记地精延迟测试(context, '破坏死光结算检查', 1600);
}

function 测试血爆(this: void, _player: any, context: 地精祭祀测试上下文): void {
  设置Boss测试单位满血(context.Boss单位, 100000);
  设置Boss测试单位满血(context.玩家英雄, 100000);
  设置Boss测试单位满血(context.测试步兵二, 100000);
  SetUnitPosition(context.玩家英雄, 测试中心X, 测试中心Y - 420);
  SetUnitPosition(context.测试步兵二, 测试中心X + 150, 测试中心Y - 420);
  const 是否开始 = 释放地精祭祀血爆(context.运行时, context.玩家英雄);
  if (是否开始) 登记地精延迟测试(context, '血爆结算检查', 1500);
}

function 测试血爆预警后移位(this: void, _player: any, context: 地精祭祀测试上下文): void {
  设置Boss测试单位满血(context.Boss单位, 100000);
  设置Boss测试单位满血(context.玩家英雄, 100000);
  SetUnitPosition(context.玩家英雄, 测试中心X, 测试中心Y - 420);
  const 是否开始 = 释放地精祭祀血爆(context.运行时, context.玩家英雄);
  if (是否开始) {
    const callbackId = addDelayedCallback(200, on地精延迟测试, { 上下文: context, 操作: '移开血爆目标' } as 地精延迟测试数据);
    context.运行时?.清理?.登记延迟回调?.('地精祭祀测试-移开血爆目标', callbackId);
  }
}

function 测试毒蕴(this: void, _player: any, context: 地精祭祀测试上下文): void {
  设置Boss测试单位满血(context.Boss单位, 100000);
  设置Boss测试单位满血(context.玩家英雄, 100000);
  设置Boss测试单位满血(context.测试步兵二, 100000);
  设置Boss测试单位满血(最近测试步兵[GetPlayerId(_player)], 100000);
  SetUnitPosition(context.玩家英雄, 测试中心X, 测试中心Y - 420);
  SetUnitPosition(context.测试步兵二, 测试中心X - 450, 测试中心Y);
  SetUnitPosition(最近测试步兵[GetPlayerId(_player)], 测试中心X + 450, 测试中心Y);
  const 是否开始 = 释放地精祭祀毒蕴(context.运行时);
  if (是否开始) 登记地精延迟测试(context, '毒蕴结算检查', 1500);
}

function 测试受击召唤(this: void, _player: any, context: 地精祭祀测试上下文): void {
  设置Boss测试单位满血(context.Boss单位);
  UnitDamageTarget(context.玩家英雄, context.Boss单位, 1000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

function on地精延迟测试(this: void, variable?: any): void {
  const data = variable as 地精延迟测试数据 | undefined;
  if (data == null) return;
  if (data.操作 === '移开血爆目标') {
    SetUnitPosition(data.上下文.玩家英雄, 测试中心X + 1000, 测试中心Y + 1000);
    登记地精延迟测试(data.上下文, '血爆结算检查', 1200);
    return;
  }
}

const 地精祭祀测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 命令: '地精1', 名称: '破坏死光', 执行: 测试破坏死光 },
  { 序号: 2, 命令: '地精2', 名称: '血爆命中范围', 执行: 测试血爆 },
  { 序号: 2, 命令: '地精2-2', 名称: '血爆预警后移位', 执行: 测试血爆预警后移位 },
  { 序号: 3, 命令: '地精3', 名称: '毒蕴', 执行: 测试毒蕴 },
  { 序号: 4, 命令: '地精4', 名称: '受击召唤（真实伤害）', 执行: 测试受击召唤 },
];

注册Boss测试命令组({
  命令单位名: '地精祭祀',
  Boss名称: '地精祭祀',
  场地: { 正式中心: { x: 测试中心X, y: 测试中心Y }, 测试空地中心: { x: 测试中心X, y: 测试中心Y } },
  创建或获取上下文: 创建或获取地精祭祀测试上下文,
  清理上下文: 清理地精祭祀测试上下文,
  技能命令列表: 地精祭祀测试技能列表,
});
