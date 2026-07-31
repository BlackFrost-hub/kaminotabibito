/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import { 创建可攻击机制单位, type 可攻击机制单位实例 } from "./01．可攻击机制单位";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { X_SetUnitMovableSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_SetUnitMovableSafe: (this: void, unit: any, movable: boolean) => void;
};
const { 设置特效缩放 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  设置特效缩放: (this: void, effect: any, scale: number) => void;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

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
  变量?: any;
  取目标列表?: (this: void, 变量?: any) => any[];
  目标有效?: (this: void, 目标: any, 变量?: any) => boolean;
  施加控制: (this: void, 目标: any, 持续秒: number, 变量?: any) => void;
  创建特效路径?: string;
  旋涡特效路径?: string;
  旋涡特效缩放?: number;
  摧毁特效路径?: string;
  on创建?: (this: void, 实例: 可攻击机制单位实例 | undefined, 受影响目标: any[], 变量?: any) => void;
  on摧毁?: (this: void, 受影响目标: any[], 变量?: any) => void;
}

interface 可攻击控制法阵死亡上下文 {
  参数: 可攻击控制法阵参数;
  受影响目标: any[];
}

const 可攻击控制法阵死亡上下文表: Record<number, 可攻击控制法阵死亡上下文 | undefined> = {};
const 可攻击控制法阵附加特效表: Record<number, any[] | undefined> = {};

interface 可攻击控制法阵到期变量 {
  实例?: 可攻击机制单位实例;
}

function 取法阵单位ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位) || 0;
}

function 取法阵目标列表(this: void, 参数: 可攻击控制法阵参数): any[] {
  if (参数.目标列表 != null) return 参数.目标列表;
  if (参数.取目标列表 != null) return 参数.取目标列表(参数.变量);
  return [];
}

function 目标是否在法阵内(this: void, 参数: 可攻击控制法阵参数, 目标: any): boolean {
  if (参数.目标有效 != null && !参数.目标有效(目标, 参数.变量)) return false;
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
    参数.施加控制(目标, 参数.持续秒, 参数.变量);
    受影响目标.push(目标);
  }
  return 受影响目标;
}

function 可攻击控制法阵死亡(this: void, 单位: any): void {
  const id = 取法阵单位ID(单位);
  if (id === 0) return;
  销毁法阵附加特效(id);
  const 上下文 = 可攻击控制法阵死亡上下文表[id];
  if (上下文 == null) return;
  delete 可攻击控制法阵死亡上下文表[id];

  const 参数 = 上下文.参数;
  const 受影响目标 = 上下文.受影响目标;
  if (参数.摧毁特效路径 != null && 参数.摧毁特效路径 !== "") {
    const 摧毁特效 = AddSpecialEffect(参数.摧毁特效路径, 参数.X, 参数.Y);
    if (摧毁特效 != null && 摧毁特效 !== 0) YDWETimerDestroyEffectSafe(1, 摧毁特效);
  }
  for (let i = 0; i < 受影响目标.length; i++) {
    const 目标 = 受影响目标[i];
    if (参数.目标有效 != null && !参数.目标有效(目标, 参数.变量)) continue;
    参数.施加控制(目标, 参数.摧毁后剩余秒, 参数.变量);
  }
  if (参数.on摧毁 != null) 参数.on摧毁(受影响目标, 参数.变量);
}

function 可攻击控制法阵销毁(this: void, 单位: any): void {
  const id = 取法阵单位ID(单位);
  if (id === 0) return;
  delete 可攻击控制法阵死亡上下文表[id];
  销毁法阵附加特效(id);
}

function 销毁法阵附加特效(this: void, id: number): void {
  const 特效列表 = 可攻击控制法阵附加特效表[id];
  if (特效列表 == null) return;
  delete 可攻击控制法阵附加特效表[id];
  for (let i = 0; i < 特效列表.length; i++) {
    const 特效 = 特效列表[i];
    if (特效 != null && 特效 !== 0) DestroyEffect(特效);
  }
}

function 登记法阵附加特效(this: void, id: number, 特效: any): void {
  if (特效 == null || 特效 === 0) return;
  let 特效列表 = 可攻击控制法阵附加特效表[id];
  if (特效列表 == null) {
    特效列表 = [];
    可攻击控制法阵附加特效表[id] = 特效列表;
  }
  特效列表.push(特效);
}

function 可攻击控制法阵持续时间到期(this: void, variable?: any): void {
  const data = variable as 可攻击控制法阵到期变量 | undefined;
  if (data == null || data.实例 == null || !data.实例.是否存活()) return;
  data.实例.销毁();
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
    固定站桩: true,
    X: 参数.X,
    Y: 参数.Y,
    最大生命: 参数.最大生命,
    缩放: 参数.缩放,
    持续时间: 参数.持续秒,
    on死亡: 可攻击控制法阵死亡,
    on销毁: 可攻击控制法阵销毁,
  });
  if (实例 != null) 可攻击控制法阵死亡上下文表[实例.ID] = { 参数, 受影响目标 };
  if (实例 == null) return undefined;

  X_SetUnitMovableSafe(实例.单位, false);
  if (参数.创建特效路径 != null && 参数.创建特效路径 !== "") {
    登记法阵附加特效(实例.ID, AddSpecialEffect(参数.创建特效路径, 参数.X, 参数.Y));
  }
  if (参数.旋涡特效路径 != null && 参数.旋涡特效路径 !== "") {
    const 旋涡 = AddSpecialEffect(参数.旋涡特效路径, 参数.X, 参数.Y);
    if (参数.旋涡特效缩放 != null && 参数.旋涡特效缩放 > 0) 设置特效缩放(旋涡, 参数.旋涡特效缩放);
    登记法阵附加特效(实例.ID, 旋涡);
  }
  if (参数.持续秒 > 0) {
    const 到期变量: 可攻击控制法阵到期变量 = { 实例 };
    const 回调ID = addDelayedCallback(参数.持续秒 * 1000, 可攻击控制法阵持续时间到期, 到期变量);
    if (参数.清理 != null) 参数.清理.登记延迟回调(参数.名称 + "-持续时间", 回调ID);
  }
  if (参数.on创建 != null) 参数.on创建(实例, 受影响目标, 参数.变量);
  return 实例;
}
