/** @noSelfInFile */

const jass = require("jass.common") as any;
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const {
  技能伤害实例存在,
  是独立技能伤害快照,
  注册技能伤害实例结束监听,
} = require("系统.04．伤害系统.08．技能伤害系统") as {
  技能伤害实例存在: (this: void, id: number | undefined) => boolean;
  是独立技能伤害快照: (this: void, snapshot: any) => boolean;
  注册技能伤害实例结束监听: (this: void, cb: (this: void, id: number) => void) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

export type 独立技能命中来源过滤 = "任意非装备技能" | "单位技能" | "Boss技能" | "召唤物技能";
export type 独立技能命中目标过滤 = "敌方" | "任意";
export type 独立技能命中计数口径 = "技能实例" | "同目标";
export type 独立技能伤害形态过滤 = "任意" | "单体" | "AOE" | "未知";

export interface 独立技能命中事件 {
  施法者: any;
  目标: any;
  本次伤害: number;
  技能实例ID: number;
  技能ID?: number;
  来源类型?: string;
  标签?: string;
  伤害形态?: string;
  命中次数: number;
  同目标命中次数: number;
  是首次命中: boolean;
  是同目标首次命中: boolean;
  伤害快照: any;
  配置: 独立技能命中触发参数;
}

export interface 独立技能命中触发参数 {
  名称?: string;
  来源过滤?: 独立技能命中来源过滤;
  目标过滤?: 独立技能命中目标过滤;
  计数口径?: 独立技能命中计数口径;
  命中次数?: number;
  触发后清空计数?: boolean;
  每个技能实例最多触发次数?: number;
  技能ID?: number;
  标签?: string;
  伤害形态?: 独立技能伤害形态过滤;
  自定义过滤?: (this: void, event: 独立技能命中事件) => boolean;
  on命中: (this: void, event: 独立技能命中事件) => void;
}

export interface 独立技能首次命中参数 extends Omit<独立技能命中触发参数, "命中次数" | "on命中"> {
  on首次命中: (this: void, event: 独立技能命中事件) => void;
}

export interface 被独立技能命中事件 extends 独立技能命中事件 {
  受击者: any;
  攻击者: any;
}

export interface 被独立技能命中参数 extends Omit<独立技能命中触发参数, "自定义过滤" | "on命中"> {
  自定义过滤?: (this: void, event: 被独立技能命中事件) => boolean;
  on被命中: (this: void, event: 被独立技能命中事件) => void;
}

export interface 首次被独立技能命中参数 extends Omit<被独立技能命中参数, "命中次数" | "on被命中"> {
  on首次被命中: (this: void, event: 被独立技能命中事件) => void;
}

export interface 独立技能命中触发控制器 {
  readonly id: number;
  readonly 名称: string;
  读取命中次数(this: void, 技能实例ID: number, 目标?: any): number;
  清空(this: void, 技能实例ID?: number): void;
  停止(this: void): void;
}

interface 独立技能实例命中计数 {
  总命中次数: number;
  目标命中次数表: Record<number, number | undefined>;
  已触发次数: number;
}

interface 独立技能命中触发记录 extends 独立技能命中触发控制器 {
  配置: 独立技能命中触发参数;
  实例计数表: Record<number, 独立技能实例命中计数 | undefined>;
  已停止: boolean;
}

const 独立技能命中触发记录表: Record<number, 独立技能命中触发记录 | undefined> = {};
let 独立技能命中触发自增ID = 0;

function 单位有效存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 是敌方命中(this: void, attacker: any, target: any): boolean {
  if (!单位有效存活(attacker) || !单位有效存活(target)) return false;
  return IsUnitEnemy(target, GetOwningPlayer(attacker));
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取技能实例ID(this: void, snapshot: any): number {
  const id = Number(snapshot?.skillInstanceId) || 0;
  return id > 0 ? id : 0;
}

function 取阈值(this: void, config: 独立技能命中触发参数): number {
  const threshold = config.命中次数 ?? 1;
  return threshold > 1 ? threshold : 1;
}

function 取实例计数(this: void, record: 独立技能命中触发记录, instanceId: number): 独立技能实例命中计数 {
  let data = record.实例计数表[instanceId];
  if (data == null) {
    data = {
      总命中次数: 0,
      目标命中次数表: {},
      已触发次数: 0,
    };
    record.实例计数表[instanceId] = data;
  }
  return data;
}

function 通过来源过滤(this: void, snapshot: any, 来源过滤: 独立技能命中来源过滤 | undefined): boolean {
  if (!是独立技能伤害快照(snapshot)) return false;
  const sourceKind = snapshot.skillDamageSourceKind;
  const filter = 来源过滤 ?? "任意非装备技能";
  if (filter === "任意非装备技能") return sourceKind === "单位技能" || sourceKind === "Boss技能" || sourceKind === "召唤物技能";
  return sourceKind === filter;
}

function 通过形态过滤(this: void, snapshot: any, filter: 独立技能伤害形态过滤 | undefined): boolean {
  const shapeFilter = filter ?? "任意";
  if (shapeFilter === "任意") return true;
  return snapshot?.skillDamageShape === shapeFilter;
}

function 通过基础过滤(this: void, target: any, attacker: any, applied: number, snapshot: any, config: 独立技能命中触发参数): boolean {
  if (!(applied > 0)) return false;
  if (!通过来源过滤(snapshot, config.来源过滤)) return false;
  if (!技能伤害实例存在(取技能实例ID(snapshot))) return false;
  if ((config.目标过滤 ?? "敌方") === "敌方" && !是敌方命中(attacker, target)) return false;
  if (config.技能ID != null && snapshot.abilityId !== config.技能ID) return false;
  if (config.标签 != null && snapshot.skillDamageTag !== config.标签) return false;
  if (!通过形态过滤(snapshot, config.伤害形态)) return false;
  return true;
}

function 创建事件(
  this: void,
  target: any,
  attacker: any,
  applied: number,
  snapshot: any,
  record: 独立技能命中触发记录,
  totalCount: number,
  targetCount: number,
): 独立技能命中事件 {
  return {
    施法者: attacker,
    目标: target,
    本次伤害: applied,
    技能实例ID: 取技能实例ID(snapshot),
    技能ID: snapshot.abilityId,
    来源类型: snapshot.skillDamageSourceKind,
    标签: snapshot.skillDamageTag,
    伤害形态: snapshot.skillDamageShape,
    命中次数: totalCount,
    同目标命中次数: targetCount,
    是首次命中: totalCount === 1,
    是同目标首次命中: targetCount === 1,
    伤害快照: snapshot,
    配置: record.配置,
  };
}

function 创建被命中事件(this: void, event: 独立技能命中事件): 被独立技能命中事件 {
  const result = event as 被独立技能命中事件;
  result.受击者 = event.目标;
  result.攻击者 = event.施法者;
  return result;
}

function 应触发(this: void, event: 独立技能命中事件, data: 独立技能实例命中计数, record: 独立技能命中触发记录): boolean {
  const config = record.配置;
  const maxTimes = config.每个技能实例最多触发次数 ?? 0;
  if (maxTimes > 0 && data.已触发次数 >= maxTimes) return false;
  const threshold = 取阈值(config);
  if ((config.计数口径 ?? "技能实例") === "同目标") {
    return event.同目标命中次数 === threshold;
  }
  return event.命中次数 === threshold;
}

function 写入命中计数(this: void, data: 独立技能实例命中计数, targetId: number, totalCount: number, targetCount: number): void {
  data.总命中次数 = totalCount;
  if (targetId > 0) data.目标命中次数表[targetId] = targetCount;
}

function 触发后处理计数(this: void, data: 独立技能实例命中计数, targetId: number, record: 独立技能命中触发记录): void {
  data.已触发次数 = data.已触发次数 + 1;
  if (record.配置.触发后清空计数 !== true) return;
  if ((record.配置.计数口径 ?? "技能实例") === "同目标") {
    if (targetId > 0) delete data.目标命中次数表[targetId];
    return;
  }
  data.总命中次数 = 0;
  data.目标命中次数表 = {};
}

function 尝试执行独立技能命中触发(this: void, target: any, attacker: any, applied: number, snapshot: any, record: 独立技能命中触发记录): void {
  if (record.已停止 || !通过基础过滤(target, attacker, applied, snapshot, record.配置)) return;
  const instanceId = 取技能实例ID(snapshot);
  const targetId = 取单位ID(target);
  const data = 取实例计数(record, instanceId);
  const totalCount = data.总命中次数 + 1;
  const targetCount = targetId > 0 ? (data.目标命中次数表[targetId] ?? 0) + 1 : 0;
  const event = 创建事件(target, attacker, applied, snapshot, record, totalCount, targetCount);
  if (record.配置.自定义过滤 != null && !record.配置.自定义过滤(event)) return;
  if (!应触发(event, data, record)) {
    写入命中计数(data, targetId, totalCount, targetCount);
    return;
  }
  写入命中计数(data, targetId, totalCount, targetCount);
  record.配置.on命中(event);
  触发后处理计数(data, targetId, record);
}

function on独立技能命中最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (const key in 独立技能命中触发记录表) {
    const record = 独立技能命中触发记录表[Number(key) || 0];
    if (record != null) 尝试执行独立技能命中触发(target, attacker, applied, snapshot, record);
  }
}

function on独立技能实例结束(this: void, id: number): void {
  for (const key in 独立技能命中触发记录表) {
    const record = 独立技能命中触发记录表[Number(key) || 0];
    if (record != null) delete record.实例计数表[id];
  }
}

registerAppliedFinalDamageListener(on独立技能命中最终伤害);
注册技能伤害实例结束监听(on独立技能实例结束);

export function 注册独立技能命中模板(this: void, 配置: 独立技能命中触发参数): 独立技能命中触发控制器 {
  const id = ++独立技能命中触发自增ID;
  const record: 独立技能命中触发记录 = {
    id,
    名称: 配置.名称 ?? ("独立技能命中#" + String(id)),
    配置,
    实例计数表: {},
    已停止: false,
    读取命中次数: function 读取独立技能命中次数(this: void, 技能实例ID: number, 目标?: any): number {
      const data = record.实例计数表[技能实例ID];
      if (data == null) return 0;
      if (目标 != null) return data.目标命中次数表[取单位ID(目标)] ?? 0;
      return data.总命中次数;
    },
    清空: function 清空独立技能命中计数(this: void, 技能实例ID?: number): void {
      if (技能实例ID == null || 技能实例ID <= 0) {
        record.实例计数表 = {};
        return;
      }
      delete record.实例计数表[技能实例ID];
    },
    停止: function 停止独立技能命中模板(this: void): void {
      record.已停止 = true;
      record.实例计数表 = {};
      delete 独立技能命中触发记录表[id];
    },
  };
  独立技能命中触发记录表[id] = record;
  return record;
}

export function 注册独立技能首次命中模板(this: void, 配置: 独立技能首次命中参数): 独立技能命中触发控制器 {
  return 注册独立技能命中模板({
    ...配置,
    计数口径: "技能实例",
    命中次数: 1,
    on命中: 配置.on首次命中,
  });
}

export function 注册被独立技能命中模板(this: void, 配置: 被独立技能命中参数): 独立技能命中触发控制器 {
  return 注册独立技能命中模板({
    ...配置,
    自定义过滤: function 被独立技能命中自定义过滤(this: void, event: 独立技能命中事件): boolean {
      if (配置.自定义过滤 == null) return true;
      return 配置.自定义过滤(创建被命中事件(event));
    },
    on命中: function 被独立技能命中回调(this: void, event: 独立技能命中事件): void {
      配置.on被命中(创建被命中事件(event));
    },
  });
}

export function 注册首次被独立技能命中模板(this: void, 配置: 首次被独立技能命中参数): 独立技能命中触发控制器 {
  return 注册被独立技能命中模板({
    ...配置,
    计数口径: "同目标",
    命中次数: 1,
    on被命中: 配置.on首次被命中,
  });
}

export {};
