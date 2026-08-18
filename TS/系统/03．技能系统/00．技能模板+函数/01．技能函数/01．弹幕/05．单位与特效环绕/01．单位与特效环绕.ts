/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};

const DEG_TO_RAD = jass.bj_DEGTORAD as number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const SetUnitPathing = jass.SetUnitPathing as (this: void, unit: any, enabled: boolean) => void;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const EXSetEffectXY = japi.EXSetEffectXY as ((this: void, effect: any, x: number, y: number) => void) | undefined;
const EXSetEffectZ = japi.EXSetEffectZ as ((this: void, effect: any, z: number) => void) | undefined;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as ((this: void, effect: any, angle: number) => void) | undefined;
const EXEffectMatScale = japi.EXEffectMatScale as ((this: void, effect: any, x: number, y: number, z: number) => void) | undefined;

export type 环绕朝向模式 = "保持" | "沿切线" | "逆切线" | "朝向中心" | "背向中心" | "使用轨道角度";
export type 环绕结束原因 = "手动" | "持续时间结束" | "中心失效" | "无有效节点";

interface 环绕节点公共参数 {
  半径?: number;
  初始角度偏移?: number;
  高度?: number;
  跟随中心飞行高度?: boolean;
  朝向模式?: 环绕朝向模式;
  朝向修正角度?: number;
  自动销毁?: boolean;
}

export interface 单位环绕节点参数 extends 环绕节点公共参数 {
  类型: "单位";
  单位?: any;
  单位类型ID?: number;
  所有者?: any;
  缩放?: number;
  禁用碰撞?: boolean;
}

export interface 特效环绕节点参数 extends 环绕节点公共参数 {
  类型: "特效";
  特效?: any;
  模型路径?: string;
  缩放?: number;
}

export type 环绕节点参数 = 单位环绕节点参数 | 特效环绕节点参数;

export interface 单位与特效环绕参数 {
  中心单位: any;
  节点: 环绕节点参数[];
  半径: number;
  /** 正数逆时针，负数顺时针，单位为度/秒。 */
  角速度: number;
  初始角度?: number;
  周期毫秒?: number;
  持续秒?: number;
  中心失效时结束?: boolean;
  自动开始?: boolean;
  每Tick?: (this: void, instance: 单位与特效环绕实例) => void;
  结束回调?: (this: void, instance: 单位与特效环绕实例, reason: 环绕结束原因) => void;
}

export interface 环绕运行节点 {
  类型: "单位" | "特效";
  句柄: any;
  半径: number;
  角度偏移: number;
  高度: number;
  跟随中心飞行高度: boolean;
  朝向模式: 环绕朝向模式;
  朝向修正角度: number;
  /** 记录已应用到特效矩阵的最终水平朝向，后续只叠加角度差。 */
  已应用特效朝向?: number;
  自动销毁: boolean;
  已销毁: boolean;
}

export interface 单位与特效环绕实例 {
  ID: number;
  参数: 单位与特效环绕参数;
  节点: 环绕运行节点[];
  当前角度: number;
  已运行毫秒: number;
  周期ID: number;
  已结束: boolean;
  已暂停: boolean;
  开始: (this: void) => void;
  暂停: (this: void) => void;
  恢复: (this: void) => void;
  结束: (this: void, reason?: 环绕结束原因) => void;
  设置半径: (this: void, radius: number) => void;
  设置角速度: (this: void, degreesPerSecond: number) => void;
}

let 环绕实例自增ID = 0;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 标准化角度(this: void, angle: number): number {
  let result = angle % 360;
  if (result < 0) result += 360;
  return result;
}

function 取最短角度差(this: void, oldAngle: number, newAngle: number): number {
  let delta = 标准化角度(newAngle) - 标准化角度(oldAngle);
  if (delta > 180) delta -= 360;
  else if (delta < -180) delta += 360;
  return delta;
}

function 取节点朝向(this: void, mode: 环绕朝向模式, orbitAngle: number, correction: number): number | undefined {
  if (mode === "保持") return undefined;
  if (mode === "沿切线") return orbitAngle + 90 + correction;
  if (mode === "逆切线") return orbitAngle - 90 + correction;
  if (mode === "朝向中心") return orbitAngle + 180 + correction;
  return orbitAngle + correction;
}

function 销毁环绕节点(this: void, node: 环绕运行节点): void {
  if (node.已销毁) return;
  node.已销毁 = true;
  if (!node.自动销毁 || node.句柄 == null || node.句柄 === 0) return;
  if (node.类型 === "单位") RemoveUnit(node.句柄);
  else DestroyEffect(node.句柄);
}

function 创建运行节点(this: void, params: 单位与特效环绕参数, nodeParams: 环绕节点参数): 环绕运行节点 | null {
  const center = params.中心单位;
  const initialAngle = (params.初始角度 ?? 0) + (nodeParams.初始角度偏移 ?? 0);
  const radius = nodeParams.半径 ?? params.半径;
  const x = GetUnitX(center) + radius * jass.Cos(initialAngle * DEG_TO_RAD);
  const y = GetUnitY(center) + radius * jass.Sin(initialAngle * DEG_TO_RAD);
  const facing = 取节点朝向(nodeParams.朝向模式 ?? "保持", initialAngle, nodeParams.朝向修正角度 ?? 0) ?? 0;
  let handle = nodeParams.类型 === "单位" ? nodeParams.单位 : nodeParams.特效;
  let created = false;

  if (handle == null || handle === 0) {
    if (nodeParams.类型 === "单位") {
      if (nodeParams.单位类型ID == null || nodeParams.单位类型ID === 0 || nodeParams.所有者 == null) return null;
      handle = 创建单位并登记排泄安全(nodeParams.所有者, nodeParams.单位类型ID, x, y, facing);
    } else {
      if (nodeParams.模型路径 == null || nodeParams.模型路径 === "") return null;
      handle = jass.AddSpecialEffect(nodeParams.模型路径, x, y);
    }
    created = true;
  }
  if (handle == null || handle === 0) return null;

  if (nodeParams.类型 === "单位") {
    if (nodeParams.禁用碰撞 !== false) SetUnitPathing(handle, false);
    if (nodeParams.缩放 != null) SetUnitScale(handle, nodeParams.缩放, nodeParams.缩放, nodeParams.缩放);
  } else if (nodeParams.缩放 != null && typeof EXEffectMatScale === "function") {
    EXEffectMatScale(handle, nodeParams.缩放, nodeParams.缩放, nodeParams.缩放);
  }

  return {
    类型: nodeParams.类型,
    句柄: handle,
    半径: radius,
    角度偏移: nodeParams.初始角度偏移 ?? 0,
    高度: nodeParams.高度 ?? 0,
    跟随中心飞行高度: nodeParams.跟随中心飞行高度 !== false,
    朝向模式: nodeParams.朝向模式 ?? "保持",
    朝向修正角度: nodeParams.朝向修正角度 ?? 0,
    已应用特效朝向: undefined,
    自动销毁: nodeParams.自动销毁 ?? created,
    已销毁: false,
  };
}

function 更新环绕节点(this: void, instance: 单位与特效环绕实例, node: 环绕运行节点): boolean {
  if (node.已销毁 || node.句柄 == null || node.句柄 === 0) return false;
  if (node.类型 === "单位" && !单位有效(node.句柄)) return false;
  const center = instance.参数.中心单位;
  const angle = instance.当前角度 + node.角度偏移;
  const x = GetUnitX(center) + node.半径 * jass.Cos(angle * DEG_TO_RAD);
  const y = GetUnitY(center) + node.半径 * jass.Sin(angle * DEG_TO_RAD);
  const z = node.高度 + (node.跟随中心飞行高度 ? GetUnitFlyHeight(center) : 0);
  const facing = 取节点朝向(node.朝向模式, angle, node.朝向修正角度);

  if (node.类型 === "单位") {
    SetUnitX(node.句柄, x);
    SetUnitY(node.句柄, y);
    SetUnitFlyHeight(node.句柄, z, 0);
    if (facing != null) SetUnitFacing(node.句柄, facing);
  } else {
    if (typeof EXSetEffectXY === "function") EXSetEffectXY(node.句柄, x, y);
    if (typeof EXSetEffectZ === "function") EXSetEffectZ(node.句柄, z);
    if (facing != null && typeof EXEffectMatRotateZ === "function") {
      const delta = node.已应用特效朝向 == null
        ? facing
        : 取最短角度差(node.已应用特效朝向, facing);
      if (delta !== 0) EXEffectMatRotateZ(node.句柄, delta);
      node.已应用特效朝向 = 标准化角度(facing);
    }
  }
  return true;
}

function 结束环绕实例(this: void, instance: 单位与特效环绕实例, reason: 环绕结束原因): void {
  if (instance.已结束) return;
  instance.已结束 = true;
  if (instance.周期ID !== 0) removePeriodicCallback(instance.周期ID);
  instance.周期ID = 0;
  for (let i = 0; i < instance.节点.length; i++) 销毁环绕节点(instance.节点[i]);
  if (instance.参数.结束回调 != null) instance.参数.结束回调(instance, reason);
}

function 推进环绕实例(this: void, variable?: any): void {
  const instance = variable as 单位与特效环绕实例 | undefined;
  if (instance == null || instance.已结束 || instance.已暂停) return;
  const params = instance.参数;
  if (params.中心失效时结束 !== false && !单位有效(params.中心单位)) {
    结束环绕实例(instance, "中心失效");
    return;
  }
  const interval = params.周期毫秒 ?? 20;
  instance.已运行毫秒 += interval;
  instance.当前角度 = 标准化角度(instance.当前角度 + params.角速度 * interval / 1000);
  let validCount = 0;
  for (let i = 0; i < instance.节点.length; i++) {
    if (更新环绕节点(instance, instance.节点[i])) validCount += 1;
  }
  if (validCount <= 0) {
    结束环绕实例(instance, "无有效节点");
    return;
  }
  if (params.每Tick != null) params.每Tick(instance);
  if (params.持续秒 != null && instance.已运行毫秒 >= params.持续秒 * 1000) {
    结束环绕实例(instance, "持续时间结束");
  }
}

export function 创建单位与特效环绕(this: void, params: 单位与特效环绕参数): 单位与特效环绕实例 | null {
  if (params == null || !单位有效(params.中心单位) || params.节点 == null || params.节点.length <= 0) return null;
  环绕实例自增ID += 1;
  const nodes: 环绕运行节点[] = [];
  for (let i = 0; i < params.节点.length; i++) {
    const node = 创建运行节点(params, params.节点[i]);
    if (node != null) nodes.push(node);
  }
  if (nodes.length <= 0) return null;

  const instance: 单位与特效环绕实例 = {
    ID: 环绕实例自增ID,
    参数: params,
    节点: nodes,
    当前角度: params.初始角度 ?? 0,
    已运行毫秒: 0,
    周期ID: 0,
    已结束: false,
    已暂停: false,
    开始: function 开始环绕(this: void): void {
      if (instance.已结束 || instance.周期ID !== 0) return;
      instance.周期ID = addPeriodicCallback(params.周期毫秒 ?? 20, 推进环绕实例, instance);
    },
    暂停: function 暂停环绕(this: void): void { instance.已暂停 = true; },
    恢复: function 恢复环绕(this: void): void { instance.已暂停 = false; },
    结束: function 手动结束环绕(this: void, reason?: 环绕结束原因): void { 结束环绕实例(instance, reason ?? "手动"); },
    设置半径: function 设置环绕半径(this: void, radius: number): void {
      params.半径 = radius;
      for (let i = 0; i < instance.节点.length; i++) instance.节点[i].半径 = radius;
    },
    设置角速度: function 设置环绕角速度(this: void, degreesPerSecond: number): void { params.角速度 = degreesPerSecond; },
  };

  for (let i = 0; i < nodes.length; i++) 更新环绕节点(instance, nodes[i]);
  if (params.自动开始 !== false) instance.开始();
  return instance;
}

export {};
