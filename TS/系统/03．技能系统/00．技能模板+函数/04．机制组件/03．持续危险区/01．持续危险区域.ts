/** @noSelfInFile */

import { 创建区域效果, 区域效果实例, 区域效果参数 } from "../../01．技能函数/04．区域效果/区域效果";
import type { 技能提示圈配置 } from "../../02．通用函数/16．技能提示圈工厂";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

export interface 持续危险区域参数 {
  清理?: 机制清理篮子;
  X: number;
  Y: number;
  锚点单位?: any;
  半径: number;
  持续时间: number;
  检测间隔?: number;
  防抖间隔?: number;
  /** 首次扫描（创建时已在范围内的单位）也触发 on进入；引用计数用途配合 防抖间隔: 0 */
  首次扫描触发进入?: boolean;
  影响目标?: "敌方" | "友方" | "全部";
  所有者?: any;
  模型路径?: string;
  特效高度?: number;
  特效缩放?: number;
  显示提示圈?: boolean;
  提示圈?: 技能提示圈配置 | false;
  周期伤害?: number;
  周期伤害去重组?: number;
  周期伤害去重间隔?: number;
  回调上下文ID?: number;
  on进入?: (this: void, 单位: any, 回调上下文ID?: number) => void;
  on离开?: (this: void, 单位: any, 回调上下文ID?: number) => void;
  on周期?: (this: void, 区域内单位: any[], 回调上下文ID?: number) => void;
  on销毁?: (this: void, 回调上下文ID?: number) => void;
}

export interface 持续危险区域实例 {
  readonly 区域效果: 区域效果实例;
  销毁(this: void): void;
  暂停(this: void): void;
  恢复(this: void): void;
  移动到(this: void, x: number, y: number): void;
}

function 转换为区域效果参数(this: void, 参数: 持续危险区域参数): 区域效果参数 {
  return {
    X: 参数.X,
    Y: 参数.Y,
    锚点单位: 参数.锚点单位,
    半径: 参数.半径,
    持续时间: 参数.持续时间,
    检测间隔: 参数.检测间隔,
    防抖间隔: 参数.防抖间隔,
    首次扫描触发进入: 参数.首次扫描触发进入,
    影响目标: 参数.影响目标,
    所有者: 参数.所有者,
    模型路径: 参数.模型路径,
    特效高度: 参数.特效高度,
    特效缩放: 参数.特效缩放,
    显示提示圈: 参数.显示提示圈,
    提示圈: 参数.提示圈,
    周期伤害: 参数.周期伤害,
    周期伤害去重组: 参数.周期伤害去重组,
    周期伤害去重间隔: 参数.周期伤害去重间隔,
    回调上下文ID: 参数.回调上下文ID,
    on进入: 参数.on进入,
    on离开: 参数.on离开,
    on周期: 参数.on周期,
    on销毁: 参数.on销毁,
  };
}

export function 创建持续危险区域(this: void, 参数: 持续危险区域参数): 持续危险区域实例 {
  const 区域效果 = 创建区域效果(转换为区域效果参数(参数));
  const 实例: 持续危险区域实例 = {
    区域效果,
    销毁(): void {
      区域效果.销毁();
    },
    暂停(): void {
      区域效果.暂停();
    },
    恢复(): void {
      区域效果.恢复();
    },
    移动到(x: number, y: number): void {
      区域效果.移动到(x, y);
    },
  };
  if (参数.清理 != null) {
    参数.清理.登记清理("持续危险区域-" + 参数.X + "-" + 参数.Y, function 持续危险区域清理(this: void): void {
      实例.销毁();
    });
  }
  return 实例;
}
