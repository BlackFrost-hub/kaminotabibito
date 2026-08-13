/** @noSelfInFile */

const jass = require("jass.common") as any;

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { X_FixUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { registerOneShotUnitRangeListener } = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
  registerOneShotUnitRangeListener: (
    this: void,
    unit: any,
    range: number,
    callback: (this: void, enteringUnit: any) => boolean,
    predicate?: (this: void, enteringUnit: any) => boolean,
  ) => () => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 刷新主线节点引导配置 } = require("系统.11．剧情系统.01．主线任务.03．主线引导UI.01．主线引导配置表") as {
  刷新主线节点引导配置: (this: void, 进度: number) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 注册剧情运行时单位, 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 清除主线节点运行时覆盖, 设置主线节点运行时覆盖 } from "../../00．剧情系统核心工具/09．主线节点配置";
import { 发布主线节点目标, 进入主线节点 } from "../../00．剧情系统核心工具/10．标准剧情动作";
import { 布置耶提尔战后奖励NPC } from "./31B．耶提尔协战控制器";
export { 王城战后与第三章启程剧情片段 } from "../03．第三章/35．王城战后与第三章启程";

const Player = jass.Player as (this: void, playerId: number) => any;

const 第三章启程进度 = 36;
const 王宫启程传送门键 = "剧情运行时.王宫启程传送门";
const 王宫启程传送门类型ID = "n025";
const 王宫启程传送门位置 = { X: 6451.3, Y: -28690.6, 朝向: 270 };
const 王宫启程传送门进入范围 = 500;
const 熔岩小镇位置 = { X: 8668.3, Y: -20334.0 };

interface 王宫启程传送门状态 {
  传送门: any;
  已切换熔岩小镇引导: boolean;
  取消范围监听?: (this: void) => void;
}

let 当前王宫启程传送门状态: 王宫启程传送门状态 | undefined;

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitAliveBJ(unit);
}

function 清理王宫启程传送门监听(this: void, 状态: 王宫启程传送门状态): void {
  if (状态.取消范围监听 != null) 状态.取消范围监听();
  状态.取消范围监听 = undefined;
}

function 切换到熔岩小镇引导(this: void): void {
  设置主线节点运行时覆盖({
    进度: 第三章启程进度,
    任务描述: "穿过第一章沙漠，前往熔岩小镇。",
    提示文本: "|cffffff00『第三章主线』：|r穿过第一章沙漠，前往|cffff6800『熔岩小镇』|r。",
    任务更新提示: "|cffffff00『系统消息』：|r已经抵达启程传送门。穿过第一章沙漠，前往|cffff6800『熔岩小镇』|r。",
    小地图: { X: 熔岩小镇位置.X, Y: 熔岩小镇位置.Y, 持续时间: 20 },
    引导: { 镜头X: 熔岩小镇位置.X, 镜头Y: 熔岩小镇位置.Y },
  });
  刷新主线节点引导配置(第三章启程进度);
  发布主线节点目标(第三章启程进度);
}

function on玩家抵达王宫启程传送门(this: void, 触发单位: any): boolean {
  const 状态 = 当前王宫启程传送门状态;
  if (状态 == null || 状态.已切换熔岩小镇引导 || 读取剧情进度() !== 第三章启程进度) return false;
  if (!单位存活(触发单位)) return false;

  状态.已切换熔岩小镇引导 = true;
  清理王宫启程传送门监听(状态);
  切换到熔岩小镇引导();
  return true;
}

function 注册王宫启程传送门范围监听(this: void, 状态: 王宫启程传送门状态): void {
  状态.取消范围监听 = registerOneShotUnitRangeListener(
    状态.传送门,
    王宫启程传送门进入范围,
    on玩家抵达王宫启程传送门,
    是玩家英雄组单位,
  );
}

function 创建王宫启程传送门(this: void): any {
  let 传送门 = 读取剧情运行时单位(王宫启程传送门键);
  if (!单位存活(传送门)) {
    传送门 = 创建单位并登记排泄安全(
      Player(6),
      stringToFourCCSafe(王宫启程传送门类型ID),
      王宫启程传送门位置.X,
      王宫启程传送门位置.Y,
      王宫启程传送门位置.朝向,
    );
    if (!单位存活(传送门)) return null;
    X_FixUnitStandingSafe(传送门);
    注册剧情运行时单位(王宫启程传送门键, 传送门);
  }
  return 传送门;
}

export function 执行第三章启程布置(this: void, 参数: 剧情动作参数表): void {
  布置耶提尔战后奖励NPC();
  if (当前王宫启程传送门状态 != null) 清理王宫启程传送门监听(当前王宫启程传送门状态);
  清除主线节点运行时覆盖(第三章启程进度);
  刷新主线节点引导配置(第三章启程进度);

  const 传送门 = 创建王宫启程传送门();
  if (单位存活(传送门)) {
    当前王宫启程传送门状态 = { 传送门, 已切换熔岩小镇引导: false };
    注册王宫启程传送门范围监听(当前王宫启程传送门状态);
  }
  进入主线节点(Number(参数.节点进度) || 第三章启程进度);
}

export const 第三章启程剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_启程前往熔岩小镇": 执行第三章启程布置,
};
