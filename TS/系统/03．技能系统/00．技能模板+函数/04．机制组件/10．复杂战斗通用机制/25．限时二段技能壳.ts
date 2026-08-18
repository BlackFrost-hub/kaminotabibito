/** @noSelfInFile */

const jass = require("jass.common") as any;

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;

export const 通用二段技能壳ID = {
  Q: "ASQ2",
  W: "ASW2",
  E: "ASE2",
  R: "ASR2",
} as const;

export interface 限时二段技能壳控制器 {
  名称: string;
  单位: any;
  一段技能ID: number;
  二段技能ID: number;
  超时回调ID: number;
  已结束: boolean;
  数据?: any;
  超时回调?: (this: void, 控制器: 限时二段技能壳控制器) => void;
}

export interface 限时二段技能壳参数 {
  名称: string;
  单位: any;
  一段技能ID: number;
  二段技能ID: number;
  持续秒: number;
  数据?: any;
  超时回调?: (this: void, 控制器: 限时二段技能壳控制器) => void;
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

function 恢复技能壳(this: void, 控制器: 限时二段技能壳控制器): void {
  if (!单位有效(控制器.单位)) return;
  UnitRemoveAbility(控制器.单位, 控制器.二段技能ID);
  const owner = GetOwningPlayer(控制器.单位);
  if (owner == null || owner === 0) return;
  SetPlayerAbilityAvailable(owner, 控制器.二段技能ID, false);
  SetPlayerAbilityAvailable(owner, 控制器.一段技能ID, true);
}

function 结束技能壳(this: void, 控制器: 限时二段技能壳控制器 | undefined, 取消计时: boolean): boolean {
  if (控制器 == null || 控制器.已结束) return false;
  控制器.已结束 = true;
  if (取消计时 && 控制器.超时回调ID !== 0) removeDelayedCallback(控制器.超时回调ID);
  控制器.超时回调ID = 0;
  恢复技能壳(控制器);
  return true;
}

function 限时二段技能壳超时(this: void, variable?: any): void {
  const 控制器 = variable as 限时二段技能壳控制器 | undefined;
  if (!结束技能壳(控制器, false) || 控制器 == null) return;
  if (控制器.超时回调 != null) 控制器.超时回调(控制器);
}

export function 创建限时二段技能壳(this: void, 参数: 限时二段技能壳参数): 限时二段技能壳控制器 | undefined {
  if (!单位有效(参数.单位) || 参数.一段技能ID === 0 || 参数.二段技能ID === 0 || 参数.持续秒 <= 0) return undefined;
  const owner = GetOwningPlayer(参数.单位);
  if (owner == null || owner === 0) return undefined;

  UnitRemoveAbility(参数.单位, 参数.二段技能ID);
  SetPlayerAbilityAvailable(owner, 参数.一段技能ID, false);
  if (!UnitAddAbility(参数.单位, 参数.二段技能ID)) {
    SetPlayerAbilityAvailable(owner, 参数.一段技能ID, true);
    return undefined;
  }
  SetPlayerAbilityAvailable(owner, 参数.二段技能ID, true);

  const 控制器: 限时二段技能壳控制器 = {
    名称: 参数.名称,
    单位: 参数.单位,
    一段技能ID: 参数.一段技能ID,
    二段技能ID: 参数.二段技能ID,
    超时回调ID: 0,
    已结束: false,
    数据: 参数.数据,
    超时回调: 参数.超时回调,
  };
  控制器.超时回调ID = addDelayedCallback(参数.持续秒 * 1000, 限时二段技能壳超时, 控制器);
  return 控制器;
}

export function 确认限时二段技能壳(this: void, 控制器: 限时二段技能壳控制器 | undefined): boolean {
  return 结束技能壳(控制器, true);
}

export function 清理限时二段技能壳(this: void, 控制器: 限时二段技能壳控制器 | undefined): boolean {
  return 结束技能壳(控制器, true);
}
