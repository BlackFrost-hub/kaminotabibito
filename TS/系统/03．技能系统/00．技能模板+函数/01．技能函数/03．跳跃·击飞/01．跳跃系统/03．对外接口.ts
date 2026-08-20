/** @noSelfInFile */
/**
 * 跳跃系统 - 对外接口
 *
 * 包含所有对外暴露的公共函数。
 */
import {
  跳跃参数,
  跳跃结束原因,
  活动跳跃列表,
  跳跃映射,
  单位当前跳跃,
  单位当前跳跃位移类型,
  取句柄ID,
  快照单位组,
  GetUnitX,
  GetUnitY,
} from "./00．共享";
import { 创建跳跃实例, 解析跳跃角度, 结束跳跃ID, 停止单位跳跃 } from "./02．驱动与实例";
import { 尝试阻止自身位移技能, 通知战斗自身位移完成 } from "../../../02．通用函数/20．位移技能限制";

const { 按英雄技能距离修正上下文修正距离 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.11．技能属性修正.index") as {
  按英雄技能距离修正上下文修正距离: (this: void, 基础距离: number, 上下文: any, 默认用途?: string) => number;
};

export function 开始跳跃(单位: any, 参数: 跳跃参数): number {
  if (尝试阻止自身位移技能(单位)) return 0;

  const 角度 = 解析跳跃角度(单位, 参数);
  if (角度 == null) return 0;
  const 起点X = GetUnitX(单位);
  const 起点Y = GetUnitY(单位);
  const 原结束回调 = 参数.结束回调;
  const 距离 = 按英雄技能距离修正上下文修正距离(参数.距离, 参数.英雄技能距离修正, "自身位移距离");

  function on主动跳跃结束(this: void, 移动单位: any, 原因: 跳跃结束原因, 跳跃ID: number): void {
    const 单位有效 = 移动单位 != null && 移动单位 !== 0;
    const 终点X = 单位有效 ? GetUnitX(移动单位) : 起点X;
    const 终点Y = 单位有效 ? GetUnitY(移动单位) : 起点Y;
    if (原结束回调 != null) 原结束回调(移动单位, 原因, 跳跃ID);
    if (单位有效 && 原因 !== "中断" && 原因 !== "死亡" && 原因 !== "主单位死亡") {
      通知战斗自身位移完成(移动单位, 起点X, 起点Y, 终点X, 终点Y);
    }
  }

  return 创建跳跃实例(单位, 角度, { ...参数, 距离, 结束回调: on主动跳跃结束 });
}

export function 开始定向跳跃(单位: any, 参数: 跳跃参数): number {
  return 开始跳跃(单位, 参数);
}

/** 沿指定方向跳跃，并明确标记为可识别的被击退/被击飞效果。 */
export function 开始跳跃作为被击退击飞(this: void, 单位: any, 参数: 跳跃参数): number {
  return 开始跳跃(单位, {
    ...参数,
    位移类型: "被击退击飞",
  });
}

/** 沿指定角度反向跳跃，并明确标记为可识别的被击退/被击飞效果。 */
export function 开始反向跳跃作为被击退击飞(this: void, 单位: any, 参数: 跳跃参数): number {
  if (参数.角度 == null) return 0;
  return 开始跳跃(单位, {
    ...参数,
    角度: 参数.角度 + 180,
    位移类型: "被击退击飞",
  });
}

export function 开始单位组跳跃(单位组: any, 参数: 跳跃参数): number[] {
  const 单位列表 = 快照单位组(单位组);
  const 结果: number[] = [];
  for (const 单位 of 单位列表) {
    const 跳跃ID = 开始跳跃(单位, 参数);
    if (跳跃ID > 0) {
      结果.push(跳跃ID);
    }
  }
  return 结果;
}

export function 开始单位组定向跳跃(单位组: any, 参数: 跳跃参数): number[] {
  const 单位列表 = 快照单位组(单位组);
  const 结果: number[] = [];
  for (const 单位 of 单位列表) {
    const 跳跃ID = 开始定向跳跃(单位, 参数);
    if (跳跃ID > 0) {
      结果.push(跳跃ID);
    }
  }
  return 结果;
}

export function 停止跳跃(跳跃ID: number, 原因: 跳跃结束原因 = "中断"): boolean {
  return 结束跳跃ID(跳跃ID, 原因);
}

export { 停止单位跳跃 };

export function 单位是否正在跳跃(单位: any): boolean {
  const 跳跃ID = 单位当前跳跃[取句柄ID(单位)];
  return 跳跃ID != null && 跳跃映射[跳跃ID] != null;
}

export function 获取单位当前跳跃ID(单位: any): number {
  return 单位当前跳跃[取句柄ID(单位)] ?? 0;
}

export function 获取单位当前跳跃位移类型(this: void, 单位: any): string {
  return 单位当前跳跃位移类型[取句柄ID(单位)] ?? "普通";
}

export function 单位是否处于被击退击飞(this: void, 单位: any): boolean {
  const id = 取句柄ID(单位);
  return 单位当前跳跃[id] != null && 单位当前跳跃位移类型[id] === "被击退击飞";
}

export function 获取活跃跳跃数量(): number {
  return 活动跳跃列表.length;
}
