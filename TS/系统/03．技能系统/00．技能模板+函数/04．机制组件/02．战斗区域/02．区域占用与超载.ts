/** @noSelfInFile */

import {
  动态矩形区域,
  动态矩形区域组,
  统计动态矩形区域内单位数量,
} from "./01．动态矩形区域组";

export interface 区域占用状态 {
  区域: 动态矩形区域;
  单位数量: number;
  容量: number;
  是否超载: boolean;
}

export interface 区域占用统计参数 {
  区域组: 动态矩形区域组 | undefined;
  单位列表: any[];
  默认容量: number;
  区域容量?: Record<string, number>;
}

function 取区域容量(this: void, 区域: 动态矩形区域, 默认容量: number, 区域容量?: Record<string, number>): number {
  if (区域容量 == null) return 默认容量;
  const id = 区域.配置.ID;
  if (id != null && 区域容量[id] != null) return 区域容量[id];
  const 名称 = 区域.配置.名称;
  if (名称 != null && 区域容量[名称] != null) return 区域容量[名称];
  return 默认容量;
}

export function 统计区域占用状态(this: void, 参数: 区域占用统计参数): 区域占用状态[] {
  const 区域组 = 参数.区域组;
  if (区域组 == null) return [];

  const result: 区域占用状态[] = [];
  const 区域列表 = 区域组.区域列表;
  for (let i = 0; i < 区域列表.length; i++) {
    const 区域 = 区域列表[i];
    const 容量 = 取区域容量(区域, 参数.默认容量, 参数.区域容量);
    const 单位数量 = 统计动态矩形区域内单位数量(区域, 参数.单位列表);
    result.push({
      区域,
      单位数量,
      容量,
      是否超载: 容量 >= 0 && 单位数量 > 容量,
    });
  }
  return result;
}

export function 取超载区域列表(this: void, 参数: 区域占用统计参数): 区域占用状态[] {
  const 状态列表 = 统计区域占用状态(参数);
  const result: 区域占用状态[] = [];
  for (let i = 0; i < 状态列表.length; i++) {
    if (状态列表[i].是否超载) result.push(状态列表[i]);
  }
  return result;
}

export function 是否存在超载区域(this: void, 参数: 区域占用统计参数): boolean {
  const 状态列表 = 统计区域占用状态(参数);
  for (let i = 0; i < 状态列表.length; i++) {
    if (状态列表[i].是否超载) return true;
  }
  return false;
}
