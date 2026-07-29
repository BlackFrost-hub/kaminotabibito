/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require('jass.common') as any;
const globals = require('jass.globals') as { udg_Boss?: any; [key: string]: any };

const {
  Boss测试单位存活,
  设置Boss测试单位满血,
  获取Boss测试玩家基准英雄,
  准备Boss测试固定步兵,
  准备Boss测试固定山丘之王,
  移除Boss测试单位,
  注册Boss测试命令组,
} = require('系统.12．测试系统.00．Boss测试系统.index') as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  设置Boss测试单位满血: (this: void, unit: any, 最大生命值?: number) => void;
  获取Boss测试玩家基准英雄: (this: void, player: any) => any;
  准备Boss测试固定步兵: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  准备Boss测试固定山丘之王: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, 配置: any) => void;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { SelectUnitForPlayerSingle } = require('lib.扩展函数.BJ函数.index') as {
  SelectUnitForPlayerSingle: (this: void, unit: any, player: any) => void;
};
const { StarOther_PanCameraToTimedForPlayer } = require('lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数') as {
  StarOther_PanCameraToTimedForPlayer: (this: void, player: any, x: number, y: number, duration: number) => void;
};
const { 标记测试Boss跳过死亡结算 } = require('系统.12．测试系统.00．测试系统辅助函数') as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const { 应用Boss战启动属性配置 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用') as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const {
  创建Boss战运行上下文,
  记录Boss战运行上下文,
  读取Boss战运行上下文,
  清理Boss战运行上下文,
} = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文') as {
  创建Boss战运行上下文: (this: void, boss: any, rect: any, battleMusic: any, victoryMusic: any) => any;
  记录Boss战运行上下文: (this: void, context: any) => void;
  读取Boss战运行上下文: (this: void, boss: any) => any;
  清理Boss战运行上下文: (this: void, boss: any) => void;
};
const { 亚伦柯斯单位技能配置 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.00．配置') as {
  亚伦柯斯单位技能配置: any;
};
const { 亚伦柯斯正式设计配置 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.02．数值与表现配置') as {
  亚伦柯斯正式设计配置: any;
};
const { 注册亚伦柯斯被动效果 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.06．被动效果') as {
  注册亚伦柯斯被动效果: (this: void) => void;
};
const { 获取或创建亚伦柯斯运行时上下文, 清理亚伦柯斯运行时上下文, 进入亚伦柯斯P3 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.01．运行时上下文') as {
  获取或创建亚伦柯斯运行时上下文: (this: void, boss: any) => any;
  清理亚伦柯斯运行时上下文: (this: void, boss: any) => void;
  进入亚伦柯斯P3: (this: void, context: any) => void;
};
const { 释放亚伦柯斯亡冥英斩 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.03．亡冥英斩') as {
  释放亚伦柯斯亡冥英斩: (this: void, context: any, target: any) => boolean;
};
const { 释放亚伦柯斯英灵陨星 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.04．英灵陨星') as {
  释放亚伦柯斯英灵陨星: (this: void, context: any) => boolean;
};
const { 释放亚伦柯斯亡者凝视 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.07．亡者凝视') as {
  释放亚伦柯斯亡者凝视: (this: void, context: any, target: any) => boolean;
};
const { 启动亚伦柯斯旧誓墓碑 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.08．旧誓墓碑') as {
  启动亚伦柯斯旧誓墓碑: (this: void, context: any) => boolean;
};
const { 启用亚伦柯斯不灭军魂, 触发亚伦柯斯最终强化 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.08．沉睡英魂亚伦柯斯.09．不灭军魂') as {
  启用亚伦柯斯不灭军魂: (this: void, context: any) => boolean;
  触发亚伦柯斯最终强化: (this: void, context: any) => boolean;
};

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const Rect = jass.Rect as (minX: number, minY: number, maxX: number, maxY: number) => any;
const RemoveRect = jass.RemoveRect as (rect: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const 亚伦柯斯单位ID = stringToFourCCSafe(亚伦柯斯单位技能配置.单位ID);
const 测试中心X = -540.6;
const 测试中心Y = -2495.2;
const 玩家测试X = -540.6;
const 玩家测试Y = -3055.2;
const 正式场地半宽 = (亚伦柯斯单位技能配置.正式场地.右边界 - 亚伦柯斯单位技能配置.正式场地.左边界) * 0.5;
const 正式场地半高 = (亚伦柯斯单位技能配置.正式场地.上边界 - 亚伦柯斯单位技能配置.正式场地.下边界) * 0.5;

interface 亚伦柯斯测试上下文 {
  运行时: any;
  目标单位: any;
  Boss单位: any;
}

const 最近测试Boss: Record<number, any> = {};
const 最近测试步兵: Record<number, any> = {};
const 最近测试山丘之王: Record<number, any> = {};
const 测试场地矩形: Record<number, any> = {};

function 获取或创建亚伦柯斯测试矩形(this: void, player: any): any {
  const pid = GetPlayerId(player);
  let rect = 测试场地矩形[pid];
  if (rect == null || rect === 0) {
    rect = Rect(测试中心X - 正式场地半宽, 测试中心Y - 正式场地半高, 测试中心X + 正式场地半宽, 测试中心Y + 正式场地半高);
    测试场地矩形[pid] = rect;
  }
  return rect;
}

function 获取或创建亚伦柯斯测试Boss(this: void, player: any): any {
  const pid = GetPlayerId(player);
  let boss = 最近测试Boss[pid];
  if (!Boss测试单位存活(boss)) {
    boss = CreateUnit(player, 亚伦柯斯单位ID, 测试中心X, 测试中心Y, 270);
    最近测试Boss[pid] = boss;
    if (Boss测试单位存活(boss)) SetHeroLevel(boss, 40, false);
  }
  if (Boss测试单位存活(boss)) {
    SetUnitPosition(boss, 测试中心X, 测试中心Y);
    SetUnitFacing(boss, 270);
    设置Boss测试单位满血(boss);
    标记测试Boss跳过死亡结算(boss);
    globals.udg_Boss = boss;
  }
  return boss;
}

function 获取或创建亚伦柯斯测试步兵(this: void, cache: Record<number, any>, player: any, x: number, y: number): any {
  const pid = GetPlayerId(player);
  const unit = 准备Boss测试固定步兵(cache[pid], x, y, 90);
  cache[pid] = unit;
  return unit;
}

function 确保亚伦柯斯测试战斗矩形(this: void, player: any, boss: any): void {
  if (读取Boss战运行上下文(boss) != null) return;
  const battle = 创建Boss战运行上下文(boss, 获取或创建亚伦柯斯测试矩形(player), null, null);
  if (battle != null) 记录Boss战运行上下文(battle);
}

function 创建或获取亚伦柯斯测试上下文(this: void, player: any): 亚伦柯斯测试上下文 | undefined {
  const pid = GetPlayerId(player);
  const hero = 获取Boss测试玩家基准英雄(player);
  const boss = 获取或创建亚伦柯斯测试Boss(player);
  if (!Boss测试单位存活(hero) || !Boss测试单位存活(boss)) return undefined;

  设置Boss测试单位满血(hero);
  const target = 获取或创建亚伦柯斯测试步兵(最近测试步兵, player, 玩家测试X - 220, 玩家测试Y + 180);
  最近测试山丘之王[pid] = 准备Boss测试固定山丘之王(最近测试山丘之王[pid], 玩家测试X + 220, 玩家测试Y + 180, 90);
  if (!Boss测试单位存活(target)) return undefined;

  注册亚伦柯斯被动效果();
  确保亚伦柯斯测试战斗矩形(player, boss);
  应用Boss战启动属性配置(boss);
  设置Boss测试单位满血(boss);
  const runtime = 获取或创建亚伦柯斯运行时上下文(boss);
  if (runtime == null) return undefined;

  SelectUnitForPlayerSingle(boss, player);
  StarOther_PanCameraToTimedForPlayer(player, 测试中心X, 测试中心Y, 0.2);
  return { 运行时: runtime, 目标单位: target, Boss单位: boss };
}

function 清理亚伦柯斯测试上下文(this: void, player: any, context: 亚伦柯斯测试上下文): void {
  const pid = GetPlayerId(player);
  if (context != null && context.Boss单位 != null) {
    清理亚伦柯斯运行时上下文(context.Boss单位);
    清理Boss战运行上下文(context.Boss单位);
  }
  const rect = 测试场地矩形[pid];
  if (rect != null && rect !== 0) RemoveRect(rect);
  移除Boss测试单位(最近测试步兵[pid]);
  移除Boss测试单位(最近测试山丘之王[pid]);
  移除Boss测试单位(最近测试Boss[pid]);
  测试场地矩形[pid] = undefined;
  最近测试步兵[pid] = undefined;
  最近测试山丘之王[pid] = undefined;
  最近测试Boss[pid] = undefined;
  if (globals.udg_Boss === context?.Boss单位) globals.udg_Boss = null;
}

function 准备亚伦柯斯P1(this: void, context: 亚伦柯斯测试上下文): void {
  context.运行时.阶段 = 'P1守墓者苏醒';
  context.运行时.当前大型技能 = undefined;
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE));
}

function 准备亚伦柯斯P2(this: void, context: 亚伦柯斯测试上下文): void {
  const thresholds = 亚伦柯斯正式设计配置.阶段阈值;
  context.运行时.阶段 = 'P2旧誓回响';
  context.运行时.当前大型技能 = undefined;
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE) * (thresholds.P2生命比例 + thresholds.P3生命比例) * 0.5);
}

function 准备亚伦柯斯P3(this: void, context: 亚伦柯斯测试上下文): void {
  const thresholds = 亚伦柯斯正式设计配置.阶段阈值;
  context.运行时.阶段 = 'P2旧誓回响';
  context.运行时.未安魂墓碑数量 = 0;
  context.运行时.当前大型技能 = undefined;
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE) * (thresholds.P3生命比例 + thresholds.最终强化生命比例) * 0.5);
  进入亚伦柯斯P3(context.运行时);
}

function 测试亚伦柯斯亡冥英斩(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P1(context);
  释放亚伦柯斯亡冥英斩(context.运行时, context.目标单位);
}
function 测试亚伦柯斯P2亡冥英斩(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P2(context);
  释放亚伦柯斯亡冥英斩(context.运行时, context.目标单位);
}
function 测试亚伦柯斯英灵陨星(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P1(context);
  释放亚伦柯斯英灵陨星(context.运行时);
}
function 测试亚伦柯斯P2英灵陨星(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P2(context);
  释放亚伦柯斯英灵陨星(context.运行时);
}
function 测试亚伦柯斯亡者凝视(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P1(context);
  释放亚伦柯斯亡者凝视(context.运行时, context.目标单位);
}
function 测试亚伦柯斯P2亡者凝视(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P2(context);
  释放亚伦柯斯亡者凝视(context.运行时, context.目标单位);
}
function 测试亚伦柯斯P3亡者凝视(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P3(context);
  释放亚伦柯斯亡者凝视(context.运行时, context.目标单位);
}
function 测试亚伦柯斯旧誓墓碑(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  context.运行时.阶段 = 'P2旧誓回响';
  context.运行时.当前大型技能 = undefined;
  启动亚伦柯斯旧誓墓碑(context.运行时);
}
function 测试亚伦柯斯进入P3(this: void, _player: any, context: 亚伦柯斯测试上下文): void { 准备亚伦柯斯P3(context); }
function 测试亚伦柯斯P3亡冥英斩(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P3(context);
  释放亚伦柯斯亡冥英斩(context.运行时, context.目标单位);
}
function 测试亚伦柯斯P3英灵陨星(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P3(context);
  释放亚伦柯斯英灵陨星(context.运行时);
}
function 测试亚伦柯斯不灭军魂(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P3(context);
  启用亚伦柯斯不灭军魂(context.运行时);
}
function 测试亚伦柯斯最终强化(this: void, _player: any, context: 亚伦柯斯测试上下文): void {
  准备亚伦柯斯P3(context);
  SetUnitState(context.Boss单位, UNIT_STATE_LIFE, GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE) * 亚伦柯斯正式设计配置.阶段阈值.最终强化生命比例 * 0.5);
  触发亚伦柯斯最终强化(context.运行时);
}

const 亚伦柯斯测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: 'P1亡冥英斩', 执行: 测试亚伦柯斯亡冥英斩 },
  { 序号: 1, 命令: '1-2', 名称: 'P2亡冥英斩', 执行: 测试亚伦柯斯P2亡冥英斩 },
  { 序号: 1, 命令: '1-3', 名称: 'P3亡冥英斩归魂', 执行: 测试亚伦柯斯P3亡冥英斩 },
  { 序号: 2, 名称: 'P1英灵陨星', 执行: 测试亚伦柯斯英灵陨星 },
  { 序号: 2, 命令: '2-2', 名称: 'P2英灵陨星', 执行: 测试亚伦柯斯P2英灵陨星 },
  { 序号: 2, 命令: '2-3', 名称: 'P3英灵陨星送葬', 执行: 测试亚伦柯斯P3英灵陨星 },
  { 序号: 3, 名称: '亡者凝视', 执行: 测试亚伦柯斯亡者凝视 },
  { 序号: 3, 命令: '3-2', 名称: 'P2亡者凝视', 执行: 测试亚伦柯斯P2亡者凝视 },
  { 序号: 3, 命令: '3-3', 名称: 'P3亡者凝视', 执行: 测试亚伦柯斯P3亡者凝视 },
  { 序号: 4, 名称: 'P2旧誓墓碑', 执行: 测试亚伦柯斯旧誓墓碑 },
  { 序号: 5, 名称: '进入P3最后誓约', 执行: 测试亚伦柯斯进入P3 },
  { 序号: 6, 名称: 'P3亡冥英斩归魂', 执行: 测试亚伦柯斯P3亡冥英斩 },
  { 序号: 7, 名称: 'P3英灵陨星送葬', 执行: 测试亚伦柯斯P3英灵陨星 },
  { 序号: 8, 名称: '不灭军魂', 执行: 测试亚伦柯斯不灭军魂 },
  { 序号: 9, 名称: '最终强化', 执行: 测试亚伦柯斯最终强化 },
];

注册Boss测试命令组({
  命令单位名: '亚伦柯斯',
  Boss名称: '亚伦柯斯',
  场地: {
    正式中心: { x: 亚伦柯斯单位技能配置.正式场地.中心X, y: 亚伦柯斯单位技能配置.正式场地.中心Y },
    测试空地中心: { x: 测试中心X, y: 测试中心Y },
  },
  创建或获取上下文: 创建或获取亚伦柯斯测试上下文,
  清理上下文: 清理亚伦柯斯测试上下文,
  技能命令列表: 亚伦柯斯测试技能列表,
});

export {};
