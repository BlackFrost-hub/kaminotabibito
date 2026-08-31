/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as Record<string, any>;

const { 注册环境互动调查点, 注销环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
  注销环境互动调查点: (this: void, 调查点ID: string) => boolean;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, 延迟毫秒: number, 回调: (this: void, 变量?: any) => void, 变量?: any) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, 玩家: any, 单位类型ID: number, X: number, Y: number, 面向: number) => any;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, 物品类型ID: number, X: number, Y: number) => any;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, 表名: string, 键: any, 属性名: string, 类型: string) => any;
  YDUserDataSetSafe: (this: void, 表名: string, 键: any, 属性名: string, 类型: string, 值: any) => void;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, 模型路径: string, X: number, Y: number, Z?: number, 持续秒?: number) => any;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};
const { 记录Boss自动技能启动 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表") as {
  记录Boss自动技能启动: (this: void, 单位: any, 来源: "STES.Boss" | "Boss战.单位" | "Boss战.绑定单位" | "Boss测试") => any;
};
const { 启动Boss战运行 } = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动") as {
  启动Boss战运行: (this: void, Boss单位: any) => void;
};
const { SFB_setBuff } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setBuff: (this: void, 来源单位: any, 目标单位: any, BuffID: number, 持续秒: number) => void;
};

import {
  旧环境互动Boss单位ID,
  旧环境互动配置表,
  旧环境互动隐藏木桩奖励物品ID列表,
  type 旧环境互动配置,
} from "./00．旧环境互动配置";

const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const GetHeroLevel = jass.GetHeroLevel as (this: void, 单位: any) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, 最小值: number, 最大值: number) => number;
const Player = jass.Player as (this: void, 玩家ID: number) => any;
const SetUnitOwner = jass.SetUnitOwner as (this: void, 单位: any, 玩家: any, 改变颜色: boolean) => void;
const UnitAddItem = jass.UnitAddItem as (this: void, 单位: any, 物品: any) => boolean;
const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;
const Boss入口特效路径 = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl";

interface Boss入口延迟参数 {
  Boss单位: any;
  触发单位: any;
}

function 创建并给予物品(this: void, 施法单位: any, 物品ID: string): void {
  const 物品 = 创建物品并注册排泄监听(
    解析配置内部ID(物品ID),
    GetUnitX(施法单位),
    GetUnitY(施法单位),
  );
  if (物品 != null && 物品 !== 0) UnitAddItem(施法单位, 物品);
}

function 处理隐藏木桩(this: void, _玩家ID: number, 施法单位: any, 调查点: 旧环境互动配置): boolean {
  const 随机序号 = GetRandomInt(1, 3) - 1;
  创建并给予物品(施法单位, 旧环境互动隐藏木桩奖励物品ID列表[随机序号]);
  广播单位提示(施法单位, 调查点.提示文本, 3000);
  return true;
}

function 处理普通提示(this: void, _玩家ID: number, 施法单位: any, 调查点: 旧环境互动配置): boolean {
  广播单位提示(施法单位, 调查点.提示文本, 3000);
  return true;
}

function 处理Boss入口(this: void, _玩家ID: number, 施法单位: any, 调查点: 旧环境互动配置): boolean {
  if (GetHeroLevel(施法单位) < 9) return false;
  const X = 调查点.X;
  const Y = 调查点.Y;
  createTimedEffect(Boss入口特效路径, X, Y, 0, 1);
  SFB_setBuff(施法单位, 施法单位, 0, 6);
  const Boss单位 = 创建单位并登记排泄安全(
    Player(PLAYER_NEUTRAL_PASSIVE),
    解析配置内部ID(旧环境互动Boss单位ID),
    X,
    Y,
    270,
  );
  if (Boss单位 == null || Boss单位 === 0) return false;
  YDUserDataSetSafe("string", "Boss战", "单位", "unit", Boss单位);
  YDUserDataSetSafe("string", "Boss战", "绑定单位", "unit", Boss单位);
  YDUserDataSetSafe("string", "Boss战", "触发玩家", "unit", 施法单位);
  YDUserDataSetSafe("unit", Boss单位, "闪避率", "real", 0.2);
  const 旧Boss随从 = jglobals.gg_unit_n05Q_0003;
  if (旧Boss随从 != null && 旧Boss随从 !== 0) SetUnitOwner(旧Boss随从, Player(5), true);
  addDelayedCallback(3000, 启动旧Boss战, { Boss单位, 触发单位: 施法单位 });
  广播单位提示(施法单位, 调查点.提示文本, 1500);
  return true;
}

function 启动旧Boss战(this: void, 参数: Boss入口延迟参数): void {
  if (参数 == null || 参数.Boss单位 == null || 参数.Boss单位 === 0) return;
  YDUserDataSetSafe("string", "Boss战", "触发玩家", "unit", 参数.触发单位);
  记录Boss自动技能启动(参数.Boss单位, "Boss战.单位");
  启动Boss战运行(参数.Boss单位);
}

function 处理物品奖励(this: void, _玩家ID: number, 施法单位: any, 调查点: 旧环境互动配置): boolean {
  if (调查点.奖励物品ID == null || 调查点.奖励物品ID === "") return false;
  创建并给予物品(施法单位, 调查点.奖励物品ID);
  广播单位提示(施法单位, 调查点.提示文本, 3000);
  return true;
}

function 取旧环境互动回调(this: void, 类型: 旧环境互动配置["类型"]): (this: void, 玩家ID: number, 施法单位: any, 调查点: any) => boolean {
  if (类型 === "隐藏木桩") return 处理隐藏木桩;
  if (类型 === "普通提示") return 处理普通提示;
  if (类型 === "Boss入口") return 处理Boss入口;
  return 处理物品奖励;
}

export function 注册旧环境互动调查点(this: void): void {
  for (let i = 0; i < 旧环境互动配置表.length; i++) {
    const 配置 = 旧环境互动配置表[i];
    注销环境互动调查点(配置.ID);
    注册环境互动调查点({
      ID: 配置.ID,
      X: 配置.X,
      Y: 配置.Y,
      触发范围: 配置.触发范围,
      一次性: 配置.一次性,
      提示文本: 配置.提示文本,
      延迟提示文本: 配置.延迟提示文本,
      奖励物品ID: 配置.奖励物品ID,
      触发回调: 取旧环境互动回调(配置.类型),
    });
  }
}

export {};
