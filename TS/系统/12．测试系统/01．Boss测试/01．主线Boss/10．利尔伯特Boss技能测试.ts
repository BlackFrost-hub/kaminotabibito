/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const globals = require('jass.globals') as { udg_Boss?: any; [key: string]: any };

const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { 创建物品并注册排泄监听 } = require('lib.扩展函数.物品相关函数.创建物品函数') as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { getItemDataEntry } = require('lib.扩展函数.物品相关函数.装备数据查询') as {
  getItemDataEntry: (this: void, item: any) => any | null;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 添加单位暂停, 移除单位暂停 } = require('lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统') as {
  添加单位暂停: (this: void, unit: any, 来源: string) => boolean;
  移除单位暂停: (this: void, unit: any, 来源: string) => boolean;
};
const { 应用Boss战启动属性配置 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用') as {
  应用Boss战启动属性配置: (this: void, unit: any) => void;
};
const { 注册利尔伯特技能结构 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.07．技能入口') as {
  注册利尔伯特技能结构: (this: void) => void;
};
const { 获取或创建利尔伯特上下文, 清理利尔伯特上下文 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.01．运行时') as {
  获取或创建利尔伯特上下文: (this: void, boss: any) => any;
  清理利尔伯特上下文: (this: void, boss: any) => void;
};
const { 释放利尔伯特裂地斩 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.04．裂地斩') as {
  释放利尔伯特裂地斩: (this: void, context: any) => boolean;
};
const { 释放利尔伯特审判拷问 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.05．审判拷问') as {
  释放利尔伯特审判拷问: (this: void, context: any, target: any) => boolean;
};
const { 释放利尔伯特检查 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.11．利尔·伯特.06．检查') as {
  释放利尔伯特检查: (this: void, context: any, target: any) => boolean;
};
const { 注册Boss技能测试目标, 注销Boss技能测试目标 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  注册Boss技能测试目标: (this: void, unit: any) => void;
  注销Boss技能测试目标: (this: void, unit: any) => void;
};
const { 标记测试Boss跳过死亡结算 } = require('系统.12．测试系统.00．测试系统辅助函数') as {
  标记测试Boss跳过死亡结算: (this: void, boss: any) => void;
};
const { Boss测试单位存活, 准备Boss测试固定山丘之王, 设置Boss测试单位满血, 移除Boss测试单位, 注册Boss测试命令组 } = require('系统.12．测试系统.00．Boss测试系统.index') as {
  Boss测试单位存活: (this: void, unit: any) => boolean;
  准备Boss测试固定山丘之王: (this: void, unit: any, x: number, y: number, facing?: number) => any;
  设置Boss测试单位满血: (this: void, unit: any, maxLife?: number) => void;
  移除Boss测试单位: (this: void, unit: any) => void;
  注册Boss测试命令组: (this: void, config: any) => void;
};
const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const Player = jass.Player as (playerId: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAcquireRange = jass.SetUnitAcquireRange as (unit: any, range: number) => void;
const IssueImmediateOrder = jass.IssueImmediateOrder as (unit: any, order: string) => boolean;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;
const UnitAddItem = jass.UnitAddItem as (unit: any, item: any) => boolean;
const UnitRemoveItem = jass.UnitRemoveItem as (unit: any, item: any) => void;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const RemoveItem = jass.RemoveItem as (item: any) => void;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const DzUnitDisableAttack = japi.DzUnitDisableAttack as ((unit: any, disabled: boolean) => void) | undefined;
const EXSetUnitFacing = japi.EXSetUnitFacing as (unit: any, radians: number) => void;
const 测试朝向角度转弧度 = 0.017453292519943295;

function 禁用利尔测试靶攻击(this: void, target: any): void {
  if (target == null || target === 0 || !Boss测试单位存活(target)) return;
  SetUnitAcquireRange(target, 0);
  if (DzUnitDisableAttack != null) DzUnitDisableAttack(target, true);
  IssueImmediateOrder(target, 'stop');
}

function 设置利尔测试靶朝向(this: void, target: any, facing: number): void {
  if (target == null || target === 0 || !Boss测试单位存活(target)) return;
  EXSetUnitFacing(target, facing * 测试朝向角度转弧度);
  SetUnitFacing(target, facing);
}

const 利尔伯特单位ID = stringToFourCCSafe('N05L');
const 步兵单位ID = stringToFourCCSafe('hfoo');
const 测试装备ID = stringToFourCCSafe('I000');
const 测试中心X = -540.6;
const 测试中心Y = -2495.2;
const 红色玩家ID = 0;
const 中立敌对玩家ID = 12;
const 最近Boss: Record<number, any> = {};
const 最近山丘之王: Record<number, any> = {};
const 最近伤害步兵: Record<number, any> = {};
const 测试创建装备: Record<number, any[]> = {};

interface 利尔伯特测试上下文 {
  Boss单位: any;
  山丘之王: any;
  伤害步兵: any;
  运行时: any;
}

interface 利尔伯特正义审判延迟伤害数据 {
  上下文: 利尔伯特测试上下文;
  暂停来源: string;
  朝向: number;
  是否攻击: boolean;
}

function 物品有效(this: void, item: any): boolean {
  return item != null && item !== 0 && GetItemTypeId(item) !== 0;
}

function 查找山丘之王可识别装备(this: void, 山丘之王: any): any {
  for (let slot = 0; slot <= 5; slot++) {
    const item = UnitItemInSlot(山丘之王, slot);
    if (物品有效(item) && getItemDataEntry(item) != null) return item;
  }
  return null;
}

function 获取山丘之王可识别装备数量(this: void, 山丘之王: any): number {
  let count = 0;
  for (let slot = 0; slot <= 5; slot++) {
    const item = UnitItemInSlot(山丘之王, slot);
    if (物品有效(item) && getItemDataEntry(item) != null) count++;
  }
  return count;
}

function 移除山丘之王可识别装备(this: void, playerId: number, 山丘之王: any): number {
  let removedCount = 0;
  for (let slot = 0; slot <= 5; slot++) {
    const item = UnitItemInSlot(山丘之王, slot);
    if (!物品有效(item) || getItemDataEntry(item) == null) continue;
    UnitRemoveItem(山丘之王, item);
    if (物品有效(item)) RemoveItem(item);
    removedCount++;
  }
  return removedCount;
}

function 确保山丘之王拥有测试装备(this: void, playerId: number, 山丘之王: any): any {
  const 已有装备 = 查找山丘之王可识别装备(山丘之王);
  if (已有装备 != null && 已有装备 !== 0) return 已有装备;
  const item = 创建物品并注册排泄监听(测试装备ID, GetUnitX(山丘之王), GetUnitY(山丘之王));
  if (!物品有效(item) || getItemDataEntry(item) == null || !UnitAddItem(山丘之王, item)) {
    if (物品有效(item)) RemoveItem(item);
    return null;
  }
  let 列表 = 测试创建装备[playerId];
  if (列表 == null) {
    列表 = [];
    测试创建装备[playerId] = 列表;
  }
  列表.push(item);
  return item;
}

function 创建或获取利尔伯特测试上下文(this: void, player: any): 利尔伯特测试上下文 | undefined {
  const playerId = GetPlayerId(player);
  注册利尔伯特技能结构();
  let boss = 最近Boss[playerId];
  if (!Boss测试单位存活(boss)) {
    boss = CreateUnit(Player(红色玩家ID), 利尔伯特单位ID, 测试中心X, 测试中心Y, 0);
    最近Boss[playerId] = boss;
  }
  if (!Boss测试单位存活(boss)) return undefined;
  SetUnitPosition(boss, 测试中心X, 测试中心Y);
  SetUnitFacing(boss, 0);
  应用Boss战启动属性配置(boss);
  设置Boss测试单位满血(boss, 100000);
  标记测试Boss跳过死亡结算(boss);

  const 山丘之王 = 准备Boss测试固定山丘之王(最近山丘之王[playerId], 测试中心X + 450, 测试中心Y, 0);
  if (!Boss测试单位存活(山丘之王)) return undefined;
  最近山丘之王[playerId] = 山丘之王;
  注册Boss技能测试目标(山丘之王);

  let 步兵 = 最近伤害步兵[playerId];
  if (!Boss测试单位存活(步兵)) {
    步兵 = CreateUnit(Player(中立敌对玩家ID), 步兵单位ID, 测试中心X - 350, 测试中心Y, 0);
    最近伤害步兵[playerId] = 步兵;
  }
  if (!Boss测试单位存活(步兵)) return undefined;
  SetUnitPosition(步兵, 测试中心X - 350, 测试中心Y);
  设置Boss测试单位满血(步兵, 100000);
  禁用利尔测试靶攻击(山丘之王);

  const 运行时 = 获取或创建利尔伯特上下文(boss);
  if (运行时 == null) return undefined;
  globals.udg_Boss = boss;
  return { Boss单位: boss, 山丘之王, 伤害步兵: 步兵, 运行时 };
}

function 清理利尔伯特测试上下文(this: void, player: any, context: 利尔伯特测试上下文): void {
  const playerId = GetPlayerId(player);
  if (Boss测试单位存活(context?.Boss单位)) 清理利尔伯特上下文(context.Boss单位);
  const 装备列表 = 测试创建装备[playerId] ?? [];
  for (let i = 装备列表.length - 1; i >= 0; i--) {
    const item = 装备列表[i];
    if (物品有效(item)) RemoveItem(item);
  }
  测试创建装备[playerId] = [];
  注销Boss技能测试目标(context?.山丘之王);
  移除Boss测试单位(最近山丘之王[playerId]);
  if (最近伤害步兵[playerId] != null && 最近伤害步兵[playerId] !== 0) RemoveUnit(最近伤害步兵[playerId]);
  移除Boss测试单位(最近Boss[playerId]);
  最近山丘之王[playerId] = undefined;
  最近伤害步兵[playerId] = undefined;
  最近Boss[playerId] = undefined;
  if (globals.udg_Boss === context?.Boss单位) globals.udg_Boss = null;
}

function 重置背对站位(this: void, context: 利尔伯特测试上下文): void {
  SetUnitPosition(context.Boss单位, 测试中心X, 测试中心Y);
  SetUnitFacing(context.Boss单位, 0);
  IssueImmediateOrder(context.Boss单位, 'holdposition');
  SetUnitPosition(context.山丘之王, 测试中心X + 450, 测试中心Y);
  禁用利尔测试靶攻击(context.山丘之王);
  设置利尔测试靶朝向(context.山丘之王, 0);
  IssueImmediateOrder(context.山丘之王, 'stop');
}

function 重置面向站位(this: void, context: 利尔伯特测试上下文): void {
  重置背对站位(context);
  设置利尔测试靶朝向(context.山丘之王, 180);
}

function 重置原位背对站位(this: void, context: 利尔伯特测试上下文): void {
  重置背对站位(context);
  设置利尔测试靶朝向(context.山丘之王, 0);
}

function on利尔伯特正义审判延迟伤害(this: void, variable?: any): void {
  const data = variable as 利尔伯特正义审判延迟伤害数据 | undefined;
  if (data == null) return;
  const context = data.上下文;
  const target = context.山丘之王;
  if (!Boss测试单位存活(context.Boss单位) || !Boss测试单位存活(target)) {
    if (Boss测试单位存活(target)) {
      移除单位暂停(target, data.暂停来源);
      设置利尔测试靶朝向(target, data.朝向);
      IssueImmediateOrder(target, 'stop');
    }
    return;
  }

  UnitDamageTarget(context.Boss单位, target, 200, data.是否攻击, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
  移除单位暂停(target, data.暂停来源);
  设置利尔测试靶朝向(target, data.朝向);
  IssueImmediateOrder(target, 'stop');
}

function 测试正义审判被动(this: void, _player: any, context: 利尔伯特测试上下文): void {
  重置背对站位(context);
  const 朝向锁定来源 = '利尔伯特测试-正义审判朝向锁定';
  添加单位暂停(context.山丘之王, 朝向锁定来源);
  设置利尔测试靶朝向(context.山丘之王, 0);
  const callbackId = addDelayedCallback(1000, on利尔伯特正义审判延迟伤害, {
    上下文: context,
    暂停来源: 朝向锁定来源,
    朝向: 0,
    是否攻击: false,
  } as 利尔伯特正义审判延迟伤害数据);
  context.运行时?.清理?.登记延迟回调?.('利尔伯特测试-正义审判背对伤害', callbackId);
}

function 测试正义审判面向安全(this: void, _player: any, context: 利尔伯特测试上下文): void {
  重置面向站位(context);
  const 朝向锁定来源 = '利尔伯特测试-正义审判面向朝向锁定';
  添加单位暂停(context.山丘之王, 朝向锁定来源);
  设置利尔测试靶朝向(context.山丘之王, 180);
  const callbackId = addDelayedCallback(1000, on利尔伯特正义审判延迟伤害, {
    上下文: context,
    暂停来源: 朝向锁定来源,
    朝向: 180,
    是否攻击: true,
  } as 利尔伯特正义审判延迟伤害数据);
  context.运行时?.清理?.登记延迟回调?.('利尔伯特测试-正义审判面向安全', callbackId);
}

function 测试裂地斩(this: void, _player: any, context: 利尔伯特测试上下文): void {
  重置背对站位(context);
  释放利尔伯特裂地斩(context.运行时);
}

function 测试审判拷问(this: void, _player: any, context: 利尔伯特测试上下文): void {
  重置背对站位(context);
  const 是否开始 = 释放利尔伯特审判拷问(context.运行时, context.山丘之王);
  if (是否开始) {
    SetUnitPosition(context.山丘之王, 测试中心X + 800, 测试中心Y);
    设置利尔测试靶朝向(context.山丘之王, 0);
    IssueImmediateOrder(context.山丘之王, 'stop');
  }
}

function 测试审判拷问原位安全(this: void, _player: any, context: 利尔伯特测试上下文): void {
  重置原位背对站位(context);
  释放利尔伯特审判拷问(context.运行时, context.山丘之王);
}

function 测试检查无装备(this: void, player: any, context: 利尔伯特测试上下文): void {
  const playerId = GetPlayerId(player);
  重置背对站位(context);
  移除山丘之王可识别装备(playerId, context.山丘之王);
  释放利尔伯特检查(context.运行时, context.山丘之王);
}

function 测试检查正常(this: void, player: any, context: 利尔伯特测试上下文): void {
  const playerId = GetPlayerId(player);
  重置背对站位(context);
  const item = 确保山丘之王拥有测试装备(playerId, context.山丘之王);
  if (item != null) 释放利尔伯特检查(context.运行时, context.山丘之王);
}

function 测试检查失败(this: void, player: any, context: 利尔伯特测试上下文): void {
  const playerId = GetPlayerId(player);
  重置背对站位(context);
  const item = 确保山丘之王拥有测试装备(playerId, context.山丘之王);
  const 是否开始 = item != null && 释放利尔伯特检查(context.运行时, context.山丘之王);
  if (是否开始) {
    UnitDamageTarget(context.伤害步兵, context.Boss单位, 5000, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
    IssueImmediateOrder(context.Boss单位, 'holdposition');
  }
}

const 利尔伯特测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 命令: '利尔1', 名称: '正义审判真实伤害', 执行: 测试正义审判被动 },
  { 序号: 1, 命令: '利尔1-2', 名称: '正义审判面向安全', 执行: 测试正义审判面向安全 },
  { 序号: 2, 命令: '利尔2', 名称: '裂地斩', 执行: 测试裂地斩 },
  { 序号: 3, 命令: '利尔3', 名称: '审判拷问背对离位', 执行: 测试审判拷问 },
  { 序号: 3, 命令: '利尔3-2', 名称: '审判拷问原位安全', 执行: 测试审判拷问原位安全 },
  { 序号: 4, 命令: '利尔4', 名称: '检查无装备安全跳过', 执行: 测试检查无装备 },
  { 序号: 4, 命令: '利尔4-2', 名称: '检查有装备正常完成', 执行: 测试检查正常 },
  { 序号: 5, 命令: '利尔5', 名称: '检查有装备超阈值失败', 执行: 测试检查失败 },
];

注册Boss测试命令组({
  命令单位名: '利尔伯特',
  Boss名称: '利尔·伯特',
  场地: { 正式中心: { x: 测试中心X, y: 测试中心Y }, 测试空地中心: { x: 测试中心X, y: 测试中心Y } },
  创建或获取上下文: 创建或获取利尔伯特测试上下文,
  清理上下文: 清理利尔伯特测试上下文,
  技能命令列表: 利尔伯特测试技能列表,
});
