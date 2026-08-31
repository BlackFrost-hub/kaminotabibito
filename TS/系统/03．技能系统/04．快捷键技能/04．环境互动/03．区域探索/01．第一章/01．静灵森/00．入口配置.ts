/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 注册环境互动调查点 } = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心") as {
  注册环境互动调查点: (this: void, 调查点: any) => boolean;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, 延迟毫秒: number, 回调: (this: void, 变量?: any) => void, 变量?: any) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, 玩家: any, 单位类型ID: number, X: number, Y: number, 面向: number) => any;
};
const { 解析配置内部ID } = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具") as {
  解析配置内部ID: (this: void, 配置值: string | undefined | null) => number;
};
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  createTimedEffect: (this: void, 模型路径: string, X: number, Y: number, Z?: number, 持续秒?: number) => any;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, 来源单位: any, 文本: string, 持续时间?: number) => void;
};

const Player = jass.Player as (this: void, 玩家ID: number) => any;
const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;

const 水触手单位ID = "水触须#n049";
const 水触手特效路径 = "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl";
const 水触手提示文本 = "水面下传来了一阵异样的动静。";
const 水触手延迟提示文本 = "水触手从水池现身了。";

function 创建水触手(this: void, 施法单位: any): void {
  if (施法单位 == null || 施法单位 === 0) return;
  const X = -28763.3;
  const Y = -8994.8;
  createTimedEffect(水触手特效路径, X, Y, 0, 1);
  创建单位并登记排泄安全(Player(PLAYER_NEUTRAL_PASSIVE), 解析配置内部ID(水触手单位ID), X, Y, 0);
  广播单位提示(施法单位, 水触手延迟提示文本, 1500);
}

function 处理水触手调查(this: void, _玩家ID: number, 施法单位: any, 调查点: any): boolean {
  void 调查点;
  createTimedEffect(水触手特效路径, -28763.3, -8994.8, 0, 1);
  addDelayedCallback(3000, 创建水触手, 施法单位);
  广播单位提示(施法单位, 水触手提示文本, 1500);
  return true;
}

/** 注册静灵森的常驻环境互动探索点。 */
export function 注册静灵森探索点(this: void): void {
  注册环境互动调查点({
    ID: "静灵森.水触手",
    X: -28763.3,
    Y: -8994.8,
    触发范围: 350,
    一次性: true,
    触发回调: 处理水触手调查,
  });
}

export {};
