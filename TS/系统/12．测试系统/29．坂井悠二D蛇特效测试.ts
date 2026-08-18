/** @noSelfInFile */

import { 坂井悠二技能配置 } from "../03．技能系统/05．单位技能/04．英雄技能/13．坂井悠二/00．配置";

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
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块名: string, ...参数: any[]) => void;
};
const { SetUnitVertexColorBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  SetUnitVertexColorBJ: (this: void, unit: any, red: number, green: number, blue: number, transparency: number) => void;
};
const { EC_GetPointZ } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_GetPointZ: (this: void, x: number, y: number) => number;
};

const AddSpecialEffect = jass.AddSpecialEffect as (this: void, 模型路径: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (this: void, 模型路径: string, 单位: any, 挂点: string) => any;
const CreateUnit = jass.CreateUnit as (this: void, 玩家: any, 单位类型ID: number, x: number, y: number, 面向: number) => any;
const DestroyEffect = jass.DestroyEffect as (this: void, 特效: any) => void;
const DzSetUnitModel = japi.DzSetUnitModel as (this: void, 单位: any, 模型路径: string) => void;
const EXSetEffectSize = japi.EXSetEffectSize as (this: void, 特效: any, 缩放: number) => void;
const EXSetEffectZ = japi.EXSetEffectZ as (this: void, 特效: any, z: number) => void;
const GetHandleId = jass.GetHandleId as (this: void, 句柄: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, 单位: any) => any;
const GetUnitFacing = jass.GetUnitFacing as (this: void, 单位: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, 单位: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, 单位: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, 单位: any) => number;
const RemoveUnit = jass.RemoveUnit as (this: void, 单位: any) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (this: void, 单位: any, 动画编号: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, 单位: any, 高度: number, 速度: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, 单位: any, x: number, y: number, z: number) => void;
const SetUnitState = jass.SetUnitState as (this: void, 单位: any, 状态: any, 数值: number) => boolean;
const SetUnitTimeScale = jass.SetUnitTimeScale as (this: void, 单位: any, 速度: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const 配置 = 坂井悠二技能配置.D;
const 模块名 = "坂井悠二D蛇特效测试";
const 直接模型命令 = "-测试坂井D模型";
const 附加模型命令 = "-测试坂井D附加";
const 观察时间毫秒 = 10000;

interface 直接模型测试上下文 {
  蛇头: any;
  蛇身: any;
  绿黑光束: any;
}

interface 附加模型测试上下文 extends 直接模型测试上下文 {
  头部马甲: any;
  蛇身马甲: any;
  原生对照: any;
}

function 取有效英雄(this: void, 玩家: any): any {
  if (!是允许测试玩家(玩家)) return null;
  const 英雄 = getRegisteredPlayerHero(玩家);
  if (英雄 == null || 英雄 === 0) {
    debugLogForce(模块名, "未找到输入指令玩家的已注册英雄");
    return null;
  }
  return 英雄;
}

function 清理直接模型(this: void, 参数?: any): void {
  const 上下文 = 参数 as 直接模型测试上下文 | undefined;
  if (上下文 == null) return;
  if (上下文.蛇头 != null && 上下文.蛇头 !== 0) DestroyEffect(上下文.蛇头);
  if (上下文.蛇身 != null && 上下文.蛇身 !== 0) DestroyEffect(上下文.蛇身);
  if (上下文.绿黑光束 != null && 上下文.绿黑光束 !== 0) DestroyEffect(上下文.绿黑光束);
  debugLogForce(模块名, "直接模型测试已自动清理");
}

function 清理附加模型(this: void, 参数?: any): void {
  const 上下文 = 参数 as 附加模型测试上下文 | undefined;
  if (上下文 == null) return;
  if (上下文.蛇头 != null && 上下文.蛇头 !== 0) DestroyEffect(上下文.蛇头);
  if (上下文.蛇身 != null && 上下文.蛇身 !== 0) DestroyEffect(上下文.蛇身);
  if (上下文.绿黑光束 != null && 上下文.绿黑光束 !== 0) DestroyEffect(上下文.绿黑光束);
  if (上下文.原生对照 != null && 上下文.原生对照 !== 0) DestroyEffect(上下文.原生对照);
  if (上下文.头部马甲 != null && 上下文.头部马甲 !== 0) RemoveUnit(上下文.头部马甲);
  if (上下文.蛇身马甲 != null && 上下文.蛇身马甲 !== 0) RemoveUnit(上下文.蛇身马甲);
  debugLogForce(模块名, "附加模型测试已自动清理");
}

function on直接模型测试(this: void, 玩家: any, _命令: string): void {
  const 英雄 = 取有效英雄(玩家);
  if (英雄 == null || 英雄 === 0) return;

  const x = GetUnitX(英雄);
  const y = GetUnitY(英雄);
  const 英雄Z = EC_GetPointZ(x, y) + GetUnitFlyHeight(英雄);
  const 蛇头配置 = 配置.马甲一.特效;
  const 蛇身配置 = 配置.马甲二.特效[0];
  const 光束配置 = 配置.马甲二.特效[1];
  const 蛇头 = AddSpecialEffect(蛇头配置.模型路径, x, y);
  const 蛇身 = AddSpecialEffect(蛇身配置.模型路径, x, y);
  const 绿黑光束 = AddSpecialEffect(光束配置.模型路径, x, y);

  if (蛇头 != null && 蛇头 !== 0) {
    EXSetEffectSize(蛇头, 配置.马甲一.缩放);
    EXSetEffectZ(蛇头, 英雄Z + 配置.马甲一.飞行高度增量);
  }
  if (蛇身 != null && 蛇身 !== 0) {
    EXSetEffectSize(蛇身, 配置.马甲二.缩放);
    EXSetEffectZ(蛇身, 英雄Z + 配置.马甲二.飞行高度增量);
  }
  if (绿黑光束 != null && 绿黑光束 !== 0) {
    EXSetEffectSize(绿黑光束, 配置.马甲二.缩放);
    EXSetEffectZ(绿黑光束, 英雄Z + 配置.马甲二.飞行高度增量);
  }

  addDelayedCallback(观察时间毫秒, 清理直接模型, { 蛇头, 蛇身, 绿黑光束 } as 直接模型测试上下文);
  debugLogForce(模块名, "直接模型已在玩家英雄位置创建", "英雄", GetHandleId(英雄), "X", x, "Y", y,
    "蛇头句柄", GetHandleId(蛇头), "蛇身句柄", GetHandleId(蛇身), "光束句柄", GetHandleId(绿黑光束), "观察秒", 观察时间毫秒 / 1000);
}

function 初始化测试马甲(this: void, 马甲: any, 缩放: number, 高度: number, 动画编号: number, 时间缩放: number, 颜色: any): void {
  if (马甲 == null || 马甲 === 0) return;
  DzSetUnitModel(马甲, 配置.马甲载体模型路径);
  SetUnitState(马甲, UNIT_STATE_MAX_LIFE, 配置.马甲一.HP保障值);
  SetUnitState(马甲, UNIT_STATE_LIFE, 配置.马甲一.HP保障值);
  SetUnitAnimationByIndex(马甲, 动画编号);
  SetUnitTimeScale(马甲, 时间缩放);
  SetUnitScale(马甲, 缩放, 缩放, 缩放);
  SetUnitVertexColorBJ(马甲, 颜色.红, 颜色.绿, 颜色.蓝, 颜色.透明度);
  SetUnitFlyHeight(马甲, 高度, 0);
}

function 执行延迟附加测试(this: void, 参数?: any): void {
  const 上下文 = 参数 as 附加模型测试上下文 | undefined;
  if (上下文 == null) return;
  if (上下文.头部马甲 == null || 上下文.头部马甲 === 0 || 上下文.蛇身马甲 == null || 上下文.蛇身马甲 === 0) {
    debugLogForce(模块名, "延迟附加失败：测试马甲无效");
    清理附加模型(上下文);
    return;
  }

  上下文.蛇头 = AddSpecialEffectTarget(配置.马甲一.特效.模型路径, 上下文.头部马甲, 配置.马甲一.特效.挂点);
  上下文.蛇身 = AddSpecialEffectTarget(配置.马甲二.特效[0].模型路径, 上下文.蛇身马甲, 配置.马甲二.特效[0].挂点);
  上下文.绿黑光束 = AddSpecialEffectTarget(配置.马甲二.特效[1].模型路径, 上下文.蛇身马甲, 配置.马甲二.特效[1].挂点);
  上下文.原生对照 = AddSpecialEffectTarget("Abilities\\Spells\\Other\\Charm\\CharmTarget.mdl", 上下文.头部马甲, "origin");

  addDelayedCallback(观察时间毫秒, 清理附加模型, 上下文);
  debugLogForce(模块名, "延迟0.05秒后完成附加", "头部马甲", GetHandleId(上下文.头部马甲), "蛇身马甲", GetHandleId(上下文.蛇身马甲),
    "蛇头句柄", GetHandleId(上下文.蛇头), "蛇身句柄", GetHandleId(上下文.蛇身), "光束句柄", GetHandleId(上下文.绿黑光束),
    "原生对照句柄", GetHandleId(上下文.原生对照), "观察秒", 观察时间毫秒 / 1000);
}

function on附加模型测试(this: void, 玩家: any, _命令: string): void {
  const 英雄 = 取有效英雄(玩家);
  if (英雄 == null || 英雄 === 0) return;

  const x = GetUnitX(英雄);
  const y = GetUnitY(英雄);
  const 面向 = GetUnitFacing(英雄);
  const 英雄飞行高度 = GetUnitFlyHeight(英雄);
  const 马甲类型ID = stringToFourCCSafe(配置.马甲一.单位类型ID);
  const owner = GetOwningPlayer(英雄);
  const 头部马甲 = CreateUnit(owner, 马甲类型ID, x, y, 面向);
  const 蛇身马甲 = CreateUnit(owner, 马甲类型ID, x, y, 面向);

  初始化测试马甲(头部马甲, 配置.马甲一.缩放, 英雄飞行高度 + 配置.马甲一.飞行高度增量,
    配置.马甲一.动画编号, 配置.马甲一.时间缩放, 配置.马甲一.颜色);
  初始化测试马甲(蛇身马甲, 配置.马甲二.缩放, 英雄飞行高度 + 配置.马甲二.飞行高度增量,
    配置.马甲二.动画编号, 配置.马甲二.时间缩放, 配置.马甲二.颜色);

  const 上下文: 附加模型测试上下文 = {
    头部马甲,
    蛇身马甲,
    蛇头: null,
    蛇身: null,
    绿黑光束: null,
    原生对照: null,
  };
  addDelayedCallback(50, 执行延迟附加测试, 上下文);
  debugLogForce(模块名, "附加载体已在玩家英雄位置创建，等待0.05秒刷新模型节点", "英雄", GetHandleId(英雄), "X", x, "Y", y,
    "马甲类型", 配置.马甲一.单位类型ID, "载体模型", 配置.马甲载体模型路径,
    "头部马甲", GetHandleId(头部马甲), "蛇身马甲", GetHandleId(蛇身马甲));
}

注册聊天命令监听(直接模型命令, on直接模型测试);
注册聊天命令监听(附加模型命令, on附加模型测试);
debugLogForce(模块名, "测试命令已注册", 直接模型命令, 附加模型命令);

export {};
