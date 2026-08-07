/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, 单位: any) => boolean;
};
const { 广播提示滑入毫秒, 广播提示淡出毫秒 } = require("系统.09．表现系统.06．广播提示消息.00．常量定义") as {
  广播提示滑入毫秒: number;
  广播提示淡出毫秒: number;
};
const { ModifyGateBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ModifyGateBJ: (this: void, 操作: number, 门: any) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块: string, ...参数: any[]) => void;
};

import { 莫特斯可游玩玩家最大ID, 莫特斯模块名 } from "./00．常量";

const GetOwningPlayer = jass.GetOwningPlayer as (this: void, 单位: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, 玩家: any) => number;
const GetWidgetLife = jass.GetWidgetLife as (this: void, 句柄: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, 单位: any, 类型: any) => boolean;

export interface 莫特斯隐藏副本运行状态 {
  永久入口已初始化: boolean;
  永久入口区域: any;
  永久入口触发器: any;
  首次入口演出已开始: boolean;
  首次入口演出已完成: boolean;
  当前入口英雄: any;
  当前洞窟守卫: any;
  当前暂停小怪: any[];
  莫特斯单位: any;
  莫特斯范围触发器: any;
  取消莫特斯范围监听?: (this: void) => void;
  莫特斯对白已触发: boolean;
  莫特斯战斗已启动: boolean;
  洞窟区域背景音乐已移除: boolean;
  莫特斯已经死亡: boolean;
  莫特斯死亡监听已注册: boolean;
}

export const 莫特斯运行状态: 莫特斯隐藏副本运行状态 = {
  永久入口已初始化: false,
  永久入口区域: null,
  永久入口触发器: null,
  首次入口演出已开始: false,
  首次入口演出已完成: false,
  当前入口英雄: null,
  当前洞窟守卫: null,
  当前暂停小怪: [],
  莫特斯单位: null,
  莫特斯范围触发器: null,
  取消莫特斯范围监听: undefined,
  莫特斯对白已触发: false,
  莫特斯战斗已启动: false,
  洞窟区域背景音乐已移除: false,
  莫特斯已经死亡: false,
  莫特斯死亡监听已注册: false,
};

export function 句柄有效(this: void, 句柄: any): boolean {
  return 句柄 != null && 句柄 !== 0;
}

export function 单位存活(this: void, 单位: any): boolean {
  return 句柄有效(单位)
    && GetWidgetLife(单位) > 0.405
    && IsUnitType(单位, jass.UNIT_TYPE_DEAD) !== true;
}

export function 是莫特斯副本玩家英雄(this: void, 单位: any): boolean {
  if (!单位存活(单位) || !是玩家英雄组单位(单位)) return false;
  const 玩家ID = GetPlayerId(GetOwningPlayer(单位));
  return 玩家ID >= 0 && 玩家ID <= 莫特斯可游玩玩家最大ID;
}

export function 取广播完整播放毫秒(this: void, 停留毫秒: number): number {
  return 广播提示滑入毫秒 + 停留毫秒 + 广播提示淡出毫秒;
}

function 修改莫特斯洞窟门(this: void, 操作: number, 操作名: string): boolean {
  const 洞窟门 = jglobals.gg_dest_DTg7_5609;
  if (!句柄有效(洞窟门)) {
    debugLogForce(莫特斯模块名, "洞窟门句柄缺失", "name=gg_dest_DTg7_5609", "operation=", 操作名);
    return false;
  }
  ModifyGateBJ(操作, 洞窟门);
  return true;
}

export function 打开莫特斯洞窟门(this: void): boolean {
  return 修改莫特斯洞窟门(jglobals.bj_GATEOPERATION_OPEN as number, "打开");
}

export function 关闭莫特斯洞窟门(this: void): boolean {
  return 修改莫特斯洞窟门(jglobals.bj_GATEOPERATION_CLOSE as number, "关闭");
}
