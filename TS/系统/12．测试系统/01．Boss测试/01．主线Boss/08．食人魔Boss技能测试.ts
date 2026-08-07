/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const globals = require('jass.globals') as { udg_Boss?: any; [key: string]: any };

const { SelectUnitForPlayerSingle } = require('lib.扩展函数.BJ函数.index') as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require('lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数') as {
  StarOther_PanCameraToTimedForPlayer: (this: void, player: any, x: number, y: number, duration: number) => void;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { 应用Boss战启动属性配置 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用') as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 注册沙漠食人魔技能结构 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.07．技能入口') as {
  注册沙漠食人魔技能结构: (this: void) => void;
};
const { 释放沙漠食人魔咒 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.03．食人魔咒') as {
  释放沙漠食人魔咒: (this: void, boss: any) => boolean;
};
const { 释放沙漠食人魔风暴之锤 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.04．风暴之锤') as {
  释放沙漠食人魔风暴之锤: (this: void, boss: any) => boolean;
};
const { 释放沙漠食人魔雷霆敲打 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.05．雷霆敲打') as {
  释放沙漠食人魔雷霆敲打: (this: void, boss: any) => boolean;
};
const { 释放沙漠食人魔雷霆震怒 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.06．雷霆震怒') as {
  释放沙漠食人魔雷霆震怒: (this: void, boss: any) => boolean;
};
const { 沙漠食人魔技能配置 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.02．数值与表现配置') as {
  沙漠食人魔技能配置: { 雷霆敲打: { 轮数: number; 轮次间隔秒: number; 预警秒: number; 弹幕持续秒: number } };
};
const { 注册杀戮食人魔技能结构 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.08．技能入口') as {
  注册杀戮食人魔技能结构: (this: void) => void;
};
const { 获取或创建杀戮食人魔上下文, 清理杀戮食人魔上下文 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.01．运行时上下文') as {
  获取或创建杀戮食人魔上下文: (this: void, boss: any) => any;
  清理杀戮食人魔上下文: (this: void, boss: any) => void;
};
const { 释放杀戮食人魔深渊魔咒 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.04．深渊魔咒') as {
  释放杀戮食人魔深渊魔咒: (this: void, context: any) => boolean;
};
const { 释放杀戮食人魔血海绞杀 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.05．血海绞杀') as {
  释放杀戮食人魔血海绞杀: (this: void, context: any) => boolean;
};
const { 释放杀戮食人魔痛之束缚 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.06．痛之束缚') as {
  释放杀戮食人魔痛之束缚: (this: void, context: any) => boolean;
};
const { 释放杀戮食人魔雷霆震怒 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.07．雷霆震怒') as {
  释放杀戮食人魔雷霆震怒: (this: void, context: any) => boolean;
};
const { 标记测试Boss跳过死亡结算 } = require('系统.12．测试系统.00．测试系统辅助函数') as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const { 注册Boss技能测试目标, 注销Boss技能测试目标 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  注册Boss技能测试目标: (this: void, unit: any) => void;
  注销Boss技能测试目标: (this: void, unit: any) => void;
};
const { addDelayedCallback, getGameDifficulty } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  getGameDifficulty: (this: void) => number;
};
const { spellHeal } = require('系统.04．伤害系统.02．治疗系统.01．核心功能') as {
  spellHeal: (this: void, source: any, target: any, amount: number, showEffect?: boolean) => number;
};
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 单位是否无敌安全 } = require('lib.扩展函数.自定义扩展函数.06．单位状态安全包装') as {
  单位是否无敌安全: (this: void, unit: any) => boolean;
};
const {
  Boss测试单位存活,
  获取Boss测试玩家基准英雄,
  准备Boss测试固定步兵,
  准备Boss测试固定山丘之王,
  设置Boss测试单位满血,
  移除Boss测试单位,
  注册Boss测试命令组,
} = require('系统.12．测试系统.00．Boss测试系统.index') as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  准备Boss测试固定山丘之王: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  设置Boss测试单位满血: (this: void, unit: any, maxLife?: number) => void;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, config: any) => void;
};

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const UnitAddAbility = jass.UnitAddAbility as (unit: any, abilityId: number) => boolean;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const IssueImmediateOrder = jass.IssueImmediateOrder as (unit: any, order: string) => boolean;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitStateJapi = japi.SetUnitState as (unit: any, state: any, value: number) => void;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 沙漠食人魔单位ID = stringToFourCCSafe('N05J');
const 杀戮食人魔单位ID = stringToFourCCSafe('N05K');
const 测试圣骑士单位ID = stringToFourCCSafe('Hpal');
const 雷霆一击技能ID = stringToFourCCSafe('AHtc');
const 测试英雄最大魔法值 = 999999;
const 测试中心X = -540.6;
const 测试中心Y = -2495.2;

function 取句柄ID(this: void, handle: any): number {
  return handle != null && handle !== 0 ? GetHandleId(handle) : 0;
}

function 确保测试英雄学会雷霆一击(this: void, unit: any): boolean {
  if (!Boss测试单位存活(unit)) return false;
  let abilityLevel = GetUnitAbilityLevel(unit, 雷霆一击技能ID);
  if (!(abilityLevel > 0)) {
    UnitAddAbility(unit, 雷霆一击技能ID);
    abilityLevel = GetUnitAbilityLevel(unit, 雷霆一击技能ID);
  }
  return abilityLevel > 0;
}

function 补充测试英雄魔法(this: void, unit: any): void {
  if (!Boss测试单位存活(unit)) return;
  SetUnitStateJapi(unit, UNIT_STATE_MAX_MANA, 测试英雄最大魔法值);
  SetUnitState(unit, UNIT_STATE_MANA, 测试英雄最大魔法值);
}

interface 食人魔测试上下文 {
  Boss单位: any;
  沙漠食人魔: any;
  杀戮食人魔: any;
  杀戮运行时: any;
  玩家英雄: any;
  测试山丘之王: any;
  测试圣骑士: any;
}

const 最近沙漠食人魔: Record<number, any> = {};
const 最近杀戮食人魔: Record<number, any> = {};
const 最近测试步兵一: Record<number, any> = {};
const 最近测试步兵二: Record<number, any> = {};
const 最近测试山丘之王: Record<number, any> = {};
const 最近测试圣骑士: Record<number, any> = {};

interface 食人魔延迟测试数据 {
  上下文: 食人魔测试上下文;
  形态: '沙漠' | '杀戮';
  操作: '施法' | '治疗反噬' | '转移伤害' | '断链' | '啃食完成检查' | '风暴之锤结束检查' | '雷霆敲打结束检查' | '血海绞杀结束检查';
}

function 恢复Boss位置与生命(this: void, boss: any, x: number): void {
  if (!Boss测试单位存活(boss)) return;
  SetUnitPosition(boss, x, 测试中心Y);
  SetUnitFacing(boss, 270);
  SetUnitState(boss, UNIT_STATE_LIFE, GetUnitState(boss, UNIT_STATE_MAX_LIFE));
  标记测试Boss跳过死亡结算(boss);
}

function 获取或创建食人魔形态(this: void, player: any, cache: Record<number, any>, unitTypeId: number, x: number): any {
  const pid = GetPlayerId(player);
  let boss = cache[pid];
  if (!Boss测试单位存活(boss)) {
    boss = CreateUnit(player, unitTypeId, x, 测试中心Y, 270);
    cache[pid] = boss;
    if (Boss测试单位存活(boss)) SetHeroLevel(boss, 20, false);
    debugLogForce('食人魔Boss技能测试', '测试Boss创建', 'playerId=', pid, 'unitTypeId=', unitTypeId, 'bossHid=', 取句柄ID(boss));
  }
  恢复Boss位置与生命(boss, x);
  return boss;
}

function 创建或获取食人魔测试上下文(this: void, player: any): 食人魔测试上下文 | undefined {
  const pid = GetPlayerId(player);
  const hero = 获取Boss测试玩家基准英雄(player);
  if (!Boss测试单位存活(hero)) {
    debugLogForce('食人魔Boss技能测试', '测试场景创建失败：玩家基准英雄无效', 'playerId=', pid, 'heroHid=', 取句柄ID(hero));
    return undefined;
  }

  注册沙漠食人魔技能结构();
  注册杀戮食人魔技能结构();

  const desert = 获取或创建食人魔形态(player, 最近沙漠食人魔, 沙漠食人魔单位ID, 测试中心X - 260);
  const killing = 获取或创建食人魔形态(player, 最近杀戮食人魔, 杀戮食人魔单位ID, 测试中心X + 260);
  if (!Boss测试单位存活(desert) || !Boss测试单位存活(killing)) {
    debugLogForce('食人魔Boss技能测试', '测试场景创建失败：Boss单位无效', 'playerId=', pid, 'desertHid=', 取句柄ID(desert), 'killingHid=', 取句柄ID(killing));
    return undefined;
  }

  最近测试步兵一[pid] = 准备Boss测试固定步兵(最近测试步兵一[pid], 测试中心X - 180, 测试中心Y - 300, 90);
  最近测试步兵二[pid] = 准备Boss测试固定步兵(最近测试步兵二[pid], 测试中心X + 180, 测试中心Y - 300, 90);
  最近测试山丘之王[pid] = 准备Boss测试固定山丘之王(最近测试山丘之王[pid], 测试中心X + 220, 测试中心Y + 220, 90);
  let 圣骑士 = 最近测试圣骑士[pid];
  if (!Boss测试单位存活(圣骑士)) {
    圣骑士 = CreateUnit(jass.Player(12), 测试圣骑士单位ID, 测试中心X - 220, 测试中心Y + 220, 90);
    最近测试圣骑士[pid] = 圣骑士;
  }
  if (Boss测试单位存活(圣骑士)) {
    SetUnitPosition(圣骑士, 测试中心X - 220, 测试中心Y + 220);
    SetUnitFacing(圣骑士, 90);
    设置Boss测试单位满血(圣骑士, 99999999);
    注册Boss技能测试目标(圣骑士);
  }
  if (!Boss测试单位存活(圣骑士)) {
    debugLogForce('食人魔Boss技能测试', '测试场景创建失败：圣骑士测试英雄无效', 'playerId=', pid, 'paladinHid=', 取句柄ID(圣骑士));
    return undefined;
  }
  const mountainKingHasThunderClap = 确保测试英雄学会雷霆一击(最近测试山丘之王[pid]);
  const paladinHasThunderClap = 确保测试英雄学会雷霆一击(最近测试圣骑士[pid]);
  补充测试英雄魔法(最近测试山丘之王[pid]);
  补充测试英雄魔法(最近测试圣骑士[pid]);
  应用Boss战启动属性配置(desert);
  应用Boss战启动属性配置(killing);
  const killingRuntime = 获取或创建杀戮食人魔上下文(killing);
  if (killingRuntime == null) {
    debugLogForce('食人魔Boss技能测试', '测试场景创建失败：杀戮食人魔上下文为空', 'playerId=', pid, 'bossHid=', 取句柄ID(killing));
    return undefined;
  }

  globals.udg_Boss = desert;
  SelectUnitForPlayerSingle(desert, player);
  StarOther_PanCameraToTimedForPlayer(player, 测试中心X, 测试中心Y, 0.2);
  debugLogForce('食人魔Boss技能测试', '测试场景准备完成', 'playerId=', pid, 'desertHid=', 取句柄ID(desert), 'killingHid=', 取句柄ID(killing), 'heroHid=', 取句柄ID(hero), 'targetOneHid=', 取句柄ID(最近测试步兵一[pid]), 'targetTwoHid=', 取句柄ID(最近测试步兵二[pid]), 'mountainKingHid=', 取句柄ID(最近测试山丘之王[pid]), 'paladinHid=', 取句柄ID(最近测试圣骑士[pid]));
  return {
    Boss单位: desert,
    沙漠食人魔: desert,
    杀戮食人魔: killing,
    杀戮运行时: killingRuntime,
    玩家英雄: hero,
    测试山丘之王: 最近测试山丘之王[pid],
    测试圣骑士: 最近测试圣骑士[pid],
  };
}

function 清理食人魔测试上下文(this: void, player: any, context: 食人魔测试上下文): void {
  const pid = GetPlayerId(player);
  debugLogForce('食人魔Boss技能测试', '测试场景清理开始', 'playerId=', pid, 'desertHid=', 取句柄ID(context?.沙漠食人魔), 'killingHid=', 取句柄ID(context?.杀戮食人魔));
  if (context != null && Boss测试单位存活(context.杀戮食人魔)) 清理杀戮食人魔上下文(context.杀戮食人魔);
  注销Boss技能测试目标(最近测试山丘之王[pid]);
  注销Boss技能测试目标(最近测试圣骑士[pid]);
  移除Boss测试单位(最近测试步兵一[pid]);
  移除Boss测试单位(最近测试步兵二[pid]);
  移除Boss测试单位(最近测试山丘之王[pid]);
  移除Boss测试单位(最近测试圣骑士[pid]);
  移除Boss测试单位(最近沙漠食人魔[pid]);
  移除Boss测试单位(最近杀戮食人魔[pid]);
  最近测试步兵一[pid] = undefined;
  最近测试步兵二[pid] = undefined;
  最近测试山丘之王[pid] = undefined;
  最近测试圣骑士[pid] = undefined;
  最近沙漠食人魔[pid] = undefined;
  最近杀戮食人魔[pid] = undefined;
  if (globals.udg_Boss === context?.沙漠食人魔 || globals.udg_Boss === context?.杀戮食人魔) globals.udg_Boss = null;
  debugLogForce('食人魔Boss技能测试', '测试场景清理完成', 'playerId=', pid);
}

function 记录技能测试结果(this: void, 技能名称: string, 是否开始: boolean, boss: any): void {
  debugLogForce('食人魔Boss技能测试', '技能命令执行', 'skill=', 技能名称, 'bossHid=', 取句柄ID(boss), 'started=', 是否开始);
}

function 准备食人魔四方向测试目标(this: void, boss: any, context: 食人魔测试上下文): void {
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const 目标列表 = [
    { 单位: 最近测试步兵一[GetPlayerId(GetOwningPlayer(boss))], x: x + 450, y },
    { 单位: 最近测试步兵二[GetPlayerId(GetOwningPlayer(boss))], x: x - 450, y },
    { 单位: context.测试山丘之王, x, y: y + 450 },
    { 单位: context.测试圣骑士, x, y: y - 450 },
  ];
  for (let i = 0; i < 目标列表.length; i++) {
    const 目标 = 目标列表[i];
    if (!Boss测试单位存活(目标.单位)) continue;
    SetUnitPosition(目标.单位, 目标.x, 目标.y);
    设置Boss测试单位满血(目标.单位, 100000);
  }
  debugLogForce('食人魔Boss技能测试', '四方向测试目标已摆位', 'bossHid=', 取句柄ID(boss), 'bossX=', x, 'bossY=', y, 'targetCount=', 目标列表.length, 'offset=', 450, 'expected=', '东西南北四个方向各有一个已登记测试目标');
}

function 测试食人魔咒(this: void, _player: any, context: 食人魔测试上下文): void {
  const 是否开始 = 释放沙漠食人魔咒(context.沙漠食人魔);
  if (是否开始) addDelayedCallback(2000, on食人魔延迟测试, { 上下文: context, 形态: '沙漠', 操作: '施法' } as 食人魔延迟测试数据);
  记录技能测试结果('沙漠-食人魔咒（2秒后山丘之王施法）', 是否开始, context.沙漠食人魔);
}
function 测试风暴之锤(this: void, _player: any, context: 食人魔测试上下文): void {
  const pid = GetPlayerId(_player);
  const target = 最近测试步兵一[pid];
  const boss = context.沙漠食人魔;
  SetUnitPosition(boss, 测试中心X - 260, 测试中心Y);
  SetUnitPosition(target, 测试中心X + 260, 测试中心Y);
  设置Boss测试单位满血(target, 100000);
  const issueOrder = Boss测试单位存活(target) && IssueTargetOrder(boss, 'thunderbolt', target);
  const 是否开始 = issueOrder || 释放沙漠食人魔风暴之锤(boss);
  if (是否开始) addDelayedCallback(7000, on食人魔延迟测试, { 上下文: context, 形态: '沙漠', 操作: '风暴之锤结束检查' } as 食人魔延迟测试数据);
  debugLogForce('食人魔Boss技能测试', '沙漠风暴之锤指定目标测试', 'bossHid=', 取句柄ID(boss), 'specifiedTargetHid=', 取句柄ID(target), 'issueOrder=', issueOrder, 'started=', 是否开始, 'expected=', '指定目标命中按100%倍率结算，弹幕5秒后清理');
}
function 测试风暴之锤非指定目标(this: void, _player: any, context: 食人魔测试上下文): void {
  const pid = GetPlayerId(_player);
  const target = 最近测试步兵一[pid];
  const interceptor = 最近测试步兵二[pid];
  const boss = context.沙漠食人魔;
  SetUnitPosition(boss, 测试中心X - 260, 测试中心Y);
  SetUnitPosition(interceptor, 测试中心X, 测试中心Y);
  SetUnitPosition(target, 测试中心X + 520, 测试中心Y);
  设置Boss测试单位满血(target, 100000);
  设置Boss测试单位满血(interceptor, 100000);
  const issueOrder = Boss测试单位存活(target) && IssueTargetOrder(boss, 'thunderbolt', target);
  const 是否开始 = issueOrder || 释放沙漠食人魔风暴之锤(boss);
  if (是否开始) addDelayedCallback(7000, on食人魔延迟测试, { 上下文: context, 形态: '沙漠', 操作: '风暴之锤结束检查' } as 食人魔延迟测试数据);
  debugLogForce('食人魔Boss技能测试', '沙漠风暴之锤非指定目标拦截测试', 'bossHid=', 取句柄ID(boss), 'specifiedTargetHid=', 取句柄ID(target), 'interceptorHid=', 取句柄ID(interceptor), 'issueOrder=', issueOrder, 'started=', 是否开始, 'expected=', '弹幕先命中非指定目标时伤害和眩晕均按60%倍率');
}
function 测试雷霆敲打(this: void, _player: any, context: 食人魔测试上下文): void {
  const boss = context.沙漠食人魔;
  准备食人魔四方向测试目标(boss, context);
  const 是否开始 = 释放沙漠食人魔雷霆敲打(boss);
  const 检查延迟毫秒 = (沙漠食人魔技能配置.雷霆敲打.轮次间隔秒 * 沙漠食人魔技能配置.雷霆敲打.轮数 + 沙漠食人魔技能配置.雷霆敲打.预警秒 + 沙漠食人魔技能配置.雷霆敲打.弹幕持续秒 + 0.3) * 1000;
  if (是否开始) addDelayedCallback(检查延迟毫秒, on食人魔延迟测试, { 上下文: context, 形态: '沙漠', 操作: '雷霆敲打结束检查' } as 食人魔延迟测试数据);
  debugLogForce('食人魔Boss技能测试', '沙漠雷霆敲打四方向测试', 'bossHid=', 取句柄ID(boss), 'started=', 是否开始, 'checkDelay=', 检查延迟毫秒, 'expected=', '全部轮次发射且最后一轮冲击波生命周期结束后检查；每轮创建四个方向冲击波并结算减速');
}
function 测试普通雷霆震怒(this: void, _player: any, context: 食人魔测试上下文): void {
  释放沙漠食人魔雷霆震怒(context.沙漠食人魔);
}
function 测试深渊魔咒(this: void, _player: any, context: 食人魔测试上下文): void {
  const 是否开始 = 释放杀戮食人魔深渊魔咒(context.杀戮运行时);
  if (是否开始) addDelayedCallback(2000, on食人魔延迟测试, { 上下文: context, 形态: '杀戮', 操作: '施法' } as 食人魔延迟测试数据);
}
function 测试深渊魔咒治疗反噬(this: void, _player: any, context: 食人魔测试上下文): void {
  const 是否开始 = 释放杀戮食人魔深渊魔咒(context.杀戮运行时);
  if (是否开始) addDelayedCallback(2000, on食人魔延迟测试, { 上下文: context, 形态: '杀戮', 操作: '治疗反噬' } as 食人魔延迟测试数据);
}
function 测试血海绞杀(this: void, _player: any, context: 食人魔测试上下文): void {
  准备食人魔四方向测试目标(context.杀戮食人魔, context);
  const 是否开始 = 释放杀戮食人魔血海绞杀(context.杀戮运行时);
  if (是否开始) addDelayedCallback(5200, on食人魔延迟测试, { 上下文: context, 形态: '杀戮', 操作: '血海绞杀结束检查' } as 食人魔延迟测试数据);
  debugLogForce('食人魔Boss技能测试', '杀戮血海绞杀四方向测试', 'bossHid=', 取句柄ID(context.杀戮食人魔), 'started=', 是否开始, 'expected=', '四个方向各创建一枚血海弹幕，命中后造成暗伤并眩晕');
}
function 测试痛之束缚(this: void, _player: any, context: 食人魔测试上下文): void {
  const 是否开始 = 释放杀戮食人魔痛之束缚(context.杀戮运行时);
  记录技能测试结果('杀戮-痛之束缚', 是否开始, context.杀戮食人魔);
}
function 测试杀戮雷霆震怒(this: void, _player: any, context: 食人魔测试上下文): void {
  const 是否开始 = 释放杀戮食人魔雷霆震怒(context.杀戮运行时);
  记录技能测试结果('杀戮-雷霆震怒', 是否开始, context.杀戮食人魔);
}

function 测试蓄力重击(this: void, _player: any, context: 食人魔测试上下文): void {
  const boss = context.沙漠食人魔;
  const target = 最近测试步兵一[GetPlayerId(_player)];
  const secondTarget = 最近测试步兵二[GetPlayerId(_player)];
  SetUnitPosition(boss, 测试中心X - 260, 测试中心Y);
  SetUnitPosition(target, 测试中心X - 180, 测试中心Y);
  SetUnitPosition(secondTarget, 测试中心X + 180, 测试中心Y);
  设置Boss测试单位满血(target, 100000);
  设置Boss测试单位满血(secondTarget, 100000);
  let 成功次数 = 0;
  for (let i = 0; i < 4; i++) {
    if (UnitDamageTarget(boss, target, 1, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)) 成功次数++;
  }
  debugLogForce('食人魔Boss技能测试', '蓄力重击四次普攻测试已提交', 'bossHid=', 取句柄ID(boss), 'centerTargetHid=', 取句柄ID(target), 'nearTargetHid=', 取句柄ID(secondTarget), 'submitted=', 成功次数, 'expected=', '第四击触发400码范围伤害且预期命中两个测试靶');
}

function 测试食人魔啃食(this: void, _player: any, context: 食人魔测试上下文, 形态: '沙漠' | '杀戮'): void {
  const pid = GetPlayerId(_player);
  const boss = 形态 === '沙漠' ? context.沙漠食人魔 : context.杀戮食人魔;
  const 被击杀靶 = 最近测试步兵一[pid];
  const 免伤验证靶 = 最近测试步兵二[pid];
  if (!Boss测试单位存活(boss) || !Boss测试单位存活(被击杀靶) || !Boss测试单位存活(免伤验证靶)) {
    debugLogForce('食人魔Boss技能测试', '啃食测试跳过：Boss或测试靶无效', 'form=', 形态, 'bossHid=', 取句柄ID(boss), 'killedTargetHid=', 取句柄ID(被击杀靶), 'damageTargetHid=', 取句柄ID(免伤验证靶));
    return;
  }
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  const maxMana = GetUnitState(boss, UNIT_STATE_MAX_MANA);
  SetUnitState(boss, UNIT_STATE_LIFE, maxLife * 0.5);
  SetUnitState(boss, UNIT_STATE_MANA, maxMana * 0.5);
  const lethalDamage = GetUnitState(被击杀靶, UNIT_STATE_MAX_LIFE) + 100000;
  let killSubmitted = false;
  let lethalHitCount = 0;
  for (let i = 0; i < 4 && Boss测试单位存活(被击杀靶); i++) {
    const submitted = UnitDamageTarget(boss, 被击杀靶, lethalDamage, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
    if (submitted) {
      killSubmitted = true;
      lethalHitCount++;
    }
  }
  debugLogForce('食人魔Boss技能测试', '致命伤害后目标状态', 'form=', 形态, 'bossHid=', 取句柄ID(boss), 'targetHid=', 取句柄ID(被击杀靶), 'targetLife=', GetUnitState(被击杀靶, UNIT_STATE_LIFE), 'targetAlive=', Boss测试单位存活(被击杀靶), 'lethalHitCount=', lethalHitCount, 'bossSafeInvulnerable=', 单位是否无敌安全(boss));
  const damageDuringEating = UnitDamageTarget(免伤验证靶, boss, 5000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
  debugLogForce('食人魔Boss技能测试', '食人魔啃食真实死亡事件已提交', 'form=', 形态, 'bossHid=', 取句柄ID(boss), 'killedTargetHid=', 取句柄ID(被击杀靶), 'killSubmitted=', killSubmitted, 'damageDuringEatingSubmitted=', damageDuringEating, 'bossLifeImmediately=', GetUnitState(boss, UNIT_STATE_LIFE), 'expected=', '击杀后暂停硬直并免伤；等待啃食结束恢复100%状态');
  if (killSubmitted) {
    const difficulty = getGameDifficulty();
    const normalizedDifficulty = difficulty > 0 ? difficulty : 1;
    const eatingDurationMs = (2.6 - normalizedDifficulty * 0.2) * 1000;
    const callbackId = addDelayedCallback(eatingDurationMs + 100, on食人魔延迟测试, { 上下文: context, 形态, 操作: '啃食完成检查' } as 食人魔延迟测试数据);
    debugLogForce('食人魔Boss技能测试', '啃食完成检查已登记', 'form=', 形态, 'bossHid=', 取句柄ID(boss), 'callbackId=', callbackId, 'eatingDurationMs=', eatingDurationMs, 'lifeBeforeEating=', maxLife * 0.5, 'manaBeforeEating=', maxMana * 0.5);
  }
}

function 测试沙漠食人魔啃食(this: void, player: any, context: 食人魔测试上下文): void {
  测试食人魔啃食(player, context, '沙漠');
}

function 测试杀戮食人魔啃食(this: void, player: any, context: 食人魔测试上下文): void {
  测试食人魔啃食(player, context, '杀戮');
}

function on食人魔延迟测试(this: void, variable?: any): void {
  const data = variable as 食人魔延迟测试数据 | undefined;
  if (data == null) return;
  const pid = GetPlayerId(data.上下文.玩家英雄 != null ? GetOwningPlayer(data.上下文.玩家英雄) : jass.Player(0));
  const boss = data.形态 === '沙漠' ? data.上下文.沙漠食人魔 : data.上下文.杀戮食人魔;
  if (data.操作 === '啃食完成检查') {
    const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
    const maxMana = GetUnitState(boss, UNIT_STATE_MAX_MANA);
    const lifeBeforePostEatingDamage = GetUnitState(boss, UNIT_STATE_LIFE);
    const manaBeforePostEatingDamage = GetUnitState(boss, UNIT_STATE_MANA);
    const postEatingDamage = UnitDamageTarget(data.上下文.测试山丘之王, boss, 1, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
    debugLogForce('食人魔Boss技能测试', '啃食完成时间线检查', 'form=', data.形态, 'bossHid=', 取句柄ID(boss), 'lifeBeforePostEatingDamage=', lifeBeforePostEatingDamage, 'maxLife=', maxLife, 'manaBeforePostEatingDamage=', manaBeforePostEatingDamage, 'maxMana=', maxMana, 'lifeAfterPostEatingDamage=', GetUnitState(boss, UNIT_STATE_LIFE), 'manaAfterPostEatingDamage=', GetUnitState(boss, UNIT_STATE_MANA), 'postEatingDamageSubmitted=', postEatingDamage, 'expected=', '追加伤害前生命魔法满值、冷却已重置、解除暂停和无敌；追加伤害后伤害可正常结算');
    return;
  }
  const target = data.上下文.测试山丘之王;
  const secondTarget = data.上下文.测试圣骑士;
  if (data.操作 === '治疗反噬') {
    const targetMaxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE);
    const secondTargetMaxLife = GetUnitState(secondTarget, UNIT_STATE_MAX_LIFE);
    SetUnitState(target, UNIT_STATE_LIFE, targetMaxLife - 5000);
    SetUnitState(secondTarget, UNIT_STATE_LIFE, secondTargetMaxLife - 5000);
    spellHeal(target, target, 5000, false);
    spellHeal(secondTarget, secondTarget, 5000, false);
    return;
  }
  if (data.操作 === '风暴之锤结束检查') {
    debugLogForce('食人魔Boss技能测试', '风暴之锤结束时间线检查', 'bossHid=', 取句柄ID(data.上下文.沙漠食人魔), 'specifiedTargetHid=', 取句柄ID(最近测试步兵一[pid]), 'interceptorHid=', 取句柄ID(最近测试步兵二[pid]), 'specifiedTargetLife=', GetUnitState(最近测试步兵一[pid], UNIT_STATE_LIFE), 'interceptorLife=', GetUnitState(最近测试步兵二[pid], UNIT_STATE_LIFE), 'expected=', '5秒生命周期结束后弹幕数据清理；指定目标与非指定拦截目标最多各结算一次');
    return;
  }
  if (data.操作 === '雷霆敲打结束检查') {
    debugLogForce('食人魔Boss技能测试', '雷霆敲打结束时间线检查', 'bossHid=', 取句柄ID(data.上下文.沙漠食人魔), 'eastTargetLife=', GetUnitState(最近测试步兵一[pid], UNIT_STATE_LIFE), 'westTargetLife=', GetUnitState(最近测试步兵二[pid], UNIT_STATE_LIFE), 'northTargetLife=', GetUnitState(data.上下文.测试山丘之王, UNIT_STATE_LIFE), 'southTargetLife=', GetUnitState(data.上下文.测试圣骑士, UNIT_STATE_LIFE), 'expected=', '全部四轮已发射且最后一轮冲击波生命周期结束；每轮应创建东南西北四枚冲击波并结算减速');
    return;
  }
  if (data.操作 === '血海绞杀结束检查') {
    debugLogForce('食人魔Boss技能测试', '血海绞杀结束时间线检查', 'bossHid=', 取句柄ID(data.上下文.杀戮食人魔), 'eastTargetLife=', GetUnitState(最近测试步兵一[pid], UNIT_STATE_LIFE), 'westTargetLife=', GetUnitState(最近测试步兵二[pid], UNIT_STATE_LIFE), 'northTargetLife=', GetUnitState(data.上下文.测试山丘之王, UNIT_STATE_LIFE), 'southTargetLife=', GetUnitState(data.上下文.测试圣骑士, UNIT_STATE_LIFE), 'expected=', '施法硬直结束且四方向血海弹幕已发射；命中后造成暗伤并眩晕');
    return;
  }
  补充测试英雄魔法(target);
  补充测试英雄魔法(secondTarget);
  const targetHasThunderClap = 确保测试英雄学会雷霆一击(target);
  const secondTargetHasThunderClap = 确保测试英雄学会雷霆一击(secondTarget);
  const started = targetHasThunderClap && IssueImmediateOrder(target, 'thunderclap');
  const secondStarted = secondTargetHasThunderClap && IssueImmediateOrder(secondTarget, 'thunderclap');
}

function 测试疼痛复仇(this: void, _player: any, context: 食人魔测试上下文): void {
  const source = 最近测试步兵一[GetPlayerId(_player)];
  let 成功次数 = 0;
  for (let i = 0; i < 2; i++) {
    if (UnitDamageTarget(source, context.杀戮食人魔, 2000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)) 成功次数++;
  }
  debugLogForce('食人魔Boss技能测试', '疼痛复仇阈值测试已提交', 'bossHid=', 取句柄ID(context.杀戮食人魔), 'sourceHid=', 取句柄ID(source), 'submitted=', 成功次数, 'expected=', '根据实际结算伤害观察增伤层与解控次数；本轮应至少触发一次解控并刷新血海绞杀');
}

function 测试痛之束缚伤害转移(this: void, _player: any, context: 食人魔测试上下文): void {
  const started = 释放杀戮食人魔痛之束缚(context.杀戮运行时);
  if (started) addDelayedCallback(900, on痛之束缚延迟测试, { 上下文: context, 形态: '杀戮', 操作: '转移伤害' } as 食人魔延迟测试数据);
  记录技能测试结果('杀戮-痛之束缚（链接后Boss受伤）', started, context.杀戮食人魔);
}

function 测试痛之束缚断链(this: void, _player: any, context: 食人魔测试上下文): void {
  const started = 释放杀戮食人魔痛之束缚(context.杀戮运行时);
  if (started) addDelayedCallback(900, on痛之束缚延迟测试, { 上下文: context, 形态: '杀戮', 操作: '断链' } as 食人魔延迟测试数据);
  记录技能测试结果('杀戮-痛之束缚（移出1200码断链）', started, context.杀戮食人魔);
}

function on痛之束缚延迟测试(this: void, variable?: any): void {
  const data = variable as 食人魔延迟测试数据 | undefined;
  if (data == null) return;
  const context = data.上下文;
  const pid = GetPlayerId(context.玩家英雄 != null ? GetOwningPlayer(context.玩家英雄) : jass.Player(0));
  const runtime = context.杀戮运行时;
  const target = runtime.束缚目标;
  if (data.操作 === '转移伤害') {
    const source = 最近测试步兵一[pid];
    const submitted = UnitDamageTarget(source, context.杀戮食人魔, 1000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
    debugLogForce('食人魔Boss技能测试', '痛之束缚伤害转移测试', 'bossHid=', 取句柄ID(context.杀戮食人魔), 'boundTargetHid=', 取句柄ID(target), 'sourceHid=', 取句柄ID(source), 'damageStarted=', submitted, 'expected=', '目标承受10%强化转移伤害');
    return;
  }
  if (target != null && target !== 0) SetUnitPosition(target, 测试中心X + 1800, 测试中心Y);
  debugLogForce('食人魔Boss技能测试', '痛之束缚距离断链测试', 'bossHid=', 取句柄ID(context.杀戮食人魔), 'boundTargetHid=', 取句柄ID(target), 'distanceForced=', 1800, 'expected=', '超过1200码后链接清理');
}

function 测试心脏掌握(this: void, player: any, context: 食人魔测试上下文): void {
  const pid = GetPlayerId(player);
  let target = context.测试山丘之王;
  if (!Boss测试单位存活(target)) {
    target = 准备Boss测试固定山丘之王(target, 测试中心X + 220, 测试中心Y + 220, 90);
    context.测试山丘之王 = target;
    最近测试山丘之王[pid] = target;
  }
  if (!Boss测试单位存活(target)) {
    return;
  }
  设置Boss测试单位满血(target, 100000);
  SetUnitState(target, UNIT_STATE_LIFE, 20000);
  UnitDamageTarget(context.杀戮食人魔, target, 1, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

const 食人魔测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 命令: '食人魔1', 名称: '沙漠-食人魔咒（2秒后施法反噬）', 执行: 测试食人魔咒 },//测试完毕√
  { 序号: 2, 名称: '沙漠-风暴之锤', 执行: 测试风暴之锤 },//测试完毕√
  { 序号: 2, 命令: '食人魔2-2', 名称: '沙漠-风暴之锤非指定目标拦截', 执行: 测试风暴之锤非指定目标 },//测试完毕√
  { 序号: 3, 名称: '沙漠-雷霆敲打', 执行: 测试雷霆敲打 },
  { 序号: 4, 名称: '沙漠-雷霆震怒', 执行: 测试普通雷霆震怒 },//测试完毕√
  { 序号: 5, 命令: '食人魔5', 名称: '杀戮-深渊魔咒（2秒后两个测试英雄施法）', 执行: 测试深渊魔咒 },//测试完毕√
  { 序号: 5, 命令: '食人魔5-2', 名称: '杀戮-深渊魔咒治疗无效与反噬', 执行: 测试深渊魔咒治疗反噬 },//测试完毕√
  { 序号: 6, 名称: '杀戮-血海绞杀', 执行: 测试血海绞杀 },//测试完毕√
  { 序号: 7, 命令: '食人魔7', 名称: '杀戮-痛之束缚（链接后Boss受伤）', 执行: 测试痛之束缚伤害转移 },//测试完毕√
  { 序号: 8, 名称: '杀戮-雷霆震怒', 执行: 测试杀戮雷霆震怒 },//测试完毕√
  { 序号: 9, 命令: '食人魔9', 名称: '沙漠-蓄力重击四次普攻', 执行: 测试蓄力重击 },//测试完毕√
  { 序号: 10, 命令: '食人魔10', 名称: '杀戮-疼痛复仇阈值', 执行: 测试疼痛复仇 },//测试完毕√
  { 序号: 11, 命令: '食人魔11', 名称: '杀戮-痛之束缚移出1200码', 执行: 测试痛之束缚断链 },//测试完毕√
  { 序号: 12, 命令: '食人魔12', 名称: '杀戮-心脏掌握低血线', 执行: 测试心脏掌握 },
  { 序号: 13, 命令: '食人魔13', 名称: '沙漠-食人魔啃食（真实击杀/免伤/恢复）', 执行: 测试沙漠食人魔啃食 },
  { 序号: 14, 命令: '食人魔14', 名称: '杀戮-食人魔啃食（真实击杀/免伤/恢复）', 执行: 测试杀戮食人魔啃食 },
];

注册Boss测试命令组({
  命令单位名: '食人魔',
  Boss名称: '食人魔双形态',
  场地: {
    正式中心: { x: 测试中心X, y: 测试中心Y },
    测试空地中心: { x: 测试中心X, y: 测试中心Y },
  },
  创建或获取上下文: 创建或获取食人魔测试上下文,
  清理上下文: 清理食人魔测试上下文,
  技能命令列表: 食人魔测试技能列表,
});

debugLogForce('食人魔Boss技能测试', '测试命令组注册完成', 'commandCount=', 食人魔测试技能列表.length);

export {};
