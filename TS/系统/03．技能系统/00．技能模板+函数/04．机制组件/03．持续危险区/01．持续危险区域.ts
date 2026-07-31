/** @noSelfInFile */

import { 创建区域效果, 区域效果实例, 区域效果参数 } from "../../01．技能函数/04．区域效果/区域效果";
import type { 技能提示圈配置 } from "../../02．通用函数/16．技能提示圈工厂";

export interface 持续危险区域参数 {
  X: number;
  Y: number;
  半径: number;
  持续时间: number;
  检测间隔?: number;
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
    半径: 参数.半径,
    持续时间: 参数.持续时间,
    检测间隔: 参数.检测间隔,
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
  return {
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
}
