/** @noSelfInFile */

/**
 * 芙莉莲 Q 附加弹道层静态观感测试。
 * 输入 -测试芙莉莲Q附加：在当前已注册玩家英雄位置创建模型，10 秒后自动销毁。
 */

import { 芙莉莲表现配置 } from "../03．技能系统/05．单位技能/04．英雄技能/25．芙莉莲/00．配置";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { 注册聊天命令监听 } = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心") as {
  注册聊天命令监听: (this: void, 命令: string, 回调: (this: void, 玩家: any, 命令: string) => void) => void;
};
const { 是允许测试玩家 } = require("系统.12．测试系统.00．测试系统辅助函数") as {
  是允许测试玩家: (this: void, 玩家: any) => boolean;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, 玩家: any) => any;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, 延迟毫秒: number, 回调: (this: void, 参数?: any) => void, 参数?: any) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块名: string, ...参数: any[]) => void;
};
const { EC_GetPointZ } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_GetPointZ: (this: void, x: number, y: number) => number;
};

const AddSpecialEffect = jass.AddSpecialEffect as (this: void, 模型路径: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, 特效: any) => void;
const GetHandleId = jass.GetHandleId as (this: void, 句柄: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, 单位: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const EXSetEffectSize = japi.EXSetEffectSize as (this: void, 特效: any, 缩放: number) => void;
const EXSetEffectZ = japi.EXSetEffectZ as (this: void, 特效: any, z: number) => void;

const 模块名 = "芙莉莲Q附加弹道层测试";
const 测试命令 = "-测试芙莉莲Q附加";
const 测试缩放 = 2.0;
const 测试高度 = 50;
const 观察时间毫秒 = 10000;

function 销毁测试特效(this: void, 参数?: any): void {
  const 特效 = 参数;
  if (特效 == null || 特效 === 0) return;
  DestroyEffect(特效);
  debugLogForce(模块名, "测试特效已自动销毁", "句柄", GetHandleId(特效));
}

function on测试芙莉莲Q附加(this: void, 玩家: any, _命令: string): void {
  if (!是允许测试玩家(玩家)) return;

  const 英雄 = getRegisteredPlayerHero(玩家);
  if (英雄 == null || 英雄 === 0) {
    debugLogForce(模块名, "未找到输入指令玩家的已注册英雄");
    return;
  }

  const x = GetUnitX(英雄);
  const y = GetUnitY(英雄);
  const z = EC_GetPointZ(x, y) + GetUnitFlyHeight(英雄) + 测试高度;
  const 模型路径 = 芙莉莲表现配置.Q弹道附加特效.模型路径;
  const 特效 = AddSpecialEffect(模型路径, x, y);
  if (特效 == null || 特效 === 0) {
    debugLogForce(模块名, "创建失败", "模型", 模型路径, "X", x, "Y", y);
    return;
  }

  EXSetEffectSize(特效, 测试缩放);
  EXSetEffectZ(特效, z);
  addDelayedCallback(观察时间毫秒, 销毁测试特效, 特效);
  debugLogForce(模块名, "已在玩家英雄位置创建", "模型", 模型路径, "缩放", 测试缩放,
    "高度", 测试高度, "X", x, "Y", y, "Z", z, "句柄", GetHandleId(特效), "观察秒", 观察时间毫秒 / 1000);
}

注册聊天命令监听(测试命令, on测试芙莉莲Q附加);
debugLogForce(模块名, "测试命令已注册", 测试命令);

export {};
