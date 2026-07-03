/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import { 创建可攻击机制单位, type 可攻击机制单位实例 } from "./01．可攻击机制单位";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;

export interface 可攻击控制法阵参数 {
  清理?: 机制清理篮子;
  名称: string;
  主人单位?: any;
  所属玩家?: any;
  单位类型?: string | number;
  模型路径?: string;
  X: number;
  Y: number;
  半径: number;
  最大生命?: number;
  缩放?: number;
  持续秒: number;
  摧毁后剩余秒: number;
  目标列表?: any[];
  取目标列表?: (this: void) => any[];
  目标有效?: (this: void, 目标: any) => boolean;
  施加控制: (this: void, 目标: any, 持续秒: number) => void;
  创建特效路径?: string;
  摧毁特效路径?: string;
  on创建?: (this: void, 实例: 可攻击机制单位实例 | undefined, 受影响目标: any[]) => void;
  on摧毁?: (this: void, 受影响目标: any[]) => void;
}

function 取法阵目标列表(this: void, 参数: 可攻击控制法阵参数): any[] {
  if (参数.目标列表 != null) return 参数.目标列表;
  if (参数.取目标列表 != null) return 参数.取目标列表();
  return [];
}

function 目标是否在法阵内(this: void, 参数: 可攻击控制法阵参数, 目标: any): boolean {
  if (参数.目标有效 != null && !参数.目标有效(目标)) return false;
  const dx = GetUnitX(目标) - 参数.X;
  const dy = GetUnitY(目标) - 参数.Y;
  return dx * dx + dy * dy <= 参数.半径 * 参数.半径;
}

function 收集并施加法阵控制(this: void, 参数: 可攻击控制法阵参数): any[] {
  const 目标列表 = 取法阵目标列表(参数);
  const 受影响目标: any[] = [];
  for (let i = 0; i < 目标列表.length; i++) {
    const 目标 = 目标列表[i];
    if (!目标是否在法阵内(参数, 目标)) continue;
    参数.施加控制(目标, 参数.持续秒);
    受影响目标.push(目标);
  }
  return 受影响目标;
}

export function 创建可攻击控制法阵(this: void, 参数: 可攻击控制法阵参数): 可攻击机制单位实例 | undefined {
  const 受影响目标 = 收集并施加法阵控制(参数);
  const 实例 = 创建可攻击机制单位({
    清理: 参数.清理,
    名称: 参数.名称,
    主人单位: 参数.主人单位,
    所属玩家: 参数.所属玩家,
    单位类型: 参数.单位类型,
    模型路径: 参数.模型路径,
    X: 参数.X,
    Y: 参数.Y,
    最大生命: 参数.最大生命,
    缩放: 参数.缩放,
    持续时间: 参数.持续秒,
    on死亡: function 可攻击控制法阵死亡(this: void): void {
      if (参数.摧毁特效路径 != null && 参数.摧毁特效路径 !== "") AddSpecialEffect(参数.摧毁特效路径, 参数.X, 参数.Y);
      for (let i = 0; i < 受影响目标.length; i++) {
        const 目标 = 受影响目标[i];
        if (参数.目标有效 != null && !参数.目标有效(目标)) continue;
        参数.施加控制(目标, 参数.摧毁后剩余秒);
      }
      if (参数.on摧毁 != null) 参数.on摧毁(受影响目标);
    },
  });
  if (参数.创建特效路径 != null && 参数.创建特效路径 !== "") AddSpecialEffect(参数.创建特效路径, 参数.X, 参数.Y);
  if (参数.on创建 != null) 参数.on创建(实例, 受影响目标);
  return 实例;
}
