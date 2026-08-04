/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "./00．剧情动作类型";
import { 写入剧情进度 } from "./01．剧情动作上下文";
import { 发送剧情小地图信号 } from "./02．剧情动作桥接";
import { 扣除触发单位金币, 给玩家组添加多个区域视野, 停止触发单位, 更新主线任务UI } from "./06．剧情通用执行工具";
import { 获取主线节点配置 } from "./09．主线节点配置";

const 标准剧情动作模块名 = "11．剧情系统-标准剧情动作";

function 读取节点进度(this: void, 参数: 剧情动作参数表): number {
  const 节点进度 = 参数.节点进度;
  if (typeof 节点进度 === "number") return 节点进度;
  if (typeof 节点进度 === "string") return Number(节点进度) || 0;
  const 目标进度 = 参数.目标进度;
  if (typeof 目标进度 === "number") return 目标进度;
  if (typeof 目标进度 === "string") return Number(目标进度) || 0;
  return 0;
}

export function 发布主线节点目标(this: void, 进度: number): boolean {
  const 节点 = 获取主线节点配置(进度);
  if (节点 == null) {
    debugLogForce(标准剧情动作模块名, "找不到主线节点配置", 进度);
    return false;
  }

  更新主线任务UI(节点.任务描述, 节点.任务更新提示 ?? 节点.提示文本);
  if (节点.小地图 != null) {
    发送剧情小地图信号({
      X: 节点.小地图.X,
      Y: 节点.小地图.Y,
      持续时间: 节点.小地图.持续时间 ?? 20,
    });
  }
  if (节点.解锁视野 != null && 节点.解锁视野 !== "") {
    给玩家组添加多个区域视野(节点.解锁视野);
  }
  return true;
}

export function 进入主线节点(this: void, 进度: number): boolean {
  if (获取主线节点配置(进度) == null) {
    debugLogForce(标准剧情动作模块名, "找不到主线节点配置", 进度);
    return false;
  }
  写入剧情进度(进度);
  return 发布主线节点目标(进度);
}

function 执行写入主线进度(this: void, 参数: 剧情动作参数表): void {
  const 进度 = 读取节点进度(参数);
  if (获取主线节点配置(进度) == null) {
    debugLogForce(标准剧情动作模块名, "无法写入未配置的主线节点", 进度);
    return;
  }
  写入剧情进度(进度);
}

function 执行发布主线节点目标(this: void, 参数: 剧情动作参数表): void {
  发布主线节点目标(读取节点进度(参数));
  const 扣除金币 = typeof 参数.扣除金币 === "number"
    ? 参数.扣除金币
    : Number(参数.扣除金币 ?? 0);
  if (扣除金币 > 0) 扣除触发单位金币(扣除金币);
}

function 执行进入主线节点(this: void, 参数: 剧情动作参数表): void {
  进入主线节点(读取节点进度(参数));
}

function 执行停止剧情触发单位(this: void): void {
  停止触发单位();
}

const 标准剧情动作注册表: Record<string, 剧情动作处理器> = {
  "主线.写入进度": 执行写入主线进度,
  "主线.发布节点目标": 执行发布主线节点目标,
  "主线.进入节点": 执行进入主线节点,
  "剧情.停止触发单位": 执行停止剧情触发单位,
};

export function 查找标准剧情动作处理器(this: void, 动作ID: string): 剧情动作处理器 | undefined {
  return 标准剧情动作注册表[动作ID];
}
