/** @noSelfInFile */
/**
 * 00．仇恨存储
 *
 * 敌人视角的仇恨表。每个敌人维护一张仇恨表，同时存 HandleId 和单位引用。
 * removeTarget / clearAllThreat 自动联动清理当前目标缓存。
 */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;

export interface ThreatEntry {
  targetHid: number;
  targetRef: any;
  threat: number;
  lastUpdateTime: number;
}

const threatTables: Record<number, ThreatEntry[]> = {};
const 仇恨上限 = 1000;
const 长尾清理阈值 = 5;
export const 仇恨整表超时毫秒 = 10000;
export const 仇恨条目超时毫秒 = 10000;
export const 仇恨列表最大目标数 = 6;

/** 敌人 HandleId → 敌人单位引用（由 addThreat 自动维护） */
const enemyRefTable: Record<number, any | undefined> = {};
/** 敌人 HandleId → 最近一次收到伤害/更新仇恨的服务器时间（毫秒） */
const enemyLastThreatUpdateMs: Record<number, number | undefined> = {};

function 取单位ID(u: any): number {
  if (u == null || u === 0) return 0;
  return GetHandleId(u) || 0;
}

let _清除当前目标: ((敌人ID: number, 目标ID: number) => void) | null = null;

function 限制仇恨值(value: number): number {
  if (value <= 0) return 0;
  if (value >= 仇恨上限) return 仇恨上限;
  return value;
}

function 获取总仇恨值(list: ThreatEntry[] | undefined): number {
  if (list == null || list.length === 0) return 0;
  let total = 0;
  for (let i = 0; i < list.length; i++) {
    total += list[i].threat;
  }
  return total;
}

function 清理长尾仇恨(list: ThreatEntry[] | undefined): void {
  if (list == null || list.length <= 2) return;
  for (let i = list.length - 1; i >= 0; i--) {
    if (list[i].threat < 长尾清理阈值) {
      list.splice(i, 1);
    }
  }
}

function 按总池上限重分配(list: ThreatEntry[] | undefined): void {
  if (list == null || list.length === 0) return;
  if (list.length < 2) return;
  const 当前总仇恨 = 获取总仇恨值(list);
  if (当前总仇恨 <= 0 || 当前总仇恨 <= 仇恨上限) return;

  const 缩放比例 = 仇恨上限 / 当前总仇恨;
  for (let i = 0; i < list.length; i++) {
    list[i].threat = 限制仇恨值(list[i].threat * 缩放比例);
  }

  清理长尾仇恨(list);
}

function 触发当前目标清除(敌人ID: number, 目标ID: number): void {
  if (_清除当前目标 != null) _清除当前目标(敌人ID, 目标ID);
}

function 移除条目并联动(list: ThreatEntry[], 敌人ID: number, index: number): void {
  const entry = list[index];
  if (entry == null) return;
  const 目标ID = entry.targetHid;
  list.splice(index, 1);
  触发当前目标清除(敌人ID, 目标ID);
}

function 维持列表上限(list: ThreatEntry[] | undefined, 敌人ID: number): void {
  if (list == null) return;
  while (list.length > 仇恨列表最大目标数) {
    let 最小索引 = 0;
    for (let i = 1; i < list.length; i++) {
      if (list[i].threat < list[最小索引].threat) {
        最小索引 = i;
      }
    }
    移除条目并联动(list, 敌人ID, 最小索引);
  }
}

function 清理过期条目(list: ThreatEntry[] | undefined, 敌人ID: number, 当前时间: number): void {
  if (list == null || list.length === 0) return;
  for (let i = list.length - 1; i >= 0; i--) {
    if (当前时间 - list[i].lastUpdateTime >= 仇恨条目超时毫秒) {
      移除条目并联动(list, 敌人ID, i);
    }
  }
}

function 清理列表并重分配(敌人ID: number, list: ThreatEntry[] | undefined, 当前时间: number): void {
  if (list == null) return;
  清理过期条目(list, 敌人ID, 当前时间);
  if (list.length === 0) {
    delete threatTables[敌人ID];
    delete enemyRefTable[敌人ID];
    delete enemyLastThreatUpdateMs[敌人ID];
    return;
  }

  维持列表上限(list, 敌人ID);
  if (list.length === 0) {
    delete threatTables[敌人ID];
    delete enemyRefTable[敌人ID];
    delete enemyLastThreatUpdateMs[敌人ID];
    return;
  }

  按总池上限重分配(list);
  if (list.length === 0) {
    delete threatTables[敌人ID];
    delete enemyRefTable[敌人ID];
    delete enemyLastThreatUpdateMs[敌人ID];
  }
}

/** 由 02．目标选择 注册清除回调，实现联动。回调参数：(敌人ID, 目标ID)，目标ID=0表示全部清除。 */
export function 注册当前目标清除回调(fn: (敌人ID: number, 目标ID: number) => void): void {
  _清除当前目标 = fn;
}

/** 增加仇恨（累加），同时维护敌人引用表 */
export function addThreat(敌人: any, 仇恨目标: any, 数值: number): void {
  const 敌人ID = 取单位ID(敌人);
  const 目标ID = 取单位ID(仇恨目标);
  if (敌人ID === 0 || 目标ID === 0) return;
  if (数值 <= 0) return;
  const 当前时间 = nowMs();

  enemyRefTable[敌人ID] = 敌人;
  enemyLastThreatUpdateMs[敌人ID] = 当前时间;

  let list = threatTables[敌人ID];
  if (list == null) {
    list = [];
    threatTables[敌人ID] = list;
  }

  清理列表并重分配(敌人ID, list, 当前时间);
  list = threatTables[敌人ID];
  if (list == null) {
    list = [];
    threatTables[敌人ID] = list;
  }

  for (let i = 0; i < list.length; i++) {
    if (list[i].targetHid === 目标ID) {
      list[i].threat = 限制仇恨值(list[i].threat + 数值);
      list[i].targetRef = 仇恨目标;
      list[i].lastUpdateTime = 当前时间;
      清理列表并重分配(敌人ID, list, 当前时间);
      return;
    }
  }

  const 新条目仇恨 = 限制仇恨值(数值);
  if (新条目仇恨 <= 0) return;
  list.push({ targetHid: 目标ID, targetRef: 仇恨目标, threat: 新条目仇恨, lastUpdateTime: 当前时间 });
  清理列表并重分配(敌人ID, list, 当前时间);
}

/** 设置仇恨（覆盖），同时维护敌人引用表 */
export function setThreat(敌人: any, 仇恨目标: any, 数值: number): void {
  const 敌人ID = 取单位ID(敌人);
  const 目标ID = 取单位ID(仇恨目标);
  if (敌人ID === 0 || 目标ID === 0) return;
  const 当前时间 = nowMs();

  enemyRefTable[敌人ID] = 敌人;
  enemyLastThreatUpdateMs[敌人ID] = 当前时间;

  let list = threatTables[敌人ID];
  if (list == null) {
    list = [];
    threatTables[敌人ID] = list;
  }

  清理列表并重分配(敌人ID, list, 当前时间);
  list = threatTables[敌人ID];
  if (list == null) {
    list = [];
    threatTables[敌人ID] = list;
  }

  for (let i = 0; i < list.length; i++) {
    if (list[i].targetHid === 目标ID) {
      list[i].threat = 限制仇恨值(数值);
      list[i].targetRef = 仇恨目标;
      list[i].lastUpdateTime = 当前时间;
      清理列表并重分配(敌人ID, list, 当前时间);
      return;
    }
  }

  const 新条目仇恨 = 限制仇恨值(数值);
  if (新条目仇恨 <= 0) return;
  list.push({ targetHid: 目标ID, targetRef: 仇恨目标, threat: 新条目仇恨, lastUpdateTime: 当前时间 });
  清理列表并重分配(敌人ID, list, 当前时间);
}

/** 获取对某个目标的仇恨值（按 HandleId） */
export function getThreatByHid(敌人: any, 目标ID: number): number {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0 || 目标ID === 0) return 0;

  const list = threatTables[敌人ID];
  if (list == null) return 0;

  for (let i = 0; i < list.length; i++) {
    if (list[i].targetHid === 目标ID) return list[i].threat;
  }

  return 0;
}
export function getThreat(敌人: any, 仇恨目标: any): number {
  const 敌人ID = 取单位ID(敌人);
  const 目标ID = 取单位ID(仇恨目标);
  if (敌人ID === 0 || 目标ID === 0) return 0;

  const list = threatTables[敌人ID];
  if (list == null) return 0;

  for (let i = 0; i < list.length; i++) {
    if (list[i].targetHid === 目标ID) return list[i].threat;
  }

  return 0;
}

/** 获取最高仇恨的目标（传递 filter 过滤 targetRef，返回的 entry 含 targetRef） */
export function getHighestThreat(敌人: any, filter?: (entry: ThreatEntry) => boolean): ThreatEntry | null {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return null;

  const list = threatTables[敌人ID];
  if (list == null || list.length === 0) return null;

  let best: ThreatEntry | null = null;
  for (let i = 0; i < list.length; i++) {
    if (filter != null && !filter(list[i])) continue;
    if (best == null || list[i].threat > best.threat) {
      best = list[i];
    }
  }

  return best;
}

/** 移除某个目标。仅当被移除目标正好是当前目标时才触达清除回调。 */
export function removeTarget(敌人: any, 仇恨目标: any): void {
  const 敌人ID = 取单位ID(敌人);
  const 目标ID = 取单位ID(仇恨目标);
  if (敌人ID === 0 || 目标ID === 0) return;

  const list = threatTables[敌人ID];
  if (list == null) return;

  for (let i = 0; i < list.length; i++) {
    if (list[i].targetHid === 目标ID) {
      移除条目并联动(list, 敌人ID, i);
      if (list.length === 0) {
        delete threatTables[敌人ID];
        delete enemyRefTable[敌人ID];
        delete enemyLastThreatUpdateMs[敌人ID];
      }
      return;
    }
  }
}

/** 清空某个敌人的所有仇恨（联动清理当前目标缓存，目标ID传0表示全部清除） */
export function clearAllThreat(敌人: any): void {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return;
  delete threatTables[敌人ID];
  delete enemyRefTable[敌人ID];
  delete enemyLastThreatUpdateMs[敌人ID];
  if (_清除当前目标 != null) _清除当前目标(敌人ID, 0);
}

/** 无条件按 ID 清空（用于敌人引用丢失的场景） */
export function clearAllThreatById(敌人ID: number): void {
  if (敌人ID === 0) return;
  delete threatTables[敌人ID];
  delete enemyRefTable[敌人ID];
  delete enemyLastThreatUpdateMs[敌人ID];
  if (_清除当前目标 != null) _清除当前目标(敌人ID, 0);
}

/** 该敌人是否有仇恨记录 */
export function isEnemyTracked(敌人: any): boolean {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return false;
  return threatTables[敌人ID] != null;
}

/** 仇恨表中的目标数量 */
export function getEnemyThreatCount(敌人: any): number {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return 0;
  const list = threatTables[敌人ID];
  return list == null ? 0 : list.length;
}

/** 获取该敌人所有仇恨目标的只读快照 */
export function getEnemyThreats(敌人: any): ThreatEntry[] {
  const 敌人ID = 取单位ID(敌人);
  if (敌人ID === 0) return [];

  const list = threatTables[敌人ID];
  if (list == null) return [];

  const result: ThreatEntry[] = [];
  for (let i = 0; i < list.length; i++) {
    result.push(list[i]);
  }
  return result;
}

/** 获取所有有仇恨记录的敌人 ID（稳定数组） */
export function getAllTrackedEnemyIds(): number[] {
  const keys = Object.keys(threatTables);
  const result: number[] = [];
  for (let i = 0; i < keys.length; i++) {
    const id = parseInt(keys[i], 10);
    if (!isNaN(id)) result.push(id);
  }
  return result;
}

/** 按 ID 取敌人仇恨表是否还有记录（驱动层用） */
export function hasThreatTable(敌人ID: number): boolean {
  return threatTables[敌人ID] != null;
}

/** 从敌人引用表获取敌人单位引用 */
export function getEnemyRef(敌人ID: number): any | null {
  return enemyRefTable[敌人ID] ?? null;
}

/** 获取最近一次收到伤害/更新仇恨的服务器时间（毫秒） */
export function getEnemyLastThreatUpdateTimeById(敌人ID: number): number {
  return enemyLastThreatUpdateMs[敌人ID] ?? 0;
}

export function 清理敌人过期仇恨条目ById(敌人ID: number): void {
  if (敌人ID === 0) return;
  const list = threatTables[敌人ID];
  if (list == null) return;
  清理列表并重分配(敌人ID, list, nowMs());
}

// 中心计时器 nowMs（懒加载）
let _nowMs: (() => number) | null = null;
function nowMs(): number {
  if (_nowMs == null) {
    _nowMs = require("系统.00．核心系统.05．中心计时器").getServerTime as () => number;
  }
  return _nowMs();
}

export {};
