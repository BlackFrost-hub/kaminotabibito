/** @noSelfInFile */

const platformAbilityApi = require("平台扩展API取值") as {
  技能_获取技能当前冷却时间: (this: void, 单位: any, 技能代码: number) => number;
};

const { 技能_获取技能当前冷却时间 } = platformAbilityApi;

export type QWER热键位 = "Q" | "W" | "E" | "R";

export type QWER技能ID表 = Partial<Record<QWER热键位, number>>;

export interface 技能冷却状态 {
  技能ID: number;
  剩余冷却: number;
  是否冷却中: boolean;
}

export interface QWER冷却状态 {
  Q: 技能冷却状态;
  W: 技能冷却状态;
  E: 技能冷却状态;
  R: 技能冷却状态;
  全部存在: boolean;
  全部冷却中: boolean;
}

const 默认冷却阈值秒 = 0.05;

function 有效句柄(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

export function 读取技能剩余冷却(this: void, 单位: any, 技能ID: number): number {
  if (!有效句柄(单位) || 技能ID == null || 技能ID === 0) return 0;
  return 技能_获取技能当前冷却时间(单位, 技能ID) || 0;
}

export function 技能是否冷却中(this: void, 单位: any, 技能ID: number, 阈值秒: number = 默认冷却阈值秒): boolean {
  return 读取技能剩余冷却(单位, 技能ID) > 阈值秒;
}

export function 读取技能冷却状态(this: void, 单位: any, 技能ID: number, 阈值秒: number = 默认冷却阈值秒): 技能冷却状态 {
  const 剩余冷却 = 读取技能剩余冷却(单位, 技能ID);
  return {
    技能ID,
    剩余冷却,
    是否冷却中: 剩余冷却 > 阈值秒,
  };
}

export function 指定技能是否全部冷却中(this: void, 单位: any, 技能ID列表: number[], 阈值秒: number = 默认冷却阈值秒): boolean {
  if (!有效句柄(单位) || 技能ID列表.length <= 0) return false;
  for (let i = 0; i < 技能ID列表.length; i++) {
    const 技能ID = 技能ID列表[i];
    if (技能ID == null || 技能ID === 0) return false;
    if (!技能是否冷却中(单位, 技能ID, 阈值秒)) return false;
  }
  return true;
}

export function 读取QWER冷却状态(this: void, 单位: any, 技能表: QWER技能ID表, 阈值秒: number = 默认冷却阈值秒): QWER冷却状态 {
  const q = 读取技能冷却状态(单位, 技能表.Q ?? 0, 阈值秒);
  const w = 读取技能冷却状态(单位, 技能表.W ?? 0, 阈值秒);
  const e = 读取技能冷却状态(单位, 技能表.E ?? 0, 阈值秒);
  const r = 读取技能冷却状态(单位, 技能表.R ?? 0, 阈值秒);
  const 全部存在 = q.技能ID !== 0 && w.技能ID !== 0 && e.技能ID !== 0 && r.技能ID !== 0;
  return {
    Q: q,
    W: w,
    E: e,
    R: r,
    全部存在,
    全部冷却中: 全部存在 && q.是否冷却中 && w.是否冷却中 && e.是否冷却中 && r.是否冷却中,
  };
}

export function QWER技能是否全部冷却中(this: void, 单位: any, 技能表: QWER技能ID表, 阈值秒: number = 默认冷却阈值秒): boolean {
  return 读取QWER冷却状态(单位, 技能表, 阈值秒).全部冷却中;
}
