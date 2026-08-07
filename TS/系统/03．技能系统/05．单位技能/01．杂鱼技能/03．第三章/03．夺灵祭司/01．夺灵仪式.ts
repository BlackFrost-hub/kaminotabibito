/** @noSelfInFile */

import type { 封印守卫战敌人记录 } from "../00．封印守卫战公共/00．类型";
import { 夺灵祭司配置 } from "./00．配置";
import {
  单位处于硬控制,
  取两点距离平方,
  取单位X,
  取单位Y,
  命令停止,
  命令移动到点,
  创建封印守卫战点特效,
  清理记录锚点压制,
  读取封印守卫战敌人记录,
  读取封印守卫战锚点状态,
  封印守卫战单位存活,
  设置记录锚点压制,
} from "../00．封印守卫战公共/01．共享";

const { 开始充能, 停止单位充能 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统") as {
  开始充能: (this: void, unit: any, params: any) => number;
  停止单位充能: (this: void, unit: any) => boolean;
};
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

function 祭司仍在锚点范围(this: void, record: 封印守卫战敌人记录): boolean {
  const anchor = 读取封印守卫战锚点状态(record.锚点编号);
  if (anchor == null || anchor.已完成) return false;
  return 取两点距离平方(取单位X(record.单位), 取单位Y(record.单位), anchor.X, anchor.Y)
    <= 夺灵祭司配置.引导范围 * 夺灵祭司配置.引导范围;
}

function on夺灵祭司充能周期(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "夺灵祭司" || record.充能ID !== chargeId) return;
  if (!祭司仍在锚点范围(record) || 单位处于硬控制(unit)) 停止单位充能(unit);
}

function on夺灵祭司充能完成(this: void, unit: any, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "夺灵祭司" || record.充能ID !== chargeId) return;
  record.充能ID = 0;
  if (!祭司仍在锚点范围(record)) return;
  const anchor = 读取封印守卫战锚点状态(record.锚点编号);
  if (anchor == null) return;
  命令停止(unit);
  record.压制特效 = 创建封印守卫战点特效({
    模型路径: 夺灵祭司配置.压制法阵特效,
    X: anchor.X,
    Y: anchor.Y,
    Z: 0,
    缩放: 0.8,
  });
  设置记录锚点压制(record, true);
}

function on夺灵祭司充能结束(this: void, unit: any, reason: string, chargeId: number): void {
  const record = 读取封印守卫战敌人记录(unit);
  if (record == null || record.类型 !== "夺灵祭司") return;
  if (record.充能ID === chargeId) record.充能ID = 0;
  if (reason !== "完成") record.下次技能毫秒 = getServerTime() + 夺灵祭司配置.失败重试毫秒;
}

function 开始夺灵祭司引导(this: void, record: 封印守卫战敌人记录): boolean {
  if (record.充能ID !== 0 || 单位处于硬控制(record.单位)) return false;
  const id = 开始充能(record.单位, {
    持续时间: 夺灵祭司配置.引导持续秒,
    强制硬直: true,
    显示进度条特效: true,
    周期回调间隔: 0.1,
    周期回调: on夺灵祭司充能周期,
    充能完成回调: on夺灵祭司充能完成,
    结束回调: on夺灵祭司充能结束,
  });
  record.充能ID = id;
  return id > 0;
}

function 选择最近未完成锚点(this: void, record: 封印守卫战敌人记录): number {
  const x = 取单位X(record.单位);
  const y = 取单位Y(record.单位);
  let bestId = 0;
  let bestDistance = 999999999;
  for (let i = 1; i <= 夺灵祭司配置.锚点数量; i++) {
    const anchor = 读取封印守卫战锚点状态(i);
    if (anchor == null || anchor.已完成) continue;
    const distance = 取两点距离平方(x, y, anchor.X, anchor.Y);
    if (distance >= bestDistance) continue;
    bestDistance = distance;
    bestId = i;
  }
  return bestId;
}

export function 刷新夺灵祭司AI(this: void, record: 封印守卫战敌人记录, 当前毫秒: number): void {
  if (!封印守卫战单位存活(record.单位)) return;
  if (record.正在压制锚点) {
    if (!祭司仍在锚点范围(record) || 单位处于硬控制(record.单位)) {
      清理记录锚点压制(record);
      record.下次技能毫秒 = 当前毫秒 + 夺灵祭司配置.失败重试毫秒;
    } else if (当前毫秒 >= record.下次AI毫秒) {
      record.下次AI毫秒 = 当前毫秒 + 夺灵祭司配置.AI刷新毫秒;
      命令停止(record.单位);
    }
    return;
  }
  if (record.充能ID !== 0 || 当前毫秒 < record.下次AI毫秒) return;
  record.下次AI毫秒 = 当前毫秒 + 夺灵祭司配置.AI刷新毫秒;
  const anchorId = 选择最近未完成锚点(record);
  if (anchorId === 0) return;
  record.锚点编号 = anchorId;
  const anchor = 读取封印守卫战锚点状态(anchorId);
  if (anchor == null) return;
  const inRange = 取两点距离平方(取单位X(record.单位), 取单位Y(record.单位), anchor.X, anchor.Y)
    <= 夺灵祭司配置.引导范围 * 夺灵祭司配置.引导范围;
  if (inRange && 当前毫秒 >= record.下次技能毫秒) {
    开始夺灵祭司引导(record);
  } else if (!inRange) {
    命令移动到点(record.单位, anchor.X, anchor.Y);
  }
}

export function 清理夺灵祭司机制(this: void, record: 封印守卫战敌人记录): void {
  if (record.充能ID !== 0 && 封印守卫战单位存活(record.单位)) 停止单位充能(record.单位);
  record.充能ID = 0;
  清理记录锚点压制(record);
}
