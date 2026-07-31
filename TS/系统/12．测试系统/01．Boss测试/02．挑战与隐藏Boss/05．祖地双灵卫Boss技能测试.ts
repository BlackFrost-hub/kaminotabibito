/** @noSelfInFile */

import type { Boss测试技能命令 } from '../../00．Boss测试系统/00．Boss测试类型';

const jass = require('jass.common') as any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const japi = require('jass.japi') as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const globals = require('jass.globals') as { udg_Boss?: any; [key: string]: any };
const { debugLogForce } = require('lib.扩展函数.自定义扩展函数.03．调试输出') as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

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
const { X_RestoreUnitStandingSafe, X_FixUnitStandingSafe } = require('lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版') as {
  X_RestoreUnitStandingSafe: (this: void, unit: any) => void;
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
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
const { 祖地双灵卫数值与表现配置 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置') as {
  祖地双灵卫数值与表现配置: any;
};
const { 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  移除单位指定Buff: (this: void, unit: any, buffId: string) => boolean;
};
const { 祖地双灵卫BuffID } = require('系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.05．祖地双灵卫') as {
  祖地双灵卫BuffID: any;
};
const { 注册祖地双灵卫被动效果 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.11．被动效果') as {
  注册祖地双灵卫被动效果: (this: void) => void;
};
const { 获取或创建祖地双灵卫运行时上下文, 清理祖地双灵卫运行时上下文 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文') as {
  获取或创建祖地双灵卫运行时上下文: (this: void, unit: any) => any;
  清理祖地双灵卫运行时上下文: (this: void, context: any) => void;
};
const { 绑定祖地双灵卫侵蚀生命下限 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.05．侵蚀择形') as {
  绑定祖地双灵卫侵蚀生命下限: (this: void, context: any) => void;
};
const { 绑定祖地双灵卫同息生命下限 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.09．同息归寂') as {
  绑定祖地双灵卫同息生命下限: (this: void, context: any) => void;
};
const { 更新祖地双灵卫侵蚀阶段 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.05．侵蚀择形') as {
  更新祖地双灵卫侵蚀阶段: (this: void, context: any, now?: number) => void;
};
const { 更新祖地双灵卫双钥净化 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.07．双钥净化') as {
  更新祖地双灵卫双钥净化: (this: void, context: any, now?: number) => void;
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
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const PauseUnit = jass.PauseUnit as (unit: any, flag: boolean) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const Rect = jass.Rect as (minX: number, minY: number, maxX: number, maxY: number) => any;
const RemoveRect = jass.RemoveRect as (rect: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
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
const 祖地双灵卫被动测试日志模块 = '祖地双灵卫-13/14/15验证';

function 取双灵卫测试生命比例(this: void, unit: any): number {
  const maxLife = unit != null && unit !== 0 ? GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) : 0;
  return maxLife > 0 ? GetUnitState(unit, UNIT_STATE_LIFE) / maxLife : 0;
}

function 记录双灵卫被动测试结果(
  this: void,
  命令: string,
  context: 祖地双灵卫测试上下文,
  预期: string,
  原始伤害比例: number,
  伤害调用成功: boolean,
  准备阶段: string,
  准备赤誓生命比例: number,
  准备苍影生命比例: number,
): void {
  const runtime = context.运行时;
  const redMaxLife = GetUnitStateJapi(context.赤誓灵卫单位, UNIT_STATE_MAX_LIFE);
  const azureMaxLife = GetUnitStateJapi(context.苍影灵卫单位, UNIT_STATE_MAX_LIFE);
  const redLife = GetUnitState(context.赤誓灵卫单位, UNIT_STATE_LIFE);
  const azureLife = GetUnitState(context.苍影灵卫单位, UNIT_STATE_LIFE);
  const redRatio = redMaxLife > 0 ? redLife / redMaxLife : 0;
  const azureRatio = azureMaxLife > 0 ? azureLife / azureMaxLife : 0;
  let lifeDiff = redRatio - azureRatio;
  if (lifeDiff < 0) lifeDiff = -lifeDiff;
  const publicConfig = 祖地双灵卫数值与表现配置.公共;
  const expectedLowDamageRatio = (1 - publicConfig.同誓低血减伤比例) * (1 - publicConfig.同誓高血分担比例);
  const expectedSharedDamageRatio = (1 - publicConfig.同誓低血减伤比例) * publicConfig.同誓高血分担比例;
  const erosionControllers = (runtime.侵蚀生命下限保护列表 ?? []) as any[];
  const collapseControllers = (runtime.同息生命下限保护列表 ?? []) as any[];
  const redErosionController = erosionControllers[0];
  const azureErosionController = erosionControllers[1];
  const redCollapseController = collapseControllers[0];
  const azureCollapseController = collapseControllers[1];
  const redMember = runtime.联合生命周期.取成员('赤誓灵卫');
  const azureMember = runtime.联合生命周期.取成员('苍影灵卫');
  debugLogForce(
    祖地双灵卫被动测试日志模块,
    '命令', 命令,
    '预期', 预期,
    '准备阶段', 准备阶段,
    '准备赤誓生命比例', 准备赤誓生命比例,
    '准备苍影生命比例', 准备苍影生命比例,
    '阶段', runtime.阶段,
    '赤誓形态', runtime.赤誓灵卫形态,
    '苍影形态', runtime.苍影灵卫形态,
    '赤誓当前生命', redLife,
    '赤誓最大生命', redMaxLife,
    '赤誓生命比例', redRatio,
    '苍影当前生命', azureLife,
    '苍影最大生命', azureMaxLife,
    '苍影生命比例', azureRatio,
    '生命差', lifeDiff,
    '双灵同誓触发阈值', publicConfig.双灵同誓触发生命差,
    '双灵同誓解除阈值', publicConfig.双灵同誓解除生命差,
    '双灵同誓启用', runtime.同誓保护已启用,
    '低血守卫', runtime.低血保护守卫,
    '保护特效', runtime.同誓保护特效 != null && runtime.同誓保护特效 !== 0,
    '暗金连线', runtime.同誓暗金连线 != null,
    '冷蓝连线', runtime.同誓冷蓝连线 != null,
    '侵蚀目标下限比例', 祖地双灵卫单位技能配置.阶段阈值.首次变异生命比例,
    '同息目标下限比例', 祖地双灵卫单位技能配置.阶段阈值.灵魂崩解生命比例,
    '侵蚀锁血-赤誓', redErosionController?.是否生效(), '已触底', redErosionController?.是否已触底(), '下限', redErosionController?.读取生命下限(),
    '侵蚀锁血-苍影', azureErosionController?.是否生效(), '已触底', azureErosionController?.是否已触底(), '下限', azureErosionController?.读取生命下限(),
    '同息锁血-赤誓', redCollapseController?.是否生效(), '已触底', redCollapseController?.是否已触底(), '下限', redCollapseController?.读取生命下限(),
    '同息锁血-苍影', azureCollapseController?.是否生效(), '已触底', azureCollapseController?.是否已触底(), '下限', azureCollapseController?.读取生命下限(),
    '联合状态-赤誓', redMember?.状态,
    '联合状态-苍影', azureMember?.状态,
    '崩解中的守卫', runtime.崩解中的守卫,
    '崩解截止Ms', runtime.崩解截止时间Ms,
    'P3共鸣层数', runtime.P3共鸣层数,
    '本次原始伤害比例', 原始伤害比例,
    '本次伤害类型', '魔法',
    '本次伤害调用成功', 伤害调用成功,
    '预期低血最终伤害比例', expectedLowDamageRatio,
    '预期高血分担伤害比例', expectedSharedDamageRatio,
  );
}

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
  // 测试场景没有正式 Boss 启动事件，必须在这里显式绑定两个生命下限控制器。
  绑定祖地双灵卫侵蚀生命下限(runtime);
  绑定祖地双灵卫同息生命下限(runtime);

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

function 清理祖地双灵卫镇魂印(this: void, runtime: any): void {
  const seal = runtime?.镇魂印;
  if (seal?.区域实例 != null) seal.区域实例.销毁();
  else if (seal?.特效 != null && seal.特效 !== 0) DestroyEffect(seal.特效);
  runtime.镇魂印 = undefined;
}

function 重置祖地双灵卫P1(this: void, context: 祖地双灵卫测试上下文): void {
  const runtime = context.运行时;
  const cfg = 祖地双灵卫单位技能配置.单位;
  const erosionControllers = (runtime.侵蚀生命下限保护列表 ?? []) as any[];
  const collapseControllers = (runtime.同息生命下限保护列表 ?? []) as any[];
  for (let i = 0; i < erosionControllers.length; i++) {
    const controller = erosionControllers[i];
    if (controller != null) controller.重置触底状态();
  }
  for (let i = 0; i < collapseControllers.length; i++) {
    const controller = collapseControllers[i];
    if (controller != null) controller.重置触底状态();
  }
  const units = [context.赤誓灵卫单位, context.苍影灵卫单位];
  const names = ['赤誓灵卫', '苍影灵卫'];
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    PauseUnit(unit, false);
    SetUnitInvulnerable(unit, false);
    移除单位指定Buff(unit, 祖地双灵卫BuffID.双灵同誓);
    移除单位指定Buff(unit, 祖地双灵卫BuffID.双蚀共鸣);
    移除单位指定Buff(unit, 祖地双灵卫BuffID.灵魂崩解);
    移除单位指定Buff(unit, 祖地双灵卫BuffID.净化反冲);
    const member = runtime.联合生命周期.取成员(names[i]);
    if (member != null && member.状态 !== '活跃') runtime.联合生命周期.设置状态(names[i], '活跃', '测试重置');
  }
  if (runtime.誓盾 != null && runtime.誓盾.特效 != null && runtime.誓盾.特效 !== 0) DestroyEffect(runtime.誓盾.特效);
  runtime.誓盾 = undefined;
  清理祖地双灵卫镇魂印(runtime);
  const 净化节点列表 = runtime.净化节点列表 as any[];
  for (let i = 0; i < 净化节点列表.length; i++) {
    const node = 净化节点列表[i];
    if (node.特效 != null && node.特效 !== 0) DestroyEffect(node.特效);
    node.特效 = undefined;
    node.表现阶段 = undefined;
    node.阶段 = '未激活';
    node.校准截止Ms = 0;
    node.重试允许Ms = 0;
  }
  runtime.阶段 = 'P1双灵守门';
  runtime.赤誓灵卫形态 = '正常';
  runtime.苍影灵卫形态 = '正常';
  runtime.首次变异守卫 = undefined;
  runtime.崩解中的守卫 = undefined;
  runtime.崩解截止时间Ms = 0;
  runtime.大型技能占用者 = undefined;
  runtime.大型机制忙碌到Ms = 0;
  runtime.当前净化节点序号 = 0;
  runtime.已净化节点数量 = 0;
  runtime.P3共鸣层数 = 祖地双灵卫数值与表现配置.P3.净化节点数量;
  runtime.净化易伤到Ms = 0;
  runtime.最终结算待处理 = false;
  runtime.封门误判待触发 = false;
  DzSetUnitModel(context.赤誓灵卫单位, cfg.赤誓灵卫.正常模型路径);
  DzSetUnitModel(context.苍影灵卫单位, cfg.苍影灵卫.正常模型路径);
  SetUnitScale(context.赤誓灵卫单位, cfg.赤誓灵卫.正常模型缩放, cfg.赤誓灵卫.正常模型缩放, cfg.赤誓灵卫.正常模型缩放);
  SetUnitScale(context.苍影灵卫单位, cfg.苍影灵卫.正常模型缩放, cfg.苍影灵卫.正常模型缩放, cfg.苍影灵卫.正常模型缩放);
  设置Boss测试单位满血(context.赤誓灵卫单位);
  设置Boss测试单位满血(context.苍影灵卫单位);
  更新祖地双灵同誓(runtime);
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
  释放灵印折步(context.运行时, 最近测试山丘之王[GetPlayerId(_player)]);
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
  const runtime = context.运行时;
  runtime.当前净化节点序号 = 1;
  runtime.已净化节点数量 = 0;
  let node: any = undefined;
  const nodes = runtime.净化节点列表;
  if (nodes != null) {
    for (const candidate of nodes) {
      if (candidate != null && candidate.序号 === 1) {
        node = candidate;
        break;
      }
    }
  }
  if (node != null) {
    node.阶段 = '校准';
    node.校准截止Ms = 0;
    X_RestoreUnitStandingSafe(context.目标单位);
    SetUnitPosition(context.目标单位, node.X, node.Y);
    X_FixUnitStandingSafe(context.目标单位);
    更新祖地双灵卫双钥净化(context.运行时);
  }
  释放失名祷潮(context.运行时, context.目标单位);
}
function 测试双灵卫失名祷潮无镇魂印(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P2苍影先变异(context);
  清理祖地双灵卫镇魂印(context.运行时);
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

function 施加双灵卫测试伤害(this: void, context: 祖地双灵卫测试上下文, target: any, 目标最大生命比例: number): boolean {
  const maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE);
  if (maxLife <= 0 || 目标最大生命比例 <= 0) return false;
  return UnitDamageTarget(context.目标单位, target, maxLife * 目标最大生命比例, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
}

function 测试双灵卫同誓被动(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  const redMax = GetUnitStateJapi(context.赤誓灵卫单位, UNIT_STATE_MAX_LIFE);
  const azureMax = GetUnitStateJapi(context.苍影灵卫单位, UNIT_STATE_MAX_LIFE);
  // P1 的侵蚀生命下限是 65%；使用 70% 可保留 P1，同时验证超过 15% 的同誓触发差值。
  SetUnitState(context.赤誓灵卫单位, UNIT_STATE_LIFE, redMax * 0.7);
  SetUnitState(context.苍影灵卫单位, UNIT_STATE_LIFE, azureMax);
  更新祖地双灵同誓(context.运行时);
  const preparedRedRatio = 取双灵卫测试生命比例(context.赤誓灵卫单位);
  const preparedAzureRatio = 取双灵卫测试生命比例(context.苍影灵卫单位);
  const damageApplied = 施加双灵卫测试伤害(context, context.赤誓灵卫单位, 0.1);
  记录双灵卫被动测试结果('13', context, 'P1，赤誓70%、苍影100%，生命差30%触发双灵同誓，施加10%最大生命魔法伤害观察55%减伤与25%分担', 0.1, damageApplied, 'P1双灵守门', preparedRedRatio, preparedAzureRatio);
}

function 测试双灵卫侵蚀锁血被动(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  重置祖地双灵卫P1(context);
  const preparedRedRatio = 取双灵卫测试生命比例(context.赤誓灵卫单位);
  const preparedAzureRatio = 取双灵卫测试生命比例(context.苍影灵卫单位);
  const damageApplied = 施加双灵卫测试伤害(context, context.赤誓灵卫单位, 0.9);
  记录双灵卫被动测试结果('14', context, 'P1满血承受90%最大生命伤害，赤誓锁在65%并首次变异进入P2', 0.9, damageApplied, 'P1双灵守门', preparedRedRatio, preparedAzureRatio);
}

function 测试双灵卫同息锁血被动(this: void, _player: any, context: 祖地双灵卫测试上下文): void {
  准备祖地双灵卫P3(context);
  const preparedRedRatio = 取双灵卫测试生命比例(context.赤誓灵卫单位);
  const preparedAzureRatio = 取双灵卫测试生命比例(context.苍影灵卫单位);
  const damageApplied = 施加双灵卫测试伤害(context, context.赤誓灵卫单位, 0.8);
  addDelayedCallback(0, function 双灵卫15延迟验证日志(this: void): void {
    记录双灵卫被动测试结果('15', context, 'P3双蚀共鸣，赤誓锁在5%并进入暂停、无敌、灵魂崩解', 0.8, damageApplied, 'P3双蚀共鸣', preparedRedRatio, preparedAzureRatio);
  });
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
  { 序号: 10, 命令: '10-2', 名称: '苍影失名祷潮（P2正常伤害）', 执行: 测试双灵卫失名祷潮无镇魂印 },
  { 序号: 10, 命令: '10-3', 名称: '苍影失名祷潮（P3校准净化）', 执行: 测试双灵卫失名祷潮P3 },
  { 序号: 11, 名称: '苍影记忆剥落', 执行: 测试双灵卫记忆剥落 },
  { 序号: 12, 名称: 'P3封门误判', 执行: 测试双灵卫封门误判 },
  { 序号: 13, 名称: '被动：双灵同誓减伤与分担', 执行: 测试双灵卫同誓被动 },
  { 序号: 14, 名称: '被动：侵蚀阶段生命下限', 执行: 测试双灵卫侵蚀锁血被动 },
  { 序号: 15, 名称: '被动：同息归寂生命下限', 执行: 测试双灵卫同息锁血被动 },
];

注册Boss测试命令组({
  命令单位名: '双灵卫',
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
