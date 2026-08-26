/** @noSelfInFile */
// 限时二段/多段技能壳：一段技能确认后临时加装多段能力，窗口超时或主动确认后恢复。
// 多段扩展：阶段列表、阶段窗口 token（旧超时回调不得关闭新窗口）、阶段数据/魔耗、死亡清理。

const jass = require("jass.common") as any;

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable as (this: void, player: any, abilityId: number, available: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (this: void, unit: any, abilityId: number) => boolean;
const UnitRemoveAbility = jass.UnitRemoveAbility as (this: void, unit: any, abilityId: number) => boolean;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const GetHandleIdSafe = jass.GetHandleId as (this: void, handle: any) => number;

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

// =============================================================================
// 多段技能壳扩展（M-02）
// =============================================================================

/** 多段技能阶段配置 */
export interface 多段技能阶段配置 {
  /** 该阶段技能 ID */
  技能ID: number;
  /** 该阶段窗口秒数 */
  窗口秒: number;
  /** 阶段数据（透传给阶段魔耗回调与超时回调） */
  数据?: any;
  /** 阶段魔耗：数值或回调（回调参数：单位、阶段数据，返回扣魔值） */
  阶段魔耗?: number | ((this: void, 单位: any, 阶段数据: any) => number);
}

export interface 多段技能壳控制器 {
  名称: string;
  单位: any;
  一段技能ID: number;
  阶段列表: 多段技能阶段配置[];
  /** 当前阶段索引（-1 = 未进入多段） */
  当前阶段: number;
  /** 窗口代次：每次进入一个阶段窗口自增，旧超时回调通过快照与激活表比对放弃 */
  token: number;
  窗口回调ID: number;
  已结束: boolean;
  数据?: any;
  窗口超时回调?: (this: void, 控制器: 多段技能壳控制器) => void;
}

export interface 开启多段技能窗口参数 {
  名称: string;
  单位: any;
  一段技能ID: number;
  阶段列表: 多段技能阶段配置[];
  数据?: any;
  窗口超时回调?: (this: void, 控制器: 多段技能壳控制器) => void;
}

/** 单位当前激活的多段壳（token 校验用，防旧回调关闭新窗口） */
const 多段激活表: Record<number, { token: number; 控制器: 多段技能壳控制器 } | undefined> = {};
let 多段token自增 = 0;
let 多段死亡监听已注册 = false;

interface 多段窗口回调变量 {
  控制器: 多段技能壳控制器;
  token: number;
}

function 单位有效多段(this: void, unit: any): boolean {
  return unit != null && unit !== 0;
}

/** 恢复一段可用并移除全部阶段技能能力 */
function 恢复多段技能壳(this: void, 控制器: 多段技能壳控制器): void {
  if (!单位有效多段(控制器.单位)) return;
  const owner = GetOwningPlayer(控制器.单位);
  for (let i = 0; i < 控制器.阶段列表.length; i++) {
    UnitRemoveAbility(控制器.单位, 控制器.阶段列表[i].技能ID);
    if (owner != null && owner !== 0) SetPlayerAbilityAvailable(owner, 控制器.阶段列表[i].技能ID, false);
  }
  if (owner != null && owner !== 0) SetPlayerAbilityAvailable(owner, 控制器.一段技能ID, true);
}

function 多段阶段配置有效(this: void, 阶段: 多段技能阶段配置 | undefined): boolean {
  return 阶段 != null && 阶段.技能ID !== 0 && 阶段.窗口秒 > 0;
}

function 删除多段激活记录(this: void, 控制器: 多段技能壳控制器): void {
  if (!单位有效多段(控制器.单位)) return;
  const id = GetHandleIdSafe(控制器.单位);
  const 激活 = 多段激活表[id];
  if (激活 != null && 激活.控制器 === 控制器) delete 多段激活表[id];
}

function 结束多段技能壳(this: void, 控制器: 多段技能壳控制器 | undefined, 取消计时: boolean): boolean {
  if (控制器 == null || 控制器.已结束) return false;
  控制器.已结束 = true;
  if (取消计时 && 控制器.窗口回调ID !== 0) removeDelayedCallback(控制器.窗口回调ID);
  控制器.窗口回调ID = 0;
  恢复多段技能壳(控制器);
  控制器.当前阶段 = -1;
  删除多段激活记录(控制器);
  return true;
}

function 开启多段阶段计时(this: void, 控制器: 多段技能壳控制器, 阶段: 多段技能阶段配置): void {
  const token = ++多段token自增;
  控制器.token = token;
  多段激活表[GetHandleIdSafe(控制器.单位)] = { token, 控制器 };
  const 回调变量: 多段窗口回调变量 = { 控制器, token };
  控制器.窗口回调ID = addDelayedCallback(阶段.窗口秒 * 1000, 多段技能壳窗口超时, 回调变量);
}

/** 加装第 index 个阶段技能能力（隐藏一段、启阶段技能） */
function 进入多段阶段(this: void, 控制器: 多段技能壳控制器, index: number): boolean {
  const 阶段 = 控制器.阶段列表[index];
  if (阶段 == null || 阶段.技能ID === 0) return false;
  const owner = GetOwningPlayer(控制器.单位);
  if (owner == null || owner === 0) return false;
  UnitRemoveAbility(控制器.单位, 阶段.技能ID);
  SetPlayerAbilityAvailable(owner, 控制器.一段技能ID, false);
  if (!UnitAddAbility(控制器.单位, 阶段.技能ID)) {
    SetPlayerAbilityAvailable(owner, 控制器.一段技能ID, true);
    return false;
  }
  SetPlayerAbilityAvailable(owner, 阶段.技能ID, true);
  控制器.当前阶段 = index;
  开启多段阶段计时(控制器, 阶段);
  return true;
}

function 读取阶段魔耗(this: void, 控制器: 多段技能壳控制器, 阶段: 多段技能阶段配置): number {
  const 魔耗 = typeof 阶段.阶段魔耗 === "function"
    ? (阶段.阶段魔耗 as (this: void, 单位: any, 阶段数据: any) => number)(控制器.单位, 阶段.数据)
    : (阶段.阶段魔耗 as number | undefined);
  return 魔耗 != null && 魔耗 > 0 ? 魔耗 : 0;
}

function 扣除阶段魔耗(this: void, 控制器: 多段技能壳控制器, 魔耗: number): void {
  if (!(魔耗 > 0)) return;
  const 当前魔法 = GetUnitState(控制器.单位, UNIT_STATE_MANA);
  SetUnitState(控制器.单位, UNIT_STATE_MANA, 当前魔法 - 魔耗);
}

function 多段技能壳窗口超时(this: void, variable?: any): void {
  const 回调变量 = variable as 多段窗口回调变量 | undefined;
  if (回调变量 == null) return;
  const 控制器 = 回调变量.控制器;
  if (控制器 == null || 控制器.已结束 || 回调变量.token !== 控制器.token) return;
  // token 快照校验：同一控制器的旧阶段窗口也不得关闭新阶段。
  if (单位有效多段(控制器.单位)) {
    const 激活 = 多段激活表[GetHandleIdSafe(控制器.单位)];
    if (激活 == null || 激活.控制器 !== 控制器 || 激活.token !== 回调变量.token) return;
  }
  结束多段技能壳(控制器, false);
  if (控制器.窗口超时回调 != null) 控制器.窗口超时回调(控制器);
}

function 多段技能壳死亡清理(this: void, dyingUnit: any, _killingUnit: any): void {
  if (!单位有效多段(dyingUnit)) return;
  const 激活 = 多段激活表[GetHandleIdSafe(dyingUnit)];
  if (激活 != null) 结束多段技能壳(激活.控制器, true);
}

/**
 * 开启多段技能窗口：一段技能确认后加装阶段列表首个能力，窗口超时自动复位。
 * 每次开启独立 token；同单位重复开启会先清理旧壳（旧超时回调不再生效）。
 */
export function 开启多段技能窗口(this: void, 参数: 开启多段技能窗口参数): 多段技能壳控制器 | undefined {
  if (!单位有效多段(参数.单位) || 参数.一段技能ID === 0 || 参数.阶段列表 == null || 参数.阶段列表.length <= 0) {
    return undefined;
  }
  for (let i = 0; i < 参数.阶段列表.length; i++) {
    if (!多段阶段配置有效(参数.阶段列表[i])) return undefined;
  }
  // 同单位已有激活壳：先清理（token 作废）
  const 旧激活 = 多段激活表[GetHandleIdSafe(参数.单位)];
  if (旧激活 != null) 结束多段技能壳(旧激活.控制器, true);

  const 控制器: 多段技能壳控制器 = {
    名称: 参数.名称,
    单位: 参数.单位,
    一段技能ID: 参数.一段技能ID,
    阶段列表: 参数.阶段列表,
    当前阶段: -1,
    token: 0,
    窗口回调ID: 0,
    已结束: false,
    数据: 参数.数据,
    窗口超时回调: 参数.窗口超时回调,
  };
  if (!进入多段阶段(控制器, 0)) {
    控制器.已结束 = true;
    恢复多段技能壳(控制器);
    return undefined;
  }

  if (!多段死亡监听已注册) {
    多段死亡监听已注册 = true;
    registerDeathListener(多段技能壳死亡清理);
  }
  return 控制器;
}

/** 确认当前阶段：扣魔（阶段魔耗）后进入下一阶段；已是最后阶段则结束整个多段壳。@returns true=成功确认；false=已结束/无效/加装下一阶段失败 */
export function 确认多段技能阶段(this: void, 控制器: 多段技能壳控制器 | undefined): boolean {
  if (控制器 == null || 控制器.已结束) return false;
  if (!单位有效多段(控制器.单位)) return false;
  const 阶段 = 控制器.阶段列表[控制器.当前阶段];
  if (!多段阶段配置有效(阶段)) return false;
  const 阶段魔耗 = 读取阶段魔耗(控制器, 阶段);
  if (阶段魔耗 > 0 && GetUnitState(控制器.单位, UNIT_STATE_MANA) < 阶段魔耗) return false;

  const 下一阶段 = 控制器.当前阶段 + 1;
  const owner = GetOwningPlayer(控制器.单位);
  if (owner == null || owner === 0) return false;

  // 先验证下一阶段确实能装载，失败时保留当前阶段，不扣魔、不破坏窗口。
  const 下一阶段配置 = 控制器.阶段列表[下一阶段];
  if (下一阶段 < 控制器.阶段列表.length) {
    if (!多段阶段配置有效(下一阶段配置)) return false;
    UnitRemoveAbility(控制器.单位, 下一阶段配置.技能ID);
    if (!UnitAddAbility(控制器.单位, 下一阶段配置.技能ID)) return false;
  }

  扣除阶段魔耗(控制器, 阶段魔耗);
  UnitRemoveAbility(控制器.单位, 阶段.技能ID);
  SetPlayerAbilityAvailable(owner, 阶段.技能ID, false);
  SetPlayerAbilityAvailable(owner, 控制器.一段技能ID, true);
  if (控制器.窗口回调ID !== 0) removeDelayedCallback(控制器.窗口回调ID);
  控制器.窗口回调ID = 0;

  if (下一阶段 >= 控制器.阶段列表.length) {
    // 最后阶段确认：沿统一收束路径恢复按钮、清除激活记录并复位阶段索引。
    return 结束多段技能壳(控制器, false);
  }
  SetPlayerAbilityAvailable(owner, 下一阶段配置!.技能ID, true);
  SetPlayerAbilityAvailable(owner, 控制器.一段技能ID, false);
  控制器.当前阶段 = 下一阶段;
  开启多段阶段计时(控制器, 下一阶段配置!);
  return true;
}

/** 主动清理多段技能壳（中断/收尾）：取消计时、移除全部阶段能力、恢复一段 */
export function 清理多段技能壳(this: void, 控制器: 多段技能壳控制器 | undefined): boolean {
  return 结束多段技能壳(控制器, true);
}

/** 读取多段壳当前阶段索引（-1=未进入） */
export function 读取多段当前阶段(this: void, 控制器: 多段技能壳控制器 | undefined): number {
  return 控制器 == null ? -1 : 控制器.当前阶段;
}
