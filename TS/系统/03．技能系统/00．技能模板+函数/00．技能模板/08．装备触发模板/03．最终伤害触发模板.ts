/** @noSelfInFile */

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const jass = require("jass.common") as any;
const {
  单位持有装备,
  取装备冷却键,
  装备冷却中,
  进入装备冷却并显示,
  装备概率通过,
} = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.08．装备识别与冷却") as {
  单位持有装备: (this: void, unit: any, 装备名: string) => boolean;
  取装备冷却键: (this: void, unit: any, tag: string, 前缀?: string) => string;
  装备冷却中: (this: void, key: string) => boolean;
  进入装备冷却并显示: (this: void, key: string, 秒数: number, unit: any, 装备名: string) => void;
  装备概率通过: (this: void, unit: any, chance: number) => boolean;
};
const { 单位存活, 是技能伤害, 是纯普攻 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.09．装备战斗判断") as {
  单位存活: (this: void, unit: any) => boolean;
  是技能伤害: (this: void, snapshot: any) => boolean;
  是纯普攻: (this: void, snapshot: any) => boolean;
};

export type 最终伤害持有者 = "攻击者" | "受击者";
export type 最终伤害类型过滤 = "任意" | "技能" | "纯普攻";

export interface 最终伤害触发事件 {
  目标: any;
  攻击者: any;
  持有者: any;
  本次伤害: number;
  伤害快照: any;
  配置: 最终伤害触发参数;
}

export interface 最终伤害触发参数 {
  名称?: string;
  装备名: string;
  持有者?: 最终伤害持有者;
  伤害过滤?: 最终伤害类型过滤;
  概率?: number;
  冷却秒数?: number;
  冷却标签?: string;
  冷却前缀?: string;
  要求双方存活?: boolean;
  自定义过滤?: (this: void, event: 最终伤害触发事件) => boolean;
  on触发: (this: void, event: 最终伤害触发事件) => void;
  次数阈值?: number;
  触发后清空次数?: boolean;
}

export interface 最终伤害触发控制器 {
  readonly 名称: string;
  读取次数(this: void, 单位: any): number;
  清空(this: void, 单位?: any): void;
  停止(this: void): void;
}

interface 最终伤害触发记录 extends 最终伤害触发控制器 {
  ID: number;
  配置: 最终伤害触发参数;
  次数表: Record<number, number | undefined>;
  已停止: boolean;
}

const 最终伤害触发记录表: Record<number, 最终伤害触发记录 | undefined> = {};
let 最终伤害触发计数 = 0;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取持有者(this: void, target: any, attacker: any, config: 最终伤害触发参数): any {
  return (config.持有者 ?? "攻击者") === "受击者" ? target : attacker;
}

function 通过伤害类型过滤(this: void, snapshot: any, config: 最终伤害触发参数): boolean {
  const filter = config.伤害过滤 ?? "任意";
  if (filter === "技能") return 是技能伤害(snapshot);
  if (filter === "纯普攻") return 是纯普攻(snapshot);
  return true;
}

function 取冷却键(this: void, holder: any, record: 最终伤害触发记录): string {
  const tag = record.配置.冷却标签 ?? record.配置.名称 ?? record.配置.装备名;
  return 取装备冷却键(holder, tag, record.配置.冷却前缀 ?? "装备最终伤害触发");
}

function 冷却允许(this: void, holder: any, record: 最终伤害触发记录): boolean {
  const cd = record.配置.冷却秒数 ?? 0;
  if (!(cd > 0)) return true;
  const key = 取冷却键(holder, record);
  if (装备冷却中(key)) return false;
  return true;
}

function 记录冷却(this: void, holder: any, record: 最终伤害触发记录): void {
  const cd = record.配置.冷却秒数 ?? 0;
  if (!(cd > 0)) return;
  进入装备冷却并显示(取冷却键(holder, record), cd, holder, record.配置.装备名);
}

function 通过次数并记录(this: void, holder: any, record: 最终伤害触发记录): boolean {
  const threshold = record.配置.次数阈值 ?? 1;
  if (!(threshold > 1)) return true;
  const id = 取单位ID(holder);
  if (id === 0) return false;
  const next = (record.次数表[id] ?? 0) + 1;
  if (next < threshold) {
    record.次数表[id] = next;
    return false;
  }
  if (record.配置.触发后清空次数 !== false) {
    delete record.次数表[id];
  } else {
    record.次数表[id] = next;
  }
  return true;
}

function 尝试执行最终伤害触发(this: void, target: any, attacker: any, applied: number, snapshot: any, record: 最终伤害触发记录): void {
  if (record.已停止 || !(applied > 0)) return;
  const config = record.配置;
  const holder = 取持有者(target, attacker, config);
  if (holder == null || holder === 0) return;
  if (config.要求双方存活 !== false && (!单位存活(holder) || !单位存活((config.持有者 ?? "攻击者") === "受击者" ? attacker : target))) return;
  if (!单位持有装备(holder, config.装备名)) return;
  if (!通过伤害类型过滤(snapshot, config)) return;

  const event: 最终伤害触发事件 = { 目标: target, 攻击者: attacker, 持有者: holder, 本次伤害: applied, 伤害快照: snapshot, 配置: config };
  if (config.自定义过滤 != null && !config.自定义过滤(event)) return;
  const chance = config.概率 ?? 1;
  if (!装备概率通过(holder, chance)) return;
  if (!冷却允许(holder, record)) return;
  if (!通过次数并记录(holder, record)) return;
  记录冷却(holder, record);
  config.on触发(event);
}

function on最终伤害触发模板(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (const key in 最终伤害触发记录表) {
    const record = 最终伤害触发记录表[Number(key) || 0];
    if (record != null) 尝试执行最终伤害触发(target, attacker, applied, snapshot, record);
  }
}

registerAppliedFinalDamageListener(on最终伤害触发模板);

export function 注册最终伤害触发模板(this: void, 配置: 最终伤害触发参数): 最终伤害触发控制器 {
  const id = ++最终伤害触发计数;
  const record: 最终伤害触发记录 = {
    ID: id,
    名称: 配置.名称 ?? ("最终伤害触发#" + String(id)),
    配置,
    次数表: {},
    已停止: false,
    读取次数: function 读取最终伤害触发次数(this: void, 单位: any): number {
      return record.次数表[取单位ID(单位)] ?? 0;
    },
    清空: function 清空最终伤害触发次数(this: void, 单位?: any): void {
      if (单位 == null) {
        record.次数表 = {};
        return;
      }
      delete record.次数表[取单位ID(单位)];
    },
    停止: function 停止最终伤害触发(this: void): void {
      record.已停止 = true;
      record.次数表 = {};
      delete 最终伤害触发记录表[id];
    },
  };
  最终伤害触发记录表[id] = record;
  return record;
}

export {};
