/** @noSelfInFile */

const jass = require("jass.common") as any;
const Rect = jass.Rect as (this: void, minX: number, minY: number, maxX: number, maxY: number) => any;
const RemoveRect = jass.RemoveRect as (this: void, rect: any) => void;

import type { 动态矩形区域配置 } from "./00．动态矩形区域类型";
import { 动态矩形区域配置表, 读取动态矩形区域配置 } from "./01．动态矩形区域配置表";

interface 动态矩形区域状态 {
  配置: 动态矩形区域配置;
  矩形: any;
}

const 动态矩形区域状态表: Record<string, 动态矩形区域状态 | undefined> = {};

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 配置有效(this: void, 配置: 动态矩形区域配置): boolean {
  return 配置.键 !== ""
    && 配置.左 < 配置.右
    && 配置.下 < 配置.上;
}

/** 注册配置并创建矩形；同一键重复调用只返回原句柄。 */
export function 注册动态矩形区域(this: void, 配置: 动态矩形区域配置): any {
  if (!配置有效(配置)) return null;
  const 已有状态 = 动态矩形区域状态表[配置.键];
  if (已有状态 != null && 句柄有效(已有状态.矩形)) return 已有状态.矩形;

  动态矩形区域配置表[配置.键] = 配置;
  const 矩形 = Rect(配置.左, 配置.下, 配置.右, 配置.上);
  if (!句柄有效(矩形)) return null;
  动态矩形区域状态表[配置.键] = { 配置, 矩形 };
  return 矩形;
}

/** 使用配置表中的键创建矩形；调用方只保留句柄，不重复保存坐标。 */
export function 按配置键注册动态矩形区域(this: void, 键: string): any {
  const 配置 = 读取动态矩形区域配置(键);
  return 配置 == null ? null : 注册动态矩形区域(配置);
}

export function 获取动态矩形区域(this: void, 键: string): any {
  const 状态 = 动态矩形区域状态表[键];
  return 状态 != null && 句柄有效(状态.矩形) ? 状态.矩形 : null;
}

/** 注销并删除运行时矩形；配置保留，便于同一键后续重新创建。 */
export function 注销动态矩形区域(this: void, 键: string): boolean {
  const 状态 = 动态矩形区域状态表[键];
  if (状态 == null) return false;
  if (句柄有效(状态.矩形)) RemoveRect(状态.矩形);
  delete 动态矩形区域状态表[键];
  return true;
}

export function 清理全部动态矩形区域(this: void): void {
  for (const 键 in 动态矩形区域状态表) {
    注销动态矩形区域(键);
  }
}
