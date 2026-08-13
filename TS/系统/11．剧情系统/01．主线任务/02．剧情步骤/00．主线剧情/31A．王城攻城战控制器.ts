/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { X_FixUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
};
const { GS_LoadUintProperty, GS_UnitPry } = require("lib.扩展函数.Star扩展函数.02．GS单位属性") as {
  GS_LoadUintProperty: (this: void, unit: any, propertyType: number) => number;
  GS_UnitPry: (this: void, unit: any, change: number, propertyType: number, value: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerOneShotUnitRangeListener } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerOneShotUnitRangeListener: (this: void, unit: any, range: number, callback: (this: void, enteringUnit: any) => boolean, predicate?: (this: void, enteringUnit: any) => boolean) => (this: void) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 设置全体玩家游戏失败 } = require("系统.00．核心系统.09．游戏结算开关") as {
  设置全体玩家游戏失败: (this: void) => boolean;
};

import { 读取当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 创建并冻结剧情Boss预置 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 结算耶提尔菲利斯协战 } from "./31B．耶提尔协战控制器";

const { 结束第二章菲利斯攻城区域音乐 } = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐") as {
  结束第二章菲利斯攻城区域音乐: (this: void) => boolean;
};

const AddSpecialEffect = jass.AddSpecialEffect as (this: void, modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, unit: any, order: string) => boolean;
const IssuePointOrder = jass.IssuePointOrder as (this: void, unit: any, order: string, x: number, y: number) => boolean;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, unit: any, order: string, target: any) => boolean;
const Player = jass.Player as (this: void, playerId: number) => any;
const PauseUnit = jass.PauseUnit as (this: void, unit: any, flag: boolean) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, unit: any, flag: boolean) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, unit: any, owner: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;

const 敌军玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const 友军玩家ID = 6;
const 攻城开始延迟毫秒 = 5000;
const 攻城目标重发间隔毫秒 = 1800;
const 防御法阵X = -6992.3;
const 防御法阵Y = -13170.9;
const 菲利斯出现X = -6906.2;
const 菲利斯出现Y = -16695.7;
const 菲利斯攻城传送门模型 = "Common\\Effect\\Form\\Portal\\FeliceSiegeBluePortal.mdx";
const 菲利斯攻城传送门X = -7025.6;
const 菲利斯攻城传送门Y = -16713.7;
const 菲利斯对白触发范围 = 600;
const 耶提尔靠近玩家偏移X = 160;
const 友军推进前线Y = -15350;
const 进攻朝向 = 90;
const 防守朝向 = 270;

interface 攻城单位预置 {
  单位名: string;
  X: number;
  Y: number;
  朝向: number;
}

interface 友军单位预置 extends 攻城单位预置 {
  生命比例: number;
  攻击比例: number;
  护甲比例: number;
}

interface 友军属性基准 {
  最大生命: number;
  攻击力: number;
  护甲: number;
}

interface 王城攻城战状态 {
  世代: number;
  阶段: number;
  剩余单位数: number;
  触发单位: any;
  防御法阵: any;
  攻城单位: any[];
  周期回调ID: number;
  菲利斯: any;
  菲利斯攻城传送门特效: any;
  取消菲利斯接近监听: ((this: void) => void) | undefined;
  菲利斯出场对话已触发: boolean;
}

const 第一波单位预置: 攻城单位预置[] = [
  { 单位名: "第二军团战士", X: -7124.8, Y: -15925.6, 朝向: 进攻朝向 },
  { 单位名: "第二军团战士", X: -7244.8, Y: -16015.6, 朝向: 进攻朝向 },
  { 单位名: "第二军团战士", X: -7004.8, Y: -16015.6, 朝向: 进攻朝向 },
  { 单位名: "第二军团弓箭手", X: -6717.6, Y: -15921.9, 朝向: 进攻朝向 },
  { 单位名: "第二军团弓箭手", X: -6837.6, Y: -16011.9, 朝向: 进攻朝向 },
  { 单位名: "第二军团弓箭手", X: -6597.6, Y: -16011.9, 朝向: 进攻朝向 },
];

const 第二波单位预置: 攻城单位预置[] = [
  { 单位名: "第二军团护卫", X: -7130.7, Y: -16299.6, 朝向: 进攻朝向 },
  { 单位名: "第二军团护卫", X: -7250.7, Y: -16389.6, 朝向: 进攻朝向 },
  { 单位名: "第二军团护卫", X: -7010.7, Y: -16389.6, 朝向: 进攻朝向 },
  { 单位名: "第二军团术士", X: -6694.2, Y: -16285.9, 朝向: 进攻朝向 },
  { 单位名: "第二军团术士", X: -6814.2, Y: -16375.9, 朝向: 进攻朝向 },
  { 单位名: "第二军团术士", X: -6574.2, Y: -16375.9, 朝向: 进攻朝向 },
];

const 友军单位预置表: 友军单位预置[] = [
  { 单位名: "精灵禁军", X: -7224.6, Y: -14381.4, 朝向: 防守朝向, 生命比例: 0.38, 攻击比例: 0.55, 护甲比例: 0.65 },
  { 单位名: "精灵禁军", X: -6789.2, Y: -14367.6, 朝向: 防守朝向, 生命比例: 0.38, 攻击比例: 0.55, 护甲比例: 0.65 },
  { 单位名: "精灵弓箭手", X: -7271.5, Y: -14101.1, 朝向: 防守朝向, 生命比例: 0.25, 攻击比例: 0.60, 护甲比例: 0.30 },
  { 单位名: "精灵弓箭手", X: -6628.4, Y: -14092.0, 朝向: 防守朝向, 生命比例: 0.25, 攻击比例: 0.60, 护甲比例: 0.30 },
  { 单位名: "虔诚的高等精灵骑士", X: -7520.3, Y: -14400.7, 朝向: 防守朝向, 生命比例: 0.50, 攻击比例: 0.70, 护甲比例: 0.75 },
  { 单位名: "精灵精英骑射手", X: -6332.1, Y: -14384.2, 朝向: 防守朝向, 生命比例: 0.34, 攻击比例: 0.68, 护甲比例: 0.40 },
];

const 当前攻城单位世代表: Record<number, number | undefined> = {};
let 当前王城攻城战状态: 王城攻城战状态 | undefined;
let 王城攻城战世代 = 0;
let 已注册攻城单位死亡监听 = false;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0 && GetUnitState(unit, jass.UNIT_STATE_LIFE) > 0.405;
}

function 至少为(this: void, value: number, minimum: number): number {
  return value < minimum ? minimum : value;
}

function 读取单位类型ID(this: void, 单位名: string): number {
  return stringToFourCCSafe(按名字反查总单位ID(单位名));
}

function 停止攻城目标重发(this: void): void {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null || 状态.周期回调ID === 0) return;
  removePeriodicCallback(状态.周期回调ID);
  状态.周期回调ID = 0;
}

function on重发攻城目标(this: void): void {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null || !单位存活(状态.防御法阵)) return;
  if (状态.阶段 >= 1 && 状态.阶段 <= 2) {
    for (let i = 0; i < 状态.攻城单位.length; i++) {
      const unit = 状态.攻城单位[i];
      if (单位存活(unit)) IssueTargetOrder(unit, "attack", 状态.防御法阵);
    }
    return;
  }
  if (状态.阶段 === 3 && !状态.菲利斯出场对话已触发 && 单位存活(状态.菲利斯)) {
    IssueTargetOrder(状态.菲利斯, "attack", 状态.防御法阵);
  }
}

function 启动攻城目标重发(this: void): void {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null || 状态.周期回调ID !== 0) return;
  状态.周期回调ID = addPeriodicCallback(攻城目标重发间隔毫秒, on重发攻城目标);
}

function 清理菲利斯攻城传送门(this: void, 状态: 王城攻城战状态): void {
  const effect = 状态.菲利斯攻城传送门特效;
  状态.菲利斯攻城传送门特效 = null;
  if (effect != null && effect !== 0) DestroyEffect(effect);
}

function 创建菲利斯攻城传送门(this: void, 状态: 王城攻城战状态): void {
  清理菲利斯攻城传送门(状态);
  状态.菲利斯攻城传送门特效 = AddSpecialEffect(
    菲利斯攻城传送门模型,
    菲利斯攻城传送门X,
    菲利斯攻城传送门Y
  );
}

function 创建攻城单位(this: void, 预置: 攻城单位预置, 世代: number): boolean {
  const unitTypeId = 读取单位类型ID(预置.单位名);
  const 状态 = 当前王城攻城战状态;
  if (!(unitTypeId > 0) || 状态 == null || !单位存活(状态.防御法阵)) return false;

  const unit = 创建单位并登记排泄安全(Player(敌军玩家ID), unitTypeId, 预置.X, 预置.Y, 预置.朝向);
  if (!单位存活(unit)) return false;

  当前攻城单位世代表[GetHandleId(unit)] = 世代;
  状态.攻城单位.push(unit);
  IssueTargetOrder(unit, "attack", 状态.防御法阵);
  return true;
}

function 创建当前阶段单位(this: void, 预置列表: 攻城单位预置[]): void {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null) return;

  状态.剩余单位数 = 0;
  for (let i = 0; i < 预置列表.length; i++) {
    if (创建攻城单位(预置列表[i], 状态.世代)) 状态.剩余单位数++;
  }
  if (状态.剩余单位数 > 0) 启动攻城目标重发();
}

function 读取友军属性基准(this: void, 耶提尔: any): 友军属性基准 {
  if (!单位存活(耶提尔)) return { 最大生命: 12000, 攻击力: 300, 护甲: 40 };
  return {
    最大生命: 至少为(GetUnitStateJapi(耶提尔, jass.UNIT_STATE_MAX_LIFE), 12000),
    攻击力: 至少为(GS_LoadUintProperty(耶提尔, 2), 300),
    护甲: 至少为(GS_LoadUintProperty(耶提尔, 3), 40),
  };
}

function 应用友军动态属性(this: void, unit: any, 预置: 友军单位预置, 基准: 友军属性基准): void {
  const 目标最大生命 = 至少为(基准.最大生命 * 预置.生命比例, 1800);
  const 目标攻击力 = 至少为(基准.攻击力 * 预置.攻击比例, 100);
  const 目标护甲 = 至少为(基准.护甲 * 预置.护甲比例, 8);
  GS_UnitPry(unit, 0, 0, 目标最大生命 - GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE));
  GS_UnitPry(unit, 0, 2, 目标攻击力 - GS_LoadUintProperty(unit, 2));
  GS_UnitPry(unit, 0, 3, 目标护甲 - GS_LoadUintProperty(unit, 3));
  SetUnitState(unit, jass.UNIT_STATE_LIFE, GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE));
}

function 创建友军单位(this: void, 预置: 友军单位预置, 基准: 友军属性基准): void {
  const unitTypeId = 读取单位类型ID(预置.单位名);
  if (!(unitTypeId > 0)) return;
  const unit = 创建单位并登记排泄安全(Player(友军玩家ID), unitTypeId, 预置.X, 预置.Y, 预置.朝向);
  if (!单位存活(unit)) return;
  应用友军动态属性(unit, 预置, 基准);
  IssuePointOrder(unit, "attack", 预置.X, 友军推进前线Y);
}

function 布置耶提尔与友军(this: void): void {
  const 耶提尔 = 读取语义单位引用("主线NPC.耶提尔");
  const 基准 = 读取友军属性基准(耶提尔);
  if (单位存活(耶提尔)) {
    SetUnitOwner(耶提尔, Player(友军玩家ID), true);
    SetUnitState(耶提尔, jass.UNIT_STATE_LIFE, GetUnitStateJapi(耶提尔, jass.UNIT_STATE_MAX_LIFE));
    PauseUnit(耶提尔, false);
    SetUnitInvulnerable(耶提尔, false);
    SetUnitPosition(耶提尔, -6924.1, -13933.9);
    SetUnitFacing(耶提尔, 防守朝向);
    IssuePointOrder(耶提尔, "attack", 防御法阵X, 友军推进前线Y);
  }
  for (let i = 0; i < 友军单位预置表.length; i++) 创建友军单位(友军单位预置表[i], 基准);
}

function 创建城门防御法阵(this: void): any {
  const unitTypeId = 读取单位类型ID("王城防御法阵");
  if (!(unitTypeId > 0)) return null;
  const unit = 创建单位并登记排泄安全(Player(友军玩家ID), unitTypeId, 防御法阵X, 防御法阵Y, 防守朝向);
  if (!单位存活(unit)) return null;
  X_FixUnitStandingSafe(unit);
  return unit;
}

function 注销菲利斯接近监听(this: void, 状态: 王城攻城战状态): void {
  const 取消监听 = 状态.取消菲利斯接近监听;
  状态.取消菲利斯接近监听 = undefined;
  if (取消监听 != null) 取消监听();
}

export function 结束菲利斯攻城等待(this: void): void {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null) return;
  停止攻城目标重发();
  for (let i = 0; i < 状态.攻城单位.length; i++) {
    if (单位存活(状态.攻城单位[i])) IssueImmediateOrder(状态.攻城单位[i], "stop");
  }
  if (单位存活(状态.菲利斯)) IssueImmediateOrder(状态.菲利斯, "stop");
  if (状态.取消菲利斯接近监听 != null) 注销菲利斯接近监听(状态);
}

export function 登记存活攻城单位为菲利斯护卫(this: void): number {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null || !单位存活(状态.菲利斯)) return 0;
  const { 登记Boss战待带入护卫 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.06．Boss战护卫") as {
    登记Boss战待带入护卫: (this: void, boss: any, guard: any, 护卫类型: string) => boolean;
  };

  let count = 0;
  for (let i = 0; i < 状态.攻城单位.length; i++) {
    const unit = 状态.攻城单位[i];
    if (!单位存活(unit)) continue;
    IssueImmediateOrder(unit, "stop");
    if (登记Boss战待带入护卫(状态.菲利斯, unit, "菲利斯第二军团残部")) count++;
    当前攻城单位世代表[GetHandleId(unit)] = undefined;
  }
  状态.攻城单位 = [];
  状态.剩余单位数 = 0;
  return count;
}

function on菲利斯接近触发(this: void, 进入单位: any): boolean {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null || 状态.阶段 !== 3 || 状态.菲利斯出场对话已触发) return true;

  if (!单位存活(进入单位)) return false;
  const 耶提尔 = 读取语义单位引用("主线NPC.耶提尔");
  const 由耶提尔触发 = 单位存活(耶提尔) && 进入单位 === 耶提尔;
  const 由玩家英雄触发 = 是玩家英雄组单位(进入单位);
  if (!由耶提尔触发 && !由玩家英雄触发) return false;

  状态.菲利斯出场对话已触发 = true;
  结束菲利斯攻城等待();
  if (单位存活(状态.菲利斯)) {
    IssueImmediateOrder(状态.菲利斯, "stop");
    PauseUnit(状态.菲利斯, true);
    SetUnitInvulnerable(状态.菲利斯, true);
  }

  let 剧情触发单位 = 状态.触发单位;
  if (由玩家英雄触发) {
    剧情触发单位 = 进入单位;
    if (单位存活(耶提尔)) {
      SetUnitPosition(耶提尔, GetUnitX(进入单位) + 耶提尔靠近玩家偏移X, GetUnitY(进入单位));
      IssueImmediateOrder(耶提尔, "stop");
    }
  }

  const { 播放主线剧情片段 } = require("../02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  播放主线剧情片段("elven_city_felice_projection_arrival", {
    片段ID: "elven_city_felice_projection_arrival",
    触发配置名: "菲利斯接近范围",
    触发单位: 剧情触发单位,
  });
  return true;
}

function 注册菲利斯接近对白触发(this: void, 状态: 王城攻城战状态, 菲利斯: any): void {
  状态.菲利斯 = 菲利斯;
  状态.菲利斯出场对话已触发 = false;
  状态.取消菲利斯接近监听 = registerOneShotUnitRangeListener(
    菲利斯,
    菲利斯对白触发范围,
    on菲利斯接近触发,
  );
}

function on开始王城攻城第二波(this: void, 预期世代?: any): void {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null || 状态.世代 !== 预期世代 || 状态.阶段 !== 1) return;

  状态.阶段 = 2;
  创建当前阶段单位(第二波单位预置);
  if (状态.剩余单位数 <= 0) addDelayedCallback(1800, on启动菲利斯出场, 状态.世代);
}

function on启动菲利斯出场(this: void, 预期世代?: any): void {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null || 状态.世代 !== 预期世代 || 状态.阶段 !== 2) return;

  状态.阶段 = 3;
  停止攻城目标重发();
  const bossUnit = 创建并冻结剧情Boss预置({
    Boss键: "Boss.菲利斯",
    Boss名: "菲利斯",
    X: 菲利斯出现X,
    Y: 菲利斯出现Y,
    朝向: 进攻朝向,
    预创建后暂停: false,
    预创建后无敌: true,
  });
  if (bossUnit == null || bossUnit === 0) return;
  SetUnitOwner(bossUnit, Player(敌军玩家ID), true);
  创建菲利斯攻城传送门(状态);
  注册菲利斯接近对白触发(状态, bossUnit);
  IssueTargetOrder(bossUnit, "attack", 状态.防御法阵);
  const 耶提尔 = 读取语义单位引用("主线NPC.耶提尔");
  if (单位存活(耶提尔)) IssueTargetOrder(耶提尔, "attack", bossUnit);
  启动攻城目标重发();
}

function on王城攻城单位死亡(this: void, dyingUnit: any): void {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null) return;
  if (dyingUnit === 状态.菲利斯) {
    清理菲利斯攻城传送门(状态);
    结束菲利斯攻城等待();
    结算耶提尔菲利斯协战();
    结束第二章菲利斯攻城区域音乐();
    return;
  }
  if (dyingUnit === 状态.防御法阵 && 状态.阶段 >= 1 && 状态.阶段 <= 3) {
    状态.阶段 = -1;
    清理菲利斯攻城传送门(状态);
    结束菲利斯攻城等待();
    设置全体玩家游戏失败();
    return;
  }
  if (状态.阶段 < 1 || 状态.阶段 > 2) return;

  const handleId = GetHandleId(dyingUnit);
  if (当前攻城单位世代表[handleId] !== 状态.世代) return;
  当前攻城单位世代表[handleId] = undefined;
  delete 当前攻城单位世代表[handleId];
  for (let i = 状态.攻城单位.length - 1; i >= 0; i--) {
    if (状态.攻城单位[i] === dyingUnit) 状态.攻城单位.splice(i, 1);
  }

  状态.剩余单位数--;
  if (状态.剩余单位数 > 0) return;
  停止攻城目标重发();
  if (状态.阶段 === 1) {
    addDelayedCallback(1600, on开始王城攻城第二波, 状态.世代);
    return;
  }
  addDelayedCallback(1800, on启动菲利斯出场, 状态.世代);
}

function 确保攻城单位死亡监听(this: void): void {
  if (已注册攻城单位死亡监听) return;
  已注册攻城单位死亡监听 = true;
  registerDeathListener(on王城攻城单位死亡);
}

function on正式开始王城攻城战(this: void, 预期世代?: any): void {
  const 状态 = 当前王城攻城战状态;
  if (状态 == null || 状态.世代 !== 预期世代 || 状态.阶段 !== 0) return;
  状态.防御法阵 = 创建城门防御法阵();
  if (!单位存活(状态.防御法阵)) return;

  布置耶提尔与友军();
  状态.阶段 = 1;
  创建当前阶段单位(第一波单位预置);
  if (状态.剩余单位数 <= 0) addDelayedCallback(1600, on开始王城攻城第二波, 状态.世代);
}

export function 启动王城攻城战(this: void): void {
  if (当前王城攻城战状态 != null && 当前王城攻城战状态.阶段 >= 0) return;
  if (当前王城攻城战状态 != null) 清理菲利斯攻城传送门(当前王城攻城战状态);
  确保攻城单位死亡监听();
  王城攻城战世代++;
  当前王城攻城战状态 = {
    世代: 王城攻城战世代,
    阶段: 0,
    剩余单位数: 0,
    触发单位: 读取当前剧情动作上下文().触发单位,
    防御法阵: null,
    攻城单位: [],
    周期回调ID: 0,
    菲利斯: null,
    菲利斯攻城传送门特效: null,
    取消菲利斯接近监听: undefined,
    菲利斯出场对话已触发: false,
  };
  addDelayedCallback(攻城开始延迟毫秒, on正式开始王城攻城战, 王城攻城战世代);
}

export {};
