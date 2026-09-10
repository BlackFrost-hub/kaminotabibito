/** @noSelfInFile */

const jass = require("jass.common") as any;
const jassGlobals = require("jass.globals") as { udg_WYDW?: any; [key: string]: any };

const { 注册物品技能事件监听 } = require("系统.00．核心系统.01．事件中心.13．物品技能事件中心") as {
  注册物品技能事件监听: (this: void, callback: (this: void, 上下文: any) => void) => void;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { 玩家主副背包持有物品 } = require("系统.03．技能系统.04．快捷键技能.02．按Ctrl切换背包") as {
  玩家主副背包持有物品: (this: void, hero: any, itemTypeID: number) => boolean;
};
const { ConsumeItemTypeCountByChargesBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  ConsumeItemTypeCountByChargesBJ: (this: void, whichUnit: any, itemId: number, needCount: number) => boolean;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};
const { 创建物品并给予单位 } = require("lib.扩展函数.物品相关函数.index") as {
  创建物品并给予单位: (this: void, unit: any, itemId: number) => any;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};
const { 开始充能, 停止单位充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, 单位: any, 参数: any) => number;
  停止单位充能: (this: void, 单位: any) => boolean;
};
const {
  registerImmediateOrderListener,
  registerPointOrderListener,
  registerTargetOrderListener,
  unregisterImmediateOrderListener,
  unregisterPointOrderListener,
  unregisterTargetOrderListener,
} = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerImmediateOrderListener: (this: void, callback: (this: void, unit: any, orderId: number) => void) => void;
  registerPointOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, x: number, y: number) => void) => void;
  registerTargetOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, targetUnit: any, targetItem: any, targetDestructable: any) => void) => void;
  unregisterImmediateOrderListener: (this: void, callback: (this: void, unit: any, orderId: number) => void) => void;
  unregisterPointOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, x: number, y: number) => void) => void;
  unregisterTargetOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, targetUnit: any, targetItem: any, targetDestructable: any) => void) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

const { questDB, QuestStatus } = require("系统.08．任务系统.01．任务数据") as {
  questDB: { getPlayerQuestStatus: (playerId: number, questId: string) => string };
  QuestStatus: { COMPLETED: string };
};
const { 米亚任务ID } = require("系统.11．剧情系统.02．支线任务.02．污染之猫米亚.00．常量") as {
  米亚任务ID: number;
};

import { 鱼竿配置, type 鱼竿单位结果配置 } from "./00．鱼竿配置";
import {
  钓点区域配置表,
  钓点鱼池配置表,
  精灵城水池键,
  熔浆钓点键,
  米亚污染池键,
  米亚净水池键,
  type 钓点区域定义,
  type 钓点产物档,
} from "./00A．钓点区域配置";

const GetHeroLevel = jass.GetHeroLevel as (this: void, unit: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: number) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;
const IsTerrainPathable = jass.IsTerrainPathable as (this: void, x: number, y: number, pathingType: any) => boolean;
const GetRandomInt = jass.GetRandomInt as (this: void, low: number, high: number) => number;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => boolean;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (
  this: void,
  player: any,
  x: number,
  y: number,
  duration: number,
  message: string,
) => void;
const Player = jass.Player as (this: void, playerId: number) => any;
const PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const PATHING_TYPE_WALKABILITY = jass.PATHING_TYPE_WALKABILITY as any;
const PATHING_TYPE_FLOATABILITY = jass.PATHING_TYPE_FLOATABILITY as any;
const 鱼竿技能类型ID = 解析配置内部ID(鱼竿配置.技能ID);
/** 熔浆钓点专属鱼竿的物品类型ID；用物品技能事件带出的物品与之比对。 */
const 熔岩专属鱼竿类型ID = 解析配置内部ID(鱼竿配置.熔岩专属鱼竿物品ID);

const 本地重复刷新标记: Record<number, boolean | undefined> = {};
let 已初始化鱼竿 = false;

function 区间命中(this: void, 随机值: number, 最小值: number, 最大值: number): boolean {
  return 随机值 >= 最小值 && 随机值 <= 最大值;
}

function 是鱼竿目标水域(this: void, x: number, y: number): boolean {
  const 行走不可通行 = IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY);
  const 漂浮可通行 = !IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY);
  return 行走不可通行 === 鱼竿配置.行走不可通行 && 漂浮可通行 === 鱼竿配置.漂浮可通行;
}

/** 点是否落在钓点矩形内（边界包含）。 */
function 点在钓点矩形内(this: void, 区域: 钓点区域定义, x: number, y: number): boolean {
  return x >= 区域.左 && x <= 区域.右 && y >= 区域.下 && y <= 区域.上;
}

/** 按优先级取命中的钓点区域；未命中返回 undefined。 */
function 取钓点区域(this: void, x: number, y: number): 钓点区域定义 | undefined {
  for (let i = 0; i < 钓点区域配置表.length; i++) {
    const 区域 = 钓点区域配置表[i];
    if (点在钓点矩形内(区域, x, y)) return 区域;
  }
  return undefined;
}

/**
 * 米亚水源是否已净化。
 * 任务进度为全局共享（questDB 的 playerId 参数不参与寻址），
 * 且"净化完成"必然蕴含"米亚已击败"，故只需判定任务是否已完成。
 */
function 米亚水源已净化(this: void): boolean {
  const 状态 = questDB.getPlayerQuestStatus(0, 米亚任务ID.toString());
  return 状态 === QuestStatus.COMPLETED;
}

/** 取该钓点当前生效的鱼池（精灵城水池按米亚任务状态切换）。 */
function 取钓点鱼池(this: void, 区域: 钓点区域定义): readonly 钓点产物档[] {
  if (区域.键 === 精灵城水池键) {
    const 池键 = 米亚水源已净化() ? 米亚净水池键 : 米亚污染池键;
    return 钓点鱼池配置表[池键] ?? [];
  }
  return 钓点鱼池配置表[区域.键] ?? [];
}

/** 把回落区间的掷骰值线性映射到通用表 1–100。 */
function 映射回落值(this: void, 随机值: number, 最小值: number, 最大值: number): number {
  const 跨度 = 最大值 - 最小值 + 1;
  if (跨度 <= 0) return 1;
  const 映射值 = Math.floor((随机值 - 最小值) * 100 / 跨度) + 1;
  if (映射值 < 1) return 1;
  if (映射值 > 100) return 100;
  return 映射值;
}

function 读取重复刷新标记(this: void, 索引: number): boolean {
  const 外部标记表 = jassGlobals.udg_WYDW;
  if (外部标记表 != null) {
    const 外部标记 = 外部标记表[索引];
    if (外部标记 != null) return 外部标记 > 0;
  }
  return 本地重复刷新标记[索引] === true;
}

function 写入重复刷新标记(this: void, 索引: number): void {
  本地重复刷新标记[索引] = true;
  const 外部标记表 = jassGlobals.udg_WYDW;
  if (外部标记表 != null) 外部标记表[索引] = 1;
}

function 读取单位结果所有者(this: void, 所有者: 鱼竿单位结果配置["所有者"]): any {
  if (所有者 === "中立敌对") return Player(PLAYER_NEUTRAL_AGGRESSIVE);
  if (所有者 === "中立被动") return Player(PLAYER_NEUTRAL_PASSIVE);
  return Player(6);
}

function 英雄等级满足(this: void, 配置: 鱼竿单位结果配置, 英雄等级: number): boolean {
  if (配置.最高英雄等级 != null && 英雄等级 > 配置.最高英雄等级) return false;
  if (配置.最低英雄等级 != null && 英雄等级 <= 配置.最低英雄等级) return false;
  return true;
}

function 创建鱼竿单位结果(this: void, 施法单位: any, 目标X: number, 目标Y: number, 配置: 鱼竿单位结果配置): any {
  if (配置.重复刷新标记索引 != null && 读取重复刷新标记(配置.重复刷新标记索引)) return null;

  const 使用目标点 = 配置.使用目标点 === true;
  const 创建X = 使用目标点 ? 目标X : 配置.创建X;
  const 创建Y = 使用目标点 ? 目标Y : 配置.创建Y;
  const 面向角度 = 使用目标点
    ? 两点角度(目标X, 目标Y, GetUnitX(施法单位), GetUnitY(施法单位))
    : 配置.创建面向角度;
  const 单位类型ID = 解析配置内部ID(配置.单位ID);
  if (单位类型ID === 0) return null;

  const 单位 = 创建单位并登记排泄安全(
    读取单位结果所有者(配置.所有者),
    单位类型ID,
    创建X,
    创建Y,
    面向角度,
  );
  if (单位 == null || 单位 === 0) return null;

  if (配置.魔抗 != null) {
    YDUserDataSetSafe("unit", 单位, "魔抗", "real", 配置.魔抗);
  }
  if (配置.重复刷新标记索引 != null) {
    写入重复刷新标记(配置.重复刷新标记索引);
  }
  if (配置.是否把施法者移动到创建点 === true && 配置.施法者移动X != null && 配置.施法者移动Y != null) {
    SetUnitPosition(施法单位, 配置.施法者移动X, 配置.施法者移动Y);
  }
  return 单位;
}

/** 隐藏遭遇是否已被触发（整局仅一次，全场共用；模块级状态，一局内有效）。 */
let 隐藏遭遇已触发 = false;

/**
 * 熔浆钓点的隐藏遭遇：携带材料抛竿时，消耗材料、改钓出单位而不是鱼。
 * 返回 true 表示本次抛竿已被隐藏遭遇接管，调用方应直接结束本次结算。
 *
 * 只对熔浆钓点生效（区域键精确匹配），因此不会影响其它水域与其它钓点。
 * 整局仅一次：第一个满足条件的人钓走后，后面的人不再触发（见 配置.整局仅一次）。
 */
function 处理隐藏遭遇(this: void, 施法单位: any, 区域: 钓点区域定义, 目标X: number, 目标Y: number): boolean {
  const 配置 = 鱼竿配置.隐藏遭遇;
  if (配置 == null) return false;
  if (区域.键 !== 熔浆钓点键) return false;
  if (配置.整局仅一次 === true && 隐藏遭遇已触发) return false;

  const 材料类型ID = 解析配置内部ID(配置.要求材料物品ID);
  if (材料类型ID === 0) return false;
  if (!玩家主副背包持有物品(施法单位, 材料类型ID)) return false;
  if (!ConsumeItemTypeCountByChargesBJ(施法单位, 材料类型ID, 配置.消耗数量)) return false;

  隐藏遭遇已触发 = true;

  const 单位类型ID = 解析配置内部ID(配置.产出单位ID);
  if (单位类型ID !== 0) {
    const 面向角度 = 两点角度(目标X, 目标Y, GetUnitX(施法单位), GetUnitY(施法单位));
    创建单位并登记排泄安全(读取单位结果所有者("中立敌对"), 单位类型ID, 目标X, 目标Y, 面向角度);
  }
  createTimedEffect(鱼竿配置.成功特效路径, 目标X, 目标Y, 0, 鱼竿配置.成功特效持续秒);
  显示鱼竿提示(施法单位, 配置.触发提示);
  return true;
}

function 显示鱼竿提示(this: void, 施法单位: any, 文本: string): void {
  const 玩家 = GetOwningPlayer(施法单位);
  if (玩家 == null || 玩家 === 0) return;
  DisplayTimedTextToPlayer(玩家, 0, 0, 5, "|cFFFFFF00『系统提示』：|r" + 文本);
}

function 显示鱼竿失败(this: void, 施法单位: any): void {
  显示鱼竿提示(施法单位, 鱼竿配置.失败提示);
}

type 鱼竿会话阶段 = "等待" | "收竿";

let 当前鱼竿等待: { 施法者: any; 目标X: number; 目标Y: number; 充能ID: number; 阶段: 鱼竿会话阶段 } | null = null;

/** 收竿后吸收同一次施法的 SPELL_EFFECT，避免刚收竿又立刻抛出新竿。 */
let 本次收竿单位: any = null;

function 鱼竿收竿标记清除(this: void): void {
  本次收竿单位 = null;
}

/**
 * 通用结果结算（原有行为）。
 * 含单位结果 = false 时只走物品表：钓点回落专用，区域内禁用单位结果池（含 94–100 人类渔夫）。
 */
function 结算通用结果(this: void, 施法单位: any, 随机值: number, 目标X: number, 目标Y: number, 含单位结果: boolean): void {
  if (随机值 <= 5) {
    显示鱼竿失败(施法单位);
    return;
  }

  createTimedEffect(鱼竿配置.成功特效路径, 目标X, 目标Y, 0, 鱼竿配置.成功特效持续秒);

  for (let i = 0; i < 鱼竿配置.物品结果列表.length; i++) {
    const 结果 = 鱼竿配置.物品结果列表[i];
    if (!区间命中(随机值, 结果.随机最小值, 结果.随机最大值)) continue;
    const 物品类型ID = 解析配置内部ID(结果.物品ID);
    if (物品类型ID !== 0) 创建物品并给予单位(施法单位, 物品类型ID);
    break;
  }

  if (!含单位结果) return;

  const 英雄等级 = GetHeroLevel(施法单位);
  for (let i = 0; i < 鱼竿配置.单位结果列表.length; i++) {
    const 结果 = 鱼竿配置.单位结果列表[i];
    if (!区间命中(随机值, 结果.随机最小值, 结果.随机最大值)) continue;
    if (!英雄等级满足(结果, 英雄等级)) continue;
    创建鱼竿单位结果(施法单位, 目标X, 目标Y, 结果);
  }
}

/** 钓点区域结算：单次掷骰落在哪个档就产出该档；档无物品则回落通用物品池。 */
function 结算钓点产物(
  this: void,
  施法单位: any,
  区域: 钓点区域定义,
  随机值: number,
  目标X: number,
  目标Y: number,
): void {
  // 隐藏遭遇优先：熔浆钓点携带指定材料时，改钓出单位，完全不走区域鱼池。
  if (处理隐藏遭遇(施法单位, 区域, 目标X, 目标Y)) return;

  const 档列表 = 取钓点鱼池(区域);
  for (let i = 0; i < 档列表.length; i++) {
    const 档 = 档列表[i];
    if (!区间命中(随机值, 档.随机最小值, 档.随机最大值)) continue;

    if (档.物品ID == null) {
      const 回落值 = 映射回落值(随机值, 档.随机最小值, 档.随机最大值);
      结算通用结果(施法单位, 回落值, 目标X, 目标Y, false);
      return;
    }

    createTimedEffect(鱼竿配置.成功特效路径, 目标X, 目标Y, 0, 鱼竿配置.成功特效持续秒);
    const 物品类型ID = 解析配置内部ID(档.物品ID);
    if (物品类型ID !== 0) 创建物品并给予单位(施法单位, 物品类型ID);
    return;
  }
}

function 结算鱼竿结果(this: void, 施法单位: any, 目标X: number, 目标Y: number): void {
  const 随机值 = GetRandomInt(鱼竿配置.随机最小值, 鱼竿配置.随机最大值);

  // 钓点区域优先：命中区域时只走该区域鱼池，完全不走通用单位结果池。
  const 区域 = 取钓点区域(目标X, 目标Y);
  if (区域 != null) {
    结算钓点产物(施法单位, 区域, 随机值, 目标X, 目标Y);
    return;
  }

  结算通用结果(施法单位, 随机值, 目标X, 目标Y, true);
}

let 收竿监听已注册 = false;

function 绑定鱼竿收竿监听(this: void): void {
  if (收竿监听已注册) return;
  收竿监听已注册 = true;
  registerImmediateOrderListener(on鱼竿立即指令);
  registerPointOrderListener(on鱼竿点指令);
  registerTargetOrderListener(on鱼竿目标指令);
}

function 解绑鱼竿收竿监听(this: void): void {
  if (!收竿监听已注册) return;
  收竿监听已注册 = false;
  unregisterImmediateOrderListener(on鱼竿立即指令);
  unregisterPointOrderListener(on鱼竿点指令);
  unregisterTargetOrderListener(on鱼竿目标指令);
}

function 鱼竿收竿结算(this: void, 会话: { 施法者: any; 目标X: number; 目标Y: number; 充能ID: number; 阶段: 鱼竿会话阶段 }): void {
  解绑鱼竿收竿监听();
  当前鱼竿等待 = null;
  本次收竿单位 = 会话.施法者;
  addDelayedCallback(200, 鱼竿收竿标记清除);
  停止单位充能(会话.施法者);
  结算鱼竿结果(会话.施法者, 会话.目标X, 会话.目标Y);
}

function 尝试鱼竿指令收竿(this: void, 单位: any): void {
  const 会话 = 当前鱼竿等待;
  if (会话 == null || 会话.阶段 !== "收竿" || 会话.施法者 !== 单位) return;
  if (单位 == null || 单位 === 0 || IsUnitType(单位, jass.UNIT_TYPE_DEAD)) return;
  鱼竿收竿结算(会话);
}

function on鱼竿立即指令(this: void, 单位: any, _orderId: number): void {
  尝试鱼竿指令收竿(单位);
}

function on鱼竿点指令(this: void, 单位: any, _orderId: number, _x: number, _y: number): void {
  尝试鱼竿指令收竿(单位);
}

function on鱼竿目标指令(this: void, 单位: any, _orderId: number, _targetUnit: any, _targetItem: any, _targetDestructable: any): void {
  尝试鱼竿指令收竿(单位);
}

function 处理鱼竿咬钩(this: void, _施法单位: any, 充能ID: number): void {
  const 会话 = 当前鱼竿等待;
  if (会话 == null || 会话.充能ID !== 充能ID || 会话.阶段 !== "等待") return;
  if (会话.施法者 == null || 会话.施法者 === 0 || IsUnitType(会话.施法者, jass.UNIT_TYPE_DEAD)) {
    当前鱼竿等待 = null;
    return;
  }
  // 咬钩：转入收竿窗口。玩家自己指令 = 收竿（由指令监听结算）；被硬控打断 = 放生（充能 硬控中断）；超时 = 挣脱。
  会话.阶段 = "收竿";
  const 收竿充能ID = 开始充能(会话.施法者, {
    持续时间: 鱼竿配置.收竿窗口毫秒 / 1000,
    指令中断: false,
    硬控中断: true,
    // 钓鱼只显示世界坐标进度UI，关掉默认的单位头顶进度条特效，避免两条进度条重叠
    显示进度条特效: false,
    世界坐标进度UI: true,
    世界坐标进度UI标题: 鱼竿配置.收竿窗口UI标题,
    世界坐标进度UI类型: 鱼竿配置.等待窗口UI类型 as any,
    充能完成回调: 处理鱼竿收竿超时,
    结束回调: 处理鱼竿等待结束,
  });
  if (收竿充能ID <= 0) {
    当前鱼竿等待 = null;
    return;
  }
  会话.充能ID = 收竿充能ID;
  绑定鱼竿收竿监听();
}

function 处理鱼竿收竿超时(this: void, _施法单位: any, 充能ID: number): void {
  const 会话 = 当前鱼竿等待;
  if (会话 == null || 会话.充能ID !== 充能ID || 会话.阶段 !== "收竿") return;
  当前鱼竿等待 = null;
  解绑鱼竿收竿监听();
  if (会话.施法者 == null || 会话.施法者 === 0) return;
  if (!IsUnitType(会话.施法者, jass.UNIT_TYPE_DEAD)) {
    显示鱼竿提示(会话.施法者, 鱼竿配置.收竿超时提示);
  }
}

function 处理鱼竿等待结束(this: void, _施法单位: any, 原因: string, 充能ID: number): void {
  const 会话 = 当前鱼竿等待;
  if (会话 == null || 会话.充能ID !== 充能ID) return;
  当前鱼竿等待 = null;
  // 收竿窗口被硬控/死亡打断：鱼放生，不结算（玩家自己指令收竿由指令监听独立结算）。
  if (会话.阶段 === "收竿") {
    解绑鱼竿收竿监听();
    if (原因 === "中断" && 会话.施法者 != null && 会话.施法者 !== 0 && !IsUnitType(会话.施法者, jass.UNIT_TYPE_DEAD)) {
      显示鱼竿提示(会话.施法者, 鱼竿配置.收竿超时提示);
    }
  }
}

/**
 * 鱼竿入口：走「物品技能事件」而不是裸 SPELL_EFFECT。
 *
 * 该事件天然同时携带**物品**（来自 `GetManipulatedItem()`）与**技能ID**（事件中心在
 * SPELL_EFFECT 阶段按施法者缓存后补上），目标坐标也是当时即时捕获的。
 * 于是"用的是哪根鱼竿"无需扫描背包即可判定 —— 这正是熔岩专属鱼竿的天然判据。
 */
function 处理鱼竿物品技能(this: void, 上下文: any): void {
  if (上下文 == null) return;

  const 施法单位 = 上下文.施法单位;
  if (施法单位 == null || 施法单位 === 0) return;
  if (上下文.技能ID !== 鱼竿技能类型ID) return;

  // 收竿指令已由指令监听在施法下单时结算，这里吸收同一次施放的物品技能事件，避免刚收竿又抛新竿。
  if (本次收竿单位 != null && 本次收竿单位 === 施法单位) return;

  // 目标坐标由事件中心在 SPELL_EFFECT 阶段即时捕获后随上下文传入，等价于原先的即时读取。
  const 目标X = 上下文.目标X;
  const 目标Y = 上下文.目标Y;

  // 先判钓点区域：命中即放行，跳过水域判定。
  // （熔浆等区域的水面不满足"可漂浮"，若先判水域会导致这些钓点在逻辑上不可达。）
  const 区域 = 取钓点区域(目标X, 目标Y);
  if (区域 == null && !是鱼竿目标水域(目标X, 目标Y)) return;

  // 熔浆钓点要求熔岩专属鱼竿：用事件带出的物品直接判定。
  if (区域 != null && 区域.键 === 熔浆钓点键) {
    if (GetItemTypeId(上下文.物品) !== 熔岩专属鱼竿类型ID) {
      显示鱼竿提示(施法单位, 鱼竿配置.熔岩专属鱼竿提示);
      return;
    }
  }

  const 等待毫秒 = GetRandomInt(鱼竿配置.等待窗口毫秒最小值, 鱼竿配置.等待窗口毫秒最大值);
  if (等待毫秒 <= 0) return;

  // 等待窗口期间再抛竿：先收掉旧窗口，避免叠出多套进度 UI。
  停止单位充能(施法单位);
  const 充能ID = 开始充能(施法单位, {
    持续时间: 等待毫秒 / 1000,
    指令中断: true,
    // 钓鱼只显示世界坐标进度UI，关掉默认的单位头顶进度条特效，避免两条进度条重叠
    显示进度条特效: false,
    世界坐标进度UI: true,
    世界坐标进度UI标题: 鱼竿配置.等待窗口UI标题,
    世界坐标进度UI类型: 鱼竿配置.等待窗口UI类型 as any,
    充能完成回调: 处理鱼竿咬钩,
    结束回调: 处理鱼竿等待结束,
  });
  if (充能ID > 0) {
    当前鱼竿等待 = { 施法者: 施法单位, 目标X, 目标Y, 充能ID, 阶段: "等待" };
  }
}

export function init鱼竿(this: void): void {
  if (已初始化鱼竿) return;
  已初始化鱼竿 = true;
  注册物品技能事件监听(处理鱼竿物品技能);
}

export {};
