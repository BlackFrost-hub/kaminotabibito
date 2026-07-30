/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
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
const { 创建Boss战运行上下文, 记录Boss战运行上下文, 读取Boss战运行上下文, 清理Boss战运行上下文 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文') as {
  创建Boss战运行上下文: (this: void, boss: any, rect: any, battleMusic: any, victoryMusic: any) => any;
  记录Boss战运行上下文: (this: void, context: any) => void;
  读取Boss战运行上下文: (this: void, boss: any) => any;
  清理Boss战运行上下文: (this: void, boss: any) => void;
};
const { 祖地双灵卫单位技能配置 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.00．配置') as {
  祖地双灵卫单位技能配置: any;
};
const { 注册祖地双灵卫被动效果 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.11．被动效果') as {
  注册祖地双灵卫被动效果: (this: void) => void;
};
const { 获取或创建祖地双灵卫运行时上下文, 清理祖地双灵卫运行时上下文 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文') as {
  获取或创建祖地双灵卫运行时上下文: (this: void, unit: any) => any;
  清理祖地双灵卫运行时上下文: (this: void, context: any) => void;
};
const { 更新祖地双灵卫侵蚀阶段 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.05．侵蚀择形') as {
  更新祖地双灵卫侵蚀阶段: (this: void, context: any, now?: number) => void;
};
const { 更新祖地双灵同誓 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.03．双灵同誓') as {
  更新祖地双灵同誓: (this: void, context: any, now?: number) => void;
};
const { 释放灵印折步, 创建赤誓镇魂印 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.01．灵印折步') as {
  释放灵印折步: (this: void, context: any, target: any) => boolean;
  创建赤誓镇魂印: (this: void, context: any, x: number, y: number) => void;
};
const { 释放月纹缚魂 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.02．月纹缚魂') as {
  释放月纹缚魂: (this: void, context: any, target?: any) => boolean;
};
const { 释放断誓践踏 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.03．断誓践踏') as {
  释放断誓践踏: (this: void, context: any, target: any) => boolean;
};
const { 释放裂魂坠斩 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．赤誓灵卫.04．裂魂坠斩') as {
  释放裂魂坠斩: (this: void, context: any, target: any) => boolean;
};
const { 释放誓锋壁进 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.01．誓锋壁进') as {
  释放誓锋壁进: (this: void, context: any, target: any) => boolean;
};
const { 释放盾刃裁决 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.02．盾刃裁决') as {
  释放盾刃裁决: (this: void, context: any, target: any) => boolean;
};
const { 释放失名祷潮 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.03．失名祷潮') as {
  释放失名祷潮: (this: void, context: any, target?: any) => boolean;
};
const { 释放记忆剥落 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．苍影灵卫.04．记忆剥落') as {
  释放记忆剥落: (this: void, context: any, target?: any) => boolean;
};
const { 释放祖地双灵卫封门校验 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.06．封门校验') as {
  释放祖地双灵卫封门校验: (this: void, context: any, target: any) => boolean;
};
const { 释放祖地双灵卫封门误判 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.08．封门误判') as {
  释放祖地双灵卫封门误判: (this: void, context: any) => boolean;
};

const CreateUnit = jass.CreateUnit as (owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetHeroLevel = jass.SetHeroLevel as (hero: any, level: number, showEyeCandy: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitScale = jass.SetUnitScale as (unit: any, x: number, y: number, z: number) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const Rect = jass.Rect as (minX: number, minY: number, maxX: number, maxY: number) => any;
const RemoveRect = jass.RemoveRect as (rect: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const DzSetUnitModel = japi.DzSetUnitModel as (unit: any, model: string) => void;

const 赤誓灵卫单位ID = stringToFourCCSafe(祖地双灵卫单位技能配置.单位.赤誓灵卫.单位ID);
const 苍影灵卫单位ID = stringToFourCCSafe(祖地双灵卫单位技能配置.单位.苍影灵卫.单位ID);
const 测试中心X = -540.6;
const 测试中心Y = -2495.2;
const 玩家测试X = -540.6;
const 玩家测试Y = -3055.2;
const 双灵测试半宽 = 1000;
const 双灵测试半高 = 850;

interface 祖地双灵卫测试上下文 {
  运行时: any;
  目标单位: any;
  赤誓灵卫单位: any;
  苍影灵卫单位: any;
}

const 最近赤誓灵卫: Record<number, any> = {};
const 最近苍影灵卫: Record<number, any> = {};
const 最近测试步兵: Record<number, any> = {};
const 最近测试山丘之王: Record<number, any> = {};
const 双灵测试矩形: Record<number, any> = {};

function 获取或创建双灵测试矩形(this: void, player: any): any {
  const pid = GetPlayerId(player);
  let rect = 双灵测试矩形[pid];
  if (rect == null || rect === 0) {
    rect = Rect(测试中心X - 双灵测试半宽, 测试中心Y - 双灵测试半高, 测试中心X + 双灵测试半宽, 测试中心Y + 双灵测试半高);
    双灵测试矩形[pid] = rect;
  }
  return rect;
}

function 获取或创建双灵测试Boss(this: void, player: any): { red: any; azure: any } | undefined {
  const pid = GetPlayerId(player);
  let red = 最近赤誓灵卫[pid];
  let azure = 最近苍影灵卫[pid];
  if (!Boss测试单位存活(red) || !Boss测试单位存活(azure)) {
    移除Boss测试单位(red);
    移除Boss测试单位(azure);
    red = CreateUnit(player, 赤誓灵卫单位ID, 测试中心X - 320, 测试中心Y, 270);
    azure = CreateUnit(player, 苍影灵卫单位ID, 测试中心X + 320, 测试中心Y, 270);
    最近赤誓灵卫[pid] = red;
    最近苍影灵卫[pid] = azure;
    if (Boss测试单位存活(red)) SetHeroLevel(red, 45, false);
    if (Boss测试单位存活(azure)) SetHeroLevel(azure, 45, false);
  }
  if (!Boss测试单位存活(red) || !Boss测试单位存活(azure)) return undefined;
  SetUnitPosition(red, 测试中心X - 320, 测试中心Y);
  SetUnitPosition(azure, 测试中心X + 320, 测试中心Y);
  SetUnitFacing(red, 270);
  SetUnitFacing(azure, 270);
  设置Boss测试单位满血(red);
  设置Boss测试单位满血(azure);
  标记测试Boss跳过死亡结算(red);
  标记测试Boss跳过死亡结算(azure);
  globals.udg_Boss = red;
  return { red, azure };
}

function 获取或创建双灵测试步兵(this: void, cache: Record<number, any>, player: any, x: number, y: number): any {
  const pid = GetPlayerId(player);
  const unit = 准备Boss测试固定步兵(cache[pid], x, y, 90);
  cache[pid] = unit;
  return unit;
}

function 确保双灵测试战斗矩形(this: void, player: any, unit: any): void {
  if (读取Boss战运行上下文(unit) != null) return;
  const battle = 创建Boss战运行上下文(unit, 获取或创建双灵测试矩形(player), null, null);
  if (battle != null) 记录Boss战运行上下文(battle);
}

function 创建或获取祖地双灵卫测试上下文(this: void, player: any): 祖地双灵卫测试上下文 | undefined {
  const pid = GetPlayerId(player);
  const hero = 获取Boss测试玩家基准英雄(player);
  const pair = 获取或创建双灵测试Boss(player);
  if (!Boss测试单位存活(hero) || pair == null) return undefined;

  设置Boss测试单位满血(hero);
  const target = 获取或创建双灵测试步兵(最近测试步兵, player, 玩家测试X - 220, 玩家测试Y + 180);
  最近测试山丘之王[pid] = 准备Boss测试固定山丘之王(最近测试山丘之王[pid], 玩家测试X + 220, 玩家测试Y + 180, 90);
  if (!Boss测试单位存活(target)) return undefined;

  注册祖地双灵卫被动效果();
  确保双灵测试战斗矩形(player, pair.red);
  确保双灵测试战斗矩形(player, pair.azure);
  应用Boss战启动属性配置(pair.red);
  应用Boss战启动属性配置(pair.azure);
  设置Boss测试单位满血(pair.red);
  设置Boss测试单位满血(pair.azure);
  const runtime = 获取或创建祖地双灵卫运行时上下文(pair.red);
  if (runtime == null) return undefined;

  SelectUnitForPlayerSingle(pair.red, player);
  StarOther_PanCameraToTimedForPlayer(player, 测试中心X, 测试中心Y, 0.2);
  return { 运行时: runtime, 目标单位: target, 赤誓灵卫单位: pair.red, 苍影灵卫单位: pair.azure };
}

function 清理祖地双灵卫测试上下文(this: void, player: any, context: 祖地双灵卫测试上下文): void {
  const pid = GetPlayerId(player);
  if (context != null) {
    if (context.运行时 != null) 清理祖地双灵卫运行时上下文(context.运行时);
    清理Boss战运行上下文(context.赤誓灵卫单位);
    清理Boss战运行上下文(context.苍影灵卫单位);
  }
  const rect = 双灵测试矩形[pid];
  if (rect != null && rect !== 0) RemoveRect(rect);
  移除Boss测试单位(最近测试步兵[pid]);
  移除Boss测试单位(最近测试山丘之王[pid]);
  移除Boss测试单位(最近赤誓灵卫[pid]);
  移除Boss测试单位(最近苍影灵卫[pid]);
  双灵测试矩形[pid] = undefined;
  最近测试步兵[pid] = undefined;
  最近测试山丘之王[pid] = undefined;
  最近赤誓灵卫[pid] = undefined;
  最近苍影灵卫[pid] = undefined;
  if (globals.udg_Boss === context?.赤誓灵卫单位) globals.udg_Boss = null;
}

function 重置祖地双灵卫P1(this: void, context: 祖地双灵卫测试上下文): void {
  const runtime = context.运行时;
  const cfg = 祖地双灵卫单位技能配置.单位;
  runtime.阶段 = 'P1双灵守门';
  runtime.赤誓灵卫形态 = '正常';
  runtime.苍影灵卫形态 = '正常';
  runtime.首次变异守卫 = undefined;
  runtime.大型技能占用者 = undefined;
  runtime.大型机制忙碌到Ms = 0;
  runtime.当前净化节点序号 = 0;
  runtime.已净化节点数量 = 0;
  runtime.封门误判待触发 = false;
  DzSetUnitModel(context.赤誓灵卫单位, cfg.赤誓灵卫.正常模型路径);
  DzSetUnitModel(context.苍影灵卫单位, cfg.苍影灵卫.正常模型路径);
  SetUnitScale(context.赤誓灵卫单位, cfg.赤誓灵卫.正常模型缩放, cfg.赤誓灵卫.正常模型缩放, cfg.赤誓灵卫.正常模型缩放);
  SetUnitScale(context.苍影灵卫单位, cfg.苍影灵卫.正常模型缩放, cfg.苍影灵卫.正常模型缩放, cfg.苍影灵卫.正常模型缩放);
  设置Boss测试单位满血(context.赤誓灵卫单位);
  设置Boss测试单位满血(context.苍影灵卫单位);
}

function 准备祖地双灵卫P2(this: void, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  const maxLife = GetUnitStateJapi(context.赤誓灵卫单位, UNIT_STATE_MAX_LIFE);
  SetUnitState(context.赤誓灵卫单位, UNIT_STATE_LIFE, maxLife * 0.6);
  更新祖地双灵卫侵蚀阶段(context.运行时);
}

function 准备祖地双灵卫P2苍影先变异(this: void, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  const maxLife = GetUnitStateJapi(context.苍影灵卫单位, UNIT_STATE_MAX_LIFE);
  SetUnitState(context.苍影灵卫单位, UNIT_STATE_LIFE, maxLife * 0.6);
  更新祖地双灵卫侵蚀阶段(context.运行时);
}

function 准备祖地双灵卫P3(this: void, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P2(context);
  const maxLife = GetUnitStateJapi(context.赤誓灵卫单位, UNIT_STATE_MAX_LIFE);
  SetUnitState(context.赤誓灵卫单位, UNIT_STATE_LIFE, maxLife * 0.3);
  更新祖地双灵卫侵蚀阶段(context.运行时);
}

function 测试双灵卫灵印折步(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  释放灵印折步(context.运行时, context.目标单位);
}
function 测试双灵卫月纹缚魂(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  释放月纹缚魂(context.运行时, context.目标单位);
}
function 测试双灵卫誓锋壁进(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  释放誓锋壁进(context.运行时, context.目标单位);
}
function 测试双灵卫盾刃裁决(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  释放盾刃裁决(context.运行时, context.目标单位);
}
function 测试双灵卫封门校验(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  释放祖地双灵卫封门校验(context.运行时, context.目标单位);
}
function 测试双灵卫赤誓变异(this: void, _player: any, context: 祖地双灵卫测试上下文): void { 准备祖地双灵卫P2(context); }
function 测试双灵卫断誓践踏(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P2(context);
  释放断誓践踏(context.运行时, context.目标单位);
}
function 测试双灵卫断誓践踏P3(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P3(context);
  释放断誓践踏(context.运行时, context.目标单位);
}
function 测试双灵卫裂魂坠斩(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P2(context);
  释放裂魂坠斩(context.运行时, context.目标单位);
}
function 测试双灵卫双蚀共鸣(this: void, _player: any, context: 祖地双灵卫测试上下文): void { 准备祖地双灵卫P3(context); }
function 测试双灵卫失名祷潮(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P2苍影先变异(context);
  创建赤誓镇魂印(context.运行时, GetUnitX(context.目标单位), GetUnitY(context.目标单位));
  释放失名祷潮(context.运行时, context.目标单位);
}
function 测试双灵卫失名祷潮P3(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P3(context);
  释放失名祷潮(context.运行时, context.目标单位);
}
function 测试双灵卫记忆剥落(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P2苍影先变异(context);
  释放记忆剥落(context.运行时, context.目标单位);
}
function 测试双灵卫封门误判(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P3(context);
  context.运行时.已净化节点数量 = 1;
  context.运行时.封门误判待触发 = true;
  if (context.运行时.净化节点列表[1] != null) context.运行时.净化节点列表[1].阶段 = '已净化';
  释放祖地双灵卫封门误判(context.运行时);
}

function 测试双灵卫同誓被动(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  const redMax = GetUnitStateJapi(context.赤誓灵卫单位, UNIT_STATE_MAX_LIFE);
  const azureMax = GetUnitStateJapi(context.苍影灵卫单位, UNIT_STATE_MAX_LIFE);
  SetUnitState(context.赤誓灵卫单位, UNIT_STATE_LIFE, redMax * 0.5);
  SetUnitState(context.苍影灵卫单位, UNIT_STATE_LIFE, azureMax);
  更新祖地双灵同誓(context.运行时);
}

function 测试双灵卫侵蚀锁血被动(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  const redMax = GetUnitStateJapi(context.赤誓灵卫单位, UNIT_STATE_MAX_LIFE);
  UnitDamageTarget(context.目标单位, context.赤誓灵卫单位, redMax * 0.9, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

function 测试双灵卫同息锁血被动(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P3(context);
  const redMax = GetUnitStateJapi(context.赤誓灵卫单位, UNIT_STATE_MAX_LIFE);
  UnitDamageTarget(context.目标单位, context.赤誓灵卫单位, redMax * 0.8, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
}

const 祖地双灵卫测试技能列表: Boss测试技能命令[] = [
  { 序号: 1, 名称: '赤誓灵印折步', 执行: 测试双灵卫灵印折步 },
  { 序号: 2, 名称: '赤誓月纹缚魂', 执行: 测试双灵卫月纹缚魂 },
  { 序号: 3, 名称: '苍影誓锋壁进', 执行: 测试双灵卫誓锋壁进 },
  { 序号: 4, 名称: '苍影盾刃裁决', 执行: 测试双灵卫盾刃裁决 },
  { 序号: 5, 名称: 'P1联合封门校验', 执行: 测试双灵卫封门校验 },
  { 序号: 6, 名称: 'P2赤誓侵蚀变异', 执行: 测试双灵卫赤誓变异 },
  { 序号: 7, 名称: '赤誓断誓践踏（P2盾压制）', 执行: 测试双灵卫断誓践踏 },
  { 序号: 7, 命令: '7-3', 名称: '赤誓断誓践踏（P3破壳净化）', 执行: 测试双灵卫断誓践踏P3 },
  { 序号: 8, 名称: '赤誓裂魂坠斩', 执行: 测试双灵卫裂魂坠斩 },
  { 序号: 9, 名称: 'P3双蚀共鸣', 执行: 测试双灵卫双蚀共鸣 },
  { 序号: 10, 名称: '苍影失名祷潮（P2吸收镇魂印）', 执行: 测试双灵卫失名祷潮 },
  { 序号: 10, 命令: '10-3', 名称: '苍影失名祷潮（P3校准净化）', 执行: 测试双灵卫失名祷潮P3 },
  { 序号: 11, 名称: '苍影记忆剥落', 执行: 测试双灵卫记忆剥落 },
  { 序号: 12, 名称: 'P3封门误判', 执行: 测试双灵卫封门误判 },
  { 序号: 13, 名称: '被动：双灵同誓减伤与分担', 执行: 测试双灵卫同誓被动 },
  { 序号: 14, 名称: '被动：侵蚀阶段生命下限', 执行: 测试双灵卫侵蚀锁血被动 },
  { 序号: 15, 名称: '被动：同息归寂生命下限', 执行: 测试双灵卫同息锁血被动 },
];

注册Boss测试命令组({
  命令单位名: '祖地双灵卫',
  Boss名称: '祖地双灵卫',
  场地: {
    正式中心: { x: 祖地双灵卫单位技能配置.正式场地.中心X, y: 祖地双灵卫单位技能配置.正式场地.中心Y },
    测试空地中心: { x: 测试中心X, y: 测试中心Y },
  },
  创建或获取上下文: 创建或获取祖地双灵卫测试上下文,
  清理上下文: 清理祖地双灵卫测试上下文,
  技能命令列表: 祖地双灵卫测试技能列表,
});

export {};
